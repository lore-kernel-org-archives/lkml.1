Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbYCHVTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbYCHVTR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 16:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbYCHVTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 16:19:04 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46112 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751424AbYCHVTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 16:19:03 -0500
Subject: Re: [UPDATED v3][PATCH 4/7] regulator: framework core
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <20080308074116.GA20652@kroah.com>
References: <1204827115.15360.150.camel@a10323.wolfsonmicro.main>
	 <20080307161012.GC28439@kroah.com>
	 <1204928391.13653.27.camel@localhost.localdomain>
	 <20080308074116.GA20652@kroah.com>
Content-Type: text/plain
Date: Sat, 08 Mar 2008 21:18:59 +0000
Message-Id: <1205011139.13653.75.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-07 at 23:41 -0800, Greg KH wrote:
> On Fri, Mar 07, 2008 at 10:19:51PM +0000, Liam Girdwood wrote:
> > On Fri, 2008-03-07 at 08:10 -0800, Greg KH wrote:
> > > On Thu, Mar 06, 2008 at 06:11:54PM +0000, Liam Girdwood wrote:
> > 
> > > > +/**
> > > > + * struct regulator_cdev
> > > > + *
> > > > + * Voltage / Current regulator class device. One for each regulator.
> > > > + */
> > > > +struct regulator_cdev {
> > > > +	struct regulator_desc *desc;
> > > > +	int use_count;
> > > > +
> > > > +	struct list_head list;
> > > > +	struct list_head consumer_list;
> > > > +	struct blocking_notifier_head notifier;
> > > > +	struct mutex mutex; /* consumer lock */
> > > > +	struct module *owner;
> > > > +	struct class_device cdev;
> > > 
> > > Can you change this to use a "struct device" instead?  We are trying to
> > > get rid of class_device, and there are only 3 users of it in the kernel
> > > today (memorystick, infiniband, and scsi), and I have patches pending to
> > > fix all of these.  For 2.6.26 I would like to be rid of it finally.
> > > 
> > > If you want, I would be glad to fix this up for you, it should be a
> > > pretty simple replacement.
> > > 
> > 
> > Yes please. Much appreciated :)
> 
> Ok, it's below, on top of your patch series.  If you want me to merge it
> in, I can do that as well.  It's a bit big, as I renamed "cdev" to "dev"
> in your structure names and variable names as it isn't a class device
> anymore.

Thanks. I've now committed into Wolfson git. I'll give it a spin on real
hardware early next week and then send to Andrew.

> 
> > > > +	struct regulation_constraints *constraints;
> > > > +	struct regulator_cdev *parent;	/* for tree */
> > > 
> > > And if when you convert, you can get rid of this pointer, it would not
> > > be needed.
> > 
> > Fwiw, the regulator-parent relationship is established by the platform
> > code after the regulator driver has registered all the regulator
> > devices. I assume we can just device_move() to re-parent. 
> 
> Ick, no, just pass the parent into the regulator_register() function.
> Otherwise you will get some wierd uevents spit out (run udevmonitor to
> see what I mean.)  You should set up the parent linkage before you
> register the device with the driver core.

Sorry, I think the 'parent' naming is a little confusing. The device
parent would be set at register time and the 'supply' would be set later
during platform power config.

Liam

