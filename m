Return-Path: <linux-kernel-owner+w=401wt.eu-S933024AbXJQLH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024AbXJQLH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 07:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760101AbXJQLHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 07:07:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39926 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759322AbXJQLHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 07:07:47 -0400
Date: Wed, 17 Oct 2007 13:07:44 +0200
From: Karsten Keil <kkeil@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de
Subject: [PATCH] [ISDN] Fix random hard freeze with AVM c4 card
Message-ID: <20071017110744.GA6687@pingi.kke.suse.de>
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

The patch
- Includes the call to capilib_data_b3_req in the spinlock. This routine
  in turn calls the offending mq_enqueue routine that triggered the
  freeze if not locked.  This should also fix other indicators of
  incosistent capilib_msgidqueue list, that trigger messages like:
  Oct  5 03:05:57 BERL0 kernel: kcapi: msgid 3019 ncci 0x30301 not on queue
  that we saw several times a day (usually several in a row).
- Fixes all occurrences of c4_dispatch_tx to be called with active
  spinlock, there were some instances where no lock was active. Mostly
  these are in very infrequently called routines, so the additional
  performance penalty is minimal.

Signed-off-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Rainer Brestan <rainer.brestan@frequentis.com>
Signed-off-by: Ralf Schlatterbeck <rsc@runtux.com>
---
 drivers/isdn/hardware/avm/c4.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/isdn/hardware/avm/c4.c b/drivers/isdn/hardware/avm/c4.c
index d58f927..4c6ef91 100644
--- a/drivers/isdn/hardware/avm/c4.c
+++ b/drivers/isdn/hardware/avm/c4.c
@@ -727,6 +727,7 @@ static void c4_send_init(avmcard *card)
 {
 	struct sk_buff *skb;
 	void *p;
+	unsigned long flags;
 
 	skb = alloc_skb(15, GFP_ATOMIC);
 	if (!skb) {
@@ -744,12 +745,15 @@ static void c4_send_init(avmcard *card)
 	skb_put(skb, (u8 *)p - (u8 *)skb->data);
 
 	skb_queue_tail(&card->dma->send_queue, skb);
+	spin_lock_irqsave(&card->lock, flags);
 	c4_dispatch_tx(card);
+	spin_unlock_irqrestore(&card->lock, flags);
 }
 
 static int queue_sendconfigword(avmcard *card, u32 val)
 {
 	struct sk_buff *skb;
+	unsigned long flags;
 	void *p;
 
 	skb = alloc_skb(3+4, GFP_ATOMIC);
@@ -766,7 +770,9 @@ static int queue_sendconfigword(avmcard *card, u32 val)
 	skb_put(skb, (u8 *)p - (u8 *)skb->data);
 
 	skb_queue_tail(&card->dma->send_queue, skb);
+	spin_lock_irqsave(&card->lock, flags);
 	c4_dispatch_tx(card);
+	spin_unlock_irqrestore(&card->lock, flags);
 	return 0;
 }
 
@@ -986,7 +992,9 @@ static void c4_release_appl(struct capi_ctr *ctrl, u16 appl)
 	struct sk_buff *skb;
 	void *p;
 
+	spin_lock_irqsave(&card->lock, flags);
 	capilib_release_appl(&cinfo->ncci_head, appl);
+	spin_unlock_irqrestore(&card->lock, flags);
 
 	if (ctrl->cnr == card->cardnr) {
 		skb = alloc_skb(7, GFP_ATOMIC);
@@ -1018,8 +1026,9 @@ static u16 c4_send_message(struct capi_ctr *ctrl, struct sk_buff *skb)
 	avmcard *card = cinfo->card;
 	u16 retval = CAPI_NOERROR;
 	unsigned long flags;
-
- 	if (CAPIMSG_CMD(skb->data) == CAPI_DATA_B3_REQ) {
+	
+	spin_lock_irqsave(&card->lock, flags);
+	if (CAPIMSG_CMD(skb->data) == CAPI_DATA_B3_REQ) {
 		retval = capilib_data_b3_req(&cinfo->ncci_head,
 					     CAPIMSG_APPID(skb->data),
 					     CAPIMSG_NCCI(skb->data),
@@ -1027,10 +1036,9 @@ static u16 c4_send_message(struct capi_ctr *ctrl, struct sk_buff *skb)
 	}
 	if (retval == CAPI_NOERROR) {
 		skb_queue_tail(&card->dma->send_queue, skb);
-		spin_lock_irqsave(&card->lock, flags);
 		c4_dispatch_tx(card);
-		spin_unlock_irqrestore(&card->lock, flags);
 	}
+	spin_unlock_irqrestore(&card->lock, flags);
 	return retval;
 }
 

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
