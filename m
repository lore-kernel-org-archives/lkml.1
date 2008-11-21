Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbYKUBQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbYKUBQf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 20:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbYKUBQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 20:16:26 -0500
Received: from gw.goop.org ([64.81.55.164]:55077 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755120AbYKUBQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 20:16:26 -0500
Message-ID: <49260BE7.1080909@goop.org>
Date: Thu, 20 Nov 2008 17:16:23 -0800
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
References: <patchbomb.1226603398@abulafia.goop.org>	<d103c0da2fa147ac31af.1226603428@abulafia.goop.org>	<20081120093506.GB6885@elte.hu> <492597B9.8070506@goop.org>	<m1y6ze87w6.fsf@frodo.ebiederm.org> <4925D762.6040406@goop.org> <m1prkpj3nl.fsf@frodo.ebiederm.org>
In-Reply-To: <m1prkpj3nl.fsf@frodo.ebiederm.org>
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
>   
>> The changes are spread over a number of patches, but the meat of it is in "xen:
>> route hardware irqs via Xen".  It turns out fairly simply, but perhaps its
>> because I've made a number of simplifying assumptions: interrupts are always
>> IOAPIC based, only using ACPI for routing, no MSI support yet.
>>
>> But it seems to me that the only time you really care that the irq isn't a gsi
>> is when programming a vector into the ioapics - you need to do a irq ->
>> ioapic/pin mapping anyway, so adding a irq -> gsi -> ioapic/pin map isn't all
>> that complex.
>>     
>
> It is hideous.  Been there and ripped out hundreds of lines of useless and problem
> causing code to get here.  It is especially bad when you do not identity map the first
> 16 gsi to linux irqs (the legacy isa irqs).
>   

Yes.  I made that concession too, and just reserved them as identity 
mapped legacy irqs.

> Yep.  And but the numbers we you should be beyond the range of the gsi's so there
> is no conflict.  Think of it an extension of how we identitly make the low 16 linux
> irqs.
>   

Yes, I suppose we can statically partition the irq space.  In fact the 
original 2.6.18-xen dom0 kernel does precisely that, but runs into 
limitations because of the compile-time limit on NR_IRQS in that 
kernel.  If we move to a purely dynamically allocated irq space, then 
having a sparse allocation if irqs becomes reasonable again, for msis 
and vectorless Xen interrupts.

>>  In a sense you can think
>> of the other Xen interrupt sources as being a bit like MSI, at least in as much
>> as they're not sourced from a GSI (but they go further and are not sourced from
>> an IOAPIC at all).
>>     
>
> MSI isn't sourced from an IOAPIC either.
>   

Right.

> The difference is that the xen sources are not delivered using vectors.  The cpu
> vector numbers we do hide and treat as an implementation detail.  And I am totally
> happy not going through the vector allocation path.
>   

Right.  And in the physical irq event channel case, the vector space is 
managed by Xen, so we need to use Xen to allocate the vector, then 
program that into the appropriate place in the ioapic.

> My gut feel says that you just want to use a different set of irq operations when
> doing Xen native and working with hardware interrupts.    I haven't seen the code so
> I don't know how you interact there.  Except in dom0 this is not a consideration so
> I don't how it is handled.
>   

Yeah.  In the domU case, where there's no physical interrupts, the Xen 
code completely avoids the ioapic/vector stuff, and directly converts an 
event channel into an irq.  Indeed, physical irq delivery is handled the 
same way; its just that the setup requires touching the ioapics to 
program the appropriate vector and bind it to an event channel.

    J
