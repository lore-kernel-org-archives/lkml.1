Return-Path: <linux-kernel-owner+w=401wt.eu-S1161411AbXBGSAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161411AbXBGSAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 13:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161412AbXBGSAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 13:00:51 -0500
Received: from web38512.mail.mud.yahoo.com ([209.191.125.58]:35789 "HELO
	web38512.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161411AbXBGSAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 13:00:48 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=6sT5gldYwx+fRNijw6Rg9tEfFZj/t3tIO3PiBH+btoC2uchCA9aXxbYgjv7oJLgZBN24ZAOOqQL8yLlfj70V7hM9Q36upq1ozlsGivJDLBbSKF7tyPw9O+KM4LRG7ZgFJzJjPPnRK0u98qfRmNh+M30xDVxignbl2pZlEgxKWz8=;
X-YMail-OSG: qFtak2IVM1l.cinHvYEBJlqzdi1iRphhVbmewm0irZ.ZSnQuDLV1wWOcE9n1YMXCMT8Qr2VFq6CcX5kIwUbOxd6vefGXi0Xp39CPYybNlhLNZgX3A0yB1O0uGKvTgtnAN.OQdd48CoXZxM4-
Date: Wed, 7 Feb 2007 10:00:47 -0800 (PST)
From: Levitsky Maxim <maximlevitsky@yahoo.com>
Subject: Re: [PATCH] [NET] dmfe : number of fixes and features
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <108416.33868.qm@web38512.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxim Levitsky <maximlevitsky@yahoo.com>
Subject: [PATCH] [NET] [004] dmfe : Add suspend/resume support

Adds support for suspend/resume

---


--- linux-2.6.20-mod/drivers/net/tulip/dmfe.c	2007-02-07 18:46:13.000000000 +0200
+++ linux-2.6.20-test/drivers/net/tulip/dmfe.c	2007-02-07 18:50:52.000000000 +0200
@@ -55,9 +55,6 @@
 
     TODO
 
-    Implement pci_driver::suspend() and pci_driver::resume()
-    power management methods.
-
     Check on 64 bit boxes.
     Check and fix on big endian boxes.
 
@@ -2027,11 +2024,59 @@ static struct pci_device_id dmfe_pci_tbl
 MODULE_DEVICE_TABLE(pci, dmfe_pci_tbl);
 
 
+
+static int dmfe_suspend(struct pci_dev *pci_dev, pm_message_t state)
+{
+    u32 tmp;
+
+    struct net_device *dev = pci_get_drvdata(pci_dev);
+    struct dmfe_board_info *db = netdev_priv(dev);
+    
+    /* Disable upper layer interface */
+    netif_device_detach(dev);
+    
+    /* Disable Tx/Rx */
+    db->cr6_data &= ~(CR6_RXSC | CR6_TXSC);	
+    update_cr6(db->cr6_data, dev->base_addr);
+    
+    /* Disable Interrupt */
+    outl(0, dev->base_addr + DCR7);		
+    outl(inl(dev->base_addr + DCR5), dev->base_addr + DCR5);
+    
+    /* Fre RX buffers */
+    dmfe_free_rxbuffer(db);
+
+    /* Power down device*/
+    pci_set_power_state(pci_dev ,  pci_choose_state(pci_dev,state));
+    pci_save_state(pci_dev);
+
+    return 0;
+}
+
+static int dmfe_resume(struct pci_dev *pci_dev)
+{
+    struct net_device *dev = pci_get_drvdata(pci_dev);
+    u32 tmp;
+
+    pci_restore_state(pci_dev);
+    pci_set_power_state(pci_dev ,PCI_D0);
+    
+    /* Re-initilize DM910X board */
+    dmfe_init_dm910x(dev);
+        
+    /* Restart upper layer interface */
+    netif_device_attach(dev);
+
+    return 0;
+}
+
 static struct pci_driver dmfe_driver = {
 	.name		= "dmfe",
 	.id_table	= dmfe_pci_tbl,
 	.probe		= dmfe_init_one,
 	.remove		= __devexit_p(dmfe_remove_one),
+        .suspend        = dmfe_suspend,
+        .resume         = dmfe_resume
 };
 
 MODULE_AUTHOR("Sten Wang, sten_wang@davicom.com.tw");



 
____________________________________________________________________________________
Need a quick answer? Get one in minutes from people who know.
Ask your question on www.Answers.yahoo.com
