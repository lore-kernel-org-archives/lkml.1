Return-Path: <linux-kernel-owner+w=401wt.eu-S1765651AbYAYIuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765651AbYAYIuP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:50:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932865AbYAYIrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:47:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59107 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933190AbYAYIq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 03:46:58 -0500
Date: Fri, 25 Jan 2008 09:46:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Huang, Ying" <ying.huang@intel.com>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] x86: fix NX bit handling in change_page_attr
Message-ID: <20080125084633.GA23708@elte.hu>
References: <1201240493.15972.43.camel@caritas-dev.intel.com> <47999089.5080609@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47999089.5080609@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Huang, Ying wrote:

>> This patch fixes a bug of change_page_attr/change_page_attr_addr on 
>> Intel i386/x86_64 CPUs.  After changing page attribute to be 
>> executable with these functions, the page remains un-executable on 
>> Intel i386/x86_64 CPU.  Because on Intel i386/x86_64 CPU, only if the 
>> "NX" bits of all three level page tables are cleared (PAE is 
>> enabled), the corresponding page is executable (refer to section 
>> 4.13.2 of Intel 64 and IA-32 Architectures Software Developer's 
>> Manual).  So, the bug is fixed through clearing the "NX" bit of PMD 
>> when splitting the huge PMD.

oops, nice detail!

>> Signed-off-by: Huang Ying <ying.huang@intel.com>
>>
>> ---
>>  arch/x86/mm/pageattr.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> --- a/arch/x86/mm/pageattr.c
>> +++ b/arch/x86/mm/pageattr.c
>> @@ -124,6 +124,7 @@ static int split_large_page(pte_t *kpte,
>>  	/*
>>  	 * Install the new, split up pagetable:
>>  	 */
>> +	pgprot_val(ref_prot) &= ~_PAGE_NX;
>>   
>
> I don't think its a good idea to treat pgprot_val() as an lvalue - it 
> precludes it from being turned into an inline function.  I know there 
> are numerous other places which do, but we should avoid making it 
> worse.

applied it with the following cleanup from Thomas:

 static int split_large_page(pte_t *kpte, unsigned long address)
 {
-       pgprot_t ref_prot = pte_pgprot(pte_clrhuge(*kpte));
+       pgprot_t ref_prot;
...
+       ref_prot = pte_pgprot(pte_mkexec(pte_clrhuge(*kpte)));

i.e. it now goes through all the proper accessors.

	Ingo
