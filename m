Return-Path: <linux-kernel-owner+w=401wt.eu-S1760202AbXGOJ6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760202AbXGOJ6e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 05:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756864AbXGOJ61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 05:58:27 -0400
Received: from havoc.gtf.org ([69.61.125.42]:57832 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756812AbXGOJ60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 05:58:26 -0400
Date: Sun, 15 Jul 2007 05:58:25 -0400
From: Jeff Garzik <jeff@garzik.org>
To: kkeil@suse.de, linux-kernel@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de
Cc: Andrew Morton <akpm@linux-foundation.org>, surya.prabhakar@wipro.com
Subject: [PATCH 1/5] HiSax: move card setup into separate function
Message-ID: <20070715095825.GA21220@havoc.gtf.org>
References: <20070715095716.GA20949@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070715095716.GA20949@havoc.gtf.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit 6704a85547f02cac2145793538f5392427ed5fae
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sat Jul 14 21:58:34 2007 -0400

    [ISDN] HiSax: move card setup into separate function
    
    No behavior changes, just code movement.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/isdn/hisax/config.c |  187 +++++++++++++++++++++++---------------------
 1 file changed, 99 insertions(+), 88 deletions(-)

6704a85547f02cac2145793538f5392427ed5fae
diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index 8d53a7f..ce54a73 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -847,95 +847,10 @@ static int init_card(struct IsdnCardState *cs)
 	return 3;
 }
 
