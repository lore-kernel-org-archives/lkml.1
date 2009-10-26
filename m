Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbZJZUqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbZJZUqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 16:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbZJZUqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 16:46:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:47800 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754042AbZJZUqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 16:46:10 -0400
From: Thomas Renninger <trenn@suse.de>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH 4/8] SGI x86_64 UV: Limit the number of ACPI messages
Date: Mon, 26 Oct 2009 23:47:43 +0100
User-Agent: KMail/1.9.10
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, Zhang Rui <rui.zhang@intel.com>,
       Len Brown <lenb@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Myron Stowe <myron.stowe@hp.com>, Feng Tang <feng.tang@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20091023233743.439628000@alcatraz.americas.sgi.com> <20091023233754.668088000@alcatraz.americas.sgi.com> <1256354987.17875.6.camel@dc7800.home>
In-Reply-To: <1256354987.17875.6.camel@dc7800.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910262347.46292.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 October 2009 05:29:47 am Bjorn Helgaas wrote:
> On Fri, 2009-10-23 at 18:37 -0500, Mike Travis wrote:
> > plain text document attachment (limit_acpi)
> > Limit number of ACPI messages of the form:
> >
> > [    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00]
> > lsapic_eid[0x00] enabled)
> >
> > [   99.638655] processor ACPI0007:00: registered as cooling_device0
> >
> > Cc: Zhang Rui <rui.zhang@intel.com>
> > Cc: Len Brown <lenb@kernel.org>
> > Cc: Thomas Renninger <trenn@suse.de>
> > Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
> > Cc: Alexey Dobriyan <adobriyan@gmail.com>
> > Cc: Myron Stowe <myron.stowe@hp.com>
> > Cc: Feng Tang <feng.tang@intel.com>
> > Cc: Suresh Siddha <suresh.b.siddha@intel.com>
> > Cc: Yinghai Lu <yhlu.kernel@gmail.com>
> > Cc: linux-acpi@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Mike Travis <travis@sgi.com>
> > ---
> >  drivers/acpi/fan.c            |    7 ++++++-
> >  drivers/acpi/processor_core.c |    8 ++++++--
> >  drivers/acpi/tables.c         |   15 ++++++++++-----
> >  3 files changed, 22 insertions(+), 8 deletions(-)
> >
> > --- linux.orig/drivers/acpi/fan.c
> > +++ linux/drivers/acpi/fan.c
> > @@ -243,6 +243,7 @@
> >  	int result = 0;
> >  	int state = 0;
> >  	struct thermal_cooling_device *cdev;
> > +	static int msgcnt;
> >
> >  	if (!device)
> >  		return -EINVAL;
> > @@ -267,7 +268,11 @@
> >  		goto end;
> >  	}
> >
> > -	dev_info(&device->dev, "registered as cooling_device%d\n", cdev->id);
> > +	if (msgcnt < 4 || !limit_console_output(false)) {
> > +		dev_info(&device->dev,
> > +			"registered as cooling_device%d\n", cdev->id);
> > +		msgcnt++;
> > +	}
>
> I'm personally not in favor of printing some, but not all, of these
> messages.  That leads to questions when analyzing a dmesg log, such as
> "Hmm, I see I have 64 CPUs, but only 0-3 are registered as cooling
> devices.  Does that mean something is wrong?"
>
> But I would be glad to see this particular message removed completely.
>
> >  	device->driver_data = cdev;
> >  	result = sysfs_create_link(&device->dev.kobj,
> > --- linux.orig/drivers/acpi/processor_core.c
> > +++ linux/drivers/acpi/processor_core.c
> > @@ -775,6 +775,7 @@
> >  	struct acpi_processor *pr = NULL;
> >  	int result = 0;
> >  	struct sys_device *sysdev;
> > +	static int msgcnt;
> >
> >  	pr = kzalloc(sizeof(struct acpi_processor), GFP_KERNEL);
> >  	if (!pr)
> > @@ -845,8 +846,11 @@
> >  		goto err_power_exit;
> >  	}
> >
> > -	dev_info(&device->dev, "registered as cooling_device%d\n",
> > -		 pr->cdev->id);
> > +	if (msgcnt < 4 || !limit_console_output(false)) {
> > +		dev_info(&device->dev, "registered as cooling_device%d\n",
> > +			 pr->cdev->id);
> > +		msgcnt++;
> > +	}
If Zhang Rui does not complain you can change these:
..registered as cooling_device..
into dev_dbg() without any condition.
This isn't critical.

Or why not use the more fine grained
ACPI debug facility and change it into:
ACPI_DEBUG_PRINT((ACPI_DB_INFO "..."));
(compare with Documentation/acpi/debug.txt and other
occurences in the same file)
You have to pass:
acpi_dbg_layer=0x20000000
to see it then.
> >
> >  	result = sysfs_create_link(&device->dev.kobj,
> >  				   &pr->cdev->device.kobj,
> > --- linux.orig/drivers/acpi/tables.c
> > +++ linux/drivers/acpi/tables.c
> > @@ -170,11 +170,16 @@
> >  	case ACPI_MADT_TYPE_LOCAL_SAPIC:
> >  		{
> >  			struct acpi_madt_local_sapic *p =
> > -			    (struct acpi_madt_local_sapic *)header;
> > -			printk(KERN_INFO PREFIX
> > -			       "LSAPIC (acpi_id[0x%02x] lsapic_id[0x%02x] lsapic_eid[0x%02x]
> > %s)\n", -			       p->processor_id, p->id, p->eid,
> > -			       (p->lapic_flags & ACPI_MADT_ENABLED) ? "enabled" :
> > "disabled"); +				(struct acpi_madt_local_sapic *)header;
> > +
> > +			if (p->eid < 8 || !limit_console_output(false))
I can't find limit_console_output(), I expect it got introduced by another one 
of your patch series, not send to the acpi list?
Still shouldn't this be:
limit_console_output(true)
instead of:
!limit_console_output(false)

       Thomas

> > +				printk(KERN_INFO PREFIX
> > +					"LSAPIC (acpi_id[0x%02x] "
> > +						"lsapic_id[0x%02x] "
> > +						"lsapic_eid[0x%02x] %s)\n",
> > +					p->processor_id, p->id, p->eid,
> > +					(p->lapic_flags & ACPI_MADT_ENABLED) ?
> > +						"enabled" : "disabled");
>
> I know we print way too much stuff for every processor, but again, I'd
> rather see all CPUs or none.  I think there's a little more value in
> this one than the cooling device one (probably because I do a lot of
> platform bringup), but it could certainly be made KERN_DEBUG and/or
> combined with another processor discovery line.

