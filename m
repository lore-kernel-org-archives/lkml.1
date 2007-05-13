Return-Path: <linux-kernel-owner+w=401wt.eu-S1760778AbXEMTQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760778AbXEMTQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 15:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760341AbXEMTPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 15:15:47 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:46916 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760302AbXEMTPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 15:15:46 -0400
From: muli@il.ibm.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Muli Ben-Yehuda <muli@il.ibm.com>,
       tammy000@gmail.com, bunk@stusta.de
Subject: [PATCH 2/3] OSS trident: fix locking around write_voice_regs
Date: Sun, 13 May 2007 22:15:27 +0300
Message-Id: <1179083728411-git-send-email-muli@il.ibm.com>
X-Mailer: git-send-email 1.4.4
In-Reply-To: <11790837282758-git-send-email-muli@il.ibm.com>
References: <11790837281608-git-send-email-muli@il.ibm.com> <11790837282758-git-send-email-muli@il.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Muli Ben-Yehuda <muli@il.ibm.com>

trident_write_voice_regs() was getting called with the card spinlock
held in only some cases. Fix it.

Explanation: we allocate a new virtual channel in open, and then we
frob some hardware registers (in write_voice_regs) for that
channel. But the hardware registers are shared with other channels,
which may be trying to frob the some registers (albeit for another
channel) via ioctl(SNDCTL_DSP_SPEED).

Fixed bugzilla.kernel.org bug #8172 (http://bugme.osdl.org/show_bug.cgi?id=8172)

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: tammy000@gmail.com
Cc: bunk@stusta.de
---
 sound/oss/trident.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/sound/oss/trident.c b/sound/oss/trident.c
index 3e408f4..2e3e78e 100644
--- a/sound/oss/trident.c
+++ b/sound/oss/trident.c
@@ -2702,6 +2702,7 @@ trident_open(struct inode *inode, struct
 	struct trident_card *card = devs;
 	struct trident_state *state = NULL;
 	struct dmabuf *dmabuf = NULL;
+	unsigned long flags;
 
 	/* Added by Matt Wu 01-05-2001 */
 	/* TODO: there's some redundacy here wrt the check below */
@@ -2779,7 +2780,9 @@ trident_open(struct inode *inode, struct
 			/* set default channel attribute to normal playback */
 			dmabuf->channel->attribute = CHANNEL_PB;
 		}
+		spin_lock_irqsave(&card->lock, flags);
 		trident_set_dac_rate(state, 8000);
+		spin_unlock_irqrestore(&card->lock, flags);
 	}
 
 	if (file->f_mode & FMODE_READ) {
@@ -2797,7 +2800,9 @@ trident_open(struct inode *inode, struct
 			dmabuf->channel->attribute = (CHANNEL_REC | PCM_LR |
 						      MONO_MIX);
 		}
+		spin_lock_irqsave(&card->lock, flags);
 		trident_set_adc_rate(state, 8000);
+		spin_unlock_irqrestore(&card->lock, flags);
 
 		/* Added by Matt Wu 01-05-2001 */
 		if (card->pci_id == PCI_DEVICE_ID_ALI_5451)
-- 
1.4.4

