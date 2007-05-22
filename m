Return-Path: <linux-kernel-owner+w=401wt.eu-S1759660AbXEVMpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759660AbXEVMpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 08:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756887AbXEVMpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 08:45:00 -0400
Received: from havoc.gtf.org ([69.61.125.42]:46556 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756617AbXEVMo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 08:44:59 -0400
Date: Tue, 22 May 2007 08:44:58 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>, kkeil@suse.de,
       kai.germaschewski@gmx.de
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ISDN: move card state init to separate function
Message-ID: <20070522124458.GA25591@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The follow is the first baby step towards moving the HiSax drivers to
the new PCI API.  The HiSax PCI initialization code is ass-backwards and
an incredible pain, so this will take many steps.  If anybody is
motivated to assist, help is more than welcome!

The first step just moves some code into a separate function, with the
general direction being the isolation of card-generic code away from all
the heavily #ifdef'd card-specific code.

This patch should not change any behavior at all.  It only includes very
trivial code modifications, like s/kmalloc/kzalloc/, use of gfp_mask,
and the allocation of cs->rcvbuf was moved up to be with the rest of the
memory allocations.

Further changes will be checked into this git branch:

The 'isdn-pci' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git

contains the following updates:

 drivers/isdn/hisax/config.c |   83 ++++++++++++++++++++++++++++--------------
 1 files changed, 55 insertions(+), 28 deletions(-)

Jeff Garzik (1):
      [ISDN] hisax: split cs alloc and init away from checkcard()

diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index da4196f..6c9a336 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -847,13 +847,14 @@ static int init_card(struct IsdnCardState *cs)
 	return 3;
 }
 
