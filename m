Return-Path: <linux-kernel-owner+w=401wt.eu-S1757259AbZLUVhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbZLUVhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 16:37:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756811AbZLUVhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 16:37:09 -0500
Received: from p01c12o143.mxlogic.net ([208.65.145.66]:36215 "EHLO
	p01c12o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbZLUVhI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 16:37:08 -0500
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Dec 2009 16:37:07 EST
X-MXL-Hash: 4b2fea83393b0ffe-33d2a8e248819ab265ecd91d0a09a8a98f09f69b
X-MXL-Hash: 4b2fe8d46556a93a-c698af7122e84ddc73728e80d870e3eb9676c7f7
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH 2.6.33] net: Fix ks8851 snl receive problem
Date: Mon, 21 Dec 2009 13:29:42 -0800
Message-ID: <14385191E87B904DBD836449AA30269D021A44@MORGANITE.micrel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.33] net: Fix ks8851 snl receive problem
Thread-Index: AcqChLUwsBo/+0EvSjWJoipeYWRELQ==
From: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
To: "Ben Dooks" <ben@simtec.co.uk>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 21 Dec 2009 21:29:42.0402 (UTC) FILETIME=[B5643E20:01CA8284]
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2009113001)]
X-MAIL-FROM: <tristram.ha@micrel.com>
X-SOURCE-IP: [65.218.208.2]
X-AnalysisOut: [v=1.0 c=1 a=7BbOX77FYVoA:10 a=J3BOMSfJb05aRia9DmE+FQ==:17 ]
X-AnalysisOut: [a=Q4n7fi2PAAAA:8 a=ppD5YTO_e67L72WQLCoA:9 a=FpRZrd8Vu496fJ]
X-AnalysisOut: [K9U44A:7 a=hoygO3RCf24fiv19fAamJWqUugsA:4 a=yJsD6ztlz_8A:1]
X-AnalysisOut: [0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tristram Ha <Tristram.Ha@micrel.com>

This fixes a receive problem of the ks8851 snl network driver.  Under heavy TCP traffic the device will stop operating correctly.  First the receive interrupt is not triggered anymore.  After then the driver cannot retrieve the correct packets from the device.  A workaround for this problem is to disable the transmit done interrupt.

Signed-off-by: Tristram Ha <Tristram.Ha@micrel.com>
---
This patch has some relations to two previous patches I submitted: "[PATH 2.6.32 2/3] net: Fix ks8851 snl transmit problem" and "[PATCH 2.6.32 3/3] net: Make ks8851 snl work under Beagle Zippy combo board."  Please see my replies regarding those patches.

--- linux-2.6.33-rc1.old/drivers/net/ks8851.c	2009-12-08 17:46:20.000000000 -0800
+++ linux-2.6.33-rc1.new/drivers/net/ks8851.c	2009-12-21 10:43:43.000000000 -0800
@@ -551,6 +551,13 @@ static void ks8851_irq_work(struct work_
 
 	mutex_lock(&ks->lock);
 
+	/*
+	 * Turn off hardware interrupt during receive processing.  This fixes
+	 * the receive problem under heavy TCP traffic while transmit done
+	 * is enabled.
+	 */
+	ks8851_wrreg16(ks, KS_IER, 0);
+
 	status = ks8851_rdreg16(ks, KS_ISR);
 
 	if (netif_msg_intr(ks))
@@ -621,6 +628,9 @@ static void ks8851_irq_work(struct work_
 		ks8851_wrreg16(ks, KS_RXCR1, rxc->rxcr1);
 	}
 
+	/* Re-enable hardware interrupt. */
+	ks8851_wrreg16(ks, KS_IER, ks->rc_ier);
+
 	mutex_unlock(&ks->lock);
 
 	if (status & IRQ_TXI)
