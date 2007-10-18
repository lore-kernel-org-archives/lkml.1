Return-Path: <linux-kernel-owner+w=401wt.eu-S933345AbXJRRwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345AbXJRRwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 13:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758410AbXJRRwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 13:52:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:60033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757509AbXJRRwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 13:52:12 -0400
Date: Thu, 18 Oct 2007 19:52:11 +0200
From: Karsten Keil <kkeil@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de
Subject: [PATCH] [ISDN]Fix random hard freeze with AVM T1 cards
Message-ID: <20071018175210.GC12773@pingi.kke.suse.de>
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

This fix the hard freeze debuged for AVM C4 cards
for the AVM T1 cards.

Signed-off-by: Karsten Keil <kkeil@suse.de>
---
 drivers/isdn/hardware/avm/t1isa.c |   28 ++++++++++++----------------
 1 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/isdn/hardware/avm/t1isa.c b/drivers/isdn/hardware/avm/t1isa.c
index c925020..6130724 100644
--- a/drivers/isdn/hardware/avm/t1isa.c
+++ b/drivers/isdn/hardware/avm/t1isa.c
@@ -180,8 +180,8 @@ static irqreturn_t t1isa_interrupt(int interrupt, void *devptr)
 
 			ApplId = (unsigned) b1_get_word(card->port);
 			MsgLen = t1_get_slice(card->port, card->msgbuf);
-			spin_unlock_irqrestore(&card->lock, flags);
 			if (!(skb = alloc_skb(MsgLen, GFP_ATOMIC))) {
+				spin_unlock_irqrestore(&card->lock, flags);
 				printk(KERN_ERR "%s: incoming packet dropped\n",
 						card->name);
 			} else {
@@ -190,7 +190,7 @@ static irqreturn_t t1isa_interrupt(int interrupt, void *devptr)
 					capilib_data_b3_conf(&cinfo->ncci_head, ApplId,
 							     CAPIMSG_NCCI(skb->data),
 							     CAPIMSG_MSGID(skb->data));
-
+				spin_unlock_irqrestore(&card->lock, flags);
 				capi_ctr_handle_message(ctrl, ApplId, skb);
 			}
 			break;
@@ -200,21 +200,17 @@ static irqreturn_t t1isa_interrupt(int interrupt, void *devptr)
 			ApplId = b1_get_word(card->port);
 			NCCI = b1_get_word(card->port);
 			WindowSize = b1_get_word(card->port);
-			spin_unlock_irqrestore(&card->lock, flags);
-
 			capilib_new_ncci(&cinfo->ncci_head, ApplId, NCCI, WindowSize);
-
+			spin_unlock_irqrestore(&card->lock, flags);
 			break;
 
 		case RECEIVE_FREE_NCCI:
 
 			ApplId = b1_get_word(card->port);
 			NCCI = b1_get_word(card->port);
-			spin_unlock_irqrestore(&card->lock, flags);
-
 			if (NCCI != 0xffffffff)
 				capilib_free_ncci(&cinfo->ncci_head, ApplId, NCCI);
-
+			spin_unlock_irqrestore(&card->lock, flags);
 			break;
 
 		case RECEIVE_START:
@@ -333,13 +329,16 @@ static void t1isa_reset_ctr(struct capi_ctr *ctrl)
 	avmctrl_info *cinfo = (avmctrl_info *)(ctrl->driverdata);
 	avmcard *card = cinfo->card;
 	unsigned int port = card->port;
+	unsigned long flags;
 
 	t1_disable_irq(port);
 	b1_reset(port);
 	b1_reset(port);
 
 	memset(cinfo->version, 0, sizeof(cinfo->version));
+	spin_lock_irqsave(&card->lock, flags);
 	capilib_release(&cinfo->ncci_head);
+	spin_unlock_irqrestore(&card->lock, flags);
 	capi_ctr_reseted(ctrl);
 }
 
@@ -466,29 +465,26 @@ static u16 t1isa_send_message(struct capi_ctr *ctrl, struct sk_buff *skb)
 	u8 subcmd = CAPIMSG_SUBCOMMAND(skb->data);
 	u16 dlen, retval;
 
+	spin_lock_irqsave(&card->lock, flags);
 	if (CAPICMD(cmd, subcmd) == CAPI_DATA_B3_REQ) {
 		retval = capilib_data_b3_req(&cinfo->ncci_head,
 					     CAPIMSG_APPID(skb->data),
 					     CAPIMSG_NCCI(skb->data),
 					     CAPIMSG_MSGID(skb->data));
-		if (retval != CAPI_NOERROR) 
+		if (retval != CAPI_NOERROR) {
+			spin_unlock_irqrestore(&card->lock, flags);
 			return retval;
-
+		}
 		dlen = CAPIMSG_DATALEN(skb->data);
 
-		spin_lock_irqsave(&card->lock, flags);
 		b1_put_byte(port, SEND_DATA_B3_REQ);
 		t1_put_slice(port, skb->data, len);
 		t1_put_slice(port, skb->data + len, dlen);
-		spin_unlock_irqrestore(&card->lock, flags);
 	} else {
-
-		spin_lock_irqsave(&card->lock, flags);
 		b1_put_byte(port, SEND_MESSAGE);
 		t1_put_slice(port, skb->data, len);
-		spin_unlock_irqrestore(&card->lock, flags);
 	}
-
+	spin_unlock_irqrestore(&card->lock, flags);
 	dev_kfree_skb_any(skb);
 	return CAPI_NOERROR;
 }

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
