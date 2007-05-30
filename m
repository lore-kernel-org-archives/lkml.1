Return-Path: <linux-kernel-owner+w=401wt.eu-S1751808AbXE3Hhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbXE3Hhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 03:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbXE3Hhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 03:37:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbXE3Hhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 03:37:39 -0400
Date: Wed, 30 May 2007 03:35:54 -0400
From: Bill Nottingham <notting@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] alsa: fix comparison of unsigned < 0
Message-ID: <20070530073554.GA28809@nostromo.devel.redhat.com>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Recent gccs emit warnings when unsigned variables are compared < 0 or >= 0.

Signed-off-by: Bill Nottingham <notting@redhat.com>

 ac97/ac97_patch.c    |    3 +--
 ali5451/ali5451.c    |    6 ++----
 ca0106/ca0106_proc.c |    4 ++--
 rme9652/rme9652.c    |    2 --
 4 files changed, 5 insertions(+), 10 deletions(-)

diff -ru linux-2.6.21-old/sound/pci/ac97/ac97_patch.c linux-2.6.21/sound/pci/ac97/ac97_patch.c
--- linux-2.6.21-old/sound/pci/ac97/ac97_patch.c	2007-05-30 02:53:05.000000000 -0400
+++ linux-2.6.21/sound/pci/ac97/ac97_patch.c	2007-05-30 02:32:41.000000000 -0400
@@ -2086,8 +2086,7 @@
 	struct snd_ac97 *ac97 = snd_kcontrol_chip(kcontrol);
 	unsigned short val;
 
-	if (ucontrol->value.enumerated.item[0] > 3
-	    || ucontrol->value.enumerated.item[0] < 0)
+	if (ucontrol->value.enumerated.item[0] > 3)
 		return -EINVAL;
 	val = ctrl2reg[ucontrol->value.enumerated.item[0]]
 	      << AC97_AD198X_VREF_SHIFT;
diff -ru linux-2.6.21-old/sound/pci/ali5451/ali5451.c linux-2.6.21/sound/pci/ali5451/ali5451.c
--- linux-2.6.21-old/sound/pci/ali5451/ali5451.c	2007-05-30 02:53:05.000000000 -0400
+++ linux-2.6.21/sound/pci/ali5451/ali5451.c	2007-05-30 02:33:27.000000000 -0400
@@ -2057,10 +2057,8 @@
 {
 	if (codec->hw_initialized)
 		snd_ali_disable_address_interrupt(codec);
-	if (codec->irq >= 0) {
-		synchronize_irq(codec->irq);
-		free_irq(codec->irq, codec);
-	}
+	synchronize_irq(codec->irq);
+	free_irq(codec->irq, codec);
 	if (codec->port)
 		pci_release_regions(codec->pci);
 	pci_disable_device(codec->pci);
diff -ru linux-2.6.21-old/sound/pci/ca0106/ca0106_proc.c linux-2.6.21/sound/pci/ca0106/ca0106_proc.c
--- linux-2.6.21-old/sound/pci/ca0106/ca0106_proc.c	2007-05-30 02:53:05.000000000 -0400
+++ linux-2.6.21/sound/pci/ca0106/ca0106_proc.c	2007-05-30 02:34:19.000000000 -0400
@@ -305,7 +305,7 @@
         while (!snd_info_get_line(buffer, line, sizeof(line))) {
                 if (sscanf(line, "%x %x", &reg, &val) != 2)
                         continue;
-                if ((reg < 0x40) && (reg >=0) && (val <= 0xffffffff) ) {
+                if ((reg < 0x40) && (val <= 0xffffffff) ) {
 			spin_lock_irqsave(&emu->emu_lock, flags);
 			outl(val, emu->port + (reg & 0xfffffffc));
 			spin_unlock_irqrestore(&emu->emu_lock, flags);
@@ -406,7 +406,7 @@
         while (!snd_info_get_line(buffer, line, sizeof(line))) {
                 if (sscanf(line, "%x %x %x", &reg, &channel_id, &val) != 3)
                         continue;
-                if ((reg < 0x80) && (reg >=0) && (val <= 0xffffffff) && (channel_id >=0) && (channel_id <= 3) )
+                if ((reg < 0x80) && (val <= 0xffffffff) && (channel_id <= 3) )
                         snd_ca0106_ptr_write(emu, reg, channel_id, val);
         }
 }
diff -ru linux-2.6.21-old/sound/pci/rme9652/rme9652.c linux-2.6.21/sound/pci/rme9652/rme9652.c
--- linux-2.6.21-old/sound/pci/rme9652/rme9652.c	2007-05-30 02:53:05.000000000 -0400
+++ linux-2.6.21/sound/pci/rme9652/rme9652.c	2007-05-30 02:35:16.000000000 -0400
@@ -406,8 +406,6 @@
 		} else if (!frag)
 			return 0;
 		offset -= rme9652->max_jitter;
-		if (offset < 0)
-			offset += period_size * 2;
 	} else {
 		if (offset > period_size + rme9652->max_jitter) {
 			if (!frag)
