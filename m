Return-Path: <linux-kernel-owner+w=401wt.eu-S1761688AbYB1TL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761688AbYB1TL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758472AbYB1TLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:11:21 -0500
Received: from el-out-1112.google.com ([209.85.162.181]:4689 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757683AbYB1TLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:11:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HMwiSVTIhAyhl9G7wRR1Lc350TQ7eQ18cRi3vFfQ0I53SFB0OC3ceCQkWEfd+NabYJuxL6I7zvNHFsQBrsrzpLRgGGxR5rAMFeQK2Or0rvV8wdglmsZvUGm2GF+w6D0dtGwZ5tc3GsLM4SoqzVb9y2ZvC8h8BP/gBT6Cc/XuSOY=
Subject: [PATCH 2/8] sound: emu10k1x.c fix shadowed variable warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 11:11:12 -0800
Message-Id: <1204225872.20280.80.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

enable in these contexts refers specifically to intr enable, as
per the two functions it is found in.  Use intr_enable instead.
sound/pci/emu10k1/emu10k1x.c:330:15: warning: symbol 'enable' shadows an earlier one
sound/pci/emu10k1/emu10k1x.c:53:12: originally declared here
sound/pci/emu10k1/emu10k1x.c:341:15: warning: symbol 'enable' shadows an earlier one
sound/pci/emu10k1/emu10k1x.c:53:12: originally declared here

instead of shadowing, use cap_voice as we test for the capture
voice in this statement.
sound/pci/emu10k1/emu10k1x.c:798:25: warning: symbol 'pvoice' shadows an earlier one
sound/pci/emu10k1/emu10k1x.c:787:24: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 sound/pci/emu10k1/emu10k1x.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/sound/pci/emu10k1/emu10k1x.c b/sound/pci/emu10k1/emu10k1x.c
index 5512abd..341f34e 100644
--- a/sound/pci/emu10k1/emu10k1x.c
+++ b/sound/pci/emu10k1/emu10k1x.c
@@ -327,22 +327,22 @@ static void snd_emu10k1x_ptr_write(struct emu10k1x *emu,
 static void snd_emu10k1x_intr_enable(struct emu10k1x *emu, unsigned int intrenb)
 {
 	unsigned long flags;
-	unsigned int enable;
-  
+	unsigned int intr_enable;
+
 	spin_lock_irqsave(&emu->emu_lock, flags);
-	enable = inl(emu->port + INTE) | intrenb;
-	outl(enable, emu->port + INTE);
+	intr_enable = inl(emu->port + INTE) | intrenb;
+	outl(intr_enable, emu->port + INTE);
 	spin_unlock_irqrestore(&emu->emu_lock, flags);
 }
 
 static void snd_emu10k1x_intr_disable(struct emu10k1x *emu, unsigned int intrenb)
 {
 	unsigned long flags;
-	unsigned int enable;
-  
+	unsigned int intr_enable;
+
 	spin_lock_irqsave(&emu->emu_lock, flags);
-	enable = inl(emu->port + INTE) & ~intrenb;
-	outl(enable, emu->port + INTE);
+	intr_enable = inl(emu->port + INTE) & ~intrenb;
+	outl(intr_enable, emu->port + INTE);
 	spin_unlock_irqrestore(&emu->emu_lock, flags);
 }
 
@@ -795,9 +795,9 @@ static irqreturn_t snd_emu10k1x_interrupt(int irq, void *dev_id)
 
 	// capture interrupt
 	if (status & (IPR_CAP_0_LOOP | IPR_CAP_0_HALF_LOOP)) {
-		struct emu10k1x_voice *pvoice = &chip->capture_voice;
-		if (pvoice->use)
-			snd_emu10k1x_pcm_interrupt(chip, pvoice);
+		struct emu10k1x_voice *cap_voice = &chip->capture_voice;
+		if (cap_voice->use)
+			snd_emu10k1x_pcm_interrupt(chip, cap_voice);
 		else
 			snd_emu10k1x_intr_disable(chip, 
 						  INTE_CAP_0_LOOP |
-- 
1.5.4.3.342.g99e8


