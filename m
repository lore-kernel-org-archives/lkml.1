Return-Path: <linux-kernel-owner+w=401wt.eu-S1756291AbYABPxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291AbYABPxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 10:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbYABPxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 10:53:15 -0500
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:41075 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbYABPxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 10:53:14 -0500
Message-ID: <477BB2BC.6090203@keyaccess.nl>
Date: Wed, 02 Jan 2008 16:50:20 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ingo Molnar <mingo@elte.hu>, "David P. Reed" <dpreed@reed.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Rene Herman <rene.herman@gmail.com>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <47667366.7010405@gmail.com>	<4766AE88.4080904@zytor.com>	<4766D175.7040807@reed.com>	<20071217212509.5edaa372@the-village.bc.nu>	<477A634C.8040000@reed.com>	<20080101161557.3ce2d5f8@the-village.bc.nu>	<20080101164338.GA901@elte.hu>	<20080101173212.1bba4939@the-village.bc.nu>	<20080101184524.GA6655@elte.hu>	<20080101210734.03414931@the-village.bc.nu>	<20080102100436.GB4389@elte.hu> <20080102134738.2d4c7464@the-village.bc.nu> <477BAF37.2020005@keyaccess.nl>
In-Reply-To: <477BAF37.2020005@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02-01-08 16:35, Rene Herman wrote:
 > On 02-01-08 14:47, Alan Cox wrote:
 >
 >>> ok, you are right. How about we go with one of your suggestions:
 >>> rename the API family to isa_*_p() in the affected ISA drivers? That
 >>> makes it perfectly clear that this is an ISA related historic quirk
 >>> that we just cannot properly emulate in an acceptable fashion. It
 >>> will also make the least amount of changes to these truly historic
 >>> drivers.
 >>
 >> Works for me. We need to build two versions of 8390.c now but thats no
 >> big deal and sorts PCMCIA out too.
 >
 > For no binary changes at all, and if going through all those outb_p()
 > users anyway, might/could as well just manually split them then:
 >
 > outb_p() --> outb();
 >              slow_down_io();
 >
 > and then just leave out the slow_down_io() call in the non-ISA spots.
 > slow_down_io() could be renamed isa_io_delay() or anything (paravirt is
 > a little annoying there) if someone cares but then it's a complete
 > identity transformation for any driver that does care.
 >
 > Would IMO also make for a somewhat better API than an isa_outb_p() as
 > there's nothing particurly ISA about the outb method itself -- many ISA
 > drivers use plain outb() as well.

Would just need this bit of io.h arch unification from the orignal patch and 
that's it:

diff --git a/include/asm-x86/io_64.h b/include/asm-x86/io_64.h
index a037b07..97cb8c6 100644
--- a/include/asm-x86/io_64.h
+++ b/include/asm-x86/io_64.h
@@ -35,13 +35,20 @@
    *  - Arnaldo Carvalho de Melo <acme@conectiva.com.br>
    */

-#define __SLOW_DOWN_IO "\noutb %%al,$0x80"
+static inline void native_io_delay(void)
+{
+	asm volatile("outb %%al,$0x80" : : : "memory");
+}

+static inline void slow_down_io(void)
+{
+	native_io_delay();
  #ifdef REALLY_SLOW_IO
-#define __FULL_SLOW_DOWN_IO __SLOW_DOWN_IO __SLOW_DOWN_IO __SLOW_DOWN_IO 
__SLOW_DOWN_IO
-#else
-#define __FULL_SLOW_DOWN_IO __SLOW_DOWN_IO
+	native_io_delay();
+	native_io_delay();
+	native_io_delay();
  #endif
+}

  /*
   * Talk about misusing macros..
@@ -50,21 +57,21 @@
  static inline void out##s(unsigned x value, unsigned short port) {

  #define __OUT2(s,s1,s2) \
-__asm__ __volatile__ ("out" #s " %" s1 "0,%" s2 "1"
+__asm__ __volatile__ ("out" #s " %" s1 "0,%" s2 "1" : : "a" (value), "Nd" 
(port))

  #define __OUT(s,s1,x) \
-__OUT1(s,x) __OUT2(s,s1,"w") : : "a" (value), "Nd" (port)); } \
-__OUT1(s##_p,x) __OUT2(s,s1,"w") __FULL_SLOW_DOWN_IO : : "a" (value), "Nd" 
(port));} \
+__OUT1(s,x) __OUT2(s,s1,"w"); } \
+__OUT1(s##_p,x) __OUT2(s,s1,"w"); slow_down_io(); }

  #define __IN1(s) \
  static inline RETURN_TYPE in##s(unsigned short port) { RETURN_TYPE _v;

  #define __IN2(s,s1,s2) \
-__asm__ __volatile__ ("in" #s " %" s2 "1,%" s1 "0"
+__asm__ __volatile__ ("in" #s " %" s2 "1,%" s1 "0" : "=a" (_v) : "Nd" (port))

-#define __IN(s,s1,i...) \
-__IN1(s) __IN2(s,s1,"w") : "=a" (_v) : "Nd" (port) ,##i ); return _v; } \
-__IN1(s##_p) __IN2(s,s1,"w") __FULL_SLOW_DOWN_IO : "=a" (_v) : "Nd" (port) 
,##i ); return _v; } \
+#define __IN(s,s1) \
+__IN1(s) __IN2(s,s1,"w"); return _v; } \
+__IN1(s##_p) __IN2(s,s1,"w"); slow_down_io(); return _v; }

  #define __INS(s) \
  static inline void ins##s(unsigned short port, void * addr, unsigned long 
count) \

