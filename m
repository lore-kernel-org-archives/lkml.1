Return-Path: <linux-kernel-owner+w=401wt.eu-S1758541AbZEVVGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758541AbZEVVGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 17:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757664AbZEVVEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 17:04:48 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:39207 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757180AbZEVVEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 17:04:46 -0400
Message-Id: <30fbcabcfc859e6713b5a7ab1a7ffc71a5cf4951.1243024967.git.kkeil@pingi.linux-pingi.de>
In-Reply-To: <cover.1243024967.git.kkeil@pingi.linux-pingi.de>
References: <cover.1243024967.git.kkeil@pingi.linux-pingi.de>
Subject: [mISDN PATCH v2 04/19] Fixed missing spin lock on pipeline process
From: Karsten Keil <keil@b1-systems.de>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       i4ldeveloper@listserv.isdn4linux.de
Date: Fri, 22 May 2009 23:04:47 +0200
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Eversberg <andreas@eversberg.eu>

Need to protect the complete pipeline.

Signed-off-by: Andreas Eversberg <andreas@eversberg.eu>
Signed-off-by: Karsten Keil <keil@b1-systems.de>
---
 drivers/isdn/mISDN/dsp_core.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/mISDN/dsp_core.c b/drivers/isdn/mISDN/dsp_core.c
index 1c49368..621ea9b 100644
--- a/drivers/isdn/mISDN/dsp_core.c
+++ b/drivers/isdn/mISDN/dsp_core.c
@@ -704,6 +704,8 @@ dsp_function(struct mISDNchannel *ch,  struct sk_buff *skb)
 			break;
 		}
 
+		spin_lock_irqsave(&dsp_lock, flags);
+
 		/* decrypt if enabled */
 		if (dsp->bf_enable)
 			dsp_bf_decrypt(dsp, skb->data, skb->len);
@@ -741,11 +743,11 @@ dsp_function(struct mISDNchannel *ch,  struct sk_buff *skb)
 			}
 		}
 		/* we need to process receive data if software */
-		spin_lock_irqsave(&dsp_lock, flags);
 		if (dsp->pcm_slot_tx < 0 && dsp->pcm_slot_rx < 0) {
 			/* process data from card at cmx */
 			dsp_cmx_receive(dsp, skb);
 		}
+
 		spin_unlock_irqrestore(&dsp_lock, flags);
 
 		if (dsp->rx_disabled) {
-- 
1.6.0.2

