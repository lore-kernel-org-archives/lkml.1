Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936323Ab0B0WEh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 17:04:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:32794 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936302Ab0B0WEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 17:04:36 -0500
Message-ID: <4B8995FB.9000908@kernel.org>
Date: Sat, 27 Feb 2010 14:00:27 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-tip-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       garyhade@us.ibm.com, iranna.ankad@in.ibm.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, trenn@suse.de
Subject: Re: [tip:x86/apic] x86: Fix out of order gsi -- add remap_ioapic_gsi_to_irq()
References: <4B882182.4030205@kernel.org>	<tip-519d637a93116ffbcd50e9e3f2591f41584f372c@git.kernel.org>	<20100227130113.GA18661@elte.hu> <m1y6ieo5zw.fsf@fess.ebiederm.org>	<4B897537.5050406@kernel.org> <m1zl2ue585.fsf@fess.ebiederm.org>
In-Reply-To: <m1zl2ue585.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2010 01:30 PM, Eric W. Biederman wrote:
> Yinghai Lu <yinghai@kernel.org> writes:
> 
>> the x3950 has strange gsi base 
>>
>> ACPI: IOAPIC (id[0x10] address[0xfecff000] gsi_base[0])
>> IOAPIC[0]: apic_id 16, version 0, address 0xfecff000, GSI 0-2
>> ACPI: IOAPIC (id[0x0f] address[0xfec00000] gsi_base[3])
>> IOAPIC[1]: apic_id 15, version 0, address 0xfec00000, GSI 3-38
>> ACPI: IOAPIC (id[0x0e] address[0xfec01000] gsi_base[39])
>> IOAPIC[2]: apic_id 14, version 0, address 0xfec01000, GSI 39-74
>>
>> and BIOS using INT_SRC_OVR to map back gsi  3 - 18 to irq 0 - 15
>>
>> ACPI: INT_SRC_OVR (bus 0 bus_irq 1 global_irq 4 dfl dfl)
>> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 5 dfl dfl)
>> ACPI: INT_SRC_OVR (bus 0 bus_irq 3 global_irq 6 dfl dfl)
>> ACPI: INT_SRC_OVR (bus 0 bus_irq 4 global_irq 7 dfl dfl)
>> ACPI: INT_SRC_OVR (bus 0 bus_irq 6 global_irq 9 dfl dfl)
>> ACPI: INT_SRC_OVR (bus 0 bus_irq 7 global_irq 10 dfl dfl)
>> ACPI: INT_SRC_OVR (bus 0 bus_irq 8 global_irq 11 low edge)
>> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 12 dfl dfl)
>> ACPI: INT_SRC_OVR (bus 0 bus_irq 12 global_irq 15 dfl dfl)
>> ACPI: INT_SRC_OVR (bus 0 bus_irq 13 global_irq 16 dfl dfl)
>> ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 17 low edge)
>> ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 18 dfl dfl)
>> if we dont have this patch to do the remap (swap some mapping between ioapic), and only assume irq = gsi,
>> the irq from first ioapic controller will be blocked.
> 
> Bah.  I was hoping Len Brown would have looked at this earlier.
> I just read through the relevant sections of the ACPI spec
> 1.0, 2.0 and 3.0 so I can understand what is really going on.
> 
> What the x3950 firmware does is stupid, and probably needs to be
> changed but it is in spec.
> 
> I see two issues here.
> - You broke x3950 by only initializing the first ioapic.
>   We should be able to fix that by having setup_IO_APIC_irqs
>   loop through all of the irqs and setup setup any irq with
>   pin_2_irq < 16.  It is fragile and out of spec to assume only
>   one ioapic will have all of the isa irqs connected to it.
>   Plus extending your loop should be simpler and less intrusive
>   patch than what you have posted.

then will have all irq_desc for ioapic stay with BSP node.

> 
>   Although I suspect your patch to find the boot_ioapic_idx is
>   good enough for now.
> 
> - The fact that our current code makes 3 gsis/irqs on the x3950 unusable.
>   This is the justification for the remapping and unless this is
>   also a regression I don't think we should fix this in the
>   current merge window.
> 
> acpi guarantees there will be a 1 to 1 mapping between gsi's and
> isa interrupts but it does not guarantee what that mapping will be.
> acpi also specified that interrupt source overrides will only be
> provided for the isa irqs.
> 
> linux irqs 0-15 must be the ISA irqs.
> 
> So to handle anything that is legitimate according to the acpi spec we
> do need a mapping between gsi and irqs. Grrrr.
> 
> Something like:
> 
> /* By default isa irqs are identity mapped to gsis */
> unsigned int isa_irq_to_gsi[16] = {
> 	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
> };
> 
> unsigned int gsi_to_irq(unsigned int gsi)
> {
> 	unsigned int irq = gsi + 16;
> 	unsigned int i;
> 	for (i = 0; i < 16; i++) {
> 		if (isa_irq_to_gsi[i] == gsi)
> 			irq = i;
> 	}
> 	return irq;
> }
> 
> unsigned int irq_to_gsi(unsigned int irq)
> {
> 	unsigned int gsi;
> 	if (irq < 16) {
> 		gsi = isa_irq_to_gsi[irq];
> 	} else {
>         	gsi = irq - 16;
>         }
>         return gsi;
> }
> 
> When we process the interrupt source overrides we just need to
> update the little isa_irq_to_gsi table.
> 
> I expect finding all of the places where we need to do a mapping
> for gsi number to irq numbers is going to take some time to do
> cleanly which suggests it is not a good idea for this merge window.
> 
> YH your current remapping patch looks like a pretty horrible hack
> instead of real solution to the problem.  I honestly think starting
> with it will just obscure what is going and make it harder to
> introduce a clean gsi_to_irq/irq_to_gsi.

good, the mapping looks much clear.

YH
