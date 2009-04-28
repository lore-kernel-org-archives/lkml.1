Return-Path: <linux-kernel-owner+w=401wt.eu-S1762610AbZD1P7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762610AbZD1P7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761591AbZD1P7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:59:08 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:42903 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761835AbZD1P7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:59:06 -0400
Date: Tue, 28 Apr 2009 17:58:56 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Christoph Hellwig <hch@lst.de>, Mikael Starvik <mikael.starvik@axis.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] CRIS: Wire up syscalls signalfd4 to writev.
Message-ID: <20090428155856.GN21811@axis.com>
References: <20090427081356.GA32167@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090427081356.GA32167@lst.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 10:13:56AM +0200, Christoph Hellwig wrote:
> 2.6.30 added the new preadv/pwritev system calls.  The following
> architectures still haven't wired them up:
> 
> 	alpha, avr32, blackfin, cris, frv, h8300, m32r, xtensa
> 
> Can you maintainers please look into wiring these system calls up?

I've just added the following patch to the CRIS tree:


Adds sys_signalfd4, sys_eventfd2, sys_epoll_create1, sys_dup3,
sys_pipe2, sys_inotify_init1, sys_preadv, sys_pwritev
for both CRISv10 and CRISv32.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v10/kernel/entry.S |   14 +++++++++++---
 arch/cris/arch-v32/kernel/entry.S |    8 ++++++++
 arch/cris/include/asm/unistd.h    |   12 ++++++++++--
 3 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/entry.S b/arch/cris/arch-v10/kernel/entry.S
index 72f5cd3..2c18d08 100644
--- a/arch/cris/arch-v10/kernel/entry.S
+++ b/arch/cris/arch-v10/kernel/entry.S
@@ -536,10 +536,10 @@ multiple_interrupt:
 	movem	$r13, [$sp]
 	push	$r10		; push orig_r10
 	clear.d [$sp=$sp-4]	; frametype == 0, normal frame
-	
+
 	move.d  $sp, $r10
 	jsr	do_multiple_IRQ
-	
+
 	jump    ret_from_intr
 
 do_sigtrap:
@@ -585,7 +585,7 @@ _ugdb_handle_breakpoint:
 	pop	$r0			; Restore r0. 
 	ba	do_sigtrap		; SIGTRAP the offending process. 
 	pop	$dccr			; Restore dccr in delay slot.
-	
+
 	.global kernel_execve
 kernel_execve:
 	move.d __NR_execve, $r9
@@ -929,6 +929,14 @@ sys_call_table:
 	.long sys_fallocate
 	.long sys_timerfd_settime	/* 325 */
 	.long sys_timerfd_gettime
+	.long sys_signalfd4
+	.long sys_eventfd2
+	.long sys_epoll_create1
+	.long sys_dup3			/* 330 */
+	.long sys_pipe2
+	.long sys_inotify_init1
+	.long sys_preadv
+	.long sys_pwritev
 
         /*
          * NOTE!! This doesn't have to be exact - we just have
diff --git a/arch/cris/arch-v32/kernel/entry.S b/arch/cris/arch-v32/kernel/entry.S
index 5e674c8..435b967 100644
--- a/arch/cris/arch-v32/kernel/entry.S
+++ b/arch/cris/arch-v32/kernel/entry.S
@@ -852,6 +852,14 @@ sys_call_table:
 	.long sys_fallocate
 	.long sys_timerfd_settime       /* 325 */
 	.long sys_timerfd_gettime
+	.long sys_signalfd4
+	.long sys_eventfd2
+	.long sys_epoll_create1
+	.long sys_dup3			/* 330 */
+	.long sys_pipe2
+	.long sys_inotify_init1
+	.long sys_preadv
+	.long sys_pwritev
 
         /*
          * NOTE!! This doesn't have to be exact - we just have
diff --git a/arch/cris/include/asm/unistd.h b/arch/cris/include/asm/unistd.h
index 235d076..c170793 100644
--- a/arch/cris/include/asm/unistd.h
+++ b/arch/cris/include/asm/unistd.h
@@ -281,7 +281,7 @@
 #define __NR_mbind		274
 #define __NR_get_mempolicy	275
 #define __NR_set_mempolicy	276
-#define __NR_mq_open 		277
+#define __NR_mq_open		277
 #define __NR_mq_unlink		(__NR_mq_open+1)
 #define __NR_mq_timedsend	(__NR_mq_open+2)
 #define __NR_mq_timedreceive	(__NR_mq_open+3)
@@ -331,10 +331,18 @@
 #define __NR_fallocate		324
 #define __NR_timerfd_settime	325
 #define __NR_timerfd_gettime	326
+#define __NR_signalfd4		327
+#define __NR_eventfd2		328
+#define __NR_epoll_create1	329
+#define __NR_dup3		330
+#define __NR_pipe2		331
+#define __NR_inotify_init1	332
+#define __NR_preadv		333
+#define __NR_pwritev		334
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 327
+#define NR_syscalls 335
 
 #include <arch/unistd.h>
 
-- 
1.6.1


/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
