Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbXIMIAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbXIMIAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 04:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbXIMIAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 04:00:30 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:47287 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbXIMIA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 04:00:29 -0400
X-IronPort-AV: i="4.20,248,1186372800"; 
   d="scan'208"; a="39527744:sNHT30950836"
Subject: [PATCH] Blackfin arch: add some missing syscall
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-arch@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Thu, 13 Sep 2007 15:56:43 +0800
Message-Id: <1189670203.30686.15.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 13 Sep 2007 08:00:27.0904 (UTC) FILETIME=[25CB5000:01C7F5DC]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When compiling the Blackfin kernel, checksyscalls.pl will report lots of missing syscalls warnings.
This patch will add some missing syscalls which make sense on Blackfin arch.

Also add ignored syscall list to kill remaining warnings.

After appling this patch, toolchain should be rebuilt. Then recompiling the kernel with the new
toolchain.

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/mach-common/entry.S |   18 ++++++++++--
 include/asm-blackfin/unistd.h     |   54 ++++++++++++++++++++++++++++++++++---
 2 files changed, 65 insertions(+), 7 deletions(-)

diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index d61bba9..ef60f2e 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -815,7 +815,7 @@ _extable:
 
 ALIGN
 ENTRY(_sys_call_table)
-	.long _sys_ni_syscall	/* 0  -  old "setup()" system call*/
+	.long _sys_restart_syscall	/* 0 */
 	.long _sys_exit
 	.long _sys_fork
 	.long _sys_read
@@ -984,7 +984,7 @@ ENTRY(_sys_call_table)
 	.long _sys_ni_syscall	/* for vm86 */
 	.long _sys_ni_syscall	/* old "query_module" */
 	.long _sys_ni_syscall	/* sys_poll */
-	.long _sys_ni_syscall	/* sys_nfsservctl */
+	.long _sys_nfsservctl
 	.long _sys_setresgid	/* setresgid16 */	/* 170 */
 	.long _sys_getresgid	/* getresgid16 */
 	.long _sys_prctl
@@ -1040,7 +1040,7 @@ ENTRY(_sys_call_table)
 	.long _sys_ni_syscall	/* reserved for TUX */
 	.long _sys_ni_syscall
 	.long _sys_gettid
-	.long _sys_ni_syscall	/* 225 */ /* sys_readahead */
+	.long _sys_readahead	/* 225 */
 	.long _sys_setxattr
 	.long _sys_lsetxattr
 	.long _sys_fsetxattr
@@ -1157,6 +1157,18 @@ ENTRY(_sys_call_table)
 	.long _sys_shmctl
 	.long _sys_shmdt	/* 340 */
 	.long _sys_shmget
+	.long _sys_splice
+	.long _sys_sync_file_range
+	.long _sys_tee
+	.long _sys_vmsplice	/* 345 */
+	.long _sys_epoll_pwait
+	.long _sys_utimensat
+	.long _sys_signalfd
+	.long _sys_timerfd
+	.long _sys_eventfd	/* 350 */
+	.long _sys_pread64
+	.long _sys_pwrite64
+	.long _sys_fadvise64
 	.rept NR_syscalls-(.-_sys_call_table)/4
 	.long _sys_ni_syscall
 	.endr
diff --git a/include/asm-blackfin/unistd.h b/include/asm-blackfin/unistd.h
index 0df9f2d..2de4cd2 100644
--- a/include/asm-blackfin/unistd.h
+++ b/include/asm-blackfin/unistd.h
@@ -3,6 +3,7 @@
 /*
  * This file contains the system call numbers.
  */
+#define __NR_restart_syscall	  0
 #define __NR_exit		  1
 #define __NR_fork		  2
 #define __NR_read		  3
@@ -171,7 +172,7 @@
 				/* 166 __NR_vm86 */
 				/* 167 __NR_query_module */
 				/* 168 __NR_poll */
-				/* 169 __NR_nfsservctl */
+#define __NR_nfsservctl		169
 #define __NR_setresgid		170
 #define __NR_getresgid		171
 #define __NR_prctl		172
@@ -227,7 +228,7 @@
 				/* 222 reserved for TUX */
 				/* 223 reserved for TUX */
 #define __NR_gettid		224
-				/* 225 __NR_readahead */
+#define __NR_readahead		225
 #define __NR_setxattr		226
 #define __NR_lsetxattr		227
 #define __NR_fsetxattr		228
@@ -287,7 +288,7 @@
 #define __NR_mq_timedreceive	(__NR_mq_open+3)
 #define __NR_mq_notify		(__NR_mq_open+4)
 #define __NR_mq_getsetattr	(__NR_mq_open+5)
-				/* 284 __NR_sys_kexec_load */
+#define __NR_kexec_load		284
 #define __NR_waitid		285
 #define __NR_add_key		286
 #define __NR_request_key	287
@@ -352,9 +353,54 @@
 #define __NR_shmdt		340
 #define __NR_shmget		341
 
-#define __NR_syscall		342
+#define __NR_splice		342
+#define __NR_sync_file_range	343
+#define __NR_tee		344
+#define __NR_vmsplice		345
+
+#define __NR_epoll_pwait	346
+#define __NR_utimensat		347
+#define __NR_signalfd		348
+#define __NR_timerfd		349
+#define __NR_eventfd		350
+#define __NR_pread64		351
+#define __NR_pwrite64		352
+#define __NR_fadvise64		353
+
+#define __NR_syscall		354
 #define NR_syscalls		__NR_syscall
 
+/* Old optional stuff no one actually uses */
+#define __IGNORE_sysfs
+#define __IGNORE_uselib
+
+/* Implement the newer interfaces */
+#define __IGNORE_mmap
+#define __IGNORE_poll
+#define __IGNORE_select
+#define __IGNORE_utime
+
+/* Not relevant on no-mmu */
+#define __IGNORE_swapon
+#define __IGNORE_swapoff
+#define __IGNORE_msync
+#define __IGNORE_mlock
+#define __IGNORE_munlock
+#define __IGNORE_mlockall
+#define __IGNORE_munlockall
+#define __IGNORE_mremap
+#define __IGNORE_mincore
+#define __IGNORE_madvise
+#define __IGNORE_remap_file_pages
+#define __IGNORE_mbind
+#define __IGNORE_get_mempolicy
+#define __IGNORE_set_mempolicy
+#define __IGNORE_migrate_pages
+#define __IGNORE_set_robust_list
+#define __IGNORE_get_robust_list
+#define __IGNORE_move_pages
+#define __IGNORE_getcpu
+
 #ifdef __KERNEL__
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_STAT64
-- 
1.5.2

