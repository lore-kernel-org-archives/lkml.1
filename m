Return-Path: <linux-kernel-owner+w=401wt.eu-S1760779AbXJQMsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760779AbXJQMsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 08:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754500AbXJQMsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 08:48:04 -0400
Received: from ns.suse.de ([195.135.220.2]:35363 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356AbXJQMsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 08:48:02 -0400
Date: Wed, 17 Oct 2007 14:48:00 +0200
From: Karsten Keil <kkeil@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de
Subject: [PATCH] [ISDN] fix random freezes with AVM B1 drivers
Message-ID: <20071017124759.GA18573@pingi.kke.suse.de>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.27-0.6-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This fix the same issue which was debbuged for the C4
controller for the B1 versions.
The capilib_ function modify or traverse a linked
list without locking.
This patch extend the existing locking
to the calls of these function to prevent access
to a list which is in the middle of a modification.

Signed-off-by: Karsten Keil <kkeil@suse.de>
---
 drivers/isdn/hardware/avm/b1.c |   28 +++++++++++++---------------
 1 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/isdn/hardware/avm/b1.c b/drivers/isdn/hardware/avm/b1.c
index 7a69a18..4484a64 100644
--- a/drivers/isdn/hardware/avm/b1.c
+++ b/drivers/isdn/hardware/avm/b1.c
@@ -321,12 +321,15 @@ void b1_reset_ctr(struct capi_ctr *ctrl)
 	avmctrl_info *cinfo = (avmctrl_info *)(ctrl->driverdata);
 	avmcard *card = cinfo->card;
 	unsigned int port = card->port;
+	unsigned long flags;
 
 	b1_reset(port);
 	b1_reset(port);
 
 	memset(cinfo->version, 0, sizeof(cinfo->version));
+	spin_lock_irqsave(&card->lock, flags);
 	capilib_release(&cinfo->ncci_head);
+	spin_unlock_irqrestore(&card->lock, flags);
 	capi_ctr_reseted(ctrl);
 }
 
@@ -361,9 +364,8 @@ void b1_release_appl(struct capi_ctr *ctrl, u16 appl)
 	unsigned int port = card->port;
 	unsigned long flags;
 
-	capilib_release_appl(&cinfo->ncci_head, appl);
-
 	spin_lock_irqsave(&card->lock, flags);
+	capilib_release_appl(&cinfo->ncci_head, appl);
 	b1_put_byte(port, SEND_RELEASE);
 	b1_put_word(port, appl);
 	spin_unlock_irqrestore(&card->lock, flags);
@@ -380,27 +382,27 @@ u16 b1_send_message(struct capi_ctr *ctrl, struct sk_buff *skb)
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
+		}
 
 		dlen = CAPIMSG_DATALEN(skb->data);
 
-	 	spin_lock_irqsave(&card->lock, flags);
 		b1_put_byte(port, SEND_DATA_B3_REQ);
 		b1_put_slice(port, skb->data, len);
 		b1_put_slice(port, skb->data + len, dlen);
-		spin_unlock_irqrestore(&card->lock, flags);
 	} else {
-	 	spin_lock_irqsave(&card->lock, flags);
 		b1_put_byte(port, SEND_MESSAGE);
 		b1_put_slice(port, skb->data, len);
-		spin_unlock_irqrestore(&card->lock, flags);
 	}
+	spin_unlock_irqrestore(&card->lock, flags);
 
 	dev_kfree_skb_any(skb);
 	return CAPI_NOERROR;
@@ -534,17 +536,17 @@ irqreturn_t b1_interrupt(int interrupt, void *devptr)
 
 		ApplId = (unsigned) b1_get_word(card->port);
 		MsgLen = b1_get_slice(card->port, card->msgbuf);
-		spin_unlock_irqrestore(&card->lock, flags);
 		if (!(skb = alloc_skb(MsgLen, GFP_ATOMIC))) {
 			printk(KERN_ERR "%s: incoming packet dropped\n",
 					card->name);
+			spin_unlock_irqrestore(&card->lock, flags);
 		} else {
 			memcpy(skb_put(skb, MsgLen), card->msgbuf, MsgLen);
 			if (CAPIMSG_CMD(skb->data) == CAPI_DATA_B3_CONF)
 				capilib_data_b3_conf(&cinfo->ncci_head, ApplId,
 						     CAPIMSG_NCCI(skb->data),
 						     CAPIMSG_MSGID(skb->data));
-
+			spin_unlock_irqrestore(&card->lock, flags);
 			capi_ctr_handle_message(ctrl, ApplId, skb);
 		}
 		break;
@@ -554,21 +556,17 @@ irqreturn_t b1_interrupt(int interrupt, void *devptr)
 		ApplId = b1_get_word(card->port);
 		NCCI = b1_get_word(card->port);
 		WindowSize = b1_get_word(card->port);
-		spin_unlock_irqrestore(&card->lock, flags);
-
 		capilib_new_ncci(&cinfo->ncci_head, ApplId, NCCI, WindowSize);
-
+		spin_unlock_irqrestore(&card->lock, flags);
 		break;
 
 	case RECEIVE_FREE_NCCI:
 
 		ApplId = b1_get_word(card->port);
 		NCCI = b1_get_word(card->port);
-		spin_unlock_irqrestore(&card->lock, flags);
-
 		if (NCCI != 0xffffffff)
 			capilib_free_ncci(&cinfo->ncci_head, ApplId, NCCI);
-	       
+		spin_unlock_irqrestore(&card->lock, flags);
 		break;
 
 	case RECEIVE_START:
-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
