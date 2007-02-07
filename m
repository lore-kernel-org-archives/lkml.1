Return-Path: <linux-kernel-owner+w=401wt.eu-S1422691AbXBGSaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422691AbXBGSaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 13:30:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422695AbXBGSaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 13:30:21 -0500
Received: from web38504.mail.mud.yahoo.com ([209.191.125.50]:44463 "HELO
	web38504.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1422693AbXBGSaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 13:30:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=31/WVLwlrylFe0cyjOZSM8Krm47gTJhqyDKa6UFoNrppBZG3xvD3Q65bCo3dhXsLAJl9xEs0L3JAYyevIbG6lBajNI/aY3oXzHF6obb92VjoMu+62oJQt7coHzSz+6dsm3ClKMkc554/Xc0501UCl26Kdw0WJm5IZZ9zSIcPWuw=;
X-YMail-OSG: XUTa1x0VM1ldqQE_j_KWIpptBihI7KIro3c02ttS
Date: Wed, 7 Feb 2007 10:30:17 -0800 (PST)
From: Levitsky Maxim <maximlevitsky@yahoo.com>
Subject: [PATCH] [NETDEV] [002] dmfe : Fix possible oops
To: linux-kernel@vger.kernel.org
Cc: tori@unhappy.mine.nu, netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <38301.22381.qm@web38504.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxim Levitsky <maximlevitsky@yahoo.com>
Subject: [PATCH] [NET] [002] dmfe : Fix possible oops

Deallocate memory after driver is unregistred to prevent oops
Don't dereference NULL pointer that can be returned by dev_alloc_skb in case of oom

Signed-off-by: Maxim Levitsky <maximlevitsky@yahoo.com>

---

--- linux-2.6.20-mod/drivers/net/tulip/dmfe.c   2007-02-07 18:27:07.000000000 +0200
+++ linux-2.6.20-test/drivers/net/tulip/dmfe.c  2007-02-07 18:27:59.000000000 +0200
@@ -497,13 +497,16 @@ static void __devexit dmfe_remove_one (s
        DMFE_DBUG(0, "dmfe_remove_one()", 0);
 
        if (dev) {
+               
+               unregister_netdev(dev);
+               pci_release_regions(pdev);
+               
+               
                pci_free_consistent(db->pdev, sizeof(struct tx_desc) *
                                        DESC_ALL_CNT + 0x20, db->desc_pool_ptr,
                                        db->desc_pool_dma_ptr);
                pci_free_consistent(db->pdev, TX_BUF_ALLOC * TX_DESC_CNT + 4,
                                        db->buf_pool_ptr, db->buf_pool_dma_ptr);
-               unregister_netdev(dev);
-               pci_release_regions(pdev);
                free_netdev(dev);       /* free board information */
                pci_set_drvdata(pdev, NULL);
        }
@@ -921,7 +924,7 @@ static inline u32 cal_CRC(unsigned char 
 static void dmfe_rx_packet(struct DEVICE *dev, struct dmfe_board_info * db)
 {
        struct rx_desc *rxptr;
-       struct sk_buff *skb;
+       struct sk_buff *skb, *newskb;
        int rxlen;
        u32 rdes0;
 
@@ -974,8 +977,10 @@ static void dmfe_rx_packet(struct DEVICE
                                        /* Good packet, send to upper layer */
                                        /* Shorst packet used new SKB */
                                        if ( (rxlen < RX_COPY_SIZE) &&
-                                               ( (skb = dev_alloc_skb(rxlen + 2) )
+                                               ( (newskb = dev_alloc_skb(rxlen + 2) )
                                                != NULL) ) {
+                                               
+                                               skb = newskb;
                                                /* size less than COPY_SIZE, allocate a rxlen SKB
*/
                                                skb->dev = dev;
                                                skb_reserve(skb, 2); /* 16byte align */



 
____________________________________________________________________________________
8:00? 8:25? 8:40? Find a flick in no time 
with the Yahoo! Search movie showtime shortcut.
http://tools.search.yahoo.com/shortcuts/#news
