Return-Path: <linux-kernel-owner+w=401wt.eu-S1758607AbZE1Hhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607AbZE1Hhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 03:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbZE1Hh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 03:37:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:53367 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbZE1Hh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 03:37:26 -0400
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Timur Tabi <timur@freescale.com>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, rmk@arm.linux.org.uk
In-Reply-To: <20090527150527.GK6805@pengutronix.de>
References: <1243408083.13460.14.camel@debian-nb>
	 <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com>
	 <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com>
	 <20090527150527.GK6805@pengutronix.de>
Content-Type: text/plain
Date: Thu, 28 May 2009 17:32:05 +1000
Message-Id: <1243495925.3171.134.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-27 at 17:05 +0200, Robert Schwebel wrote:

> I'm highly convinced that the existence of oftree-hell in ARM-land would
> have been *the* key motivation for FSL to have worked on mainline
> instead of inhouse-BSPs back in 2004 when we mainlined i.MX1 and in 2007
> when we started the mainline work on MX27 and MX31.
> 
> Seriously: oftree in general is a good idea. Just that it doesn't work
> in practise. The concept has some serious flaws:

Lots of strong words and animosity here ... we may not have got
everything right the first time around, an some things may still be wet
behind the ears but overall, I'm strongly convinced that this whole
thing ended up being a net benefit for various reasons though not
necessarily the most obvious ones.

> - The whole concept is based on the assumption that bindings are defined
>   *once*, then never to be changed again. As this is not true (check
>   MPC5200 to find out what I mean), oftree wreckage is *the* main cause
>   of new kernels not working on old bootloaders any more. Is there a
>   solution of this problem? I have not seen a good idea how to avoid the
>   constant change in definitions.

Bindings are defined as we go and mostly -can- be changed, it's actually
not that a big deal. It depends what your approach is though vs. putting
the device-tree in a firmware or just shipping it wrapped with the
kernel. Right, putting DTs in firmwares mean potential issues like that,
but we dealt on real OF based platforms with serious differences in
approach and bindings between IBM, Apple and Sun without big
difficulties.

IE. It's not a big deal in practice, at least not as much as it seems.

Part of the problem exposed by the bindings discussions is typical to
internet discussions where the less complex the problem is, the more
idiots come in and think they have something to contribute :-)

Mostly, a binding only need some good work once for bus types, and a lot
of the common ones have been ironed out. Funnily enough, it looks like
we may have to do one for amba on powerpc soon too :-)

For actual devices, there's a huge amount of flexibility. It's nice to
be standardize whenever possible, but in the end, the content of a node
is a deal between the device-tree and the driver.

> - The oftree layering is fundamentally broken. We already have a sane
>   abstraction for arbitrary hardware in the kernel: platform devices.
>   Why not instanciate platform devices from a generic oftree core?

I don't understand what you mean here. Platform devices are everything
-but- a sane abstraction, but again, there is absolutely no issue there,
it's completely orthogonal.

Nowadays, any struct device can be linked to an OF device node thanks to
the archdata extension that we added to the generic struct device. One
of the idea we have in mind is to create a simple mechanism that
"intanciate" devices based on probing them in the tree, regardless of
the actual bus and linux device "type" (platform, PCI, i2c, ...).
 
> - Platform data makes it possible to store function pointers. There
>   is no equivalent to this concept in oftree-land.

I don't see why there would be ... those are totally different issues
here.

> oftree could be a great tool if these things would be resolved.
> Currently they are not, and in result, ARM just works and is easy,
> whereas on PowerPC systems people often spend more time working on
> binding stuff than on the actual functionality.

A lot of conservatism here and little attempt to even think about the
possible benefits :-)

There are areas where the device-tree have proved invaluable. One is
interrupt routing. The ability of the DT to represent any possible
interrupt layout of cascaded PICs and other fucked up schemes is great,
which mixed with powerpc simple virtual interrupt mapping scheme greatly
simplified handling of many setups.

You really only need to describe in each device what PIC it's connected
to, what IRQ on that PIC and the sense info. You can convert interrupt
domain using maps (useful for PCI). The kernel provide simple helper to
retrieve this, and with our IRQ remapping core (which I would recommend
porting as well), can trivially assign PIC/irq pairs to a linux irq
number. No more hard wired ranges that blow up every time you try to
add a new GPIO controller in the system etc...

It's also proved very useful to effectively have all the data related
to how the HW is wired together in one single place rather than spread
among 25 drivers and platform files.

And that's just some ...

Cheers,
Ben.

