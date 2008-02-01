Return-Path: <linux-kernel-owner+w=401wt.eu-S1765037AbYBANqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765037AbYBANqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 08:46:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756217AbYBANp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 08:45:58 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:39488 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755023AbYBANp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 08:45:57 -0500
Date: Fri, 1 Feb 2008 14:46:00 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: isdn4linux@listserv.isdn4linux.de
Subject: Re: [PATCH 0/5] isdn: fix section mismatch warnings in isdn
Message-ID: <20080201134600.GA13524@uranus.ravnborg.org>
References: <20080201133838.GA13349@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201133838.GA13349@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If anyone like to test it here is a cumulative patch.

	Sam

diff --git a/drivers/isdn/hisax/amd7930_fn.c b/drivers/isdn/hisax/amd7930_fn.c
index c0d7036..341faf5 100644
--- a/drivers/isdn/hisax/amd7930_fn.c
+++ b/drivers/isdn/hisax/amd7930_fn.c
@@ -744,8 +744,7 @@ dbusy_timer_handler(struct IsdnCardState *cs)
 
 
 
-void __devinit
-Amd7930_init(struct IsdnCardState *cs)
+void Amd7930_init(struct IsdnCardState *cs)
 {
     WORD *ptr;
     BYTE cmd, cnt;
diff --git a/drivers/isdn/hisax/avm_a1p.c b/drivers/isdn/hisax/avm_a1p.c
index c87fa3f..3039c6d 100644
--- a/drivers/isdn/hisax/avm_a1p.c
+++ b/drivers/isdn/hisax/avm_a1p.c
@@ -213,8 +213,7 @@ AVM_card_msg(struct IsdnCardState *cs, int mt, void *arg)
 	return 0;
 }
 
-int
-setup_avm_a1_pcmcia(struct IsdnCard *card)
+int __devinit setup_avm_a1_pcmcia(struct IsdnCard *card)
 {
 	u_char model, vers;
 	struct IsdnCardState *cs = card->cs;
diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index 97097ef..a0ee43c 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -847,7 +847,7 @@ static int init_card(struct IsdnCardState *cs)
 	return 3;
 }
 
-static int hisax_cs_setup_card(struct IsdnCard *card)
+static int __devinit hisax_cs_setup_card(struct IsdnCard *card)
 {
 	int ret;
 
@@ -1166,7 +1166,10 @@ outf_cs:
 	return 0;
 }
 
-static int checkcard(int cardnr, char *id, int *busy_flag, struct module *lockowner)
+/* Used from an exported function but calls __devinit functions.
+ * Tell modpost not to warn (__ref)
+ */
+static int __ref checkcard(int cardnr, char *id, int *busy_flag, struct module *lockowner)
 {
 	int ret;
 	struct IsdnCard *card = cards + cardnr;
diff --git a/drivers/isdn/hisax/hfc_sx.c b/drivers/isdn/hisax/hfc_sx.c
index 4fd09d2..05482d2 100644
--- a/drivers/isdn/hisax/hfc_sx.c
+++ b/drivers/isdn/hisax/hfc_sx.c
@@ -1330,8 +1330,7 @@ hfcsx_bh(struct work_struct *work)
 /********************************/
 /* called for card init message */
 /********************************/
-static void __devinit
-inithfcsx(struct IsdnCardState *cs)
+static void inithfcsx(struct IsdnCardState *cs)
 {
 	cs->setstack_d = setstack_hfcsx;
 	cs->BC_Send_Data = &hfcsx_send_data;
diff --git a/drivers/isdn/hisax/isac.c b/drivers/isdn/hisax/isac.c
index 4e9f238..07b1673 100644
--- a/drivers/isdn/hisax/isac.c
+++ b/drivers/isdn/hisax/isac.c
@@ -27,8 +27,7 @@ static char *ISACVer[] __devinitdata =
 {"2086/2186 V1.1", "2085 B1", "2085 B2",
  "2085 V2.3"};
 
-void
-ISACVersion(struct IsdnCardState *cs, char *s)
+void __devinit ISACVersion(struct IsdnCardState *cs, char *s)
 {
 	int val;
 
@@ -616,8 +615,7 @@ dbusy_timer_handler(struct IsdnCardState *cs)
 	}
 }
 
-void __devinit
-initisac(struct IsdnCardState *cs)
+void initisac(struct IsdnCardState *cs)
 {
 	cs->setstack_d = setstack_isac;
 	cs->DC_Close = DC_Close_isac;
@@ -648,8 +646,7 @@ initisac(struct IsdnCardState *cs)
 	cs->writeisac(cs, ISAC_MASK, 0x0);
 }
 
-void __devinit
-clear_pending_isac_ints(struct IsdnCardState *cs)
+void clear_pending_isac_ints(struct IsdnCardState *cs)
 {
 	int val, eval;
 
diff --git a/drivers/isdn/hisax/isar.c b/drivers/isdn/hisax/isar.c
index c547a66..bfeb9b6 100644
--- a/drivers/isdn/hisax/isar.c
+++ b/drivers/isdn/hisax/isar.c
@@ -1894,8 +1894,7 @@ isar_auxcmd(struct IsdnCardState *cs, isdn_ctrl *ic) {
 	return(0);
 }
 
-void __devinit
-initisar(struct IsdnCardState *cs)
+void initisar(struct IsdnCardState *cs)
 {
 	cs->bcs[0].BC_SetStack = setstack_isar;
 	cs->bcs[1].BC_SetStack = setstack_isar;
