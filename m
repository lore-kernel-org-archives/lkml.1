Return-Path: <linux-kernel-owner+w=401wt.eu-S1030927AbXDPT4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030927AbXDPT4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 15:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030930AbXDPT4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 15:56:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:29150 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030927AbXDPT4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 15:56:50 -0400
Date: Mon, 16 Apr 2007 22:56:49 +0300
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, Jens Axboe <jens.axboe@oracle.com>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: SATA resume slowness, e1000 MSI warning
Message-ID: <20070416195649.GA4507@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <20070308102354.GC5149@mellanox.co.il>
	<m1wt1oyqyo.fsf@ebiederm.dsl.xmission.com>
	<20070311112400.GB24475@mellanox.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070311112400.GB24475@mellanox.co.il>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Hmm. pci_save_pcix_state/pci_restore_pcix_state seem to only handle
> > > regular devices and seem to ignore the fact that for bridge PCI-X
> > > capability has a different structure.
> > >
> > > Is this intentional? 
> > 
> > Probably not a such.  I don't think we have any drivers for bridge
> > devices so I don't think it matters.  It likely wouldn't hurt to fix
> > it just in case though.
> > 
> > Do any of the mellanox cards do anything with the bridge on the card?
> 
> Yes but they do their own thing wrt saving/restoring registers.
> Look at drivers/infiniband/hw/mthca/mthca_reset.c
> 
> > > If not, here's a patch to fix this. Warning: completely untested.
> > 
> > If you fix the offsets and diff this against my last fix (to never
> > free the buffer) I think your patch makes sense.
> 
> Let's agree what the correct offsets are.
> 
> > > PCI: restore bridge PCI-X capability registers after PM event
> > >
> > > Restore PCI-X bridge up/downstream capability registers
> > > after PM event.  This includes maxumum split transaction
> > > commitment limit which might be vital for PCI X.
> > >
> > > Signed-off-by: Michael S. Tsirkin <mst@mellanox.co.il>
> > >
> > > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> > > index df49530..4b788ef 100644
> > > --- a/drivers/pci/pci.c
> > > +++ b/drivers/pci/pci.c
> > > @@ -597,14 +597,19 @@ static int pci_save_pcix_state(struct pci_dev *dev)
> > >  	if (pos <= 0)
> > >  		return 0;
> > >  
> > > -	save_state = kzalloc(sizeof(*save_state) + sizeof(u16), GFP_KERNEL);
> > > + save_state = kzalloc(sizeof(*save_state) + sizeof(u16) * 2, GFP_KERNEL);
> > >  	if (!save_state) {
> > > -		dev_err(&dev->dev, "Out of memory in pci_save_pcie_state\n");
> > > +		dev_err(&dev->dev, "Out of memory in pci_save_pcix_state\n");
> > >  		return -ENOMEM;
> > >  	}
> > >  	cap = (u16 *)&save_state->data[0];
> > >  
> > > -	pci_read_config_word(dev, pos + PCI_X_CMD, &cap[i++]);
> > > +	if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE) {
> > 
> > This appears to be the proper test.
> > 
> > > + pci_read_config_word(dev, pos + PCI_X_BRIDGE_UP_SPL_CTL, &cap[i++]);
> > > + pci_read_config_word(dev, pos + PCI_X_BRIDGE_DN_SPL_CTL, &cap[i++]);
> > > +	} else
> > > +		pci_read_config_word(dev, pos + PCI_X_CMD, &cap[i++]);
> > > +
> > >  	pci_add_saved_cap(dev, save_state);
> > >  	return 0;
> > >  }
> > > @@ -621,7 +626,11 @@ static void pci_restore_pcix_state(struct pci_dev *dev)
> > >  		return;
> > >  	cap = (u16 *)&save_state->data[0];
> > >  
> > > -	pci_write_config_word(dev, pos + PCI_X_CMD, cap[i++]);
> > > +	if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE) {
> > > + pci_write_config_word(dev, pos + PCI_X_BRIDGE_UP_SPL_CTL, cap[i++]);
> > > + pci_write_config_word(dev, pos + PCI_X_BRIDGE_DN_SPL_CTL, cap[i++]);
> > 
> > These look like the proper two registers to save.
> > 
> > > +	} else
> > > +		pci_write_config_word(dev, pos + PCI_X_CMD, cap[i++]);
> > >  	pci_remove_saved_cap(save_state);
> > >  	kfree(save_state);
> > >  }
> > > diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
> > > index f09cce2..fb7eefd 100644
> > > --- a/include/linux/pci_regs.h
> > > +++ b/include/linux/pci_regs.h
> > > @@ -332,6 +332,8 @@
> > >  #define PCI_X_STATUS_SPL_ERR 0x20000000 /* Rcvd Split Completion Error Msg */
> > >  #define  PCI_X_STATUS_266MHZ	0x40000000	/* 266 MHz capable */
> > >  #define  PCI_X_STATUS_533MHZ	0x80000000	/* 533 MHz capable */
> > > +#define PCI_X_BRIDGE_UP_SPL_CTL 10 /* PCI-X upstream split transaction limit */
> > > +#define PCI_X_BRIDGE_DN_SPL_CTL 14 /* PCI-X downstream split transaction limit */
> > 
> > Unless I am completely misreading the spec. While you have picked the
> > right register to save the offsets should be 0x08 and 0x0c or 8 and 12....
> 
> No, the spec is written in terms of dwords (32 bit), we are storing words (16 bits).
> The data at offsets 8 and 12 is read-only split transaction capacity.
> Split transaction limit starts at bit 16 so you need to add 2 to byte offset.

So, Eric, what are your thoughts on this patch (probably wrt 2.6.22)?
Since the rest of the save/restore code uses 16 bit transactions,
it should be safe here too?

-- 
MST
