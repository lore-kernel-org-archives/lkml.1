Return-Path: <linux-kernel-owner+w=401wt.eu-S1760441AbYBUGTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760441AbYBUGTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 01:19:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbYBUGTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 01:19:31 -0500
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:33345 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbYBUGT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 01:19:29 -0500
Message-ID: <47BD1857.9000505@keyaccess.nl>
Date: Thu, 21 Feb 2008 07:21:11 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "David P. Reed" <dpreed@reed.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       Dmitry Torokhov <dtor_core@ameritech.net>, linux-kernel@vger.kernel.org
Subject: Re: [linux-kernel] Re: [PATCH] x86: use explicit timing delay for
 pit accesses in kernel and pcspkr driver
References: <6gr00g$g7qpu0@smtp01.lnh.mail.rcn.net> <47B9ECE0.70000@keyaccess.nl> <47B9EDF1.5050404@zytor.com> <47B9F2EC.4070308@keyaccess.nl> <47B9FC3A.2010508@zytor.com> <47B9FFD5.6040801@keyaccess.nl> <47BA002B.7070806@zytor.com> <47BA0188.6000808@keyaccess.nl> <47BA077B.50401@keyaccess.nl> <47BA0A3D.1060708@zytor.com> <47BC17BE.9010800@keyaccess.nl> <47BC5DF4.9020300@zytor.com> <47BC5EE3.5090101@keyaccess.nl> <47BC89F5.90305@reed.com>
In-Reply-To: <47BC89F5.90305@reed.com>
Content-Type: multipart/mixed;
 boundary="------------060904070002010107050903"
X-Spam-Score: -0.6 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060904070002010107050903
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 20-02-08 21:13, David P. Reed wrote:

> Actually, disparaging things as "one idiotic system" doesn't seem like a 
> long-term thoughtful process - it's not even accurate.

Whatever we think about systems using port 0x80, fact of the matter is that 
they do and outside of legacy stuff that isn't applicable to these systems, 
Linux needs to stop using it (post ACPI init at least) to be able to run on 
them.

As options of doing so we have:

1) Replace the port 0x80 I/O delay with nothing. Determined to be unsafe.

2) Replace 0x80 with another port. None are really available and DMI based 
switching gets to be unmaintainable and has a such been shot down.

3) Replace the port 0x80 I/O delay with a udelay(2). Should work well enough 
in practice for the remaining users outside legacy drivers after (Alan's) 
cleaning up.

The remaining (possible) problem is that pre calibration microseconds are a 
total fiction and at least PIT init happens before calibration. In practice 
I believe this might not be much of a real-world problem since for whatever 
initial value for loops_per_jiffy we get at least our old double short jump 
that is enough of a delay for 386 and 486 but I sympathise with anone, such 
as HPA, who'd consider my beliefs not a particular guarantee.

So, we need a more useful pre calibration udelay. Ugly as it might be, 
through something like the attached. Alan, could you perhaps comment?

With the problam surfacing only post ACPI init, the _last_ remaining option 
is talking to the PIT using port 0x80 at init and using udelay after but I 
myself will not be submitting a patch to do so. Insane mess.

It would be good to get this crap sorted relatively quickly so we can do 
away with the io_delay mongering even pre .26 again. It introduces boot 
parameters and as such becomes part of API somewhat, so if it's not going to 
stay let's kill it quickly.

Ren

--------------060904070002010107050903
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

--------------060904070002010107050903--
