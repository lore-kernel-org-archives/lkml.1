Return-Path: <linux-kernel-owner+w=401wt.eu-S1752800AbZJZSPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbZJZSPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 14:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbZJZSPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 14:15:09 -0400
Received: from relay3.sgi.com ([192.48.152.1]:56604 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752506AbZJZSPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 14:15:07 -0400
Message-ID: <4AE5E72E.1020702@sgi.com>
Date: Mon, 26 Oct 2009 11:15:10 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, Zhang Rui <rui.zhang@intel.com>,
       Len Brown <lenb@kernel.org>, Thomas Renninger <trenn@suse.de>,
       Alexey Dobriyan <adobriyan@gmail.com>, Myron Stowe <myron.stowe@hp.com>,
       Feng Tang <feng.tang@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] SGI x86_64 UV: Limit the number of ACPI messages
References: <20091023233743.439628000@alcatraz.americas.sgi.com>	 <20091023233754.668088000@alcatraz.americas.sgi.com> <1256354987.17875.6.camel@dc7800.home>
In-Reply-To: <1256354987.17875.6.camel@dc7800.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Bjorn Helgaas wrote:
> On Fri, 2009-10-23 at 18:37 -0500, Mike Travis wrote:
>> plain text document attachment (limit_acpi)
>> Limit number of ACPI messages of the form:
>>
>> [    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x00] enabled)
>>
>> [   99.638655] processor ACPI0007:00: registered as cooling_device0
>>
>> Cc: Zhang Rui <rui.zhang@intel.com>
>> Cc: Len Brown <lenb@kernel.org>
>> Cc: Thomas Renninger <trenn@suse.de>
>> Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
>> Cc: Alexey Dobriyan <adobriyan@gmail.com>
>> Cc: Myron Stowe <myron.stowe@hp.com>
>> Cc: Feng Tang <feng.tang@intel.com>
>> Cc: Suresh Siddha <suresh.b.siddha@intel.com>
>> Cc: Yinghai Lu <yhlu.kernel@gmail.com>
>> Cc: linux-acpi@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Mike Travis <travis@sgi.com>
>> ---
>>  drivers/acpi/fan.c            |    7 ++++++-
>>  drivers/acpi/processor_core.c |    8 ++++++--
>>  drivers/acpi/tables.c         |   15 ++++++++++-----
>>  3 files changed, 22 insertions(+), 8 deletions(-)
>>
>> --- linux.orig/drivers/acpi/fan.c
>> +++ linux/drivers/acpi/fan.c
>> @@ -243,6 +243,7 @@
>>  	int result = 0;
>>  	int state = 0;
>>  	struct thermal_cooling_device *cdev;
>> +	static int msgcnt;
>>  
>>  	if (!device)
>>  		return -EINVAL;
>> @@ -267,7 +268,11 @@
>>  		goto end;
>>  	}
>>  
>> -	dev_info(&device->dev, "registered as cooling_device%d\n", cdev->id);
>> +	if (msgcnt < 4 || !limit_console_output(false)) {
>> +		dev_info(&device->dev,
>> +			"registered as cooling_device%d\n", cdev->id);
>> +		msgcnt++;
>> +	}
> 
> I'm personally not in favor of printing some, but not all, of these
> messages.  That leads to questions when analyzing a dmesg log, such as
> "Hmm, I see I have 64 CPUs, but only 0-3 are registered as cooling
> devices.  Does that mean something is wrong?"
> 
> But I would be glad to see this particular message removed completely.

I didn't want to make the decision to remove messages as the original
authors might have very good reasons for including them.

Note that the dmesg log (kernel log buffer) still does have every one of
the messages, only the prints to the console output (which usually is a
serial connection [or IPMI] on servers) are limited.

> 
>>  	device->driver_data = cdev;
>>  	result = sysfs_create_link(&device->dev.kobj,
>> --- linux.orig/drivers/acpi/processor_core.c
>> +++ linux/drivers/acpi/processor_core.c
>> @@ -775,6 +775,7 @@
>>  	struct acpi_processor *pr = NULL;
>>  	int result = 0;
>>  	struct sys_device *sysdev;
>> +	static int msgcnt;
>>  
>>  	pr = kzalloc(sizeof(struct acpi_processor), GFP_KERNEL);
>>  	if (!pr)
>> @@ -845,8 +846,11 @@
>>  		goto err_power_exit;
>>  	}
>>  
>> -	dev_info(&device->dev, "registered as cooling_device%d\n",
>> -		 pr->cdev->id);
>> +	if (msgcnt < 4 || !limit_console_output(false)) {
>> +		dev_info(&device->dev, "registered as cooling_device%d\n",
>> +			 pr->cdev->id);
>> +		msgcnt++;
>> +	}
>>  
>>  	result = sysfs_create_link(&device->dev.kobj,
>>  				   &pr->cdev->device.kobj,
>> --- linux.orig/drivers/acpi/tables.c
>> +++ linux/drivers/acpi/tables.c
>> @@ -170,11 +170,16 @@
>>  	case ACPI_MADT_TYPE_LOCAL_SAPIC:
>>  		{
>>  			struct acpi_madt_local_sapic *p =
>> -			    (struct acpi_madt_local_sapic *)header;
>> -			printk(KERN_INFO PREFIX
>> -			       "LSAPIC (acpi_id[0x%02x] lsapic_id[0x%02x] lsapic_eid[0x%02x] %s)\n",
>> -			       p->processor_id, p->id, p->eid,
>> -			       (p->lapic_flags & ACPI_MADT_ENABLED) ? "enabled" : "disabled");
>> +				(struct acpi_madt_local_sapic *)header;
>> +
>> +			if (p->eid < 8 || !limit_console_output(false))
>> +				printk(KERN_INFO PREFIX
>> +					"LSAPIC (acpi_id[0x%02x] "
>> +						"lsapic_id[0x%02x] "
>> +						"lsapic_eid[0x%02x] %s)\n",
>> +					p->processor_id, p->id, p->eid,
>> +					(p->lapic_flags & ACPI_MADT_ENABLED) ?
>> +						"enabled" : "disabled");
> 
> I know we print way too much stuff for every processor, but again, I'd
> rather see all CPUs or none.  I think there's a little more value in
> this one than the cooling device one (probably because I do a lot of
> platform bringup), but it could certainly be made KERN_DEBUG and/or
> combined with another processor discovery line.

This was the major reason why I left the default as it currently is, and
made it a startup option that a site can choose to use or not.

The intent of printing a few messages was to give context to the last line
in this sequence:

[   99.638655] processor ACPI0007:00: registered as cooling_device0
[   99.648277] processor ACPI0007:01: registered as cooling_device1
[   99.657976] processor ACPI0007:02: registered as cooling_device2
[   99.667229] processor ACPI0007:03: registered as cooling_device3
[   99.676517] printk: further related messages suppressed

Thanks,
Mike

> 
> Bjorn
> 
>>  		}
>>  		break;
>>  
>>
