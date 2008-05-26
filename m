Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbYE0AHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbYE0AHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 20:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755628AbYE0AHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 20:07:40 -0400
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:57686 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598AbYE0AHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 20:07:39 -0400
To: amit.shah@qumranet.com
Cc: fujita.tomonori@lab.ntt.co.jp, muli@il.ibm.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       alexisb@us.ibm.com, andi@firstfloor.org, kvm@vger.kernel.org,
       avi@qumranet.com
Subject: Re: [PATCH v2 -mm 0/2] x86: per-device dma_mapping_ops
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200805262214.35397.amit.shah@qumranet.com>
References: <200805260939.21320.amit.shah@qumranet.com>
	<20080526151152Q.fujita.tomonori@lab.ntt.co.jp>
	<200805262214.35397.amit.shah@qumranet.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080527085054E.fujita.tomonori@lab.ntt.co.jp>
Date: Tue, 27 May 2008 08:50:54 +0900
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2008 22:14:34 +0530
Amit Shah <amit.shah@qumranet.com> wrote:

> On Monday 26 May 2008 11:41:52 FUJITA Tomonori wrote:
> > On Mon, 26 May 2008 09:39:20 +0530
> >
> > Amit Shah <amit.shah@qumranet.com> wrote:
> > > On Sunday 25 May 2008 12:50:11 Muli Ben-Yehuda wrote:
> > > > On Thu, May 22, 2008 at 04:13:02PM +0530, Amit Shah wrote:
> > > > > OK; this sounds helpful. the hook can make a hypercall and confirm
> > > > > with the host kernel if the device in question is an assigned
> > > > > physical device. If yes, we replace the dma_ops. Though, the
> > > > > original intent of having stackable ops is that we might want to go
> > > > > through the swiotlb in the guest even for an assigned device if the
> > > > > guest dma addresses are not in the addressable range of the guest
> > > > > chipset.
> > > > >
> > > > > > created (it works with hot plugging). It enables IOMMUs to set up
> > > > > > an appropriate dma_mapping_ops per device.
> > > > >
> > > > > From what we've discussed so far, it looks like stackable dma ops
> > > > > will definitely be needed. Does this patchset provide something that
> > > > > stacking won't?
> > > >
> > > > Yes---this patchset let's you have a per-device dma-ops, whereas with
> > > > stackable you only get global dma-ops. I think it's clear we need
> > > > both, and I think per-device dma-ops are the first thing that's
> > > > needed. Stacking can then be introduced on a per-device basis.
> > >
> > > When we would want stacking, we'll want it globally and not per-device,
> > > isn't it? Or at least for devices on a particular bus.
> > >
> > > When an IOMMU driver registers itself, it should tell which devices it's
> > > interested in (each device behind a bus or by enumerating each device it
> > > cares for). This should take care of all the scenarios and we won't have
> > > the need for per-device dma_ops.
> >
> > Well, without per-device dma_ops, IOMMUs could live. But it's pretty
> > hacky. Every time a dma operation is called, IOMMUs need to figure out
> > how a device should be handled.
> 
> What if this information could be hidden behind (a slightly complicated) 
> get_dma_ops()? Also, each of the operations in dma_ops will see if there's 
> something else down the stack that might be interested in the current device.

dma_ops can't do anything since only IOMMUs know what to do against a
device.

Whatever you implement in dma_ops, without per-device dma_ops, IOMMUs
need to figure out what to do a device every time a dma operation is
called.


> My contention is that we are going to need stackable ops, and a full-fledged 
> stackable implementation is going to solve this problem as well. However, 
> this current implementation of per-device dma_ops looks like a really simple 
> and non-intrusive solution to one problem, that of getting rid of some 
> overheads in the IOMMU code.

I don't think that stackable ops solve the problem that some IOMMUs have.


> > If IOMMUs can set dma_ops for the device when a new device is created,
> > IOMMUs don't care anything any more. That's much clean. That's What
> > the POWER architecture does.
> >
> > > For something like pvdma, we can walk through the list of pci devices and
> > > make a hypercall for each of them to get this information and have the
> > > pvdma version of dma_ops registered for that device. This sounds like
> > > it's per-device dma_ops, but it's not -- internally, the dma operations
> > > walk through each of the IOMMUs registered and call them in sequence.
> >
> > As Muli poinsted out, For pvdma, you need stacking per-device
> > dma_ops. With per-device dma_ops, you don't need hack like adding
> > is_pv_device hook in dma_ops. You can set your dma_ops to only pci
> > devices that you are interested.
> 
> The hack was added only because there's no stackable dma api we have now. 
> Sure, per-device dma_ops is going to solve this problem and I like it. I'm 
> only saying we're also going to need stacking ops and in effect, per-device 
> dma_ops would just be replaced by them once we get the complete solution.

Again, stackable ops can't cleanly solve the problem that per-device
dma_ops tries to solve. For example, you stack dma_ops like
pvdma->hardare->nommu/swiotlb. How can pvdma_ops know if pvdma_ops
needs to handle a device or not? pvdma_ops needs to skip some devices
and handle some. per-device dma_ops enables us not to stack pvdma_ops
for devices that pvdma_ops are not instrested in. That's much clean.
