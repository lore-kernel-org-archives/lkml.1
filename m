Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbZDDTDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbZDDTDu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 15:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbZDDTDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 15:03:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54932 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754005AbZDDTDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 15:03:41 -0400
Message-ID: <49D7AF26.5030808@redhat.com>
Date: Sat, 04 Apr 2009 15:04:06 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: [BUG][-tip] kprobes on module functions hits kernel BUG in 	text_poke
  on x86-32
References: <49D76FFF.6020202@redhat.com> <20090404154230.GB2451@Krystal> <49D7A6DF.8080804@redhat.com>
In-Reply-To: <49D7A6DF.8080804@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Mathieu Desnoyers wrote:
>> * Masami Hiramatsu (mhiramat@redhat.com) wrote:
>>> Hi,
>>>
>>> I found text_poke() problem on x86-32 with the latest-tip tree.
>>> When I put a kprobe on a module function, text_poke() hit a BUG.
>>>
>>> This bug can be reproduced on x86-32, but not on x86-64.
>>> And inserting kprobes on a kernel-core function is OK.
>>>
>>> Thank you,
>>>
>> Hi Masami,
>>
>> OK, so text_poke safety net saves the day :)
>>
>> Basically, what we have here is the BUG_ON I have put :
>>
>>        for (i = 0; i < len; i++)
>>                 BUG_ON(((char *)addr)[i] != ((char *)opcode)[i]);
>>
>> Which checks that the modification is really preceivable in the kernel
>> code, triggers this bug. Only for modules you say.
>>
>> It might not be this, but.. let's try something simple (this could be
>> completely unrelated, but won't take long to test): can you try to add a
>> vmalloc_sync_all() at the beginning of text_poke ? This would make sure
>> that lazily-populated TLB entries, which include module code and data on
>> x86, will be populated. I wonder if we hit this problem because
>> vmalloc_to_page would be returning a mapping to a yet unpopulated TLB
>> entry, if it is ever possible.
> 
> Hmm, from the result of my test, vmalloc_sync_all() didn't change anything...
> 
>> If that's not this, then I guess we have some problem with setting a
>> fixmap to a page returned by vmalloc on x86 32.
> 
> I investigate it a bit deeper. I compared fixmap's page* and original
> which vmalloc_to_page returns(because vmalloc_to_page just decode
> current pagetable).
> 
> I added a printk right after set_fixmap, which shows below message.
> 
> fixmap:<fixmap's vaddr>:<page* by vmalloc_to_page>, \
> orig:<original vaddr>:<page* passed to fixmap>
> 
> When I probe a module address, I got this;
> fixmap:ffc58000:c1db1ae4, orig:f84a1000:c59b1ae4
> 
> on the other hand, when probing a kernel addrees, I got this;
> fixmap:ffc58000:c129e01c, orig:c048946a:c129e01c
> 
> I guess this means that set_fixmap didn't set a correct page or
> page_to_phys() returned incorrect phys address.

Oops, I found a funny truth,

fixmap:ffc58000:c1db1670, orig:f83fb000:c59b1670
orig page c59b1670, phys 12f8a4000
fixmap page c1db1670, phys 2f8a4000

page means (struct page *) value, and phys means
its physical address.

You can see set_fixmap() cuts higher bits than 32 bit in fixmap.h

----
void native_set_fixmap(enum fixed_addresses idx,
                       unsigned long phys, pgprot_t flags);

#ifndef CONFIG_PARAVIRT
static inline void __set_fixmap(enum fixed_addresses idx,
                                unsigned long phys, pgprot_t flags)
{
        native_set_fixmap(idx, phys, flags);
}
#endif
---

in x86-64, unsigned long is 64bit, so it can handle highmem. So,
this problem never happens on x86-64.

Ingo, would you think we can expand phys to unsigned long long or
somesush in fixmap.h?

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

