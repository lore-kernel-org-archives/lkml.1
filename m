Return-Path: <linux-kernel-owner+w=401wt.eu-S933388AbXBJLxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933388AbXBJLxD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 06:53:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933392AbXBJLvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 06:51:20 -0500
Received: from mail.suse.de ([195.135.220.2]:50265 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933390AbXBJLue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:50:34 -0500
From: Andi Kleen <ak@suse.de>
References: <200702101250.142420000@suse.de>
In-Reply-To: <200702101250.142420000@suse.de>
To: Eric Dumazet <dada1@cosmosbay.com>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.21 review I] [20/25] x86_64: get rid of ARCH_HAVE_XTIME_LOCK
Message-Id: <20070210115033.5AEF313DCE@wotan.suse.de>
Date: Sat, 10 Feb 2007 12:50:33 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Eric Dumazet <dada1@cosmosbay.com>

ARCH_HAVE_XTIME_LOCK is used by x86_64 arch .  This arch needs to place a
read only copy of xtime_lock into vsyscall page.  This read only copy is
named __xtime_lock, and xtime_lock is defined in
arch/x86_64/kernel/vmlinux.lds.S as an alias.  So the declaration of
xtime_lock in kernel/timer.c was guarded by ARCH_HAVE_XTIME_LOCK define,
defined to true on x86_64.

We can get same result with _attribute__((weak)) in the declaration. linker
should do the job.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-x86_64/vsyscall.h |    5 -----
 include/linux/time.h          |    2 +-
 kernel/timer.c                |    4 +---
 3 files changed, 2 insertions(+), 9 deletions(-)

Index: linux/include/asm-x86_64/vsyscall.h
===================================================================
--- linux.orig/include/asm-x86_64/vsyscall.h
+++ linux/include/asm-x86_64/vsyscall.h
@@ -56,11 +56,6 @@ extern struct vxtime_data vxtime;
 extern int vgetcpu_mode;
 extern struct timezone sys_tz;
 extern int sysctl_vsyscall;
-extern seqlock_t xtime_lock;
-
-extern int sysctl_vsyscall;
-
-#define ARCH_HAVE_XTIME_LOCK 1
 
 #endif /* __KERNEL__ */
 
Index: linux/include/linux/time.h
===================================================================
--- linux.orig/include/linux/time.h
+++ linux/include/linux/time.h
@@ -90,7 +90,7 @@ static inline struct timespec timespec_s
 
 extern struct timespec xtime;
 extern struct timespec wall_to_monotonic;
-extern seqlock_t xtime_lock;
+extern seqlock_t xtime_lock __attribute__((weak));
 
 void timekeeping_init(void);
 
Index: linux/kernel/timer.c
===================================================================
--- linux.orig/kernel/timer.c
+++ linux/kernel/timer.c
@@ -1162,11 +1162,9 @@ static inline void calc_load(unsigned lo
  * This read-write spinlock protects us from races in SMP while
  * playing with xtime and avenrun.
  */
-#ifndef ARCH_HAVE_XTIME_LOCK
-__cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
+__attribute__((weak)) __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
 
 EXPORT_SYMBOL(xtime_lock);
-#endif
 
 /*
  * This function runs timers and the timer-tq in bottom half context.
