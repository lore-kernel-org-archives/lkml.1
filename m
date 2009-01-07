Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbZAGRYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbZAGRYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 12:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbZAGRX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 12:23:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:44927 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbZAGRX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 12:23:57 -0500
Date: Wed, 7 Jan 2009 09:25:55 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Yong Wang <yong.y.wang@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/6] fastboot: make ACPI bus drivers probe asynchronous
Message-ID: <20090107092555.6e89e9c7@infradead.org>
In-Reply-To: <20090107141256.GA22902@ywang-moblin2.bj.intel.com>
References: <20090105200959.04a626ac@infradead.org>
	<20090105201239.0784606e@infradead.org>
	<20090107141256.GA22902@ywang-moblin2.bj.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2009 22:12:56 +0800
Yong Wang <yong.y.wang@linux.intel.com> wrote:

> On Mon, Jan 05, 2009 at 08:12:39PM -0800, Arjan van de Ven wrote:
> > 
> > >From 34c47dd38f49e29eb7cd7fa2078efc6b8b258bb9 Mon Sep 17 00:00:00
> > >2001
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Date: Sun, 4 Jan 2009 05:32:28 -0800
> > Subject: [PATCH] fastboot: make ACPI bus drivers probe asynchronous
> > 
> > the various ACPI bus drivers have non-overlapping devices and can
> > each be run asynchronous. Some of the ACPI drivers (especially the
> > battery one, but others as well) can take quite a long time to
> > probe.
> > 
> > Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> > ---
> >  drivers/acpi/scan.c |   23 ++++++++++++++++-------
> >  1 files changed, 16 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> > index 39b7233..a9e542d 100644
> > --- a/drivers/acpi/scan.c
> > +++ b/drivers/acpi/scan.c
> > @@ -8,6 +8,7 @@
> >  #include <linux/acpi.h>
> >  #include <linux/signal.h>
> >  #include <linux/kthread.h>
> > +#include <linux/async.h>
> >  
> >  #include <acpi/acpi_drivers.h>
> >  #include <acpi/acinterp.h>	/* for
> > acpi_ex_eisa_id_to_string() */ @@ -578,6 +579,19 @@ static int
> > acpi_start_single_object(struct acpi_device *device) return result;
> >  }
> >  
> > +static void acpi_bus_register_async(void *data, async_cookie_t
> > cookie) +{
> > +	int ret;
> > +	struct acpi_driver *driver = data;
> > +	driver->drv.name = driver->name;
> > +	driver->drv.bus = &acpi_bus_type;
> > +	driver->drv.owner = driver->owner;
> > +
> > +	async_synchronize_cookie(cookie);
> > +
> > +	ret = driver_register(&driver->drv);
> > +	WARN_ON(ret != 0);
> > +}
> >  /**
> >   * acpi_bus_register_driver - register a driver with the ACPI bus
> >   * @driver: driver being registered
> > @@ -588,16 +602,11 @@ static int acpi_start_single_object(struct
> > acpi_device *device) */
> >  int acpi_bus_register_driver(struct acpi_driver *driver)
> >  {
> > -	int ret;
> >  
> >  	if (acpi_disabled)
> >  		return -ENODEV;
> > -	driver->drv.name = driver->name;
> > -	driver->drv.bus = &acpi_bus_type;
> > -	driver->drv.owner = driver->owner;
> > -
> > -	ret = driver_register(&driver->drv);
> > -	return ret;
> > +	async_schedule(acpi_bus_register_async, driver);
> > +	return 0;
> >  }
> >  
> >  EXPORT_SYMBOL(acpi_bus_register_driver);
> 
> For ACPI battery, button and thermal drivers whose init funtion
> immediately ends right after calling acpi_bus_register_driver, it
> might be OK. But for other drivers whose init function has more work
> to do and depends on acpi_bus_register_driver having *really* done
> its job, it is certainly not OK. In the latter case, the 'return 0'
> in acpi_bus_register_driver is effectively cheating those drivers
> that acpi_bus_register_driver has already done its job which is
> unfortunately not the case. Example drivers include eeepc_laptop and
> asus_laptop. At least I am seeing a kernel oops on eeepc because of
> that.

ok I've dropped the ACPI part for now; I'll work with you and Len to
see how we can solve the ACPI side, but for now it seems to have too
many issues

> 
> -Yong


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
