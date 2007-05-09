Return-Path: <linux-kernel-owner+w=401wt.eu-S1757841AbXEIK2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841AbXEIK2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 06:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755997AbXEIK22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 06:28:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56411 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165AbXEIK21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 06:28:27 -0400
Subject: Re: [GIT PATCHES] V4L/DVB updates
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Rechberger Markus <mrechberger@gmail.com>
In-Reply-To: <Pine.LNX.4.64.0705090804310.12497@anakin>
References: <1177706435.5163.49.camel@localhost>
	 <Pine.LNX.4.64.0705090804310.12497@anakin>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 09 May 2007 07:27:53 -0300
Message-Id: <1178706473.9614.31.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

Em Qua, 2007-05-09 às 08:30 +0200, Geert Uytterhoeven escreveu:
> On Fri, 27 Apr 2007, Mauro Carvalho Chehab wrote:
> > A short changelog:
> > 
> >    - New drivers:
> >         ivtv driver for Hauppauge PVR series and similar boards;
> 
> Can we please have proper Kconfig dependencies instead of
> 
> | #ifdef CONFIG_LIRC_I2C
> | #  error "This driver is not compatible with the LIRC I2C kernel configuration
> | #endif /* CONFIG_LIRC_I2C */
> | 
> | #ifndef CONFIG_PCI
> | #  error "This driver requires kernel PCI support."
> | #endif /* CONFIG_PCI */
> 
> in drivers/media/video/ivtv/ivtv-driver.h? Especially a dependency on
> CONFIG_PCI would be nice (CONFIG_LIRC_I2C doesn't exist in mainline?).
> 
> | drivers/media/video/video-buf.c: In function 'videobuf_queue_pci':
> | drivers/media/video/video-buf.c:399: error: 'pci_map_sg' undeclared (first use in this function)
> 
> Probably some new driver does a select VIDEO_BUF, which overrides that
> VIDEO_BUF depends on PCI?

Can you check if the following patch would fix it? VIDEO_BUF is selected
by several PCI-dependent devices. The only non-PCI device wrongly
selecting VIDEO_BUF seems to be em28xx.

If the fixes are ok, I'll later add on my -git tree and ask Linus to
pull.

Cheers,
Mauro

---

 linux/drivers/media/video/em28xx/Kconfig     |    1 -
 linux/drivers/media/video/ivtv/Kconfig       |    2 +-
 linux/drivers/media/video/ivtv/ivtv-driver.h |    8 --------
 3 files changed, 1 insertion(+), 10 deletions(-)

diff -r 8b431c3f669b -r ccd4eeca9037 linux/drivers/media/video/ivtv/Kconfig
--- a/linux/drivers/media/video/ivtv/Kconfig	Tue May 08 23:19:22 2007 -0300
+++ b/linux/drivers/media/video/ivtv/Kconfig	Wed May 09 07:00:00 2007 -0300
@@ -1,6 +1,6 @@ config VIDEO_IVTV
 config VIDEO_IVTV
 	tristate "Conexant cx23416/cx23415 MPEG encoder/decoder support"
-	depends on VIDEO_V4L1 && VIDEO_V4L2 && USB && I2C && EXPERIMENTAL
+	depends on VIDEO_V4L1 && VIDEO_V4L2 && PCI && I2C && EXPERIMENTAL
 	select FW_LOADER
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
diff -r 8b431c3f669b -r ccd4eeca9037 linux/drivers/media/video/ivtv/ivtv-driver.h
--- a/linux/drivers/media/video/ivtv/ivtv-driver.h	Tue May 08 23:19:22 2007 -0300
+++ b/linux/drivers/media/video/ivtv/ivtv-driver.h	Wed May 09 07:00:00 2007 -0300
@@ -69,14 +69,6 @@
 /* #define HAVE_XC3028 1 */
 
 #include <media/ivtv.h>
-
-#ifdef CONFIG_LIRC_I2C
-#  error "This driver is not compatible with the LIRC I2C kernel configuration option."
-#endif /* CONFIG_LIRC_I2C */
-
-#ifndef CONFIG_PCI
-#  error "This driver requires kernel PCI support."
-#endif /* CONFIG_PCI */
 
 #define IVTV_ENCODER_OFFSET	0x00000000
 #define IVTV_ENCODER_SIZE	0x00800000	/* Last half isn't needed 0x01000000 */

diff -r ccd4eeca9037 -r 589fa7f7b695 linux/drivers/media/video/em28xx/Kconfig
--- a/linux/drivers/media/video/em28xx/Kconfig	Wed May 09 07:00:00 2007 -0300
+++ b/linux/drivers/media/video/em28xx/Kconfig	Wed May 09 07:06:23 2007 -0300
@@ -1,7 +1,6 @@ config VIDEO_EM28XX
 config VIDEO_EM28XX
 	tristate "Empia EM2800/2820/2840 USB video capture support"
 	depends on VIDEO_V4L1 && I2C
-	select VIDEO_BUF
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select VIDEO_IR

-- 
Cheers,
Mauro

