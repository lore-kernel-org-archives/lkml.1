Return-Path: <linux-kernel-owner+w=401wt.eu-S1752592AbYLYQVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbYLYQVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 11:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbYLYQVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 11:21:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50941 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbYLYQVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 11:21:22 -0500
Date: Thu, 25 Dec 2008 17:21:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joerg.roedel@amd.com>,
       Benjamin Serebrin <benjamin.serebrin@amd.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       Alexander Graf <agraf@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Re: kvm vmload/vmsave vs tss.ist
Message-ID: <20081225162107.GB14486@elte.hu>
References: <49539FD0.7070103@redhat.com> <20081225151757.GA25117@elte.hu> <4953AAE5.4000708@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4953AAE5.4000708@redhat.com>
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
>> i think we should actually do #1 unconditionally.
>>
>> ISTs are bad for the native kernel too. They have various nasty  
>> complications in the stack walker (and hence they _reduce_ reliability 
>> in practice), and they are non-preemptible as well. Plus we have the  
>> maximum-stack-footprint ftrace plugin now, which can remove any 
>> perception about how bad the worst-case stack footprint is in practice.
>>
>> If it ever becomes an issue we could also soft-switch to a larger (per  
>> CPU) exception stack from the exception handlers themselves. The  
>> architectural stack footprint of the various critical exceptions are  
>> calculatable and low - so we could switch away and get almost the kind 
>> of separation that ISTs give. There's no deep reason to actually make 
>> use of hw switched ISTs.
>>
>> So feel free to send a patch that just standardizes the critical  
>> exceptions to use the regular kernel stack. (I havent actually tried 
>> this but it should be relatively simple to implement. Roadblocks are 
>> possible.)
>>   
>
> Certainly.  There is provision for a debug stack that can be larger than 
> the normal exception stack.  This is used for vectors 1 and 3.  If we 
> wish to preserve this, we need to to manual stack switching.
>
> Currently DEBUG_STKSZ is 8K, the same as the normal stack (compared to 
> 4K for the other execption stacks).  Do we need to implement stack 
> switching for debug vectors?

i'd suggest to reuse the irq-stacks for this. Right now on 64-bit we've 
got the following stack layout: 8K process stacks, a 16K IRQ stack on each 
CPU, shared by all IRQs. Then we have the IST stacks with weird sizes: 
debug:8K, the others: 4K.

Then all the unnecessary IST complications can be removed. If nesting ever 
becomes an issue, the IRQ stack size can be doubled to 32K.

This way we save some small amount of RAM too (right now the IST stacks 
take up 28K of RAM per CPU), and reduce complexity and fragility quite 
visibly. And help KVM ;-)

	Ingo
