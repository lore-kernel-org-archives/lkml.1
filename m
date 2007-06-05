Return-Path: <linux-kernel-owner+w=401wt.eu-S933021AbXFEPwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021AbXFEPwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 11:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932760AbXFEPwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 11:52:08 -0400
Received: from er-systems.de ([85.25.136.202]:46387 "EHLO er-systems.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932618AbXFEPwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 11:52:06 -0400
Date: Tue, 5 Jun 2007 17:52:04 +0200 (CEST)
From: Thomas Voegtle <tv@lio96.de>
To: linux-kernel@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>,
       akpm@linux-foundation.org
cc: Bastian Friedrich <bastian@bastian-friedrich.de>
Subject: Re: [Patch] sane irq initialization in sedlbauer/hisax (was: hisax
 isdn card (Sedlbauer Speed Fax+) does not get an interrupt)
In-Reply-To: <Pine.LNX.4.63.0705311520150.9151@er-systems.de>
Message-ID: <Pine.LNX.4.63.0706051315090.20996@er-systems.de>
References: <Pine.LNX.4.63.0705311520150.9151@er-systems.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="425052808-1380272027-1181042226=:20996"
Content-ID: <Pine.LNX.4.63.0706051739060.29324@er-systems.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--425052808-1380272027-1181042226=:20996
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.63.0706051317161.20996@er-systems.de>

Hi,

On Thu, 31 May 2007, Thomas Voegtle wrote:
> ==========================================================================
[...]
> <06>2007 May 30 14:21:40 cbs kern: Sedlbauer: PCI base adr 0xa800
> <03>2007 May 30 14:21:40 cbs kern: irq 11: nobody cared (try booting with the \"irqpoll\" option)
[...]
> <03>2007 May 30 14:21:40 cbs kern: handlers:
> <03>2007 May 30 14:21:40 cbs kern: [<c030899d>] (usb_hcd_irq+0x0/0x4f)
> <00>2007 May 30 14:21:40 cbs kern: Disabling IRQ #11



As described, the interrupt handler is registered too late, so early 
incoming interrupts lead to the original problem. The patch first disables 
the interrupts (byteout(..., 0)), then registers the irq, and finally 
enables the irqs again (byteout(..., 2) as was done at the first point 
before).

Please note that the patch was developed without access to technical 
specifications; the /exact/ meaning of the constants being written to the 
registers are unknown.

Patch applies to 2.6.22-rc4.

Signed-off-by: Bastian Friedrich <bastian@bastian-friedrich.de>
Signed-off-by: Thomas Voegtle <tv@lio96.de>


diff -uNr linux-2.6.22rc4/drivers/isdn/hisax/config.c linux-2.6.22rc4/drivers/isdn/hisax/config.c
--- linux-2.6.22rc4/drivers/isdn/hisax/config.c	2007-06-05 17:16:24.000000000 +0200
+++ linux-2.6.22rc4/drivers/isdn/hisax/config.c	2007-06-05 17:20:28.000000000 +0200
@@ -511,6 +511,7 @@
 
 #if CARD_SEDLBAUER
 extern int setup_sedlbauer(struct IsdnCard *card);
+extern void sedlbauer_enable_interrupts(struct IsdnCardState *cs);
 #endif
 
 #if CARD_SPORTSTER
@@ -822,6 +823,7 @@
 		       cs->irq);
 		return 1;
 	}
+	sedlbauer_enable_interrupts(cs);
 	while (cnt) {
 		cs->cardmsg(cs, CARD_INIT, NULL);
 		/* Timeout 10ms */
diff -uNr linux-2.6.22rc4/drivers/isdn/hisax/sedlbauer.c linux-2.6.22rc4/drivers/isdn/hisax/sedlbauer.c
--- linux-2.6.22rc4/drivers/isdn/hisax/sedlbauer.c	2007-04-26 05:08:32.000000000 +0200
+++ linux-2.6.22rc4/drivers/isdn/hisax/sedlbauer.c	2007-06-05 17:20:28.000000000 +0200
@@ -529,6 +529,19 @@
 static struct pnp_card *pnp_c __devinitdata = NULL;
 #endif
 
+int
+sedlbauer_enable_interrupts(struct IsdnCardState *cs)
+{
+#ifdef CONFIG_PCI
+	if ((cs->typ == ISDN_CTYPE_SEDLBAUER) ||
+	   (cs->typ == ISDN_CTYPE_SEDLBAUER_FAX)) {
+		byteout(cs->hw.sedl.cfg_reg+ 5, 0x02);
+	}
+#endif
+	return 0;
+}
+
+
 int __devinit
 setup_sedlbauer(struct IsdnCard *card)
 {
@@ -667,7 +680,8 @@
 		byteout(cs->hw.sedl.cfg_reg, 0xff);
 		byteout(cs->hw.sedl.cfg_reg, 0x00);
 		byteout(cs->hw.sedl.cfg_reg+ 2, 0xdd);
-		byteout(cs->hw.sedl.cfg_reg+ 5, 0x02);
+		byteout(cs->hw.sedl.cfg_reg+ 5, 0x00);
+			 /* 0 seems to be "disable". Enable (-> 0x02) later! */
 		byteout(cs->hw.sedl.cfg_reg +3, cs->hw.sedl.reset_on);
 		mdelay(2);
 		byteout(cs->hw.sedl.cfg_reg +3, cs->hw.sedl.reset_off);






-- 
 Thomas Vögtle    email: thomas@voegtle-clan.de
 ----- http://www.voegtle-clan.de/thomas ------
--425052808-1380272027-1181042226=:20996--
