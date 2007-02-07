Return-Path: <linux-kernel-owner+w=401wt.eu-S1030479AbXBGAye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030479AbXBGAye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 19:54:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030485AbXBGAye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 19:54:34 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:33744 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030479AbXBGAyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 19:54:33 -0500
Message-ID: <45C92348.7090201@vmware.com>
Date: Tue, 06 Feb 2007 16:54:32 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Andi Kleen <ak@muc.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 5/11] Fix PIT override bug for paravirt
References: <200702060353.l163r2hU000745@zach-dev.vmware.com> <20070206123023.GE47229@muc.de>
In-Reply-To: <20070206123023.GE47229@muc.de>
Content-Type: multipart/mixed;
 boundary="------------030304030608080706040402"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030304030608080706040402
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Andi Kleen wrote:
> On Mon, Feb 05, 2007 at 07:53:02PM -0800, Zachary Amsden wrote:
>   
>> The time initialization changed for i386 when some code moved into time_init.
>> This made it no longer possible to override the PIT / HPET, which broke
>> paravirt guests.
>>     
>
> Looks still fragile. Can this be done cleaner? 
>
> In particularly some comments would be good, but clearer code 
> logic would be preferred.
>
> -Andi
>   

Well, the logic is still overly complicated, but I axed the ifdef and 
commented it.  It is difficult to work around the number of different 
compile and boot sequences here.

--------------030304030608080706040402
Content-Type: text/plain;
 name="pit-override"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pit-override"

diff -r 31c3528be5d2 arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c	Fri Feb 02 16:29:46 2007 -0800
+++ b/arch/i386/kernel/paravirt.c	Tue Feb 06 16:16:54 2007 -0800
@@ -497,7 +497,7 @@ struct paravirt_ops paravirt_ops = {
 	.memory_setup = machine_specific_memory_setup,
 	.get_wallclock = native_get_wallclock,
 	.set_wallclock = native_set_wallclock,
-	.time_init = time_init_hook,
+	.time_init = native_time_init,
 	.init_IRQ = native_init_IRQ,
 
 	.cpuid = native_cpuid,
diff -r 31c3528be5d2 arch/i386/kernel/time.c
--- a/arch/i386/kernel/time.c	Fri Feb 02 16:29:46 2007 -0800
+++ b/arch/i386/kernel/time.c	Tue Feb 06 16:27:06 2007 -0800
@@ -266,10 +266,24 @@ static void __init hpet_time_init(void)
 {
 	if (!hpet_enable())
 		setup_pit_timer();
+	time_init_hook();
+}
+
+void __init native_time_init(void)
+{
+	late_time_init = hpet_time_init;
+}
+
+/*
+ * This is called directly from init code; we must delay timer setup in the
+ * HPET case as we can't make the decision to turn on HPET this early in the
+ * boot process.  So we call do_time_init(), which either calls
+ * native_time_init above or a paravirt-op which implements an alternative
+ * timer.  This may seem like overkill, but is necessary for the rather large
+ * number of timer combinations.  But remember, this is all dealing with time,
+ * and with time, too much is never enough.
+ */
+void __init time_init(void)
+{
 	do_time_init();
 }
-
-void __init time_init(void)
-{
-	late_time_init = hpet_time_init;
-}
diff -r 31c3528be5d2 include/asm-i386/time.h
--- a/include/asm-i386/time.h	Fri Feb 02 16:29:46 2007 -0800
+++ b/include/asm-i386/time.h	Tue Feb 06 16:21:05 2007 -0800
@@ -28,13 +28,15 @@ static inline int native_set_wallclock(u
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
+#define do_time_init() native_time_init()
 
 #endif /* CONFIG_PARAVIRT */
 

--------------030304030608080706040402--
