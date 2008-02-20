Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbYBTMEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbYBTMEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 07:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbYBTMEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 07:04:47 -0500
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:48434 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbYBTMEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 07:04:46 -0500
Message-ID: <47BC17BE.9010800@keyaccess.nl>
Date: Wed, 20 Feb 2008 13:06:22 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Dmitry Torokhov <dtor_core@ameritech.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: use explicit timing delay for pit accesses in kernel
 and pcspkr driver
References: <6gr00g$g7qpu0@smtp01.lnh.mail.rcn.net> <47B9ECE0.70000@keyaccess.nl> <47B9EDF1.5050404@zytor.com> <47B9F2EC.4070308@keyaccess.nl> <47B9FC3A.2010508@zytor.com> <47B9FFD5.6040801@keyaccess.nl> <47BA002B.7070806@zytor.com> <47BA0188.6000808@keyaccess.nl> <47BA077B.50401@keyaccess.nl> <47BA0A3D.1060708@zytor.com>
In-Reply-To: <47BA0A3D.1060708@zytor.com>
Content-Type: multipart/mixed;
 boundary="------------090103070505040707070802"
X-Spam-Score: -0.6 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090103070505040707070802
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 18-02-08 23:44, H. Peter Anvin wrote:

>>>> Rene Herman wrote:
>>>>>
>>>>> Yes, but generally not any P5+ system is going to need the PIT 
>>>>> delay in the first place meaning it just doesn't matter. There were 
>>>>> the VIA issues with the PIC but unless I missed it not with the PIT.
>>>>>
>>>>
>>>> Uhm, I'm not sure I believe that's safe.
>>>>
>>>> The PIT is particularly pissy in this case -- the semantics of the 
>>>> PIT are ill-defined if there hasn't been a PIT clock between two 
>>>> adjacent accesses, so I fully expect that there are chipsets out 
>>>> there which will do very bad things in this case.
>>>
>>> Okay. Now that they're isolated, do you have a suggestion for 
>>> {in,out}b_pit? You say a PIT clock, so do you think we can bounce of 
>>> the PIT iself in this case after all?
>>
>> Am I correct that channel 1 is never used? A simple read from 0x41?
>>
> 
> Channel 1 is available for the system.  In modern systems, it's pretty 
> much available for the OS, although that's never formally stated (in the 
> original PC, it was used for DRAM refresh.)
> 
> However, I could very easily see a chipset have issues with that kind of 
> stuff.

I couldn't really, but clean it's neither. Okay, so you just want something 
like this? This initializes loops_per_jiffy somewhat more usefully -- at a 
1G CPU for P6 and 64-bit, and tuning it down again for 386/486/586.

The values taken are for what I believe to be the fastest CPUs among the 
specific family. Alan?

386-40 and P1-233 were verified, the 486-120 value was scaled from a 486-40.

_Something_ like this would seem to be the only remaining option. It seems 
fairly unuseful to #ifdef around that switch statement for kernels without 
support for the earlier families, but if you insist...

Rene.

--------------090103070505040707070802
Content-Type: text/plain;
 name="per-family-loops_per_jiffy.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="per-family-loops_per_jiffy.diff"

commit 9c679215248e837b34242632d5a22adf9a247021
Author: Rene Herman <rene.herman@gmail.com>
Date:   Wed Feb 20 12:52:30 2008 +0100

    x86: per CPU family loops_per_jiffy initialization
    
    Following the current port 0x80 I/O delay replacements we need
    microseconds to be somewhat usefully defined pre calibration.
    
    Initialize 386, 486 and Pentium 1 as fastest in their families
    and higher CPUs (including 64-bit) at 1 Ghz. Note that trouble
    should be absent past family 5 systems anyway.
    
    Signed-off-by: Rene Herman <rene.herman@gmail.com>

diff --git a/arch/x86/kernel/time_32.c b/arch/x86/kernel/time_32.c
index 1a89e93..e33e70b 100644
--- a/arch/x86/kernel/time_32.c
+++ b/arch/x86/kernel/time_32.c
@@ -32,6 +32,7 @@
 #include <linux/interrupt.h>
 #include <linux/time.h>
 #include <linux/mca.h>
+#include <linux/delay.h>
 
 #include <asm/arch_hooks.h>
 #include <asm/hpet.h>
@@ -134,6 +135,17 @@ void __init hpet_time_init(void)
  */
 void __init time_init(void)
 {
+	switch (boot_cpu_data.x86) {
+	case 3:
+		loops_per_jiffy = LOOPS_PER_JIFFY_386;
+		break;
+	case 4:
+		loops_per_jiffy = LOOPS_PER_JIFFY_486;
+		break;
+	case 5:
+		loops_per_jiffy = LOOPS_PER_JIFFY_586;
+		break;
+	}
 	tsc_init();
 	late_time_init = choose_time_init();
 }
diff --git a/include/asm-x86/delay.h b/include/asm-x86/delay.h
index 409a649..d0fbaf6 100644
--- a/include/asm-x86/delay.h
+++ b/include/asm-x86/delay.h
@@ -7,6 +7,11 @@
  * Delay routines calling functions in arch/x86/lib/delay.c
  */
 
+#define LOOPS_PER_JIFFY_386	(4000000 / HZ)	  /* 386 at 40 Mhz */
+#define LOOPS_PER_JIFFY_486	(30000000 / HZ)	  /* 486 at 120 MHz */
+#define LOOPS_PER_JIFFY_586	(233000000 / HZ)  /* Pentium 1 at 233 Mhz */
+#define LOOPS_PER_JIFFY		(1000000000 / HZ) /* P6+ at 1 GHz */
+
 /* Undefined functions to get compile-time errors */
 extern void __bad_udelay(void);
 extern void __bad_ndelay(void);
diff --git a/init/main.c b/init/main.c
index 8b19820..94862c8 100644
--- a/init/main.c
+++ b/init/main.c
@@ -228,12 +228,11 @@ static int __init obsolete_checksetup(char *line)
 	return had_early_param;
 }
 
-/*
- * This should be approx 2 Bo*oMips to start (note initial shift), and will
- * still work even if initially too large, it will just take slightly longer
- */
-unsigned long loops_per_jiffy = (1<<12);
+#ifndef LOOPS_PER_JIFFY
+#define LOOPS_PER_JIFFY	(1 << 12)
+#endif
 
+unsigned long loops_per_jiffy = LOOPS_PER_JIFFY;
 EXPORT_SYMBOL(loops_per_jiffy);
 
 static int __init debug_kernel(char *str)

--------------090103070505040707070802--
