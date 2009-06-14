Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbZFNLYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbZFNLYR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 07:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbZFNLYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 07:24:06 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60896 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbZFNLYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 07:24:05 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 14 Jun 2009 13:23:58 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update] firewire: core: use more outbound tlabels
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Guus Sliepen <guus@sliepen.org>
In-Reply-To: <4A34D871.7030708@s5r6.in-berlin.de>
Message-ID: <tkrat.c570ff7db48cd764@s5r6.in-berlin.de>
References: <tkrat.e2bb42d0db655b15@s5r6.in-berlin.de>
 <20090614103656.GT6540@sliepen.org> <4A34D871.7030708@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tlabel is a 6 bits wide datum.  Wrap it after 63 rather than 31 for more
safety against transaction label exhaustion and potential responders'
transaction layer bugs.  (As noted by Guus Sliepen, this change requires
an expansion of tlabel_mask to 64 bits.)

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-transaction.c |    8 ++++----
 include/linux/firewire.h            |    3 ++-
 2 files changed, 6 insertions(+), 5 deletions(-)

Index: b/drivers/firewire/core-transaction.c
===================================================================
--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -82,7 +82,7 @@ static int close_transaction(struct fw_t
 	list_for_each_entry(t, &card->transaction_list, link) {
 		if (t == transaction) {
 			list_del(&t->link);
-			card->tlabel_mask &= ~(1 << t->tlabel);
+			card->tlabel_mask &= ~(1ULL << t->tlabel);
 			break;
 		}
 	}
@@ -288,14 +288,14 @@ void fw_send_request(struct fw_card *car
 	spin_lock_irqsave(&card->lock, flags);
 
 	tlabel = card->current_tlabel;
-	if (card->tlabel_mask & (1 << tlabel)) {
+	if (card->tlabel_mask & (1ULL << tlabel)) {
 		spin_unlock_irqrestore(&card->lock, flags);
 		callback(card, RCODE_SEND_ERROR, NULL, 0, callback_data);
 		return;
 	}
 
-	card->current_tlabel = (card->current_tlabel + 1) & 0x1f;
-	card->tlabel_mask |= (1 << tlabel);
+	card->current_tlabel = (card->current_tlabel + 1) & 0x3f;
+	card->tlabel_mask |= (1ULL << tlabel);
 
 	t->node_id = destination_id;
 	t->tlabel = tlabel;
Index: b/include/linux/firewire.h
===================================================================
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -98,7 +98,8 @@ struct fw_card {
 
 	int node_id;
 	int generation;
-	int current_tlabel, tlabel_mask;
+	int current_tlabel;
+	u64 tlabel_mask;
 	struct list_head transaction_list;
 	struct timer_list flush_timer;
 	unsigned long reset_jiffies;

-- 
Stefan Richter
-=====-==--= -==- -===-
http://arcgraph.de/sr/

