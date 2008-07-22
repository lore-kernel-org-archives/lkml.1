Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbYGVWwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbYGVWwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 18:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbYGVWwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 18:52:23 -0400
Received: from mailbox2.myri.com ([64.172.73.26]:1892 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751223AbYGVWwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 18:52:22 -0400
Message-ID: <488664A0.3040407@myri.com>
Date: Wed, 23 Jul 2008 00:52:16 +0200
From: Brice Goglin <brice@myri.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: Regression: myri10ge driver in 2.6.26
References: <20080722150438.GK4359@ics.muni.cz> <48865B04.6030707@myri.com>
In-Reply-To: <48865B04.6030707@myri.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brice Goglin wrote:
> Lukas Hejtmanek wrote:
>   
>> Hello,
>>
>> the myri10ge driver in 2.6.26 vanila kernel does not work.
>>
>> Loading the driver produces only:
>> [   86.641632] myri10ge: Version 1.3.99-1.347
>> [   86.641632] PCI: Setting latency timer of device 0000:07:00.0 to 64
>>
>> and nothing more.  
>>     
>
> I have seen one machine with a similar problem. Does reverting
> 014377a1df693ff30a9e8b69f0bbb0a38e601f75 help? Also could you check that
> current Linus' git works fine? (just get the driver source from there,
> no need to build the whole tree)
>   

If the above is correct, then patch below should fix it. If so, I'll
push this into the next stable 2.6.26.x release.

Brice

--- linux.old/drivers/net/myri10ge/myri10ge.c	2008-07-23 00:38:52.000000000 +0200
+++ linux/drivers/net/myri10ge/myri10ge.c	2008-07-23 00:43:16.000000000 +0200
@@ -3213,26 +3213,26 @@
 	for (i = 0; i < ETH_ALEN; i++)
 		netdev->dev_addr[i] = mgp->mac_addr[i];
 
-	/* allocate rx done ring */
-	bytes = mgp->max_intr_slots * sizeof(*mgp->ss.rx_done.entry);
-	mgp->ss.rx_done.entry = dma_alloc_coherent(&pdev->dev, bytes,
-						&mgp->ss.rx_done.bus, GFP_KERNEL);
-	if (mgp->ss.rx_done.entry == NULL)
-		goto abort_with_ioremap;
-	memset(mgp->ss.rx_done.entry, 0, bytes);
-
 	myri10ge_select_firmware(mgp);
 
 	status = myri10ge_load_firmware(mgp);
 	if (status != 0) {
 		dev_err(&pdev->dev, "failed to load firmware\n");
-		goto abort_with_rx_done;
+		goto abort_with_ioremap;
 	}
 
+	/* allocate rx done ring */
+	bytes = mgp->max_intr_slots * sizeof(*mgp->ss.rx_done.entry);
+	mgp->ss.rx_done.entry = dma_alloc_coherent(&pdev->dev, bytes,
+						&mgp->ss.rx_done.bus, GFP_KERNEL);
+	if (mgp->ss.rx_done.entry == NULL)
+		goto abort_with_firmware;
+	memset(mgp->ss.rx_done.entry, 0, bytes);
+
 	status = myri10ge_reset(mgp);
 	if (status != 0) {
 		dev_err(&pdev->dev, "failed reset\n");
-		goto abort_with_firmware;
+		goto abort_with_rx_done;
 	}
 
 	pci_set_drvdata(pdev, mgp);
@@ -3258,7 +3258,7 @@
 	 * is set to correct value if MSI is enabled */
 	status = myri10ge_request_irq(mgp);
 	if (status != 0)
-		goto abort_with_firmware;
+		goto abort_with_rx_done;
 	netdev->irq = pdev->irq;
 	myri10ge_free_irq(mgp);
 
@@ -3287,14 +3287,14 @@
 abort_with_state:
 	pci_restore_state(pdev);
 
-abort_with_firmware:
-	myri10ge_dummy_rdma(mgp, 0);
-
 abort_with_rx_done:
 	bytes = mgp->max_intr_slots * sizeof(*mgp->ss.rx_done.entry);
 	dma_free_coherent(&pdev->dev, bytes,
 			  mgp->ss.rx_done.entry, mgp->ss.rx_done.bus);
 
+abort_with_firmware:
+	myri10ge_dummy_rdma(mgp, 0);
+
 abort_with_ioremap:
 	iounmap(mgp->sram);
 


