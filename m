Return-Path: <linux-kernel-owner+w=401wt.eu-S1752708AbZHMDbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbZHMDbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 23:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbZHMDbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 23:31:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58291 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbZHMDbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 23:31:06 -0400
Message-ID: <4A83893D.50707@redhat.com>
Date: Thu, 13 Aug 2009 11:32:13 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, linux-mm@kvack.org,
       Neil Horman <nhorman@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       akpm@linux-foundation.org, bernhard.walle@gmx.de,
       Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 8/8] kexec: allow to shrink reserved memory
References: <20090812081731.5757.25254.sendpatchset@localhost.localdomain>	<20090812081906.5757.39417.sendpatchset@localhost.localdomain> <m1bpmk8l1g.fsf@fess.ebiederm.org>
In-Reply-To: <m1bpmk8l1g.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Amerigo Wang <amwang@redhat.com> writes:
>
>   
>> This patch implements shrinking the reserved memory for crash kernel,
>> if it is more than enough.
>>
>> For example, if you have already reserved 128M, now you just want 100M,
>> you can do:
>>
>> # echo $((100*1024*1024)) > /sys/kernel/kexec_crash_size
>>     
>
> Getting closer (comments inline)
>
> Semantically this patch is non-contriversial and pretty
> simple, but still needs a fair amount of review.  Can
> you put this patch at the front of your patch set.
>
>   

Sure, I will do it when I resend them next time.

I add mm people into Cc.
>> Index: linux-2.6/kernel/kexec.c
>> ===================================================================
>> --- linux-2.6.orig/kernel/kexec.c
>> +++ linux-2.6/kernel/kexec.c
>> @@ -1083,6 +1083,76 @@ void crash_kexec(struct pt_regs *regs)
>>  	}
>>  }
>>  
>> +int kexec_crash_kernel_loaded(void)
>> +{
>> +	int ret;
>> +	if (!mutex_trylock(&kexec_mutex))
>> +		return 1;
>>     
>
> We don't need trylock on this code path 
>   

OK.

>   
>> +	ret = kexec_crash_image != NULL;
>> +	mutex_unlock(&kexec_mutex);
>> +	return ret;
>> +}
>> +
>> +size_t get_crash_memory_size(void)
>> +{
>> +	size_t size;
>> +	if (!mutex_trylock(&kexec_mutex))
>> +		return 1;
>>     
>
> We don't need trylock on this code path 
>
>   

Hmm, crashk_res is a global struct, so other process can also
change it... but currently no process does that, right?

>> +	size = crashk_res.end - crashk_res.start + 1;
>> +	mutex_unlock(&kexec_mutex);
>> +	return size;
>> +}
>> +
>> +int shrink_crash_memory(unsigned long new_size)
>> +{
>> +	struct page **pages;
>> +	int ret = 0;
>> +	int  npages, i;
>> +	unsigned long addr;
>> +	unsigned long start, end;
>> +	void *vaddr;
>> +
>> +	if (!mutex_trylock(&kexec_mutex))
>> +		return -EBUSY;
>>     
>
> We don't need trylock on this code path 
>
> We are missing the check to see if the crash_kernel is loaded
> under this lock instance. So I please move the kexec_crash_image != NULL
> test inline here and kill the kexec_crash_kernel_loaded function.
>   

Ok, no problem.

>   
>> +	start = crashk_res.start;
>> +	end = crashk_res.end;
>> +
>> +	if (new_size >= end - start + 1) {
>> +		ret = -EINVAL;
>> +		if (new_size == end - start + 1)
>> +			ret = 0;
>> +		goto unlock;
>> +	}
>> +
>> +	start = roundup(start, PAGE_SIZE);
>> +	end = roundup(start + new_size, PAGE_SIZE) - 1;
>> +	npages = (end + 1 - start ) / PAGE_SIZE;
>> +
>> +	pages = kmalloc(sizeof(struct page *) * npages, GFP_KERNEL);
>> +	if (!pages) {
>> +		ret = -ENOMEM;
>> +		goto unlock;
>> +	}
>> +	for (i = 0; i < npages; i++) {
>> +		addr = end + 1 + i * PAGE_SIZE;
>> +		pages[i] = virt_to_page(addr);
>> +	}
>> +
>> +	vaddr = vm_map_ram(pages, npages, 0, PAGE_KERNEL);
>>     
>
> This is the wrong kernel call to use.  I expect this needs to look
> like a memory hotplug event.  This does not put the pages into the
> free page pool.
>   

Well, I also wanted to use an memory-hotplug API, but that will make the 
code depend on memory-hotplug, which certainly is not what we want...

I checked the mm code, actually what I need is an API which is similar 
to add_active_range(), but add_active_range() can't be used here since 
it is marked as "__init".

Do we have that kind of API in mm? I can't find one.

Thanks!


