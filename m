Return-Path: <linux-kernel-owner+w=401wt.eu-S1752467AbXCSTih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbXCSTih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 15:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbXCSTig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 15:38:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42077
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752467AbXCSTif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 15:38:35 -0400
Date: Mon, 19 Mar 2007 12:38:36 -0700 (PDT)
Message-Id: <20070319.123836.39155546.davem@davemloft.net>
To: zaitcev@redhat.com
Cc: jg@laptop.org, linux-kernel@vger.kernel.org
Subject: Re: BSOD
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070319120807.af36ef5d.zaitcev@redhat.com>
References: <20070318160707.GC12673@elte.hu>
	<1174236045.6832.9.camel@localhost>
	<20070319120807.af36ef5d.zaitcev@redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pete Zaitcev <zaitcev@redhat.com>
Date: Mon, 19 Mar 2007 12:08:07 -0700

> On Sun, 18 Mar 2007 12:40:45 -0400, Jim Gettys <jg@laptop.org> wrote:
> 
> > Also more seriously, a somewhat hybrid approach is in order for mode
> > setting: simple mode setting isn't much code and is required for sane
> > behavior on crash (it is nice to get oopses onto a screen); but the full
> > blown mode setting/configuration problem is so large that on some
> > hardware, it is likely left best left to a helper process (not the X
> > server).
> 
> Jim, I doubt that a mode switch on oops is a good idea. Maybe I'm unlucky,
> but in my experience, it often is the case that systems fail to switch
> to text mode for shutdown. What is amazing, the very same systems switch
> to text mode on <Alt>F1 just fine, and then back to <Alt>F7!
> I would hazard a guess that this happens because nobody cares
> about shutdown modes to fix them. But then the same is true for
> crashes.
> 
> I understand that you have your own experience, but thought to note
> this all the same.
> 
> From the constructive angle, I think that a crash should render into
> existing mode, into the currently mapped frame buffer. This is the
> only way how it can be made to work reliably.

All of this talk makes me appreciate what happens on Sparc machines
even though it has more often than not been ridiculed.

There the firmware sets the resolution and that's basically what
the kernel and X uses, no mode changes are performed.

With that kind of setup even the system firmware (such as OFW) can
render error messages onto the console while X is active.

The disadvantage of course is that you're stuck with whatever video
mode you configured the firmware to use.  The advantage is that you
always get crash messages and neither X nor the kernel framebuffer
driver need to know how to switch modes.

Back to the main discussion, when we get an OOPS you can basically
assume that nothing works.  So I definitely agree with Peter.
There is no way we should try to execute something so non-trivial
as a mode switch when the kernel is on it's last legs.

There are four pieces of information the kernel needs from the X
server when it switches modes in order to do this:

1) pixel resolution
2) frame buffer base, should be specified in an extremely
   portable a manner (this means NOT using physical addresses
   or just PCI addresses), perhaps a PCI device specifier,
   BAR index, and offset from that BAR.
3) frame buffer w-skip (ie. how many bytes to get to the next
   scanline)
4) depth/bpp

This is also what the most minimal kernel framebuffer driver needs in
order to support a chip.

I understand that there are chips that can only be rendered into using
DMA or indirect accesses, that's a very real and tough problem to fix.
There is also the issue of making sure the graphics card accelerator
is not rendering anything (ie. it's pipeline FIFO has emptied) when
we try to render a panic message.
