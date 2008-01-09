Return-Path: <linux-kernel-owner+w=401wt.eu-S1758489AbYAIBDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489AbYAIBDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 20:03:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756163AbYAIAzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 19:55:51 -0500
Received: from gw.goop.org ([64.81.55.164]:35853 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756923AbYAIAz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 19:55:27 -0500
Message-ID: <47841B09.3020507@goop.org>
Date: Tue, 08 Jan 2008 16:53:29 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 00 of 10] x86: unify asm/pgtable.h
References: <patchbomb.1199829603@localhost> <20080108224244.GA3768@elte.hu> <20080108231226.GA10744@elte.hu> <478405DA.40303@goop.org> <20080108232803.GA19906@elte.hu> <20080108234449.GA24274@elte.hu> <20080109000146.GA29095@elte.hu> <47841194.2010208@goop.org> <20080109002014.GB31289@elte.hu> <20080109002803.GA3732@elte.hu> <20080109003034.GA4658@elte.hu>
In-Reply-To: <20080109003034.GA4658@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>>>>>>  #define __PAGE_KERNEL_EXEC						\
>>>>>> -	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_GLOBAL)
>>>>>> +	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED)
>>>>>>     
>>>>>>             
>>>> This shouldn't be necessary.  The old 64-bit code defined everything 
>>>> without _PAGE_GLOBAL, but then used a MAKE_GLOBAL() macro to OR it 
>>>> in later.  This seemed a bit roundabout to me, so I just put it in 
>>>> from the outset.
>>>>         
>> actually, this is wrong.
>>
>> a couple of places use __PAGE_* values, which you've now changed to 
>> include the _PAGE_GLOBAL flag.
>>     
>
> yep, fixing this resolves the crash.
>   

Bugger.  OK.

And I don't see quite how the global flag is causing the BUG bug in 
change_page_attr().  The logic is:

	if (pgprot_val(prot) != pgprot_val(ref_prot)) {
		...
	} else {
		if (!pte_huge(*kpte)) {
			...
		} else
			BUG();
	}

Is _PAGE_GLOBAL causing the first if() to fall through to the second 
clause?  Because otherwise it shouldn't have any effect on the 
pte_huge() test.

But given that ref_prot is set to PAGE_KERNEL or PAGE_KERNEL_EXEC, which 
will have _PAGE_GLOBAL in it either way, I don't see where the problem 
is coming from.

Gah!  This can't be right!  I think the original change_page_attr() code 
is plain buggy.

The crash call chain is:

  [<ffffffff8021db68>] change_page_attr_addr+0x9e/0x119
  [<ffffffff8021d44f>] ioremap_change_attr+0x49/0x58
  [<ffffffff8021d626>] iounmap+0xbe/0xe0
...


ioremap_change_attr does:

		err = change_page_attr_addr(vaddr,npages,__pgprot(__PAGE_KERNEL|flags));

Now, in the current code (ie, before my patch), __PAGE_KERNEL doesn't 
have _PAGE_GLOBAL set, but PAGE_KERNEL does.  Therefore, 
change_page_attr_addr calls

	__change_page_attr(address, pfn, prot, PAGE_KERNEL);

which means:

	__change_page_attr(address, pfn, pgprot(__PAGE_KERNEL), PAGE_KERNEL);

(iounmap always passes flags of 0) which just happens to fail the test:

	if (pgprot_val(prot) != pgprot_val(ref_prot)) {


because prot doesn't contain _PAGE_GLOBAL and ref_prot does.

In other words, prot and ref_prot can never be equal, so this path is 
always taken, and the other branch which tests pte_huge() is never run.

Andi?  Jan?  Is this code just buggy, or is there something else going 
on here?

    J
