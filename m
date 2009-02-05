Return-Path: <linux-kernel-owner+w=401wt.eu-S1760978AbZBETLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760978AbZBETLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:11:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760174AbZBETLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:11:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42799 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760371AbZBETK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:10:59 -0500
Date: Thu, 5 Feb 2009 20:10:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: William Lee Irwin III <wli@holomorphy.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: pud_bad vs pud_bad
Message-ID: <20090205191017.GF20470@elte.hu>
References: <498B2EBC.60700@goop.org> <20090205184355.GF5661@elte.hu> <498B35F9.601@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498B35F9.601@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

> Ingo Molnar wrote:
>> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>
>>   
>>> I'm looking at unifying the 32 and 64-bit versions of pud_bad.
>>>
>>> 32-bits defines it as:
>>>
>>> static inline int pud_bad(pud_t pud)
>>> {
>>> 	return (pud_val(pud) & ~(PTE_PFN_MASK | _KERNPG_TABLE | _PAGE_USER)) != 0;
>>> }
>>>
>>> and 64 as:
>>>
>>> static inline int pud_bad(pud_t pud)
>>> {
>>> 	return (pud_val(pud) & ~(PTE_PFN_MASK | _PAGE_USER)) != _KERNPG_TABLE;
>>> }
>>>
>>>
>>> I'm inclined to go with the 64-bit version, but I'm wondering if 
>>> there's something subtle I'm missing here.
>>>     
>>
>> Why go with the 64-bit version? The 32-bit check looks more compact and 
>> should result in smaller code.
>>   
>
> Well, its stricter.  But I don't really understand what condition its  
> actually testing for.

Well it tests: "beyond the bits covered by PTE_PFN|_PAGE_USER, the rest 
must only be _KERNPG_TABLE".

The _KERNPG_TABLE bits are disjunct from PTE_PFN|_PAGE_USER bits, so this 
makes sense.

But the 32-bit check does the exact same thing but via a single binary 
operation: it checks whether any bits outside of those bits are zero - just 
via a simpler test that compiles to more compact code.

So i'd go with the 32-bit version. (unless there are some sign-extension 
complications i'm missing - but i think we got rid of those already.)

	Ingo
