Return-Path: <linux-kernel-owner+w=401wt.eu-S1755504AbYLYSTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbYLYSTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 13:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbYLYSSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 13:18:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57365 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939AbYLYSSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 13:18:30 -0500
Date: Thu, 25 Dec 2008 19:18:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joerg.roedel@amd.com>,
       Benjamin Serebrin <benjamin.serebrin@amd.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       Alexander Graf <agraf@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Re: kvm vmload/vmsave vs tss.ist
Message-ID: <20081225181810.GA1548@elte.hu>
References: <49539FD0.7070103@redhat.com> <20081225151757.GA25117@elte.hu> <4953AAE5.4000708@redhat.com> <20081225162107.GB14486@elte.hu> <20081225164232.GA25195@elte.hu> <4953C57F.70502@redhat.com> <20081225175821.GA23390@elte.hu> <4953CD1A.5090906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4953CD1A.5090906@redhat.com>
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
>>> I think it's enough to switch %rsp before incrementing irqcount, no?
>>>     
>>
>> no - that would introduce a small race: if an exception (say an NMI or  
>> MCE, or a debug trap) happens in that small window then the exception  
>> context thinks that it's on the IRQ stack already, and would use the 
>> task stack.
>>
>>   
>
> I'm suggesting
>
>    check irqcount
>    if (wasnt_in_irq)
>        rsp = irqstack
>    ++irqcount
>
> If the NMI happens before the increment, we'll switch the stack 
> unconditionally, and if the NMI happens after the increment, then we 
> won't switch the stack, but we're guaranteed to be on the irqstack 
> anyway.  The window size is negative :)
>
> Similarly, the exit path should be
>
>    oldstack_reg = oldstack;
>    --irqcount;
>    rsp = oldstack_register;
>
> To guarantee that by the time we decrement irqcount, we don't need the  
> stack anymore.

agreed, something like this would work too. My suggestion, to eliminate 
irqcount altogether and just check RSP against the known-irqstack-range, 
could result in slightly smaller (and thus faster) code, but it's a 
marginal difference at best.

	Ingo
