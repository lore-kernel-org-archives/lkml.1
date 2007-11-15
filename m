Return-Path: <linux-kernel-owner+w=401wt.eu-S933395AbXKOHDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933395AbXKOHDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:03:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932436AbXKOGrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:47:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58116 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765986AbXKOGrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:47:46 -0500
Date: Wed, 14 Nov 2007 22:45:20 -0800
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
       alan@lxorguk.ukuu.org.uk, rainer.brestan@frequentis.com, kkeil@suse.de,
       rsc@runtux.com
Subject: [patch 26/40] i4l: Fix random hard freeze with AVM c4 card
Message-ID: <20071115064520.GA19218@kroah.com>
References: <20071115062710.885284510@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="i4l-fix-random-hard-freeze-with-avm-c4-card.patch"
In-Reply-To: <20071115064302.GA19218@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Karsten Keil <kkeil@suse.de>

patch 1ccfd63367c1a6aaf8b33943f18856dde85f2f0b in mainline.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/isdn/hardware/avm/c4.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

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
@@ -766,7 +770,9 @@ static int queue_sendconfigword(avmcard 
 	skb_put(skb, (u8 *)p - (u8 *)skb->data);
 
 	skb_queue_tail(&card->dma->send_queue, skb);
+	spin_lock_irqsave(&card->lock, flags);
 	c4_dispatch_tx(card);
+	spin_unlock_irqrestore(&card->lock, flags);
 	return 0;
 }
 
@@ -986,7 +992,9 @@ static void c4_release_appl(struct capi_
 	struct sk_buff *skb;
 	void *p;
 
+	spin_lock_irqsave(&card->lock, flags);
 	capilib_release_appl(&cinfo->ncci_head, appl);
+	spin_unlock_irqrestore(&card->lock, flags);
 
 	if (ctrl->cnr == card->cardnr) {
 		skb = alloc_skb(7, GFP_ATOMIC);
@@ -1019,7 +1027,8 @@ static u16 c4_send_message(struct capi_c
 	u16 retval = CAPI_NOERROR;
 	unsigned long flags;
 
- 	if (CAPIMSG_CMD(skb->data) == CAPI_DATA_B3_REQ) {
+	spin_lock_irqsave(&card->lock, flags);
+	if (CAPIMSG_CMD(skb->data) == CAPI_DATA_B3_REQ) {
 		retval = capilib_data_b3_req(&cinfo->ncci_head,
 					     CAPIMSG_APPID(skb->data),
 					     CAPIMSG_NCCI(skb->data),
@@ -1027,10 +1036,9 @@ static u16 c4_send_message(struct capi_c
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
