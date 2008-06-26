Return-Path: <linux-kernel-owner+w=401wt.eu-S1758213AbYFZO3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213AbYFZO3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 10:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbYFZO3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 10:29:07 -0400
Received: from gw.goop.org ([64.81.55.164]:55825 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbYFZO3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 10:29:06 -0400
Message-ID: <4863A7A3.201@goop.org>
Date: Thu, 26 Jun 2008 07:28:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Nick Piggin <npiggin@suse.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 00 of 36] x86/paravirt: groundwork for 64-bit Xen support
References: <patchbomb.1214367536@localhost> <20080625084253.GA11524@elte.hu> <20080625152212.GA3442@elte.hu> <4862A6A9.1030109@goop.org> <20080626105722.GA12640@elte.hu>
In-Reply-To: <20080626105722.GA12640@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>>> It quickly broke the build in testing:
>>>
>>>  include/asm/pgalloc.h: In function ‘paravirt_pgd_free':
>>>  include/asm/pgalloc.h:14: error: parameter name omitted
>>>  arch/x86/kernel/entry_64.S: In file included from  
>>> arch/x86/kernel/traps_64.c:51:include/asm/pgalloc.h: In function 
>>> ‘paravirt_pgd_free':
>>>  include/asm/pgalloc.h:14: error: parameter name omitted
>>>   
>>>       
>> No, looks like my fault.  The non-PARAVIRT version of  
>> paravirt_pgd_free() is:
>>
>> static inline void paravirt_pgd_free(struct mm_struct *mm, pgd_t *) {}
>>
>> but C doesn't like missing parameter names, even if unused.
>>
>> This should fix it:
>>     
>
> that fixed the build but now we've got a boot crash with this config:
>
>  time.c: Detected 2010.304 MHz processor.
>  spurious 8259A interrupt: IRQ7.
>  BUG: unable to handle kernel NULL pointer dereference at  0000000000000000
>  IP: [<0000000000000000>]
>  PGD 0
>  Thread overran stack, or stack corrupted
>  Oops: 0010 [1] SMP
>  CPU 0
>
> with:
>
>   http://redhat.com/~mingo/misc/config-Thu_Jun_26_12_46_46_CEST_2008.bad
>   

Blerg, a contextless NULL rip.  Have you done any bisection on it?  
Could you try again with the same config, but with 
"CONFIG_PARAVIRT_DEBUG" enabled as well?  That will BUG if it turns out 
to be trying to call a NULL paravirt-op

I'll try to repro here anyway.

> i've pushed out the current tip/xen-64bit branch, so that you can see 
> how things look like at the moment, but i cannot put it into tip/master 
> yet.

Yeah, I was expecting things to break somewhere with this lot :/

Could you add this patch?  I don't think it will help this case, but 
it's a bugfix.

    J

Subject: x86_64: use SWAPGS_UNSAFE_STACK in ia32entry.S

Use SWAPGS_UNSAFE_STACK in ia32entry.S in the places where the active
stack is the usermode stack.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/ia32/ia32entry.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

===================================================================
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -98,7 +98,7 @@
 	CFI_SIGNAL_FRAME
 	CFI_DEF_CFA	rsp,0
 	CFI_REGISTER	rsp,rbp
-	SWAPGS
+	SWAPGS_UNSAFE_STACK
 	movq	%gs:pda_kernelstack, %rsp
 	addq	$(PDA_STACKOFFSET),%rsp	
 	/*
@@ -210,7 +210,7 @@
 	CFI_DEF_CFA	rsp,PDA_STACKOFFSET
 	CFI_REGISTER	rip,rcx
 	/*CFI_REGISTER	rflags,r11*/
-	SWAPGS
+	SWAPGS_UNSAFE_STACK
 	movl	%esp,%r8d
 	CFI_REGISTER	rsp,r8
 	movq	%gs:pda_kernelstack,%rsp


