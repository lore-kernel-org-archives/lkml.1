Return-Path: <linux-kernel-owner+w=401wt.eu-S1756093AbXLFMrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbXLFMrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbXLFMmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:42:52 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:53721 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbXLFMmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:42:39 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <ce39a86c40512f19524fcc85881b89e6ab456f0f.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Fri, 30 Nov 2007 15:44:07 +0100
Subject: [PATCH 19/47] Update CRISv32 entry.S to working order.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Remove oldset parameter.
- Utilise delay-slot for parameter moving.
- Add kernel_execve as break 13.
- Add new kernel syscalls.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v32/kernel/entry.S |   82 +++++++++++++++++++++++++++++--------
 1 files changed, 64 insertions(+), 18 deletions(-)

diff --git a/arch/cris/arch-v32/kernel/entry.S b/arch/cris/arch-v32/kernel/entry.S
index f9d2780..596184c 100644
--- a/arch/cris/arch-v32/kernel/entry.S
+++ b/arch/cris/arch-v32/kernel/entry.S
@@ -10,7 +10,7 @@
  * after a timer-interrupt and after each system call.
  *
  * Stack layout in 'ret_from_system_call':
- * 	ptrace needs to have all regs on the stack.
+ *	ptrace needs to have all regs on the stack.
  *	if the order here is changed, it needs to be
  *	updated in fork.c:copy_process, signal.c:do_signal,
  *	ptrace.c and ptrace.h
@@ -281,12 +281,10 @@ _work_notifysig:
 	;; Deal with pending signals and notify-resume requests.
 
 	addoq	+TI_flags, $r0, $acr
-	move.d	[$acr], $r13		; The thread_info_flags parameter.
-	move.d	$r9, $r10		; do_notify_resume syscall/irq param.
-	moveq	0, $r11			; oldset param - 0 in this case.
-	move.d	$sp, $r12		; The regs param.
+	move.d	[$acr], $r12		; The thread_info_flags parameter.
+	move.d	$sp, $r11		; The regs param.
 	jsr	do_notify_resume
-	nop
+	move.d	$r9, $r10		; do_notify_resume syscall/irq param.
 
 	ba _Rexit
 	nop
@@ -396,7 +394,7 @@ nmi_interrupt:
 	btstq	REG_BIT(intr_vect, r_nmi, watchdog), $r0
 	bpl     1f
 	nop
-	jsr 	handle_watchdog_bite	; In time.c.
+	jsr	handle_watchdog_bite	; In time.c.
         move.d	$sp, $r10		; Pointer to registers
 1:	btstq	REG_BIT(intr_vect, r_nmi, ext), $r0
 	bpl     1f
@@ -515,6 +513,13 @@ _ugdb_handle_exception:
 	ba	do_sigtrap		; SIGTRAP the offending process.
 	move.d	[$sp+], $r0		; Restore R0 in delay slot.
 
+	.global kernel_execve
+kernel_execve:
+	move.d __NR_execve, $r9
+	break 13
+	ret
+	nop
+
 	.data
 
 	.section .rodata,"a"
@@ -778,21 +783,21 @@ sys_call_table:
 	.long sys_epoll_ctl	/* 255 */
 	.long sys_epoll_wait
 	.long sys_remap_file_pages
- 	.long sys_set_tid_address
- 	.long sys_timer_create
- 	.long sys_timer_settime		/* 260 */
- 	.long sys_timer_gettime
- 	.long sys_timer_getoverrun
- 	.long sys_timer_delete
- 	.long sys_clock_settime
- 	.long sys_clock_gettime		/* 265 */
- 	.long sys_clock_getres
- 	.long sys_clock_nanosleep
+	.long sys_set_tid_address
+	.long sys_timer_create
+	.long sys_timer_settime		/* 260 */
+	.long sys_timer_gettime
+	.long sys_timer_getoverrun
+	.long sys_timer_delete
+	.long sys_clock_settime
+	.long sys_clock_gettime		/* 265 */
+	.long sys_clock_getres
+	.long sys_clock_nanosleep
 	.long sys_statfs64
 	.long sys_fstatfs64
 	.long sys_tgkill	/* 270 */
 	.long sys_utimes
- 	.long sys_fadvise64_64
+	.long sys_fadvise64_64
 	.long sys_ni_syscall	/* sys_vserver */
 	.long sys_ni_syscall	/* sys_mbind */
 	.long sys_ni_syscall	/* 275 sys_get_mempolicy */
@@ -805,6 +810,47 @@ sys_call_table:
 	.long sys_mq_getsetattr
 	.long sys_ni_syscall		/* reserved for kexec */
 	.long sys_waitid
+	.long sys_ni_syscall		/* 285 */ /* available */
+	.long sys_add_key
+	.long sys_request_key
+	.long sys_keyctl
+	.long sys_ioprio_set
+	.long sys_ioprio_get		/* 290 */
+	.long sys_inotify_init
+	.long sys_inotify_add_watch
+	.long sys_inotify_rm_watch
+	.long sys_migrate_pages
+	.long sys_openat		/* 295 */
+	.long sys_mkdirat
+	.long sys_mknodat
+	.long sys_fchownat
+	.long sys_futimesat
+	.long sys_fstatat64		/* 300 */
+	.long sys_unlinkat
+	.long sys_renameat
+	.long sys_linkat
+	.long sys_symlinkat
+	.long sys_readlinkat		/* 305 */
+	.long sys_fchmodat
+	.long sys_faccessat
+	.long sys_pselect6
+	.long sys_ppoll
+	.long sys_unshare		/* 310 */
+	.long sys_set_robust_list
+	.long sys_set_robust_list
+	.long sys_get_robust_list
+	.long sys_splice
+	.long sys_sync_file_range
+	.long sys_tee			/* 315 */
+	.long sys_vmsplice
+	.long sys_move_pages
+	.long sys_getcpu
+	.long sys_epoll_pwait
+	.long sys_utimensat		/* 320 */
+	.long sys_signalfd
+	.long sys_timerfd
+	.long sys_eventfd
+	.long sys_fallocate
 
         /*
          * NOTE!! This doesn't have to be exact - we just have
-- 
1.5.3.6.970.gd25430

