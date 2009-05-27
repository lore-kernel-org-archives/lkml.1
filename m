Return-Path: <linux-kernel-owner+w=401wt.eu-S1761096AbZE0JFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761096AbZE0JFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 05:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756341AbZE0JFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 05:05:45 -0400
Received: from outbound-mail-02.bluehost.com ([69.89.21.12]:46239 "HELO
	outbound-mail-02.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751728AbZE0JFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 05:05:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=tWA73W8shhrBXsH6+iL7rLGOz7GYfXw1nqquA5zIF1q2otkwNWM4REjfCGQM9LegxKMyo4Qfzu+kVKyrA73CdZf6/LoIGdnKybd0R4qLK14Tlk7zcpT0mloqmJ/McrBC;
Date: Wed, 27 May 2009 02:05:38 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Alex Chiang <achiang@hp.com>, bjorn.helgaas@hp.com,
       linux-pci <linux-pci@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI Hotplug: acpiphp: don't store a pci_dev in
 acpiphp_func
Message-ID: <20090527020538.359d4d24@jbarnes-x200>
In-Reply-To: <4A1B2FEA.1070002@jp.fujitsu.com>
References: <20090521222115.GC8792@ldl.fc.hp.com>
	<4A1B2FEA.1070002@jp.fujitsu.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 80.67.104.102 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009 08:55:22 +0900
Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com> wrote:

> Alex Chiang wrote:
> > An oops can occur if a user attempts to use both PCI logical
> > hotplug and the ACPI physical hotplug driver (acpiphp) in this
> > sequence, where $slot/address == $device.
> > 
> > In other words, if acpiphp has claimed a PCI device, and that
> > device is logically removed, then acpiphp may oops when it
> > attempts to access it again.
> > 
> > 	# echo 1 > /sys/bus/pci/devices/$device/remove
> > 	# echo 0 > /sys/bus/pci/slots/$slot/power
> > 
> > Unable to handle kernel NULL pointer dereference (address
> > 0000000000000000) Call Trace:
> >  [<a000000100016390>] show_stack+0x50/0xa0
> >  [<a000000100016c60>] show_regs+0x820/0x860
> >  [<a00000010003b390>] die+0x190/0x2a0
> >  [<a000000100066a40>] ia64_do_page_fault+0x8e0/0xa40
> >  [<a00000010000c7a0>] ia64_native_leave_kernel+0x0/0x270
> >  [<a0000001003b2660>] pci_remove_bus_device+0x120/0x260
> >  [<a0000002060549f0>] acpiphp_disable_slot+0x410/0x540 [acpiphp]
> >  [<a0000002060505c0>] disable_slot+0xc0/0x120 [acpiphp]
> >  [<a0000002040d21c0>] power_write_file+0x1e0/0x2a0 [pci_hotplug]
> >  [<a0000001003bb820>] pci_slot_attr_store+0x60/0xa0
> >  [<a000000100240f70>] sysfs_write_file+0x230/0x2c0
> >  [<a000000100195750>] vfs_write+0x190/0x2e0
> >  [<a0000001001961a0>] sys_write+0x80/0x100
> >  [<a00000010000c600>] ia64_ret_from_syscall+0x0/0x20
> >  [<a000000000010720>] __kernel_syscall_via_break+0x0/0x20
> > 
> > The root cause of this oops is that the logical remove ("echo 1 >
> > /sys/bus/pci/devices/$device/remove") destroyed the pci_dev. The
> > pci_dev struct itself wasn't deallocated because acpiphp kept a
> > reference, but some of its fields became invalid.
> > 
> > acpiphp doesn't have any real reason to keep a pointer to a
> > pci_dev around. It can always derive it using pci_get_slot().
> > 
> > If a logical remove destroys the pci_dev, acpiphp won't find it
> > and is thus prevented from causing mischief.
> > 
> > Reported-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> > Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> > Signed-off-by: Alex Chiang <achiang@hp.com>
> > ---
> >  acpiphp.h      |    1 
> >  acpiphp_glue.c |   63
> >  +++++++++++++++++++++++----------------------------------
> >  2 files changed, 26 insertions(+), 38 deletions(-)
> > ---
> > diff --git a/drivers/pci/hotplug/acpiphp.h
> > b/drivers/pci/hotplug/acpiphp.h index 4fc168b..e68d5f2 100644
> > --- a/drivers/pci/hotplug/acpiphp.h
> > +++ b/drivers/pci/hotplug/acpiphp.h
> > @@ -129,7 +129,6 @@ struct acpiphp_func {
> >  	struct acpiphp_bridge *bridge;	/* Ejectable
> > PCI-to-PCI bridge */ 
> >  	struct list_head sibling;
> > -	struct pci_dev *pci_dev;
> >  	struct notifier_block nb;
> >  	acpi_handle	handle;
> >  
> > diff --git a/drivers/pci/hotplug/acpiphp_glue.c
> > b/drivers/pci/hotplug/acpiphp_glue.c index a33794d..3a6064b 100644
> > --- a/drivers/pci/hotplug/acpiphp_glue.c
> > +++ b/drivers/pci/hotplug/acpiphp_glue.c
> > @@ -32,9 +32,6 @@
> >  
> >  /*
> >   * Lifetime rules for pci_dev:
> > - *  - The one in acpiphp_func has its refcount elevated by
> > pci_get_slot()
> > - *    when the driver is loaded or when an insertion event
> > occurs.  It loses
> > - *    a refcount when its ejected or the driver unloads.
> >   *  - The one in acpiphp_bridge has its refcount elevated by
> > pci_get_slot()
> >   *    when the bridge is scanned and it loses a refcount when the
> > bridge
> >   *    is removed.
> > @@ -130,6 +127,7 @@ register_slot(acpi_handle handle, u32 lvl, void
> > *context, void **rv) unsigned long long adr, sun;
> >  	int device, function, retval;
> >  	struct pci_bus *pbus = bridge->pci_bus;
> > +	struct pci_dev *pdev;
> >  
> >  	if (!acpi_pci_check_ejectable(pbus, handle)
> > && !is_dock_device(handle)) return AE_OK;
> > @@ -213,10 +211,10 @@ register_slot(acpi_handle handle, u32 lvl,
> > void *context, void **rv) newfunc->slot = slot;
> >  	list_add_tail(&newfunc->sibling, &slot->funcs);
> >  
> > -	/* associate corresponding pci_dev */
> > -	newfunc->pci_dev = pci_get_slot(pbus, PCI_DEVFN(device,
> > function));
> > -	if (newfunc->pci_dev) {
> > +	pdev = pci_get_slot(pbus, PCI_DEVFN(device, function));
> > +	if (pdev) {
> >  		slot->flags |= (SLOT_ENABLED | SLOT_POWEREDON);
> > +		pci_dev_put(pdev);
> >  	}
> >  
> >  	if (is_dock_device(handle)) {
> > @@ -617,7 +615,6 @@ static void cleanup_bridge(struct
> > acpiphp_bridge *bridge) if (ACPI_FAILURE(status))
> >  					err("failed to remove
> > notify handler\n"); }
> > -			pci_dev_put(func->pci_dev);
> >  			list_del(list);
> >  			kfree(func);
> >  		}
> > @@ -1101,22 +1098,24 @@ static int __ref enable_device(struct
> > acpiphp_slot *slot) pci_enable_bridges(bus);
> >  	pci_bus_add_devices(bus);
> >  
> > -	/* associate pci_dev to our representation */
> >  	list_for_each (l, &slot->funcs) {
> >  		func = list_entry(l, struct acpiphp_func, sibling);
> > -		func->pci_dev = pci_get_slot(bus,
> > PCI_DEVFN(slot->device,
> > -
> > func->function));
> > -		if (!func->pci_dev)
> > +		dev = pci_get_slot(bus, PCI_DEVFN(slot->device,
> > +						  func->function));
> > +		if (!dev)
> >  			continue;
> >  
> > -		if (func->pci_dev->hdr_type !=
> > PCI_HEADER_TYPE_BRIDGE &&
> > -		    func->pci_dev->hdr_type !=
> > PCI_HEADER_TYPE_CARDBUS)
> > +		if (dev->hdr_type != PCI_HEADER_TYPE_BRIDGE &&
> > +		    dev->hdr_type != PCI_HEADER_TYPE_CARDBUS) {
> > +			pci_dev_put(dev);
> >  			continue;
> > +		}
> >  
> >  		status = find_p2p_bridge(func->handle, (u32)1,
> > bus, NULL); if (ACPI_FAILURE(status))
> >  			warn("find_p2p_bridge failed (error code =
> > 0x%x)\n", status);
> > +		pci_dev_put(dev);
> >  	}
> >  
> >  	slot->flags |= SLOT_ENABLED;
> > @@ -1142,17 +1141,14 @@ static void disable_bridges(struct pci_bus
> > *bus) */
> >  static int disable_device(struct acpiphp_slot *slot)
> >  {
> > -	int retval = 0;
> >  	struct acpiphp_func *func;
> > -	struct list_head *l;
> > +	struct pci_dev *pdev;
> >  
> >  	/* is this slot already disabled? */
> >  	if (!(slot->flags & SLOT_ENABLED))
> >  		goto err_exit;
> >  
> > -	list_for_each (l, &slot->funcs) {
> > -		func = list_entry(l, struct acpiphp_func, sibling);
> > -
> > +	list_for_each_entry(func, &slot->funcs, sibling) {
> >  		if (func->bridge) {
> >  			/* cleanup p2p bridges under this P2P
> > bridge */ cleanup_p2p_bridge(func->bridge->handle,
> > @@ -1160,35 +1156,28 @@ static int disable_device(struct
> > acpiphp_slot *slot) func->bridge = NULL;
> >  		}
> >  
> > -		if (func->pci_dev) {
> > -			pci_stop_bus_device(func->pci_dev);
> > -			if (func->pci_dev->subordinate) {
> > -
> > disable_bridges(func->pci_dev->subordinate);
> > -				pci_disable_device(func->pci_dev);
> > +		pdev = pci_get_slot(slot->bridge->pci_bus,
> > +				    PCI_DEVFN(slot->device,
> > func->function));
> > +		if (pdev) {
> > +			pci_stop_bus_device(pdev);
> > +			if (pdev->subordinate) {
> > +				disable_bridges(pdev->subordinate);
> > +				pci_disable_device(pdev);
> >  			}
> > +			pci_remove_bus_device(pdev);
> > +			pci_dev_put(pdev);
> >  		}
> >  	}
> >  
> > -	list_for_each (l, &slot->funcs) {
> > -		func = list_entry(l, struct acpiphp_func, sibling);
> > -
> > +	list_for_each_entry(func, &slot->funcs, sibling) {
> >  		acpiphp_unconfigure_ioapics(func->handle);
> >  		acpiphp_bus_trim(func->handle);
> > -		/* try to remove anyway.
> > -		 * acpiphp_bus_add might have been failed */
> > -
> > -		if (!func->pci_dev)
> > -			continue;
> > -
> > -		pci_remove_bus_device(func->pci_dev);
> > -		pci_dev_put(func->pci_dev);
> > -		func->pci_dev = NULL;
> >  	}
> >  
> >  	slot->flags &= (~SLOT_ENABLED);
> >  
> > - err_exit:
> > -	return retval;
> > +err_exit:
> > +	return 0;
> >  }
> >  
> 
> The patch looks good to me. I confirmed it fixes the kernel oops
> problem on my test environment.
> 
> Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> Tested-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

Thanks guys, I just pushed this to my for-linus tree.  Assuming Linus
hasn't released yet, I'll send this over to him tomorrow.

Thanks,
Jesse
