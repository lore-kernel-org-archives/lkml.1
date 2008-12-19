Return-Path: <linux-kernel-owner+w=401wt.eu-S1754383AbYLSIS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383AbYLSIS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 03:18:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbYLSISW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 03:18:22 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50545 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753063AbYLSISV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 03:18:21 -0500
Date: Fri, 19 Dec 2008 08:17:39 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: device driver probe return codes
Message-ID: <20081219081739.GL12431@fluff.org.uk>
References: <20081216215331.GH12431@fluff.org.uk> <20081216234128.05a343bb.akpm@linux-foundation.org> <20081218101426.GI12431@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081218101426.GI12431@fluff.org.uk>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 10:14:26AM +0000, Ben Dooks wrote:
> On Tue, Dec 16, 2008 at 11:41:28PM -0800, Andrew Morton wrote:
> > On Tue, 16 Dec 2008 21:53:31 +0000 Ben Dooks <ben-linux@fluff.org> wrote:
> > 
> > > I would like some feedback on the following regarding some
> > > form of standardising return codes from a device driver probe
> > > to try and stop some basic mistakes.
> > > 
> > > This document is not complete, any additions would be welcone.
> > > 
> > > 
> > > probe() error return codes
> > > ==========================
> > > 
> > > -ENODEV		This should be reserved for the case where there
> > > 		really is no device here.
> > > 
> > > 		If you do not have a necessary resource or other setup
> > > 		information this is NOT the error you want to return as
> > > 		the driver core will not print any error message to the
> > > 		user. Even if you driver prints a warning, this is still
> > > 		not the error code to return.
> > > 
> > > -ENXIO		See -ENODEV, this is taken by the driver core to mean
> > > 		there is "No such device or address (POSIX.1)".
> > > 
> > > -ENOMEM		This is used to signify lack of memory resources, such
> > > 		as a failure to kmalloc() device state.
> > > 
> > > -EBUSY		A resource you need is not avaialable.
> > > 
> > > 		This is returned if you cannot get exclusive access to a
> > > 		resource such as a request_mem_region() has failed.
> > > 
> > > -EINVAL		An argument to the driver is invalid.
> > > 
> > > -EIO		An input/output error occured. This could be due to
> > > 		the device responding in an unexpected way or that
> > > 		the device did not complete a request properly.
> > > 
> > > 
> > 
> > Sounds good.  I forsee a lot of patches to fix all this up :)
> > 
> > > 
> > > Generic driver examples
> > > =======================
> > > 
> > > Requesting an memory region
> > > ---------------------------
> > > 
> > > 	if (!request_mem_region(start, len, why))
> > > 		return -EBUSY;
> > > 
> > > Mapping a IO region
> > > -------------------
> > > 
> > > 	regs = ioremap(base, size);
> > > 	if (!regs)
> > > 		return -EIO;
> > > 
> > > possibly -EFAULT here? 
> > 
> > I don't think EFAULT is appropriate here - there was no fault.
> > 
> > And EIO to me implies some problem with a hardware device.
> > 
> > > Not -ENOMEM, which a number of drivers do.
> > 
> > And ENOMEM should be reserved for page allocation exhaustion.
> > 
> > It's a bit presumptuous, but perhaps EBUSY here?
> 
> Ok, that might be ok, but it will get overloaded as -EBUSY is
> a possible return from a number of resource reservation calls.

As a note, Russell has said that -ENOMEM should be more than acceptable
here, as generally a failure from ioremap() is due to there being
insufficient memory to create the necessary page mappings.
  
> > > 
> > > Platform driver specific examples
> > > =================================
> > > 
> > > Examples when writing platform drivers.
> > > 
> > > All examples in this section assume the probe prototype is:
> > > 
> > > static int my_probe(struct platform_device *pdev)
> > > 
> > > 
> > > Checking platform data
> > > ----------------------
> > > 
> > > 	if (!pdev->dev.platform_data)
> > > 		return -EINVAL;
> > > 
> > > should -ENOENT be returned here?
> > 
> > Well.. what would cause this to come about?
> > 
> > Perhaps BUG() is more appropriate ;)
> 
> WARN_ON() possibly, BUG() is a bit terminal to the whole kernel
> process and if triggered before the console is working can be
> rather hard to detect.
> 
> Possibly change this to:
> 
> 	 if (!pdev->dev.platform_data) {
> 		dev_dbg(&pdev->dev, "no platform data supplied\n");
> 		WARN();
> 		return -EINVAL;
> 	}
>  
> > > 
> > > Finding platform resource(s)
> > > ----------------------------
> > > 
> > > 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > > 	if (!res)
> > > 		return -ENOENT;
> > 
> > I don't really like the practice of returning what are clearly
> > filesystem-related errnos just because they're kinda sorta conceptually
> > similar to what actually happened.
> > 
> > Again, what could actually cause this to happen?  The device doesn't
> > have any memory resources?  So it's busted?  EIO or ENODEV?
> 
> ENODEV is part of the problem that we're trying to avoid returning
> as it gets silently discarded by the device core. Unfortunately without
> creating a new set of error codes specifically for device probes then
> we're out of choice.
>  
> > > 	   
> > > Getting a clock
> > > ---------------
> > > 
> > > 	clk = clk_get(&pdev->dev, NULL);
> > > 	if (IS_ERR(clk))
> > > 		return PTR_ERR(clk);
> > 
> > yup.
> > 
> > 
> > But really, the drivers should be doing far less of this
> > errno-guessing.  In the majority of cases (platform_get_resource,
> > ioremap, request_mem_region from your examples) the core kernel
> > function should have returned an IS_ERR value and all the driver needs
> > to do is to return it.
> 
> Yes, although the work to fixup some of these might be large it certainly
> shouldn't be too complicated to do.
> 
> -- 
> Ben (ben@fluff.org, http://www.fluff.org/)
> 
>   'a smiley only costs 4 bytes'
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
