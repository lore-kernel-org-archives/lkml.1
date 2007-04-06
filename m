Return-Path: <linux-kernel-owner+w=401wt.eu-S932943AbXDFPng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943AbXDFPng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 11:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932953AbXDFPng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 11:43:36 -0400
Received: from smtp105.sbc.mail.mud.yahoo.com ([68.142.198.204]:32089 "HELO
	smtp105.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932900AbXDFPne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 11:43:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=sMaCtKIPl7jqDd714/Z2Mt0oqC3oN6YJLM8TqhAiQcflwq+gB+mNLXFXvlUc6PfF3vW8RhDDadzuOxv+LC58BKDpSiXvqMQ/cTDx7qToAX91z8sAyBOj24I/hXY0G+ZWSCl4SFtB6CRE2w4jNR6S8EKP8LGUZ823xVhrUxAihT0=  ;
X-YMail-OSG: OPQ3VGUVM1muE_POSSfUq.vYMn8LK_zPwJySxEgUTlO2dYFUVIWX.E95ZzPSt8OpZdbNdDaXYQ--
From: David Brownell <david-b@pacbell.net>
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [patch 2.6.21-rc5-git] make /proc/acpi/wakeup more useful
Date: Fri, 6 Apr 2007 08:43:30 -0700
User-Agent: KMail/1.7.1
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       lenb@kernel.org, "linux-acpi@vger" <linux-acpi@vger.kernel.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
References: <200704031741.42273.david-b@pacbell.net> <200704050358.43689.david-b@pacbell.net> <1175852213.2650.4.camel@localhost.localdomain>
In-Reply-To: <1175852213.2650.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704060843.30723.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 April 2007 2:36 am, Zhang Rui wrote:
> On Thu, 2007-04-05 at 03:58 -0700, David Brownell wrote: 
> > 
> > For wakeup devices, the main issue I've seen is with button devices.
> > In my limited set of test sytems, everything else is either PCI, PNP,
> > or a bug (listing a non-existent device).
>
> There may be other wakeup-enabled devices like legacy serial,
> PS2 devices described in ACPI name space.

Do you mean they wouldn't be listed in /proc/acpi/wakeup though?

Or just that they wouldn't be listed as PNP devices (like the button
devices)?  That seems buglike.  Not that BIOS bugs are so rare; and
I sure wouldn't know which types are common...

Because that example file certainly included UART and PS2 devices,
which were listed both as PNP devices and as ACPI devices.


> > If this patch starts to get deployed, I expect other people will find
> > a few other curiousities ... and likely some things to be fixed.
> 
> > The /sys/devices/acpi_system:00/ tree is kind of new.  I suspect one
> > way it could be more informative is to set up cross-links in sysfs
> > between the ACPI devices and the "real" device nodes ... e.g. on the
> > system I'm using right now .../device:00/PNP0A03:00/device:15/PNP0B00:00
> > could have a link pointing to /sys/devices/pnp0/00:06 ... and that PNP
> > node in turn could have an "acpi" link pointing back to the ACPI thing.
> > 
> > Such cross-links would let people see those relationships, and observe
> > which links are missing or otherwise strange.  Fixing the bugs would
> > seem unlikely until those things become visible.
>
> Sounds nice.
> The patch below should make sense.

Yeah, that's the idea.  Let's see if it's any good.  :)

I'd just call it "acpi_node" not "ACPI_node" (NO POINT IN SHOUTING),
and might not even use the "_node" suffix.

I cc'd Greg, who's our resident (or is that itinerant?) sysfs guru,
in case he has comments on this issue.

This applied over the "ACPI driver model flags and platform_enable_wake()"
patch with a bit of fuzz, on RC6.

- Dave


> Add cross-links between ACPI device and "real" devices in sysfs.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com> 
> ---
>  drivers/acpi/glue.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+)
> 
> Index: linux-2.6.21-rc5/drivers/acpi/glue.c
> ===================================================================
> --- linux-2.6.21-rc5.orig/drivers/acpi/glue.c	2007-04-06 16:06:04.000000000 +0800
> +++ linux-2.6.21-rc5/drivers/acpi/glue.c	2007-04-06 17:32:40.000000000 +0800
> @@ -147,6 +147,7 @@ EXPORT_SYMBOL(acpi_get_physical_device);
>  static int acpi_bind_one(struct device *dev, acpi_handle handle)
>  {
>  	acpi_status status;
> +	struct acpi_device *acpi_dev;
>  
>  	if (dev->archdata.acpi_handle) {
>  		printk(KERN_WARNING PREFIX
> @@ -161,16 +162,29 @@ static int acpi_bind_one(struct device *
>  	}
>  	dev->archdata.acpi_handle = handle;
>  
> +	if (!acpi_bus_get_device(handle, &acpi_dev)) {
> +		sysfs_create_link(&dev->kobj, &acpi_dev->dev.kobj, "ACPI_node");
> +		sysfs_create_link(&acpi_dev->dev.kobj, &dev->kobj, "physical_node");
> +	}
> +
>  	return 0;
>  }
>  
>  static int acpi_unbind_one(struct device *dev)
>  {
> +	struct acpi_device *acpi_dev;
> +
>  	if (!dev->archdata.acpi_handle)
>  		return 0;
>  	if (dev == acpi_get_physical_device(dev->archdata.acpi_handle)) {
>  		/* acpi_get_physical_device increase refcnt by one */
>  		put_device(dev);
> +
> +		if (!acpi_bus_get_device(dev->archdata.acpi_handle, &acpi_dev)) {
> +			sysfs_remove_link(&dev->kobj, "ACPI_node");
> +			sysfs_remove_link(&acpi_dev->dev.kobj, "physical_node");
> +		}
> +
>  		acpi_detach_data(dev->archdata.acpi_handle,
>  				 acpi_glue_data_handler);
>  		dev->archdata.acpi_handle = NULL;
> 
