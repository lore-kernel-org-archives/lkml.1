Return-Path: <linux-kernel-owner+w=401wt.eu-S1422796AbXCBC4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422796AbXCBC4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 21:56:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422728AbXCBC4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 21:56:17 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:52730 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422732AbXCBCz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 21:55:29 -0500
Date: Thu, 1 Mar 2007 18:55:11 -0800
Message-Id: <200703020255.l222tBj2009682@zach-dev.vmware.com>
Subject: [PATCH 6/9] Pit override.patch
From: Zachary Amsden <zach@vmware.com>
To: Andi Kleen <ak@muc.de>, Linus Torvalds <torvalds@osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>, Dan Hecht <dhecht@vmware.com>,
       Dan Arai <arai@vmware.com>, Andrew Morton <akpm@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Andrew Morton <akpm@osdl.org>
X-OriginalArrivalTime: 02 Mar 2007 02:55:28.0167 (UTC) FILETIME=[3BBFCB70:01C75C76]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The time_init_hook in paravirt-ops no longer functions in the correct manner
after the integration of the hrtimers code.  The problem is that now the
call path for time initialization is:

  time_init :
       late_time_init = hpet_time_init;

  late_time_init -> hpet_time_init:
       setup_pit_timer (BAD)
       do_time_init --> (via paravirt.h)
          time_init_hook --> (via arch_hooks.h)
              time_init_hook (in SUBARCH/setup.c)

If this isn't confusing enough, the paravirt case goes through an indirect
function pointer in the paravirt-ops table.  The problem is, by the time
the paravirt hook is called, the pit timer is already enabled.

But paravirt guests have their own timer, and don't want to use the PIT.
Rather than intensify the struggle for power going on here, just make it
all nice and simple and just unconditionally do all timer setup in
the late_time_init hook.  This also has the advantage of enabling timers
in the same place in all code paths, so everyone has the same bugs and
we don't have outliers who break other code because they turn on timer
too early or too late.

So the paravirt-ops time init function is now by default hpet_time_init,
which is the time init function used for native hardware.  Paravirt
guests have the chance to override this when they setup the paravirt-ops
table, and should need no change.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r 2ae8eb19b227 arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c	Tue Feb 27 16:28:10 2007 -0800
+++ b/arch/i386/kernel/paravirt.c	Tue Feb 27 17:08:11 2007 -0800
@@ -494,7 +494,7 @@ struct paravirt_ops paravirt_ops = {
 	.memory_setup = machine_specific_memory_setup,
 	.get_wallclock = native_get_wallclock,
 	.set_wallclock = native_set_wallclock,
-	.time_init = time_init_hook,
+	.time_init = hpet_time_init,
 	.init_IRQ = native_init_IRQ,
 
 	.cpuid = native_cpuid,
diff -r 2ae8eb19b227 arch/i386/kernel/time.c
--- a/arch/i386/kernel/time.c	Tue Feb 27 16:28:10 2007 -0800
+++ b/arch/i386/kernel/time.c	Tue Feb 27 16:50:01 2007 -0800
@@ -262,14 +262,22 @@ void notify_arch_cmos_timer(void)
 
 extern void (*late_time_init)(void);
 /* Duplicate of time_init() below, with hpet_enable part added */
-static void __init hpet_time_init(void)
+void __init hpet_time_init(void)
 {
 	if (!hpet_enable())
 		setup_pit_timer();
-	do_time_init();
-}
-
+	time_init_hook();
+}
+
+/*
+ * This is called directly from init code; we must delay timer setup in the
+ * HPET case as we can't make the decision to turn on HPET this early in the
+ * boot process.
+ *
+ * The chosen time_init function will usually be hpet_time_init, above, but
+ * in the case of virtual hardware, an alternative function may be substituted.
+ */
 void __init time_init(void)
 {
-	late_time_init = hpet_time_init;
-}
+	late_time_init = choose_time_init();
+}
diff -r 2ae8eb19b227 include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h	Tue Feb 27 16:28:10 2007 -0800
+++ b/include/asm-i386/paravirt.h	Tue Feb 27 17:07:23 2007 -0800
@@ -186,9 +186,9 @@ static inline int set_wallclock(unsigned
 	return paravirt_ops.set_wallclock(nowtime);
 }
 
-static inline void do_time_init(void)
-{
-	return paravirt_ops.time_init();
+static inline void (*choose_time_init(void))(void)
+{
+	return paravirt_ops.time_init;
 }
 
 /* The paravirtualized CPUID instruction. */
diff -r 2ae8eb19b227 include/asm-i386/time.h
--- a/include/asm-i386/time.h	Tue Feb 27 16:28:10 2007 -0800
+++ b/include/asm-i386/time.h	Tue Feb 27 16:50:45 2007 -0800
@@ -28,13 +28,16 @@ static inline int native_set_wallclock(u
 	return retval;
 }
 
+extern void (*late_time_init)(void);
+extern void hpet_time_init(void);
+
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else /* !CONFIG_PARAVIRT */
 
 #define get_wallclock() native_get_wallclock()
 #define set_wallclock(x) native_set_wallclock(x)
-#define do_time_init() time_init_hook()
+#define choose_time_init() hpet_time_init
 
 #endif /* CONFIG_PARAVIRT */
 
