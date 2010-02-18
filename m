Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab0BRFWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 00:22:20 -0500
Received: from kroah.org ([198.145.64.141]:48458 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724Ab0BRFWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 00:22:13 -0500
Date: Wed, 17 Feb 2010 21:22:23 -0800
From: Greg KH <greg@kroah.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Linux-usb <linux-usb@vger.kernel.org>,
       Linux USB <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [PATCH 2.6.34] ehci-hcd: add option to enable 64-bit DMA
	support
Message-ID: <20100218052223.GA13254@kroah.com>
References: <4B7CAF95.6020306@gmail.com> <20100218042626.GB11649@kroah.com> <51f3faa71002172113o65a85ed6y5fa39d0b3a96f7ce@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51f3faa71002172113o65a85ed6y5fa39d0b3a96f7ce@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 17, 2010 at 11:13:05PM -0600, Robert Hancock wrote:
> On Wed, Feb 17, 2010 at 10:26 PM, Greg KH <greg@kroah.com> wrote:
> > On Wed, Feb 17, 2010 at 09:10:13PM -0600, Robert Hancock wrote:
> >> Add a module parameter to allow the user to enable 64-bit DMA support in EHCI,
> >> which has been forcibly disabled since 2003 - see:
> >>
> >> http://www.mail-archive.com/linux-usb-devel@lists.sourceforge.net/msg17230.html
> >>
> >> At that time the comment was "it'd only matter on a few big Intel boxes anyway",
> >> however the situation is much different today when many new machines have 4GB
> >> or more of RAM and IOMMU/SWIOTLB are thus needlessly required for USB transfers.
> >> For now, the support remains disabled by default and is controlled by an
> >> allow_64bit module parameter.
> >>
> >> Note that some USB device drivers may require updates to pass the DMA
> >> capabilities up to their higher layers to avoid unnecessary IOMMU or bounce-
> >> buffer use (i.e. networking layer NETIF_F_HIGHDMA). Some of these checks were
> >> disabled by the patch listed above, and more may be required again today.
> >> However, those previous checks were done incorrectly using dma_supported,
> >> which checks to see whether a device's DMA mask can be validly set to a given
> >> mask, not whether its previously set mask will accomodate the mask passed in.
> >>
> >> Signed-off-by: Robert Hancock <hancockrwd@gmail.com>
> >
> > What is the "advantage" that setting this option would allow people to
> > do that the code currently does not? ?Is such an advantage measurable at
> > the slow rates that the EHCI driver controls?
> 
> I expect it would likely be quite system-dependent. However,
> particularly with devices like high-speed USB storage on systems with
> lots of RAM, especially 8GB or more (where more of the memory can't be
> addressed with 32-bit than can), I suspect it would likely be
> measurable in terms of CPU usage, throughput or both, especially if
> there's no hardware IOMMU and software bounce-buffering is required.

So you did not measure it?

Hm, I guess this change must not be necessary :)

> > Is there any way to dynamically figure out if we can enable this or not?
> > Adding module paramaters sucks, as they are hard to configure for most
> > users, and they tend to be ignored.
> 
> Well, the option only has an effect if the controller indicates the
> 64-bit addressing feature flag in the first place. The only issue
> would be with potential controllers that report the feature flag but
> it doesn't work. Based on the libata experience with AHCI which has a
> similar 64-bit feature flag, there are some controllers that didn't do
> it properly, but not many (only ATI SB600 it appears, and only on
> certain boards, as it seems it was a BIOS configuration issue).
> 
> Having the ability to turn it on manually for testing would likely be
> the first step towards turning it on for all controllers that indicate
> support, not the end goal in itself.

But we disabled it on purpose, because of problems, do we want those
problems again?

> > And are you really ok with enabling this on a system-wide level, and not
> > on a per-controller level? ?Does that work properly on all systems?
> 
> As above, the only issue is if the controller reports the capability
> but it doesn't function properly. If a user runs into the case where
> one of their controllers doesn't work with it enabled, that likely
> means that we need to add blacklisting for that device ID, etc. (or
> blacklist 64-bit DMA for their platform in general).

blacklists are hard to keep up to date, you are always handling bug
reports after-the-fact.  That's not something you should add lightly.

> > And if the system does not support it, and a user enables it, who is
> > going to support their broken system? ?:)
> 
> That would be me/us :-) We need those reports though, to know how to
> proceed, and better to be from those who opted into testing for now..

But we need a _reason_ to enable it.

What user needs this?

And if there is no speed benifit, why take the risk?

thanks,

greg k-h
