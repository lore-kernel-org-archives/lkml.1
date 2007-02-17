Return-Path: <linux-kernel-owner+w=401wt.eu-S933066AbXBQWaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933066AbXBQWaq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 17:30:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933069AbXBQWaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 17:30:46 -0500
Received: from nz-out-0506.google.com ([64.233.162.233]:13238 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933066AbXBQWao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 17:30:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=fPSnDhmZTlP1JO8PIvARB/K/K75zGEi+TEDE7LVwOcQjxjYzF6V4RbNKnOhJ3HJ0BQ6KopPz9RQc1Ww/amYYo/o66Q4JItYqsbTfmsIPr+P9Y/Kvz2ensE8kMztgpiebZWc4erbekeplosRAC/dUaaD39Yld6bmxhY00qJXOEbk=
From: Maxim <maximlevitsky@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Subject:  [PATCH 2.6.20 004/005] dmfe: Add support for suspend/resume
Date: Sun, 18 Feb 2007 00:29:03 +0200
User-Agent: KMail/1.9.6
Cc: netdev@kernel.org, linux-kernel@vger.kernel.org
References: <200702152253.53680.maximlevitsky@gmail.com> <200702152311.54407.maximlevitsky@gmail.com> <20070217115029.GF9120@elf.ucw.cz>
In-Reply-To: <20070217115029.GF9120@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702180029.03651.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 February 2007 13:50:29 Pavel Machek wrote:
> Hi!
> 
> > @@ -2050,11 +2047,56 @@ static struct pci_device_id dmfe_pci_tbl
> >  MODULE_DEVICE_TABLE(pci, dmfe_pci_tbl);
> >  
> >  
> > +
> > +static int dmfe_suspend(struct pci_dev *pci_dev, pm_message_t state)
> > +{
> > +	struct net_device *dev = pci_get_drvdata(pci_dev);
> > +	struct dmfe_board_info *db = netdev_priv(dev);
> > +
> > +	/* Disable upper layer interface */
> > +	netif_device_detach (dev);
> > +
> > +	/* Disable Tx/Rx */
> > +	db->cr6_data &= ~(CR6_RXSC | CR6_TXSC);
> > +	update_cr6(db->cr6_data, dev->base_addr);
> > +
> > +	/* Disable Interrupt */
> > +	outl (0, dev->base_addr + DCR7);
> > +	outl (inl (dev->base_addr + DCR5), dev->base_addr + DCR5);
> 
> Please no space between function and "(".

I missed that part of coding style about no space after function name
> 
> > +	/* Fre RX buffers */
> 
> Free?

Of course  :-)
> 
> > +	dmfe_free_rxbuffer (db);
> 
> > +	/* Power down device*/
> 
> " */"
> 
> > +	pci_set_power_state (pci_dev, pci_choose_state (pci_dev,state));
> 
> Let it be ", state", and delete spaces between function and "(".

Sure
> 
> 
> > +static int dmfe_resume (struct pci_dev *pci_dev)
> 
> delete spaces between function and "(".
> 
> > +	pci_restore_state(pci_dev);
> > +	pci_set_power_state(pci_dev ,PCI_D0);
> > +
> 
> ", "
> 
> Otherwise looks ok to me.
> 

Hello ,  I am sorry that I missed some parts of coding style. I need to reread it :-)

There is a updated patch :

--- linux-2.6.20-mod/drivers/net/tulip/dmfe.c	2007-02-15 18:24:47.000000000 +0200
+++ linux-2.6.20-test/drivers/net/tulip/dmfe.c	2007-02-15 18:26:34.000000000 +0200
@@ -55,9 +55,6 @@
 
     TODO
 
-    Implement pci_driver::suspend() and pci_driver::resume()
-    power management methods.
-
     Check on 64 bit boxes.
     Check and fix on big endian boxes.
 
@@ -2050,11 +2047,56 @@ static struct pci_device_id dmfe_pci_tbl
 MODULE_DEVICE_TABLE(pci, dmfe_pci_tbl);
 
 
+
+static int dmfe_suspend(struct pci_dev *pci_dev, pm_message_t state)
+{
+	struct net_device *dev = pci_get_drvdata(pci_dev);
+	struct dmfe_board_info *db = netdev_priv(dev);
+
+	/* Disable upper layer interface */
+	netif_device_detach(dev);
+
+	/* Disable Tx/Rx */
+	db->cr6_data &= ~(CR6_RXSC | CR6_TXSC);
+	update_cr6(db->cr6_data, dev->base_addr);
+
+	/* Disable Interrupt */
+	outl (0, dev->base_addr + DCR7);
+	outl (inl(dev->base_addr + DCR5), dev->base_addr + DCR5);
+
+	/* Free RX buffers */
+	dmfe_free_rxbuffer(db);
+
+	/* Power down device*/
+	pci_set_power_state(pci_dev, pci_choose_state(pci_dev, state));
+	pci_save_state(pci_dev);
+
+	return 0;
+}
+
+static int dmfe_resume(struct pci_dev *pci_dev)
+{
+	struct net_device *dev = pci_get_drvdata(pci_dev);
+
+	pci_restore_state(pci_dev);
+	pci_set_power_state(pci_dev, PCI_D0);
+
+	/* Re-initialize DM910X board */
+	dmfe_init_dm910x(dev);
+
+	/* Restart upper layer interface */
+	netif_device_attach(dev);
+
+	return 0;
+}
+
 static struct pci_driver dmfe_driver = {
 	.name		= "dmfe",
 	.id_table	= dmfe_pci_tbl,
 	.probe		= dmfe_init_one,
 	.remove		= __devexit_p(dmfe_remove_one),
+	.suspend        = dmfe_suspend,
+	.resume         = dmfe_resume
 };
 
 MODULE_AUTHOR("Sten Wang, sten_wang@davicom.com.tw");
