Return-Path: <linux-kernel-owner+w=401wt.eu-S1752665AbXBFDxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbXBFDxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 22:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbXBFDxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 22:53:19 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:40365 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752672AbXBFDxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 22:53:05 -0500
Date: Mon, 5 Feb 2007 19:53:02 -0800
Message-Id: <200702060353.l163r2hU000745@zach-dev.vmware.com>
Subject: [PATCH 5/11] Fix PIT override bug for paravirt
From: Zachary Amsden <zach@vmware.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>
X-OriginalArrivalTime: 06 Feb 2007 03:53:02.0200 (UTC) FILETIME=[4C996780:01C749A2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The time initialization changed for i386 when some code moved into time_init.
This made it no longer possible to override the PIT / HPET, which broke
paravirt guests.

Subject: Fix PIT override bug for paravirt
Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r acd12d5196c7 arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c	Thu Feb 01 23:13:18 2007 -0800
+++ b/arch/i386/kernel/paravirt.c	Thu Feb 01 23:19:36 2007 -0800
@@ -497,7 +497,7 @@ struct paravirt_ops paravirt_ops = {
 	.memory_setup = machine_specific_memory_setup,
 	.get_wallclock = native_get_wallclock,
 	.set_wallclock = native_set_wallclock,
-	.time_init = time_init_hook,
+	.time_init = native_time_init,
 	.init_IRQ = native_init_IRQ,
 
 	.cpuid = native_cpuid,
diff -r acd12d5196c7 arch/i386/kernel/time.c
--- a/arch/i386/kernel/time.c	Thu Feb 01 23:13:18 2007 -0800
+++ b/arch/i386/kernel/time.c	Thu Feb 01 23:43:21 2007 -0800
@@ -268,10 +268,17 @@ static void __init hpet_time_init(void)
 {
 	if (!hpet_enable())
 		setup_pit_timer();
-	do_time_init();
-}
-
+	time_init_hook();
+}
+
+void __init native_time_init(void)
+{
+	late_time_init = hpet_time_init;
+}
+
+#ifndef CONFIG_PARAVIRT
 void __init time_init(void)
 {
-	late_time_init = hpet_time_init;
-}
+	native_time_init();
+}
+#endif
diff -r acd12d5196c7 include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h	Thu Feb 01 23:13:18 2007 -0800
+++ b/include/asm-i386/paravirt.h	Thu Feb 01 23:17:27 2007 -0800
@@ -185,7 +185,7 @@ static inline int set_wallclock(unsigned
 	return paravirt_ops.set_wallclock(nowtime);
 }
 
-static inline void do_time_init(void)
+static inline void time_init(void)
 {
 	return paravirt_ops.time_init();
 }
diff -r acd12d5196c7 include/asm-i386/time.h
--- a/include/asm-i386/time.h	Thu Feb 01 23:13:18 2007 -0800
+++ b/include/asm-i386/time.h	Thu Feb 01 23:43:29 2007 -0800
@@ -28,13 +28,14 @@ static inline int native_set_wallclock(u
 	return retval;
 }
 
+extern void native_time_init(void);
+
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else /* !CONFIG_PARAVIRT */
 
 #define get_wallclock() native_get_wallclock()
 #define set_wallclock(x) native_set_wallclock(x)
-#define do_time_init() time_init_hook()
 
 #endif /* CONFIG_PARAVIRT */
 
