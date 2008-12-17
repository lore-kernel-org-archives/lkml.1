Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759955AbYLQHmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955AbYLQHmX (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 02:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbYLQHmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 02:42:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753691AbYLQHmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 02:42:08 -0500
Date: Tue, 16 Dec 2008 23:41:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: device driver probe return codes
Message-Id: <20081216234128.05a343bb.akpm@linux-foundation.org>
In-Reply-To: <20081216215331.GH12431@fluff.org.uk>
References: <20081216215331.GH12431@fluff.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008 21:53:31 +0000 Ben Dooks <ben-linux@fluff.org> wrote:

> I would like some feedback on the following regarding some
> form of standardising return codes from a device driver probe
> to try and stop some basic mistakes.
> 
> This document is not complete, any additions would be welcone.
> 
> 
> probe() error return codes
> ==========================
> 
> -ENODEV		This should be reserved for the case where there
> 		really is no device here.
> 
> 		If you do not have a necessary resource or other setup
> 		information this is NOT the error you want to return as
> 		the driver core will not print any error message to the
> 		user. Even if you driver prints a warning, this is still
> 		not the error code to return.
> 
> -ENXIO		See -ENODEV, this is taken by the driver core to mean
> 		there is "No such device or address (POSIX.1)".
> 
> -ENOMEM		This is used to signify lack of memory resources, such
> 		as a failure to kmalloc() device state.
> 
> -EBUSY		A resource you need is not avaialable.
> 
> 		This is returned if you cannot get exclusive access to a
> 		resource such as a request_mem_region() has failed.
> 
> -EINVAL		An argument to the driver is invalid.
> 
> -EIO		An input/output error occured. This could be due to
> 		the device responding in an unexpected way or that
> 		the device did not complete a request properly.
> 
> 

Sounds good.  I forsee a lot of patches to fix all this up :)

> 
> Generic driver examples
> =======================
> 
> Requesting an memory region
> ---------------------------
> 
> 	if (!request_mem_region(start, len, why))
> 		return -EBUSY;
> 
> Mapping a IO region
> -------------------
> 
> 	regs = ioremap(base, size);
> 	if (!regs)
> 		return -EIO;
> 
> possibly -EFAULT here? 

I don't think EFAULT is appropriate here - there was no fault.

And EIO to me implies some problem with a hardware device.

> Not -ENOMEM, which a number of drivers do.

And ENOMEM should be reserved for page allocation exhaustion.

It's a bit presumptuous, but perhaps EBUSY here?

> 
> Platform driver specific examples
> =================================
> 
> Examples when writing platform drivers.
> 
> All examples in this section assume the probe prototype is:
> 
> static int my_probe(struct platform_device *pdev)
> 
> 
> Checking platform data
> ----------------------
> 
> 	if (!pdev->dev.platform_data)
> 		return -EINVAL;
> 
> should -ENOENT be returned here?

Well.. what would cause this to come about?

Perhaps BUG() is more appropriate ;)

> 
> Finding platform resource(s)
> ----------------------------
> 
> 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> 	if (!res)
> 		return -ENOENT;

I don't really like the practice of returning what are clearly
filesystem-related errnos just because they're kinda sorta conceptually
similar to what actually happened.

Again, what could actually cause this to happen?  The device doesn't
have any memory resources?  So it's busted?  EIO or ENODEV?

> 	   
> Getting a clock
> ---------------
> 
> 	clk = clk_get(&pdev->dev, NULL);
> 	if (IS_ERR(clk))
> 		return PTR_ERR(clk);

yup.


But really, the drivers should be doing far less of this
errno-guessing.  In the majority of cases (platform_get_resource,
ioremap, request_mem_region from your examples) the core kernel
function should have returned an IS_ERR value and all the driver needs
to do is to return it.

But we screwed that up again and again.
