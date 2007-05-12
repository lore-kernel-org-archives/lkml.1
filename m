Return-Path: <linux-kernel-owner+w=401wt.eu-S1760090AbXELTgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760090AbXELTgR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 15:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757375AbXELTgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 15:36:03 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:40585 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359AbXELTgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 15:36:01 -0400
Message-ID: <4646171E.7090609@web.de>
Date: Sat, 12 May 2007 21:35:58 +0200
From: Lee Garrett <lee-in-berlin@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070329 Thunderbird/1.5.0.10 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Truxton Fulton <trux@truxton.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>
Subject: Re: [Bugme-new] [Bug 8378] New: Averatec 3156X laptop doesn't  reboot
 with kernels > 2.6.13.5 (responsible commit found)
References: <200704271742.l3RHgPTH019561@fire-2.osdl.org>	<20070427144434.970de79f.akpm@linux-foundation.org> <m2k5vx6vce.fsf@truxton.com>
In-Reply-To: <m2k5vx6vce.fsf@truxton.com>
Content-Type: multipart/mixed;
 boundary="------------010005020008080808090108"
X-Provags-ID: V01U2FsdGVkX1++A7oCUoArBOsahfm/gfVQystMFXCTkWKAcsrV
	7RGleRLG1kn4gUTuWZkhIbu2ba0fAiF87DNXQnAgxhkjYQ2j4L
	fGCtIrPQE6qee3LifL0Q==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010005020008080808090108
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Truxton Fulton wrote:
> Hi,
> 
> I verified on my IDEQ210M that performing the old reboot sequence
> followed by the new reboot sequence works for me, and I suspect that
> it will work for Lee also.  Like this :
> 
> 	/* old method, works on most machines */
>         for (i = 0; i < 100; i++) {
>                 kb_wait();
>                 udelay(50);
>                 outb(0xfe, 0x64);         /* pulse reset low */
>                 udelay(50);
>         }
> 
> 	/* new method, sets the "System flag" which when set,
> 	   indicates successful completion of the keyboard controller
> 	   self-test (Basic Assurance Test, BAT).  This is needed
> 	   for some machines with no keyboard plugged in */
>         for (i = 0; i < 100; i++) {
>                 kb_wait();
>                 udelay(50);
>                 outb(0x60, 0x64);         /* write Controller Command Byte */
>                 udelay(50);
>                 kb_wait();
>                 udelay(50);
>                 outb(0x14, 0x60);         /* set "System flag" */
>                 udelay(50);
>                 kb_wait();
>                 udelay(50);
>                 outb(0xfe, 0x64);         /* pulse reset low */
>                 udelay(50);
>         }
> 
> Thanks,
> 
> -Truxton

Hello everyone,

I compiled a 2.6.21.1 kernel with Truxton's suggestion mentioned 
above. My laptop reboots normally with it. For convenience I've 
diffed a patch, which is appended to this mail.

Regards,
Lee

--------------010005020008080808090108
Content-Type: text/x-patch;
 name="reboot-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="reboot-fix.patch"

--- a/include/asm-i386/mach-default/mach_reboot.h	2007-05-11 16:12:56.000000000 +0200
+++ b/include/asm-i386/mach-default/mach_reboot.h	2007-05-11 16:13:54.000000000 +0200
@@ -19,20 +19,32 @@
 static inline void mach_reboot(void)
 {
 	int i;
-	for (i = 0; i < 10; i++) {
-		kb_wait();
-		udelay(50);
-		outb(0x60, 0x64);	/* write Controller Command Byte */
-		udelay(50);
-		kb_wait();
-		udelay(50);
-		outb(0x14, 0x60);	/* set "System flag" */
-		udelay(50);
-		kb_wait();
-		udelay(50);
-		outb(0xfe, 0x64);	/* pulse reset low */
-		udelay(50);
-	}
+	/* old method, works on most machines */
+        for (i = 0; i < 100; i++) {
+                kb_wait();
+                udelay(50);
+                outb(0xfe, 0x64);         /* pulse reset low */
+                udelay(50);
+        }
+
+	/* new method, sets the "System flag" which when set,
+	   indicates successful completion of the keyboard controller
+	   self-test (Basic Assurance Test, BAT).  This is needed
+	   for some machines with no keyboard plugged in */
+        for (i = 0; i < 100; i++) {
+                kb_wait();
+                udelay(50);
+                outb(0x60, 0x64);         /* write Controller Command Byte */
+                udelay(50);
+                kb_wait();
+                udelay(50);
+                outb(0x14, 0x60);         /* set "System flag" */
+                udelay(50);
+                kb_wait();
+                udelay(50);
+                outb(0xfe, 0x64);         /* pulse reset low */
+                udelay(50);
+        }
 }
 
 #endif /* !_MACH_REBOOT_H */

--------------010005020008080808090108--
