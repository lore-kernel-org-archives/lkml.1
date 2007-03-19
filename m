Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbXCSTyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbXCSTyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 15:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbXCSTyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 15:54:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:44635 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798AbXCSTyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 15:54:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,302,1170662400"; 
   d="scan'208"; a="215276783:sNHT19370939"
From: Jesse Barnes <jesse.barnes@intel.com>
To: David Miller <davem@davemloft.net>
Subject: Re: BSOD
Date: Mon, 19 Mar 2007 12:54:36 -0700
User-Agent: KMail/1.9.6
Cc: zaitcev@redhat.com, jg@laptop.org, linux-kernel@vger.kernel.org
References: <20070318160707.GC12673@elte.hu> <20070319120807.af36ef5d.zaitcev@redhat.com> <20070319.123836.39155546.davem@davemloft.net>
In-Reply-To: <20070319.123836.39155546.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703191254.36373.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 19, 2007 12:38 pm David Miller wrote:
> All of this talk makes me appreciate what happens on Sparc machines
> even though it has more often than not been ridiculed.
>
> There the firmware sets the resolution and that's basically what
> the kernel and X uses, no mode changes are performed.
>
> With that kind of setup even the system firmware (such as OFW) can
> render error messages onto the console while X is active.
>
> The disadvantage of course is that you're stuck with whatever video
> mode you configured the firmware to use.  The advantage is that you
> always get crash messages and neither X nor the kernel framebuffer
> driver need to know how to switch modes.

That certainly keeps things simple, but most machines force us into a 
more flexible approach. :)

> Back to the main discussion, when we get an OOPS you can basically
> assume that nothing works.  So I definitely agree with Peter.
> There is no way we should try to execute something so non-trivial
> as a mode switch when the kernel is on it's last legs.
>
> There are four pieces of information the kernel needs from the X
> server when it switches modes in order to do this:
>
> 1) pixel resolution
> 2) frame buffer base, should be specified in an extremely
>    portable a manner (this means NOT using physical addresses
>    or just PCI addresses), perhaps a PCI device specifier,
>    BAR index, and offset from that BAR.
> 3) frame buffer w-skip (ie. how many bytes to get to the next
>    scanline)
> 4) depth/bpp
>
> This is also what the most minimal kernel framebuffer driver needs in
> order to support a chip.
>
> I understand that there are chips that can only be rendered into
> using DMA or indirect accesses, that's a very real and tough problem
> to fix. There is also the issue of making sure the graphics card
> accelerator is not rendering anything (ie. it's pipeline FIFO has
> emptied) when we try to render a panic message.

I'm working on an approach that will teach the DRM layer about 
modesetting, which should address all the problems above, and also 
allow flexible uses like multihead and (I hope, though this is far 
fetched) things like a separate head for a kernel level debugger.

As for what happens at panic time, if the kernel knows how to modeset we 
can do whatever we want:  conservatively clear an appropriate scanout 
buffer and render our panic there, switch into a better mode to dump 
the panic if we think that's possible, or just hang without any output 
like we do today.

Kernel based modesetting should get us a lot of things:
  o robust suspend/resume support
  o some more independence from X for complex gfx setups
  o a good mode at early boot time
and several others I'm leaving out at the moment.  On the downside, the 
modesetting layer will be a chunk of new code, and require enhanced 
chip specific mode setting code to be added to the drm/fb drivers.

Jesse
