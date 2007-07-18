Return-Path: <linux-kernel-owner+w=401wt.eu-S934005AbYBNXkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934005AbYBNXkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 18:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760140AbYBNXkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 18:40:06 -0500
Received: from havoc.gtf.org ([69.61.125.42]:58095 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759453AbYBNXkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 18:40:04 -0500
Message-Id: <xxxc75b3eadfa82aee70b855e9944b5439a259d5.1203031878.git.jeff@garzik.org>
In-Reply-To: <74fc75b3eadfa82aee70b855e9944b5439a259d5.1203031878.git.jeff@garzik.org>
References: <74fc75b3eadfa82aee70b855e9944b5439a259d5.1203031878.git.jeff@garzik.org>
From: Jeff Garzik <jeff@garzik.org>
To: linux-kernel@vger.kernel.org, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de
Date: Tue, 17 Jul 2007 23:04:04 -0400
Subject: [PATCH 01/14] [ISDN] HiSax: modularize card setup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the previous no-behavior-change code movement patches have
occurred, we can easily replace the big per-card "call the setup
function for <this card>" switch statement with a function pointer.

Signed-off-by: Jeff Garzik <jeff@garzik.org>
---
 drivers/isdn/hisax/config.c    |   14 +++++++++-----
 drivers/isdn/hisax/hisax_cfg.h |    2 ++
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index a0ee43c..f395a72 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -1169,7 +1169,9 @@ outf_cs:
 /* Used from an exported function but calls __devinit functions.
  * Tell modpost not to warn (__ref)
  */
-static int __ref checkcard(int cardnr, char *id, int *busy_flag, struct module *lockowner)
+static int __ref checkcard(int cardnr, char *id, int *busy_flag,
+			   struct module *lockowner,
+		    	   hisax_setup_func_t card_setup)
 {
 	int ret;
 	struct IsdnCard *card = cards + cardnr;
@@ -1187,7 +1189,7 @@ static int __ref checkcard(int cardnr, char *id, int *busy_flag, struct module *
 	       (card->protocol == ISDN_PTYPE_NI1) ? "NI1" :
 	       "NONE", cs->iif.id, cs->myid);
 
-	ret = hisax_cs_setup_card(card);
+	ret = card_setup(card);
 	if (!ret) {
 		ll_unload(cs);
 		goto outf_cs;
@@ -1241,7 +1243,8 @@ static int HiSax_inithardware(int *busy_flag)
 			else
 				sprintf(ids, "%s%d", id, i);
 		}
-		if (checkcard(i, ids, busy_flag, THIS_MODULE)) {
+		if (checkcard(i, ids, busy_flag, THIS_MODULE,
+			      hisax_cs_setup_card)) {
 			foundcards++;
 			i++;
 		} else {
@@ -1549,7 +1552,8 @@ int hisax_init_pcmcia(void *pcm_iob, int *busy_flag, struct IsdnCard *card)
 		sprintf(ids, "HiSax%d", nrcards);
 	else
 		sprintf(ids, "HiSax");
-	if (!checkcard(nrcards, ids, busy_flag, THIS_MODULE))
+	if (!checkcard(nrcards, ids, busy_flag, THIS_MODULE,
+		       hisax_cs_setup_card))
 		goto error;
 
 	ret = nrcards;
@@ -1595,7 +1599,7 @@ int hisax_register(struct hisax_d_if *hisax_d_if, struct hisax_b_if *b_if[],
 	cards[i].protocol = protocol;
 	sprintf(id, "%s%d", name, i);
 	nrcards++;
-	retval = checkcard(i, id, NULL, hisax_d_if->owner);
+	retval = checkcard(i, id, NULL, hisax_d_if->owner, hisax_cs_setup_card);
 	if (retval == 0) { // yuck
 		cards[i].typ = 0;
 		nrcards--;
diff --git a/drivers/isdn/hisax/hisax_cfg.h b/drivers/isdn/hisax/hisax_cfg.h
index ca3fe62..17a2fea 100644
--- a/drivers/isdn/hisax/hisax_cfg.h
+++ b/drivers/isdn/hisax/hisax_cfg.h
@@ -60,5 +60,7 @@ struct IsdnCard {
 	IsdnCardState_t	*cs;
 };
 
+typedef int (*hisax_setup_func_t)(struct IsdnCard *card);
+
 extern void	HiSax_closecard(int);
 extern int	hisax_init_pcmcia(void *, int *, IsdnCard_t *);
-- 
1.5.3.8

