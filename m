Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbZLCVa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbZLCVa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 16:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbZLCVa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 16:30:56 -0500
Received: from p01c11o144.mxlogic.net ([208.65.144.67]:48685 "EHLO
	p01c11o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbZLCVaz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 16:30:55 -0500
X-MXL-Hash: 4b182e166c79d638-7cba1f9217ce4f4e25334bed98cb2f21fbd07b08
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH 2.6.32 3/3] net: Make ks8851 snl work under Beagle Zippy combo board
Date: Thu, 3 Dec 2009 13:30:03 -0800
Message-ID: <14385191E87B904DBD836449AA30269D021A42@MORGANITE.micrel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.32 3/3] net: Make ks8851 snl work under Beagle Zippy combo board
Thread-Index: Acp0X8ZH67S3aHKkQrOZhrG5gy3AVQ==
From: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
To: "Ben Dooks" <ben@simtec.co.uk>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 03 Dec 2009 21:30:03.0120 (UTC) FILETIME=[C64E0F00:01CA745F]
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2009113001)]
X-MAIL-FROM: <tristram.ha@micrel.com>
X-SOURCE-IP: [65.218.208.2]
X-AnalysisOut: [v=1.0 c=1 a=1NDvmQSjS8MA:10 a=J3BOMSfJb05aRia9DmE+FQ==:17 ]
X-AnalysisOut: [a=Q4n7fi2PAAAA:8 a=5up0PxFPkEGkKBIfix0A:9 a=wUhFBcORCP6eGC]
X-AnalysisOut: [76Zf43l0FYoqsA:4 a=yJsD6ztlz_8A:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tristram Ha <Tristram.Ha@micrel.com>

The Micrel KSZ8851 SNL Ethernet chip is used in the OMAP Beagle Zippy combo board.  Requesting interrupt using level triggering flag hangs the system because the interrupt handling routine is called continually.  Using edge triggering avoids this problem.  As a result, disabling interrupt may not be necessary.

Signed-off-by: Tristram Ha <Tristram.Ha@micrel.com>
---
diff -urpN linux-2.6.32.old/drivers/net/ks8851.c linux-2.6.32.new/drivers/net/ks8851.c
--- linux-2.6.32.old/drivers/net/ks8851.c	2009-11-03 11:37:49.000000000 -0800
+++ linux-2.6.32.new/drivers/net/ks8851.c	2009-12-02 15:31:39.000000000 -0800
@@ -398,7 +398,6 @@ static irqreturn_t ks8851_irq(int irq, v
 {
 	struct ks8851_net *ks = pw;
 
-	disable_irq_nosync(irq);
 	schedule_work(&ks->irq_work);
 	return IRQ_HANDLED;
 }
@@ -611,8 +610,6 @@ static void ks8851_irq_work(struct work_
 	}
 
 	mutex_unlock(&ks->lock);
-
-	enable_irq(ks->netdev->irq);
 }
 
 /**
@@ -1284,7 +1281,7 @@ static int __devinit ks8851_probe(struct
 	ks8851_init_mac(ks);
 	ks->tx_space = ks8851_rdreg16(ks, KS_TXMIR);
 
-	ret = request_irq(spi->irq, ks8851_irq, IRQF_TRIGGER_LOW,
+	ret = request_irq(spi->irq, ks8851_irq, IRQF_TRIGGER_FALLING,
 			  ndev->name, ks);
 	if (ret < 0) {
 		dev_err(&spi->dev, "failed to get irq\n");
