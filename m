Return-Path: <linux-kernel-owner+w=401wt.eu-S933626AbXJRRuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933626AbXJRRuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 13:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762866AbXJRRul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 13:50:41 -0400
Received: from ns2.suse.de ([195.135.220.15]:59915 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759775AbXJRRuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 13:50:39 -0400
Date: Thu, 18 Oct 2007 19:50:37 +0200
From: Karsten Keil <kkeil@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de
Subject: [PATCH] [ISDN]Fix random hard freeze with AVM cards using b1dma
Message-ID: <20071018175037.GB12773@pingi.kke.suse.de>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.53-0.16-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This fix the hard freeze debuged for AVM C4 cards using
the b1dma interface.

Signed-off-by: Karsten Keil <kkeil@suse.de>
---
 drivers/isdn/hardware/avm/b1dma.c |   28 +++++++++++++++++++---------
 1 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/isdn/hardware/avm/b1dma.c b/drivers/isdn/hardware/avm/b1dma.c
index 428872b..a40997b 100644
--- a/drivers/isdn/hardware/avm/b1dma.c
+++ b/drivers/isdn/hardware/avm/b1dma.c
@@ -486,11 +486,13 @@ static void b1dma_handle_rx(avmcard *card)
 					card->name);
 		} else {
 			memcpy(skb_put(skb, MsgLen), card->msgbuf, MsgLen);
-			if (CAPIMSG_CMD(skb->data) == CAPI_DATA_B3_CONF)
+			if (CAPIMSG_CMD(skb->data) == CAPI_DATA_B3_CONF) {
+				spin_lock(&card->lock);
 				capilib_data_b3_conf(&cinfo->ncci_head, ApplId,
-						     CAPIMSG_NCCI(skb->data),
-						     CAPIMSG_MSGID(skb->data));
-
+					CAPIMSG_NCCI(skb->data),
+					CAPIMSG_MSGID(skb->data));
+				spin_unlock(&card->lock);
+			}
 			capi_ctr_handle_message(ctrl, ApplId, skb);
 		}
 		break;
@@ -500,9 +502,9 @@ static void b1dma_handle_rx(avmcard *card)
 		ApplId = _get_word(&p);
 		NCCI = _get_word(&p);
 		WindowSize = _get_word(&p);
-
+		spin_lock(&card->lock);
 		capilib_new_ncci(&cinfo->ncci_head, ApplId, NCCI, WindowSize);
-
+		spin_unlock(&card->lock);
 		break;
 
 	case RECEIVE_FREE_NCCI:
@@ -510,9 +512,11 @@ static void b1dma_handle_rx(avmcard *card)
 		ApplId = _get_word(&p);
 		NCCI = _get_word(&p);
 
-		if (NCCI != 0xffffffff)
+		if (NCCI != 0xffffffff) {
+			spin_lock(&card->lock);
 			capilib_free_ncci(&cinfo->ncci_head, ApplId, NCCI);
-
+			spin_unlock(&card->lock);
+		}
 		break;
 
 	case RECEIVE_START:
@@ -751,10 +755,10 @@ void b1dma_reset_ctr(struct capi_ctr *ctrl)
 
 	spin_lock_irqsave(&card->lock, flags);
  	b1dma_reset(card);
-	spin_unlock_irqrestore(&card->lock, flags);
 
 	memset(cinfo->version, 0, sizeof(cinfo->version));
 	capilib_release(&cinfo->ncci_head);
+	spin_unlock_irqrestore(&card->lock, flags);
 	capi_ctr_reseted(ctrl);
 }
 
@@ -803,8 +807,11 @@ void b1dma_release_appl(struct capi_ctr *ctrl, u16 appl)
 	avmcard *card = cinfo->card;
 	struct sk_buff *skb;
 	void *p;
+	unsigned long flags;
 
+	spin_lock_irqsave(&card->lock, flags);
 	capilib_release_appl(&cinfo->ncci_head, appl);
+	spin_unlock_irqrestore(&card->lock, flags);
 
 	skb = alloc_skb(7, GFP_ATOMIC);
 	if (!skb) {
@@ -832,10 +839,13 @@ u16 b1dma_send_message(struct capi_ctr *ctrl, struct sk_buff *skb)
 	u16 retval = CAPI_NOERROR;
 
  	if (CAPIMSG_CMD(skb->data) == CAPI_DATA_B3_REQ) {
+ 		unsigned long flags;
+		spin_lock_irqsave(&card->lock, flags);
 		retval = capilib_data_b3_req(&cinfo->ncci_head,
 					     CAPIMSG_APPID(skb->data),
 					     CAPIMSG_NCCI(skb->data),
 					     CAPIMSG_MSGID(skb->data));
+		spin_unlock_irqrestore(&card->lock, flags);
 	}
 	if (retval == CAPI_NOERROR) 
 		b1dma_queue_tx(card, skb);

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
