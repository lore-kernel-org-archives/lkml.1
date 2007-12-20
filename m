Return-Path: <linux-kernel-owner+w=401wt.eu-S1761974AbXLTNUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761974AbXLTNUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754609AbXLTNUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:20:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:29115 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959AbXLTNU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:20:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,189,1196668800"; 
   d="scan'208";a="301620504"
Date: Thu, 20 Dec 2007 14:20:10 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: ak@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com,
       suresh.b.siddha@intel.com, roland@redhat.com, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: [patch 3/5] x86, ptrace: add buffer size checks
Message-ID: <20071220142010.A29729@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass the buffer size for (most) ptrace commands that pass user-allocated buffers and check that size before accessing the buffer. Unfortunately, PTRACE_BTS_GET already uses all 4 parameters.
Commands that access user buffers return the number of bytes or records read or written.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: linux-2.6-x86/arch/x86/kernel/ptrace.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/ptrace.c	2007-12-20 13:52:01.%N +0100
+++ linux-2.6-x86/arch/x86/kernel/ptrace.c	2007-12-20 13:52:09.%N +0100
@@ -591,6 +591,7 @@
 }
 
 static int ptrace_bts_drain(struct task_struct *child,
+			    long size,
 			    struct bts_struct __user *out)
 {
 	int end, i;
@@ -603,6 +604,9 @@
 	if (end <= 0)
 		return end;
 
+	if (size < (end * sizeof(struct bts_struct)))
+		return -EIO;
+
 	for (i = 0; i < end; i++, out++) {
 		struct bts_struct ret;
 		int retval;
@@ -617,7 +621,7 @@
 
 	ds_clear(ds);
 
-	return i;
+	return end;
 }
 
 static int ptrace_bts_realloc(struct task_struct *child,
@@ -690,15 +694,22 @@
 }
 
 static int ptrace_bts_config(struct task_struct *child,
+			     long cfg_size,
 			     const struct ptrace_bts_config __user *ucfg)
 {
 	struct ptrace_bts_config cfg;
 	int bts_size, ret = 0;
 	void *ds;
 
+	if (cfg_size < sizeof(cfg))
+		return -EIO;
+
 	if (copy_from_user(&cfg, ucfg, sizeof(cfg)))
 		return -EFAULT;
 
+	if ((int)cfg.size < 0)
+		return -EINVAL;
+
 	bts_size = 0;
 	ds = (void *)child->thread.ds_area_msr;
 	if (ds) {
@@ -734,6 +745,8 @@
 	else
 		clear_tsk_thread_flag(child, TIF_BTS_TRACE_TS);
 
+	ret = sizeof(cfg);
+
 out:
 	if (child->thread.debugctlmsr)
 		set_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
@@ -749,11 +762,15 @@
 }
 
 static int ptrace_bts_status(struct task_struct *child,
+			     long cfg_size,
 			     struct ptrace_bts_config __user *ucfg)
 {
 	void *ds = (void *)child->thread.ds_area_msr;
 	struct ptrace_bts_config cfg;
 
+	if (cfg_size < sizeof(cfg))
+		return -EIO;
+
 	memset(&cfg, 0, sizeof(cfg));
 
 	if (ds) {
@@ -935,12 +952,12 @@
 
 	case PTRACE_BTS_CONFIG:
 		ret = ptrace_bts_config
-			(child, (struct ptrace_bts_config __user *)addr);
+			(child, data, (struct ptrace_bts_config __user *)addr);
 		break;
 
 	case PTRACE_BTS_STATUS:
 		ret = ptrace_bts_status
-			(child, (struct ptrace_bts_config __user *)addr);
+			(child, data, (struct ptrace_bts_config __user *)addr);
 		break;
 
 	case PTRACE_BTS_SIZE:
@@ -958,7 +975,7 @@
 
 	case PTRACE_BTS_DRAIN:
 		ret = ptrace_bts_drain
-			(child, (struct bts_struct __user *) addr);
+			(child, data, (struct bts_struct __user *) addr);
 		break;
 
 	default:
Index: linux-2.6-x86/include/asm-x86/ptrace-abi.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/ptrace-abi.h	2007-12-20 13:52:01.%N +0100
+++ linux-2.6-x86/include/asm-x86/ptrace-abi.h	2007-12-20 13:52:09.%N +0100
@@ -99,13 +99,15 @@
 
 #define PTRACE_BTS_CONFIG	40
 /* Configure branch trace recording.
-   DATA is ignored, ADDR points to a struct ptrace_bts_config.
+   ADDR points to a struct ptrace_bts_config.
+   DATA gives the size of that buffer.
    A new buffer is allocated, iff the size changes.
+   Returns the number of bytes read.
 */
 #define PTRACE_BTS_STATUS	41
-/* Return the current configuration.
-   DATA is ignored, ADDR points to a struct ptrace_bts_config
-   that will contain the result.
+/* Return the current configuration in a struct ptrace_bts_config
+   pointed to by ADDR; DATA gives the size of that buffer.
+   Returns the number of bytes written.
 */
 #define PTRACE_BTS_SIZE		42
 /* Return the number of available BTS records.
@@ -123,8 +125,8 @@
 */
 #define PTRACE_BTS_DRAIN	45
 /* Read all available BTS records and clear the buffer.
-   DATA is ignored. ADDR points to an array of struct bts_struct of
-   suitable size.
+   ADDR points to an array of struct bts_struct.
+   DATA gives the size of that buffer.
    BTS records are read from oldest to newest.
    Returns number of BTS records drained.
 */
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

