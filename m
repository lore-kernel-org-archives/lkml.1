Return-Path: <linux-kernel-owner+w=401wt.eu-S1758527AbYJNJRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527AbYJNJRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 05:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757555AbYJNJPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 05:15:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38477
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755188AbYJNJPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 05:15:31 -0400
Date: Tue, 14 Oct 2008 02:15:06 -0700 (PDT)
Message-Id: <20081014.021506.18668456.davem@davemloft.net>
To: mathieu.desnoyers@polymtl.ca
Cc: linux-kernel@vger.kernel.org
Subject: Re: sparc64: Optimized immediate value implementation build error
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081014044758.GA20420@Krystal>
References: <20081014021704.GA15549@Krystal>
	<20081013.193117.38855645.davem@davemloft.net>
	<20081014044758.GA20420@Krystal>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m9E9Hldq020118

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Tue, 14 Oct 2008 00:47:58 -0400

> * David Miller (davem@davemloft.net) wrote:
> > I'll pull in 0.40 next.
> 
> I'm looking forward to hear about the results. Thanks !

It builds, and I made sure that USE_IMMEDIATE does get defined
by the makefile changes you made.

On the other hand, CONFIG_PSRWLOCK_LATENCY_TEST fails to build:

  CC      lib/psrwlock-latency-trace.o
lib/psrwlock-latency-trace.c: In function â€˜calibrate_get_cyclesâ€™:
lib/psrwlock-latency-trace.c:60: error: implicit declaration of function â€˜rdtsc_barrierâ€™

You could use sched_clock() or similar, we do have portable
interfaces by which to do these things.  And if we don't
have something fitting exactly what is needed here, add it :-)

Also:

<stdin>:1421:2: warning: #warning syscall marker not implemented
<stdin>:1425:2: warning: #warning syscall trace not implemented

which should be fixed by the following patch:

sparc: Add sys_trace() and sys_marker() syscall table entries.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/arch/sparc/include/asm/unistd_32.h b/arch/sparc/include/asm/unistd_32.h
index 648643a..ef924f4 100644
--- a/arch/sparc/include/asm/unistd_32.h
+++ b/arch/sparc/include/asm/unistd_32.h
@@ -338,8 +338,10 @@
 #define __NR_dup3		320
 #define __NR_pipe2		321
 #define __NR_inotify_init1	322
+#define __NR_marker		323
+#define __NR_trace		324
 
-#define NR_SYSCALLS		323
+#define NR_SYSCALLS		325
 
 /* Sparc 32-bit only has the "setresuid32", "getresuid32" variants,
  * it never had the plain ones and there is no value to adding those
diff --git a/arch/sparc/include/asm/unistd_64.h b/arch/sparc/include/asm/unistd_64.h
index c5cc0e0..bd830d8 100644
--- a/arch/sparc/include/asm/unistd_64.h
+++ b/arch/sparc/include/asm/unistd_64.h
@@ -340,8 +340,10 @@
 #define __NR_dup3		320
 #define __NR_pipe2		321
 #define __NR_inotify_init1	322
+#define __NR_marker		323
+#define __NR_trace		324
 
-#define NR_SYSCALLS		323
+#define NR_SYSCALLS		325
 
 #ifdef __KERNEL__
 #define __ARCH_WANT_IPC_PARSE_VERSION
diff --git a/arch/sparc/kernel/systbls.S b/arch/sparc/kernel/systbls.S
index e1b9233..0a1dd3d 100644
--- a/arch/sparc/kernel/systbls.S
+++ b/arch/sparc/kernel/systbls.S
@@ -81,4 +81,4 @@ sys_call_table:
 /*305*/	.long sys_set_mempolicy, sys_kexec_load, sys_move_pages, sys_getcpu, sys_epoll_pwait
 /*310*/	.long sys_utimensat, sys_signalfd, sys_timerfd_create, sys_eventfd, sys_fallocate
 /*315*/	.long sys_timerfd_settime, sys_timerfd_gettime, sys_signalfd4, sys_eventfd2, sys_epoll_create1
-/*320*/	.long sys_dup3, sys_pipe2, sys_inotify_init1
+/*320*/	.long sys_dup3, sys_pipe2, sys_inotify_init1, sys_marker, sys_trace
diff --git a/arch/sparc64/kernel/systbls.S b/arch/sparc64/kernel/systbls.S
index 0fdbf3b..0257912 100644
--- a/arch/sparc64/kernel/systbls.S
+++ b/arch/sparc64/kernel/systbls.S
@@ -82,7 +82,7 @@ sys_call_table32:
 	.word compat_sys_set_mempolicy, compat_sys_kexec_load, compat_sys_move_pages, sys_getcpu, compat_sys_epoll_pwait
 /*310*/	.word compat_sys_utimensat, compat_sys_signalfd, sys_timerfd_create, sys_eventfd, compat_sys_fallocate
 	.word compat_sys_timerfd_settime, compat_sys_timerfd_gettime, compat_sys_signalfd4, sys_eventfd2, sys_epoll_create1
-/*320*/	.word sys_dup3, sys_pipe2, sys_inotify_init1
+/*320*/	.word sys_dup3, sys_pipe2, sys_inotify_init1, sys_marker, sys_trace
 
 #endif /* CONFIG_COMPAT */
 
@@ -156,4 +156,4 @@ sys_call_table:
 	.word sys_set_mempolicy, sys_kexec_load, sys_move_pages, sys_getcpu, sys_epoll_pwait
 /*310*/	.word sys_utimensat, sys_signalfd, sys_timerfd_create, sys_eventfd, sys_fallocate
 	.word sys_timerfd_settime, sys_timerfd_gettime, sys_signalfd4, sys_eventfd2, sys_epoll_create1
-/*320*/	.word sys_dup3, sys_pipe2, sys_inotify_init1
+/*320*/	.word sys_dup3, sys_pipe2, sys_inotify_init1, sys_marker, sys_trace
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
