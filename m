Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbYGIIC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbYGIIC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 04:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbYGIICq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 04:02:46 -0400
Received: from gw.goop.org ([64.81.55.164]:54914 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbYGIICp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 04:02:45 -0400
Message-ID: <4874709A.1080801@goop.org>
Date: Wed, 09 Jul 2008 01:02:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mark McLoughlin <markmc@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Stephen Tweedie <sct@redhat.com>,
       Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [PATCH 16 of 55] xen64: add extra pv_mmu_ops
References: <76d0856d664470b81640.1215554798@localhost> <1215590110.16579.7.camel@muff>
In-Reply-To: <1215590110.16579.7.camel@muff>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark McLoughlin wrote:
> Hey Jeremy,
>
> On Tue, 2008-07-08 at 15:06 -0700, Jeremy Fitzhardinge wrote:
>   
>> We need extra pv_mmu_ops for 64-bit, to deal with the extra level of
>> pagetable.
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>> ---
>>  arch/x86/xen/enlighten.c   |   33 +++++++++++++++++++++++++++-
>>  arch/x86/xen/mmu.c         |   51 +++++++++++++++++++++++++++++++++++++++++++-
>>  arch/x86/xen/mmu.h         |   15 +++++++++++-
>>  include/asm-x86/xen/page.h |    4 +++
>>  4 files changed, 99 insertions(+), 4 deletions(-)
>>     
> ...
>   
>> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
>> --- a/arch/x86/xen/mmu.c
>> +++ b/arch/x86/xen/mmu.c
>> @@ -438,14 +438,19 @@
>>  
>>  void xen_set_pte(pte_t *ptep, pte_t pte)
>>  {
>> +#ifdef CONFIG_X86_PAE
>>  	ptep->pte_high = pte.pte_high;
>>  	smp_wmb();
>>  	ptep->pte_low = pte.pte_low;
>> +#else
>> +	*ptep = pte;
>> +#endif
>>  }
>>     
>
> You've dropped non-PAE support already, right? Any reason to use the
> X86_PAE macro instead of X86_32?
>   

It's a fine difference, but the specific thing I'm testing for is 
actually PAE vs 64-bit (or even more specifically "can I update a whole 
pte atomically?").  Testing for X86_32 is equivalent in the absence of 
non-PAE 32-bit, but not quite as correct.  The other way I could do it 
is as I have elsewhere:

	if (sizeof(pte_t) > sizeof(long)) {
		ptep->pte_high = pte.pte_high;
		smp_wmb();
		ptep->pte_low = pte.pte_low;
	} else
		*ptep = pte;

But there are other places where it tests for this using PAE (and even 
whole pvops which are only defined in the PAE case).

You'll notice other places where I test for PAGETABLE_LEVELS == 3 where 
the code  is generally handling 3-level pagetables, and others where I 
test for PAE where it's something specific to PAE.

    J
