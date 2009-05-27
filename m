Return-Path: <linux-kernel-owner+w=401wt.eu-S1763777AbZE0TIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763777AbZE0TIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 15:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758146AbZE0TIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 15:08:24 -0400
Received: from main.gmane.org ([80.91.229.2]:53994 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760619AbZE0TIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 15:08:24 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Date: Wed, 27 May 2009 19:56:02 +0100
Message-ID: <2ve0f6-8fn.ln1@woodchuck.wormnet.eu>
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> <20090527150527.GK6805@pengutronix.de> <fa686aa40905270839m375bbdacqb1acb1be0a2d2da0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: woodchuck.wormnet.eu
User-Agent: tin/1.9.3-20080506 ("Dalintober") (UNIX) (Linux/2.6.26-1-sparc64 (sparc64))
Cc: devicetree-discuss@ozlabs.org, linux-arm-kernel@lists.arm.linux.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In gmane.linux.kernel Grant Likely <grant.likely@secretlab.ca> wrote:
> On Wed, May 27, 2009 at 9:05 AM, Robert Schwebel
> <r.schwebel@pengutronix.de> wrote:
>> Seriously: oftree in general is a good idea. Just that it doesn't work
>> in practise. The concept has some serious flaws:
>>
>> - The whole concept is based on the assumption that bindings are defined
>>  *once*, then never to be changed again. As this is not true (check
>>  MPC5200 to find out what I mean), oftree wreckage is *the* main cause
>>  of new kernels not working on old bootloaders any more. Is there a
>>  solution of this problem? I have not seen a good idea how to avoid the
>>  constant change in definitions.
> 
> This is a MPC5200 is the posterchild for device tree wreckage; mostly
> because of my own inexperience at the time.  A lot of mistakes were
> made and I freely admit that.
> 
> However, my counter example is Xilinx Virtex support.  The Virtex is
> an FPGA with all the devices instantiated in the FPGA fabric.  It
> would be a nightmare to try and describe each different FPGA bitstream
> using hand coded platform devices, and the xparameters.h file exported
> by the Xilinx toolchain wasn't much better.  Encoding the machine
> layout in a data structure (the device tree) has decoupled FPGA
> changes from the kernel image.  Now FPGA engineers can make major
> changes to FPGA layouts without having to lockstep with changes in the
> kernel.  I regularly boot a single kernel image on multiple bitstream
> images.
> 
> That being said, the problems we have had are the reason why it is
> *not* recommended to hard link the device tree image into firmware.
> We do commit to not breaking old trees, but the ability to update is
> important; particularly for enabling new features/drivers.
> 
Although I have no input of value here, I'm hoping I do not become the 
next posterchild for "pain++".

I'm working through redo'ing the FPGA support in the TS-7800[1] into a 
new bus rather than just continuing the messy direction I have been 
going to date[2].

My current approach is that the bus handles the 'hotplug'ing of the FPGA 
bitstream by unregistering all the devices and then when it's informed 
the new bitstream is ready it prods all the registered drivers if any 
devices need bringing up (obviously drivers can be modprobe'd as and 
when).

The 'magic' is that the FPGA code has some special value[3] that what it 
is and the drivers (outside the platform code) have a list of FPGA magic 
values (with a mask) that they are willing to service.  The *bus* 
(platform code) is what installs the devices effectively and only does 
so if the loaded driver says it can drive a particular loaded bitstream 
(in the bus driver struct is a array of ID's it checks).

Does this sound sane?  Is it an approach that could be ACKed one day?  
Currently the bit that might be considered sinful is there is for some 
of the drivers (rtc-m48t86, timeriomem-rng and plat_nand) the FPGA bus 
'driver' is a light wrapper around the platform device driver.  This is 
so that the hooks still exist so the bus know what to load and unload as 
and when.

I cannot think of another way to do this as implementing the FPGA as a 
'parent' *device* rather than a bus would shift all the bitstream 
specific code back into the platform code :-/  There might be a magic 
method I have not seen yet though.

I would dish out patches, but currently it's not a patch set, just one 
phat one; obviously it will be broken up later :)

Cheers

[1] http://ts78xx.digriz.org.uk/
	http://armlinux.simtec.co.uk/kautobuild/2.6.29/index.html#machine_1653
[2] http://git.marvell.com/?p=orion.git;a=blob;f=arch/arm/mach-orion5x/ts78xx-setup.c;hb=HEAD
[3] ftp://ftp.embeddedarm.com/ts-arm-sbc/ts-7800-linux/docs/ts-7800-syscon-regmap.txt

-- 
Alexander Clouter
.sigmonster says: Good leaders being scarce, following yourself is allowed.

