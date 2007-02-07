Return-Path: <linux-kernel-owner+w=401wt.eu-S1030650AbXBGSd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030650AbXBGSd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 13:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030649AbXBGSd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 13:33:57 -0500
Received: from web38506.mail.mud.yahoo.com ([209.191.125.52]:20295 "HELO
	web38506.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030650AbXBGSd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 13:33:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=n58t2/8n9It/o8uUaZu1hHIFnn3taVaCUmO9xJ6iVAQVtZ6X4AMZuYAPXtnrbGdZRYhw3ce4W8OqvUxSSjcWULfHd9R3ZqBl1vFhYTHHxbv1/OkE0CsQh/0gqbBLzVyYr9BGoOZtyX2p5FbWiFXM2VCTO0krdZkHrx182R/Advw=;
X-YMail-OSG: LZw6RjQVM1k2nCoFQEHezpaMHBkoyY_ox8p.8MPEdbM6NvdS3S4TdXt9c0Izaxs_yGSUvkozfWuTKQEJN7vc04r24aoJ0NCpQ_dzbi8B6iBHXFbJmNZ_c5VY3B4AtnEIXalcclkrEPSyq3c-
Date: Wed, 7 Feb 2007 10:33:55 -0800 (PST)
From: Levitsky Maxim <maximlevitsky@yahoo.com>
Subject: [PATCH] [NETDEV] [004] dmfe : Add suspend/resume support
To: linux-kernel@vger.kernel.org
Cc: tori@unhappy.mine.nu, netdev@vger.kernel.org, pavel@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <549393.8054.qm@web38506.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxim Levitsky <maximlevitsky@yahoo.com>
Subject: [PATCH] [NETDEV] [004] dmfe : Add suspend/resume support

Adds support for suspend/resume

---


--- linux-2.6.20-mod/drivers/net/tulip/dmfe.c   2007-02-07 18:46:13.000000000 +0200
+++ linux-2.6.20-test/drivers/net/tulip/dmfe.c  2007-02-07 18:50:52.000000000 +0200
@@ -55,9 +55,6 @@
 
     TODO
 
-    Implement pci_driver::suspend() and pci_driver::resume()
-    power management methods.
-
     Check on 64 bit boxes.
     Check and fix on big endian boxes.
 
@@ -2027,11 +2024,59 @@ static struct pci_device_id dmfe_pci_tbl
 MODULE_DEVICE_TABLE(pci, dmfe_pci_tbl);
 
 
+
+static int dmfe_suspend(struct pci_dev *pci_dev, pm_message_t state)
+{
+    u32 tmp;
+
+    struct net_device *dev = pci_get_drvdata(pci_dev);
+    struct dmfe_board_info *db = netdev_priv(dev);
+    
+    /* Disable upper layer interface */
+    netif_device_detach(dev);
+    
+    /* Disable Tx/Rx */
+    db->cr6_data &= ~(CR6_RXSC | CR6_TXSC);    
+    update_cr6(db->cr6_data, dev->base_addr);
+    
+    /* Disable Interrupt */
+    outl(0, dev->base_addr + DCR7);            
+    outl(inl(dev->base_addr + DCR5), dev->base_addr + DCR5);
+    
+    /* Fre RX buffers */
+    dmfe_free_rxbuffer(db);
+
+    /* Power down device*/
+    pci_set_power_state(pci_dev ,  pci_choose_state(pci_dev,state));
+    pci_save_state(pci_dev);
+
+    return 0;
+}
+
+static int dmfe_resume(struct pci_dev *pci_dev)
+{
+    struct net_device *dev = pci_get_drvdata(pci_dev);
+    u32 tmp;
+
+    pci_restore_state(pci_dev);
+    pci_set_power_state(pci_dev ,PCI_D0);
+    
+    /* Re-initilize DM910X board */
+    dmfe_init_dm910x(dev);
+        
+    /* Restart upper layer interface */
+    netif_device_attach(dev);
+
+    return 0;
+}
+
 static struct pci_driver dmfe_driver = {
        .name           = "dmfe",
        .id_table       = dmfe_pci_tbl,
        .probe          = dmfe_init_one,
        .remove         = __devexit_p(dmfe_remove_one),
+        .suspend        = dmfe_suspend,
+        .resume         = dmfe_resume
 };
 
 MODULE_AUTHOR("Sten Wang, sten_wang@davicom.com.tw");



 
____________________________________________________________________________________
Do you Yahoo!?
Everyone is raving about the all-new Yahoo! Mail beta.
http://new.mail.yahoo.com
