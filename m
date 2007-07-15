Return-Path: <linux-kernel-owner+w=401wt.eu-S1760288AbXGOJ7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760288AbXGOJ7Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 05:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757878AbXGOJ7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 05:59:01 -0400
Received: from havoc.gtf.org ([69.61.125.42]:57837 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756864AbXGOJ7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 05:59:01 -0400
Date: Sun, 15 Jul 2007 05:59:00 -0400
From: Jeff Garzik <jeff@garzik.org>
To: kkeil@suse.de, linux-kernel@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de
Cc: Andrew Morton <akpm@linux-foundation.org>, surya.prabhakar@wipro.com
Subject: [PATCH 2/5] HiSax: move card state alloc/setup code into separate functions
Message-ID: <20070715095900.GB21220@havoc.gtf.org>
References: <20070715095716.GA20949@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070715095716.GA20949@havoc.gtf.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit 8190a38259cebf01db250f397408787aed7c6b93
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sat Jul 14 22:29:16 2007 -0400

    [ISDN] HiSax: move card state alloc/setup code into separate functions
    
    No behavior changes, just code movement.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/isdn/hisax/config.c |   72 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 54 insertions(+), 18 deletions(-)

8190a38259cebf01db250f397408787aed7c6b93
diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index ce54a73..23b5412 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -1016,12 +1016,14 @@ static int hisax_cs_setup_card(struct IsdnCard *card)
 	return ret;
 }
 
-static int checkcard(int cardnr, char *id, int *busy_flag, struct module *lockowner)
+static int hisax_cs_new(int cardnr, struct IsdnCard *card,
+			struct IsdnCardState **cs_out, int *busy_flag,
+			struct module *lockowner)
 {
-	int ret = 0;
-	struct IsdnCard *card = cards + cardnr;
 	struct IsdnCardState *cs;
 
+	*cs_out = NULL;
+
 	cs = kzalloc(sizeof(struct IsdnCardState), GFP_ATOMIC);
 	if (!cs) {
 		printk(KERN_WARNING
@@ -1098,19 +1100,23 @@ static int checkcard(int cardnr, char *id, int *busy_flag, struct module *lockow
 	cs->iif.readstat = HiSax_readstatus;
 	register_isdn(&cs->iif);
 	cs->myid = cs->iif.channels;
-	printk(KERN_INFO
-	       "HiSax: Card %d Protocol %s Id=%s (%d)\n", cardnr + 1,
-	       (card->protocol == ISDN_PTYPE_1TR6) ? "1TR6" :
-	       (card->protocol == ISDN_PTYPE_EURO) ? "EDSS1" :
-	       (card->protocol == ISDN_PTYPE_LEASED) ? "LEASED" :
-	       (card->protocol == ISDN_PTYPE_NI1) ? "NI1" :
-	       "NONE", cs->iif.id, cs->myid);
 
-	ret = hisax_cs_setup_card(card);
-	if (!ret) {
-		ll_unload(cs);
-		goto outf_cs;
-	}
+	*cs_out = cs;
+	return 1;	/* success */
+
+outf_dlog:
+	kfree(cs->dlog);
+outf_cs:
+	kfree(cs);
+	card->cs = NULL;
+out:
+	return 0;	/* error */
+}
+
+static int hisax_cs_setup(int cardnr, struct IsdnCard *card,
+			  struct IsdnCardState *cs)
+{
+	int ret;
 
 	if (!(cs->rcvbuf = kmalloc(MAX_DFRAME_LEN_L1, GFP_ATOMIC))) {
 		printk(KERN_WARNING "HiSax: No memory for isac rcvbuf\n");
@@ -1154,11 +1160,41 @@ static int checkcard(int cardnr, char *id, int *busy_flag, struct module *lockow
 	if (!test_bit(HW_ISAR, &cs->HW_Flags))
 		ll_run(cs, 0);
 
-	ret = 1;
+	return 1;
+
+outf_cs:
+	kfree(cs);
+	card->cs = NULL;
+	return ret;
+}
+
+static int checkcard(int cardnr, char *id, int *busy_flag, struct module *lockowner)
+{
+	int ret;
+	struct IsdnCard *card = cards + cardnr;
+	struct IsdnCardState *cs;
+
+	ret = hisax_cs_new(cardnr, card, &cs, busy_flag, lockowner);
+	if (!ret)
+		return 0;
+
+	printk(KERN_INFO
+	       "HiSax: Card %d Protocol %s Id=%s (%d)\n", cardnr + 1,
+	       (card->protocol == ISDN_PTYPE_1TR6) ? "1TR6" :
+	       (card->protocol == ISDN_PTYPE_EURO) ? "EDSS1" :
+	       (card->protocol == ISDN_PTYPE_LEASED) ? "LEASED" :
+	       (card->protocol == ISDN_PTYPE_NI1) ? "NI1" :
+	       "NONE", cs->iif.id, cs->myid);
+
+	ret = hisax_cs_setup_card(card);
+	if (!ret) {
+		ll_unload(cs);
+		goto outf_cs;
+	}
+
+	ret = hisax_cs_setup(cardnr, card, cs);
 	goto out;
 
- outf_dlog:
-	kfree(cs->dlog);
  outf_cs:
 	kfree(cs);
 	card->cs = NULL;
