Return-Path: <linux-kernel-owner+w=401wt.eu-S1758955AbYCZQNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955AbYCZQNu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 12:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756490AbYCZQNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 12:13:42 -0400
Received: from gw.goop.org ([64.81.55.164]:40836 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756455AbYCZQNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 12:13:41 -0400
Message-ID: <47EA7633.1080909@goop.org>
Date: Wed, 26 Mar 2008 09:13:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 06/10] x86: reduce memory and stack usage in	intel_cacheinfo
References: <20080325220650.835342000@polaris-admin.engr.sgi.com> <20080325220651.683748000@polaris-admin.engr.sgi.com> <20080326065023.GG18301@elte.hu> <47EA6EA3.1070609@sgi.com>
In-Reply-To: <47EA6EA3.1070609@sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Ingo Molnar wrote:
>   
>> * Mike Travis <travis@sgi.com> wrote:
>>
>>     
>>> * Change the following static arrays sized by NR_CPUS to
>>>   per_cpu data variables:
>>>
>>> 	_cpuid4_info *cpuid4_info[NR_CPUS];
>>> 	_index_kobject *index_kobject[NR_CPUS];
>>> 	kobject * cache_kobject[NR_CPUS];
>>>
>>> * Remove the local NR_CPUS array with a kmalloc'd region in
>>>   show_shared_cpu_map().
>>>       
>> thanks Travis, i've applied this to x86.git.
>>
>> one observation:
>>
>>     
>>>  static ssize_t show_shared_cpu_map(struct _cpuid4_info *this_leaf, char *buf)
>>>  {
>>> -	char mask_str[NR_CPUS];
>>> -	cpumask_scnprintf(mask_str, NR_CPUS, this_leaf->shared_cpu_map);
>>> -	return sprintf(buf, "%s\n", mask_str);
>>> +	int n = 0;
>>> +	int len = cpumask_scnprintf_len(nr_cpu_ids);
>>> +	char *mask_str = kmalloc(len, GFP_KERNEL);
>>> +
>>> +	if (mask_str) {
>>> +		cpumask_scnprintf(mask_str, len, this_leaf->shared_cpu_map);
>>> +		n = sprintf(buf, "%s\n", mask_str);
>>> +		kfree(mask_str);
>>> +	}
>>> +	return n;
>>>       
>> the other changes look good, but this one looks a bit ugly and complex. 
>> We basically want to sprintf shared_cpu_map into 'buf', but we do that 
>> by first allocating a temporary buffer, print a string into it, then 
>> print that string into another buffer ...
>>
>> this very much smells like an API bug in cpumask_scnprintf() - why dont 
>> you create a cpumask_scnprintf_ptr() API that takes a pointer to a 
>> cpumask? Then this change would become a trivial and much more readable:
>>
>>  -	char mask_str[NR_CPUS];
>>  -	cpumask_scnprintf(mask_str, NR_CPUS, this_leaf->shared_cpu_map);
>>  -	return sprintf(buf, "%s\n", mask_str);
>>  +	return cpumask_scnprintf_ptr(buf, NR_CPUS, &this_leaf->shared_cpu_map);
>>
>> 	Ingo
>>     
>
> The main goal was to avoid allocating 4096 bytes when only 32 would do
> (characters needed to represent nr_cpu_ids cpus instead of NR_CPUS cpus.)
> But I'll look at cleaning it up a bit more.  It wouldn't have to be
> a function if CHUNKSZ in cpumask_scnprintf() were visible (or a non-changeable
> constant.)
>   

It's a pity you can't take advantage of kasprintf to handle all this.

Hm, I would say that bitmap_scnprintf is a candidate for implementation 
as a printk format specifier so you could get away from needing a 
special function to print bitmaps...

Eh?  What's the difference between snprintf and scnprintf?

    J
