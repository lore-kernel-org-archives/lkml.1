Return-Path: <linux-kernel-owner+w=401wt.eu-S1161275AbXBOVEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161275AbXBOVEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 16:04:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161277AbXBOVEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 16:04:12 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:58646 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161275AbXBOVEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 16:04:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=KB98OybK2fw9mduSb8VbW+oI+ZWdFRWJjJrYvVvHchOoEhtrvrlxhqW3/7VlFafTj1phP7wWYjy0zDOkL/cHYYsxzFIC4j19xnFFdRvrmXYb4OuVs0wf6ehTS+1gtVCzd+HisoeNZ/ryjQ06wm7PYLkOM41zqWrDsh9vM5Llmag=
From: Maxim <maximlevitsky@gmail.com>
To: netdev@kernel.org
Subject: [PATCH 2.6.20 002/005] [RESEND v2] dmfe : Fix two bugs
Date: Thu, 15 Feb 2007 23:04:03 +0200
User-Agent: KMail/1.9.6
References: <200702152253.53680.maximlevitsky@gmail.com>
In-Reply-To: <200702152253.53680.maximlevitsky@gmail.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702152304.03835.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 2.6.20 002/005] [RESEND v2] dmfe : Fix two bugs

Fix a oops on module removal due to deallocating memory before unregistring driver
Fix a NULL pointer dereference when dev_alloc_skb fails

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>

---

--- linux-2.6.20-mod/drivers/net/tulip/dmfe.c	2007-02-15 17:59:33.000000000 +0200
+++ linux-2.6.20-test/drivers/net/tulip/dmfe.c	2007-02-15 18:00:14.000000000 +0200
@@ -501,14 +501,17 @@ static void __devexit dmfe_remove_one (s
 	DMFE_DBUG(0, "dmfe_remove_one()", 0);
 
  	if (dev) {
+		
+		unregister_netdev(dev);
+		
 		pci_free_consistent(db->pdev, sizeof(struct tx_desc) *
 					DESC_ALL_CNT + 0x20, db->desc_pool_ptr,
  					db->desc_pool_dma_ptr);
 		pci_free_consistent(db->pdev, TX_BUF_ALLOC * TX_DESC_CNT + 4,
 					db->buf_pool_ptr, db->buf_pool_dma_ptr);
-		unregister_netdev(dev);
 		pci_release_regions(pdev);
 		free_netdev(dev);	/* free board information */
+		
 		pci_set_drvdata(pdev, NULL);
 	}
 
@@ -927,7 +930,7 @@ static inline u32 cal_CRC(unsigned char 
 static void dmfe_rx_packet(struct DEVICE *dev, struct dmfe_board_info * db)
 {
 	struct rx_desc *rxptr;
-	struct sk_buff *skb;
+	struct sk_buff *skb, *newskb;
 	int rxlen;
 	u32 rdes0;
 
@@ -981,8 +984,10 @@ static void dmfe_rx_packet(struct DEVICE
 					/* Good packet, send to upper layer */
 					/* Shorst packet used new SKB */
 					if ( (rxlen < RX_COPY_SIZE) &&
-						( (skb = dev_alloc_skb(rxlen + 2) )
+						( (newskb = dev_alloc_skb(rxlen + 2) )
 						!= NULL) ) {
+						
+						skb = newskb;
 						/* size less than COPY_SIZE, allocate a rxlen SKB */
 						skb->dev = dev;
 						skb_reserve(skb, 2); /* 16byte align */
