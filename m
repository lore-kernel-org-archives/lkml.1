Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638AbZKMNx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbZKMNx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 08:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbZKMNxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 08:53:51 -0500
Received: from relay3.sgi.com ([192.48.152.1]:50126 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753311AbZKMNxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 08:53:51 -0500
Message-ID: <4AFD64EF.20807@sgi.com>
Date: Fri, 13 Nov 2009 05:53:51 -0800
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
References: <20091112171934.584037000@alcatraz.americas.sgi.com> <20091112171949.218777000@alcatraz.americas.sgi.com> <alpine.DEB.2.00.0911121259260.13943@chino.kir.corp.google.com> <4AFC7BCA.3070705@sgi.com> <alpine.DEB.2.00.0911121324280.17797@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0911121324280.17797@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



David Rientjes wrote:
> On Thu, 12 Nov 2009, Mike Travis wrote:
> 
>>>> --- linux.orig/drivers/acpi/tables.c
>>>> +++ linux/drivers/acpi/tables.c
>>>> @@ -66,11 +66,15 @@
>>>>  		{
>>>>  			struct acpi_madt_local_x2apic *p =
>>>>  			    (struct acpi_madt_local_x2apic *)header;
>>>> -			printk(KERN_INFO PREFIX
>>>> -			       "X2APIC (apic_id[0x%02x] uid[0x%02x] %s)\n",
>>>> -			       p->local_apic_id, p->uid,
>>>> -			       (p->lapic_flags & ACPI_MADT_ENABLED) ?
>>>> -			       "enabled" : "disabled");
>>>> +			/*
>>>> +			 * Per cpu tracing clogs console output when NR_CPUS
>>>> +			 * is large.  Send only to kernel log buffer.
>>>> +			 */
>>>> +			printk(KERN_DEBUG PREFIX
>>>> +				"X2APIC (apic_id[0x%02x] uid[0x%02x] %s)\n",
>>>> +				p->local_apic_id, p->uid,
>>>> +				(p->lapic_flags & ACPI_MADT_ENABLED) ?
>>>> +					"enabled" : "disabled");
>>>>  		}
>>>>  		break;
>>>>  
>>> You can still use dev_dbg(PREFIX "...") here.
>> I thought dev_dbg needed the 'dev' structure and I wasn't sure how to get
>> that...?
>>
> 
> Ah, ok, it needs to be pr_debug(PREFIX "...") then.

The primary reason I'm using KERN_DEBUG instead of pr_debug is that the
messages will end up in the log in the former case, so dmesg can print
them out, whether it's a DEBUG kernel or not.  This helps diagnose problems
without requiring a reboot of a DEBUG kernel to reproduce a problem, which
often is not acceptable to many customers (security and system availability
being the primary concerns.)

> Any reason why the other printk's in acpi_table_print_madt_entry() weren't 
> converted to use KERN_DEBUG?  It might make more sense to convert all 
> those to use a new acpi=verbose flag.

I thought of that, but the ACPI debug infrastructure is complex to understand,
and since I can't really test most cases, I wanted to tread lightly.
> 
> I'm not sure if Ingo is the right person to go through for acpi patches, I 
> think this should probably be submitted to Len Brown <lenb@kernel.org> and 
> linux-acpi@vger.kernel.org instead.

I can do that.

Thanks,
Mike
