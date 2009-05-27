Return-Path: <linux-kernel-owner+w=401wt.eu-S933606AbZE0TyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933606AbZE0TyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 15:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933375AbZE0Txk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 15:53:40 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:49806 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933400AbZE0Txj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 15:53:39 -0400
Message-ID: <4A1D9A1E.80603@freescale.com>
Date: Wed, 27 May 2009 14:53:02 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Russell King <rmk+lkml@arm.linux.org.uk>
CC: Peter Korsgaard <jacmet@sunsite.dk>,
       Robert Schwebel <r.schwebel@pengutronix.de>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Janboe Ye <yuan-bo.ye@motorola.com>, Timur Tabi <timur@freescale.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> <20090527150527.GK6805@pengutronix.de> <87vdnm8sec.fsf@macbook.be.48ers.dk> <4A1D6901.2090508@freescale.com> <20090527175609.GB31861@flint.arm.linux.org.uk> <4A1D8FBA.6040802@freescale.com> <20090527192909.GA32398@flint.arm.linux.org.uk>
In-Reply-To: <20090527192909.GA32398@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> On Wed, May 27, 2009 at 02:08:42PM -0500, Scott Wood wrote:
>> Russell King wrote:
>>> No one has brought that up on the ARM mailing lists - so does this issue
>>> really exist?  All of the stuff I see on the ARM lists seems to be well
>>> behaved and following our existing model - even vendor stuff (supplied
>>> to me under NDA) seems to generally get this kind of stuff right.
>> I'm just going by what I've seen on the u-boot list lately.  What is the  
>> existing ARM Linux model for passing MAC addresses, so that we can point  
>> people to that when they try to get u-boot to do silly things?
> 
> To program them into the hardware registers, 

Isn't that adding a requirement to the boot firmware?  I thought you 
didn't like that? :-)

The patches that were proposed (and NACKed) in u-boot did exactly this 
-- except supposedly they would only set the MAC address if the 
interface were actually used prior to booting the kernel.

> which is not what we in the ARM community say, but it's what the
> _network_ guys tell people they should be doing.

They don't seem to be NACKing drivers that get it from the device tree 
instead.

> I've suggested in the past having a standard kernel parameter such
> that you can specify a mac address on a per-device basis in a totally
> platform independent way, but the network folk don't like that idea.

How do you reliably associate MAC addresses with specific devices that 
way?  The device tree can do this.

Think of the device tree as a really expressive kernel command line 
argument. :-)

>> I'm not talking about platform specific code, I'm talking about code to  
>> retrieve information about a device from the device tree.  There would  
>> not be separate instances of this for "platforms X, Y and Z", just one  
>> of_platform binding in each driver.  It's no different than having a  
>> platform bus binding, except in the data structures used.
> 
> I really don't see what OF buys us then,

The data is in a key/value format rather than a C struct, which makes it 
easier to pass from entities outside the kernel *if you want to*.

It is this distinction that led to the platfom/of_platform split -- we 
can't turn key/value into C structs without glue code that knows the 
specific device binding, and it's easier for the driver to access that 
data directly.

>> The device tree is quite capable of expressing information beyond  
>> addresses and interrupts.
> 
> Bus width?  Register offset spacing?  SMC LED configuration?  Whether
> to use the hardware wait signal from the SMC?
> 
> If you're going to say yes to all that,

Sure, you can add properties for that stuff.

> I'm going to start asking how
> you cope with verifying that the data for ethernet driver A doesn't
> get accidentally used for ethernet driver B.

Device nodes have "compatible" properties indicating what the hardware 
is compatible with.  A given driver only binds to nodes for hardware 
that is compatible with what it knows how to drive.

> I assume you have some kind of compiler, which needs a set of specification
> files to tell it what's required for each driver which is OF compatible.

Yes, there's a device tree compiler.  It doesn't know the details of 
individual device bindings, which is a little less safe than C structs, 
but not much.  There's nothing in theory preventing the compiler from 
being given this knowledge, and doing checks beyond what the C compiler 
can do.

> If not, I can see no way for OF trees to ever be safe and correct.

Code reviews and testing, same as how you get C code to be correct.

-Scott
