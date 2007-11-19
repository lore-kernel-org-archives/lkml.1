Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbXKSS2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbXKSS2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:28:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752405AbXKSSWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:22:39 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49351 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbXKSSWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:22:37 -0500
Date: Mon, 19 Nov 2007 10:19:26 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, kkeil@suse.de
Subject: [patch 21/26] i4l: fix random freezes with AVM B1 drivers
Message-ID: <20071119181926.GV15425@kroah.com>
References: <20071119181438.617190424@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="i4l-fix-random-freezes-with-avm-b1-drivers.patch"
In-Reply-To: <20071119181746.GA15425@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Karsten Keil <kkeil@suse.de>

patch 9713d9e650045f7f2afd81d58a068827be306993 in mainline.

This fix the same issue which was debbuged for the C4 controller for the B1
versions.

The capilib_ function modify or traverse a linked list without locking.

This patch extends the existing locking to the calls of these function to
prevent access to a list which is in the middle of a modification.

Signed-off-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/isdn/hardware/avm/b1.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

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
 
@@ -361,9 +364,8 @@ void b1_release_appl(struct capi_ctr *ct
 	unsigned int port = card->port;
 	unsigned long flags;
 
-	capilib_release_appl(&cinfo->ncci_head, appl);
-
 	spin_lock_irqsave(&card->lock, flags);
+	capilib_release_appl(&cinfo->ncci_head, appl);
 	b1_put_byte(port, SEND_RELEASE);
 	b1_put_word(port, appl);
 	spin_unlock_irqrestore(&card->lock, flags);
@@ -380,27 +382,27 @@ u16 b1_send_message(struct capi_ctr *ctr
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
@@ -534,17 +536,17 @@ irqreturn_t b1_interrupt(int interrupt, 
 
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
@@ -554,21 +556,17 @@ irqreturn_t b1_interrupt(int interrupt, 
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
