Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbZH3T5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbZH3T5g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 15:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbZH3T5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 15:57:35 -0400
Received: from poutre.nerim.net ([62.4.16.124]:49798 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897AbZH3T5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 15:57:35 -0400
Date: Sun, 30 Aug 2009 21:57:35 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Petr Vandrovec <vandrove@vc.cvut.cz>
Subject: [PATCH 5/5] matroxfb: Get rid of CONFIG_FB_MATROX_32MB
Message-ID: <20090830215735.77194bfc@hyperion.delvare>
In-Reply-To: <20090830215059.0fae63c3@hyperion.delvare>
References: <20090830215059.0fae63c3@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_FB_MATROX_32MB is always enabled, so there is no point in
having ifdefs all around. And it is bad practice to use CONFIG_*
as a name for something which is not a Kconfig option.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Petr Vandrovec <vandrove@vc.cvut.cz>
---
 drivers/video/matrox/matroxfb_DAC1064.c |    2 --
 drivers/video/matrox/matroxfb_base.c    |   12 ------------
 drivers/video/matrox/matroxfb_base.h    |    5 -----
 3 files changed, 19 deletions(-)

--- linux-2.6.31-rc5.orig/drivers/video/matrox/matroxfb_DAC1064.c	2009-08-03 17:19:20.000000000 +0200
+++ linux-2.6.31-rc5/drivers/video/matrox/matroxfb_DAC1064.c	2009-08-03 21:42:21.000000000 +0200
@@ -1080,10 +1080,8 @@ static void MGAG100_restore(struct matro
 
 	DAC1064_restore_1(minfo);
 	matroxfb_vgaHWrestore(minfo);
-#ifdef CONFIG_FB_MATROX_32MB
 	if (minfo->devflags.support32MB)
 		mga_setr(M_EXTVGA_INDEX, 8, hw->CRTCEXT[8]);
-#endif
 	minfo->crtc1.panpos = -1;
 	for (i = 0; i < 6; i++)
 		mga_setr(M_EXTVGA_INDEX, i, hw->CRTCEXT[i]);
--- linux-2.6.31-rc5.orig/drivers/video/matrox/matroxfb_base.c	2009-08-03 17:49:55.000000000 +0200
+++ linux-2.6.31-rc5/drivers/video/matrox/matroxfb_base.c	2009-08-03 21:42:21.000000000 +0200
@@ -310,9 +310,7 @@ static void matrox_pan_var(struct matrox
 {
 	unsigned int pos;
 	unsigned short p0, p1, p2;
-#ifdef CONFIG_FB_MATROX_32MB
 	unsigned int p3;
-#endif
 	int vbl;
 	unsigned long flags;
 
@@ -330,9 +328,7 @@ static void matrox_pan_var(struct matrox
 	p0 = minfo->hw.CRTC[0x0D] = pos & 0xFF;
 	p1 = minfo->hw.CRTC[0x0C] = (pos & 0xFF00) >> 8;
 	p2 = minfo->hw.CRTCEXT[0] = (minfo->hw.CRTCEXT[0] & 0xB0) | ((pos >> 16) & 0x0F) | ((pos >> 14) & 0x40);
-#ifdef CONFIG_FB_MATROX_32MB
 	p3 = minfo->hw.CRTCEXT[8] = pos >> 21;
-#endif
 
 	/* FB_ACTIVATE_VBL and we can acquire interrupts? Honor FB_ACTIVATE_VBL then... */
 	vbl = (var->activate & FB_ACTIVATE_VBL) && (matroxfb_enable_irq(minfo, 0) == 0);
@@ -342,10 +338,8 @@ static void matrox_pan_var(struct matrox
 	matroxfb_DAC_lock_irqsave(flags);
 	mga_setr(M_CRTC_INDEX, 0x0D, p0);
 	mga_setr(M_CRTC_INDEX, 0x0C, p1);
-#ifdef CONFIG_FB_MATROX_32MB
 	if (minfo->devflags.support32MB)
 		mga_setr(M_EXTVGA_INDEX, 0x08, p3);
-#endif
 	if (vbl) {
 		minfo->crtc1.panpos = p2;
 	} else {
@@ -1360,13 +1354,9 @@ static struct video_board vbMystique		=
 #ifdef CONFIG_FB_MATROX_G
 static struct video_board vbG100		= {0x0800000, 0x0800000, FB_ACCEL_MATROX_MGAG100,	&matrox_G100};
 static struct video_board vbG200		= {0x1000000, 0x1000000, FB_ACCEL_MATROX_MGAG200,	&matrox_G100};
-#ifdef CONFIG_FB_MATROX_32MB
 /* from doc it looks like that accelerator can draw only to low 16MB :-( Direct accesses & displaying are OK for
    whole 32MB */
 static struct video_board vbG400		= {0x2000000, 0x1000000, FB_ACCEL_MATROX_MGAG400,	&matrox_G100};
-#else
-static struct video_board vbG400		= {0x2000000, 0x1000000, FB_ACCEL_MATROX_MGAG400,	&matrox_G100};
-#endif
 #endif
 
 #define DEVF_VIDEO64BIT		0x0001
@@ -1646,9 +1636,7 @@ static int initMatrox2(struct matrox_fb_
 		minfo->devflags.textmode = 1;
 		minfo->devflags.text_type_aux = FB_AUX_TEXT_MGA_STEP8;
 	}
-#ifdef CONFIG_FB_MATROX_32MB
 	minfo->devflags.support32MB = (b->flags & DEVF_SUPPORT32MB) != 0;
-#endif
 	minfo->devflags.precise_width = !(b->flags & DEVF_ANY_VXRES);
 	minfo->devflags.crtc2 = (b->flags & DEVF_CRTC2) != 0;
 	minfo->devflags.maven_capable = (b->flags & DEVF_MAVEN_CAPABLE) != 0;
--- linux-2.6.31-rc5.orig/drivers/video/matrox/matroxfb_base.h	2009-08-03 17:49:55.000000000 +0200
+++ linux-2.6.31-rc5/drivers/video/matrox/matroxfb_base.h	2009-08-03 21:42:21.000000000 +0200
@@ -54,9 +54,6 @@
 #include "../macmodes.h"
 #endif
 
-/* always compile support for 32MB... It cost almost nothing */
-#define CONFIG_FB_MATROX_32MB
-
 #ifdef MATROXFB_DEBUG
 
 #define DEBUG
@@ -464,9 +461,7 @@ struct matrox_fb_info {
 		int		nopciretry;
 		int		noinit;
 		int		sgram;
-#ifdef CONFIG_FB_MATROX_32MB
 		int		support32MB;
-#endif
 
 		int		accelerator;
 		int		text_type_aux;

-- 
Jean Delvare
