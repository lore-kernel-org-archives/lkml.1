Return-Path: <linux-kernel-owner+w=401wt.eu-S1761155AbZE0Pjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761155AbZE0Pjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 11:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbZE0Pjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 11:39:41 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:42138 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbZE0Pjl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 11:39:41 -0400
MIME-Version: 1.0
In-Reply-To: <20090527150527.GK6805@pengutronix.de>
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> 
	<ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> 
	<20090527150527.GK6805@pengutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 27 May 2009 09:39:21 -0600
Message-ID: <fa686aa40905270839m375bbdacqb1acb1be0a2d2da0@mail.gmail.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Timur Tabi <timur@freescale.com>, Janboe Ye <yuan-bo.ye@motorola.com>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       rmk@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 9:05 AM, Robert Schwebel
<r.schwebel@pengutronix.de> wrote:
> Seriously: oftree in general is a good idea. Just that it doesn't work
> in practise. The concept has some serious flaws:
>
> - The whole concept is based on the assumption that bindings are defined
>  *once*, then never to be changed again. As this is not true (check
>  MPC5200 to find out what I mean), oftree wreckage is *the* main cause
>  of new kernels not working on old bootloaders any more. Is there a
>  solution of this problem? I have not seen a good idea how to avoid the
>  constant change in definitions.

This is a MPC5200 is the posterchild for device tree wreckage; mostly
because of my own inexperience at the time.  A lot of mistakes were
made and I freely admit that.

However, my counter example is Xilinx Virtex support.  The Virtex is
an FPGA with all the devices instantiated in the FPGA fabric.  It
would be a nightmare to try and describe each different FPGA bitstream
using hand coded platform devices, and the xparameters.h file exported
by the Xilinx toolchain wasn't much better.  Encoding the machine
layout in a data structure (the device tree) has decoupled FPGA
changes from the kernel image.  Now FPGA engineers can make major
changes to FPGA layouts without having to lockstep with changes in the
kernel.  I regularly boot a single kernel image on multiple bitstream
images.

That being said, the problems we have had are the reason why it is
*not* recommended to hard link the device tree image into firmware.
We do commit to not breaking old trees, but the ability to update is
important; particularly for enabling new features/drivers.

> - The oftree layering is fundamentally broken. We already have a sane
>  abstraction for arbitrary hardware in the kernel: platform devices.
>  Why not instanciate platform devices from a generic oftree core?

No; the oftree is a data structure.  That is it, nothing more.  The
device tree layout is well defined and independent of Linux kernel
internal implementation details.  In powerpc land we've chosen to use
the of_platform bus to decode the data into Linux usable form, and I
think it is the best approach.  If a designer wanted to, then platform
devices could be instantiated instead.  In fact, that used to be done
for most powerpc devices, but we've moved away from that model because
the data still needs to be decoded somewhere, and that 'somewhere'
should be as close to the driver as possible.

> - Platform data makes it possible to store function pointers. There
>  is no equivalent to this concept in oftree-land.

But there is concept of platform specific code.  In the majority of
cases platform specific function pointers aren't needed at all.  In
the cases where they are; platform devices can still be used.

> oftree could be a great tool if these things would be resolved.
> Currently they are not, and in result, ARM just works and is easy,
> whereas on PowerPC systems people often spend more time working on
> binding stuff than on the actual functionality.

That's a rather polarizing statement and I don't think its fair.  The
FDT is not a magic bullet.  It makes aspects of platform independence,
code sharing, and board porting simpler, but it is also requires
forethought and has overhead associated with it.  I don't think anyone
is proposing to require all ARM platforms to use the FDT approach.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
