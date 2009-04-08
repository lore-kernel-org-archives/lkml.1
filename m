Return-Path: <linux-kernel-owner+w=401wt.eu-S1762269AbZDHO67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762269AbZDHO67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753538AbZDHO6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:58:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55760 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822AbZDHO6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:58:47 -0400
Message-ID: <49DCBB53.2020202@redhat.com>
Date: Wed, 08 Apr 2009 07:57:23 -0700
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: [BUGFIX][PATCH -tip] x86: fix text_poke to handle highmem pages
References: <49D76FFF.6020202@redhat.com> <20090404154230.GB2451@Krystal> <49D7A6DF.8080804@redhat.com> <49D7AF26.5030808@redhat.com> <49D82987.5090003@redhat.com> <49DA37CB.4020901@redhat.com> <20090408123133.GE18581@elte.hu>
In-Reply-To: <20090408123133.GE18581@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
>> @@ -514,27 +515,39 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
>>  {
>>  	unsigned long flags;
>>  	char *vaddr;
>> -	struct page *pages[2];
>> +	struct page *page;
>>  	int i;
>> +	unsigned long endp = ((unsigned long)addr + len) & PAGE_MASK;
>>
>> -	if (!core_kernel_text((unsigned long)addr)) {
>> -		pages[0] = vmalloc_to_page(addr);
>> -		pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
>> -	} else {
>> -		pages[0] = virt_to_page(addr);
>> -		WARN_ON(!PageReserved(pages[0]));
>> -		pages[1] = virt_to_page(addr + PAGE_SIZE);
>> +	/*
>> +	 * If the written range covers 2 pages, we'll split it, because
>> +	 * vmalloc pages are not always continuous -- e.g. 1st page is
>> +	 * lowmem and 2nd page is highmem.
>> +	 */
>> +	if (((unsigned long)addr & PAGE_MASK) != endp) {
>> +		text_poke(addr, opcode, endp - (unsigned long)addr);
>> +		addr =  (void *)endp;
>> +		opcode = (char *)opcode + (endp - (unsigned long)addr);
>> +		len -= endp - (unsigned long)addr;
>>  	}
>> -	BUG_ON(!pages[0]);
>> +
>> +	if (!core_kernel_text((unsigned long)addr))
>> +		page = vmalloc_to_page(addr);
>> +	else
>> +		page = virt_to_page(addr);
> 
> hm, the bug is upstream now. And your fix turns a 
> supposed-to-be-simpler kmap based patching thing back into something 
> fragile looking again. We might be better off with a revert - or we 
> do a real clean patch.
> 
> Firstly, that core_kernel_text() distinction above looks 
> artificially open-coded - dont we have a proper, generic 
> "look-up-the-page" variant in the MM somewhere?

Actually, vmalloc_to_page() is generic one. It decodes
the kernel page table directly to find struct page *.
virt_to_page() is just a short-cut api.

> 
>> +	BUG_ON(!page);
>>  	local_irq_save(flags);
>> -	set_fixmap(FIX_TEXT_POKE0, page_to_phys(pages[0]));
>> -	if (pages[1])
>> -		set_fixmap(FIX_TEXT_POKE1, page_to_phys(pages[1]));
>> -	vaddr = (char *)fix_to_virt(FIX_TEXT_POKE0);
>> +	if (PageHighMem(page))
>> +		vaddr = kmap_atomic(page, KM_TEXT_POKE);
>> +	else {
>> +		set_fixmap(FIX_TEXT_POKE, page_to_phys(page));
>> +		vaddr = (char *)fix_to_virt(FIX_TEXT_POKE);
>> +	}
> 
> that too looks artificially complex. Why cannot we kmap lowmem pages 
> too? If the API isnt available on !HIGHMEM kernels .. then the 
> solution is to make it available, not to branch our way around it.

Hmm, why don't we enhance fixmap to handle highmem pages?
(e.g. adding set_fixmap_page())
Since kmap is only for highmem kernels, I think changing it will effects
more users...

Thank you,

> 
>>  	memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
>> -	clear_fixmap(FIX_TEXT_POKE0);
>> -	if (pages[1])
>> -		clear_fixmap(FIX_TEXT_POKE1);
>> +	if (PageHighMem(page))
>> +		kunmap_atomic(vaddr, KM_TEXT_POKE);
>> +	else
>> +		clear_fixmap(FIX_TEXT_POKE);
> 
> ditto.
> 
> Thanks,
> 
> 	Ingo

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

