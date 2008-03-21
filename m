Return-Path: <linux-kernel-owner+w=401wt.eu-S1756256AbYCUUCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbYCUUCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 16:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbYCUUB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 16:01:56 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:14933 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760098AbYCUUBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 16:01:55 -0400
Date: Fri, 21 Mar 2008 14:01:54 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Greg KH <gregkh@suse.de>, Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 8/16][BUG] PCI slot: Fix invalid memory access (Not for
	mainline!)
Message-ID: <20080321200154.GN17292@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Greg KH <gregkh@suse.de>, Gary Hade <garyhade@us.ibm.com>,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
	rick.jones2@hp.com, linux-kernel@vger.kernel.org,
	linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
References: <20080318210539.GA30421@ldl.fc.hp.com> <47E33472.1000602@jp.fujitsu.com> <47E33671.1000107@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E33671.1000107@jp.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Fix kernel oops in pci_release_slot() when dbg() is enabled.

Merged, thanks.

/ac

> 
> The dbg() in pci_release_slot() cause a kernel oops (invalid memory
> access) because it accesses slot after it is released. We need to
> access slot before calling kobject_put().
> 
> Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> 
> ---
>  drivers/pci/slot.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6.25-rc6/drivers/pci/slot.c
> ===================================================================
> --- linux-2.6.25-rc6.orig/drivers/pci/slot.c
> +++ linux-2.6.25-rc6/drivers/pci/slot.c
> @@ -191,13 +191,14 @@ EXPORT_SYMBOL_GPL(pci_create_slot);
>  
>  int pci_destroy_slot(struct pci_slot *slot)
>  {
> +	dbg("%s: decreased refcount to %d on %x:%d\n", __func__,
> +	    atomic_read(&slot->kobj.kref.refcount) - 1, slot->bus->number,
> +	    slot->number);
> +
>  	down_write(&pci_bus_sem);
>  	kobject_put(&slot->kobj);
>  	up_write(&pci_bus_sem);
>  
> -	dbg("%s: decreased refcount to %d on %x:%d\n", __func__,
> -	    atomic_read(&slot->kobj.kref.refcount), slot->bus->number,
> -	    slot->number);
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(pci_destroy_slot);
> 
> 
