Return-Path: <linux-kernel-owner+w=401wt.eu-S1423388AbXBHVPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423388AbXBHVPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 16:15:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423397AbXBHVPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 16:15:05 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:35575 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423388AbXBHVPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 16:15:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=keEMCYsFXQ/7tmIohNjqHI4iskX+9lBVF20WTyPMcf4v9DklHpEelWNGh6W1v1nUe8nI+pmnWdTwiu33RpnhIGdAgAck8wivdVgTMEBUHwPH3jg52Exy8if9OufH+ByZ3j6kKnRu9TEdmDYKUxMWYGAI10CFbVESR2qImNb+hUQ=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: netdev@vger.kernel.org
Subject: [PATCH 2.6.20 2/5] dmfe: Fix two bugs
Date: Thu, 8 Feb 2007 23:11:49 +0200
User-Agent: KMail/1.9.4
References: <200702082305.26735.maximlevitsky@gmail.com>
In-Reply-To: <200702082305.26735.maximlevitsky@gmail.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702082311.50122.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxim Levitsky <maximlevitsky@gmail.com>
Subject : [PATCH 2.6.20 2/5] dmfe: Fix two bugs

Fix a oops on module removal due to deallocating memory before unregistring 
driver
Fix a NULL pointer dereference when dev_alloc_skb fails

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>

---

--- linux-2.6.20-mod/drivers/net/tulip/dmfe.c	2007-02-08 20:41:25.000000000 
+0200
+++ linux-2.6.20-test/drivers/net/tulip/dmfe.c	2007-02-08 20:48:11.000000000 
+0200
@@ -504,14 +504,17 @@ static void __devexit dmfe_remove_one (s
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
 
@@ -930,7 +933,7 @@ static inline u32 cal_CRC(unsigned char 
 static void dmfe_rx_packet(struct DEVICE *dev, struct dmfe_board_info * db)
 {
 	struct rx_desc *rxptr;
-	struct sk_buff *skb;
+	struct sk_buff *skb, *newskb;
 	int rxlen;
 	u32 rdes0;
 
@@ -984,8 +987,10 @@ static void dmfe_rx_packet(struct DEVICE
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
