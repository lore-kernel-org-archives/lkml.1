Return-Path: <linux-kernel-owner+w=401wt.eu-S1760566AbXGOJ7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760566AbXGOJ7p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 05:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757760AbXGOJ7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 05:59:37 -0400
Received: from havoc.gtf.org ([69.61.125.42]:57843 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757173AbXGOJ7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 05:59:36 -0400
Date: Sun, 15 Jul 2007 05:59:35 -0400
From: Jeff Garzik <jeff@garzik.org>
To: kkeil@suse.de, linux-kernel@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de
Cc: Andrew Morton <akpm@linux-foundation.org>, surya.prabhakar@wipro.com
Subject: [PATCH 3/5] HiSax: modularize card setup; introduce simple hotplug API
Message-ID: <20070715095935.GC21220@havoc.gtf.org>
References: <20070715095716.GA20949@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070715095716.GA20949@havoc.gtf.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit 8571a5d1c62f5b129612bcb978827ed9e542bda2
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sun Jul 15 03:56:11 2007 -0400

    [ISDN] HiSax: modularize card setup; introduce simple hotplug API
    
    1) Now that the previous no-behavior-change code movement patches have
    occurred, we can easily replace the big per-card "call the setup
    function for <this card>" switch statement with a function pointer.
    
    2) Duplicate and modify slightly the hotplug logic found in existing
    function hisax_init_pcmcia(), to make it easily usable by modular
    drivers.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/isdn/hisax/config.c    |   34 +++++++++++++++++++++++++++++-----
 drivers/isdn/hisax/hisax_cfg.h |    3 +++
 2 files changed, 32 insertions(+), 5 deletions(-)

8571a5d1c62f5b129612bcb978827ed9e542bda2
diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index 23b5412..e5c972b 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -1168,7 +1168,9 @@ outf_cs:
 	return ret;
 }
 
-static int checkcard(int cardnr, char *id, int *busy_flag, struct module *lockowner)
+static int checkcard(int cardnr, char *id, int *busy_flag,
+		     struct module *lockowner,
+		     hisax_setup_func_t card_setup)
 {
 	int ret;
 	struct IsdnCard *card = cards + cardnr;
@@ -1186,7 +1188,7 @@ static int checkcard(int cardnr, char *id, int *busy_flag, struct module *lockow
 	       (card->protocol == ISDN_PTYPE_NI1) ? "NI1" :
 	       "NONE", cs->iif.id, cs->myid);
 
-	ret = hisax_cs_setup_card(card);
+	ret = card_setup(card);
 	if (!ret) {
 		ll_unload(cs);
 		goto outf_cs;
@@ -1240,7 +1242,8 @@ static int HiSax_inithardware(int *busy_flag)
 			else
 				sprintf(ids, "%s%d", id, i);
 		}
-		if (checkcard(i, ids, busy_flag, THIS_MODULE)) {
+		if (checkcard(i, ids, busy_flag, THIS_MODULE,
+			      hisax_cs_setup_card)) {
 			foundcards++;
 			i++;
 		} else {
@@ -1538,6 +1541,25 @@ static void __exit HiSax_exit(void)
 	printk(KERN_INFO "HiSax module removed\n");
 }
 
+int hisax_init_hotplug(struct IsdnCard *card, hisax_setup_func_t card_setup)
+{
+	u_char ids[16];
+	int ret = -1;
+
+	cards[nrcards] = *card;
+	if (nrcards)
+		sprintf(ids, "HiSax%d", nrcards);
+	else
+		sprintf(ids, "HiSax");
+	if (!checkcard(nrcards, ids, NULL, THIS_MODULE, card_setup))
+		goto error;
+
+	ret = nrcards;
+	nrcards++;
+error:
+	return ret;
+}
+
 int hisax_init_pcmcia(void *pcm_iob, int *busy_flag, struct IsdnCard *card)
 {
 	u_char ids[16];
@@ -1548,7 +1570,8 @@ int hisax_init_pcmcia(void *pcm_iob, int *busy_flag, struct IsdnCard *card)
 		sprintf(ids, "HiSax%d", nrcards);
 	else
 		sprintf(ids, "HiSax");
-	if (!checkcard(nrcards, ids, busy_flag, THIS_MODULE))
+	if (!checkcard(nrcards, ids, busy_flag, THIS_MODULE,
+		       hisax_cs_setup_card))
 		goto error;
 
 	ret = nrcards;
@@ -1558,6 +1581,7 @@ error:
 }
 
 EXPORT_SYMBOL(hisax_init_pcmcia);
+EXPORT_SYMBOL(hisax_init_hotplug);
 EXPORT_SYMBOL(HiSax_closecard);
 
 #include "hisax_if.h"
@@ -1594,7 +1618,7 @@ int hisax_register(struct hisax_d_if *hisax_d_if, struct hisax_b_if *b_if[],
 	cards[i].protocol = protocol;
 	sprintf(id, "%s%d", name, i);
 	nrcards++;
-	retval = checkcard(i, id, NULL, hisax_d_if->owner);
+	retval = checkcard(i, id, NULL, hisax_d_if->owner, hisax_cs_setup_card);
 	if (retval == 0) { // yuck
 		cards[i].typ = 0;
 		nrcards--;
diff --git a/drivers/isdn/hisax/hisax_cfg.h b/drivers/isdn/hisax/hisax_cfg.h
index ca3fe62..ec309d4 100644
--- a/drivers/isdn/hisax/hisax_cfg.h
+++ b/drivers/isdn/hisax/hisax_cfg.h
@@ -60,5 +60,8 @@ struct IsdnCard {
 	IsdnCardState_t	*cs;
 };
 
+typedef int (*hisax_setup_func_t)(struct IsdnCard *card);
+
 extern void	HiSax_closecard(int);
 extern int	hisax_init_pcmcia(void *, int *, IsdnCard_t *);
+extern int	hisax_init_hotplug(IsdnCard_t *, hisax_setup_func_t card_setup);
