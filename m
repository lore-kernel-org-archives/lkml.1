Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbZEZKCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbZEZKCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 06:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbZEZKCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 06:02:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53482 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133AbZEZKCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 06:02:03 -0400
Message-ID: <4A1BBE51.8090208@redhat.com>
Date: Tue, 26 May 2009 18:02:57 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, jdike@addtoit.com, mingo@elte.hu
Subject: Re: [Patch 2/4] x86 module: merge the rest functions with macros
References: <20090526083717.5050.32719.sendpatchset@localhost.localdomain> <20090526083734.5050.25473.sendpatchset@localhost.localdomain> <20090526092157.GA25759@infradead.org>
In-Reply-To: <20090526092157.GA25759@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Tue, May 26, 2009 at 04:35:22AM -0400, Amerigo Wang wrote:
>   
>> +#if defined(CONFIG_UML) || defined(CONFIG_X86_32)
>> +void *module_alloc(unsigned long size)
>> +{
>> +	if (size == 0)
>> +		return NULL;
>> +	return vmalloc_exec(size);
>> +}
>> +#else /*X86_64*/
>> +void *module_alloc(unsigned long size)
>> +{
>> +	struct vm_struct *area;
>> +
>> +	if (!size)
>> +		return NULL;
>> +	size = PAGE_ALIGN(size);
>> +	if (size > MODULES_LEN)
>> +		return NULL;
>> +
>> +	area = __get_vm_area(size, VM_ALLOC, MODULES_VADDR, MODULES_END);
>> +	if (!area)
>> +		return NULL;
>> +
>> +	return __vmalloc_area(area, GFP_KERNEL, PAGE_KERNEL_EXEC);
>> +}
>> +#endif
>>     
>
> vmalloc_exec basically expands to the x86-64 version of that code, just
> using VMALLOC_START/VMALLOC_END instead of MODULES_VADDR/MODULES_END.
>
> So instead of having two variants it would be better to use the x86-64
> unconditionally and define MODULES_VADDR/MODULES_END to
> VMALLOC_START/VMALLOC_END to 32bit and uml.
>
> And that part should be a patch of it's own, not mixed with others.
>   

Thanks, it is a good idea!

But... vmalloc_exec() also sets __GFP_HIGHMEM, this is different from 
x86_64.
No? Or __GFP_HIGHMEM is meaningless on x86_64? :-)


