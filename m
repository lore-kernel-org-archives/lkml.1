Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbYCCWVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbYCCWVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 17:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbYCCWVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 17:21:10 -0500
Received: from gw.goop.org ([64.81.55.164]:53251 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbYCCWVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 17:21:08 -0500
Message-ID: <47CC7897.1080703@goop.org>
Date: Mon, 03 Mar 2008 14:15:51 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <ak@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>
Subject: Re: bad paravirt/Xen interaction in "x86 - Enhance DEBUG_RODATA	support
 - alternatives"
References: <47C86D7A.5030608@goop.org> <20080303173057.GA14598@Krystal> <47CC3C2B.6000807@goop.org> <200803031903.35724.ak@suse.de> <47CC3DE5.4060105@goop.org> <20080303205333.GA1832@Krystal>
In-Reply-To: <20080303205333.GA1832@Krystal>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Jeremy Fitzhardinge (jeremy@goop.org) wrote:
>   
>> Andi Kleen wrote:
>>     
>>> On Monday 03 March 2008 18:58:03 Jeremy Fitzhardinge wrote:
>>>
>>>   
>>>       
>>>> Perhaps, though that's uncached by default.
>>>>     
>>>>         
>>> ioremap_cached()
>>>       
>> Sure.  But given that from the perspective of this problem ioremap* is just 
>> a wrapper for vmap, we may as well use it directly and avoid getting 
>> tangled up in any current or future io-related stuff that ioremap may want 
>> to do.
>>
>>    J
>>     
>
> Would you have a quick hint on why I get a page fault with the following
> implementation ? There is probably a fundamental detail I missed.
>
>
> void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
> {
>         char *vaddr;
>         struct page *pages[1];
>
>         BUG_ON(len > sizeof(long));
>         BUG_ON((((long)addr + len - 1) & ~(sizeof(long) - 1))
>                 - ((long)addr & ~(sizeof(long) - 1)));
>         if (kernel_text_address((unsigned long)addr))
>                 pages[0] = virt_to_page(addr);
>         else
>                 vaddr = addr;
>   

What's this for?  You just overwrite vaddr with the vmap on the next line.

>         vaddr = vmap(pages, 1, VM_MAP, PAGE_KERNEL);
>   
Do you need to handle the case of an instruction spanning a page boundary?

>         memcpy(&vaddr[(unsigned long)addr & PAGE_MASK], opcode, len);
>         if (kernel_text_address((unsigned long)addr))
>                 vunmap(vaddr);
>         sync_core();
>         /* Could also do a CLFLUSH here to speed up CPU recovery; but
>            that causes hangs on some VIA CPUs. */
>         return addr;
> }
>
>
> [    0.149856] SMP alternatives: switching to UP code                           
> [    0.152009] BUG: unable to handle kernel paging request at b8902000          
>   
That's a userspace address, unless you've got 2G:2G, and the error code 
says there's nothing mapped there.

> [    0.152009] IP: [<c03acfa1>] text_poke+0x85/0xb4                             
> [    0.152009] *pde = 00000000                                                  
> [    0.152009] Oops: 0002 [#1] SMP                                              
> [    0.152009] LTT NESTING LEVEL : 0 <0>                                        
> [    0.152009] Modules linked in:
> [    0.152009] 
> [    0.152009] Pid: 0, comm: swapper Not tainted (2.6.25-rc3-testssmp #744)
> [    0.152009] EIP: 0060:[<c03acfa1>] EFLAGS: 00010002 CPU: 0
> [    0.152009] EIP is at text_poke+0x85/0xb4
> [    0.152009] EAX: f8800000 EBX: 00000001 ECX: 00000001 EDX: f8800000
> [    0.152009] ESI: c04a3fab EDI: b8902000 EBP: c0102114 ESP: c04a3f88
> [    0.152009]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [    0.152009] Process swapper (pid: 0, ti=c04a2000 task=c04703a0 task.ti=c04a2)
> [    0.152009] Stack: 00000163 f8800000 c1002040 c04a400c c04a7cac c0100000 c03 
> [    0.152009]        90411244 00000206 c04e072c c17fb72c 0000672c c04aaefe c03 
> [    0.152009]        c04ab76a c17f5000 c04a896a 00000092 c04a80d7 00000008 000 
> [    0.152009] Call Trace:                                                      
> [    0.152009]  [<c03b0139>] _etext+0x0/0xf7ec7                                 
> [    0.152009]  [<c0107814>] alternatives_smp_unlock+0x57/0x59                  
> [    0.152009]  [<c04aaefe>] alternative_instructions+0x152/0x157               
> [    0.152009]  [<c03b0139>] _etext+0x0/0xf7ec7                                 
> [    0.152009]  [<c04ab76a>] check_bugs+0x131/0x14e                             
> [    0.152009]  [<c04a896a>] start_kernel+0x2d1/0x327                           
> [    0.152009]  [<c04a80d7>] unknown_bootoption+0x0/0x1e3                       
> [    0.152009]  =======================                                         
> [    0.152009] Code: b9 04 00 00 00 ba 01 00 00 00 e8 a6 87 db ff 89 44 24 04 8 
> [    0.152009] EIP: [<c03acfa1>] text_poke+0x85/0xb4 SS:ESP 0068:c04a3f88       
> [    0.152009] ---[ end trace ca143223eefdc828 ]---                             
> [    0.152009] Kernel panic - not syncing: Attempted to kill the idle task!     
>   

    J
