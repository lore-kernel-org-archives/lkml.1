Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbZKLVTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbZKLVTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 16:19:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754608AbZKLVTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 16:19:07 -0500
Received: from relay1.sgi.com ([192.48.179.29]:35321 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754525AbZKLVTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 16:19:06 -0500
Message-ID: <4AFC7BCA.3070705@sgi.com>
Date: Thu, 12 Nov 2009 13:19:06 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
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
Subject: Re: [PATCH 2/7] ACPI: Limit the number of per cpu ACPI bootup messages
References: <20091112171934.584037000@alcatraz.americas.sgi.com> <20091112171949.218777000@alcatraz.americas.sgi.com> <alpine.DEB.2.00.0911121259260.13943@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0911121259260.13943@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



David Rientjes wrote:
> On Thu, 12 Nov 2009, Mike Travis wrote:
> 
>> Limit the number of per cpu ACPI messages when system is booting to
>> prevent clogging up the console output with repetitious messages.
>>
> 
> ... "by changing the log level from KERN_INFO to KERN_DEBUG."
> 
>> Signed-off-by: Mike Travis <travis@sgi.com>
>> ---
>>  drivers/acpi/fan.c            |    2 +-
>>  drivers/acpi/processor_core.c |    2 +-
>>  drivers/acpi/tables.c         |   28 +++++++++++++++++++---------
>>  3 files changed, 21 insertions(+), 11 deletions(-)
>>
>> --- linux.orig/drivers/acpi/fan.c
>> +++ linux/drivers/acpi/fan.c
>> @@ -267,7 +267,7 @@
>>  		goto end;
>>  	}
>>  
>> -	dev_info(&device->dev, "registered as cooling_device%d\n", cdev->id);
>> +	dev_dbg(&device->dev, "registered as cooling_device%d\n", cdev->id);
>>  
>>  	device->driver_data = cdev;
>>  	result = sysfs_create_link(&device->dev.kobj,
>> --- linux.orig/drivers/acpi/processor_core.c
>> +++ linux/drivers/acpi/processor_core.c
>> @@ -845,7 +845,7 @@
>>  		goto err_power_exit;
>>  	}
>>  
>> -	dev_info(&device->dev, "registered as cooling_device%d\n",
>> +	dev_dbg(&device->dev, "registered as cooling_device%d\n",
>>  		 pr->cdev->id);
>>  
>>  	result = sysfs_create_link(&device->dev.kobj,
>> --- linux.orig/drivers/acpi/tables.c
>> +++ linux/drivers/acpi/tables.c
>> @@ -66,11 +66,15 @@
>>  		{
>>  			struct acpi_madt_local_x2apic *p =
>>  			    (struct acpi_madt_local_x2apic *)header;
>> -			printk(KERN_INFO PREFIX
>> -			       "X2APIC (apic_id[0x%02x] uid[0x%02x] %s)\n",
>> -			       p->local_apic_id, p->uid,
>> -			       (p->lapic_flags & ACPI_MADT_ENABLED) ?
>> -			       "enabled" : "disabled");
>> +			/*
>> +			 * Per cpu tracing clogs console output when NR_CPUS
>> +			 * is large.  Send only to kernel log buffer.
>> +			 */
>> +			printk(KERN_DEBUG PREFIX
>> +				"X2APIC (apic_id[0x%02x] uid[0x%02x] %s)\n",
>> +				p->local_apic_id, p->uid,
>> +				(p->lapic_flags & ACPI_MADT_ENABLED) ?
>> +					"enabled" : "disabled");
>>  		}
>>  		break;
>>  
> 
> You can still use dev_dbg(PREFIX "...") here.

I thought dev_dbg needed the 'dev' structure and I wasn't sure how to get that...?

> 
>> @@ -171,10 +175,16 @@
>>  		{
>>  			struct acpi_madt_local_sapic *p =
>>  			    (struct acpi_madt_local_sapic *)header;
>> -			printk(KERN_INFO PREFIX
>> -			       "LSAPIC (acpi_id[0x%02x] lsapic_id[0x%02x] lsapic_eid[0x%02x] %s)\n",
>> -			       p->processor_id, p->id, p->eid,
>> -			       (p->lapic_flags & ACPI_MADT_ENABLED) ? "enabled" : "disabled");
>> +			/*
>> +			 * Per cpu tracing clogs console output when NR_CPUS
>> +			 * is large.  Send only to kernel log buffer.
>> +			 */
>> +			printk(KERN_DEBUG PREFIX
>> +				"LSAPIC (acpi_id[0x%02x] lsapic_id[0x%02x] "
>> +				"lsapic_eid[0x%02x] %s)\n",
>> +				p->processor_id, p->id, p->eid,
>> +				(p->lapic_flags & ACPI_MADT_ENABLED) ?
>> +					"enabled" : "disabled");
>>  		}
>>  		break;
>>  
> 
> Likewise, but recent emails from Linus indicate that we don't want to 
> break printk strings into multiple lines even if it goes over 80 
> characters unless broken at '\n'.  Users who grep for 
> "lsapic_id.*lsapic_eid" with this patch wouldn't find the string.

Ahh, ok, I hadn't heard that yet.  (Grep just needs to be made smarter... ;-)

Thanks,
Mike
