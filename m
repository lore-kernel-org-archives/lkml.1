Return-Path: <linux-kernel-owner+w=401wt.eu-S1758449AbZF3XMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449AbZF3XMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755738AbZF3XL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:11:57 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:28967 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbZF3XLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:11:55 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] ACPI: reintroduce acpi_device_ops .shutdown method
Date: Tue, 30 Jun 2009 17:11:32 -0600
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-server; KDE/4.2.2; x86_64; ; )
Cc: David =?iso-8859-1?q?H=E4rdeman?= <david@hardeman.nu>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-input@vger.kernel.org, jbarnes@virtuousgeek.org,
       Len Brown <lenb@kernel.org>
References: <1246079912-17619-1-git-send-email-david@hardeman.nu> <1246079912-17619-2-git-send-email-david@hardeman.nu> <20090630141047.c8c79b0b.akpm@linux-foundation.org>
In-Reply-To: <20090630141047.c8c79b0b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906301711.34074.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 June 2009 3:10:47 pm Andrew Morton wrote:
> On Sat, 27 Jun 2009 07:18:31 +0200
> David H__rdeman <david@hardeman.nu> wrote:
> 
> > This reintroduces the .shutdown method which is used by the
> > winbond-cir driver. A normal revert wasn't possible since there
> > had been other changes to include/acpi/acpi_bus.h since.
> > 
> > Signed-off-by: David H__rdeman <david@hardeman.nu>
> > ---
> >  drivers/acpi/scan.c     |   12 ++++++++++++
> >  include/acpi/acpi_bus.h |    2 ++
> >  2 files changed, 14 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> > index 781435d..c94ab13 100644
> > --- a/drivers/acpi/scan.c
> > +++ b/drivers/acpi/scan.c
> > @@ -464,10 +464,22 @@ static int acpi_device_remove(struct device * dev)
> >  	return 0;
> >  }
> >  
> > +static void acpi_device_shutdown(struct device *dev)
> > +{
> > +	struct acpi_device *acpi_dev = to_acpi_device(dev);
> > +	struct acpi_driver *acpi_drv = acpi_dev->driver;
> > +
> > +	if (acpi_drv && acpi_drv->ops.shutdown)
> > +		acpi_drv->ops.shutdown(acpi_dev);
> > +
> > +	return ;
> > +}
> > +
> >  struct bus_type acpi_bus_type = {
> >  	.name		= "acpi",
> >  	.suspend	= acpi_device_suspend,
> >  	.resume		= acpi_device_resume,
> > +	.shutdown	= acpi_device_shutdown,
> >  	.match		= acpi_bus_match,
> >  	.probe		= acpi_device_probe,
> >  	.remove		= acpi_device_remove,
> > diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> > index c65e4ce..52da89a 100644
> > --- a/include/acpi/acpi_bus.h
> > +++ b/include/acpi/acpi_bus.h
> > @@ -96,6 +96,7 @@ typedef int (*acpi_op_resume) (struct acpi_device * device);
> >  typedef int (*acpi_op_bind) (struct acpi_device * device);
> >  typedef int (*acpi_op_unbind) (struct acpi_device * device);
> >  typedef void (*acpi_op_notify) (struct acpi_device * device, u32 event);
> > +typedef int (*acpi_op_shutdown) (struct acpi_device * device);
> >  
> >  struct acpi_bus_ops {
> >  	u32 acpi_op_add:1;
> > @@ -112,6 +113,7 @@ struct acpi_device_ops {
> >  	acpi_op_bind bind;
> >  	acpi_op_unbind unbind;
> >  	acpi_op_notify notify;
> > +	acpi_op_shutdown shutdown;
> >  };
> >  
> >  #define ACPI_DRIVER_ALL_NOTIFY_EVENTS	0x1	/* system AND device events */
> 
> Len, Bjorn: is this OK?  Or is there some other mechanism which the
> driver should have used?

I'm on vacation and don't have time to read the new winbond driver
right now, but maybe it could be changed so that wbcir_shutdown()
is an internal function called by wbcir_suspend() (as it is already)
and wbcir_remove().

I hate to re-introduce .shutdown when it's only used by a single
driver.  That makes me think either we have a bunch of drivers that
are buggy because they *should* have .shutdown methods but don't,
or the single user of .shutdown doesn't have a real dependency on it.

The winbond driver does not use any ACPI-specific functionality, so
it might be simpler to write it as a PNP driver (which would depend
on PNPACPI, of course).

Nice looking driver, by the way.  Even from a cursory glance it's
obvious that you've taken a lot of care with it.

Bjorn
