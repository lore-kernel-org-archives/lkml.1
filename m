Return-Path: <linux-kernel-owner+w=401wt.eu-S1755097AbZKBOwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097AbZKBOwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 09:52:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbZKBOwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 09:52:10 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:59740 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754234AbZKBOwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 09:52:09 -0500
Date: Mon, 2 Nov 2009 14:51:39 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>
Cc: Antonio Ospite <ospite@studenti.unina.it>,
       linux-arm-kernel@lists.infradead.org, openezx-devel@lists.openezx.org,
       linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
       Daniel Ribeiro <drwyrm@gmail.com>, Mike Rapoport <mike@compulab.co.il>
Subject: Re: Using statically allocated memory for platform_data.
Message-ID: <20091102145139.GA20341@fluff.org.uk>
References: <20091102112316.16163f6a.ospite@studenti.unina.it>
 <20091102103940.GA25282@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091102103940.GA25282@pengutronix.de>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 11:39:40AM +0100, Uwe Kleine-K?nig wrote:
> Hello,
> 
> On Mon, Nov 02, 2009 at 11:23:16AM +0100, Antonio Ospite wrote:
> > Hi,
> > 
> > I noted that in some mfd drivers (drivers/mfd/ezx-pcap.c and
> > drivers/mfd/da903x.c) there is code like this:
> > 
> > static int __devinit pcap_add_subdev(struct pcap_chip *pcap,
> >                                      struct pcap_subdev *subdev)
> > {
> >         struct platform_device *pdev;
> > 
> >         pdev = platform_device_alloc(subdev->name, subdev->id);
> >         pdev->dev.parent = &pcap->spi->dev;
> >         pdev->dev.platform_data = subdev->platform_data;
> > 
> >         return platform_device_add(pdev);
> > }
> > 
> > Note the _direct_assignment_ of platform data; then in board init code
> > there are often global struct pointers passed as subdev platform data,
> > see arch/arm/mach-pxa/em-x270.c::em_x270_da9030_subdevs for instance.
> > 
> > In these cases, whenever the subdev platform device is unregistered,
> > the call to platform_device_release() tries to kfree the platform data,
> > and being it statically allocated memory this triggers a bug from SLAB:
> > 	kernel BUG at mm/slab.c:521!
> > In my case this prevented proper device poweroff.
> > 
> > The question: should these mfd drivers use platform_device_add_data()
> > which allocates dynamic memory for *a copy* of platform data? Is this
> > simple solution acceptable even if there will be more memory used?
> If you move the original data lives in .init there is no duplication.

they you can't modprobe devices after loading the kernel, so udev
autoload and the like become impossible.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
