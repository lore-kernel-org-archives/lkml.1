Return-Path: <linux-kernel-owner+w=401wt.eu-S1759270AbZCQSdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759270AbZCQSdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 14:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754448AbZCQSde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 14:33:34 -0400
Received: from gw.goop.org ([64.81.55.164]:50463 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754337AbZCQSdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 14:33:33 -0400
Message-ID: <49BFECF9.6090204@goop.org>
Date: Tue, 17 Mar 2009 11:33:29 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       hpa@zytor.com
Subject: Re: [PATCH] x86: create a non-zero sized bm_pte only when	 needed
References: <49B91826.76E4.0078.0@novell.com> <49BED400.6040605@goop.org> <49BF621E.76E4.0078.0@novell.com>
In-Reply-To: <49BF621E.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>> Does this depend on CONFIG_EARLY_PRINTK_DBGP being set?  And what's so 
>> special about FIX_DBGP_BASE, that we should hard-code it in here?  Is it 
>> just that its the first non-arch-dependent fixmap slot?  Or something 
>> else?  Will it break if we move FIX_DBGP_BASE?
>>     
>
> No, it is indeed tied to that one fixmap entry, as this is what the 'early
> initialization of the fixmap area' (commented such in head_32.S, and
> uncommented equivalent exists in head_64.S) is about, albeit without
> explicit tying to the respective fixmap entry (which makes this code
> even more fragile than my change might seem).
>   

I had to dig back to mid 2007 to find Eric's changeset referring to "USB 
debug", but as far as I can see the DBGP code didn't appear in-tree 
until mid 2008.  That's a lot of archaeology to dig through to 
understand this change.

>> Is the space saving here just the 1 page for bm_pte[]?
>>     
>
> Yes.
>
>   
>> Wouldn't we do as well by making it initdata?
>>     
>
> No, because the table may be retained past boot.
>   

No, early_ioremaps are not allowed to exist beyond boot-time.  The 
ioremap code will complain about any extant mappings in 
check_early_ioremap_leak().

But bm_pte might be used for other fixmap slots, so it can't really be 
released unless we carefully rearrange things.

>> I'm picking on this change because its breaking Xen PV booting...
>>     
>
> Hmm, I don't think there's anything that should make it break. Any
> details?
>   

dmi_present() faults because the pointer returned from early_ioremap is 
bad: the L2 entry is empty.  Xen boot doesn't go through head.S, and has 
no particular requirement for extremely early fixmap access, so there's 
no implicit fixmap pte setup.

user-defined physical RAM map:
 user: 0000000000000000 - 00000000000a0000 (usable)
 user: 00000000000a0000 - 0000000000100000 (reserved)
 user: 0000000000100000 - 0000000000eaf000 (usable)
 user: 0000000000eaf000 - 0000000000f32000 (reserved)
 user: 0000000000f32000 - 0000000010000000 (usable)
(XEN) d1:v0: unhandled page fault (ec=0000)
(XEN) Pagetable walk from ffffffffff400000:
(XEN)  L4[0x1ff] = 0000000078c80067 0000000000000203
(XEN)  L3[0x1ff] = 0000000078c41067 0000000000000204
(XEN)  L2[0x1fa] = 0000000000000000 ffffffffffffffff 
(XEN) domain_crash_sync called from entry.S
(XEN) Domain 1 (vcpu#0) crashed on cpu#1:
(XEN) ----[ Xen-3.4-unstable  x86_64  debug=y  Not tainted ]----
(XEN) CPU:    1
(XEN) RIP:    e033:[<ffffffff8034e155>]
(XEN) RFLAGS: 0000000000000207   EM: 1   CONTEXT: pv guest
(XEN) rax: ffffffffff410000   rbx: ffffffff80665e88   rcx: 0000000000000003
(XEN) rdx: 000000000000000f   rsi: ffffffffff400000   rdi: ffffffff80665e88
(XEN) rbp: ffffffff80665e78   rsp: ffffffff80665e30   r8:  ffffffff80665c68
(XEN) r9:  ffffffff80621080   r10: 0000000000000002   r11: 0000000000000519
(XEN) r12: ffffffffff400000   r13: ffffffffff400000   r14: 0000000000000000
(XEN) r15: 0000000000000000   cr0: 000000008005003b   cr4: 00000000000026f0
(XEN) cr3: 0000000078e01000   cr2: ffffffffff400000



>>>  static __initdata int after_paging_init;
>>> -static pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)] __page_aligned_bss;
>>> +#define __FIXADDR_TOP (-PAGE_SIZE)
>>>   
>>>       
>> Will this break in a 32-bit PV kernel where FIXADDR_TOP is shifted?
>>     
>
> Not as long as the shifting happens in 2Mb steps (and when I wrote the
> patch [which was a while back] I checked that there are other assumptions
> about the shift only happening in 2Mb increments).
>
>   
>> This seriously needs a good inline comment.
>>     
>
> Why only is it always me who is asked for extensive inline comments, when
> other code in the same area is happily being accepted without even being
> self-commenting (which, if you read the construct carefully, I believe my
> change is)? As noted above, the dependency on which page table slot
> need early initialization is completely hidden behind hardcoded literal numbers
> at least for x86-64. This is what indeed would need a comment (or better
> yet, replacing of the hardcoded numbers by proper symbolics, in which
> case I would think a comment would quickly become redundant).
>   

The change needs to stand on its own.  I'm fairly familiar with this 
area of this area of code, but the implicit dependency on the fixmap 
setup in head*.S wasn't at all obvious.  I searched the tree for 
references to FIX_DBGP_BASE to work out why it was the slot you were 
using here, but again, I couldn't work it out.  And conceptually, making 
the init of something as central as early_ioremap a side-effect of the 
init for a debug device just doesn't make much sense to me.

My concern is that this change makes everything a bit more brittle, with 
more non-obvious long-range dependencies which we'll need to keep under 
control as the code changes, but with only a tiny (potential) memory 
saving as an upside.

    J
