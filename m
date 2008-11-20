Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbYKTRAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbYKTRAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 12:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbYKTRAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 12:00:43 -0500
Received: from gw.goop.org ([64.81.55.164]:51980 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbYKTRAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 12:00:43 -0500
Message-ID: <492597B9.8070506@goop.org>
Date: Thu, 20 Nov 2008 09:00:41 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 30 of 38] xen: implement io_apic_ops
References: <patchbomb.1226603398@abulafia.goop.org> <d103c0da2fa147ac31af.1226603428@abulafia.goop.org> <20081120093506.GB6885@elte.hu>
In-Reply-To: <20081120093506.GB6885@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Writes to the IO APIC are paravirtualized via hypercalls, so implement
>> the appropriate operations.
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>> ---
>>  arch/x86/xen/Makefile    |    3 +-
>>  arch/x86/xen/apic.c      |   66 ++++++++++++++++++++++++++++++++++++++++++++++
>>  arch/x86/xen/enlighten.c |    2 +
>>  arch/x86/xen/xen-ops.h   |    2 +
>>  4 files changed, 72 insertions(+), 1 deletion(-)
>>     
>
> hm, why is the ioapic used as the API here, and not an irqchip?
>   

In essence, the purpose of the series is to break the 1:1 relationship 
between Linux irqs and hardware GSIs.  This allows me to have my own irq 
allocator, which in turn allows me to intermix "physical" irqs (ie, a 
Linux irq number bound to a real hardware interrupt source) with the 
various software/virtual irqs the Xen system needs.

Once a physical irq has been mapped onto a gsi interrupt source, the 
mechanisms for handing the ioapic side of things are more or less the 
same.  There's the same procedure of finding the ioapic/pin for a gsi 
and programming the appropriate vector.

(Presumably once I implement MSI support, all references to "gsi" will 
become "gsi/msi/etc".)

So, there's an awkward tradeoff.  I could just completely duplicate the 
whole irq/vector/ioapic management code and hide it under my own 
irqchip, but it would end up duplicating a lot of the existing code.  My 
alternative was to try to open out the existing code into something like 
a thin ioapic library, which I can call into as needed.  The only 
low-level difference is that the Xen ioapics need to be programmed via a 
hypercall rather than register writes.

If the x86 interrupt layer in general decouples irqs from GSIs, then I 
can probably make use of that to clean things up.  A general irq 
allocator along with some way of attaching interrupt-source-specific 
information to each irq would get me a long way, I think.  I'd still 
need hooks to paravirtualize the actual ioapic writes, but at least I 
wouldn't need to have quite so much delicate hooking.

Thanks,
    J
