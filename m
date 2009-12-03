Return-Path: <linux-kernel-owner+w=401wt.eu-S1755634AbZLCVOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbZLCVOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 16:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbZLCVON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 16:14:13 -0500
Received: from p01c11o145.mxlogic.net ([208.65.144.68]:42586 "EHLO
	p01c11o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbZLCVOM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 16:14:12 -0500
X-Greylist: delayed 455 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Dec 2009 16:14:12 EST
X-MXL-Hash: 4b182a2b077dcd85-c7f1ebf5e1638b2e9ff7262e62e4a4411f216dc1
X-MXL-Hash: 4b182863120a2827-33468ed6308b35d5af14ac6496797f73ec0328cc
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH 2.6.32 1/3] net: Fix ks8851 snl NULL pointer dereference Oops
Date: Thu, 3 Dec 2009 13:06:42 -0800
Message-ID: <14385191E87B904DBD836449AA30269D021A40@MORGANITE.micrel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.32 1/3] net: Fix ks8851 snl NULL pointer dereference Oops
Thread-Index: Acp0Wt/33R+JFyxWRIyhBiO9ChRRhg==
From: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
To: "Ben Dooks" <ben@simtec.co.uk>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 03 Dec 2009 21:06:42.0372 (UTC) FILETIME=[8364E040:01CA745C]
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2009113001)]
X-MAIL-FROM: <tristram.ha@micrel.com>
X-SOURCE-IP: [65.218.208.2]
X-AnalysisOut: [v=1.0 c=1 a=8n3w4sfrkw4A:10 a=J3BOMSfJb05aRia9DmE+FQ==:17 ]
X-AnalysisOut: [a=Q4n7fi2PAAAA:8 a=5_BfxKqGAAAA:8 a=4Oy_iV3DYWQYelAV22AA:9]
X-AnalysisOut: [ a=OXyDB8_uO0K8Uhx2X-EA:7 a=6ITZgDGDxAxIpFPvw-UIgsrz0kwA:4]
X-AnalysisOut: [ a=yJsD6ztlz_8A:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tristram Ha <Tristram.Ha@micrel.com>

This fixes the NULL pointer dereference Oops in the ks8851 snl network driver during transmission.  All socket buffers from the queue are processed inside the loop, but new workqueues have been scheduled to run.

Signed-off-by: Tristram Ha <Tristram.Ha@micrel.com>
---
diff -urpN linux-2.6.32.old/drivers/net/ks8851.c linux-2.6.32.new/drivers/net/ks8851.c
--- linux-2.6.32.old/drivers/net/ks8851.c	2009-11-03 11:37:49.000000000 -0800
+++ linux-2.6.32.new/drivers/net/ks8851.c	2009-12-02 15:31:39.000000000 -0800
@@ -1,4 +1,4 @@
-/* drivers/net/ks8651.c
+/* drivers/net/ks8851.c
  *
  * Copyright 2009 Simtec Electronics
  *	http://www.simtec.co.uk/
@@ -714,7 +714,7 @@ static void ks8851_tx_work(struct work_s
 {
 	struct ks8851_net *ks = container_of(work, struct ks8851_net, tx_work);
 	struct sk_buff *txb;
-	bool last = false;
+	bool last = skb_queue_empty(&ks->txq);
 
 	mutex_lock(&ks->lock);
 
