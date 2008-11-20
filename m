Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbYKTVcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbYKTVcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 16:32:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755185AbYKTVcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 16:32:22 -0500
Received: from gw.goop.org ([64.81.55.164]:44658 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807AbYKTVcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 16:32:21 -0500
Message-ID: <4925D762.6040406@goop.org>
Date: Thu, 20 Nov 2008 13:32:18 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 30 of 38] xen: implement io_apic_ops
References: <patchbomb.1226603398@abulafia.goop.org>	<d103c0da2fa147ac31af.1226603428@abulafia.goop.org>	<20081120093506.GB6885@elte.hu> <492597B9.8070506@goop.org> <m1y6ze87w6.fsf@frodo.ebiederm.org>
In-Reply-To: <m1y6ze87w6.fsf@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>
>   
>> Ingo Molnar wrote:
>>     
>>> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>>
>>>
>>>       
>>>> Writes to the IO APIC are paravirtualized via hypercalls, so implement
>>>> the appropriate operations.
>>>>
>>>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>>> ---
>>>>  arch/x86/xen/Makefile    |    3 +-
>>>> arch/x86/xen/apic.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++
>>>>  arch/x86/xen/enlighten.c |    2 +
>>>>  arch/x86/xen/xen-ops.h   |    2 +
>>>>  4 files changed, 72 insertions(+), 1 deletion(-)
>>>>
>>>>         
>>> hm, why is the ioapic used as the API here, and not an irqchip?
>>>
>>>       
>> In essence, the purpose of the series is to break the 1:1 relationship between
>> Linux irqs and hardware GSIs.
>>     
>
> Bad idea (I think).  We have a 1:1 relationship between the linux irq number and
> the GSI because it makes the code dramatically simpler, and it took significant
> work to get there.  The concept of an intermediate mapping layer sounds nasty.
> But I haven't yet read the patch.
>   

The changes are spread over a number of patches, but the meat of it is 
in "xen: route hardware irqs via Xen".  It turns out fairly simply, but 
perhaps its because I've made a number of simplifying assumptions: 
interrupts are always IOAPIC based, only using ACPI for routing, no MSI 
support yet.

But it seems to me that the only time you really care that the irq isn't 
a gsi is when programming a vector into the ioapics - you need to do a 
irq -> ioapic/pin mapping anyway, so adding a irq -> gsi -> ioapic/pin 
map isn't all that complex.  And conversely, when probing devices you 
need to map gsi->irq to see whether the interrupt is shared, though you 
could do that on a pure gsi level anyway.

And of course the current code isn't purely irq == gsi anyway, since 
msis are allocated irqs as well, and there's no underlying gsi.  In a 
sense you can think of the other Xen interrupt sources as being a bit 
like MSI, at least in as much as they're not sourced from a GSI (but 
they go further and are not sourced from an IOAPIC at all).

    J
