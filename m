Return-Path: <linux-kernel-owner+w=401wt.eu-S1754253AbZESPu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbZESPu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 11:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbZESPuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 11:50:50 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:48868 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbZESPut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 11:50:49 -0400
Message-Id: <b11d200065c0ad2a8feca4412093c07844c71451.1242739648.git.kkeil@pingi.linux-pingi.de>
In-Reply-To: <cover.1242739648.git.kkeil@pingi.linux-pingi.de>
References: <cover.1242739648.git.kkeil@pingi.linux-pingi.de>
Subject: [PATCH 08/19] Fixed missing spin lock on pipeline process
From: Karsten Keil <keil@b1-systems.de>
To: linux-kernel@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       i4ldeveloper@listserv.isdn4linux.de
Date: Tue, 19 May 2009 15:58:28 +0200
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
index e4ddd80..d3184a0 100644
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

