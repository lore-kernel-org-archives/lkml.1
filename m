Return-Path: <linux-kernel-owner+w=401wt.eu-S1754430AbZKLVC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbZKLVC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 16:02:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754178AbZKLVCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 16:02:54 -0500
Received: from smtp-out.google.com ([216.239.45.13]:56907 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbZKLVCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 16:02:53 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=hkhuaZi23MHVJ/DEFJ0PcwKFxlFh43HxHlrSe4F+eHsnqxXUNrzPsoK47Tm5Ed6JA
	KBh6SYn7RZ9AGi7QWIfzA==
Date: Thu, 12 Nov 2009 13:02:39 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mike Travis <travis@sgi.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] ACPI: Limit the number of per cpu ACPI bootup
 messages
In-Reply-To: <20091112171949.218777000@alcatraz.americas.sgi.com>
Message-ID: <alpine.DEB.2.00.0911121259260.13943@chino.kir.corp.google.com>
References: <20091112171934.584037000@alcatraz.americas.sgi.com> <20091112171949.218777000@alcatraz.americas.sgi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009, Mike Travis wrote:

> Limit the number of per cpu ACPI messages when system is booting to
> prevent clogging up the console output with repetitious messages.
> 

... "by changing the log level from KERN_INFO to KERN_DEBUG."

> Signed-off-by: Mike Travis <travis@sgi.com>
> ---
>  drivers/acpi/fan.c            |    2 +-
>  drivers/acpi/processor_core.c |    2 +-
>  drivers/acpi/tables.c         |   28 +++++++++++++++++++---------
>  3 files changed, 21 insertions(+), 11 deletions(-)
> 
> --- linux.orig/drivers/acpi/fan.c
> +++ linux/drivers/acpi/fan.c
> @@ -267,7 +267,7 @@
>  		goto end;
>  	}
>  
> -	dev_info(&device->dev, "registered as cooling_device%d\n", cdev->id);
> +	dev_dbg(&device->dev, "registered as cooling_device%d\n", cdev->id);
>  
>  	device->driver_data = cdev;
>  	result = sysfs_create_link(&device->dev.kobj,
> --- linux.orig/drivers/acpi/processor_core.c
> +++ linux/drivers/acpi/processor_core.c
> @@ -845,7 +845,7 @@
>  		goto err_power_exit;
>  	}
>  
> -	dev_info(&device->dev, "registered as cooling_device%d\n",
> +	dev_dbg(&device->dev, "registered as cooling_device%d\n",
>  		 pr->cdev->id);
>  
>  	result = sysfs_create_link(&device->dev.kobj,
> --- linux.orig/drivers/acpi/tables.c
> +++ linux/drivers/acpi/tables.c
> @@ -66,11 +66,15 @@
>  		{
>  			struct acpi_madt_local_x2apic *p =
>  			    (struct acpi_madt_local_x2apic *)header;
> -			printk(KERN_INFO PREFIX
> -			       "X2APIC (apic_id[0x%02x] uid[0x%02x] %s)\n",
> -			       p->local_apic_id, p->uid,
> -			       (p->lapic_flags & ACPI_MADT_ENABLED) ?
> -			       "enabled" : "disabled");
> +			/*
> +			 * Per cpu tracing clogs console output when NR_CPUS
> +			 * is large.  Send only to kernel log buffer.
> +			 */
> +			printk(KERN_DEBUG PREFIX
> +				"X2APIC (apic_id[0x%02x] uid[0x%02x] %s)\n",
> +				p->local_apic_id, p->uid,
> +				(p->lapic_flags & ACPI_MADT_ENABLED) ?
> +					"enabled" : "disabled");
>  		}
>  		break;
>  

You can still use dev_dbg(PREFIX "...") here.

> @@ -171,10 +175,16 @@
>  		{
>  			struct acpi_madt_local_sapic *p =
>  			    (struct acpi_madt_local_sapic *)header;
> -			printk(KERN_INFO PREFIX
> -			       "LSAPIC (acpi_id[0x%02x] lsapic_id[0x%02x] lsapic_eid[0x%02x] %s)\n",
> -			       p->processor_id, p->id, p->eid,
> -			       (p->lapic_flags & ACPI_MADT_ENABLED) ? "enabled" : "disabled");
> +			/*
> +			 * Per cpu tracing clogs console output when NR_CPUS
> +			 * is large.  Send only to kernel log buffer.
> +			 */
> +			printk(KERN_DEBUG PREFIX
> +				"LSAPIC (acpi_id[0x%02x] lsapic_id[0x%02x] "
> +				"lsapic_eid[0x%02x] %s)\n",
> +				p->processor_id, p->id, p->eid,
> +				(p->lapic_flags & ACPI_MADT_ENABLED) ?
> +					"enabled" : "disabled");
>  		}
>  		break;
>  

Likewise, but recent emails from Linus indicate that we don't want to 
break printk strings into multiple lines even if it goes over 80 
characters unless broken at '\n'.  Users who grep for 
"lsapic_id.*lsapic_eid" with this patch wouldn't find the string.
