Return-Path: <linux-kernel-owner+w=401wt.eu-S1752640AbYLYR67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbYLYR67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 12:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbYLYR6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 12:58:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46488 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbYLYR6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 12:58:35 -0500
Date: Thu, 25 Dec 2008 18:58:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joerg.roedel@amd.com>,
       Benjamin Serebrin <benjamin.serebrin@amd.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       Alexander Graf <agraf@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Re: kvm vmload/vmsave vs tss.ist
Message-ID: <20081225175821.GA23390@elte.hu>
References: <49539FD0.7070103@redhat.com> <20081225151757.GA25117@elte.hu> <4953AAE5.4000708@redhat.com> <20081225162107.GB14486@elte.hu> <20081225164232.GA25195@elte.hu> <4953C57F.70502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4953C57F.70502@redhat.com>
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


* Avi Kivity <avi@redhat.com> wrote:

> Ingo Molnar wrote:
>> * Ingo Molnar <mingo@elte.hu> wrote:
>>
>>   
>>> i'd suggest to reuse the irq-stacks for this. Right now on 64-bit 
>>> we've got the following stack layout: 8K process stacks, a 16K IRQ 
>>> stack on each CPU, shared by all IRQs. Then we have the IST stacks 
>>> with weird sizes: debug:8K, the others: 4K.
>>>     
>>
>> this has to be done carefully though, as there's a subtle detail here:  
>> right now the pda_irqcount and the pda_irqstackptr logic in entry_64.S 
>> is not re-entry safe and relies on IRQs being off.
>>
>> If critical exceptions are moved to the IRQ stack then %rsp switching 
>> to the IRQ stack has to be done atomically: instead of using the 
>> pda_irqcount check the %rsp value itself should be checked against 
>> pda_irqstackptr - if it's within that 16K range then we are already on 
>> the IRQ stack and do not need to switch to it but can just use the 
>> current %rsp.
>>   
>
> I think it's enough to switch %rsp before incrementing irqcount, no?

no - that would introduce a small race: if an exception (say an NMI or 
MCE, or a debug trap) happens in that small window then the exception 
context thinks that it's on the IRQ stack already, and would use the task 
stack.

So if we want to move them to IRQ stacks all the time, we have to check 
that condition atomically - the safest way of which is to check RSP 
against the (static) pda:[irqstackptr-16K+64..irqstackptr] range.

	Ingo
