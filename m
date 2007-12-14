Return-Path: <linux-kernel-owner+w=401wt.eu-S934581AbXLNRHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934581AbXLNRHT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 12:07:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754843AbXLNRHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 12:07:06 -0500
Received: from mga03.intel.com ([143.182.124.21]:13723 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228AbXLNRHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 12:07:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,168,1196668800"; 
   d="scan'208";a="341238975"
Date: Fri, 14 Dec 2007 18:05:31 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: ak@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com,
       suresh.b.siddha@intel.com, roland@redhat.com, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: [patch 4/5] x86, ptrace: new ptrace BTS API
Message-ID: <20071214180531.A20647@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the new ptrace BTS API that supports two different overflow handling mechanisms (wrap-around and buffer-full-signal) to support two different use cases (debugging and profiling).

It further combines buffer allocation and configuration.


Opens:
- memory rlimit
- overflow signal

What would be the right signal to use?


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: linux-2.6-x86/arch/x86/kernel/ds.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/ds.c	2007-12-14 15:31:48.%N +0100
+++ linux-2.6-x86/arch/x86/kernel/ds.c	2007-12-14 15:31:48.%N +0100
@@ -177,18 +177,20 @@
 }
 
 
-int ds_allocate(void **dsp, size_t bts_size_in_records)
+int ds_allocate(void **dsp, size_t bts_size_in_bytes)
 {
-	size_t bts_size_in_bytes = 0;
-	void *bts = 0;
-	void *ds = 0;
+	size_t bts_size_in_records;
+	void *bts;
+	void *ds;
 
 	if (!ds_cfg.sizeof_ds || !ds_cfg.sizeof_bts)
 		return -EOPNOTSUPP;
 
-	if (bts_size_in_records < 0)
+	if (bts_size_in_bytes < 0)
 		return -EINVAL;
 
+	bts_size_in_records =
+		bts_size_in_bytes / ds_cfg.sizeof_bts;
 	bts_size_in_bytes =
 		bts_size_in_records * ds_cfg.sizeof_bts;
 
@@ -233,9 +235,21 @@
 	if (!ds_cfg.sizeof_ds || !ds_cfg.sizeof_bts)
 		return -EOPNOTSUPP;
 
+	if (!ds)
+		return 0;
+
 	size_in_bytes =
 		get_bts_absolute_maximum(ds) -
 		get_bts_buffer_base(ds);
+	return size_in_bytes;
+}
+
+int ds_get_bts_end(void *ds)
+{
+	size_t size_in_bytes = ds_get_bts_size(ds);
+
+	if (size_in_bytes <= 0)
+		return size_in_bytes;
 
 	return size_in_bytes / ds_cfg.sizeof_bts;
 }
@@ -254,6 +268,38 @@
 	return index_offset_in_bytes / ds_cfg.sizeof_bts;
 }
 
