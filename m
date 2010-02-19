Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab0BSLCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 06:02:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40721 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034Ab0BSLCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 06:02:31 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] drivers: acpi: fan.c move a dereference below the NULL test
Date: Fri, 19 Feb 2010 12:02:28 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32.1-0.0.14.f17927a-desktop; KDE/4.3.1; x86_64; ; )
Cc: Darren Jenkins <darrenrjenkins@gmail.com>, Zhang Rui <rui.zhang@intel.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Matthew Garrett <mjg@redhat.com>,
       linux ACPI <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>
References: <1265882202.27789.0.camel@ICE-BOX> <alpine.LFD.2.00.1002190026070.17638@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002190026070.17638@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002191202.28792.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 February 2010 06:27:46 Len Brown wrote:
> I think think this is a run-time check for a programming error,
> and the current fashion is to delete the check and take a fault
> if this happens so the caller can be fixed.
> 
> There are a couple of checks like this in fan.c --
> perhaps Rui can clean them up when he comes back next week.
Please let us clean this up first and remove:
static inline void *acpi_driver_data(struct acpi_device *d)
{
        return d->driver_data;
}
This has nothing to do with acpica code, it's in kernel code only.
Is there a reason for above abstraction?
If not, it's error prone and really should get eliminated.

    Thomas

> thanks,
> Len Brown, Intel Open Source Technology Center
> 
> On Thu, 11 Feb 2010, Darren Jenkins wrote:
> 
> > In acpi_fan_remove() device is being dereferenced before the NULL 
test.
> > This reorders the code to ensure it is checked for NULL first.
> > 
> > Coverity CID: 2758
> > 
> > Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
> > ---
> >  drivers/acpi/fan.c |    9 +++++++--
> >  1 files changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
> > index acf2ab2..dc39640 100644
> > --- a/drivers/acpi/fan.c
> > +++ b/drivers/acpi/fan.c
> > @@ -298,9 +298,14 @@ static int acpi_fan_add(struct acpi_device 
*device)
> >  
> >  static int acpi_fan_remove(struct acpi_device *device, int type)
> >  {
> > -	struct thermal_cooling_device *cdev = acpi_driver_data(device);
> > +	struct thermal_cooling_device *cdev;
> > +
> > +	if (!device)
> > +		return -EINVAL;
> > +
> > +	cdev = acpi_driver_data(device);
> >  
> > -	if (!device || !cdev)
> > +	if (!cdev)
> >  		return -EINVAL;
> >  
> >  	acpi_fan_remove_fs(device);
> > -- 
> > 1.6.3.3
> > 
> > 
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> 

