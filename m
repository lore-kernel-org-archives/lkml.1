Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758049AbYLPVxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbYLPVxn (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 16:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbYLPVxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 16:53:33 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:34172 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750967AbYLPVxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 16:53:32 -0500
Date: Tue, 16 Dec 2008 21:53:31 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Subject: device driver probe return codes
Message-ID: <20081216215331.GH12431@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would like some feedback on the following regarding some
form of standardising return codes from a device driver probe
to try and stop some basic mistakes.

This document is not complete, any additions would be welcone.


probe() error return codes
==========================

-ENODEV		This should be reserved for the case where there
		really is no device here.

		If you do not have a necessary resource or other setup
		information this is NOT the error you want to return as
		the driver core will not print any error message to the
		user. Even if you driver prints a warning, this is still
		not the error code to return.

-ENXIO		See -ENODEV, this is taken by the driver core to mean
		there is "No such device or address (POSIX.1)".

-ENOMEM		This is used to signify lack of memory resources, such
		as a failure to kmalloc() device state.

-EBUSY		A resource you need is not avaialable.

		This is returned if you cannot get exclusive access to a
		resource such as a request_mem_region() has failed.

-EINVAL		An argument to the driver is invalid.

-EIO		An input/output error occured. This could be due to
		the device responding in an unexpected way or that
		the device did not complete a request properly.




Generic driver examples
=======================

Requesting an memory region
---------------------------

	if (!request_mem_region(start, len, why))
		return -EBUSY;

Mapping a IO region
-------------------

	regs = ioremap(base, size);
	if (!regs)
		return -EIO;

possibly -EFAULT here? 

Not -ENOMEM, which a number of drivers do.


Platform driver specific examples
=================================

Examples when writing platform drivers.

All examples in this section assume the probe prototype is:

static int my_probe(struct platform_device *pdev)


Checking platform data
----------------------

	if (!pdev->dev.platform_data)
		return -EINVAL;

should -ENOENT be returned here?


Finding platform resource(s)
----------------------------

	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
	if (!res)
		return -ENOENT;

	   
Getting a clock
---------------

	clk = clk_get(&pdev->dev, NULL);
	if (IS_ERR(clk))
		return PTR_ERR(clk);



-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
