Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbZE2BjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbZE2BjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 21:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbZE2BjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 21:39:11 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:45525 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbZE2BjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 21:39:10 -0400
Date: Fri, 29 May 2009 11:39:08 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090529013908.GA7831@yookeroo.seuss>
Mail-Followup-To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Grant Likely <grant.likely@secretlab.ca>,
	Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
	devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk
References: <20090527175609.GB31861@flint.arm.linux.org.uk> <1243496236.3171.140.camel@pasglop> <20090528091513.GA14789@n2100.arm.linux.org.uk> <20090528.025739.16559619.davem@davemloft.net> <gvlvcs$ub5$1@ger.gmane.org> <fa686aa40905280713u2b3ef5fvbe3d58ccdb629b60@mail.gmail.com> <1243549318.17903.9.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243549318.17903.9.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 08:21:58AM +1000, Benjamin Herrenschmidt wrote:
> On Thu, 2009-05-28 at 08:13 -0600, Grant Likely wrote:
> > Two nodes are used to describe the device and a "phandle" is used to
> > link them.  A device driver probe could be triggered (bind) against
> > the i2c half of the device and follow the phandle to get the rest of
> > the description.
> 
> One thing I wouldn't do though is to put "phandle" in the property
> name :-) Just call it spi-interface.
> 
> Now, that's an option. And it works to a certain extent. But I do
> understand the need in general to provide "methods". It's something
> we don't solve (but then we don't make it worse than it was before).
> 
> I think the cleanest option might be named methods in the device-tree
> for example, a device can have an "enable-method" property and a
> "clock-method" property. The names would use the usual convention
> of "manuf,name" to avoid clashes and could be registered by the
> platform.
> 
> Now, it -does- somewhat deviates from the moto that the DT should
> only contain OS agnostic HW representations, but appart for having
> a full blown OF with actual method calls in each nodes I don't
> see a nicer way at this stage.

But then another OS can also understand those names and at least use
them to figure out what procedures it needs.  That's not fundamentally
different from the fact that the device tree doesn't provide drivers -
if a node has a certain compatible value, you just have to know how to
drive it based on that.

Note that ePAPR (a new standard for firmware/OS interface on embedded
powerpc machines) already has a small example of this approach.  We
add an "enable-method" property in the cpu nodes to indicate how
secondary cpus should be started up.  One basic, least common
denominator method is defined in the standard, but it's kind of
crappy, so it's expected that vendor and/or platform specific methods
will be used most of the time - in order to boot such a machine, the
OS just has to know how to implement that method.

Also note that there are certainly circumstances where it's reasonable
to have a device node representing nothing more than a tangle of wires
between a couple of other devices.  In this case the compatible
property as usual selects a "driver" for the device (in practice
usually folded into some other driver) which can handle peculiar
routing or other fiddling things such as you describe.

> Now, the methods could then take "informations" from the target DT.
> 
> For example, one could have a generic "simple-gpio-enable" method that
> can be used as "enable-method" anywhere, as long as the target device
> contains also a "enable-gpio" property that points to the actual GPIO
> (and maybe an "enable-delay" while at it).
> 
> IE. We can provide a collection of "simple" methods that handle
> the easy cases in library code.
> 
> I'm very much against putting actual function pointers in the tree
> though as Jon Smirl proposed.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
