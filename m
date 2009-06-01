Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbZFAJAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbZFAJAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 05:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754340AbZFAJAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 05:00:47 -0400
Received: from bu3sch.de ([62.75.166.246]:55139 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692AbZFAJAq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 05:00:46 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: parport_pc: Fix subscription bugs
Date: Mon, 1 Jun 2009 11:00:33 +0200
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906011100.34086.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes array subscription bugs in the parport_pc driver.

drivers/parport/parport_pc.c: In function ‘parport_irq_probe’:
drivers/parport/parport_pc.c:1589: warning: array subscript is above array bounds
drivers/parport/parport_pc.c: In function ‘parport_pc_probe_port’:
drivers/parport/parport_pc.c:1579: warning: array subscript is above array bounds

The patch also fixes a few other array bugs, which the compiler was
unable to find. Coding style violations are also fixed.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Stable <stable@kernel.org>

---

These are real bugs, not just bogus compiler warnings.


Index: wireless-testing/drivers/parport/parport_pc.c
===================================================================
--- wireless-testing.orig/drivers/parport/parport_pc.c	2009-04-29 22:43:55.000000000 +0200
+++ wireless-testing/drivers/parport/parport_pc.c	2009-06-01 10:51:48.000000000 +0200
@@ -1243,23 +1243,23 @@ static void __devinit show_parconfig_sms
 		printk(KERN_INFO "SMSC LPT Config: enabled=%s power=%s\n",
 		       (cr23*4 >=0x100) ?"yes":"no", (cr1 & 4) ? "yes" : "no");
 		printk(KERN_INFO "SMSC LPT Config: Port mode=%s, EPP version =%s\n",
 		       (cr1 & 0x08 ) ? "Standard mode only (SPP)" : modes[cr4 & 0x03], 
 		       (cr4 & 0x40) ? "1.7" : "1.9");
 	}
-		
+
 	/* Heuristics !  BIOS setup for this mainboard device limits
 	   the choices to standard settings, i.e. io-address and IRQ
 	   are related, however DMA can be 1 or 3, assume DMA_A=DMA1,
 	   DMA_C=DMA3 (this is true e.g. for TYAN 1564D Tomcat IV) */
-	if(cr23*4 >=0x100) { /* if active */
-		while((superios[i].io!= 0) && (i<NR_SUPERIOS))
+	if (cr23 * 4 >= 0x100) { /* if active */
+		while ((i < NR_SUPERIOS) && (superios[i].io != 0))
 			i++;
-		if(i==NR_SUPERIOS)
+		if (i == NR_SUPERIOS) {
 			printk(KERN_INFO "Super-IO: too many chips!\n");
-		else {
+		} else {
 			int d;
 			switch (cr23*4) {
 				case 0x3bc:
 					superios[i].io = 0x3bc;
 					superios[i].irq = 7;
 					break;
@@ -1329,18 +1329,18 @@ static void __devinit show_parconfig_win
 			printk("dma=%d\n",cr74 & 0x07);
 		printk(KERN_INFO "Winbond LPT Config: irqtype=%s, ECP fifo threshold=%d\n",
 		       irqtypes[crf0>>7], (crf0>>3)&0x0f);
 		printk(KERN_INFO "Winbond LPT Config: Port mode=%s\n", modes[crf0 & 0x07]);
 	}
 
-	if(cr30 & 0x01) { /* the settings can be interrogated later ... */
-		while((superios[i].io!= 0) && (i<NR_SUPERIOS))
+	if (cr30 & 0x01) { /* the settings can be interrogated later ... */
+		while ((i < NR_SUPERIOS) && (superios[i].io != 0))
 			i++;
-		if(i==NR_SUPERIOS) 
+		if (i == NR_SUPERIOS) {
 			printk(KERN_INFO "Super-IO: too many chips!\n");
-		else {
+		} else {
 			superios[i].io = (cr60<<8)|cr61;
 			superios[i].irq = cr70&0x0f;
 			superios[i].dma = (((cr74 & 0x07) > 3) ?
 					   PARPORT_DMA_NONE : (cr74 & 0x07));
 		}
 	}
@@ -1572,30 +1572,32 @@ static void __devinit detect_and_report_
 	release_region(0x2e, 1);
 }
 #endif /* CONFIG_PARPORT_PC_SUPERIO */
 
 static int get_superio_dma (struct parport *p)
 {
-	int i=0;
-	while( (superios[i].io != p->base) && (i<NR_SUPERIOS))
+	int i = 0;
+
+	while ((i < NR_SUPERIOS) && (superios[i].io != p->base))
 		i++;
-	if (i!=NR_SUPERIOS)
+	if (i != NR_SUPERIOS)
 		return superios[i].dma;
 	return PARPORT_DMA_NONE;
 }
 
 static int get_superio_irq (struct parport *p)
 {
-	int i=0;
-        while( (superios[i].io != p->base) && (i<NR_SUPERIOS))
+	int i = 0;
+
+        while ((i < NR_SUPERIOS) && (superios[i].io != p->base))
                 i++;
-        if (i!=NR_SUPERIOS)
+        if (i != NR_SUPERIOS)
                 return superios[i].irq;
         return PARPORT_IRQ_NONE;
 }
-	
+
 
 /* --- Mode detection ------------------------------------- */
 
 /*
  * Checks for port existence, all ports support SPP MODE
  * Returns: 

-- 
Greetings, Michael.
