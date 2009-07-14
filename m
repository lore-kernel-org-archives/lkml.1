Return-Path: <linux-kernel-owner+w=401wt.eu-S1754943AbZGNOej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbZGNOej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 10:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbZGNOei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 10:34:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35596 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752804AbZGNOeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 10:34:37 -0400
Date: Tue, 14 Jul 2009 15:35:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tiago Vignatti <tiago.vignatti@nokia.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@redhat.com>,
       <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       Tiago Vignatti <tiago.vignatti@nokia.com>
Subject: Re: [PATCH 1/2] vga: implements VGA arbitration on Linux
Message-ID: <20090714153509.51bbec27@lxorguk.ukuu.org.uk>
In-Reply-To: <1247576250-16274-2-git-send-email-tiago.vignatti@nokia.com>
References: <1247576250-16274-1-git-send-email-tiago.vignatti@nokia.com>
	<1247576250-16274-2-git-send-email-tiago.vignatti@nokia.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#ifndef __ARCH_HAS_VGA_ENABLE_RESOURCES
> +static inline void vga_enable_resources(struct pci_dev *pdev,
> +					unsigned int rsrc)
> +{
> +	struct pci_bus *bus;
> +	struct pci_dev *bridge;
> +	u16 cmd;
> +
> +#ifdef DEBUG
> +	printk(KERN_DEBUG "%s\n", __func__);
> +#endif
> +	pci_read_config_word(pdev, PCI_COMMAND, &cmd);
> +	if (rsrc & (VGA_RSRC_LEGACY_IO | VGA_RSRC_NORMAL_IO))
> +		cmd |= PCI_COMMAND_IO;
> +	if (rsrc & (VGA_RSRC_LEGACY_MEM | VGA_RSRC_NORMAL_MEM))
> +		cmd |= PCI_COMMAND_MEMORY;
> +	pci_write_config_word(pdev, PCI_COMMAND, cmd);

Locking question - what locks this lot against hotplug also touching
bridge settings ?

> +
> +	if (!(rsrc & VGA_RSRC_LEGACY_MASK))
> +		return;
> +
> +	bus = pdev->bus;
> +	while (bus) {
> +		bridge = bus->self;
> +		if (bridge) {
> +			pci_read_config_word(bridge, PCI_BRIDGE_CONTROL,
> +					     &cmd);
> +			if (!(cmd & PCI_BRIDGE_CTL_VGA)) {
> +				cmd |= PCI_BRIDGE_CTL_VGA;
> +				pci_write_config_word(bridge,
> +						      PCI_BRIDGE_CONTROL,
> +						      cmd);
> +			}
> +		}
> +		bus = bus->parent;
> +	}
> +}
> +#endif


> +	/* The one who calls us should check for this, but lets be sure... */
> +	if (pdev == NULL)
> +		pdev = vga_default_device();

What if the BIOS provided device was hot unplugged ?

> +		conflict = __vga_tryget(vgadev, rsrc);
> +		spin_unlock_irqrestore(&vga_lock, flags);
> +		if (conflict == NULL)
> +			break;
> +
> +
> +		/* We have a conflict, we wait until somebody kicks the
> +		 * work queue. Currently we have one work queue that we

If two drivers own half the resources and both are waiting for the rest
what handles the deadlock

> +		 * kick each time some resources are released, but it would
> +		 * be fairly easy to have a per device one so that we only
> +		 * need to attach to the conflicting device
> +		 */
> +		init_waitqueue_entry(&wait, current);
> +		add_wait_queue(&vga_wait_queue, &wait);
> +		set_current_state(interruptible ?
> +				  TASK_INTERRUPTIBLE :
> +				  TASK_UNINTERRUPTIBLE);
> +		if (signal_pending(current)) {
> +			rc = -EINTR;
> +			break;
> +		}
> +		schedule();
> +		remove_wait_queue(&vga_wait_queue, &wait);
> +		set_current_state(TASK_RUNNING);

Seems a very long winded way to write

	wait_event_interruptible(...)


> +	/* Allocate structure */
> +	vgadev = kmalloc(sizeof(struct vga_device), GFP_KERNEL);
> +	if (vgadev == NULL) {
> +		/* What to do on allocation failure ? For now, let's
> +		 * just do nothing, I'm not sure there is anything saner
> +		 * to be done
> +		 */

If this is an "oh dear" moment then at least printk something

>
> +	/* Set the client' lists of locks */
> +	priv->target = vga_default_device(); /* Maybe this is still null! */

PCI device refcounting ?

