Return-Path: <linux-kernel-owner+w=401wt.eu-S1759731AbYBPU3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759731AbYBPU3z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 15:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756666AbYBPU3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 15:29:09 -0500
Received: from havoc.gtf.org ([69.61.125.42]:37917 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195AbYBPU3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 15:29:07 -0500
Message-Id: <167d76873c13943668c7f4443bfa60bb1552ecb2.1203189978.git.jeff@garzik.org>
In-Reply-To: <098123kjff90231nv098233rnvd908u234@garzik.org>
References: <098123kjff90231nv098233rnvd908u234@garzik.org>
From: Jeff Garzik <jeff@garzik.org>
To: kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org
Date: Fri, 15 Feb 2008 23:41:15 -0500
Subject: [PATCH 01/14] [ISDN] HiSax: modularization prep
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass a function pointer into the core HiSax probe function checkcard(),
in order to facilitate modular drivers passing in their own setup
routines.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/isdn/hisax/config.c    |   14 +++++++++-----
 drivers/isdn/hisax/hisax_cfg.h |    2 ++
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index a0ee43c..84d75a3 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -1169,7 +1169,9 @@ outf_cs:
 /* Used from an exported function but calls __devinit functions.
  * Tell modpost not to warn (__ref)
  */
-static int __ref checkcard(int cardnr, char *id, int *busy_flag, struct module *lockowner)
+static int __ref checkcard(int cardnr, char *id, int *busy_flag,
+			   struct module *lockowner,
+			   hisax_setup_func_t card_setup)
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

