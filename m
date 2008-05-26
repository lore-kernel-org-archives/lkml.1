Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204AbYEZGfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbYEZGfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 02:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbYEZGfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 02:35:40 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:64407 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbYEZGfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 02:35:39 -0400
To: amit.shah@qumranet.com
Cc: muli@il.ibm.com, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       alexisb@us.ibm.com, andi@firstfloor.org, kvm@vger.kernel.org,
       avi@qumranet.com
Subject: Re: [PATCH v2 -mm 0/2] x86: per-device dma_mapping_ops
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200805260939.21320.amit.shah@qumranet.com>
References: <200805221613.03686.amit.shah@qumranet.com>
	<20080525072011.GM7334@il.ibm.com>
	<200805260939.21320.amit.shah@qumranet.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080526151152Q.fujita.tomonori@lab.ntt.co.jp>
Date: Mon, 26 May 2008 15:11:52 +0900
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2008 09:39:20 +0530
Amit Shah <amit.shah@qumranet.com> wrote:

> On Sunday 25 May 2008 12:50:11 Muli Ben-Yehuda wrote:
> > On Thu, May 22, 2008 at 04:13:02PM +0530, Amit Shah wrote:
> > > OK; this sounds helpful. the hook can make a hypercall and confirm
> > > with the host kernel if the device in question is an assigned
> > > physical device. If yes, we replace the dma_ops. Though, the
> > > original intent of having stackable ops is that we might want to go
> > > through the swiotlb in the guest even for an assigned device if the
> > > guest dma addresses are not in the addressable range of the guest
> > > chipset.
> > >
> > > > created (it works with hot plugging). It enables IOMMUs to set up an
> > > > appropriate dma_mapping_ops per device.
> > >
> > > From what we've discussed so far, it looks like stackable dma ops will
> > > definitely be needed. Does this patchset provide something that stacking
> > > won't?
> >
> > Yes---this patchset let's you have a per-device dma-ops, whereas with
> > stackable you only get global dma-ops. I think it's clear we need
> > both, and I think per-device dma-ops are the first thing that's
> > needed. Stacking can then be introduced on a per-device basis.
> 
> When we would want stacking, we'll want it globally and not per-device, isn't 
> it? Or at least for devices on a particular bus.
> 
> When an IOMMU driver registers itself, it should tell which devices it's 
> interested in (each device behind a bus or by enumerating each device it 
> cares for). This should take care of all the scenarios and we won't have the 
> need for per-device dma_ops.

Well, without per-device dma_ops, IOMMUs could live. But it's pretty
hacky. Every time a dma operation is called, IOMMUs need to figure out
how a device should be handled.

If IOMMUs can set dma_ops for the device when a new device is created,
IOMMUs don't care anything any more. That's much clean. That's What
the POWER architecture does.


> For something like pvdma, we can walk through the list of pci devices and make 
> a hypercall for each of them to get this information and have the pvdma 
> version of dma_ops registered for that device. This sounds like it's 
> per-device dma_ops, but it's not -- internally, the dma operations walk 
> through each of the IOMMUs registered and call them in sequence.

As Muli poinsted out, For pvdma, you need stacking per-device
dma_ops. With per-device dma_ops, you don't need hack like adding
is_pv_device hook in dma_ops. You can set your dma_ops to only pci
devices that you are interested.
