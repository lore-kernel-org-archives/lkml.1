Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbZESRNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbZESRNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 13:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbZESRNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 13:13:31 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:54609 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343AbZESRNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 13:13:31 -0400
Message-Id: <44cf481ddf924151c192431e10972d49aa74e48d.1242739648.git.kkeil@pingi.linux-pingi.de>
In-Reply-To: <cover.1242739648.git.kkeil@pingi.linux-pingi.de>
References: <cover.1242739648.git.kkeil@pingi.linux-pingi.de>
Subject: [PATCH 14/19] Add "sapi" information to debug messages
From: Karsten Keil <keil@b1-systems.de>
To: linux-kernel@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       i4ldeveloper@listserv.isdn4linux.de
Date: Tue, 19 May 2009 15:58:32 +0200
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Eversberg <andreas@eversberg.eu>

Using sapi values other than 0 work now.
The "OpenBSC" project does not require special kernel patch anymore.

Signed-off-by: Andreas Eversberg <andreas@eversberg.eu>
Signed-off-by: Karsten Keil <keil@b1-systems.de>
---
 drivers/isdn/mISDN/layer2.c |   24 +++++++++++-------------
 drivers/isdn/mISDN/tei.c    |   11 +++++++++--
 2 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/isdn/mISDN/layer2.c b/drivers/isdn/mISDN/layer2.c
index 0628ef6..9efee8e 100644
--- a/drivers/isdn/mISDN/layer2.c
+++ b/drivers/isdn/mISDN/layer2.c
@@ -99,7 +99,7 @@ l2m_debug(struct FsmInst *fi, char *fmt, ...)
 	if (!(*debug & DEBUG_L2_FSM))
 		return;
 	va_start(va, fmt);
-	printk(KERN_DEBUG "l2 (tei %d): ", l2->tei);
+	printk(KERN_DEBUG "l2 (sapi %d tei %d): ", l2->sapi, l2->tei);
 	vprintk(fmt, va);
 	printk("\n");
 	va_end(va);
@@ -1859,20 +1859,18 @@ ph_data_indication(struct layer2 *l2, struct mISDNhead *hh, struct sk_buff *skb)
 		psapi >>= 2;
 		ptei >>= 1;
 		if (psapi != l2->sapi) {
-			/* not our bussiness
-			 * printk(KERN_DEBUG "%s: sapi %d/%d sapi mismatch\n",
-			 *  __func__,
-			 *	psapi, l2->sapi);
-			 */
+			/* not our bussiness */
+			if (*debug & DEBUG_L2)
+				printk(KERN_DEBUG "%s: sapi %d/%d mismatch\n",
+					__func__, psapi, l2->sapi);
 			dev_kfree_skb(skb);
 			return 0;
 		}
 		if ((ptei != l2->tei) && (ptei != GROUP_TEI)) {
-			/* not our bussiness
-			 * printk(KERN_DEBUG "%s: tei %d/%d sapi %d mismatch\n",
-			 *  __func__,
-			 *	ptei, l2->tei, psapi);
-			 */
+			/* not our bussiness */
+			if (*debug & DEBUG_L2)
+				printk(KERN_DEBUG "%s: tei %d/%d mismatch\n",
+					__func__, ptei, l2->tei);
 			dev_kfree_skb(skb);
 			return 0;
 		}
@@ -1927,8 +1925,8 @@ l2_send(struct mISDNchannel *ch, struct sk_buff *skb)
 	int 			ret = -EINVAL;
 
 	if (*debug & DEBUG_L2_RECV)
-		printk(KERN_DEBUG "%s: prim(%x) id(%x) tei(%d)\n",
-		    __func__, hh->prim, hh->id, l2->tei);
+		printk(KERN_DEBUG "%s: prim(%x) id(%x) sapi(%d) tei(%d)\n",
+		    __func__, hh->prim, hh->id, l2->sapi, l2->tei);
 	switch (hh->prim) {
 	case PH_DATA_IND:
 		ret = ph_data_indication(l2, hh, skb);
diff --git a/drivers/isdn/mISDN/tei.c b/drivers/isdn/mISDN/tei.c
index 9e88135..4ebba5c 100644
--- a/drivers/isdn/mISDN/tei.c
+++ b/drivers/isdn/mISDN/tei.c
@@ -227,7 +227,7 @@ tei_debug(struct FsmInst *fi, char *fmt, ...)
 	if (!(*debug & DEBUG_L2_TEIFSM))
 		return;
 	va_start(va, fmt);
-	printk(KERN_DEBUG "tei(%d): ", tm->l2->tei);
+	printk(KERN_DEBUG "sapi(%d) tei(%d): ", tm->l2->sapi, tm->l2->tei);
 	vprintk(fmt, va);
 	printk("\n");
 	va_end(va);
@@ -1188,9 +1188,16 @@ check_data(struct manager *mgr, struct sk_buff *skb)
 	if ((skb->data[2] & ~0x10) != SABME)
 		return -ENOTCONN;
 	/* We got a SABME for a fixed TEI */
+	if (*debug & DEBUG_L2_CTRL)
+		printk(KERN_DEBUG "%s: SABME sapi(%d) tei(%d)\n",
+		    __func__, sapi, tei);
 	l2 = create_new_tei(mgr, tei, sapi);
-	if (!l2)
+	if (!l2) {
+		if (*debug & DEBUG_L2_CTRL)
+			printk(KERN_DEBUG "%s: failed to create new tei\n",
+			    __func__);
 		return -ENOMEM;
+	}
 	ret = l2->ch.send(&l2->ch, skb);
 	return ret;
 }
-- 
1.6.0.2

