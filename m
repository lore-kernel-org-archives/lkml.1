Return-Path: <linux-kernel-owner+w=401wt.eu-S1760643AbYBPUfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760643AbYBPUfi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 15:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbYBPUfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 15:35:14 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58621 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756541AbYBPUfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 15:35:04 -0500
Message-ID: <47B748EE.8020100@sgi.com>
Date: Sat, 16 Feb 2008 12:34:54 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, Christoph Lameter <clameter@sgi.com>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: 2.6.24 git2/mm1: cpu_to_node mapping to non-existant nodes causing
 boot failure
References: <20080203171634.58ab668b.akpm@linux-foundation.org> <20080213175241.GA327@csn.ul.ie> <47B33ACF.5030700@sgi.com> <20080214201727.GC30841@csn.ul.ie> <47B4A774.7050509@sgi.com> <20080215020208.GA6500@csn.ul.ie>
In-Reply-To: <20080215020208.GA6500@csn.ul.ie>
Content-Type: multipart/mixed;
 boundary="------------060104020707030509000903"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060104020707030509000903
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Well, after lot's of aggravation I finally got the dusty old
numa box to boot up, and the upstream linux-2.6 kernel works fine.
(I've attached the startup log showing 8 cores on 4 nodes.)

The big difference appears in where memory is located.  Your
box has all the memory on node 0 where my box has memory on
all the nodes...

>From the working log:

SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 1 -> APIC 2 -> Node 1
SRAT: PXM 1 -> APIC 3 -> Node 1
SRAT: PXM 2 -> APIC 4 -> Node 2
SRAT: PXM 2 -> APIC 5 -> Node 2
SRAT: PXM 3 -> APIC 6 -> Node 3
SRAT: PXM 3 -> APIC 7 -> Node 3
SRAT: Node 0 PXM 0 0-a0000
SRAT: Node 0 PXM 0 0-e4000000
SRAT: Node 0 PXM 0 0-200000000
SRAT: Node 1 PXM 1 200000000-400000000
SRAT: Node 2 PXM 2 400000000-600000000
SRAT: Node 3 PXM 3 600000000-800000000

>From the failing log:

SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 1 -> APIC 2 -> Node 1
SRAT: PXM 1 -> APIC 3 -> Node 1
SRAT: Node 0 PXM 0 0-40000000

The message that cpu's 2 & 3 having no node is therefore misleading, it
should say that cpu's 2 & 3 have no "node local memory".  But other
than that, it should allocate the PERCPU memory on node 0 and
everything's fine.

Apparently then the only way to debug this is to fake a setup where
some cpus have no node local memory and go from there.  Unfortunately,
the box I'm testing on has no working remote access.  I'll see if I
can't fake it out on a non-numa box until the lab is back open on Tuesday.

Thanks,
Mike

Mel Gorman wrote:
> On (14/02/08 12:41), Mike Travis didst pronounce:
>> Mel Gorman wrote:
...
>>>>
>>> According to git-bisect, the problem patch is below. It doesn't back out
>>> cleanly so I haven't verified for sure the bisect is correct yet.
>> This might make sense.  This code is in preparation for the extended
>> apic's available on the new processors.  I've tested the code with
>> our simulator (with no errors) and I'm setting up to test on a real
>> machine that has multiple numa nodes.  I wonder if maybe BIOS is not
>> providing correct node data, or the ACPI parsing is in error?  You
>> might try adding "apic=debug" to the boot command line.
>>
> 
> I tried this, but the dmesg complained about a malformed option. I'll
> check out why tomorrow but it didn't appear particularly helpful.
> 
>> For the short term, we can remove this patch if it's causing the
>> problem.  A more complete patch will be available soon that contains
>> the entire set of x2apic changes.
>>
> 
> If you send me patches to apply on top of 2.6.25-rc1, I'll give them a spin
> on the machine in question. Reverting didn't work out very well as there are
> too many collisions with patches that were applied later. I eventually got
> the machine booting but it only succeeds because it only brings up one core
> on each processor.  The patch, which is pretty brain damaged is below in case
> it helps you guess what the real problem is. dmesg logs are attached of the
> vanilla failure with acpi=debug and the log with the patch applied showing
> "__cpu_up: bad cpu 1" and "__cpu_up: bad cpu3" (i.e. the second cores of
> each machine).
> 
> 
> diff -ru linux-2.6/arch/x86/kernel/genapic_64.c linux-2.6-working/arch/x86/kernel/genapic_64.c
> --- linux-2.6/arch/x86/kernel/genapic_64.c	2008-02-14 16:32:55.000000000 -0600
> +++ linux-2.6-working/arch/x86/kernel/genapic_64.c	2008-02-14 15:46:18.000000000 -0600
> @@ -25,10 +25,10 @@
>  #endif
>  
>  /* which logical CPU number maps to which CPU (physical APIC ID) */
> -u16 x86_cpu_to_apicid_init[NR_CPUS] __initdata
> +u8 x86_cpu_to_apicid_init[NR_CPUS] __initdata
>  					= { [0 ... NR_CPUS-1] = BAD_APICID };
>  void *x86_cpu_to_apicid_early_ptr;
> -DEFINE_PER_CPU(u16, x86_cpu_to_apicid) = BAD_APICID;
> +DEFINE_PER_CPU(u8, x86_cpu_to_apicid) = BAD_APICID;
>  EXPORT_PER_CPU_SYMBOL(x86_cpu_to_apicid);
>  
>  struct genapic __read_mostly *genapic = &apic_flat;
> diff -ru linux-2.6/arch/x86/kernel/mpparse_64.c linux-2.6-working/arch/x86/kernel/mpparse_64.c
> --- linux-2.6/arch/x86/kernel/mpparse_64.c	2008-02-14 16:32:55.000000000 -0600
> +++ linux-2.6-working/arch/x86/kernel/mpparse_64.c	2008-02-14 15:45:44.000000000 -0600
> @@ -67,7 +67,7 @@
>  /* Bitmask of physically existing CPUs */
>  physid_mask_t phys_cpu_present_map = PHYSID_MASK_NONE;
>  
> -u16 x86_bios_cpu_apicid_init[NR_CPUS] __initdata
> +u8 x86_bios_cpu_apicid_init[NR_CPUS] __initdata
>  				= { [0 ... NR_CPUS-1] = BAD_APICID };
>  void *x86_bios_cpu_apicid_early_ptr;
>  DEFINE_PER_CPU(u16, x86_bios_cpu_apicid) = BAD_APICID;
> diff -ru linux-2.6/include/asm-x86/smp_64.h linux-2.6-working/include/asm-x86/smp_64.h
> --- linux-2.6/include/asm-x86/smp_64.h	2008-02-14 16:33:04.000000000 -0600
> +++ linux-2.6-working/include/asm-x86/smp_64.h	2008-02-14 15:43:01.000000000 -0600
> @@ -26,15 +26,16 @@
>  extern int smp_call_function_mask(cpumask_t mask, void (*func)(void *),
>  				  void *info, int wait);
>  
> -extern u16 __initdata x86_cpu_to_apicid_init[];
> -extern u16 __initdata x86_bios_cpu_apicid_init[];
> +extern u8 __initdata x86_cpu_to_apicid_init[];
> +extern u8 __initdata x86_bios_cpu_apicid_init[];
>  extern void *x86_cpu_to_apicid_early_ptr;
>  extern void *x86_bios_cpu_apicid_early_ptr;
> +DECLARE_PER_CPU(u8, x86_cpu_to_apicid); /* physical ID */
> +extern u8 bios_cpu_apicid[];
>  
>  DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
>  DECLARE_PER_CPU(cpumask_t, cpu_core_map);
>  DECLARE_PER_CPU(u16, cpu_llc_id);
> -DECLARE_PER_CPU(u16, x86_cpu_to_apicid);
>  DECLARE_PER_CPU(u16, x86_bios_cpu_apicid);
>  
>  static inline int cpu_present_to_apicid(int mps_cpu)
> 
> 



--------------060104020707030509000903
Content-Type: text/plain;
 name="test-2.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="test-2.txt"

Linux version 2.6.25-rc1-defconfig-00075-g10270d4-dirty (travis@polaris-admin) (gcc version 4.2.0) #2 SMP Thu Feb 14 14:41:12 PST 2008
Command line: root=/dev/sda2 splash=silent console=tty0 resume=/dev/sda1 apic=debug loglevel=8
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 0000000000099c00 (usable)
 BIOS-e820: 0000000000099c00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000e3f70000 (usable)
 BIOS-e820: 00000000e3f70000 - 00000000e3f77000 (ACPI data)
 BIOS-e820: 00000000e3f77000 - 00000000e3f80000 (ACPI NVS)
 BIOS-e820: 00000000e3f80000 - 00000000e4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec00400 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000800000000 (usable)
Malformed early option 'loglevel'
Entering add_active_range(0, 0, 153) 0 entries of 3200 used
Entering add_active_range(0, 256, 933744) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 8388608) 2 entries of 3200 used
end_pfn_map = 8388608
DMI present.
ACPI: RSDP 000F7820, 0024 (r2 PTLTD )
ACPI: XSDT E3F719E5, 005C (r1 PTLTD  	 XSDT    6040000  LTP        0)
ACPI: FACP E3F76AB0, 00F4 (r3 NWS    3U4P      6040000 PTEC    F4240)
ACPI: DSDT E3F71A41, 4FFB (r1   NWS      3U4P  6040000 MSFT  100000E)
ACPI: FACS E3F7FFC0, 0040
ACPI: HPET E3F76BA4, 0038 (r1 NWS    3U4P      6040000 PTEC        0)
ACPI: APIC E3F76BDC, 00FA (r1 PTLTD  	 APIC    6040000  LTP        0)
ACPI: SPCR E3F76CD6, 0050 (r1 PTLTD  $UCRTBL$  6040000 PTL         1)
ACPI: SSDT E3F76D26, 009D (r1 NWS    NEWISYS   6040000  LTP        1)
ACPI: SSDT E3F76DC3, 009D (r1 NWS    NEWISYS   6040000  LTP        1)
ACPI: SRAT E3F76E60, 01A0 (r1 NWS    3U4P      6040000 NWS         1)
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 1 -> APIC 2 -> Node 1
SRAT: PXM 1 -> APIC 3 -> Node 1
SRAT: PXM 2 -> APIC 4 -> Node 2
SRAT: PXM 2 -> APIC 5 -> Node 2
SRAT: PXM 3 -> APIC 6 -> Node 3
SRAT: PXM 3 -> APIC 7 -> Node 3
SRAT: Node 0 PXM 0 0-a0000
Entering add_active_range(0, 0, 153) 0 entries of 3200 used
SRAT: Node 0 PXM 0 0-e4000000
Entering add_active_range(0, 0, 153) 1 entries of 3200 used
Entering add_active_range(0, 256, 933744) 1 entries of 3200 used
SRAT: Node 0 PXM 0 0-200000000
Entering add_active_range(0, 0, 153) 2 entries of 3200 used
Entering add_active_range(0, 256, 933744) 2 entries of 3200 used
Entering add_active_range(0, 1048576, 2097152) 2 entries of 3200 used
SRAT: Node 1 PXM 1 200000000-400000000
Entering add_active_range(1, 2097152, 4194304) 3 entries of 3200 used
SRAT: Node 2 PXM 2 400000000-600000000
Entering add_active_range(2, 4194304, 6291456) 4 entries of 3200 used
SRAT: Node 3 PXM 3 600000000-800000000
Entering add_active_range(3, 6291456, 8388608) 5 entries of 3200 used
NUMA: Using 33 for the hash shift.
Bootmem setup node 0 0000000000000000-0000000200000000
  NODE_DATA [0000000000029000 - 000000000002ffff]
  bootmap [0000000000030000 -  000000000006ffff] pages 40
