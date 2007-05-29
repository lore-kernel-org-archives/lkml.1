Return-Path: <linux-kernel-owner+w=401wt.eu-S1752504AbXE2ViW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbXE2ViW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 17:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751135AbXE2ViP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 17:38:15 -0400
Received: from smtp103.sbc.mail.mud.yahoo.com ([68.142.198.202]:44830 "HELO
	smtp103.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751119AbXE2ViO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 17:38:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=aBbHtTdaco+0/bRXYyyPDWFDagcu1tY/sdbTTjOdkabea37ZGl8tTDYcklmNOkXCvMxzo3nFp9Y4PqSVgkP9y8XL4clTy6Ie5HhI9KZMK1uG9sKhmP1O2FyYATBW1UGMto+6x1lBVtbesQyc9bTKss19vG/C9ogeJULgSFQHYqQ=  ;
X-YMail-OSG: PghXp0EVM1ndvqU0Q8VW6ja0NbqE0GXFo7aPpyvTI796gKKUyKicOh8Uz1cHyuObvGoPdg.MfA--
From: David Brownell <david-b@pacbell.net>
To: Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] Samsung LTV350QV LCD driver
Date: Tue, 29 May 2007 14:38:11 -0700
User-Agent: KMail/1.9.6
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>, linux-kernel@vger.kernel.org
References: <11804683571524-git-send-email-hskinnemoen@atmel.com> <1180472477.5822.87.camel@localhost.localdomain>
In-Reply-To: <1180472477.5822.87.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705291438.11581.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 May 2007, Richard Purdie wrote:
> On Tue, 2007-05-29 at 21:52 +0200, Haavard Skinnemoen wrote:
> > This patch adds support for powering on and off the Samsung LTV350QV
> > LCD panel via SPI. The driver responds to framebuffer power
> > management, it powers off the panel on reboot/halt/poweroff, and it
> > can also be controlled through sysfs. The panel is powered up when the
> > module is loaded and off when the module is unloaded.
> > 
> > Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
> 
> The LCD class device bits look fine to me. The only change I'd request
> is not to change the order of things in drivers/video/backlight/Kconfig.
> If you do want to reword one of those entries (which is what I think you
> wanted to do), send it as a separate patch please.

One significant issue was screwed up sequencing causing
tools like 'xconfig' to display things wrong.  Appended
is a patch fixing just that goof.


> David, any objections to the SPI bits?

They seemed fine to me, other than the write_reg() macro
having an embedded 'goto' ... explicitly against the
Documentation/CodingStyle guidelines.  ("Chapter 12",
point 1 = "macros that affect code flow".)

I like seeing more of the SPI drivers go upstream.  ;)

- Dave



> 
> Richard
> 


======	CUT HERE
Switch the order of LCD_CLASS_DEVICE and BACKLIGHT_CLASS_DEVICE,
so that it's possible to insert LCD devices without borking the
dependency displays of xconfig and other config tools.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/video/backlight/Kconfig |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- g26.orig/drivers/video/backlight/Kconfig	2007-05-29 14:31:41.000000000 -0700
+++ g26/drivers/video/backlight/Kconfig	2007-05-29 14:33:29.000000000 -0700
@@ -8,26 +8,32 @@ menuconfig BACKLIGHT_LCD_SUPPORT
 	  Enable this to be able to choose the drivers for controlling the
 	  backlight and the LCD panel on some platforms, for example on PDAs.
 
-config BACKLIGHT_CLASS_DEVICE
-        tristate "Lowlevel Backlight controls"
+#
+# LCD
+#
+config LCD_CLASS_DEVICE
+        tristate "Lowlevel LCD controls"
 	depends on BACKLIGHT_LCD_SUPPORT
 	default m
 	help
-	  This framework adds support for low-level control of the LCD
-          backlight. This includes support for brightness and power.
+	  This framework adds support for low-level control of LCD.
+	  Some framebuffer devices connect to platform-specific LCD modules
+	  in order to have a platform-specific way to control the flat panel
+	  (contrast and applying power to the LCD (not to the backlight!)).
 
 	  To have support for your specific LCD panel you will have to
 	  select the proper drivers which depend on this option.
 
-config LCD_CLASS_DEVICE
-        tristate "Lowlevel LCD controls"
+#
+# Backlight
+#
+config BACKLIGHT_CLASS_DEVICE
+        tristate "Lowlevel Backlight controls"
 	depends on BACKLIGHT_LCD_SUPPORT
 	default m
 	help
-	  This framework adds support for low-level control of LCD.
-	  Some framebuffer devices connect to platform-specific LCD modules
-	  in order to have a platform-specific way to control the flat panel
-	  (contrast and applying power to the LCD (not to the backlight!)).
+	  This framework adds support for low-level control of the LCD
+          backlight. This includes support for brightness and power.
 
 	  To have support for your specific LCD panel you will have to
 	  select the proper drivers which depend on this option.
