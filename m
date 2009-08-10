Return-Path: <linux-kernel-owner+w=401wt.eu-S1752324AbZHJTjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbZHJTjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 15:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbZHJTjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 15:39:14 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:44268 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbZHJTjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 15:39:13 -0400
Date: Mon, 10 Aug 2009 21:38:49 +0200
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@gefanuc.com>
Cc: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 1/5] Staging: VME Framework for the Linux Kernel
Message-ID: <20090810193849.GA3055@braap.org>
References: <20090803205657.964064732@mini.kroah.org> <20090803210111.GB28430@kroah.com> <20090808230145.GB27151@braap.org> <4A801644.2070009@gefanuc.com> <20090810141442.GA18456@braap.org> <4A804283.5090009@gefanuc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A804283.5090009@gefanuc.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martyn Welch wrote:
> That's one reason for the helper function. If VME bridges are added  
> which sit of on other buses then vme_alloc_consistent can be extended to  
> support this without requiring VME device drivers to be altered to  
> reflect the fact that pci_alloc_consistent might not work for all VME  
> bridges.

But it corresponds to the bridge's code (not to the generic layer) to
know whether the bridge sits on top of PCI or not; hence my comment.

> The DMA controller in the tsi-148 can do PCI to PCI; PCI to VME; VME to  
> PCI; VME to VME; Patterns to  VME and Patterns to PCI transfers. How do  
> you specify all those options without providing a structure where over  
> 50% of the fields aren't used for any given transfer?

I think a struct where not _every_ field is *always* used is fine.
However requiring your drivers to know about what your bridge
looks like is a mistake; just give them something thin that doesn't
assume anything about what's behind it, and if it's not supported,
return an appropriate error message.

> Every bridge I have seen is capable of link-list execution. The API  
> provides the ability to do scatter-gather style DMA transfers, this  
> could be used as part of a "zero-copy" type driver for high speed VME  
> capture devices. How would you support the link-list execution with a  
> single call?

Let me say it again: "Drivers should know *nothing* about the
underlying bridge".
They should work with *any* bridge; or do we care about the PCI
bridge we're plug our PCI device on when writing a driver for it?

> I was also looking at the ability to queue DMA transfers if the  
> controller was currently busy - if the consensus is that this is  
> overkill I will happily remove this.

AFAICT the tsi148 has several DMA channels; in our driver we just
try to find a free channel to proceed with the transfer; if there
aren't any then we return EBUSY.
Drawing an analogy with current 'streaming DMA' transfers, we're
told we should check whether they failed or not, so I think
trying to be too clever here it's not worth it.

> I implemented it using param array, I agree that the arguments might get
> quite long with 10 devices, especially if multiple parameters are
> required, but I don't see why it shouldn't work.

The fact that 'it works' doesn't make it less ugly or messy.
When referring to code, these two words usually mean "there's
a better way"; so let's just find it.

E.
