Return-Path: <linux-kernel-owner+w=401wt.eu-S1757181AbYKTTXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181AbYKTTXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 14:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756842AbYKTTWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 14:22:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33580 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756836AbYKTTWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 14:22:47 -0500
Date: Thu, 20 Nov 2008 20:22:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 30 of 38] xen: implement io_apic_ops
Message-ID: <20081120192218.GF3955@elte.hu>
References: <patchbomb.1226603398@abulafia.goop.org> <d103c0da2fa147ac31af.1226603428@abulafia.goop.org> <20081120093506.GB6885@elte.hu> <492597B9.8070506@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492597B9.8070506@goop.org>
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
>>> Writes to the IO APIC are paravirtualized via hypercalls, so implement
>>> the appropriate operations.
>>>
>>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>> ---
>>>  arch/x86/xen/Makefile    |    3 +-
>>>  arch/x86/xen/apic.c      |   66 ++++++++++++++++++++++++++++++++++++++++++++++
>>>  arch/x86/xen/enlighten.c |    2 +
>>>  arch/x86/xen/xen-ops.h   |    2 +
>>>  4 files changed, 72 insertions(+), 1 deletion(-)
>>>     
>>
>> hm, why is the ioapic used as the API here, and not an irqchip?
>>   
>
> In essence, the purpose of the series is to break the 1:1 
> relationship between Linux irqs and hardware GSIs.  This allows me 
> to have my own irq allocator, which in turn allows me to intermix 
> "physical" irqs (ie, a Linux irq number bound to a real hardware 
> interrupt source) with the various software/virtual irqs the Xen 
> system needs.
>
> Once a physical irq has been mapped onto a gsi interrupt source, the 
> mechanisms for handing the ioapic side of things are more or less 
> the same.  There's the same procedure of finding the ioapic/pin for 
> a gsi and programming the appropriate vector.
>
> (Presumably once I implement MSI support, all references to "gsi" 
> will become "gsi/msi/etc".)
>
> So, there's an awkward tradeoff.  I could just completely duplicate 
> the whole irq/vector/ioapic management code and hide it under my own 
> irqchip, but it would end up duplicating a lot of the existing code.  
> My alternative was to try to open out the existing code into 
> something like a thin ioapic library, which I can call into as 
> needed.  The only low-level difference is that the Xen ioapics need 
> to be programmed via a hypercall rather than register writes.
>
> If the x86 interrupt layer in general decouples irqs from GSIs, then 
> I can probably make use of that to clean things up.  A general irq 
> allocator along with some way of attaching interrupt-source-specific 
> information to each irq would get me a long way, I think.  I'd still 
> need hooks to paravirtualize the actual ioapic writes, but at least 
> I wouldn't need to have quite so much delicate hooking.

it certainly looks thin enough to me although i'm really not sure we 
want to virtualize at the IO-APIC level. Peter, what's your 
opinion/preference?

	Ingo
