Return-Path: <linux-kernel-owner+w=401wt.eu-S1752210AbZJXDd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbZJXDd1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 23:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbZJXDd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 23:33:26 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:4860 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbZJXDdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 23:33:25 -0400
Subject: Re: [PATCH 4/8] SGI x86_64 UV: Limit the number of ACPI messages
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, Zhang Rui <rui.zhang@intel.com>,
       Len Brown <lenb@kernel.org>, Thomas Renninger <trenn@suse.de>,
       Alexey Dobriyan <adobriyan@gmail.com>, Myron Stowe <myron.stowe@hp.com>,
       Feng Tang <feng.tang@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091023233754.668088000@alcatraz.americas.sgi.com>
References: <20091023233743.439628000@alcatraz.americas.sgi.com>
	 <20091023233754.668088000@alcatraz.americas.sgi.com>
Content-Type: text/plain
Date: Fri, 23 Oct 2009 21:29:47 -0600
Message-Id: <1256354987.17875.6.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-23 at 18:37 -0500, Mike Travis wrote:
> plain text document attachment (limit_acpi)
> Limit number of ACPI messages of the form:
> 
> [    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x00] enabled)
> 
> [   99.638655] processor ACPI0007:00: registered as cooling_device0
> 
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Thomas Renninger <trenn@suse.de>
> Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: Myron Stowe <myron.stowe@hp.com>
> Cc: Feng Tang <feng.tang@intel.com>
> Cc: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: Yinghai Lu <yhlu.kernel@gmail.com>
> Cc: linux-acpi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Mike Travis <travis@sgi.com>
> ---
>  drivers/acpi/fan.c            |    7 ++++++-
>  drivers/acpi/processor_core.c |    8 ++++++--
>  drivers/acpi/tables.c         |   15 ++++++++++-----
>  3 files changed, 22 insertions(+), 8 deletions(-)
> 
> --- linux.orig/drivers/acpi/fan.c
> +++ linux/drivers/acpi/fan.c
> @@ -243,6 +243,7 @@
>  	int result = 0;
>  	int state = 0;
>  	struct thermal_cooling_device *cdev;
> +	static int msgcnt;
>  
>  	if (!device)
>  		return -EINVAL;
> @@ -267,7 +268,11 @@
>  		goto end;
>  	}
>  
> -	dev_info(&device->dev, "registered as cooling_device%d\n", cdev->id);
> +	if (msgcnt < 4 || !limit_console_output(false)) {
> +		dev_info(&device->dev,
> +			"registered as cooling_device%d\n", cdev->id);
> +		msgcnt++;
> +	}

I'm personally not in favor of printing some, but not all, of these
messages.  That leads to questions when analyzing a dmesg log, such as
"Hmm, I see I have 64 CPUs, but only 0-3 are registered as cooling
devices.  Does that mean something is wrong?"

But I would be glad to see this particular message removed completely.

>  	device->driver_data = cdev;
>  	result = sysfs_create_link(&device->dev.kobj,
> --- linux.orig/drivers/acpi/processor_core.c
> +++ linux/drivers/acpi/processor_core.c
> @@ -775,6 +775,7 @@
>  	struct acpi_processor *pr = NULL;
>  	int result = 0;
>  	struct sys_device *sysdev;
> +	static int msgcnt;
>  
>  	pr = kzalloc(sizeof(struct acpi_processor), GFP_KERNEL);
>  	if (!pr)
> @@ -845,8 +846,11 @@
>  		goto err_power_exit;
>  	}
>  
> -	dev_info(&device->dev, "registered as cooling_device%d\n",
> -		 pr->cdev->id);
> +	if (msgcnt < 4 || !limit_console_output(false)) {
> +		dev_info(&device->dev, "registered as cooling_device%d\n",
> +			 pr->cdev->id);
> +		msgcnt++;
> +	}
>  
>  	result = sysfs_create_link(&device->dev.kobj,
>  				   &pr->cdev->device.kobj,
> --- linux.orig/drivers/acpi/tables.c
> +++ linux/drivers/acpi/tables.c
> @@ -170,11 +170,16 @@
>  	case ACPI_MADT_TYPE_LOCAL_SAPIC:
>  		{
>  			struct acpi_madt_local_sapic *p =
> -			    (struct acpi_madt_local_sapic *)header;
> -			printk(KERN_INFO PREFIX
> -			       "LSAPIC (acpi_id[0x%02x] lsapic_id[0x%02x] lsapic_eid[0x%02x] %s)\n",
> -			       p->processor_id, p->id, p->eid,
> -			       (p->lapic_flags & ACPI_MADT_ENABLED) ? "enabled" : "disabled");
> +				(struct acpi_madt_local_sapic *)header;
> +
> +			if (p->eid < 8 || !limit_console_output(false))
> +				printk(KERN_INFO PREFIX
> +					"LSAPIC (acpi_id[0x%02x] "
> +						"lsapic_id[0x%02x] "
> +						"lsapic_eid[0x%02x] %s)\n",
> +					p->processor_id, p->id, p->eid,
> +					(p->lapic_flags & ACPI_MADT_ENABLED) ?
> +						"enabled" : "disabled");

I know we print way too much stuff for every processor, but again, I'd
rather see all CPUs or none.  I think there's a little more value in
this one than the cooling device one (probably because I do a lot of
platform bringup), but it could certainly be made KERN_DEBUG and/or
combined with another processor discovery line.

Bjorn

>  		}
>  		break;
>  
> 

