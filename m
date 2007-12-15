Return-Path: <linux-kernel-owner+w=401wt.eu-S933007AbXLOIAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007AbXLOIAK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 03:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755610AbXLOH76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 02:59:58 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:14532 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbXLOH74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 02:59:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type;
        b=WN7PHllEqDmKLYuAthvO1QjQIIah8Xl+X3GfYSRH0mS7gEIvLBB/hRwRQDoYtDgFwuq6GwD+az0pxzSIl4Zv/VbVyZ9aBNYeat53Fg0iy318ReMeXU40MEnIjmvsUvp2oQMQI7Uy0/frhB6az8T9Zwa9OsKFZl2oqbImzHuu3OE=
Message-ID: <4763891A.3010004@gmail.com>
Date: Sat, 15 Dec 2007 08:58:18 +0100
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, "David P. Reed" <dpreed@reed.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Rene Herman <rene.herman@keyaccess.nl>,
       Pavel Machek <pavel@ucw.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
 on some AMD64x2 laptops, etc.
References: <469578CD.3080609@reed.com> <1184216528.12353.203.camel@chaos> <1184218962.12353.209.camel@chaos> <46964352.7040301@reed.com> <1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <20071214131502.GA14359@elte.hu> <4762C551.5070003@zytor.com> <20071215074358.GD12110@elte.hu>
In-Reply-To: <20071215074358.GD12110@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------050101030200010309050201"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050101030200010309050201
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 15-12-07 08:43, Ingo Molnar wrote:

> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> I believe this will suffer from the issue that was raised: this will 
>> use udelay() long before loop calibration (and no, we can't just "be 
>> conservative" since there is no "conservative" value we can use.)
>>
>> Worse, I suspect that at least the PIT, which may need to be used for 
>> udelay calibration, is one of the devices that may be affected.  I 
>> have seen the Verilog for a contemporary chipset, and it can only 
>> access the PIT once per microsecond -- this actually has to do with 
>> the definition of the PIT; some of the PIT operations are ill-defined 
>> if allowed at a higher frequency than the PIT clock.
> 
> i think the native_io_delay() in quirks.c signals the obvious solution: 
> a DMI (or otherwise) driven quirk that activates a port 0x80 based delay 
> on such boards. Combined with an iodelay=port80 boot option as well 
> perhaps, just in case someone hits a system that is not blacklisted yet. 
> This way such crazy broken hardware can be mapped correctly - like we 
> map such quirks in every other case. Perhaps even do this workaround on 
> the PIT driver level. Instead of perpetuating the superstition of port 
> 80 forever.

The issue is -- how do you safely replace the outb pre-loops_per_jiffy 
calibration? I'm currently running with the attached hack (not submitted, 
only for 32-bit and discussion) the idea of which might be the best we can do?

(And the broken is the hardware that can't take writes to port 0x80, not the 
other way around. It's a well-known legacy PC thing).

Rene.


--------------050101030200010309050201
Content-Type: text/plain;
 name="native_io_delay-switch.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="native_io_delay-switch.diff"

diff --git a/arch/x86/boot/compressed/misc_32.c b/arch/x86/boot/compressed/misc_32.c
index b74d60d..288e162 100644
--- a/arch/x86/boot/compressed/misc_32.c
+++ b/arch/x86/boot/compressed/misc_32.c
@@ -276,10 +276,10 @@ static void putstr(const char *s)
 	RM_SCREEN_INFO.orig_y = y;
 
 	pos = (x + cols * y) * 2;	/* Update cursor position */
-	outb_p(14, vidport);
-	outb_p(0xff & (pos >> 9), vidport+1);
-	outb_p(15, vidport);
-	outb_p(0xff & (pos >> 1), vidport+1);
+	outb(14, vidport);
+	outb(0xff & (pos >> 9), vidport+1);
+	outb(15, vidport);
+	outb(0xff & (pos >> 1), vidport+1);
 }
 
 static void* memset(void* s, int c, unsigned n)
diff --git a/arch/x86/kernel/time_32.c b/arch/x86/kernel/time_32.c
index 8a322c9..c95d313 100644
--- a/arch/x86/kernel/time_32.c
+++ b/arch/x86/kernel/time_32.c
@@ -222,6 +222,19 @@ void __init hpet_time_init(void)
 	time_init_hook();
 }
 
+static void port_io_delay(void)
+{
+	asm volatile ("outb %%al, $0x80": : : "memory");
+}
+
+static void udelay_io_delay(void)
+{
+	udelay(2);
+}
+
+void (*native_io_delay)(void) = port_io_delay;
+EXPORT_SYMBOL(native_io_delay);
+
 /*
  * This is called directly from init code; we must delay timer setup in the
  * HPET case as we can't make the decision to turn on HPET this early in the
@@ -233,5 +246,7 @@ void __init hpet_time_init(void)
 void __init time_init(void)
 {
 	tsc_init();
+	if (!tsc_disable)
+		native_io_delay = udelay_io_delay;
 	late_time_init = choose_time_init();
 }
diff --git a/include/asm-x86/io_32.h b/include/asm-x86/io_32.h
index fe881cd..1b73f49 100644
--- a/include/asm-x86/io_32.h
+++ b/include/asm-x86/io_32.h
@@ -250,10 +250,7 @@ static inline void flush_write_buffers(void)
 
 #endif /* __KERNEL__ */
 
-static inline void native_io_delay(void)
-{
-	asm volatile("outb %%al,$0x80" : : : "memory");
-}
+extern void (*native_io_delay)(void);
 
 #if defined(CONFIG_PARAVIRT)
 #include <asm/paravirt.h>

--------------050101030200010309050201--
