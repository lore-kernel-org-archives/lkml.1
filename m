Return-Path: <linux-kernel-owner+w=401wt.eu-S1751850AbZHSULs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbZHSULs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 16:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbZHSULr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 16:11:47 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:59948 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbZHSULp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 16:11:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=m0+AHEJhoZajhEKD4Xm6X9eAxLRAY5Kqdp7Dm43dqKrJk5WlXFAgvM6K02OmenJQmw
         VWACmTSlTN+p3M8+ktHj5KsoRZBikSXiftynSAx1px+4QxExG+/wT/sECKDPCkgbjjw4
         84qCxztJqfolPPxUNQC7fxnmPdcNc+1ibtDiY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Subject: [PATCH] ali5451: remove dead code
Date: Wed, 19 Aug 2009 22:09:55 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc6-dirty; KDE/4.2.4; i686; ; )
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908192209.55701.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ali5451: remove dead code

Remove code covered by #if/endif 0 and #ifdef/endif CODEC_RESET
(CODEC_RESET is never defined).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 sound/pci/ali5451/ali5451.c |   65 --------------------------------------------
 1 file changed, 65 deletions(-)

Index: b/sound/pci/ali5451/ali5451.c
===================================================================
--- a/sound/pci/ali5451/ali5451.c
+++ b/sound/pci/ali5451/ali5451.c
@@ -477,45 +477,6 @@ static int snd_ali_reset_5451(struct snd
 	return 0;
 }
 
-#ifdef CODEC_RESET
-
-static int snd_ali_reset_codec(struct snd_ali *codec)
-{
-	struct pci_dev *pci_dev;
-	unsigned char bVal;
-	unsigned int   dwVal;
-	unsigned short wCount, wReg;
-
-	pci_dev = codec->pci_m1533;
-	
-	pci_read_config_dword(pci_dev, 0x7c, &dwVal);
-	pci_write_config_dword(pci_dev, 0x7c, dwVal | 0x08000000);
-	udelay(5000);
-	pci_read_config_dword(pci_dev, 0x7c, &dwVal);
-	pci_write_config_dword(pci_dev, 0x7c, dwVal & 0xf7ffffff);
-	udelay(5000);
-
-	bVal = inb(ALI_REG(codec,ALI_SCTRL));
-	bVal |= 0x02;
-	outb(ALI_REG(codec,ALI_SCTRL),bVal);
-	udelay(5000);
-	bVal = inb(ALI_REG(codec,ALI_SCTRL));
-	bVal &= 0xfd;
-	outb(ALI_REG(codec,ALI_SCTRL),bVal);
-	udelay(15000);
-
-	wCount = 200;
-	while (wCount--) {
-		wReg = snd_ali_codec_read(codec->ac97, AC97_POWERDOWN);
-		if ((wReg & 0x000f) == 0x000f)
-			return 0;
-		udelay(5000);
-	}
-	return -1;
-}
-
-#endif
-
 /*
  *  ALI 5451 Controller
  */
@@ -560,22 +521,6 @@ static void snd_ali_disable_address_inte
 	outl(gc, ALI_REG(codec, ALI_GC_CIR));
 }
 
-#if 0 /* not used */
-static void snd_ali_enable_voice_irq(struct snd_ali *codec,
-				     unsigned int channel)
-{
-	unsigned int mask;
-	struct snd_ali_channel_control *pchregs = &(codec->chregs);
-
-	snd_ali_printk("enable_voice_irq channel=%d\n",channel);
-	
-	mask = 1 << (channel & 0x1f);
-	pchregs->data.ainten  = inl(ALI_REG(codec, pchregs->regs.ainten));
-	pchregs->data.ainten |= mask;
-	outl(pchregs->data.ainten, ALI_REG(codec, pchregs->regs.ainten));
-}
-#endif
-
 static void snd_ali_disable_voice_irq(struct snd_ali *codec,
 				      unsigned int channel)
 {
@@ -676,16 +621,6 @@ static void snd_ali_free_channel_pcm(str
 	}
 }
 
-#if 0 /* not used */
-static void snd_ali_start_voice(struct snd_ali *codec, unsigned int channel)
-{
-	unsigned int mask = 1 << (channel & 0x1f);
-	
-	snd_ali_printk("start_voice: channel=%d\n",channel);
-	outl(mask, ALI_REG(codec,codec->chregs.regs.start));
-}
-#endif
-
 static void snd_ali_stop_voice(struct snd_ali *codec, unsigned int channel)
 {
 	unsigned int mask = 1 << (channel & 0x1f);