+int ds_set_overflow(void *ds, int method)
+{
+	switch (method) {
+	case DS_O_SIGNAL:
+		return -EOPNOTSUPP;
+	case DS_O_WRAP:
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+int ds_get_overflow(void *ds)
+{
+	return DS_O_WRAP;
+}
+
+int ds_clear(void *ds)
+{
+	int bts_size = ds_get_bts_size(ds);
+	void *bts_base;
+
+	if (bts_size <= 0)
+		return bts_size;
+
+	bts_base = get_bts_buffer_base(ds);
+	memset(bts_base, 0, bts_size);
+
+	set_bts_index(ds, bts_base);
+	return 0;
+}
+
 int ds_read_bts(void *ds, size_t index, struct bts_struct *out)
 {
 	void *bts;
Index: linux-2.6-x86/arch/x86/kernel/ptrace.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/ptrace.c	2007-12-14 15:31:48.%N +0100
+++ linux-2.6-x86/arch/x86/kernel/ptrace.c	2007-12-14 17:32:40.%N +0100
@@ -33,12 +33,6 @@
 
 
 /*
- * The maximal size of a BTS buffer per traced task in number of BTS
- * records.
- */
-#define PTRACE_BTS_BUFFER_MAX 4000
-
-/*
  * does not yet catch signals sent when the child dies.
  * in exit.c or in signal.c.
  */
@@ -466,17 +460,12 @@
 	return 0;
 }
 
-static int ptrace_bts_max_buffer_size(void)
-{
-	return PTRACE_BTS_BUFFER_MAX;
-}
-
-static int ptrace_bts_get_buffer_size(struct task_struct *child)
+static int ptrace_bts_get_size(struct task_struct *child)
 {
 	if (!child->thread.ds_area_msr)
 		return -ENXIO;
 
-	return ds_get_bts_size((void *)child->thread.ds_area_msr);
+	return ds_get_bts_index((void *)child->thread.ds_area_msr);
 }
 
 static int ptrace_bts_read_record(struct task_struct *child,
@@ -485,7 +474,7 @@
 {
 	struct bts_struct ret;
 	int retval;
-	int bts_size;
+	int bts_end;
 	int bts_index;
 
 	if (!child->thread.ds_area_msr)
@@ -494,15 +483,15 @@
 	if (index < 0)
 		return -EINVAL;
 
-	bts_size = ds_get_bts_size((void *)child->thread.ds_area_msr);
-	if (bts_size <= index)
+	bts_end = ds_get_bts_end((void *)child->thread.ds_area_msr);
+	if (bts_end <= index)
 		return -EINVAL;
 
 	/* translate the ptrace bts index into the ds bts index */
 	bts_index = ds_get_bts_index((void *)child->thread.ds_area_msr);
 	bts_index -= (index + 1);
 	if (bts_index < 0)
-		bts_index += bts_size;
+		bts_index += bts_end;
 
 	retval = ds_read_bts((void *)child->thread.ds_area_msr,
 			     bts_index, &ret);
@@ -530,19 +519,97 @@
 	return sizeof(*in);
 }
 
-static int ptrace_bts_config(struct task_struct *child,
-			     unsigned long options)
+static int ptrace_bts_clear(struct task_struct *child)
 {
-	unsigned long debugctl_mask = ds_debugctl_mask();
-	int retval;
+	if (!child->thread.ds_area_msr)
+		return -ENXIO;
 
-	retval = ptrace_bts_get_buffer_size(child);
-	if (retval < 0)
-		return retval;
-	if (retval == 0)
+	return ds_clear((void *)child->thread.ds_area_msr);
+}
+
+static int ptrace_bts_drain(struct task_struct *child,
+			    struct bts_struct __user *out)
+{
+	int end, i;
+	void *ds = (void *)child->thread.ds_area_msr;
+
+	if (!ds)
 		return -ENXIO;
 
-	if (options & PTRACE_BTS_O_TRACE_TASK) {
+	end = ds_get_bts_index(ds);
+	if (end <= 0)
+		return end;
+
+	for (i = 0; i < end; i++, out++) {
+		struct bts_struct ret;
+		int retval;
+
+		retval = ds_read_bts(ds, i, &ret);
+		if (retval < 0)
+			return retval;
+
+		if (copy_to_user(out, &ret, sizeof(ret)))
+			return -EFAULT;
+	}
+
+	ds_clear(ds);
+
+	return i;
+}
+
+static int ptrace_bts_config(struct task_struct *child,
+			     const struct ptrace_bts_config __user *ucfg)
+{
+	struct ptrace_bts_config cfg;
+	unsigned long debugctl_mask;
+	int bts_size, ret;
+	void *ds;
+
+	if (copy_from_user(&cfg, ucfg, sizeof(cfg)))
+		return -EFAULT;
+
+	bts_size = 0;
+	ds = (void *)child->thread.ds_area_msr;
+	if (ds) {
+		bts_size = ds_get_bts_size(ds);
+		if (bts_size < 0)
+			return bts_size;
+	}
+
+	if (bts_size != cfg.size) {
+		ret = ds_free((void **)&child->thread.ds_area_msr);
+		if (ret < 0)
+			return ret;
+
+		if (cfg.size > 0)
+			ret = ds_allocate((void **)&child->thread.ds_area_msr,
+					  cfg.size);
+		ds = (void *)child->thread.ds_area_msr;
+		if (ds)
+			set_tsk_thread_flag(child, TIF_DS_AREA_MSR);
+		else
+			clear_tsk_thread_flag(child, TIF_DS_AREA_MSR);
+
+		if (ret < 0)
+			return ret;
+
+		bts_size = ds_get_bts_size(ds);
+		if (bts_size <= 0)
+			return bts_size;
+	}
+
+	if (ds) {
+		if (cfg.flags & PTRACE_BTS_O_SIGNAL) {
+			ret = ds_set_overflow(ds, DS_O_SIGNAL);
+		} else {
+			ret = ds_set_overflow(ds, DS_O_WRAP);
+		}
+		if (ret < 0)
+			return ret;
+	}
+
+	debugctl_mask = ds_debugctl_mask();
+	if (ds && (cfg.flags & PTRACE_BTS_O_TRACE)) {
 		child->thread.debugctlmsr |= debugctl_mask;
 		set_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
 	} else {
@@ -555,7 +622,7 @@
 			clear_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
 	}
 
-	if (options & PTRACE_BTS_O_TIMESTAMPS)
+	if (ds && (cfg.flags & PTRACE_BTS_O_SCHED))
 		set_tsk_thread_flag(child, TIF_BTS_TRACE_TS);
 	else
 		clear_tsk_thread_flag(child, TIF_BTS_TRACE_TS);
@@ -563,59 +630,32 @@
 	return 0;
 }
 
-static int ptrace_bts_status(struct task_struct *child)
+static int ptrace_bts_status(struct task_struct *child,
+			     struct ptrace_bts_config __user *ucfg)
 {
-	unsigned long debugctl_mask = ds_debugctl_mask();
-	int retval, status = 0;
+	void *ds = (void *)child->thread.ds_area_msr;
+	struct ptrace_bts_config cfg;
 
-	retval = ptrace_bts_get_buffer_size(child);
-	if (retval < 0)
-		return retval;
-	if (retval == 0)
-		return -ENXIO;
+	memset(&cfg, 0, sizeof(cfg));
 
-	if (ptrace_bts_get_buffer_size(child) <= 0)
-		return -ENXIO;
+	if (ds) {
+		cfg.size = ds_get_bts_size(ds);
 
-	if (test_tsk_thread_flag(child, TIF_DEBUGCTLMSR) &&
-	    child->thread.debugctlmsr & debugctl_mask)
-		status |= PTRACE_BTS_O_TRACE_TASK;
-	if (test_tsk_thread_flag(child, TIF_BTS_TRACE_TS))
-		status |= PTRACE_BTS_O_TIMESTAMPS;
+		if (ds_get_overflow(ds) == DS_O_SIGNAL)
+			cfg.flags |= PTRACE_BTS_O_SIGNAL;
 
-	return status;
-}
+		if (test_tsk_thread_flag(child, TIF_DEBUGCTLMSR) &&
+		    child->thread.debugctlmsr & ds_debugctl_mask())
+			cfg.flags |= PTRACE_BTS_O_TRACE;
 
-static int ptrace_bts_allocate_bts(struct task_struct *child,
-				   int size_in_records)
-{
-	int retval = 0;
-	void *ds;
-
-	if (size_in_records < 0)
-		return -EINVAL;
-
-	if (size_in_records > ptrace_bts_max_buffer_size())
-		return -EINVAL;
-
-	if (size_in_records == 0) {
-		ptrace_bts_config(child, /* options = */ 0);
-	} else {
-		retval = ds_allocate(&ds, size_in_records);
-		if (retval)
-			return retval;
+		if (test_tsk_thread_flag(child, TIF_BTS_TRACE_TS))
+			cfg.flags |= PTRACE_BTS_O_SCHED;
 	}
 
-	if (child->thread.ds_area_msr)
-		ds_free((void **)&child->thread.ds_area_msr);
-
-	child->thread.ds_area_msr = (unsigned long)ds;
-	if (child->thread.ds_area_msr)
-		set_tsk_thread_flag(child, TIF_DS_AREA_MSR);
-	else
-		clear_tsk_thread_flag(child, TIF_DS_AREA_MSR);
+	if (copy_to_user(ucfg, &cfg, sizeof(cfg)))
+		return -EFAULT;
 
-	return retval;
+	return sizeof(cfg);
 }
 
 void ptrace_bts_take_timestamp(struct task_struct *tsk,
@@ -626,9 +666,6 @@
 		.variant.jiffies = jiffies
 	};
 
-	if (ptrace_bts_get_buffer_size(tsk) <= 0)
-		return;
-
 	ptrace_bts_write_record(tsk, &rec);
 }
 
@@ -808,30 +845,32 @@
 		break;
 #endif
 
-	case PTRACE_BTS_MAX_BUFFER_SIZE:
-		ret = ptrace_bts_max_buffer_size();
+	case PTRACE_BTS_CONFIG:
+		ret = ptrace_bts_config
+			(child, (struct ptrace_bts_config __user *)addr);
 		break;
 
-	case PTRACE_BTS_ALLOCATE_BUFFER:
-		ret = ptrace_bts_allocate_bts(child, data);
+	case PTRACE_BTS_STATUS:
+		ret = ptrace_bts_status
+			(child, (struct ptrace_bts_config __user *)addr);
 		break;
 
-	case PTRACE_BTS_GET_BUFFER_SIZE:
-		ret = ptrace_bts_get_buffer_size(child);
+	case PTRACE_BTS_SIZE:
+		ret = ptrace_bts_get_size(child);
 		break;
 
-	case PTRACE_BTS_READ_RECORD:
+	case PTRACE_BTS_GET:
 		ret = ptrace_bts_read_record
-			(child, data,
-			 (struct bts_struct __user *) addr);
+			(child, data, (struct bts_struct __user *) addr);
 		break;
 
-	case PTRACE_BTS_CONFIG:
-		ret = ptrace_bts_config(child, data);
+	case PTRACE_BTS_CLEAR:
+		ret = ptrace_bts_clear(child);
 		break;
 
-	case PTRACE_BTS_STATUS:
-		ret = ptrace_bts_status(child);
+	case PTRACE_BTS_DRAIN:
+		ret = ptrace_bts_drain
+			(child, (struct bts_struct __user *) addr);
 		break;
 
 	default:
@@ -1017,12 +1056,12 @@
 	case PTRACE_SETOPTIONS:
 	case PTRACE_SET_THREAD_AREA:
 	case PTRACE_GET_THREAD_AREA:
-	case PTRACE_BTS_MAX_BUFFER_SIZE:
-	case PTRACE_BTS_ALLOCATE_BUFFER:
-	case PTRACE_BTS_GET_BUFFER_SIZE:
-	case PTRACE_BTS_READ_RECORD:
 	case PTRACE_BTS_CONFIG:
 	case PTRACE_BTS_STATUS:
+	case PTRACE_BTS_SIZE:
+	case PTRACE_BTS_GET:
+	case PTRACE_BTS_CLEAR:
+	case PTRACE_BTS_DRAIN:
 		return sys_ptrace(request, pid, addr, data);
 
 	default:
Index: linux-2.6-x86/include/asm-x86/ds.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/ds.h	2007-12-14 15:31:48.%N +0100
+++ linux-2.6-x86/include/asm-x86/ds.h	2007-12-14 15:31:48.%N +0100
@@ -52,11 +52,18 @@
 	} variant;
 };
 
+/* Overflow handling mechanisms */
+#define DS_O_SIGNAL	1 /* send overflow signal */
+#define DS_O_WRAP	2 /* wrap around */
 
 extern int ds_allocate(void **, size_t);
 extern int ds_free(void **);
 extern int ds_get_bts_size(void *);
+extern int ds_get_bts_end(void *);
 extern int ds_get_bts_index(void *);
+extern int ds_set_overflow(void *, int);
+extern int ds_get_overflow(void *);
+extern int ds_clear(void *);
 extern int ds_read_bts(void *, size_t, struct bts_struct *);
 extern int ds_write_bts(void *, const struct bts_struct *);
 extern unsigned long ds_debugctl_mask(void);
Index: linux-2.6-x86/include/asm-x86/ptrace-abi.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/ptrace-abi.h	2007-12-14 15:31:48.%N +0100
+++ linux-2.6-x86/include/asm-x86/ptrace-abi.h	2007-12-14 15:31:48.%N +0100
@@ -80,51 +80,53 @@
 
 #define PTRACE_SINGLEBLOCK	33	/* resume execution until next branch */
 
-/* Return maximal BTS buffer size in number of records,
-   if successuf; -1, otherwise.
-   EOPNOTSUPP...processor does not support bts tracing */
-#define PTRACE_BTS_MAX_BUFFER_SIZE 40
-
-/* Allocate new bts buffer (free old one, if exists) of size DATA bts records;
-   parameter ADDR is ignored.
-   Return 0, if successful; -1, otherwise.
-   EOPNOTSUPP...processor does not support bts tracing
-   EINVAL.......invalid size in records
-   ENOMEM.......out of memory */
-#define PTRACE_BTS_ALLOCATE_BUFFER 41
-
-/* Return the size of the bts buffer in number of bts records,
-   if successful; -1, otherwise.
-   EOPNOTSUPP...processor does not support bts tracing
-   ENXIO........no buffer allocated */
-#define PTRACE_BTS_GET_BUFFER_SIZE 42
-
-/* Read the DATA'th bts record into a ptrace_bts_record buffer
-   provided in ADDR.
-   Records are ordered from newest to oldest.
-   Return 0, if successful; -1, otherwise
-   EOPNOTSUPP...processor does not support bts tracing
-   ENXIO........no buffer allocated
-   EINVAL.......invalid index */
-#define PTRACE_BTS_READ_RECORD 43
-
-/* Configure last branch trace; the configuration is given as a bit-mask of
-   PTRACE_BTS_O_* options in DATA; parameter ADDR is ignored.
-   Return 0, if successful; -1, otherwise
-   EOPNOTSUPP...processor does not support bts tracing
-   ENXIO........no buffer allocated */
-#define PTRACE_BTS_CONFIG 44
-
-/* Return the configuration as bit-mask of PTRACE_BTS_O_* options
-   if successful; -1, otherwise.
-   EOPNOTSUPP...processor does not support bts tracing
-   ENXIO........no buffer allocated */
-#define PTRACE_BTS_STATUS 45
-
-/* Trace configuration options */
-/* Collect last branch trace */
-#define PTRACE_BTS_O_TRACE_TASK 0x1
-/* Take timestamps when the task arrives and departs */
-#define PTRACE_BTS_O_TIMESTAMPS 0x2
+/* configuration/status structure used in PTRACE_BTS_CONFIG and
+   PTRACE_BTS_STATUS commands.
+*/
+struct ptrace_bts_config {
+	/* requested or actual size of BTS buffer in bytes */
+	unsigned long size;
+	/* bitmask of below flags */
+	unsigned long flags;
+};
+
+#define PTRACE_BTS_O_TRACE	0x1 /* branch trace */
+#define PTRACE_BTS_O_SCHED	0x2 /* scheduling events w/ jiffies */
+#define PTRACE_BTS_O_SIGNAL     0x4 /* send SIG? on buffer overflow
+				       instead of wrapping around */
+#define PTRACE_BTS_O_CUT_SIZE	0x8 /* cut requested size to max available
+				       instead of failing */
+
+#define PTRACE_BTS_CONFIG	40
+/* Configure branch trace recording.
+   DATA is ignored, ADDR points to a struct ptrace_bts_config.
+   A new buffer is allocated, iff the size changes.
+*/
+#define PTRACE_BTS_STATUS	41
+/* Return the current configuration.
+   DATA is ignored, ADDR points to a struct ptrace_bts_config
+   that will contain the result.
+*/
+#define PTRACE_BTS_SIZE		42
+/* Return the number of available BTS records.
+   DATA and ADDR are ignored.
+*/
+#define PTRACE_BTS_GET		43
+/* Get a single BTS record.
+   DATA defines the index into the BTS array, where 0 is the newest
+   entry, and higher indices refer to older entries.
+   ADDR is pointing to struct bts_struct (see asm/ds.h).
+*/
+#define PTRACE_BTS_CLEAR	44
+/* Clear the BTS buffer.
+   DATA and ADDR are ignored.
+*/
+#define PTRACE_BTS_DRAIN	45
+/* Read all available BTS records and clear the buffer.
+   DATA is ignored. ADDR points to an array of struct bts_struct of
+   suitable size.
+   BTS records are read from oldest to newest.
+   Returns number of BTS records drained.
+*/
 
 #endif
Index: linux-2.6-x86/include/asm-x86/ptrace.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/ptrace.h	2007-12-14 15:31:36.%N +0100
+++ linux-2.6-x86/include/asm-x86/ptrace.h	2007-12-14 15:31:48.%N +0100
@@ -9,6 +9,7 @@
 
 #ifdef __KERNEL__
 
+/* the DS BTS struct is used for ptrace as well */
 #include <asm/ds.h>
 
 struct task_struct;
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

