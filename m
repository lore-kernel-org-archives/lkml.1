Return-Path: <linux-kernel-owner+w=401wt.eu-S1763707AbYCDEMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763707AbYCDEMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 23:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757954AbYCDEMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 23:12:33 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:50069 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757861AbYCDEMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 23:12:32 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAFZbzEdMQWoK/2dsb2JhbACBVqw+
Date: Mon, 3 Mar 2008 23:12:30 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>
Subject: Re: bad paravirt/Xen interaction in "x86 - Enhance DEBUG_RODATA
	support - alternatives"
Message-ID: <20080304041230.GA22753@Krystal>
References: <47C86D7A.5030608@goop.org> <20080303173057.GA14598@Krystal> <47CC3C2B.6000807@goop.org> <200803031903.35724.ak@suse.de> <47CC3DE5.4060105@goop.org> <20080303205333.GA1832@Krystal> <47CC7897.1080703@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <47CC7897.1080703@goop.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:02:10 up 4 days, 13 min,  5 users,  load average: 0.15, 0.13,
	0.29
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> Mathieu Desnoyers wrote:
>> * Jeremy Fitzhardinge (jeremy@goop.org) wrote:
>>   
>>> Andi Kleen wrote:
>>>     
>>>> On Monday 03 March 2008 18:58:03 Jeremy Fitzhardinge wrote:
>>>>
>>>>         
>>>>> Perhaps, though that's uncached by default.
>>>>>             
>>>> ioremap_cached()
>>>>       
>>> Sure.  But given that from the perspective of this problem ioremap* is 
>>> just a wrapper for vmap, we may as well use it directly and avoid getting 
>>> tangled up in any current or future io-related stuff that ioremap may 
>>> want to do.
>>>
>>>    J
>>>     
>>
>> Would you have a quick hint on why I get a page fault with the following
>> implementation ? There is probably a fundamental detail I missed.
>>
>>
>> void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
>> {
>>         char *vaddr;
>>         struct page *pages[1];
>>
>>         BUG_ON(len > sizeof(long));
>>         BUG_ON((((long)addr + len - 1) & ~(sizeof(long) - 1))
>>                 - ((long)addr & ~(sizeof(long) - 1)));
>>         if (kernel_text_address((unsigned long)addr))
>>                 pages[0] = virt_to_page(addr);
>>         else
>>                 vaddr = addr;
>>   
>

Hi Jeremy,

(Connecting brain...)

> What's this for?  You just overwrite vaddr with the vmap on the next line.
>

Ah, it's supposed to be

if (kernel_text_address((unsigned long)addr)) {
  pages[0] = virt_to_page(addr);
  vaddr = vmap(pages, 1, VM_MAP, PAGE_KERNEL);
  memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
} else
  memcpy(addr, opcode, len);



>>         vaddr = vmap(pages, 1, VM_MAP, PAGE_KERNEL);
>>   
> Do you need to handle the case of an instruction spanning a page boundary?
>

Not really :

1-byte changes :

- kprobes is a 1-byte breakpoint
- smp alternatives changes an f0 prefix into a 1-byte nop when a single
  CPU is active (the opposite is done when bringing up a second CPU).

Aligned on word size :
- immediate values are aligned on word size

At boot time only, before kernel pages are marked RO :
- alternatives and paravirt are applied at boot time only

But yes, I guess it's cheap and allows supporting users which does not
have their instructions aligned. I'll change it.

>>         memcpy(&vaddr[(unsigned long)addr & PAGE_MASK], opcode, len);
>>         if (kernel_text_address((unsigned long)addr))
>>                 vunmap(vaddr);
>>         sync_core();
>>         /* Could also do a CLFLUSH here to speed up CPU recovery; but
>>            that causes hangs on some VIA CPUs. */
>>         return addr;
>> }
>>
>>
>> [    0.149856] SMP alternatives: switching to UP code                      
>>      [    0.152009] BUG: unable to handle kernel paging request at 
>> b8902000            
> That's a userspace address, unless you've got 2G:2G, and the error code 
> says there's nothing mapped there.
>

<banging head on the wall> & PAGE_MASK -> & ~PAGE_MASK  :)

Thanks!

Mathieu

>> [    0.152009] IP: [<c03acfa1>] text_poke+0x85/0xb4                        
>>      [    0.152009] *pde = 00000000                                        
>>           [    0.152009] Oops: 0002 [#1] SMP                               
>>                [    0.152009] LTT NESTING LEVEL : 0 <0>                    
>>                     [    0.152009] Modules linked in:
>> [    0.152009] [    0.152009] Pid: 0, comm: swapper Not tainted 
>> (2.6.25-rc3-testssmp #744)
>> [    0.152009] EIP: 0060:[<c03acfa1>] EFLAGS: 00010002 CPU: 0
>> [    0.152009] EIP is at text_poke+0x85/0xb4
>> [    0.152009] EAX: f8800000 EBX: 00000001 ECX: 00000001 EDX: f8800000
>> [    0.152009] ESI: c04a3fab EDI: b8902000 EBP: c0102114 ESP: c04a3f88
>> [    0.152009]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>> [    0.152009] Process swapper (pid: 0, ti=c04a2000 task=c04703a0 
>> task.ti=c04a2)
>> [    0.152009] Stack: 00000163 f8800000 c1002040 c04a400c c04a7cac 
>> c0100000 c03 [    0.152009]        90411244 00000206 c04e072c c17fb72c 
>> 0000672c c04aaefe c03 [    0.152009]        c04ab76a c17f5000 c04a896a 
>> 00000092 c04a80d7 00000008 000 [    0.152009] Call Trace:                  
>>                                     [    0.152009]  [<c03b0139>] 
>> _etext+0x0/0xf7ec7                                 [    0.152009]  
>> [<c0107814>] alternatives_smp_unlock+0x57/0x59                  [    
>> 0.152009]  [<c04aaefe>] alternative_instructions+0x152/0x157               
>> [    0.152009]  [<c03b0139>] _etext+0x0/0xf7ec7                            
>>      [    0.152009]  [<c04ab76a>] check_bugs+0x131/0x14e                   
>>           [    0.152009]  [<c04a896a>] start_kernel+0x2d1/0x327            
>>                [    0.152009]  [<c04a80d7>] unknown_bootoption+0x0/0x1e3   
>>                     [    0.152009]  =======================                
>>                          [    0.152009] Code: b9 04 00 00 00 ba 01 00 00 
>> 00 e8 a6 87 db ff 89 44 24 04 8 [    0.152009] EIP: [<c03acfa1>] 
>> text_poke+0x85/0xb4 SS:ESP 0068:c04a3f88       [    0.152009] ---[ end 
>> trace ca143223eefdc828 ]---                             [    0.152009] 
>> Kernel panic - not syncing: Attempted to kill the idle task!       
>
>    J

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
