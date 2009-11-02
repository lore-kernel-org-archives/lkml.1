Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbZKBPAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbZKBPAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 10:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbZKBPAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 10:00:09 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:43367 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755096AbZKBPAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 10:00:08 -0500
Date: Mon, 2 Nov 2009 15:00:11 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-arm-kernel@lists.infradead.org, openezx-devel@lists.openezx.org,
       linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
       Daniel Ribeiro <drwyrm@gmail.com>, Mike Rapoport <mike@compulab.co.il>
Subject: Re: Using statically allocated memory for platform_data.
Message-ID: <20091102150011.GB20341@fluff.org.uk>
References: <20091102112316.16163f6a.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091102112316.16163f6a.ospite@studenti.unina.it>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 11:23:16AM +0100, Antonio Ospite wrote:
> Hi,
> 
> I noted that in some mfd drivers (drivers/mfd/ezx-pcap.c and
> drivers/mfd/da903x.c) there is code like this:
> 
> static int __devinit pcap_add_subdev(struct pcap_chip *pcap,
>                                      struct pcap_subdev *subdev)
> {
>         struct platform_device *pdev;
> 
>         pdev = platform_device_alloc(subdev->name, subdev->id);
>         pdev->dev.parent = &pcap->spi->dev;
>         pdev->dev.platform_data = subdev->platform_data;
> 
>         return platform_device_add(pdev);
> }
> 
> Note the _direct_assignment_ of platform data; then in board init code
> there are often global struct pointers passed as subdev platform data,
> see arch/arm/mach-pxa/em-x270.c::em_x270_da9030_subdevs for instance.
> 
> In these cases, whenever the subdev platform device is unregistered,
> the call to platform_device_release() tries to kfree the platform data,
> and being it statically allocated memory this triggers a bug from SLAB:
> 	kernel BUG at mm/slab.c:521!
> In my case this prevented proper device poweroff.

This looks like something is freeing stuff that it did not allocate in
the first place, which is IMHO bad. The call platform_device_alloc()
is setting platform_device_release() as the default release function
but platform_device_release() releases more than platform_device_alloc()
actually created.

My view is that platform_device_alloc()'s default release shouldn't
be freeing the platform data, and that using platform_device_add_data()
or platform_device_add_resources() should change either the behvaiour 
of platform_device_release() or it should change the pointer to a new
release function.
 
> The question: should these mfd drivers use platform_device_add_data()
> which allocates dynamic memory for *a copy* of platform data? Is this
> simple solution acceptable even if there will be more memory used?
> Or should we setup platform_data in dynamic memory from the beginning
> in board init code? (which would be way less pretty IMHO).

On the s3c24xx, we copy the data when the device is registered by the
board as this allows the board's data to be specified __initdata and
still have things work with hotplug etc.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
