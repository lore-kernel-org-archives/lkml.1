Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030741Ab0B0TmQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 14:42:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:48171 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030725Ab0B0TmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 14:42:14 -0500
Message-ID: <4B897537.5050406@kernel.org>
Date: Sat, 27 Feb 2010 11:40:39 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-tip-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       garyhade@us.ibm.com, iranna.ankad@in.ibm.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, trenn@suse.de
Subject: Re: [tip:x86/apic] x86: Fix out of order gsi -- add remap_ioapic_gsi_to_irq()
References: <4B882182.4030205@kernel.org>	<tip-519d637a93116ffbcd50e9e3f2591f41584f372c@git.kernel.org>	<20100227130113.GA18661@elte.hu> <m1y6ieo5zw.fsf@fess.ebiederm.org>
In-Reply-To: <m1y6ieo5zw.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2010 11:04 AM, Eric W. Biederman wrote:
> Ingo Molnar <mingo@elte.hu> writes:
> 
>> Causes:
>>
>>  arch/x86/kernel/apic/io_apic.c:1042: error: implicit declaration of function ?remap_ioapic_gsi_to_irq?
>>
>> Please send delta fix.
> 
> I am certain I have said this before but the entire concept of 
> irq != gsi is broken.  We used to have code that did this and it was a
> non-ending source of problems that we finally removed after we pushed
> up the limit on the number of irqs.
> 
> We already have the irq_2_pin list which allows for arbitrary mappings
> between irqs and the ioapics and pins.  So there should be no problem
> mapping irq to gsi and assigning irqs to arbitrary ioapic pins.
> 
> I have yet to see something that even purports to be an explanation
> of why our handling of acpi int_src_overrides is broken and why
> it needs the mess that is a remapper.
> 
> I don't doubt YHs changes fix something but this feels like a direction
> that trades off one bug for another instead of actually fixing the code.
> 
> It does look like we have weird old hard codes in some of the
> irq_2_pin and pin_2_irq paths that YH is touching, and it may make sense
> to introduce a concept of ioapic pin index.  
> 
> The touching of drivers/pnp/pnpacpi/rsparser.c feels like just the tip of
> the iceberg in dealing with weird bugs if we continue down this path.
> 

the x3950 has strange gsi base 

ACPI: IOAPIC (id[0x10] address[0xfecff000] gsi_base[0])
IOAPIC[0]: apic_id 16, version 0, address 0xfecff000, GSI 0-2
ACPI: IOAPIC (id[0x0f] address[0xfec00000] gsi_base[3])
IOAPIC[1]: apic_id 15, version 0, address 0xfec00000, GSI 3-38
ACPI: IOAPIC (id[0x0e] address[0xfec01000] gsi_base[39])
IOAPIC[2]: apic_id 14, version 0, address 0xfec01000, GSI 39-74

and BIOS using INT_SRC_OVR to map back gsi  3 - 18 to irq 0 - 15
ACPI: INT_SRC_OVR (bus 0 bus_irq 1 global_irq 4 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 5 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 3 global_irq 6 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 4 global_irq 7 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 6 global_irq 9 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 7 global_irq 10 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 8 global_irq 11 low edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 12 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 12 global_irq 15 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 13 global_irq 16 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 17 low edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 18 dfl dfl)
if we dont have this patch to do the remap (swap some mapping between ioapic), and only assume irq = gsi,

the irq from first ioapic controller will be blocked.

so far this patch only affect (fix ) x3950.

all other platform will all have boot_ioapic_idx's gsi_base == 0, 
the function will just still return gsi.

other solution will ask IBM to fix their bios, so we can get

ACPI: IOAPIC (id[0x10] address[0xfecff000] gsi_base[36])
IOAPIC[0]: apic_id 16, version 0, address 0xfecff000, GSI 36-38
ACPI: IOAPIC (id[0x0f] address[0xfec00000] gsi_base[0])
IOAPIC[1]: apic_id 15, version 0, address 0xfec00000, GSI 0-35
ACPI: IOAPIC (id[0x0e] address[0xfec01000] gsi_base[39])
IOAPIC[2]: apic_id 14, version 0, address 0xfec01000, GSI 39-74
then they don't need append that bunch of OVR.

Yinghai
