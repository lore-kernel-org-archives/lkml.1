Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbZAES2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbZAES2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 13:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbZAES2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 13:28:33 -0500
Received: from relay1.sgi.com ([192.48.179.29]:60977 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751165AbZAES2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 13:28:32 -0500
Message-ID: <49625145.7070402@sgi.com>
Date: Mon, 05 Jan 2009 10:28:21 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] x86: cpumask: some more cpumask cleanups
References: <20090104131759.865331000@polaris-admin.engr.sgi.com> <20090104144454.GA1132@elte.hu>
In-Reply-To: <20090104144454.GA1132@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Here's some more cpumask cleanups.
>>
>>     ia64: cpumask fix for is_affinity_mask_valid()
>>     cpumask: update local_cpus_show to use new cpumask API
>>     cpumask: update pci_bus_show_cpuaffinity to use new cpumask API
>>     x86: cleanup remaining cpumask_t ops in smpboot code
>>     x86: clean up speedstep-centrino and reduce cpumask_t usage
>>     cpumask: Replace CPUMASK_ALLOC etc with cpumask_var_t.
>>     cpumask: convert struct cpufreq_policy to cpumask_var_t.
>>     cpumask: use work_on_cpu in acpi/cstate.c
>>     cpumask: use cpumask_var_t in acpi-cpufreq.c
>>     cpumask: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write
>>     cpumask: use work_on_cpu in acpi-cpufreq.c for read_measured_perf_ctrs
>>
>> This version basically splits out the changes to make it more 
>> bisectable, and has been patch-wise compile/boot tested.  Updated stats 
>> are below.
> 
> ok, i've picked them up into tip/cpus4096:

Thanks Ingo!

> 
> 1d1a70e: cpumask: use work_on_cpu in acpi-cpufreq.c for read_measured_perf_ctrs
> 4d30e6b: cpumask: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write
> 0771cd4: cpumask: use cpumask_var_t in acpi-cpufreq.c
> 9fa9864: cpumask: use work_on_cpu in acpi/cstate.c
> a2a8809: cpumask: convert struct cpufreq_policy to cpumask_var_t
> ee557bd: cpumask: replace CPUMASK_ALLOC etc with cpumask_var_t
> 3744123: x86: clean up speedstep-centrino and reduce cpumask_t usage
> c2d1cec: x86: cleanup remaining cpumask_t ops in smpboot code
> 588235b: cpumask: update pci_bus_show_cpuaffinity to use new cpumask API
> 3be8305: cpumask: update local_cpus_show to use new cpumask API
> d3b66bf: ia64: cpumask fix for is_affinity_mask_valid()
> 
> ( Sidenote, your mail scripts have a bug that do this to the Subject line:
> 
>     Subject: [PATCH 05/11] x86: clean up speedstep-centrino and reduce 
>     cpumask_t usage From: Rusty Russell <rusty@rustcorp.com.au>

It's in quilt mail (even the latest version), but since it's a script, I'll
see about fixing it manually.

> 
>   i've fixed them up manually so that Rusty is in the Author field. )
> 
> 
>> The number of stack hogs have been significantly reduced:
>>
>> ====== Stack (-l 500)
>>     1 - allyesconfig-128
>>     2 - allyesconfig-4k
>>
>>   .1.    .2.    ..final..
>>     0  +1032   1032      .  flush_tlb_page
>>     0  +1024   1024      .  kvm_reload_remote_mmus
>>     0  +1024   1024      .  kvm_flush_remote_tlbs
>>     0  +1024   1024      .  flush_tlb_mm
>>     0  +1024   1024      .  flush_tlb_current_task
> 
> Quite good! Can we fix those TLB flush cpumask uses too?

I've looked at the tlb ones and they are hairy.  But we now have a few more
facilities in place so I'll revisit them.

> 
>> And the overall memory usage is becoming quite less affected by changing
>> NR_CPUS from 128 to 4096:
> [...]
>>         .1.       .2.    ..final..
>>    11436936  +4167424    15604360   +36%  .bss
> 
> .bss seems to account for ~80% of the increase. Are these static cpumasks, 
> or do we still have NR_CPUS arrays around?

There are 72 arrays still using NR_CPUS (though some legitimately) and 14 static
cpumask_t's and 11 "DECLARE_BITMAP(..., NR_CPUS)".

There are also about 5 patches left in my queue that need further testing with
the latest tip code.

Thanks,
Mike