-static int checkcard(int cardnr, char *id, int *busy_flag, struct module *lockowner)
+static int hisax_new_cs(int cardnr, struct IsdnCard *card,
+			struct IsdnCardState **cs_out, int *busy_flag,
+			struct module *lockowner, gfp_t gfp_mask)
 {
-	int ret = 0;
-	struct IsdnCard *card = cards + cardnr;
 	struct IsdnCardState *cs;
+	int rc = -ENOMEM;
 
-	cs = kzalloc(sizeof(struct IsdnCardState), GFP_ATOMIC);
+	cs = kzalloc(sizeof(struct IsdnCardState), gfp_mask);
 	if (!cs) {
 		printk(KERN_WARNING
 		       "HiSax: No memory for IsdnCardState(card %d)\n",
@@ -870,30 +871,32 @@ static int checkcard(int cardnr, char *id, int *busy_flag, struct module *lockow
 	cs->HW_Flags = 0;
 	cs->busy_flag = busy_flag;
 	cs->irq_flags = I4L_IRQ_FLAG;
-#if TEI_PER_CARD
-	if (card->protocol == ISDN_PTYPE_NI1)
-		test_and_set_bit(FLG_TWO_DCHAN, &cs->HW_Flags);
-#else
-	test_and_set_bit(FLG_TWO_DCHAN, &cs->HW_Flags);
-#endif
+
 	cs->protocol = card->protocol;
 
 	if (card->typ <= 0 || card->typ > ISDN_CTYPE_COUNT) {
 		printk(KERN_WARNING
 		       "HiSax: Card Type %d out of range\n", card->typ);
+		rc = -EINVAL;
 		goto outf_cs;
 	}
-	if (!(cs->dlog = kmalloc(MAX_DLOG_SPACE, GFP_ATOMIC))) {
+
+	if (!(cs->dlog = kzalloc(MAX_DLOG_SPACE, gfp_mask))) {
 		printk(KERN_WARNING
 		       "HiSax: No memory for dlog(card %d)\n", cardnr + 1);
 		goto outf_cs;
 	}
-	if (!(cs->status_buf = kmalloc(HISAX_STATUS_BUFSIZE, GFP_ATOMIC))) {
+	if (!(cs->status_buf = kzalloc(HISAX_STATUS_BUFSIZE, gfp_mask))) {
 		printk(KERN_WARNING
 		       "HiSax: No memory for status_buf(card %d)\n",
 		       cardnr + 1);
 		goto outf_dlog;
 	}
+	if (!(cs->rcvbuf = kzalloc(MAX_DFRAME_LEN_L1, gfp_mask))) {
+		printk(KERN_WARNING "HiSax: No memory for isac rcvbuf\n");
+		goto outf_status;
+	}
+
 	cs->stlist = NULL;
 	cs->status_read = cs->status_buf;
 	cs->status_write = cs->status_buf;
@@ -911,22 +914,53 @@ static int checkcard(int cardnr, char *id, int *busy_flag, struct module *lockow
 		ISDN_FEATURE_L2_HDLC |
 		ISDN_FEATURE_L2_HDLC_56K |
 		ISDN_FEATURE_L2_TRANS |
-		ISDN_FEATURE_L3_TRANS |
+		ISDN_FEATURE_L3_TRANS;
+	cs->iif.command = HiSax_command;
+	cs->iif.writecmd = NULL;
+	cs->iif.writebuf_skb = HiSax_writebuf_skb;
+	cs->iif.readstat = HiSax_readstatus;
+
+	*cs_out = cs;
+	return 0;
+
+outf_status:
+	kfree(cs->status_buf);
+outf_dlog:
+	kfree(cs->dlog);
+outf_cs:
+	kfree(cs);
+	card->cs = NULL;
+out:
+	*cs_out = NULL;
+	return rc;
+}
+
+static int checkcard(int cardnr, char *id, int *busy_flag, struct module *lockowner)
+{
+	int ret = 0, rc;
+	struct IsdnCard *card = cards + cardnr;
+	struct IsdnCardState *cs = NULL;
+
+	rc = hisax_new_cs(cardnr, card, &cs, busy_flag, lockowner, GFP_ATOMIC);
+	if (rc)
+		goto out;	/* ret == 0 == error */
+
+#if TEI_PER_CARD
+	if (card->protocol == ISDN_PTYPE_NI1)
+		test_and_set_bit(FLG_TWO_DCHAN, &cs->HW_Flags);
+#else
+	test_and_set_bit(FLG_TWO_DCHAN, &cs->HW_Flags);
+#endif
 #ifdef	CONFIG_HISAX_1TR6
-		ISDN_FEATURE_P_1TR6 |
+	cs->iif.features |= ISDN_FEATURE_P_1TR6;
 #endif
 #ifdef	CONFIG_HISAX_EURO
-		ISDN_FEATURE_P_EURO |
+	cs->iif.features |= ISDN_FEATURE_P_EURO;
 #endif
 #ifdef	CONFIG_HISAX_NI1
-		ISDN_FEATURE_P_NI1 |
+	cs->iif.features |= ISDN_FEATURE_P_NI1;
 #endif
-		0;
 
-	cs->iif.command = HiSax_command;
-	cs->iif.writecmd = NULL;
-	cs->iif.writebuf_skb = HiSax_writebuf_skb;
-	cs->iif.readstat = HiSax_readstatus;
 	register_isdn(&cs->iif);
 	cs->myid = cs->iif.channels;
 	printk(KERN_INFO
@@ -1101,11 +1135,6 @@ static int checkcard(int cardnr, char *id, int *busy_flag, struct module *lockow
 		ll_unload(cs);
 		goto outf_cs;
 	}
-	if (!(cs->rcvbuf = kmalloc(MAX_DFRAME_LEN_L1, GFP_ATOMIC))) {
-		printk(KERN_WARNING "HiSax: No memory for isac rcvbuf\n");
-		ll_unload(cs);
-		goto outf_cs;
-	}
 	cs->rcvidx = 0;
 	cs->tx_skb = NULL;
 	cs->tx_cnt = 0;
@@ -1146,8 +1175,6 @@ static int checkcard(int cardnr, char *id, int *busy_flag, struct module *lockow
 	ret = 1;
 	goto out;
 
- outf_dlog:
-	kfree(cs->dlog);
  outf_cs:
 	kfree(cs);
 	card->cs = NULL;
