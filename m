Return-Path: <linux-kernel-owner+w=401wt.eu-S1752753AbZBQCA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbZBQCA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 21:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbZBQCAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 21:00:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34974 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbZBQCAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 21:00:47 -0500
Message-ID: <499A1A43.6000009@redhat.com>
Date: Mon, 16 Feb 2009 21:00:35 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Nick Piggin <npiggin@suse.de>
CC: Peter Zijlstra <peterz@infradead.org>, akpm <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: irq-disabled vs vmap vs text_poke
References: <1234529407.6519.28.camel@twins> <20090213141839.GA31922@Krystal> <4995A0B7.1030705@redhat.com> <20090213165555.GA4684@Krystal> <4995B88C.2090900@redhat.com> <20090213185725.GC7124@Krystal> <4995E925.3080506@redhat.com> <4999808B.5080505@redhat.com> <20090216153145.GB19182@wotan.suse.de> <20090216172441.GA12576@Krystal>
In-Reply-To: <20090216172441.GA12576@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Nick Piggin (npiggin@suse.de) wrote:
>> On Mon, Feb 16, 2009 at 10:04:43AM -0500, Masami Hiramatsu wrote:
>>>>>>>> BTW, what about using map_vm_area() in text_poke() instead of vmap()?
>>>>>>>> Since text_poke() just maps text pages to alias pages temporarily,
>>>>>>>> I think we don't need to use delayed vunmap().
>> [...] 
>>
>>> Here is the patch which replace v(un)map with (un)map_vm_area.
>> I don't quite understand the point of this... delayed vunmap() is
>> just an implementation detail of vmap subsystem. Callers should not
>> have to care.
>>
> 
> AFAIK, map_vm_area/unmap_vm_area is faster than vmap/vunmap.  This is
> the point of this patch. Masami, could you provide a quick benchmark of
> text_poke()/seconds before and after this optimization is applied to
> confirm this ?

Sure, here is the result of calling text_poke() 2^14 times.

<Without this patch>
Total: 3634133356(cycles), 221809(cycles/text_poke)
Total: 3699532690(cycles), 225801(cycles/text_poke)
Total: 3249855588(cycles), 198355(cycles/text_poke)

<With this patch>
Total: 483467579(cycles), 29508(cycles/text_poke)
Total: 497441301(cycles), 30361(cycles/text_poke)
Total: 497604548(cycles), 30371(cycles/text_poke)

BTW, this is not only for performance, but also simplicity and its need.
Vmap may allocate new vm_area. However, since text_poke() just needs to
map pages temporarily (yeah, very short time), we don't want to call
kmalloc or any other memory allocators.
And since text_poke() makes WRITABLE aliases of READ-ONLY pages, we
want to purge these pages ASAP.
So, I think just reserving a small vm_area for text_poke() and
reusing it is enough.

Thanks,

> 
> Thanks,
> 
> Mathieu
> 
>>  
>>> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
>>> ---
>>>  arch/x86/include/asm/alternative.h |    1 +
>>>  arch/x86/kernel/alternative.c      |   25 ++++++++++++++++++++-----
>>>  init/main.c                        |    3 +++
>>>  3 files changed, 24 insertions(+), 5 deletions(-)
>>>
>>> Index: linux-2.6/arch/x86/include/asm/alternative.h
>>> ===================================================================
>>> --- linux-2.6.orig/arch/x86/include/asm/alternative.h
>>> +++ linux-2.6/arch/x86/include/asm/alternative.h
>>> @@ -177,6 +177,7 @@ extern void add_nops(void *insns, unsign
>>>   * The _early version expects the memory to already be RW.
>>>   */
>>>
>>> +extern void text_poke_init(void);
>>>  extern void *text_poke(void *addr, const void *opcode, size_t len);
>>>  extern void *text_poke_early(void *addr, const void *opcode, size_t len);
>>>
>>> Index: linux-2.6/arch/x86/kernel/alternative.c
>>> ===================================================================
>>> --- linux-2.6.orig/arch/x86/kernel/alternative.c
>>> +++ linux-2.6/arch/x86/kernel/alternative.c
>>> @@ -485,6 +485,16 @@ void *text_poke_early(void *addr, const
>>>  	return addr;
>>>  }
>>>
>>> +static struct vm_struct *text_poke_area[2];
>>> +static DEFINE_SPINLOCK(text_poke_lock);
>>> +
>>> +void __init text_poke_init(void)
>>> +{
>>> +	text_poke_area[0] = get_vm_area(PAGE_SIZE, VM_ALLOC);
>>> +	text_poke_area[1] = get_vm_area(2 * PAGE_SIZE, VM_ALLOC);
>>> +	BUG_ON(!text_poke_area[0] || !text_poke_area[1]);
>>> +}
>>> +
>>>  /**
>>>   * text_poke - Update instructions on a live kernel
>>>   * @addr: address to modify
>>> @@ -501,8 +511,9 @@ void *__kprobes text_poke(void *addr, co
>>>  	unsigned long flags;
>>>  	char *vaddr;
>>>  	int nr_pages = 2;
>>> -	struct page *pages[2];
>>> -	int i;
>>> +	struct page *pages[2], **pgp = pages;
>>> +	int i, ret;
>>> +	struct vm_struct *vma;
>>>
>>>  	if (!core_kernel_text((unsigned long)addr)) {
>>>  		pages[0] = vmalloc_to_page(addr);
>>> @@ -515,12 +526,16 @@ void *__kprobes text_poke(void *addr, co
>>>  	BUG_ON(!pages[0]);
>>>  	if (!pages[1])
>>>  		nr_pages = 1;
>>> -	vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
>>> -	BUG_ON(!vaddr);
>>> +	spin_lock(&text_poke_lock);
>>> +	vma = text_poke_area[nr_pages-1];
>>> +	ret = map_vm_area(vma, PAGE_KERNEL, &pgp);
>>> +	BUG_ON(ret);
>>> +	vaddr = vma->addr;
>>>  	local_irq_save(flags);
>>>  	memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
>>>  	local_irq_restore(flags);
>>> -	vunmap(vaddr);
>>> +	unmap_kernel_range((unsigned long)vma->addr, (unsigned 
>>> long)vma->size);
>>> +	spin_unlock(&text_poke_lock);
>>>  	sync_core();
>>>  	/* Could also do a CLFLUSH here to speed up CPU recovery; but
>>>  	   that causes hangs on some VIA CPUs. */
>>> Index: linux-2.6/init/main.c
>>> ===================================================================
>>> --- linux-2.6.orig/init/main.c
>>> +++ linux-2.6/init/main.c
>>> @@ -676,6 +676,9 @@ asmlinkage void __init start_kernel(void
>>>  	taskstats_init_early();
>>>  	delayacct_init();
>>>
>>> +#ifdef CONFIG_X86
>>> +	text_poke_init();
>>> +#endif
>>>  	check_bugs();
>>>
>>>  	acpi_early_init(); /* before LAPIC and SMP init */
>>>
>>> -- 
>>> Masami Hiramatsu
>>>
>>> Software Engineer
>>> Hitachi Computer Products (America) Inc.
>>> Software Solutions Division
>>>
>>> e-mail: mhiramat@redhat.com
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