Bootmem setup node 1 0000000200000000-0000000400000000
  NODE_DATA [0000000200000000 - 0000000200006fff]
  bootmap [0000000200007000 -  0000000200046fff] pages 40
Bootmem setup node 2 0000000400000000-0000000600000000
  NODE_DATA [0000000400000000 - 0000000400006fff]
  bootmap [0000000400007000 -  0000000400046fff] pages 40
Bootmem setup node 3 0000000600000000-0000000800000000
  NODE_DATA [0000000600000000 - 0000000600006fff]
  bootmap [0000000600007000 -  0000000600046fff] pages 40
early res: 0 [0-fff] BIOS data page
early res: 1 [6000-7fff] SMP_TRAMPOLINE
early res: 2 [200000-8bcfe7] TEXT DATA BSS
early res: 3 [99c00-9cbff] EBDA
early res: 4 [8000-28fff] PGTABLE
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
 [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
 [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
 [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
 [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002e00000 on node 0
 [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003200000 on node 0
 [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003600000 on node 0
 [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003a00000 on node 0
 [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003e00000 on node 0
 [ffffe20001800000-ffffe200019fffff] PMD ->ffff810004200000 on node 0
 [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810004600000 on node 0
 [ffffe20001c00000-ffffe20001dfffff] PMD ->ffff810004a00000 on node 0
 [ffffe20001e00000-ffffe20001ffffff] PMD ->ffff810004e00000 on node 0
 [ffffe20002000000-ffffe200021fffff] PMD ->ffff810005200000 on node 0
 [ffffe20002200000-ffffe200023fffff] PMD ->ffff810005600000 on node 0
 [ffffe20002400000-ffffe200025fffff] PMD ->ffff810005a00000 on node 0
 [ffffe20002600000-ffffe200027fffff] PMD ->ffff810005e00000 on node 0
 [ffffe20002800000-ffffe200029fffff] PMD ->ffff810006200000 on node 0
 [ffffe20002a00000-ffffe20002bfffff] PMD ->ffff810006600000 on node 0
 [ffffe20002c00000-ffffe20002dfffff] PMD ->ffff810006a00000 on node 0
 [ffffe20002e00000-ffffe20002ffffff] PMD ->ffff810006e00000 on node 0
 [ffffe20003000000-ffffe200031fffff] PMD ->ffff810007200000 on node 0
 [ffffe20003200000-ffffe200033fffff] PMD ->ffff810007600000 on node 0
 [ffffe20003800000-ffffe200039fffff] PMD ->ffff810007a00000 on node 0
 [ffffe20003a00000-ffffe20003bfffff] PMD ->ffff810007e00000 on node 0
 [ffffe20003c00000-ffffe20003dfffff] PMD ->ffff810008200000 on node 0
 [ffffe20003e00000-ffffe20003ffffff] PMD ->ffff810008600000 on node 0
 [ffffe20004000000-ffffe200041fffff] PMD ->ffff810008a00000 on node 0
 [ffffe20004200000-ffffe200043fffff] PMD ->ffff810008e00000 on node 0
 [ffffe20004400000-ffffe200045fffff] PMD ->ffff810009200000 on node 0
 [ffffe20004600000-ffffe200047fffff] PMD ->ffff810009600000 on node 0
 [ffffe20004800000-ffffe200049fffff] PMD ->ffff810009a00000 on node 0
 [ffffe20004a00000-ffffe20004bfffff] PMD ->ffff810009e00000 on node 0
 [ffffe20004c00000-ffffe20004dfffff] PMD ->ffff81000a200000 on node 0
 [ffffe20004e00000-ffffe20004ffffff] PMD ->ffff81000a600000 on node 0
 [ffffe20005000000-ffffe200051fffff] PMD ->ffff81000aa00000 on node 0
 [ffffe20005200000-ffffe200053fffff] PMD ->ffff81000ae00000 on node 0
 [ffffe20005400000-ffffe200055fffff] PMD ->ffff81000b200000 on node 0
 [ffffe20005600000-ffffe200057fffff] PMD ->ffff81000b600000 on node 0
 [ffffe20005800000-ffffe200059fffff] PMD ->ffff81000ba00000 on node 0
 [ffffe20005a00000-ffffe20005bfffff] PMD ->ffff81000be00000 on node 0
 [ffffe20005c00000-ffffe20005dfffff] PMD ->ffff81000c200000 on node 0
 [ffffe20005e00000-ffffe20005ffffff] PMD ->ffff81000c600000 on node 0
 [ffffe20006000000-ffffe200061fffff] PMD ->ffff81000ca00000 on node 0
 [ffffe20006200000-ffffe200063fffff] PMD ->ffff81000ce00000 on node 0
 [ffffe20006400000-ffffe200065fffff] PMD ->ffff81000d200000 on node 0
 [ffffe20006600000-ffffe200067fffff] PMD ->ffff81000d600000 on node 0
 [ffffe20006800000-ffffe200069fffff] PMD ->ffff81000da00000 on node 0
 [ffffe20006a00000-ffffe20006bfffff] PMD ->ffff81000de00000 on node 0
 [ffffe20006c00000-ffffe20006dfffff] PMD ->ffff81000e200000 on node 0
 [ffffe20006e00000-ffffe20006ffffff] PMD ->ffff81000e600000 on node 0
 [ffffe20007000000-ffffe200071fffff] PMD ->ffff810200200000 on node 1
 [ffffe20007200000-ffffe200073fffff] PMD ->ffff810200400000 on node 1
 [ffffe20007400000-ffffe200075fffff] PMD ->ffff810200600000 on node 1
 [ffffe20007600000-ffffe200077fffff] PMD ->ffff810200800000 on node 1
 [ffffe20007800000-ffffe200079fffff] PMD ->ffff810200a00000 on node 1
 [ffffe20007a00000-ffffe20007bfffff] PMD ->ffff810200c00000 on node 1
 [ffffe20007c00000-ffffe20007dfffff] PMD ->ffff810200e00000 on node 1
 [ffffe20007e00000-ffffe20007ffffff] PMD ->ffff810201000000 on node 1
 [ffffe20008000000-ffffe200081fffff] PMD ->ffff810201200000 on node 1
 [ffffe20008200000-ffffe200083fffff] PMD ->ffff810201400000 on node 1
 [ffffe20008400000-ffffe200085fffff] PMD ->ffff810201600000 on node 1
 [ffffe20008600000-ffffe200087fffff] PMD ->ffff810201800000 on node 1
 [ffffe20008800000-ffffe200089fffff] PMD ->ffff810201a00000 on node 1
 [ffffe20008a00000-ffffe20008bfffff] PMD ->ffff810201c00000 on node 1
 [ffffe20008c00000-ffffe20008dfffff] PMD ->ffff810201e00000 on node 1
 [ffffe20008e00000-ffffe20008ffffff] PMD ->ffff810202000000 on node 1
 [ffffe20009000000-ffffe200091fffff] PMD ->ffff810202200000 on node 1
 [ffffe20009200000-ffffe200093fffff] PMD ->ffff810202400000 on node 1
 [ffffe20009400000-ffffe200095fffff] PMD ->ffff810202600000 on node 1
 [ffffe20009600000-ffffe200097fffff] PMD ->ffff810202800000 on node 1
 [ffffe20009800000-ffffe200099fffff] PMD ->ffff810202a00000 on node 1
 [ffffe20009a00000-ffffe20009bfffff] PMD ->ffff810202c00000 on node 1
 [ffffe20009c00000-ffffe20009dfffff] PMD ->ffff810202e00000 on node 1
 [ffffe20009e00000-ffffe20009ffffff] PMD ->ffff810203000000 on node 1
 [ffffe2000a000000-ffffe2000a1fffff] PMD ->ffff810203200000 on node 1
 [ffffe2000a200000-ffffe2000a3fffff] PMD ->ffff810203400000 on node 1
 [ffffe2000a400000-ffffe2000a5fffff] PMD ->ffff810203600000 on node 1
 [ffffe2000a600000-ffffe2000a7fffff] PMD ->ffff810203800000 on node 1
 [ffffe2000a800000-ffffe2000a9fffff] PMD ->ffff810203a00000 on node 1
 [ffffe2000aa00000-ffffe2000abfffff] PMD ->ffff810203c00000 on node 1
 [ffffe2000ac00000-ffffe2000adfffff] PMD ->ffff810203e00000 on node 1
 [ffffe2000ae00000-ffffe2000affffff] PMD ->ffff810204000000 on node 1
 [ffffe2000b000000-ffffe2000b1fffff] PMD ->ffff810204200000 on node 1
 [ffffe2000b200000-ffffe2000b3fffff] PMD ->ffff810204400000 on node 1
 [ffffe2000b400000-ffffe2000b5fffff] PMD ->ffff810204600000 on node 1
 [ffffe2000b600000-ffffe2000b7fffff] PMD ->ffff810204800000 on node 1
 [ffffe2000b800000-ffffe2000b9fffff] PMD ->ffff810204a00000 on node 1
 [ffffe2000ba00000-ffffe2000bbfffff] PMD ->ffff810204c00000 on node 1
 [ffffe2000bc00000-ffffe2000bdfffff] PMD ->ffff810204e00000 on node 1
 [ffffe2000be00000-ffffe2000bffffff] PMD ->ffff810205000000 on node 1
 [ffffe2000c000000-ffffe2000c1fffff] PMD ->ffff810205200000 on node 1
 [ffffe2000c200000-ffffe2000c3fffff] PMD ->ffff810205400000 on node 1
 [ffffe2000c400000-ffffe2000c5fffff] PMD ->ffff810205600000 on node 1
 [ffffe2000c600000-ffffe2000c7fffff] PMD ->ffff810205800000 on node 1
 [ffffe2000c800000-ffffe2000c9fffff] PMD ->ffff810205a00000 on node 1
 [ffffe2000ca00000-ffffe2000cbfffff] PMD ->ffff810205c00000 on node 1
 [ffffe2000cc00000-ffffe2000cdfffff] PMD ->ffff810205e00000 on node 1
 [ffffe2000ce00000-ffffe2000cffffff] PMD ->ffff810206000000 on node 1
 [ffffe2000d000000-ffffe2000d1fffff] PMD ->ffff810206200000 on node 1
 [ffffe2000d200000-ffffe2000d3fffff] PMD ->ffff810206400000 on node 1
 [ffffe2000d400000-ffffe2000d5fffff] PMD ->ffff810206600000 on node 1
 [ffffe2000d600000-ffffe2000d7fffff] PMD ->ffff810206800000 on node 1
 [ffffe2000d800000-ffffe2000d9fffff] PMD ->ffff810206a00000 on node 1
 [ffffe2000da00000-ffffe2000dbfffff] PMD ->ffff810206c00000 on node 1
 [ffffe2000dc00000-ffffe2000ddfffff] PMD ->ffff810206e00000 on node 1
 [ffffe2000de00000-ffffe2000dffffff] PMD ->ffff810207000000 on node 1
 [ffffe2000e000000-ffffe2000e1fffff] PMD ->ffff810400200000 on node 2
 [ffffe2000e200000-ffffe2000e3fffff] PMD ->ffff810400400000 on node 2
 [ffffe2000e400000-ffffe2000e5fffff] PMD ->ffff810400600000 on node 2
 [ffffe2000e600000-ffffe2000e7fffff] PMD ->ffff810400800000 on node 2
 [ffffe2000e800000-ffffe2000e9fffff] PMD ->ffff810400a00000 on node 2
 [ffffe2000ea00000-ffffe2000ebfffff] PMD ->ffff810400c00000 on node 2
 [ffffe2000ec00000-ffffe2000edfffff] PMD ->ffff810400e00000 on node 2
 [ffffe2000ee00000-ffffe2000effffff] PMD ->ffff810401000000 on node 2
 [ffffe2000f000000-ffffe2000f1fffff] PMD ->ffff810401200000 on node 2
 [ffffe2000f200000-ffffe2000f3fffff] PMD ->ffff810401400000 on node 2
 [ffffe2000f400000-ffffe2000f5fffff] PMD ->ffff810401600000 on node 2
 [ffffe2000f600000-ffffe2000f7fffff] PMD ->ffff810401800000 on node 2
 [ffffe2000f800000-ffffe2000f9fffff] PMD ->ffff810401a00000 on node 2
 [ffffe2000fa00000-ffffe2000fbfffff] PMD ->ffff810401c00000 on node 2
 [ffffe2000fc00000-ffffe2000fdfffff] PMD ->ffff810401e00000 on node 2
 [ffffe2000fe00000-ffffe2000fffffff] PMD ->ffff810402000000 on node 2
 [ffffe20010000000-ffffe200101fffff] PMD ->ffff810402200000 on node 2
 [ffffe20010200000-ffffe200103fffff] PMD ->ffff810402400000 on node 2
 [ffffe20010400000-ffffe200105fffff] PMD ->ffff810402600000 on node 2
 [ffffe20010600000-ffffe200107fffff] PMD ->ffff810402800000 on node 2
 [ffffe20010800000-ffffe200109fffff] PMD ->ffff810402a00000 on node 2
 [ffffe20010a00000-ffffe20010bfffff] PMD ->ffff810402c00000 on node 2
 [ffffe20010c00000-ffffe20010dfffff] PMD ->ffff810402e00000 on node 2
 [ffffe20010e00000-ffffe20010ffffff] PMD ->ffff810403000000 on node 2
 [ffffe20011000000-ffffe200111fffff] PMD ->ffff810403200000 on node 2
 [ffffe20011200000-ffffe200113fffff] PMD ->ffff810403400000 on node 2
 [ffffe20011400000-ffffe200115fffff] PMD ->ffff810403600000 on node 2
 [ffffe20011600000-ffffe200117fffff] PMD ->ffff810403800000 on node 2
 [ffffe20011800000-ffffe200119fffff] PMD ->ffff810403a00000 on node 2
 [ffffe20011a00000-ffffe20011bfffff] PMD ->ffff810403c00000 on node 2
 [ffffe20011c00000-ffffe20011dfffff] PMD ->ffff810403e00000 on node 2
 [ffffe20011e00000-ffffe20011ffffff] PMD ->ffff810404000000 on node 2
 [ffffe20012000000-ffffe200121fffff] PMD ->ffff810404200000 on node 2
 [ffffe20012200000-ffffe200123fffff] PMD ->ffff810404400000 on node 2
 [ffffe20012400000-ffffe200125fffff] PMD ->ffff810404600000 on node 2
 [ffffe20012600000-ffffe200127fffff] PMD ->ffff810404800000 on node 2
 [ffffe20012800000-ffffe200129fffff] PMD ->ffff810404a00000 on node 2
 [ffffe20012a00000-ffffe20012bfffff] PMD ->ffff810404c00000 on node 2
 [ffffe20012c00000-ffffe20012dfffff] PMD ->ffff810404e00000 on node 2
 [ffffe20012e00000-ffffe20012ffffff] PMD ->ffff810405000000 on node 2
 [ffffe20013000000-ffffe200131fffff] PMD ->ffff810405200000 on node 2
 [ffffe20013200000-ffffe200133fffff] PMD ->ffff810405400000 on node 2
 [ffffe20013400000-ffffe200135fffff] PMD ->ffff810405600000 on node 2
 [ffffe20013600000-ffffe200137fffff] PMD ->ffff810405800000 on node 2
 [ffffe20013800000-ffffe200139fffff] PMD ->ffff810405a00000 on node 2
 [ffffe20013a00000-ffffe20013bfffff] PMD ->ffff810405c00000 on node 2
 [ffffe20013c00000-ffffe20013dfffff] PMD ->ffff810405e00000 on node 2
 [ffffe20013e00000-ffffe20013ffffff] PMD ->ffff810406000000 on node 2
 [ffffe20014000000-ffffe200141fffff] PMD ->ffff810406200000 on node 2
 [ffffe20014200000-ffffe200143fffff] PMD ->ffff810406400000 on node 2
 [ffffe20014400000-ffffe200145fffff] PMD ->ffff810406600000 on node 2
 [ffffe20014600000-ffffe200147fffff] PMD ->ffff810406800000 on node 2
 [ffffe20014800000-ffffe200149fffff] PMD ->ffff810406a00000 on node 2
 [ffffe20014a00000-ffffe20014bfffff] PMD ->ffff810406c00000 on node 2
 [ffffe20014c00000-ffffe20014dfffff] PMD ->ffff810406e00000 on node 2
 [ffffe20014e00000-ffffe20014ffffff] PMD ->ffff810407000000 on node 2
 [ffffe20015000000-ffffe200151fffff] PMD ->ffff810600200000 on node 3
 [ffffe20015200000-ffffe200153fffff] PMD ->ffff810600400000 on node 3
 [ffffe20015400000-ffffe200155fffff] PMD ->ffff810600600000 on node 3
 [ffffe20015600000-ffffe200157fffff] PMD ->ffff810600800000 on node 3
 [ffffe20015800000-ffffe200159fffff] PMD ->ffff810600a00000 on node 3
 [ffffe20015a00000-ffffe20015bfffff] PMD ->ffff810600c00000 on node 3
 [ffffe20015c00000-ffffe20015dfffff] PMD ->ffff810600e00000 on node 3
 [ffffe20015e00000-ffffe20015ffffff] PMD ->ffff810601000000 on node 3
 [ffffe20016000000-ffffe200161fffff] PMD ->ffff810601200000 on node 3
 [ffffe20016200000-ffffe200163fffff] PMD ->ffff810601400000 on node 3
 [ffffe20016400000-ffffe200165fffff] PMD ->ffff810601600000 on node 3
 [ffffe20016600000-ffffe200167fffff] PMD ->ffff810601800000 on node 3
 [ffffe20016800000-ffffe200169fffff] PMD ->ffff810601a00000 on node 3
 [ffffe20016a00000-ffffe20016bfffff] PMD ->ffff810601c00000 on node 3
 [ffffe20016c00000-ffffe20016dfffff] PMD ->ffff810601e00000 on node 3
 [ffffe20016e00000-ffffe20016ffffff] PMD ->ffff810602000000 on node 3
 [ffffe20017000000-ffffe200171fffff] PMD ->ffff810602200000 on node 3
 [ffffe20017200000-ffffe200173fffff] PMD ->ffff810602400000 on node 3
 [ffffe20017400000-ffffe200175fffff] PMD ->ffff810602600000 on node 3
 [ffffe20017600000-ffffe200177fffff] PMD ->ffff810602800000 on node 3
 [ffffe20017800000-ffffe200179fffff] PMD ->ffff810602a00000 on node 3
 [ffffe20017a00000-ffffe20017bfffff] PMD ->ffff810602c00000 on node 3
 [ffffe20017c00000-ffffe20017dfffff] PMD ->ffff810602e00000 on node 3
 [ffffe20017e00000-ffffe20017ffffff] PMD ->ffff810603000000 on node 3
 [ffffe20018000000-ffffe200181fffff] PMD ->ffff810603200000 on node 3
 [ffffe20018200000-ffffe200183fffff] PMD ->ffff810603400000 on node 3
 [ffffe20018400000-ffffe200185fffff] PMD ->ffff810603600000 on node 3
 [ffffe20018600000-ffffe200187fffff] PMD ->ffff810603800000 on node 3
 [ffffe20018800000-ffffe200189fffff] PMD ->ffff810603a00000 on node 3
 [ffffe20018a00000-ffffe20018bfffff] PMD ->ffff810603c00000 on node 3
 [ffffe20018c00000-ffffe20018dfffff] PMD ->ffff810603e00000 on node 3
 [ffffe20018e00000-ffffe20018ffffff] PMD ->ffff810604000000 on node 3
 [ffffe20019000000-ffffe200191fffff] PMD ->ffff810604200000 on node 3
 [ffffe20019200000-ffffe200193fffff] PMD ->ffff810604400000 on node 3
 [ffffe20019400000-ffffe200195fffff] PMD ->ffff810604600000 on node 3
 [ffffe20019600000-ffffe200197fffff] PMD ->ffff810604800000 on node 3
 [ffffe20019800000-ffffe200199fffff] PMD ->ffff810604a00000 on node 3
 [ffffe20019a00000-ffffe20019bfffff] PMD ->ffff810604c00000 on node 3
 [ffffe20019c00000-ffffe20019dfffff] PMD ->ffff810604e00000 on node 3
 [ffffe20019e00000-ffffe20019ffffff] PMD ->ffff810605000000 on node 3
 [ffffe2001a000000-ffffe2001a1fffff] PMD ->ffff810605200000 on node 3
 [ffffe2001a200000-ffffe2001a3fffff] PMD ->ffff810605400000 on node 3
 [ffffe2001a400000-ffffe2001a5fffff] PMD ->ffff810605600000 on node 3
 [ffffe2001a600000-ffffe2001a7fffff] PMD ->ffff810605800000 on node 3
 [ffffe2001a800000-ffffe2001a9fffff] PMD ->ffff810605a00000 on node 3
 [ffffe2001aa00000-ffffe2001abfffff] PMD ->ffff810605c00000 on node 3
 [ffffe2001ac00000-ffffe2001adfffff] PMD ->ffff810605e00000 on node 3
 [ffffe2001ae00000-ffffe2001affffff] PMD ->ffff810606000000 on node 3
 [ffffe2001b000000-ffffe2001b1fffff] PMD ->ffff810606200000 on node 3
 [ffffe2001b200000-ffffe2001b3fffff] PMD ->ffff810606400000 on node 3
 [ffffe2001b400000-ffffe2001b5fffff] PMD ->ffff810606600000 on node 3
 [ffffe2001b600000-ffffe2001b7fffff] PMD ->ffff810606800000 on node 3
 [ffffe2001b800000-ffffe2001b9fffff] PMD ->ffff810606a00000 on node 3
 [ffffe2001ba00000-ffffe2001bbfffff] PMD ->ffff810606c00000 on node 3
 [ffffe2001bc00000-ffffe2001bdfffff] PMD ->ffff810606e00000 on node 3
 [ffffe2001be00000-ffffe2001bffffff] PMD ->ffff810607000000 on node 3
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  8388608
Movable zone start PFN for each node
early_node_map[6] active PFN ranges
    0:        0 ->      153
    0:      256 ->   933744
    0:  1048576 ->  2097152
    1:  2097152 ->  4194304
    2:  4194304 ->  6291456
    3:  6291456 ->  8388608
On node 0 totalpages: 1982217
  DMA zone: 56 pages used for memmap
  DMA zone: 1765 pages reserved
  DMA zone: 2172 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 915368 pages, LIFO batch:31
  Normal zone: 14336 pages used for memmap
  Normal zone: 1034240 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
On node 1 totalpages: 2097152
  DMA zone: 0 pages used for memmap
  DMA32 zone: 0 pages used for memmap
  Normal zone: 28672 pages used for memmap
  Normal zone: 2068480 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
On node 2 totalpages: 2097152
  DMA zone: 0 pages used for memmap
  DMA32 zone: 0 pages used for memmap
  Normal zone: 28672 pages used for memmap
  Normal zone: 2068480 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
On node 3 totalpages: 2097152
  DMA zone: 0 pages used for memmap
  DMA32 zone: 0 pages used for memmap
  Normal zone: 28672 pages used for memmap
  Normal zone: 2068480 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
Detected use of extended apic ids on hypertransport bus
Detected use of extended apic ids on hypertransport bus
Detected use of extended apic ids on hypertransport bus
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0xf008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
Processor #3
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
Processor #4
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
Processor #5
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
Processor #6
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
Processor #7
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xe4000000] gsi_base[24])
IOAPIC[1]: apic_id 9, address 0xe4000000, GSI 24-27
ACPI: IOAPIC (id[0x0a] address[0xe4001000] gsi_base[28])
IOAPIC[2]: apic_id 10, address 0xe4001000, GSI 28-31
ACPI: IOAPIC (id[0x0b] address[0xe5b01000] gsi_base[32])
IOAPIC[3]: apic_id 11, address 0xe5b01000, GSI 32-35
ACPI: IOAPIC (id[0x0c] address[0xe5b03000] gsi_base[36])
IOAPIC[4]: apic_id 12, address 0xe5b03000, GSI 36-39
ACPI: IOAPIC (id[0x0d] address[0xe5b05000] gsi_base[40])
IOAPIC[5]: apic_id 13, address 0xe5b05000, GSI 40-43
ACPI: IOAPIC (id[0x0e] address[0xe5b07000] gsi_base[44])
IOAPIC[6]: apic_id 14, address 0xe5b07000, GSI 44-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x102282a0 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
mapped APIC to ffffffffff5fb000 (        fee00000)
mapped IOAPIC to ffffffffff5fa000 (00000000fec00000)
mapped IOAPIC to ffffffffff5f9000 (00000000e4000000)
mapped IOAPIC to ffffffffff5f8000 (00000000e4001000)
mapped IOAPIC to ffffffffff5f7000 (00000000e5b01000)
mapped IOAPIC to ffffffffff5f6000 (00000000e5b03000)
mapped IOAPIC to ffffffffff5f5000 (00000000e5b05000)
mapped IOAPIC to ffffffffff5f4000 (00000000e5b07000)
PM: Registered nosave memory: 0000000000099000 - 000000000009a000
PM: Registered nosave memory: 000000000009a000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000d0000
PM: Registered nosave memory: 00000000000d0000 - 0000000000100000
PM: Registered nosave memory: 00000000e3f70000 - 00000000e3f77000
PM: Registered nosave memory: 00000000e3f77000 - 00000000e3f80000
PM: Registered nosave memory: 00000000e3f80000 - 00000000e4000000
PM: Registered nosave memory: 00000000e4000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 00000000fee00000
PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
PM: Registered nosave memory: 00000000fee01000 - 00000000fff80000
PM: Registered nosave memory: 00000000fff80000 - 0000000100000000
Allocating PCI resources starting at e6000000 (gap: e4000000:1ac00000)
SMP: Allowing 8 CPUs, 0 hotplug CPUs
PERCPU: Allocating 27136 bytes of per cpu data
Built 4 zonelists in Zone order, mobility grouping on.  Total pages: 8157220
Policy zone: Normal
Kernel command line: root=/dev/sda2 splash=silent console=tty0 resume=/dev/sda1 apic=debug loglevel=8
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC calibrated against PM_TIMER
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 2393.187 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Checking aperture...
Node 0: aperture @ 0 size 32 MB
No AGP bridge found
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 10000000
Memory: 32565416k/33554432k available (3829k kernel code, 529276k reserved, 1738k data, 360k init)
CPA: page pool initialized 512 of 512 pages preallocated
hpet clockevent registered
Calibrating delay using timer specific routine.. 4790.95 BogoMIPS (lpj=9581912)
Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes)
Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
ACPI: Core revision 20070126
masked ExtINT on CPU#0
ENABLING IO-APIC IRQs
init IO_APIC IRQs
 IO-APIC (apicid-pin) 8-0 not connected.
IOAPIC[0]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (8-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (8-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (8-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (8-9 -> 0x39 -> IRQ 9 Mode:1 Active:1)
IOAPIC[0]: Set routing entry (8-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (8-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (8-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (8-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (8-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
 IO-APIC (apicid-pin) 8-16, 8-17, 8-18, 8-19, 8-20, 8-21, 8-22, 8-23, 9-0, 9-1, 9-2, 9-3, 10-0, 10-1, 10-2, 10-3, 11-0, 11-1, 11-2, 11-3, 12-0, 12-1, 12-2, 12-3, 13-0, 13-1, 13-2, 13-3, 14-0, 14-1, 14-2, 14-3 not connected.
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
Using local APIC timer interrupts.
APIC timer calibration result 12464523
Detected 12.464 MHz APIC timer.
Booting processor 1/8 APIC 0x1
Initializing CPU#1
masked ExtINT on CPU#1
Calibrating delay using timer specific routine.. 4786.58 BogoMIPS (lpj=9573179)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Dual Core AMD Opteron(tm) Processor 880 stepping 02
Booting processor 2/8 APIC 0x2
Initializing CPU#2
masked ExtINT on CPU#2
Calibrating delay using timer specific routine.. 4786.49 BogoMIPS (lpj=9572982)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 2/2 -> Node 1
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
Dual Core AMD Opteron(tm) Processor 880 stepping 02
Booting processor 3/8 APIC 0x3
Initializing CPU#3
masked ExtINT on CPU#3
Calibrating delay using timer specific routine.. 4786.48 BogoMIPS (lpj=9572963)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 3/3 -> Node 1
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 1
Dual Core AMD Opteron(tm) Processor 880 stepping 02
Booting processor 4/8 APIC 0x4
Initializing CPU#4
masked ExtINT on CPU#4
Calibrating delay using timer specific routine.. 4786.48 BogoMIPS (lpj=9572962)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 4/4 -> Node 2
CPU: Physical Processor ID: 2
CPU: Processor Core ID: 0
Dual Core AMD Opteron(tm) Processor 880 stepping 02
Booting processor 5/8 APIC 0x5
Initializing CPU#5
masked ExtINT on CPU#5
Calibrating delay using timer specific routine.. 4786.48 BogoMIPS (lpj=9572961)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 5/5 -> Node 2
CPU: Physical Processor ID: 2
CPU: Processor Core ID: 1
Dual Core AMD Opteron(tm) Processor 880 stepping 02
Booting processor 6/8 APIC 0x6
Initializing CPU#6
masked ExtINT on CPU#6
Calibrating delay using timer specific routine.. 4786.37 BogoMIPS (lpj=9572752)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 6/6 -> Node 3
CPU: Physical Processor ID: 3
CPU: Processor Core ID: 0
Dual Core AMD Opteron(tm) Processor 880 stepping 02
Booting processor 7/8 APIC 0x7
Initializing CPU#7
masked ExtINT on CPU#7
Calibrating delay using timer specific routine.. 4786.48 BogoMIPS (lpj=9572964)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 7/7 -> Node 3
CPU: Physical Processor ID: 3
CPU: Processor Core ID: 1
Dual Core AMD Opteron(tm) Processor 880 stepping 02
Brought up 8 CPUs
net_namespace: 416 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.THOR._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.Z000._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.Z002._PRT]
ACPI: PCI Root Bridge [PCI1] (0000:20)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.Z003._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.Z004._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.Z005._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.Z006._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 5 *10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 *5 10 11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 5 10 11) *7
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 5 10 *11)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
IOAPIC[0]: Set routing entry (8-19 -> 0x49 -> IRQ 19 Mode:1 Active:1)
IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (8-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (8-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
number of MP IRQ sources: 15.
number of IO-APIC #8 registers: 24.
number of IO-APIC #9 registers: 4.
number of IO-APIC #10 registers: 4.
number of IO-APIC #11 registers: 4.
number of IO-APIC #12 registers: 4.
number of IO-APIC #13 registers: 4.
number of IO-APIC #14 registers: 4.
testing the IO APIC.......................

IO APIC #8......
.... register #00: 08000000
.......    : physical APIC id: 08
.... register #01: 00170011
.......     : max redirection entries: 0017
.......     : PRQ implemented: 0
.......     : IO APIC version: 0011
.... register #02: 08000000
.......     : arbitration: 08
.... IRQ redirection table:
 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
 00 000 1    0    0   0   0    0    0    00
 01 0FF 0    0    0   0   0    1    1    31
 02 0FF 0    0    0   0   0    1    1    30
 03 0FF 0    0    0   0   0    1    1    33
 04 0FF 0    0    0   0   0    1    1    34
 05 0FF 0    0    0   0   0    1    1    35
 06 0FF 0    0    0   0   0    1    1    36
 07 0FF 0    0    0   0   0    1    1    37
 08 0FF 0    0    0   0   0    1    1    38
 09 0FF 0    1    0   1   0    1    1    39
 0a 0FF 0    0    0   0   0    1    1    3A
 0b 0FF 0    0    0   0   0    1    1    3B
 0c 0FF 0    0    0   0   0    1    1    3C
 0d 0FF 0    0    0   0   0    1    1    3D
 0e 0FF 0    0    0   0   0    1    1    3E
 0f 0FF 0    0    0   0   0    1    1    3F
 10 000 1    0    0   0   0    0    0    00
 11 000 1    0    0   0   0    0    0    00
 12 000 1    0    0   0   0    0    0    00
 13 0FF 1    1    0   1   0    1    1    49
 14 000 1    0    0   0   0    0    0    00
 15 000 1    0    0   0   0    0    0    00
 16 000 1    0    0   0   0    0    0    00
 17 000 1    0    0   0   0    0    0    00

IO APIC #9......
.... register #00: 09000000
.......    : physical APIC id: 09
.... register #01: 00030011
.......     : max redirection entries: 0003
.......     : PRQ implemented: 0
.......     : IO APIC version: 0011
.... register #02: 00000000
.......     : arbitration: 00
.... IRQ redirection table:
 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
 00 000 1    0    0   0   0    0    0    00
 01 000 1    0    0   0   0    0    0    00
 02 000 1    0    0   0   0    0    0    00
 03 000 1    0    0   0   0    0    0    00

IO APIC #10......
.... register #00: 0A000000
.......    : physical APIC id: 0A
.... register #01: 00030011
.......     : max redirection entries: 0003
.......     : PRQ implemented: 0
.......     : IO APIC version: 0011
.... register #02: 00000000
.......     : arbitration: 00
.... IRQ redirection table:
 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
 00 000 1    0    0   0   0    0    0    00
 01 000 1    0    0   0   0    0    0    00
 02 000 1    0    0   0   0    0    0    00
 03 000 1    0    0   0   0    0    0    00

IO APIC #11......
.... register #00: 0B000000
.......    : physical APIC id: 0B
.... register #01: 00030011
.......     : max redirection entries: 0003
.......     : PRQ implemented: 0
.......     : IO APIC version: 0011
.... register #02: 00000000
.......     : arbitration: 00
.... IRQ redirection table:
 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
 00 000 1    0    0   0   0    0    0    00
 01 000 1    0    0   0   0    0    0    00
 02 000 1    0    0   0   0    0    0    00
 03 000 1    0    0   0   0    0    0    00

IO APIC #12......
.... register #00: 0C000000
.......    : physical APIC id: 0C
.... register #01: 00030011
.......     : max redirection entries: 0003
.......     : PRQ implemented: 0
.......     : IO APIC version: 0011
.... register #02: 00000000
.......     : arbitration: 00
.... IRQ redirection table:
 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
 00 000 1    0    0   0   0    0    0    00
 01 000 1    0    0   0   0    0    0    00
 02 000 1    0    0   0   0    0    0    00
 03 000 1    0    0   0   0    0    0    00

IO APIC #13......
.... register #00: 0D000000
.......    : physical APIC id: 0D
.... register #01: 00030011
.......     : max redirection entries: 0003
.......     : PRQ implemented: 0
.......     : IO APIC version: 0011
.... register #02: 00000000
.......     : arbitration: 00
.... IRQ redirection table:
 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
 00 000 1    0    0   0   0    0    0    00
 01 000 1    0    0   0   0    0    0    00
 02 000 1    0    0   0   0    0    0    00
 03 000 1    0    0   0   0    0    0    00

IO APIC #14......
.... register #00: 0E000000
.......    : physical APIC id: 0E
.... register #01: 00030011
.......     : max redirection entries: 0003
.......     : PRQ implemented: 0
.......     : IO APIC version: 0011
.... register #02: 00000000
.......     : arbitration: 00
.... IRQ redirection table:
 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
 00 000 1    0    0   0   0    0    0    00
 01 000 1    0    0   0   0    0    0    00
 02 000 1    0    0   0   0    0    0    00
 03 000 1    0    0   0   0    0    0    00
IRQ to pin mappings:
IRQ0 -> 0:2
IRQ1 -> 0:1
IRQ3 -> 0:3
IRQ4 -> 0:4
IRQ5 -> 0:5
IRQ6 -> 0:6
IRQ7 -> 0:7
IRQ8 -> 0:8
IRQ9 -> 0:9
IRQ10 -> 0:10
IRQ11 -> 0:11
IRQ12 -> 0:12
IRQ13 -> 0:13
IRQ14 -> 0:14
IRQ15 -> 0:15
IRQ19 -> 0:19
.................................... done.
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 10000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 1
hpet0: 3 32-bit timers, 14318180 Hz
Time: hpet clocksource has been installed.
system 00:00: iomem range 0xe0000-0xfffff could not be reserved
system 00:00: iomem range 0xc0000-0xc7fff has been reserved
system 00:00: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:00: iomem range 0xffc00000-0xfff7ffff has been reserved
system 00:00: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:00: iomem range 0xfff80000-0xffffffff could not be reserved
system 00:00: iomem range 0xe4000000-0xe4000fff has been reserved
system 00:00: iomem range 0xe4001000-0xe4001fff has been reserved
system 00:09: ioport range 0x4d0-0x4d1 has been reserved
system 00:09: ioport range 0x1100-0x117f has been reserved
system 00:09: ioport range 0x1180-0x11ff has been reserved
system 00:09: ioport range 0xca2-0xca3 has been reserved
system 00:09: ioport range 0xb78-0xb7b has been reserved
system 00:09: ioport range 0x190-0x193 has been reserved
system 00:09: ioport range 0x290-0x291 has been reserved
system 00:09: ioport range 0xcf9-0xcf9 could not be reserved
PCI: Bridge: 0000:00:06.0
  IO window: disabled.
  MEM window: 0xe4100000-0xe57fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0a.0
  IO window: 2000-2fff
  MEM window: 0xe5800000-0xe58fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:20:01.0
  IO window: 4000-4fff
  MEM window: 0xe6000000-0xe6ffffff
  PREFETCH window: 0x00000000ec000000-0x00000000efffffff
PCI: Bridge: 0000:20:02.0
  IO window: 3000-3fff
  MEM window: 0xe7000000-0xe7ffffff
  PREFETCH window: 0x00000000f0000000-0x00000000f3ffffff
PCI: Bridge: 0000:20:03.0
  IO window: 5000-5fff
  MEM window: 0xe8000000-0xe8ffffff
  PREFETCH window: 0x00000000f4000000-0x00000000f7ffffff
PCI: Bridge: 0000:20:04.0
  IO window: 6000-6fff
  MEM window: 0xe9000000-0xe9ffffff
  PREFETCH window: 0x00000000f8000000-0x00000000fbffffff
IOAPIC[3]: Set routing entry (11-0 -> 0x51 -> IRQ 32 Mode:1 Active:1)
ACPI: PCI Interrupt 0000:20:01.0[A] -> GSI 32 (level, low) -> IRQ 32
IOAPIC[4]: Set routing entry (12-0 -> 0x59 -> IRQ 36 Mode:1 Active:1)
ACPI: PCI Interrupt 0000:20:02.0[A] -> GSI 36 (level, low) -> IRQ 36
IOAPIC[5]: Set routing entry (13-0 -> 0x61 -> IRQ 40 Mode:1 Active:1)
ACPI: PCI Interrupt 0000:20:03.0[A] -> GSI 40 (level, low) -> IRQ 40
IOAPIC[6]: Set routing entry (14-0 -> 0x69 -> IRQ 44 Mode:1 Active:1)
ACPI: PCI Interrupt 0000:20:04.0[A] -> GSI 44 (level, low) -> IRQ 44
NET: Registered protocol family 2
IP route cache hash table entries: 1048576 (order: 11, 8388608 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
Total HugeTLB memory allocated, 0
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
SGI XFS with large block/inode numbers, no debug enabled
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:0a.0: MSI quirk detected; subordinate MSI disabled
pci 0000:00:0a.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
pci 0000:00:0b.0: MSI quirk detected; subordinate MSI disabled
pci 0000:00:0b.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
pci 0000:01:05.0: Boot video device
pci 0000:20:01.0: MSI quirk detected; subordinate MSI disabled
pci 0000:20:01.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
pci 0000:20:02.0: MSI quirk detected; subordinate MSI disabled
pci 0000:20:02.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
pci 0000:20:03.0: MSI quirk detected; subordinate MSI disabled
pci 0000:20:03.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
pci 0000:20:04.0: MSI quirk detected; subordinate MSI disabled
pci 0000:20:04.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: ACPI0007:02 is registered as cooling_device2
ACPI: ACPI0007:03 is registered as cooling_device3
ACPI: ACPI0007:04 is registered as cooling_device4
ACPI: ACPI0007:05 is registered as cooling_device5
ACPI: ACPI0007:06 is registered as cooling_device6
ACPI: ACPI0007:07 is registered as cooling_device7
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
AMD768 RNG detected
Linux agpgart interface v0.103
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
IOAPIC[4]: Set routing entry (12-1 -> 0x71 -> IRQ 37 Mode:1 Active:1)
ACPI: PCI Interrupt 0000:25:01.0[A] -> GSI 37 (level, low) -> IRQ 37
ttyS1: detected caps 00000700 should be 00000100
0000:25:01.0: ttyS1 at I/O 0x3020 (irq = 37) is a 16C950/954
ttyS2: detected caps 00000700 should be 00000100
0000:25:01.0: ttyS2 at I/O 0x3028 (irq = 37) is a 16C950/954
ttyS3: detected caps 00000700 should be 00000100
0000:25:01.0: ttyS3 at I/O 0x3030 (irq = 37) is a 16C950/954
Couldn't register serial port 0000:25:01.0: -28
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
brd: module loaded
loop: module loaded
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
tg3.c:v3.87 (December 20, 2007)
IOAPIC[1]: Set routing entry (9-1 -> 0x79 -> IRQ 25 Mode:1 Active:1)
ACPI: PCI Interrupt 0000:02:02.0[A] -> GSI 25 (level, low) -> IRQ 25
eth0: Tigon3 [partno(BCM95704A6) rev 2003 PHY(5704)] (PCIX:66MHz:64-bit) 10/100/1000Base-T Ethernet 00:09:3d:12:1c:37
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth0: dma_rwctrl[769f0000] dma_mask[64-bit]
IOAPIC[1]: Set routing entry (9-2 -> 0x81 -> IRQ 26 Mode:1 Active:1)
ACPI: PCI Interrupt 0000:02:02.1[B] -> GSI 26 (level, low) -> IRQ 26
eth1: Tigon3 [partno(BCM95704A6) rev 2003 PHY(5704)] (PCIX:66MHz:64-bit) 10/100/1000Base-T Ethernet 00:09:3d:12:1c:38
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth1: dma_rwctrl[769f0000] dma_mask[64-bit]
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
console [netcon0] enabled
netconsole: network logging started
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
AMD8111: 0000:00:07.1 (rev 03) UDMA133 controller
AMD8111: IDE controller (0x1022:0x7469 rev 0x03) at  PCI slot 0000:00:07.1
AMD8111: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x1000-0x1007, BIOS settings: hda:PIO, hdb:PIO
    ide1: BM-DMA at 0x1008-0x100f, BIOS settings: hdc:DMA, hdd:PIO
Probing IDE interface ide0...
Probing IDE interface ide1...
hdc: MATSHITADVD-ROM SR-8178, ATAPI CD/DVD-ROM drive
hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/33 mode selected
ide1 at 0x170-0x177,0x376 on irq 15
Probing IDE interface ide0...
hdc: ATAPI 24X DVD-ROM drive, 256kB Cache
Uniform CD-ROM driver Revision: 3.20
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
Fusion MPT base driver 3.04.06
Copyright (c) 1999-2007 LSI Corporation
Fusion MPT SPI Host driver 3.04.06
IOAPIC[1]: Set routing entry (9-3 -> 0x89 -> IRQ 27 Mode:1 Active:1)
ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 27 (level, low) -> IRQ 27
mptbase: ioc0: Initiating bringup
ioc0: LSI53C1030 C0: Capabilities={Initiator}
scsi0 : ioc0: LSI53C1030 C0, FwRev=01032300h, Ports=1, MaxQ=222, IRQ=27
scsi 0:0:0:0: Direct-Access     FUJITSU  MAU3036NC        0104 PQ: 0 ANSI: 3
 target0:0:0: Beginning Domain Validation
 target0:0:0: Ending Domain Validation
 target0:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI WRFLOW PCOMP (6.25 ns, offset 127)
sd 0:0:0:0: [sda] 71819496 512-byte hardware sectors (36772 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: b3 00 00 08
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 71819496 512-byte hardware sectors (36772 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: b3 00 00 08
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 0:0:6:0: Processor         SDR      GEM318P          1    PQ: 0 ANSI: 2
 target0:0:6: Beginning Domain Validation
 target0:0:6: Ending Domain Validation
 target0:0:6: asynchronous
scsi 0:0:6:0: Attached scsi generic sg1 type 3
ieee1394: raw1394: /dev/raw1394 device initialized
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:01:00.0[D] -> GSI 19 (level, low) -> IRQ 19
ohci_hcd 0000:01:00.0: OHCI Host Controller
ohci_hcd 0000:01:00.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:01:00.0: irq 19, io mem 0xe4120000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
ACPI: PCI Interrupt 0000:01:00.1[D] -> GSI 19 (level, low) -> IRQ 19
ohci_hcd 0000:01:00.1: OHCI Host Controller
ohci_hcd 0000:01:00.1: new USB bus registered, assigned bus number 2
ohci_hcd 0000:01:00.1: irq 19, io mem 0xe4121000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
USB Universal Host Controller Interface driver v3.0
usb 1-1: new low speed USB device using ohci_hcd and address 2
usb 1-1: configuration #1 chosen from 1 choice
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
input: SILITEK USB Keyboard and Mouse as /class/input/input2
input: USB HID v1.00 Keyboard [SILITEK USB Keyboard and Mouse] on usb-0000:01:00.0-1
input: SILITEK USB Keyboard and Mouse as /class/input/input3
input: USB HID v1.00 Mouse [SILITEK USB Keyboard and Mouse] on usb-0000:01:00.0-1
usbcore: registered new interface driver usbhid
/mdata/lwork/polaris1/travis/workareas/Linus/linux-2.6/drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
oprofile: using NMI interrupt.
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
powernow-k8: Found 4 Dual Core AMD Opteron(tm) Processor 880 processors (8 cpu cores) (version 2.20.00)
powernow-k8: MP systems not supported by PSB BIOS structure
powernow-k8: MP systems not supported by PSB BIOS structure
powernow-k8: MP systems not supported by PSB BIOS structure
powernow-k8: MP systems not supported by PSB BIOS structure
powernow-k8: MP systems not supported by PSB BIOS structure
powernow-k8: MP systems not supported by PSB BIOS structure
powernow-k8: MP systems not supported by PSB BIOS structure
powernow-k8: MP systems not supported by PSB BIOS structure
XFS mounting filesystem sda2
Ending clean XFS mount for filesystem: sda2
VFS: Mounted root (xfs filesystem) readonly.
Freeing unused kernel memory: 360k freed
Adding 1052216k swap on /dev/sda1.  Priority:42 extents:1 across:1052216k
ADDRCONF(NETDEV_UP): eth0: link is not ready
tg3: eth0: Link is up at 100 Mbps, full duplex.
tg3: eth0: Flow control is on for TX and on for RX.
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
eth0: no IPv6 routers present
end_request: I/O error, dev fd0, sector 0
end_request: I/O error, dev fd0, sector 0
program hwscan is using a deprecated SCSI ioctl, please convert it to SG_IO
end_request: I/O error, dev fd0, sector 0
end_request: I/O error, dev fd0, sector 0

--------------060104020707030509000903--
