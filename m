Return-Path: <linux-kernel-owner+w=401wt.eu-S1750793AbXBSJXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750793AbXBSJXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 04:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750796AbXBSJXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 04:23:33 -0500
Received: from smtp-101-monday.noc.nerim.net ([62.4.17.101]:2322 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750793AbXBSJXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 04:23:32 -0500
Date: Mon, 19 Feb 2007 10:23:35 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] platform: reorder platform_device_del
Message-Id: <20070219102335.8d56dddd.khali@linux-fr.org>
In-Reply-To: <200702190105.31051.dtor@insightbb.com>
References: <20070218213020.5618eb98.khali@linux-fr.org>
	<200702190105.31051.dtor@insightbb.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Mon, 19 Feb 2007 01:05:30 -0500, Dmitry Torokhov wrote:
> On Sunday 18 February 2007 15:30, Jean Delvare wrote:
> > In platform_device_del(), we currently delete the device resources
> > first, then we delete the device itself. This causes a (minor) bug to
> > occur when one unregisters a platform device before unregistering its
> > platform driver, and the driver is requesting (in .probe()) and
> > releasing (in .remove()) a resource of the device. The device
> > resources are already gone by the time the driver gets the chance to
> > release the resources it had been requesting, causing an error like:
> > Trying to free nonexistent resource <0000000000000295-0000000000000296>
> > 
> > If the platform driver is unregistered first, the problem doesn't
> > occur, as the driver will have the opportunity to release the
> > resources it had requested before the device resources themselves are
> > released. It's a bit odd that unregistering the driver first or the
> > device first doesn't lead to the same result.
> 
> I am not sure that this is correct argument. Why does a driver request
> and release device's resources? "Higher power" has already requested 
> these resources for the device and this is not drivers task to free
> them.

My understanding is that, in the device driver model, devices _declare_
resources, and it's up to the drivers to actually request the ones they
wish to use. Looking at /proc/ioports, this hierarchy is quite visible.
And while not all platform drivers actually request their device's
resource, quite a few do (I counted 95 out of 228), so I'm definitely
not the only one thinking it is the right thing to do.

If the intent was that devices request the resources and the drivers
don't have to care, then a driver requesting a device's resource should
be returned an error. Instead, it works fine, which make me confident
that I got the idea right.

>       However you are right that we should not free resources until
> device is marked for deletion and driver's ->remove() method completes
> but I would not rely on surrounding code for keeping an extra reference
> and would just take one explicitely in platform_device_del().

You mean that you wouldn't trust the rest of the platform driver core,
which lives in the same source file, to do the right thing? That's
being too defensive IMHO, and I don't think we usually do that. Greg?

-- 
Jean Delvare
