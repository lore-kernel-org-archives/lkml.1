Return-Path: <linux-kernel-owner+w=401wt.eu-S1161413AbXBGR7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161413AbXBGR7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 12:59:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161412AbXBGR7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 12:59:43 -0500
Received: from web38501.mail.mud.yahoo.com ([209.191.125.47]:42577 "HELO
	web38501.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161413AbXBGR7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 12:59:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=D4oQ+2i2GQETGaTTMBngXPH5TlapoQmH4IT7DKPqxPauDcL9ULGsJN+a7jJW/jVmG2XkwXSuRmMs7qrMd0cPFpA9WhM4irR1WKXtyK3W7CMsvt7dxZj+zT01z/LfaABBIc6Rmdx90tRAwETqrCCK9HEdRy3r3cts56iRGmz7cD0=;
X-YMail-OSG: Zrmh.TAVM1kXoTYt52XgtD3MMaM5g4QBEuDH7XmQlgicnQH4f0FHEtvMRrdYQhInaOSW.vQkRSGI2X8daklNr0.357XqGQ9UDz1jxXgtjZwkKPXrh1lj.g--
Date: Wed, 7 Feb 2007 09:59:41 -0800 (PST)
From: Levitsky Maxim <maximlevitsky@yahoo.com>
Subject: Re: [PATCH] [NET] dmfe : number of fixes and features
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <386082.5155.qm@web38501.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxim Levitsky <maximlevitsky@yahoo.com>
Subject: [PATCH] [NET] [002] dmfe : Fix possible oops

Deallocate memory after driver is unregistred to prevent oops
Don't dereference NULL pointer that can be returned by dev_alloc_skb in case of oom

Signed-off-by: Maxim Levitsky <maximlevitsky@yahoo.com>

---

--- linux-2.6.20-mod/drivers/net/tulip/dmfe.c	2007-02-07 18:27:07.000000000 +0200
+++ linux-2.6.20-test/drivers/net/tulip/dmfe.c	2007-02-07 18:27:59.000000000 +0200
@@ -497,13 +497,16 @@ static void __devexit dmfe_remove_one (s
 	DMFE_DBUG(0, "dmfe_remove_one()", 0);
 
  	if (dev) {
+		
+		unregister_netdev(dev);
+		pci_release_regions(pdev);
+		
+		
 		pci_free_consistent(db->pdev, sizeof(struct tx_desc) *
 					DESC_ALL_CNT + 0x20, db->desc_pool_ptr,
  					db->desc_pool_dma_ptr);
 		pci_free_consistent(db->pdev, TX_BUF_ALLOC * TX_DESC_CNT + 4,
 					db->buf_pool_ptr, db->buf_pool_dma_ptr);
-		unregister_netdev(dev);
-		pci_release_regions(pdev);
 		free_netdev(dev);	/* free board information */
 		pci_set_drvdata(pdev, NULL);
 	}
@@ -921,7 +924,7 @@ static inline u32 cal_CRC(unsigned char 
 static void dmfe_rx_packet(struct DEVICE *dev, struct dmfe_board_info * db)
 {
 	struct rx_desc *rxptr;
-	struct sk_buff *skb;
+	struct sk_buff *skb, *newskb;
 	int rxlen;
 	u32 rdes0;
 
@@ -974,8 +977,10 @@ static void dmfe_rx_packet(struct DEVICE
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



 
____________________________________________________________________________________
Expecting? Get great news right away with email Auto-Check. 
Try the Yahoo! Mail Beta.
http://advision.webevents.yahoo.com/mailbeta/newmail_tools.html 