-static int checkcard(int cardnr, char *id, int *busy_flag, struct module *lockowner)
+static int hisax_cs_setup_card(struct IsdnCard *card)
 {
-	int ret = 0;
-	struct IsdnCard *card = cards + cardnr;
-	struct IsdnCardState *cs;
-
-	cs = kzalloc(sizeof(struct IsdnCardState), GFP_ATOMIC);
-	if (!cs) {
-		printk(KERN_WARNING
-		       "HiSax: No memory for IsdnCardState(card %d)\n",
-		       cardnr + 1);
-		goto out;
-	}
-	card->cs = cs;
-	spin_lock_init(&cs->statlock);
-	spin_lock_init(&cs->lock);
-	cs->chanlimit = 2;	/* maximum B-channel number */
-	cs->logecho = 0;	/* No echo logging */
-	cs->cardnr = cardnr;
-	cs->debug = L1_DEB_WARN;
-	cs->HW_Flags = 0;
-	cs->busy_flag = busy_flag;
-	cs->irq_flags = I4L_IRQ_FLAG;
-#if TEI_PER_CARD
-	if (card->protocol == ISDN_PTYPE_NI1)
-		test_and_set_bit(FLG_TWO_DCHAN, &cs->HW_Flags);
-#else
-	test_and_set_bit(FLG_TWO_DCHAN, &cs->HW_Flags);
-#endif
-	cs->protocol = card->protocol;
-
-	if (card->typ <= 0 || card->typ > ISDN_CTYPE_COUNT) {
-		printk(KERN_WARNING
-		       "HiSax: Card Type %d out of range\n", card->typ);
-		goto outf_cs;
-	}
-	if (!(cs->dlog = kmalloc(MAX_DLOG_SPACE, GFP_ATOMIC))) {
-		printk(KERN_WARNING
-		       "HiSax: No memory for dlog(card %d)\n", cardnr + 1);
-		goto outf_cs;
-	}
-	if (!(cs->status_buf = kmalloc(HISAX_STATUS_BUFSIZE, GFP_ATOMIC))) {
-		printk(KERN_WARNING
-		       "HiSax: No memory for status_buf(card %d)\n",
-		       cardnr + 1);
-		goto outf_dlog;
-	}
-	cs->stlist = NULL;
-	cs->status_read = cs->status_buf;
-	cs->status_write = cs->status_buf;
-	cs->status_end = cs->status_buf + HISAX_STATUS_BUFSIZE - 1;
-	cs->typ = card->typ;
-#ifdef MODULE
-	cs->iif.owner = lockowner;
-#endif
-	strcpy(cs->iif.id, id);
-	cs->iif.channels = 2;
-	cs->iif.maxbufsize = MAX_DATA_SIZE;
-	cs->iif.hl_hdrlen = MAX_HEADER_LEN;
-	cs->iif.features =
-		ISDN_FEATURE_L2_X75I |
-		ISDN_FEATURE_L2_HDLC |
-		ISDN_FEATURE_L2_HDLC_56K |
-		ISDN_FEATURE_L2_TRANS |
-		ISDN_FEATURE_L3_TRANS |
-#ifdef	CONFIG_HISAX_1TR6
-		ISDN_FEATURE_P_1TR6 |
-#endif
-#ifdef	CONFIG_HISAX_EURO
-		ISDN_FEATURE_P_EURO |
-#endif
-#ifdef	CONFIG_HISAX_NI1
-		ISDN_FEATURE_P_NI1 |
-#endif
-		0;
+	int ret;
 
-	cs->iif.command = HiSax_command;
-	cs->iif.writecmd = NULL;
-	cs->iif.writebuf_skb = HiSax_writebuf_skb;
-	cs->iif.readstat = HiSax_readstatus;
-	register_isdn(&cs->iif);
-	cs->myid = cs->iif.channels;
-	printk(KERN_INFO
-	       "HiSax: Card %d Protocol %s Id=%s (%d)\n", cardnr + 1,
-	       (card->protocol == ISDN_PTYPE_1TR6) ? "1TR6" :
-	       (card->protocol == ISDN_PTYPE_EURO) ? "EDSS1" :
-	       (card->protocol == ISDN_PTYPE_LEASED) ? "LEASED" :
-	       (card->protocol == ISDN_PTYPE_NI1) ? "NI1" :
-	       "NONE", cs->iif.id, cs->myid);
 	switch (card->typ) {
 #if CARD_TELES0
 	case ISDN_CTYPE_16_0:
@@ -1094,13 +1009,109 @@ static int checkcard(int cardnr, char *id, int *busy_flag, struct module *lockow
 		printk(KERN_WARNING
 		       "HiSax: Support for %s Card not selected\n",
 		       CardType[card->typ]);
-		ll_unload(cs);
+		ret = 0;
+		break;
+	}
+
+	return ret;
+}
+
+static int checkcard(int cardnr, char *id, int *busy_flag, struct module *lockowner)
+{
+	int ret = 0;
+	struct IsdnCard *card = cards + cardnr;
+	struct IsdnCardState *cs;
+
+	cs = kzalloc(sizeof(struct IsdnCardState), GFP_ATOMIC);
+	if (!cs) {
+		printk(KERN_WARNING
+		       "HiSax: No memory for IsdnCardState(card %d)\n",
+		       cardnr + 1);
+		goto out;
+	}
+	card->cs = cs;
+	spin_lock_init(&cs->statlock);
+	spin_lock_init(&cs->lock);
+	cs->chanlimit = 2;	/* maximum B-channel number */
+	cs->logecho = 0;	/* No echo logging */
+	cs->cardnr = cardnr;
+	cs->debug = L1_DEB_WARN;
+	cs->HW_Flags = 0;
+	cs->busy_flag = busy_flag;
+	cs->irq_flags = I4L_IRQ_FLAG;
+#if TEI_PER_CARD
+	if (card->protocol == ISDN_PTYPE_NI1)
+		test_and_set_bit(FLG_TWO_DCHAN, &cs->HW_Flags);
+#else
+	test_and_set_bit(FLG_TWO_DCHAN, &cs->HW_Flags);
+#endif
+	cs->protocol = card->protocol;
+
+	if (card->typ <= 0 || card->typ > ISDN_CTYPE_COUNT) {
+		printk(KERN_WARNING
+		       "HiSax: Card Type %d out of range\n", card->typ);
 		goto outf_cs;
 	}
+	if (!(cs->dlog = kmalloc(MAX_DLOG_SPACE, GFP_ATOMIC))) {
+		printk(KERN_WARNING
+		       "HiSax: No memory for dlog(card %d)\n", cardnr + 1);
+		goto outf_cs;
+	}
+	if (!(cs->status_buf = kmalloc(HISAX_STATUS_BUFSIZE, GFP_ATOMIC))) {
+		printk(KERN_WARNING
+		       "HiSax: No memory for status_buf(card %d)\n",
+		       cardnr + 1);
+		goto outf_dlog;
+	}
+	cs->stlist = NULL;
+	cs->status_read = cs->status_buf;
+	cs->status_write = cs->status_buf;
+	cs->status_end = cs->status_buf + HISAX_STATUS_BUFSIZE - 1;
+	cs->typ = card->typ;
+#ifdef MODULE
+	cs->iif.owner = lockowner;
+#endif
+	strcpy(cs->iif.id, id);
+	cs->iif.channels = 2;
+	cs->iif.maxbufsize = MAX_DATA_SIZE;
+	cs->iif.hl_hdrlen = MAX_HEADER_LEN;
+	cs->iif.features =
+		ISDN_FEATURE_L2_X75I |
+		ISDN_FEATURE_L2_HDLC |
+		ISDN_FEATURE_L2_HDLC_56K |
+		ISDN_FEATURE_L2_TRANS |
+		ISDN_FEATURE_L3_TRANS |
+#ifdef	CONFIG_HISAX_1TR6
+		ISDN_FEATURE_P_1TR6 |
+#endif
+#ifdef	CONFIG_HISAX_EURO
+		ISDN_FEATURE_P_EURO |
+#endif
+#ifdef	CONFIG_HISAX_NI1
+		ISDN_FEATURE_P_NI1 |
+#endif
+		0;
+
+	cs->iif.command = HiSax_command;
+	cs->iif.writecmd = NULL;
+	cs->iif.writebuf_skb = HiSax_writebuf_skb;
+	cs->iif.readstat = HiSax_readstatus;
+	register_isdn(&cs->iif);
+	cs->myid = cs->iif.channels;
+	printk(KERN_INFO
+	       "HiSax: Card %d Protocol %s Id=%s (%d)\n", cardnr + 1,
+	       (card->protocol == ISDN_PTYPE_1TR6) ? "1TR6" :
+	       (card->protocol == ISDN_PTYPE_EURO) ? "EDSS1" :
+	       (card->protocol == ISDN_PTYPE_LEASED) ? "LEASED" :
+	       (card->protocol == ISDN_PTYPE_NI1) ? "NI1" :
+	       "NONE", cs->iif.id, cs->myid);
+
+	ret = hisax_cs_setup_card(card);
 	if (!ret) {
 		ll_unload(cs);
 		goto outf_cs;
 	}
+
 	if (!(cs->rcvbuf = kmalloc(MAX_DFRAME_LEN_L1, GFP_ATOMIC))) {
 		printk(KERN_WARNING "HiSax: No memory for isac rcvbuf\n");
 		ll_unload(cs);
