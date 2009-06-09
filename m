Return-Path: <linux-kernel-owner+w=401wt.eu-S1755820AbZFKR3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbZFKR3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 13:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755542AbZFKR3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 13:29:04 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:52337 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525AbZFKR3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 13:29:03 -0400
Message-Id: <8164491dd628ffcac5d61267f747997689ee256c.1244739994.git.keil@b1-systems.de>
In-Reply-To: <cover.1244739994.git.keil@b1-systems.de>
References: <cover.1244739994.git.keil@b1-systems.de>
Date: Tue, 9 Jun 2009 14:38:39 +0200
Subject: [PATCH 5/6] mISDN: Do not disable IRQ in ph_data_ind()
From: Karsten Keil <keil@b1-systems.de>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       i4ldeveloper@listserv.isdn4linux.de
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fix triggering the WARN_ON_ONCE(in_irq() || irqs_disabled()); in
local_bh_enable().

Here is no need to grab this lock, this was wrong at all and may
cause a deadlock and access to freed memory, since on a TEI remove
the current listelement can be deleted under us. So this is clearly
a case for list_for_each_entry_safe.

Signed-off-by: Karsten Keil <keil@b1-systems.de>
---
 drivers/isdn/mISDN/tei.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/isdn/mISDN/tei.c b/drivers/isdn/mISDN/tei.c
index bfcdd97..e04bad6 100644
--- a/drivers/isdn/mISDN/tei.c
+++ b/drivers/isdn/mISDN/tei.c
@@ -862,8 +862,7 @@ static int
 ph_data_ind(struct manager *mgr, struct sk_buff *skb)
 {
 	int		ret = -EINVAL;
-	struct layer2	*l2;
-	u_long		flags;
+	struct layer2	*l2, *nl2;
 	u_char		mt;
 
 	if (skb->len < 8) {
@@ -908,11 +907,9 @@ ph_data_ind(struct manager *mgr, struct sk_buff *skb)
 		new_tei_req(mgr, &skb->data[4]);
 		goto done;
 	}
-	read_lock_irqsave(&mgr->lock, flags);
-	list_for_each_entry(l2, &mgr->layer2, list) {
+	list_for_each_entry_safe(l2, nl2, &mgr->layer2, list) {
 		tei_ph_data_ind(l2->tm, mt, &skb->data[4], skb->len - 4);
 	}
-	read_unlock_irqrestore(&mgr->lock, flags);
 done:
 	return ret;
 }
-- 
1.6.0.2

