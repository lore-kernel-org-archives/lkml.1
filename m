Return-Path: <linux-kernel-owner+w=401wt.eu-S1763133AbXLNJrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763133AbXLNJrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 04:47:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbXLNJrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 04:47:35 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:20783 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbXLNJrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 04:47:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type;
        b=RDZKGBiQdqEwOohyyiLIPkDxSs1LJ9UqAofDUQSzFlFLGXD7RVgNUqphLhZ9/IWqW6C7c+salefAKjFtJZyLKdr57MfkdPWwfCEaQDYkRIsXbX1GeA30joYlN2g5CSvlnu5L+ipXVHoaVeWhYvC1lEQjYnx9rSgGAFZHyM1ord8=
Message-ID: <476250D5.8000409@gmail.com>
Date: Fri, 14 Dec 2007 10:45:57 +0100
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "David P. Reed" <dpreed@reed.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
 on some AMD64x2 laptops, etc.
References: <466F0941.9060201@reed.com> <1181682498.8176.224.camel@chaos>	 <469578CD.3080609@reed.com>  <1184216528.12353.203.camel@chaos>	 <1184218962.12353.209.camel@chaos>  <46964352.7040301@reed.com>	 <1184253339.12353.223.camel@chaos>  <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com>
In-Reply-To: <4761F193.7090400@reed.com>
Content-Type: multipart/mixed;
 boundary="------------060404040108070207030406"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060404040108070207030406
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 14-12-07 03:59, David P. Reed wrote:

> Replace use of outb to "unused" diagnostic port 0x80 for time delay
> with udelay based time delay on x86_64 architecture machines.  Fix for
> bugs 9511 and 6307 in bugzilla, plus bugs reported in
> bugzilla.redhat.com.
> 
> Derived from suggestion (that didn't compile) by Pavel Machek, and
> tested, also based on measurements of typical timings of out's
> collated by Rene Herman from many in the community.
> 
> This patch fixes a number of bugs known to cause problems on HP
> Pavilion dv9000z and dv6000z laptops - in the form of solid freezes
> when hwclock is used to show or set the time.  Also, it potentially
> improves bus utilization on SMP machines, by using a waiting process
> that doesn't tie up the ISA/LPC bus for 1 or 2 microseconds.
> 
> i386 family fixes (completely parallel) were not included, considering
> that such machines might involve more risk of problems on legacy machines.

Here's the corresponding 32-bit patch. Applies fine to (and works on) 
v2.6.23.x as well after un-uniting the paths...

I do believe it would be better to do both; x86-64 machines can run 32-bit 
kernels fine and might certainly in the form of generic (installer) kernels 
and the like so if it's a fix lets fix it across the board -- the 2 us delay 
is going to be enough for everything out there, certainly given that _0_ is 
normally enough. With the arches just merged, minimising diferences should 
be a goal in itself I guess.

One thing though -- I believe we want to adjust the loops_per_jiffy default 
to make sure this works, or would work, pre-calibration as well? Not really 
sure how needed it is, but bogomips is defined as

	bogomips = loops_per_jiffy / (500000 / HZ)
			<=>
	loops_per_jiffy = bogomips * (500000 / HZ)

which with assuming any machine above 1G isn't affected by any of this and 
bogomips coming out to 2 * MHz on anything I myself have run linux on might 
suggest that

	loops_per_jiffy = 2 * 1000 * (500000 / HZ) = 1000000000 / HZ

could possibly be a sane if very large default? Alan?

diff --git a/init/main.c b/init/main.c
index 9def935..6d41771 100644
--- a/init/main.c
+++ b/init/main.c
@@ -229,10 +229,9 @@ static int __init obsolete_checksetup(char *line)
  }

  /*
- * This should be approx 2 Bo*oMips to start (note initial shift), and will
- * still work even if initially too large, it will just take slightly longer
+ * Initial value roughly corresponds to a 1 GHz CPU
   */
-unsigned long loops_per_jiffy = (1<<12);
+unsigned long loops_per_jiffy = 1000000000 / HZ;

  EXPORT_SYMBOL(loops_per_jiffy);

--------------060404040108070207030406
Content-Type: text/plain;
 name="v24-port80.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="v24-port80.diff"

From: Pavel Machek <pavel@ucw.cz>

32-bit part of the port 0x80 delay replacement.

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
diff --git a/include/asm-x86/io_32.h b/include/asm-x86/io_32.h
index fe881cd..9abc215 100644
--- a/include/asm-x86/io_32.h
+++ b/include/asm-x86/io_32.h
@@ -3,6 +3,7 @@
 
 #include <linux/string.h>
 #include <linux/compiler.h>
+#include <linux/delay.h>
 
 /*
  * This file contains the definitions for the x86 IO instructions
@@ -17,17 +18,6 @@
  * mistake somewhere.
  */
 
-/*
- * Thanks to James van Artsdalen for a better timing-fix than
- * the two short jumps: using outb's to a nonexistent port seems
- * to guarantee better timings even on fast machines.
- *
- * On the other hand, I'd like to be sure of a non-existent port:
- * I feel a bit unsafe about using 0x80 (should be safe, though)
- *
- *		Linus
- */
-
  /*
   *  Bit simplified and optimized by Jan Hubicka
   *  Support of BIGMEM added by Gerhard Wichert, Siemens AG, July 1999.
@@ -252,7 +242,7 @@ static inline void flush_write_buffers(void)
 
 static inline void native_io_delay(void)
 {
-	asm volatile("outb %%al,$0x80" : : : "memory");
+	udelay(2);
 }
 
 #if defined(CONFIG_PARAVIRT)

--------------060404040108070207030406--
