Return-Path: <linux-kernel-owner+w=401wt.eu-S1764185AbYEVWKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764185AbYEVWKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757557AbYEVWKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:10:39 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:48427 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757545AbYEVWKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:10:37 -0400
Message-ID: <4835EF80.7080901@suse.de>
Date: Fri, 23 May 2008 02:11:12 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] x86: move mp_bus_not_pci from mpparse.c
References: <20080519154656.15071.96979.stgit@thinkpad> <20080519154715.15071.44328.stgit@thinkpad> <alpine.LFD.1.10.0805222351400.3295@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0805222351400.3295@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this is the output from cscope:
C symbol: mp_bus_not_pci

  File         Function                   Line
0 io_apic_32.c <global>                     88 DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
1 io_apic_64.c <global>                    120 DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
2 mpspec.h     <global>                     33 extern DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
3 boot.c       mp_config_acpi_legacy_irqs  995 set_bit(MP_ISA_BUS, mp_bus_not_pci);
4 io_apic_32.c find_isa_irq_pin            829 if (test_bit(lbus, mp_bus_not_pci) &&
5 io_apic_32.c find_isa_irq_apic           845 if (test_bit(lbus, mp_bus_not_pci) &&
6 io_apic_32.c IO_APIC_get_PCI_irq_vector  873 if (test_bit(bus, mp_bus_not_pci)) {
7 io_apic_32.c IO_APIC_get_PCI_irq_vector  885 if (!test_bit(lbus, mp_bus_not_pci) &&
8 io_apic_32.c MPBIOS_polarity             988 polarity = test_bit(bus, mp_bus_not_pci)?
9 io_apic_32.c MPBIOS_trigger             1031 trigger = test_bit(bus, mp_bus_not_pci)?
a io_apic_32.c pin_2_irq                  1114 if (test_bit(bus, mp_bus_not_pci))
b io_apic_64.c find_isa_irq_pin            481 if (test_bit(lbus, mp_bus_not_pci) &&
c io_apic_64.c find_isa_irq_apic           497 if (test_bit(lbus, mp_bus_not_pci) &&
d io_apic_64.c IO_APIC_get_PCI_irq_vector  525 if (test_bit(bus, mp_bus_not_pci)) {
e io_apic_64.c IO_APIC_get_PCI_irq_vector  537 if (!test_bit(lbus, mp_bus_not_pci) &&
f io_apic_64.c MPBIOS_polarity             583 if (test_bit(bus, mp_bus_not_pci))
g io_apic_64.c MPBIOS_trigger              625 if (test_bit(bus, mp_bus_not_pci))
h io_apic_64.c pin_2_irq                   677 if (test_bit(bus, mp_bus_not_pci)) {
i mpparse.c    MP_bus_info                 106 set_bit(m->mpc_busid, mp_bus_not_pci);
j mpparse.c    MP_bus_info                 114 clear_bit(m->mpc_busid, mp_bus_not_pci);

Do you still claim io_apic has no association with mp_bus_not_pci?

Regards,
Alex.

Thomas Gleixner wrote:
> On Mon, 19 May 2008, Alexey Starikovskiy wrote:
> 
>> +++ b/arch/x86/kernel/io_apic_32.c
>> @@ -81,6 +81,12 @@ struct mp_config_intsrc mp_irqs[MAX_IRQ_SOURCES];
>>  /* # of MP IRQ source entries */
>>  int mp_irq_entries;
>>  
>> +#if defined (CONFIG_MCA) || defined (CONFIG_EISA)
>> +int mp_bus_id_to_type[MAX_MP_BUSSES];
>> +#endif
>> +
>> +DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
>> +
> 
>> +++ b/arch/x86/kernel/io_apic_64.c
>> @@ -117,6 +117,8 @@ struct mp_config_intsrc mp_irqs[MAX_IRQ_SOURCES];
>>  /* # of MP IRQ source entries */
>>  int mp_irq_entries;
>>  
>> +DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
>> +
> 
> NAK for the whole series. If you want to move out stuff from mpparse,
> then please look for a useful place, which is
> 
> 1) related to the code (mp_bus_not_pci has no obvious association to
> io_apic)
> 
> 2) not duplicating code into 32/64 bit files again. We work hard on
> unifying and also distangling things and I refuse to accept a patch
> which moves code to a random place where it happens to compile.
> 
> Thanks,
> 
> 	tglx

