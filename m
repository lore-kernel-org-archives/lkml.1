Return-Path: <linux-kernel-owner+w=401wt.eu-S933860AbXCKRjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933860AbXCKRjd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 13:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933864AbXCKRjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 13:39:33 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45732 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933860AbXCKRjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 13:39:31 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Michael S. Tsirkin" <mst@mellanox.co.il>
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
References: <20070308102354.GC5149@mellanox.co.il>
	<m1wt1oyqyo.fsf@ebiederm.dsl.xmission.com>
	<20070311112400.GB24475@mellanox.co.il>
Date: Sun, 11 Mar 2007 11:37:52 -0600
In-Reply-To: <20070311112400.GB24475@mellanox.co.il> (Michael S. Tsirkin's
	message of "Sun, 11 Mar 2007 13:24:00 +0200")
Message-ID: <m1ird7y93j.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@mellanox.co.il> writes:

>> Quoting Eric W. Biederman <ebiederm@xmission.com>:
>> Subject: Re: SATA resume slowness, e1000 MSI warning
>> 
>> "Michael S. Tsirkin" <mst@mellanox.co.il> writes:
>> 
>> >> The only case I can see which might trigger this is if we saved
>> >> pci-X state and then didn't restore it because we could not find
>> >> the capability on restore.
>> >
>> > Hmm. pci_save_pcix_state/pci_restore_pcix_state seem to only handle
>> > regular devices and seem to ignore the fact that for bridge PCI-X
>> > capability has a different structure.
>> >
>> > Is this intentional? 
>> 
>> Probably not a such.  I don't think we have any drivers for bridge
>> devices so I don't think it matters.  It likely wouldn't hurt to fix
>> it just in case though.
>> 
>> Do any of the mellanox cards do anything with the bridge on the card?
>
> Yes but they do their own thing wrt saving/restoring registers.
> Look at drivers/infiniband/hw/mthca/mthca_reset.c
>
>> > If not, here's a patch to fix this. Warning: completely untested.
>> 
>> If you fix the offsets and diff this against my last fix (to never
>> free the buffer) I think your patch makes sense.
>
> Let's agree what the correct offsets are.
>
>> > PCI: restore bridge PCI-X capability registers after PM event
>> >
>> > Restore PCI-X bridge up/downstream capability registers
>> > after PM event.  This includes maxumum split transaction
>> > commitment limit which might be vital for PCI X.
>> >
>> > Signed-off-by: Michael S. Tsirkin <mst@mellanox.co.il>
>> >
>> > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> > index df49530..4b788ef 100644
>> > --- a/drivers/pci/pci.c
>> > +++ b/drivers/pci/pci.c
>> > @@ -597,14 +597,19 @@ static int pci_save_pcix_state(struct pci_dev *dev)
>> >  	if (pos <= 0)
>> >  		return 0;
>> >  
>> > -	save_state = kzalloc(sizeof(*save_state) + sizeof(u16), GFP_KERNEL);
>> > + save_state = kzalloc(sizeof(*save_state) + sizeof(u16) * 2, GFP_KERNEL);
>> >  	if (!save_state) {
>> > -		dev_err(&dev->dev, "Out of memory in pci_save_pcie_state\n");
>> > +		dev_err(&dev->dev, "Out of memory in pci_save_pcix_state\n");
>> >  		return -ENOMEM;
>> >  	}
>> >  	cap = (u16 *)&save_state->data[0];
>> >  
>> > -	pci_read_config_word(dev, pos + PCI_X_CMD, &cap[i++]);
>> > +	if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE) {
>> 
>> This appears to be the proper test.
>> 
>> > + pci_read_config_word(dev, pos + PCI_X_BRIDGE_UP_SPL_CTL, &cap[i++]);
>> > + pci_read_config_word(dev, pos + PCI_X_BRIDGE_DN_SPL_CTL, &cap[i++]);
>> > +	} else
>> > +		pci_read_config_word(dev, pos + PCI_X_CMD, &cap[i++]);
>> > +
>> >  	pci_add_saved_cap(dev, save_state);
>> >  	return 0;
>> >  }
>> > @@ -621,7 +626,11 @@ static void pci_restore_pcix_state(struct pci_dev *dev)
>> >  		return;
>> >  	cap = (u16 *)&save_state->data[0];
>> >  
>> > -	pci_write_config_word(dev, pos + PCI_X_CMD, cap[i++]);
>> > +	if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE) {
>> > + pci_write_config_word(dev, pos + PCI_X_BRIDGE_UP_SPL_CTL, cap[i++]);
>> > + pci_write_config_word(dev, pos + PCI_X_BRIDGE_DN_SPL_CTL, cap[i++]);
>> 
>> These look like the proper two registers to save.
>> 
>> > +	} else
>> > +		pci_write_config_word(dev, pos + PCI_X_CMD, cap[i++]);
>> >  	pci_remove_saved_cap(save_state);
>> >  	kfree(save_state);
>> >  }
>> > diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
>> > index f09cce2..fb7eefd 100644
>> > --- a/include/linux/pci_regs.h
>> > +++ b/include/linux/pci_regs.h
>> > @@ -332,6 +332,8 @@
>> > #define PCI_X_STATUS_SPL_ERR 0x20000000 /* Rcvd Split Completion Error Msg
> */
>> >  #define  PCI_X_STATUS_266MHZ	0x40000000	/* 266 MHz capable */
>> >  #define  PCI_X_STATUS_533MHZ	0x80000000	/* 533 MHz capable */
>> > +#define PCI_X_BRIDGE_UP_SPL_CTL 10 /* PCI-X upstream split transaction
> limit */
>> > +#define PCI_X_BRIDGE_DN_SPL_CTL 14 /* PCI-X downstream split transaction
> limit */
>> 
>> Unless I am completely misreading the spec. While you have picked the
>> right register to save the offsets should be 0x08 and 0x0c or 8 and 12....
>
> No, the spec is written in terms of dwords (32 bit), we are storing words (16
> bits).
> The data at offsets 8 and 12 is read-only split transaction capacity.
> Split transaction limit starts at bit 16 so you need to add 2 to byte offset.
>
> Right?

>From that perspective it makes sense.  So I will agree with the way you are
thinking the code works.

The read-only and the read-write part are all defined as part of the
same register so I didn't expect them to be separate.  And I hadn't
paid attention enough to see that the code was only saving 16bit
values.

Rumor has it that some pci devices can't tolerate < 32bit accesses.
Although I have never met one.  The two factors together suggest that
for generic code it probably makes sense to operate on 32bit
quantities, and just to ignore the read-only portion.

Eric
