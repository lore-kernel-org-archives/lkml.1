Return-Path: <linux-kernel-owner+w=401wt.eu-S1755179AbYE0EvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbYE0EvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 00:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbYE0Euw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 00:50:52 -0400
Received: from mis011.exch011.intermedia.net ([64.78.21.10]:35203 "EHLO
	mis011.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751561AbYE0Euv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 00:50:51 -0400
From: Amit Shah <amit.shah@qumranet.com>
Organization: Qumranet Inc.
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v2 -mm 0/2] x86: per-device dma_mapping_ops
Date: Tue, 27 May 2008 10:23:21 +0530
User-Agent: KMail/1.9.9
Cc: muli@il.ibm.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       alexisb@us.ibm.com, andi@firstfloor.org, kvm@vger.kernel.org,
       avi@qumranet.com
References: <200805260939.21320.amit.shah@qumranet.com> <200805262214.35397.amit.shah@qumranet.com> <20080527085054E.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080527085054E.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805271023.22574.amit.shah@qumranet.com>
X-OriginalArrivalTime: 27 May 2008 04:50:50.0098 (UTC) FILETIME=[3C41A520:01C8BFB5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 May 2008 05:20:54 FUJITA Tomonori wrote:
> On Mon, 26 May 2008 22:14:34 +0530
>
> Amit Shah <amit.shah@qumranet.com> wrote:
> > On Monday 26 May 2008 11:41:52 FUJITA Tomonori wrote:
> > > On Mon, 26 May 2008 09:39:20 +0530
> > >
> > > Amit Shah <amit.shah@qumranet.com> wrote:
> > > > On Sunday 25 May 2008 12:50:11 Muli Ben-Yehuda wrote:
> > > > > On Thu, May 22, 2008 at 04:13:02PM +0530, Amit Shah wrote:
> > > > > > OK; this sounds helpful. the hook can make a hypercall and
> > > > > > confirm with the host kernel if the device in question is an
> > > > > > assigned physical device. If yes, we replace the dma_ops. Though,
> > > > > > the original intent of having stackable ops is that we might want
> > > > > > to go through the swiotlb in the guest even for an assigned
> > > > > > device if the guest dma addresses are not in the addressable
> > > > > > range of the guest chipset.
> > > > > >
> > > > > > > created (it works with hot plugging). It enables IOMMUs to set
> > > > > > > up an appropriate dma_mapping_ops per device.
> > > > > >
> > > > > > From what we've discussed so far, it looks like stackable dma ops
> > > > > > will definitely be needed. Does this patchset provide something
> > > > > > that stacking won't?
> > > > >
> > > > > Yes---this patchset let's you have a per-device dma-ops, whereas
> > > > > with stackable you only get global dma-ops. I think it's clear we
> > > > > need both, and I think per-device dma-ops are the first thing
> > > > > that's needed. Stacking can then be introduced on a per-device
> > > > > basis.
> > > >
> > > > When we would want stacking, we'll want it globally and not
> > > > per-device, isn't it? Or at least for devices on a particular bus.
> > > >
> > > > When an IOMMU driver registers itself, it should tell which devices
> > > > it's interested in (each device behind a bus or by enumerating each
> > > > device it cares for). This should take care of all the scenarios and
> > > > we won't have the need for per-device dma_ops.
> > >
> > > Well, without per-device dma_ops, IOMMUs could live. But it's pretty
> > > hacky. Every time a dma operation is called, IOMMUs need to figure out
> > > how a device should be handled.
> >
> > What if this information could be hidden behind (a slightly complicated)
> > get_dma_ops()? Also, each of the operations in dma_ops will see if
> > there's something else down the stack that might be interested in the
> > current device.
>
> dma_ops can't do anything since only IOMMUs know what to do against a
> device.

Instead of each device calling a function to check which IOMMU is right, I am 
suggesting each IOMMU come in and tell which devices it is interested in.

> Again, stackable ops can't cleanly solve the problem that per-device
> dma_ops tries to solve. For example, you stack dma_ops like
> pvdma->hardare->nommu/swiotlb. How can pvdma_ops know if pvdma_ops
> needs to handle a device or not? pvdma_ops needs to skip some devices
> and handle some. per-device dma_ops enables us not to stack pvdma_ops
> for devices that pvdma_ops are not instrested in. That's much clean.

OK; how about this:

An example with per-device dma_ops and stacking will look like this:

pvdma->hardware->nommu/swiotlb
    ^             ^
     |              |
 e1000     rtl8139

And this scheme is going to suit everyone, agreed?

This is simple and doesn't need too many changes all around.

I was suggesting something more than this that can handle cases like an iommu 
wanting to have each device behind a bus to pass through it (it's still 
possible, but needs a per-device walk). Also, in the scenario depicted above, 
each device will start by pointing to the first iommu in the chain (pvdma in 
this case) and the iommu will then determine if that device needs to be 
passed via its translations.
