Return-Path: <linux-kernel-owner+w=401wt.eu-S1761581AbZJJBrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761581AbZJJBrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 21:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759612AbZJJBrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 21:47:52 -0400
Received: from straum.hexapodia.org ([64.81.70.185]:41622 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbZJJBrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 21:47:51 -0400
Date: Fri, 9 Oct 2009 18:47:14 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Chris Wright <chrisw@sous-sol.org>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: DMAR regression in 2.6.31 leads to ext4 corruption?
Message-ID: <20091010014714.GG30557@hexapodia.org>
References: <20091009061729.GA31242@hexapodia.org> <20091010000926.GA17547@sequoia.sous-sol.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091010000926.GA17547@sequoia.sous-sol.org>
User-Agent: Mutt/1.4.2.3i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 05:09:26PM -0700, Chris Wright wrote:
> There's some timing coincidence there, but it's a full 1/2 second between
> the ext4 error and the DMAR fault (and there's various DMAR faults
> along the way for the same buffer before and after the ext4 error).
> That fault is quite typical of a driver bug, and it's the VGA device
> (rather its driver) that is culpable.  The IOMMU caught the VGA device
> trying to do a DMA write to a buffer mapped r/o.

Yeah, this timing coincidence isn't very compelling to me, but
*something* sure is hosing my filesystems.  (Note that I've had ext3 and
ext4 both fail with what look like missed, misdirected, or corrupted
writes.)

> > The full output of fsck and full dmesg are at the URL below.
> > 
> > I don't know that DMAR is resulting in my repeated filesystem
> > corruption, but it does seem like a potential cause (and would explain
> > why I'm seeing this whereas most people aren't, since few people are
> > using VT-d *and* i915).
> 
> I do use it every day on my primary workstation (x200), and haven't
> had any issue (I'm using ext3).

What BIOS version are you using?  The X200 I'm testing on has "BIOS
Version 2.02 (6DET38WW) 2008-12-19".  Hmm, I see there's a 3.08
2009-09-07 available...

Could you provide a dmesg from a working machine?

> > I see that the BROKEN_GFX_WA code has been removed; do we actually
> > believe that the relevant code is working?  Could it be corrupting my
> > AHCI DMAs if not?
> 
> It should be for your adapter (after 66a4fe0c merged in agp fixes).
> While it could still be broken (aside of the initial faults before the
> device is even initialized in Linux -- I'm not seeing any faults, btw),
> iommu=pt will put all devices in a 1:1 mapped domain and would suppress
> the DMAR faults you see (similar to intel_iommu=off, but allowing the
> iommu to still be used for pci device assignment).  However, doing that
> or enabling the gfx workaround would allow the device to generate invalid
> DMA requests since if effectively disables the IOMMU for the gfx device,
> which would leave a better opportunity for DMA related corruption.

OK, thanks for the confirmation that the BROKEN_GFX_WA issues should be
fixed in current linus kernels, I'm certainly running with 66a4fe0c.

> The earlier fs issues we saw w/ the IOMMU were when it was actively
> blocking disk DMA requests, but that's not happening here.

Well, we don't know for sure what happened on the previous boot where
the filesystem corruption occurred.  I'm imagining a nightmare scenario
where GPU erroneous writes cause DMAR faults and handling them somehow
causes AHCI DMA requests to get lost.

I'm going to go ahead on the theory that the BIOS needs an update.

-andy
