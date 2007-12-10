Return-Path: <linux-kernel-owner+w=401wt.eu-S1757588AbXLJLtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbXLJLtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 06:49:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757338AbXLJLt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 06:49:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:1512 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757327AbXLJLt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 06:49:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,276,1194249600"; 
   d="scan'208";a="231767772"
Date: Mon, 10 Dec 2007 12:49:09 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: ak@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com,
       suresh.b.siddha@intel.com, roland@redhat.com, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: [patch 3/4] x86, ptrace: change interface to newest-to-oldest array
Message-ID: <20071210124909.A14988@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the ptrace user interface to use an array from newest to oldest BTS entry.
This eliminates the need for the GET_INDEX command.

I could further imagine combining ALLOCATE_BUFFER with CONFIG and GET_BUFFER_SIZE with STATUS. This would bring the interface down to 3 commands (config, status, read), but it would require struct to be passed for config and status.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: linux-2.6-x86/arch/x86/kernel/ptrace.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/ptrace.c	2007-12-10 11:14:26.%N +0100
+++ linux-2.6-x86/arch/x86/kernel/ptrace.c	2007-12-10 11:34:20.%N +0100
@@ -479,26 +479,33 @@
 	return ds_get_bts_size((void *)child->thread.ds_area_msr);
 }
 
-static int ptrace_bts_get_index(struct task_struct *child)
-{
-	if (!child->thread.ds_area_msr)
-		return -ENXIO;
-
-	return ds_get_bts_index((void *)child->thread.ds_area_msr);
-}
-
 static int ptrace_bts_read_record(struct task_struct *child,
 				  long index,
 				  struct bts_struct __user *out)
 {
 	struct bts_struct ret;
 	int retval;
+	int bts_size;
+	int bts_index;
 
 	if (!child->thread.ds_area_msr)
 		return -ENXIO;
 
+	if (index < 0)
+		return -EINVAL;
+
+	bts_size = ds_get_bts_size((void *)child->thread.ds_area_msr);
+	if (bts_size <= index)
+		return -EINVAL;
+
+	/* translate the ptrace bts index into the ds bts index */
+	bts_index = ds_get_bts_index((void *)child->thread.ds_area_msr);
+	bts_index -= (index + 1);
+	if (bts_index < 0)
+		bts_index += bts_size;
+
 	retval = ds_read_bts((void *)child->thread.ds_area_msr,
-			     index, &ret);
+			     bts_index, &ret);
 	if (retval)
 		return retval;
 
@@ -813,10 +820,6 @@
 		ret = ptrace_bts_get_buffer_size(child);
 		break;
 
-	case PTRACE_BTS_GET_INDEX:
-		ret = ptrace_bts_get_index(child);
-		break;
-
 	case PTRACE_BTS_READ_RECORD:
 		ret = ptrace_bts_read_record
 			(child, data,
@@ -1017,7 +1020,6 @@
 	case PTRACE_BTS_MAX_BUFFER_SIZE:
 	case PTRACE_BTS_ALLOCATE_BUFFER:
 	case PTRACE_BTS_GET_BUFFER_SIZE:
-	case PTRACE_BTS_GET_INDEX:
 	case PTRACE_BTS_READ_RECORD:
 	case PTRACE_BTS_CONFIG:
 	case PTRACE_BTS_STATUS:
Index: linux-2.6-x86/include/asm-x86/ptrace-abi.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/ptrace-abi.h	2007-12-10 11:14:26.%N +0100
+++ linux-2.6-x86/include/asm-x86/ptrace-abi.h	2007-12-10 11:16:27.%N +0100
@@ -99,32 +99,27 @@
    ENXIO........no buffer allocated */
 #define PTRACE_BTS_GET_BUFFER_SIZE 42
 
-/* Return the index of the next bts record to be written,
-   if successful; -1, otherwise.
-   EOPNOTSUPP...processor does not support bts tracing
-   ENXIO........no buffer allocated
-   After the first warp-around, this is the start of the circular bts buffer. */
-#define PTRACE_BTS_GET_INDEX 43
-
-/* Read the DATA'th bts record into a ptrace_bts_record buffer provided in ADDR.
+/* Read the DATA'th bts record into a ptrace_bts_record buffer
+   provided in ADDR.
+   Records are ordered from newest to oldest.
    Return 0, if successful; -1, otherwise
    EOPNOTSUPP...processor does not support bts tracing
    ENXIO........no buffer allocated
    EINVAL.......invalid index */
-#define PTRACE_BTS_READ_RECORD 44
+#define PTRACE_BTS_READ_RECORD 43
 
 /* Configure last branch trace; the configuration is given as a bit-mask of
    PTRACE_BTS_O_* options in DATA; parameter ADDR is ignored.
    Return 0, if successful; -1, otherwise
    EOPNOTSUPP...processor does not support bts tracing
    ENXIO........no buffer allocated */
-#define PTRACE_BTS_CONFIG 45
+#define PTRACE_BTS_CONFIG 44
 
 /* Return the configuration as bit-mask of PTRACE_BTS_O_* options
    if successful; -1, otherwise.
    EOPNOTSUPP...processor does not support bts tracing
    ENXIO........no buffer allocated */
-#define PTRACE_BTS_STATUS 46
+#define PTRACE_BTS_STATUS 45
 
 /* Trace configuration options */
 /* Collect last branch trace */
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
