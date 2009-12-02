Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbZLBSL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbZLBSL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 13:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242AbZLBSL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 13:11:26 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:46121 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932AbZLBSLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 13:11:21 -0500
Date: Wed, 2 Dec 2009 10:11:08 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Borislav Petkov <petkovbb@googlemail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Doug Thompson <dougthompson@xmission.com>
Subject: Re: 2.6.32-rc8: amd64_edac slub error
Message-Id: <20091202101108.11b84c5c.randy.dunlap@oracle.com>
In-Reply-To: <20091202105838.GA10306@aftab>
References: <4B1400B3.60300@oracle.com>
	<20091130203547.GA2838@liondog.tnic>
	<20091130141629.44401d86.randy.dunlap@oracle.com>
	<20091201151639.GA670@aftab>
	<4B155023.1000801@oracle.com>
	<20091202105838.GA10306@aftab>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Wed__2_Dec_2009_10_11_08_-0800_Uta+bOFaVS9jY_Ru"
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4B16ADCA.0112:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Wed__2_Dec_2009_10_11_08_-0800_Uta+bOFaVS9jY_Ru
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 2 Dec 2009 11:58:38 +0100 Borislav Petkov wrote:

> On Tue, Dec 01, 2009 at 09:19:31AM -0800, Randy Dunlap wrote:
> > Here's the new log file (attached).
>=20
> Thanks for testing. Meanwhile, I noticed that the other places where
> rdmsr_on_cpus() gets called with non-contigious cpumasks need fixing
> too. Here's a version that takes care of that, I'd be nice if you could
> give it a run too (patch against today's upstream). You could also
> enforce the module loading by setting 'ecc_enable_override=3D1' to verify
> the other rdmsr_on_cpus calls.
>=20
> Thanks.

This patch also works for me.  Thanks.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


boot log attached.

> ---
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index a38831c..da2428b 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -2618,6 +2618,9 @@ static int amd64_init_csrows(struct mem_ctl_info *m=
ci)
>  	return empty;
>  }
> =20
> +static struct msr *alloc_msrs(const cpumask_t *mask);
> +static void free_msrs(struct msr *msrs);
> +
>  /*
>   * Only if 'ecc_enable_override' is set AND BIOS had ECC disabled, do "w=
e"
>   * enable it.
> @@ -2627,14 +2630,16 @@ static void amd64_enable_ecc_error_reporting(stru=
ct mem_ctl_info *mci)
>  	struct amd64_pvt *pvt =3D mci->pvt_info;
>  	const cpumask_t *cpumask =3D cpumask_of_node(pvt->mc_node_id);
>  	int cpu, idx =3D 0, err =3D 0;
> -	struct msr msrs[cpumask_weight(cpumask)];
> +	struct msr *msrs;
>  	u32 value;
>  	u32 mask =3D K8_NBCTL_CECCEn | K8_NBCTL_UECCEn;
> =20
>  	if (!ecc_enable_override)
>  		return;
> =20
> -	memset(msrs, 0, sizeof(msrs));
> +	msrs =3D alloc_msrs(cpumask);
> +	if (!msrs)
> +		return;
> =20
>  	amd64_printk(KERN_WARNING,
>  		"'ecc_enable_override' parameter is active, "
> @@ -2697,20 +2702,24 @@ static void amd64_enable_ecc_error_reporting(stru=
ct mem_ctl_info *mci)
>  		(value & K8_NBCFG_ECC_ENABLE) ? "Enabled" : "Disabled");
> =20
>  	pvt->ctl_error_info.nbcfg =3D value;
> +
> +	free_msrs(msrs);
>  }
> =20
>  static void amd64_restore_ecc_error_reporting(struct amd64_pvt *pvt)
>  {
>  	const cpumask_t *cpumask =3D cpumask_of_node(pvt->mc_node_id);
>  	int cpu, idx =3D 0, err =3D 0;
> -	struct msr msrs[cpumask_weight(cpumask)];
> +	struct msr *msrs;
>  	u32 value;
>  	u32 mask =3D K8_NBCTL_CECCEn | K8_NBCTL_UECCEn;
> =20
>  	if (!pvt->nbctl_mcgctl_saved)
>  		return;
> =20
> -	memset(msrs, 0, sizeof(msrs));
> +	msrs =3D alloc_msrs(cpumask);
> +	if (!msrs)
> +		return;
> =20
>  	err =3D pci_read_config_dword(pvt->misc_f3_ctl, K8_NBCTL, &value);
>  	if (err)
> @@ -2731,6 +2740,8 @@ static void amd64_restore_ecc_error_reporting(struc=
t amd64_pvt *pvt)
>  	}
> =20
>  	wrmsr_on_cpus(cpumask, K8_MSR_MCGCTL, msrs);
> +
> +	free_msrs(msrs);
>  }
> =20
>  /* get all cores on this DCT */
> @@ -2743,6 +2754,40 @@ static void get_cpus_on_this_dct_cpumask(cpumask_t=
 *mask, int nid)
>  			cpumask_set_cpu(cpu, mask);
>  }
> =20
> +/*
> + * Allocate enough msr structs for the supplied cpumask. Also, take care=
 of
> + * non-contigious bitmasks.
> + */
> +static struct msr *alloc_msrs(const cpumask_t *mask)
> +{
> +	struct msr *msrs;
> +	int i, first_cpu, last_cpu =3D 0;
> +
> +	if (cpumask_empty(mask)) {
> +		amd64_printk(KERN_WARNING, "%s: Empty cpumask!\n", __func__);
> +		return NULL;
> +	}
> +
> +	first_cpu =3D cpumask_first(mask);
> +	for (i =3D first_cpu; i < nr_cpu_ids; i++)
> +		if (cpumask_test_cpu(i, mask))
> +			last_cpu =3D i;
> +
> +	msrs =3D kzalloc(sizeof(*msrs) * (last_cpu - first_cpu + 1), GFP_KERNEL=
);
> +	if (!msrs) {
> +		amd64_printk(KERN_WARNING, "%s: error allocating msrs\n",
> +			      __func__);
> +		 return NULL;
> +	}
> +
> +	return msrs;
> +}
> +
> +static void free_msrs(struct msr *msrs)
> +{
> +	 kfree(msrs);
> +}
> +
>  /* check MCG_CTL on all the cpus on this node */
>  static bool amd64_nb_mce_bank_enabled_on_node(int nid)
>  {
> @@ -2755,12 +2800,9 @@ static bool amd64_nb_mce_bank_enabled_on_node(int =
nid)
> =20
>  	get_cpus_on_this_dct_cpumask(&mask, nid);
> =20
> -	msrs =3D kzalloc(sizeof(struct msr) * cpumask_weight(&mask), GFP_KERNEL=
);
> -	if (!msrs) {
> -		amd64_printk(KERN_WARNING, "%s: error allocating msrs\n",
> -			      __func__);
> -		 return false;
> -	}
> +	msrs =3D alloc_msrs(&mask);
> +	if (!msrs)
> +		goto out_err;
> =20
>  	rdmsr_on_cpus(&mask, MSR_IA32_MCG_CTL, msrs);
> =20
> @@ -2779,7 +2821,9 @@ static bool amd64_nb_mce_bank_enabled_on_node(int n=
id)
>  	ret =3D true;
> =20
>  out:
> -	kfree(msrs);
> +	free_msrs(msrs);
> +
> +out_err:
>  	return ret;
>  }
> =20
>=20
> --=20
> Regards/Gruss,
> Boris.
>=20
> Operating | Advanced Micro Devices GmbH
>   System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. M=FCnchen, Germa=
ny
>  Research | Gesch=E4ftsf=FChrer: Andrew Bowd, Thomas M. McCoy, Giuliano M=
eroni
>   Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis M=FCnchen
>   (OSRC)  | Registergericht M=FCnchen, HRB Nr. 43632
>=20


---
~Randy

--Multipart=_Wed__2_Dec_2009_10_11_08_-0800_Uta+bOFaVS9jY_Ru
Content-Type: text/x-log;
 name="edac-ml.log"
Content-Disposition: attachment;
 filename="edac-ml.log"
Content-Transfer-Encoding: quoted-printable

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.32-rc8-git4 (rdunlap@ca-ostest293.us.oracle.com) (gcc ver=
sion 4.1.2 20080704 (Red Hat 4.1.2-44)) #1 SMP Wed Dec 2 02:15:06 PST 2009
Command line: ro root=3D/dev/cciss/c0d0p3 console=3Dtty0 console=3DttyS0,11=
5200n8 netconsole=3D50000@139.185.50.77/eth0,50000@139.185.50.76/00:18:FE:3=
4:1C:3D nmi_watchdog=3D2 selinux=3D0 debug ignore_loglevel initcall_debug p=
rint_fatal_signals=3D1 slub_debug=3DFPZ
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fe50000 (usable)
 BIOS-e820: 000000007fe50000 - 000000007fe58000 (ACPI data)
 BIOS-e820: 000000007fe58000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 000000027ffff000 (usable)
debug: ignoring loglevel setting.
DMI 2.3 present.
last_pfn =3D 0x27ffff max_arch_pfn =3D 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-FFFFF write-back
MTRR variable ranges enabled:
  0 base 0000000000 mask FF80000000 write-back
  1 disabled
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
TOM2: 0000000280000000 aka 10240M
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820 update range: 0000000080000000 - 0000000100000000 (usable) =3D=3D> (re=
served)
last_pfn =3D 0x7fe50 max_arch_pfn =3D 0x400000000
initial memory mapped : 0 - 20000000
init_memory_mapping: 0000000000000000-000000007fe50000
 0000000000 - 007fe00000 page 2M
 007fe00000 - 007fe50000 page 4k
kernel direct mapping tables up to 7fe50000 @ 8000-c000
init_memory_mapping: 0000000100000000-000000027ffff000
 0100000000 - 027fe00000 page 2M
 027fe00000 - 027ffff000 page 4k
kernel direct mapping tables up to 27ffff000 @ a000-16000
RAMDISK: 37eac000 - 37fef133
ACPI: RSDP 00000000000f4f00 00024 (v02 HP    )
ACPI: XSDT 000000007fe50780 0005C (v01 HP     A08      00000002   =D2? 0000=
162E)
ACPI: FACP 000000007fe50800 000F4 (v03 HP     A08      00000002   =D2? 0000=
162E)
ACPI: DSDT 000000007fe50900 03F75 (v01 HP         DSDT 00000001 INTL 200302=
28)
ACPI: FACS 000000007fe50100 00040
ACPI: SPCR 000000007fe50140 00050 (v01 HP     SPCRRBSU 00000001   =D2? 0000=
162E)
ACPI: MCFG 000000007fe501c0 0003C (v01 HP     ProLiant 00000001      000000=
00)
ACPI: HPET 000000007fe50200 00038 (v01 HP     A08      00000002   =D2? 0000=
162E)
ACPI: SPMI 000000007fe50240 00040 (v05 HP     ProLiant 00000001   =D2? 0000=
162E)
ACPI: APIC 000000007fe50280 000DE (v01 HP     00000083 00000002      000000=
00)
ACPI: SRAT 000000007fe50380 00110 (v01 AMD    HAMMER   00000001 AMD  000000=
01)
ACPI: Local APIC address 0xfee00000
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 1 -> APIC 2 -> Node 1
SRAT: PXM 1 -> APIC 3 -> Node 1
SRAT: Node 0 PXM 0 0-a0000
SRAT: Node 0 PXM 0 100000-80000000
SRAT: Node 0 PXM 0 100000000-180000000
SRAT: Node 1 PXM 1 180000000-280000000
NUMA: Allocated memnodemap from 11000 - 16040
NUMA: Using 20 for the hash shift.
Bootmem setup node 0 0000000000000000-0000000180000000
  NODE_DATA [0000000000016040 - 000000000002c03f]
  bootmap [000000000002d000 -  000000000005cfff] pages 30
(9 early reservations) =3D=3D> bootmem [0000000000 - 0180000000]
  #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [0000000000 - 00000=
01000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE =3D=3D> [0000006000 - 00000=
08000]
  #2 [0001000000 - 0001a58218]    TEXT DATA BSS =3D=3D> [0001000000 - 0001a=
58218]
  #3 [0037eac000 - 0037fef133]          RAMDISK =3D=3D> [0037eac000 - 0037f=
ef133]
  #4 [000009f400 - 0000100000]    BIOS reserved =3D=3D> [000009f400 - 00001=
00000]
  #5 [0001a59000 - 0001a5910c]              BRK =3D=3D> [0001a59000 - 0001a=
5910c]
  #6 [0000008000 - 000000a000]          PGTABLE =3D=3D> [0000008000 - 00000=
0a000]
  #7 [000000a000 - 0000011000]          PGTABLE =3D=3D> [000000a000 - 00000=
11000]
  #8 [0000011000 - 0000016040]       MEMNODEMAP =3D=3D> [0000011000 - 00000=
16040]
Bootmem setup node 1 0000000180000000-000000027ffff000
  NODE_DATA [0000000180000000 - 0000000180015fff]
  bootmap [0000000180016000 -  0000000180035fff] pages 20
(9 early reservations) =3D=3D> bootmem [0180000000 - 027ffff000]
  #0 [0000000000 - 0000001000]   BIOS data page
  #1 [0000006000 - 0000008000]       TRAMPOLINE
  #2 [0001000000 - 0001a58218]    TEXT DATA BSS
  #3 [0037eac000 - 0037fef133]          RAMDISK
  #4 [000009f400 - 0000100000]    BIOS reserved
  #5 [0001a59000 - 0001a5910c]              BRK
  #6 [0000008000 - 000000a000]          PGTABLE
  #7 [000000a000 - 0000011000]          PGTABLE
  #8 [0000011000 - 0000016040]       MEMNODEMAP
found SMP MP-table at [ffff8800000f4f80] f4f80
 [ffffea0000000000-ffffea00053fffff] PMD -> [ffff880001c00000-ffff8800053ff=
fff] on node 0
 [ffffea0005400000-ffffea0008bfffff] PMD -> [ffff880180200000-ffff8801839ff=
fff] on node 1
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x0027ffff
Movable zone start PFN for each node
early_node_map[4] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0007fe50
    0: 0x00100000 -> 0x00180000
    1: 0x00180000 -> 0x0027ffff
On node 0 totalpages: 1048047
  DMA zone: 56 pages used for memmap
  DMA zone: 113 pages reserved
  DMA zone: 3830 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 505480 pages, LIFO batch:31
  Normal zone: 7168 pages used for memmap
  Normal zone: 517120 pages, LIFO batch:31
On node 1 totalpages: 1048575
  Normal zone: 14336 pages used for memmap
  Normal zone: 1034239 pages, LIFO batch:31
Detected use of extended apic ids on hypertransport bus
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x908
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xf7df0000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 17, address 0xf7df0000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xfdef0000] gsi_base[38])
IOAPIC[1]: apic_id 9, version 17, address 0xfdef0000, GSI 38-61
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x10228201 base: 0xfed00000
SMP: Allowing 4 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 62
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
PM: Registered nosave memory: 000000007fe50000 - 000000007fe58000
PM: Registered nosave memory: 000000007fe58000 - 0000000080000000
PM: Registered nosave memory: 0000000080000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 00000000fed00000
PM: Registered nosave memory: 00000000fed00000 - 00000000fee00000
PM: Registered nosave memory: 00000000fee00000 - 00000000fee10000
PM: Registered nosave memory: 00000000fee10000 - 00000000ffc00000
PM: Registered nosave memory: 00000000ffc00000 - 0000000100000000
Allocating PCI resources starting at 80000000 (gap: 80000000:7ec00000)
Booting paravirtualized kernel on bare hardware
NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:4 nr_node_ids:2
PERCPU: Embedded 30 pages/cpu @ffff880005600000 s91224 r8192 d23464 u1048576
pcpu-alloc: s91224 r8192 d23464 u1048576 alloc=3D1*2097152
pcpu-alloc: [0] 0 2 [1] 1 3=20
Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 2060669
Policy zone: Normal
Kernel command line: ro root=3D/dev/cciss/c0d0p3 console=3Dtty0 console=3Dt=
tyS0,115200n8 netconsole=3D50000@139.185.50.77/eth0,50000@139.185.50.76/00:=
18:FE:34:1C:3D nmi_watchdog=3D2 selinux=3D0 debug ignore_loglevel initcall_=
debug print_fatal_signals=3D1 slub_debug=3DFPZ
PID hash table entries: 4096 (order: 3, 32768 bytes)
Initializing CPU#0
Checking aperture...
No AGP bridge found
Node 0: aperture @ 20000000 size 32 MB
Aperture pointing to e820 RAM. Ignoring.
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 20000000
PM: Registered nosave memory: 0000000020000000 - 0000000024000000
Memory: 8193160k/10485756k available (4277k kernel code, 2099268k absent, 1=
93328k reserved, 3930k data, 940k init)
SLUB: Genslabs=3D14, HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4, N=
odes=3D2
Hierarchical RCU implementation.
NR_IRQS:4352 nr_irqs:1024
Extended CMOS year: 2000
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
allocated 83886080 bytes of page_cgroup
please try 'cgroup_disable=3Dmemory' option if you don't want memory cgroups
hpet clockevent registered
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Fast TSC calibration using PIT
Detected 2611.642 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. =
5223.28 BogoMIPS (lpj=3D2611642)
Security Framework initialized
SELinux:  Disabled at boot.
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0x0 -> Node 0
tseg: 0000000000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 5 MCE banks
using C1E aware idle routine
Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
ACPI: Core revision 20090903
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 26440 entries in 104 pages
Setting APIC routing to flat
..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
CPU0: Dual-Core AMD Opteron(tm) Processor 8218 stepping 02
calling  migration_init+0x0/0x5a @ 1
initcall migration_init+0x0/0x5a returned 0 after 0 usecs
calling  spawn_ksoftirqd+0x0/0x59 @ 1
initcall spawn_ksoftirqd+0x0/0x59 returned 0 after 0 usecs
calling  init_call_single_data+0x0/0x87 @ 1
initcall init_call_single_data+0x0/0x87 returned 0 after 0 usecs
calling  spawn_softlockup_task+0x0/0x75 @ 1
initcall spawn_softlockup_task+0x0/0x75 returned 0 after 0 usecs
calling  relay_init+0x0/0x14 @ 1
initcall relay_init+0x0/0x14 returned 0 after 0 usecs
calling  tracer_alloc_buffers+0x0/0x1f6 @ 1
initcall tracer_alloc_buffers+0x0/0x1f6 returned 0 after 0 usecs
calling  init_trace_printk+0x0/0x12 @ 1
initcall init_trace_printk+0x0/0x12 returned 0 after 0 usecs
calling  trace_workqueue_early_init+0x0/0x108 @ 1
initcall trace_workqueue_early_init+0x0/0x108 returned 0 after 0 usecs
calling  mce_amd_init+0x0/0x33 @ 1
initcall mce_amd_init+0x0/0x33 returned 0 after 0 usecs
Booting processor 1 APIC 0x2 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5223.81 BogoMIPS (lpj=3D26=
11907)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/0x2 -> Node 1
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
CPU1: Dual-Core AMD Opteron(tm) Processor 8218 stepping 02
Booting processor 2 APIC 0x1 ip 0x6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 5223.81 BogoMIPS (lpj=3D26=
11906)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 2/0x1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU2: Dual-Core AMD Opteron(tm) Processor 8218 stepping 02
Booting processor 3 APIC 0x3 ip 0x6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 5223.81 BogoMIPS (lpj=3D26=
11908)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 3/0x3 -> Node 1
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 1
CPU3: Dual-Core AMD Opteron(tm) Processor 8218 stepping 02
Brought up 4 CPUs
Total of 4 processors activated (20894.72 BogoMIPS).
Testing NMI watchdog ... OK.
CPU0 attaching sched-domain:
 domain 0: span 0,2 level MC
  groups: 0 2
  domain 1: span 0-3 level NODE
   groups: 0,2 (cpu_power =3D 2048) 1,3 (cpu_power =3D 2048)
CPU1 attaching sched-domain:
 domain 0: span 1,3 level MC
  groups: 1 3
  domain 1: span 0-3 level NODE
   groups: 1,3 (cpu_power =3D 2048) 0,2 (cpu_power =3D 2048)
CPU2 attaching sched-domain:
 domain 0: span 0,2 level MC
  groups: 2 0
  domain 1: span 0-3 level NODE
   groups: 0,2 (cpu_power =3D 2048) 1,3 (cpu_power =3D 2048)
CPU3 attaching sched-domain:
 domain 0: span 1,3 level MC
  groups: 3 1
  domain 1: span 0-3 level NODE
   groups: 1,3 (cpu_power =3D 2048) 0,2 (cpu_power =3D 2048)
calling  init_mmap_min_addr+0x0/0x26 @ 1
initcall init_mmap_min_addr+0x0/0x26 returned 0 after 0 usecs
calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 =
usecs
calling  net_ns_init+0x0/0xc8 @ 1
initcall net_ns_init+0x0/0xc8 returned 0 after 976 usecs
calling  e820_mark_nvs_memory+0x0/0x41 @ 1
initcall e820_mark_nvs_memory+0x0/0x41 returned 0 after 0 usecs
calling  cpufreq_tsc+0x0/0x28 @ 1
initcall cpufreq_tsc+0x0/0x28 returned 0 after 0 usecs
calling  pci_reboot_init+0x0/0x14 @ 1
initcall pci_reboot_init+0x0/0x14 returned 0 after 0 usecs
calling  init_lapic_sysfs+0x0/0x2d @ 1
initcall init_lapic_sysfs+0x0/0x2d returned 0 after 0 usecs
calling  init_smp_flush+0x0/0x26 @ 1
initcall init_smp_flush+0x0/0x26 returned 0 after 0 usecs
calling  alloc_frozen_cpus+0x0/0xd @ 1
initcall alloc_frozen_cpus+0x0/0xd returned 0 after 0 usecs
calling  sysctl_init+0x0/0x16 @ 1
initcall sysctl_init+0x0/0x16 returned 0 after 0 usecs
calling  ksysfs_init+0x0/0xbb @ 1
initcall ksysfs_init+0x0/0xbb returned 0 after 0 usecs
calling  async_init+0x0/0x61 @ 1
initcall async_init+0x0/0x61 returned 0 after 0 usecs
calling  init_jiffies_clocksource+0x0/0x12 @ 1
initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 usecs
calling  pm_init+0x0/0x34 @ 1
initcall pm_init+0x0/0x34 returned 0 after 0 usecs
calling  pm_disk_init+0x0/0x19 @ 1
initcall pm_disk_init+0x0/0x19 returned 0 after 0 usecs
calling  swsusp_header_init+0x0/0x31 @ 1
initcall swsusp_header_init+0x0/0x31 returned 0 after 0 usecs
calling  init_zero_pfn+0x0/0x35 @ 1
initcall init_zero_pfn+0x0/0x35 returned 0 after 0 usecs
calling  filelock_init+0x0/0x2e @ 1
initcall filelock_init+0x0/0x2e returned 0 after 0 usecs
calling  init_misc_binfmt+0x0/0x41 @ 1
initcall init_misc_binfmt+0x0/0x41 returned 0 after 0 usecs
calling  init_script_binfmt+0x0/0x14 @ 1
initcall init_script_binfmt+0x0/0x14 returned 0 after 0 usecs
calling  init_elf_binfmt+0x0/0x14 @ 1
initcall init_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
calling  init_compat_elf_binfmt+0x0/0x14 @ 1
initcall init_compat_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
calling  debugfs_init+0x0/0x5a @ 1
initcall debugfs_init+0x0/0x5a returned 0 after 0 usecs
calling  securityfs_init+0x0/0x51 @ 1
initcall securityfs_init+0x0/0x51 returned 0 after 0 usecs
calling  random32_init+0x0/0xd1 @ 1
initcall random32_init+0x0/0xd1 returned 0 after 0 usecs
calling  gnttab_init+0x0/0x16e @ 1
initcall gnttab_init+0x0/0x16e returned -19 after 0 usecs
calling  regulator_init+0x0/0x2e @ 1
regulator: core version 0.5
initcall regulator_init+0x0/0x2e returned 0 after 976 usecs
calling  early_resume_init+0x0/0x1a0 @ 1
Time: 10:56:16  Date: 12/02/09
initcall early_resume_init+0x0/0x1a0 returned 0 after 976 usecs
calling  cpufreq_core_init+0x0/0x8c @ 1
initcall cpufreq_core_init+0x0/0x8c returned 0 after 0 usecs
calling  cpuidle_init+0x0/0x40 @ 1
initcall cpuidle_init+0x0/0x40 returned 0 after 0 usecs
calling  sock_init+0x0/0x5e @ 1
initcall sock_init+0x0/0x5e returned 0 after 0 usecs
calling  net_inuse_init+0x0/0x26 @ 1
initcall net_inuse_init+0x0/0x26 returned 0 after 0 usecs
calling  netpoll_init+0x0/0x31 @ 1
initcall netpoll_init+0x0/0x31 returned 0 after 0 usecs
calling  netlink_proto_init+0x0/0x14c @ 1
NET: Registered protocol family 16
initcall netlink_proto_init+0x0/0x14c returned 0 after 976 usecs
calling  bdi_class_init+0x0/0x41 @ 1
initcall bdi_class_init+0x0/0x41 returned 0 after 0 usecs
calling  kobject_uevent_init+0x0/0x54 @ 1
initcall kobject_uevent_init+0x0/0x54 returned 0 after 0 usecs
calling  pcibus_class_init+0x0/0x19 @ 1
initcall pcibus_class_init+0x0/0x19 returned 0 after 0 usecs
calling  pci_driver_init+0x0/0x12 @ 1
initcall pci_driver_init+0x0/0x12 returned 0 after 0 usecs
calling  backlight_class_init+0x0/0x5d @ 1
initcall backlight_class_init+0x0/0x5d returned 0 after 0 usecs
calling  xenbus_probe_init+0x0/0x10a @ 1
initcall xenbus_probe_init+0x0/0x10a returned -19 after 0 usecs
calling  tty_class_init+0x0/0x38 @ 1
initcall tty_class_init+0x0/0x38 returned 0 after 0 usecs
calling  vtconsole_class_init+0x0/0xc3 @ 1
initcall vtconsole_class_init+0x0/0xc3 returned 0 after 0 usecs
calling  register_node_type+0x0/0x6b @ 1
initcall register_node_type+0x0/0x6b returned 0 after 0 usecs
calling  amd_postcore_init+0x0/0x885 @ 1
node 0 link 1: io port [1000, 3fff]
node 1 link 2: io port [4000, ffff]
TOM: 0000000080000000 aka 2048M
node 0 link 1: mmio [e8000000, fddfffff]
node 1 link 2: mmio [fde00000, fdffffff]
node 0 link 1: mmio [80000000, 83ffffff]
node 1 link 2: mmio [84000000, 8fffffff]
node 0 link 1: mmio [a0000, bffff]
TOM2: 0000000280000000 aka 10240M
bus: [00,3f] on node 0 link 1
bus: 00 index 0 io port: [0, 3fff]
bus: 00 index 1 mmio: [90000000, fddfffff]
bus: 00 index 2 mmio: [80000000, 83ffffff]
bus: 00 index 3 mmio: [a0000, bffff]
bus: 00 index 4 mmio: [fe000000, ffffffff]
bus: 00 index 5 mmio: [280000000, fcffffffff]
bus: [40,ff] on node 1 link 2
bus: 40 index 0 io port: [4000, ffff]
bus: 40 index 1 mmio: [fde00000, fdffffff]
bus: 40 index 2 mmio: [84000000, 8fffffff]
initcall amd_postcore_init+0x0/0x885 returned 0 after 23437 usecs
calling  arch_kdebugfs_init+0x0/0x242 @ 1
initcall arch_kdebugfs_init+0x0/0x242 returned 0 after 0 usecs
calling  mtrr_if_init+0x0/0x63 @ 1
initcall mtrr_if_init+0x0/0x63 returned 0 after 0 usecs
calling  ffh_cstate_init+0x0/0x2a @ 1
initcall ffh_cstate_init+0x0/0x2a returned -1 after 0 usecs
initcall ffh_cstate_init+0x0/0x2a returned with error code -1=20
calling  arch_init_ftrace_syscalls+0x0/0xfd @ 1
initcall arch_init_ftrace_syscalls+0x0/0xfd returned 0 after 976 usecs
calling  acpi_pci_init+0x0/0x5c @ 1
ACPI: bus type pci registered
initcall acpi_pci_init+0x0/0x5c returned 0 after 976 usecs
calling  setup_vcpu_hotplug_event+0x0/0x22 @ 1
initcall setup_vcpu_hotplug_event+0x0/0x22 returned -19 after 0 usecs
calling  dmi_id_init+0x0/0x31a @ 1
initcall dmi_id_init+0x0/0x31a returned 0 after 0 usecs
calling  dma_bus_init+0x0/0x3f @ 1
initcall dma_bus_init+0x0/0x3f returned 0 after 0 usecs
calling  dma_channel_table_init+0x0/0xbf @ 1
initcall dma_channel_table_init+0x0/0xbf returned 0 after 0 usecs
calling  pci_arch_init+0x0/0x57 @ 1
PCI: MCFG configuration 0: base 80000000 segment 0 buses 0 - 255
PCI: Not using MMCONFIG.
PCI: Using configuration type 1 for base access
PCI: HP ProLiant BL685c G1 detected, enabling pci=3Dbfsort.
initcall pci_arch_init+0x0/0x57 returned 0 after 3906 usecs
calling  topology_init+0x0/0x86 @ 1
initcall topology_init+0x0/0x86 returned 0 after 976 usecs
calling  mtrr_init_finialize+0x0/0x3d @ 1
initcall mtrr_init_finialize+0x0/0x3d returned 0 after 0 usecs
calling  param_sysfs_init+0x0/0x216 @ 1
initcall param_sysfs_init+0x0/0x216 returned 0 after 4882 usecs
calling  pm_sysrq_init+0x0/0x1e @ 1
initcall pm_sysrq_init+0x0/0x1e returned 0 after 0 usecs
calling  audit_watch_init+0x0/0x2f @ 1
initcall audit_watch_init+0x0/0x2f returned 0 after 0 usecs
calling  init_slow_work+0x0/0x37 @ 1
initcall init_slow_work+0x0/0x37 returned 0 after 0 usecs
calling  default_bdi_init+0x0/0xb6 @ 1
initcall default_bdi_init+0x0/0xb6 returned 0 after 976 usecs
calling  init_bio+0x0/0xd3 @ 1
bio: create slab <bio-0> at 0
initcall init_bio+0x0/0xd3 returned 0 after 976 usecs
calling  fsnotify_init+0x0/0x12 @ 1
initcall fsnotify_init+0x0/0x12 returned 0 after 0 usecs
calling  fsnotify_notification_init+0x0/0x68 @ 1
initcall fsnotify_notification_init+0x0/0x68 returned 0 after 976 usecs
calling  cryptomgr_init+0x0/0x12 @ 1
initcall cryptomgr_init+0x0/0x12 returned 0 after 0 usecs
calling  blk_settings_init+0x0/0x2a @ 1
initcall blk_settings_init+0x0/0x2a returned 0 after 0 usecs
calling  blk_ioc_init+0x0/0x2a @ 1
initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
calling  blk_softirq_init+0x0/0x6e @ 1
initcall blk_softirq_init+0x0/0x6e returned 0 after 0 usecs
calling  blk_iopoll_setup+0x0/0x6e @ 1
initcall blk_iopoll_setup+0x0/0x6e returned 0 after 0 usecs
calling  genhd_device_init+0x0/0x66 @ 1
initcall genhd_device_init+0x0/0x66 returned 0 after 0 usecs
calling  blk_dev_integrity_init+0x0/0x2a @ 1
initcall blk_dev_integrity_init+0x0/0x2a returned 0 after 0 usecs
calling  pci_slot_init+0x0/0x4a @ 1
initcall pci_slot_init+0x0/0x4a returned 0 after 0 usecs
calling  fbmem_init+0x0/0x98 @ 1
initcall fbmem_init+0x0/0x98 returned 0 after 0 usecs
calling  acpi_init+0x0/0x262 @ 1
ACPI: EC: Look up EC in DSDT
ACPI: SSDT 000000007fe58000 004F0 (v02 HP     PNOWSSDT 00000002 HP   000000=
01)
ACPI: Interpreter enabled
ACPI: (supports S0 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base 80000000 segment 0 buses 0 - 255
PCI: MCFG area at 80000000 reserved in ACPI motherboard resources
PCI: Using MMCONFIG at 80000000 - 8fffffff
initcall acpi_init+0x0/0x262 returned 0 after 190429 usecs
calling  dock_init+0x0/0x8d @ 1
ACPI: No dock devices found.
initcall dock_init+0x0/0x8d returned 0 after 13671 usecs
calling  acpi_pci_root_init+0x0/0x28 @ 1
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:02.0: reg 10 32bit mmio: [0xf7de0000-0xf7de0fff]
pci 0000:00:02.0: supports D1 D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.1: reg 10 32bit mmio: [0xf7dd0000-0xf7dd00ff]
pci 0000:00:02.1: supports D1 D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.1: PME# disabled
pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0b.0: PME# disabled
pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0c.0: PME# disabled
pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0d.0: PME# disabled
pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0e.0: PME# disabled
PCI: peer root bus 00 res updated from pci conf
pci 0000:01:03.0: reg 10 32bit mmio pref: [0xe8000000-0xefffffff]
pci 0000:01:03.0: reg 14 io port: [0x1000-0x10ff]
pci 0000:01:03.0: reg 18 32bit mmio: [0xf7ff0000-0xf7ffffff]
pci 0000:01:03.0: reg 30 32bit mmio pref: [0x000000-0x01ffff]
pci 0000:01:03.0: supports D1 D2
pci 0000:01:04.0: reg 10 io port: [0x2800-0x28ff]
pci 0000:01:04.0: reg 14 32bit mmio: [0xf7fe0000-0xf7fe01ff]
pci 0000:01:04.0: PME# supported from D0 D3hot D3cold
pci 0000:01:04.0: PME# disabled
pci 0000:01:04.2: reg 10 io port: [0x1400-0x14ff]
pci 0000:01:04.2: reg 14 32bit mmio: [0xf7fd0000-0xf7fd07ff]
pci 0000:01:04.2: reg 18 32bit mmio: [0xf7fc0000-0xf7fc3fff]
pci 0000:01:04.2: reg 1c 32bit mmio: [0xf7f00000-0xf7f7ffff]
pci 0000:01:04.2: reg 30 32bit mmio pref: [0x000000-0x00ffff]
pci 0000:01:04.2: PME# supported from D0 D3hot D3cold
pci 0000:01:04.2: PME# disabled
pci 0000:01:04.4: reg 20 io port: [0x1800-0x181f]
pci 0000:01:04.4: PME# supported from D0 D3hot D3cold
pci 0000:01:04.4: PME# disabled
pci 0000:01:04.6: reg 10 32bit mmio: [0xf7ef0000-0xf7ef00ff]
pci 0000:01:04.6: PME# supported from D0 D3hot D3cold
pci 0000:01:04.6: PME# disabled
pci 0000:00:09.0: transparent bridge
pci 0000:00:09.0: bridge io port: [0x1000-0x2fff]
pci 0000:00:09.0: bridge 32bit mmio: [0xf7e00000-0xf7ffffff]
pci 0000:00:09.0: bridge 32bit mmio pref: [0xe8000000-0xefffffff]
pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it=
 with 'pcie_aspm=3Dforce'
pci 0000:00:0b.0: bridge 32bit mmio: [0xf8000000-0xf9ffffff]
pci 0000:03:00.0: reg 10 64bit mmio: [0xf8000000-0xf9ffffff]
pci 0000:03:00.0: reg 30 32bit mmio pref: [0x000000-0x01ffff]
pci 0000:03:00.0: PME# supported from D3hot D3cold
pci 0000:03:00.0: PME# disabled
pci 0000:02:00.0: bridge 32bit mmio: [0xf8000000-0xf9ffffff]
pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
pci 0000:04:00.0: PME# disabled
pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it=
 with 'pcie_aspm=3Dforce'
pci 0000:00:0c.0: bridge 32bit mmio: [0xfa000000-0xfbffffff]
pci 0000:05:00.0: reg 10 64bit mmio: [0xfa000000-0xfbffffff]
pci 0000:05:00.0: reg 30 32bit mmio pref: [0x000000-0x01ffff]
pci 0000:05:00.0: PME# supported from D3hot D3cold
pci 0000:05:00.0: PME# disabled
pci 0000:04:00.0: bridge 32bit mmio: [0xfa000000-0xfbffffff]
pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
pci 0000:06:00.0: PME# disabled
pci 0000:06:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it=
 with 'pcie_aspm=3Dforce'
pci 0000:00:0d.0: bridge 32bit mmio: [0xfdc00000-0xfdcfffff]
pci 0000:07:04.0: reg 10 64bit mmio: [0xfdcf0000-0xfdcfffff]
pci 0000:07:04.0: reg 18 64bit mmio: [0xfdce0000-0xfdceffff]
pci 0000:07:04.0: PME# supported from D3hot D3cold
pci 0000:07:04.0: PME# disabled
pci 0000:07:04.1: reg 10 64bit mmio: [0xfdcd0000-0xfdcdffff]
pci 0000:07:04.1: reg 18 64bit mmio: [0xfdcc0000-0xfdccffff]
pci 0000:07:04.1: PME# supported from D3hot D3cold
pci 0000:07:04.1: PME# disabled
pci 0000:06:00.0: bridge 32bit mmio: [0xfdc00000-0xfdcfffff]
pci 0000:08:00.0: reg 10 64bit mmio: [0xfddf0000-0xfddf0fff]
pci 0000:08:00.0: reg 18 64bit mmio: [0xfdde0000-0xfdde00ff]
pci 0000:08:00.0: reg 20 io port: [0x3000-0x30ff]
pci 0000:08:00.0: reg 30 32bit mmio pref: [0x000000-0x03ffff]
pci 0000:08:00.1: reg 10 64bit mmio: [0xfddd0000-0xfddd0fff]
pci 0000:08:00.1: reg 18 64bit mmio: [0xfddc0000-0xfddc00ff]
pci 0000:08:00.1: reg 20 io port: [0x3400-0x34ff]
pci 0000:08:00.1: reg 30 32bit mmio pref: [0x000000-0x03ffff]
pci 0000:08:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it=
 with 'pcie_aspm=3Dforce'
pci 0000:00:0e.0: bridge io port: [0x3000-0x3fff]
pci 0000:00:0e.0: bridge 32bit mmio: [0xfdd00000-0xfddfffff]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IP2P._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE1.NB01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE2.NC1B._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE3.NC2B._PRT]
ACPI: PCI Root Bridge [PCI1] (0000:40)
pci 0000:40:01.0: reg 14 32bit mmio: [0xfdef0000-0xfdef0fff]
pci 0000:40:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:40:0c.0: PME# disabled
pci 0000:40:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:40:0d.0: PME# disabled
pci 0000:40:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:40:0e.0: PME# disabled
PCI: peer root bus 40 res updated from pci conf
pci 0000:41:00.0: PME# supported from D0 D3hot D3cold
pci 0000:41:00.0: PME# disabled
pci 0000:41:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it=
 with 'pcie_aspm=3Dforce'
pci 0000:40:0c.0: bridge io port: [0x4000-0x4fff]
pci 0000:40:0c.0: bridge 32bit mmio: [0xfdf00000-0xfdffffff]
pci 0000:42:08.0: reg 10 64bit mmio: [0xfdf80000-0xfdffffff]
pci 0000:42:08.0: reg 18 io port: [0x4000-0x40ff]
pci 0000:42:08.0: reg 1c 32bit mmio: [0xfdf70000-0xfdf77fff]
pci 0000:42:08.0: reg 30 32bit mmio pref: [0x000000-0x003fff]
pci 0000:42:08.0: supports D1
pci 0000:41:00.0: bridge io port: [0x4000-0x4fff]
pci 0000:41:00.0: bridge 32bit mmio: [0xfdf00000-0xfdffffff]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE2.SASB._PRT]
initcall acpi_pci_root_init+0x0/0x28 returned 0 after 2912111 usecs
calling  acpi_pci_link_init+0x0/0x43 @ 1
ACPI: PCI Interrupt Link [LNKW] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [LNKX] (IRQs 17) *0, disabled.
ACPI: PCI Interrupt Link [LNKY] (IRQs 18) *0, disabled.
ACPI: PCI Interrupt Link [LNKZ] (IRQs 19) *0, disabled.
ACPI: PCI Interrupt Link [LNU0] (IRQs 22) *5
ACPI: PCI Interrupt Link [LNU2] (IRQs 23) *7
ACPI: PCI Interrupt Link [LNKA] (IRQs 54) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 55) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 56) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 57) *0, disabled.
initcall acpi_pci_link_init+0x0/0x43 returned 0 after 215820 usecs
calling  pnp_init+0x0/0x12 @ 1
initcall pnp_init+0x0/0x12 returned 0 after 0 usecs
calling  setup_shutdown_event+0x0/0x14 @ 1
initcall setup_shutdown_event+0x0/0x14 returned 0 after 0 usecs
calling  balloon_init+0x0/0x1c3 @ 1
initcall balloon_init+0x0/0x1c3 returned -19 after 0 usecs
calling  misc_init+0x0/0xb8 @ 1
initcall misc_init+0x0/0xb8 returned 0 after 0 usecs
calling  vga_arb_device_init+0x0/0x78 @ 1
vgaarb: device added: PCI:0000:01:03.0,decodes=3Dio+mem,owns=3Dio+mem,locks=
=3Dnone
vgaarb: loaded
initcall vga_arb_device_init+0x0/0x78 returned 0 after 44921 usecs
calling  cn_init+0x0/0xf3 @ 1
initcall cn_init+0x0/0xf3 returned 0 after 0 usecs
calling  init_scsi+0x0/0x91 @ 1
SCSI subsystem initialized
initcall init_scsi+0x0/0x91 returned 0 after 13671 usecs
calling  ata_init+0x0/0x33f @ 1
libata version 3.00 loaded.
initcall ata_init+0x0/0x33f returned 0 after 13671 usecs
calling  phy_init+0x0/0x31 @ 1
initcall phy_init+0x0/0x31 returned 0 after 0 usecs
calling  init_pcmcia_cs+0x0/0x25 @ 1
initcall init_pcmcia_cs+0x0/0x25 returned 0 after 0 usecs
calling  usb_init+0x0/0x1a8 @ 1
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
initcall usb_init+0x0/0x1a8 returned 0 after 56640 usecs
calling  serio_init+0x0/0x89 @ 1
initcall serio_init+0x0/0x89 returned 0 after 0 usecs
calling  input_init+0x0/0x133 @ 1
initcall input_init+0x0/0x133 returned 0 after 0 usecs
calling  rtc_init+0x0/0x71 @ 1
initcall rtc_init+0x0/0x71 returned 0 after 0 usecs
calling  power_supply_class_init+0x0/0x38 @ 1
initcall power_supply_class_init+0x0/0x38 returned 0 after 0 usecs
calling  hwmon_init+0x0/0x10d @ 1
initcall hwmon_init+0x0/0x10d returned 0 after 0 usecs
calling  thermal_init+0x0/0x40 @ 1
initcall thermal_init+0x0/0x40 returned 0 after 0 usecs
calling  md_init+0x0/0xd0 @ 1
initcall md_init+0x0/0xd0 returned 0 after 0 usecs
calling  leds_init+0x0/0x40 @ 1
initcall leds_init+0x0/0x40 returned 0 after 0 usecs
calling  pci_subsys_init+0x0/0x125 @ 1
PCI: Using ACPI for IRQ routing
initcall pci_subsys_init+0x0/0x125 returned 0 after 16601 usecs
calling  proto_init+0x0/0x12 @ 1
initcall proto_init+0x0/0x12 returned 0 after 0 usecs
calling  net_dev_init+0x0/0x177 @ 1
initcall net_dev_init+0x0/0x177 returned 0 after 0 usecs
calling  neigh_init+0x0/0x71 @ 1
initcall neigh_init+0x0/0x71 returned 0 after 0 usecs
calling  fib_rules_init+0x0/0xa6 @ 1
initcall fib_rules_init+0x0/0xa6 returned 0 after 0 usecs
calling  pktsched_init+0x0/0xd0 @ 1
initcall pktsched_init+0x0/0xd0 returned 0 after 0 usecs
calling  tc_filter_init+0x0/0x4c @ 1
initcall tc_filter_init+0x0/0x4c returned 0 after 0 usecs
calling  tc_action_init+0x0/0x4c @ 1
initcall tc_action_init+0x0/0x4c returned 0 after 0 usecs
calling  genl_init+0x0/0x8f @ 1
initcall genl_init+0x0/0x8f returned 0 after 0 usecs
calling  cipso_v4_init+0x0/0x67 @ 1
initcall cipso_v4_init+0x0/0x67 returned 0 after 0 usecs
calling  wireless_nlevent_init+0x0/0x12 @ 1
initcall wireless_nlevent_init+0x0/0x12 returned 0 after 0 usecs
calling  netlbl_init+0x0/0x83 @ 1
NetLabel: Initializing
NetLabel:  domain hash size =3D 128
NetLabel:  protocols =3D UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
initcall netlbl_init+0x0/0x83 returned 0 after 72265 usecs
calling  sysctl_init+0x0/0x49 @ 1
initcall sysctl_init+0x0/0x49 returned 0 after 0 usecs
calling  xen_mc_debugfs+0x0/0x118 @ 1
initcall xen_mc_debugfs+0x0/0x118 returned 0 after 0 usecs
calling  xen_mmu_debugfs+0x0/0x2be @ 1
initcall xen_mmu_debugfs+0x0/0x2be returned 0 after 0 usecs
calling  print_all_ICs+0x0/0x500 @ 1
initcall print_all_ICs+0x0/0x500 returned 0 after 0 usecs
calling  hpet_late_init+0x0/0x1bc @ 1
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
hpet0: 3 comparators, 32-bit 25.000000 MHz counter
initcall hpet_late_init+0x0/0x1bc returned 0 after 43945 usecs
calling  clocksource_done_booting+0x0/0x36 @ 1
Switching to clocksource hpet
initcall clocksource_done_booting+0x0/0x36 returned 0 after 15813 usecs
calling  ftrace_init_debugfs+0x0/0x214 @ 1
initcall ftrace_init_debugfs+0x0/0x214 returned 0 after 101 usecs
calling  rb_init_debugfs+0x0/0x2f @ 1
initcall rb_init_debugfs+0x0/0x2f returned 0 after 4 usecs
calling  tracer_init_debugfs+0x0/0x33e @ 1
initcall tracer_init_debugfs+0x0/0x33e returned 0 after 191 usecs
calling  init_trace_printk_function_export+0x0/0x2f @ 1
initcall init_trace_printk_function_export+0x0/0x2f returned 0 after 4 usecs
calling  stat_workqueue_init+0x0/0x2d @ 1
initcall stat_workqueue_init+0x0/0x2d returned 0 after 5 usecs
calling  event_trace_init+0x0/0x1e2 @ 1
initcall event_trace_init+0x0/0x1e2 returned 0 after 21469 usecs
calling  init_pipe_fs+0x0/0x4c @ 1
initcall init_pipe_fs+0x0/0x4c returned 0 after 59 usecs
calling  eventpoll_init+0x0/0xc3 @ 1
initcall eventpoll_init+0x0/0xc3 returned 0 after 85 usecs
calling  anon_inode_init+0x0/0x123 @ 1
initcall anon_inode_init+0x0/0x123 returned 0 after 17 usecs
calling  blk_scsi_ioctl_init+0x0/0x289 @ 1
initcall blk_scsi_ioctl_init+0x0/0x289 returned 0 after 1 usecs
calling  acpi_event_init+0x0/0x80 @ 1
initcall acpi_event_init+0x0/0x80 returned 0 after 85 usecs
calling  pnpacpi_init+0x0/0x8c @ 1
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
initcall pnpacpi_init+0x0/0x8c returned 0 after 76194 usecs
calling  pnp_system_init+0x0/0x12 @ 1
system 00:01: ioport range 0x408-0x40f has been reserved
system 00:01: ioport range 0x4d0-0x4d1 has been reserved
system 00:01: ioport range 0x700-0x73f has been reserved
system 00:01: ioport range 0x800-0x8fe has been reserved
system 00:01: ioport range 0x900-0x9fe has been reserved
system 00:01: ioport range 0x9ff-0x9ff has been reserved
system 00:01: ioport range 0xa00-0xafe has been reserved
system 00:01: ioport range 0xaff-0xaff has been reserved
system 00:01: ioport range 0xb00-0xbfe has been reserved
system 00:01: ioport range 0xbff-0xbff has been reserved
system 00:01: ioport range 0xc80-0xc83 has been reserved
system 00:01: ioport range 0xcd4-0xcd7 has been reserved
system 00:01: ioport range 0xf50-0xf58 has been reserved
system 00:01: ioport range 0xca0-0xca1 has been reserved
system 00:01: ioport range 0xca4-0xca5 has been reserved
system 00:01: ioport range 0xcf9-0xcf9 could not be reserved
system 00:01: ioport range 0x3f8-0x3ff has been reserved
system 00:01: iomem range 0x80000000-0x8fffffff could not be reserved
system 00:01: iomem range 0xf7df0000-0xf7df0fff could not be reserved
system 00:01: iomem range 0xfdef0000-0xfdef0fff could not be reserved
initcall pnp_system_init+0x0/0x12 returned 0 after 544999 usecs
calling  chr_dev_init+0x0/0xc7 @ 1
initcall chr_dev_init+0x0/0xc7 returned 0 after 434 usecs
calling  firmware_class_init+0x0/0x79 @ 1
initcall firmware_class_init+0x0/0x79 returned 0 after 32 usecs
calling  init_pcmcia_bus+0x0/0x74 @ 1
initcall init_pcmcia_bus+0x0/0x74 returned 0 after 67 usecs
calling  cpufreq_gov_performance_init+0x0/0x12 @ 1
initcall cpufreq_gov_performance_init+0x0/0x12 returned 0 after 1 usecs
calling  cpufreq_gov_userspace_init+0x0/0x12 @ 1
initcall cpufreq_gov_userspace_init+0x0/0x12 returned 0 after 0 usecs
calling  init_acpi_pm_clocksource+0x0/0xef @ 1
initcall init_acpi_pm_clocksource+0x0/0xef returned 0 after 4426 usecs
calling  pcibios_assign_resources+0x0/0x76 @ 1
pci 0000:00:09.0: PCI bridge, secondary bus 0000:01
pci 0000:00:09.0:   IO window: 0x1000-0x2fff
pci 0000:00:09.0:   MEM window: 0xf7e00000-0xf7ffffff
pci 0000:00:09.0:   PREFETCH window: 0xe8000000-0xefffffff
pci 0000:02:00.0: PCI bridge, secondary bus 0000:03
pci 0000:02:00.0:   IO window: disabled
pci 0000:02:00.0:   MEM window: 0xf8000000-0xf9ffffff
pci 0000:02:00.0:   PREFETCH window: 0x90000000-0x900fffff
pci 0000:00:0b.0: PCI bridge, secondary bus 0000:02
pci 0000:00:0b.0:   IO window: disabled
pci 0000:00:0b.0:   MEM window: 0xf8000000-0xf9ffffff
pci 0000:00:0b.0:   PREFETCH window: 0x90000000-0x900fffff
pci 0000:04:00.0: PCI bridge, secondary bus 0000:05
pci 0000:04:00.0:   IO window: disabled
pci 0000:04:00.0:   MEM window: 0xfa000000-0xfbffffff
pci 0000:04:00.0:   PREFETCH window: 0x90100000-0x901fffff
pci 0000:00:0c.0: PCI bridge, secondary bus 0000:04
pci 0000:00:0c.0:   IO window: disabled
pci 0000:00:0c.0:   MEM window: 0xfa000000-0xfbffffff
pci 0000:00:0c.0:   PREFETCH window: 0x90100000-0x901fffff
pci 0000:06:00.0: PCI bridge, secondary bus 0000:07
pci 0000:06:00.0:   IO window: disabled
pci 0000:06:00.0:   MEM window: 0xfdc00000-0xfdcfffff
pci 0000:06:00.0:   PREFETCH window: disabled
pci 0000:00:0d.0: PCI bridge, secondary bus 0000:06
pci 0000:00:0d.0:   IO window: disabled
pci 0000:00:0d.0:   MEM window: 0xfdc00000-0xfdcfffff
pci 0000:00:0d.0:   PREFETCH window: disabled
pci 0000:00:0e.0: PCI bridge, secondary bus 0000:08
pci 0000:00:0e.0:   IO window: 0x3000-0x3fff
pci 0000:00:0e.0:   MEM window: 0xfdd00000-0xfddfffff
pci 0000:00:0e.0:   PREFETCH window: 0x90200000-0x902fffff
pci 0000:00:09.0: setting latency timer to 64
pci 0000:00:0b.0: setting latency timer to 64
pci 0000:02:00.0: setting latency timer to 64
pci 0000:00:0c.0: setting latency timer to 64
pci 0000:04:00.0: setting latency timer to 64
pci 0000:00:0d.0: setting latency timer to 64
pci 0000:06:00.0: setting latency timer to 64
pci 0000:00:0e.0: setting latency timer to 64
pci 0000:42:04.0: PCI bridge, secondary bus 0000:43
pci 0000:42:04.0:   IO window: disabled
pci 0000:42:04.0:   MEM window: disabled
pci 0000:42:04.0:   PREFETCH window: disabled
pci 0000:41:00.0: PCI bridge, secondary bus 0000:42
pci 0000:41:00.0:   IO window: 0x4000-0x4fff
pci 0000:41:00.0:   MEM window: 0xfdf00000-0xfdffffff
pci 0000:41:00.0:   PREFETCH window: 0x84000000-0x840fffff
pci 0000:40:0c.0: PCI bridge, secondary bus 0000:41
pci 0000:40:0c.0:   IO window: 0x4000-0x4fff
pci 0000:40:0c.0:   MEM window: 0xfdf00000-0xfdffffff
pci 0000:40:0c.0:   PREFETCH window: 0x84000000-0x840fffff
pci 0000:40:0d.0: PCI bridge, secondary bus 0000:44
pci 0000:40:0d.0:   IO window: disabled
pci 0000:40:0d.0:   MEM window: disabled
pci 0000:40:0d.0:   PREFETCH window: disabled
pci 0000:40:0e.0: PCI bridge, secondary bus 0000:47
pci 0000:40:0e.0:   IO window: disabled
pci 0000:40:0e.0:   MEM window: disabled
pci 0000:40:0e.0:   PREFETCH window: disabled
pci 0000:40:0c.0: setting latency timer to 64
pci 0000:41:00.0: setting latency timer to 64
pci 0000:40:0d.0: setting latency timer to 64
pci 0000:40:0e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0x3fff]
pci_bus 0000:00: resource 1 mem: [0x90000000-0xfddfffff]
pci_bus 0000:00: resource 2 mem: [0x80000000-0x83ffffff]
pci_bus 0000:00: resource 3 mem: [0x0a0000-0x0bffff]
pci_bus 0000:00: resource 4 mem: [0xfe000000-0xffffffff]
pci_bus 0000:00: resource 5 mem: [0x280000000-0xfcffffffff]
pci_bus 0000:01: resource 0 io:  [0x1000-0x2fff]
pci_bus 0000:01: resource 1 mem: [0xf7e00000-0xf7ffffff]
pci_bus 0000:01: resource 2 pref mem [0xe8000000-0xefffffff]
pci_bus 0000:01: resource 3 io:  [0x00-0x3fff]
pci_bus 0000:01: resource 4 mem: [0x90000000-0xfddfffff]
pci_bus 0000:01: resource 5 mem: [0x80000000-0x83ffffff]
pci_bus 0000:01: resource 6 mem: [0x0a0000-0x0bffff]
pci_bus 0000:01: resource 7 mem: [0xfe000000-0xffffffff]
pci_bus 0000:01: resource 8 mem: [0x280000000-0xfcffffffff]
pci_bus 0000:02: resource 1 mem: [0xf8000000-0xf9ffffff]
pci_bus 0000:02: resource 2 pref mem [0x90000000-0x900fffff]
pci_bus 0000:03: resource 1 mem: [0xf8000000-0xf9ffffff]
pci_bus 0000:03: resource 2 pref mem [0x90000000-0x900fffff]
pci_bus 0000:04: resource 1 mem: [0xfa000000-0xfbffffff]
pci_bus 0000:04: resource 2 pref mem [0x90100000-0x901fffff]
pci_bus 0000:05: resource 1 mem: [0xfa000000-0xfbffffff]
pci_bus 0000:05: resource 2 pref mem [0x90100000-0x901fffff]
pci_bus 0000:06: resource 1 mem: [0xfdc00000-0xfdcfffff]
pci_bus 0000:07: resource 1 mem: [0xfdc00000-0xfdcfffff]
pci_bus 0000:08: resource 0 io:  [0x3000-0x3fff]
pci_bus 0000:08: resource 1 mem: [0xfdd00000-0xfddfffff]
pci_bus 0000:08: resource 2 pref mem [0x90200000-0x902fffff]
pci_bus 0000:40: resource 0 io:  [0x4000-0xffff]
pci_bus 0000:40: resource 1 mem: [0xfde00000-0xfdffffff]
pci_bus 0000:40: resource 2 mem: [0x84000000-0x8fffffff]
pci_bus 0000:41: resource 0 io:  [0x4000-0x4fff]
pci_bus 0000:41: resource 1 mem: [0xfdf00000-0xfdffffff]
pci_bus 0000:41: resource 2 pref mem [0x84000000-0x840fffff]
pci_bus 0000:42: resource 0 io:  [0x4000-0x4fff]
pci_bus 0000:42: resource 1 mem: [0xfdf00000-0xfdffffff]
pci_bus 0000:42: resource 2 pref mem [0x84000000-0x840fffff]
initcall pcibios_assign_resources+0x0/0x76 returned 0 after 2365274 usecs
calling  sysctl_core_init+0x0/0x38 @ 1
initcall sysctl_core_init+0x0/0x38 returned 0 after 15 usecs
calling  inet_init+0x0/0x204 @ 1
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
initcall inet_init+0x0/0x204 returned 0 after 163315 usecs
calling  af_unix_init+0x0/0x55 @ 1
NET: Registered protocol family 1
initcall af_unix_init+0x0/0x55 returned 0 after 17549 usecs
calling  pci_apply_final_quirks+0x0/0x35 @ 1
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:0b.0: Found disabled HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:0c.0: Found enabled HT MSI Mapping
pci 0000:00:0d.0: Found enabled HT MSI Mapping
pci 0000:00:0e.0: Found enabled HT MSI Mapping
pci 0000:01:03.0: Boot video device
pci 0000:01:04.4: HCRESET not completed yet!
pci 0000:40:0c.0: Found enabled HT MSI Mapping
pci 0000:40:0d.0: Found enabled HT MSI Mapping
pci 0000:40:0e.0: Found enabled HT MSI Mapping
initcall pci_apply_final_quirks+0x0/0x35 returned 0 after 249604 usecs
calling  populate_rootfs+0x0/0x23a @ 1
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 1292k freed
initcall populate_rootfs+0x0/0x23a returned 0 after 67185 usecs
calling  pci_iommu_init+0x0/0x21 @ 1
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 20000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
initcall pci_iommu_init+0x0/0x21 returned 0 after 79028 usecs
calling  calgary_fixup_tce_spaces+0x0/0xee @ 1
initcall calgary_fixup_tce_spaces+0x0/0xee returned -19 after 0 usecs
calling  i8259A_init_sysfs+0x0/0x22 @ 1
initcall i8259A_init_sysfs+0x0/0x22 returned 0 after 86 usecs
calling  vsyscall_init+0x0/0x6c @ 1
initcall vsyscall_init+0x0/0x6c returned 0 after 17 usecs
calling  sbf_init+0x0/0xd7 @ 1
initcall sbf_init+0x0/0xd7 returned 0 after 0 usecs
calling  i8237A_init_sysfs+0x0/0x22 @ 1
initcall i8237A_init_sysfs+0x0/0x22 returned 0 after 57 usecs
calling  add_rtc_cmos+0x0/0xa4 @ 1
platform rtc_cmos: registered platform RTC device (no PNP device found)
initcall add_rtc_cmos+0x0/0xa4 returned 0 after 36104 usecs
calling  cache_sysfs_init+0x0/0x5e @ 1
initcall cache_sysfs_init+0x0/0x5e returned 0 after 697 usecs
calling  mce_init_device+0x0/0xf8 @ 1
initcall mce_init_device+0x0/0xf8 returned 0 after 255 usecs
calling  threshold_init_device+0x0/0x44 @ 1
initcall threshold_init_device+0x0/0x44 returned 0 after 1 usecs
calling  thermal_throttle_init_device+0x0/0x89 @ 1
initcall thermal_throttle_init_device+0x0/0x89 returned 0 after 0 usecs
calling  msr_init+0x0/0x104 @ 1
initcall msr_init+0x0/0x104 returned 0 after 215 usecs
calling  cpuid_init+0x0/0x104 @ 1
initcall cpuid_init+0x0/0x104 returned 0 after 217 usecs
calling  ioapic_init_sysfs+0x0/0x99 @ 1
initcall ioapic_init_sysfs+0x0/0x99 returned 0 after 97 usecs
calling  add_pcspkr+0x0/0x28 @ 1
initcall add_pcspkr+0x0/0x28 returned 0 after 44 usecs
calling  audit_classes_init+0x0/0xaf @ 1
initcall audit_classes_init+0x0/0xaf returned 0 after 12 usecs
calling  init_vdso_vars+0x0/0x19d @ 1
initcall init_vdso_vars+0x0/0x19d returned 0 after 15 usecs
calling  ia32_binfmt_init+0x0/0x14 @ 1
initcall ia32_binfmt_init+0x0/0x14 returned 0 after 2 usecs
calling  sysenter_setup+0x0/0x2cc @ 1
initcall sysenter_setup+0x0/0x2cc returned 0 after 4 usecs
calling  init_sched_debug_procfs+0x0/0x29 @ 1
initcall init_sched_debug_procfs+0x0/0x29 returned 0 after 10 usecs
calling  proc_schedstat_init+0x0/0x1f @ 1
initcall proc_schedstat_init+0x0/0x1f returned 0 after 6 usecs
calling  proc_execdomains_init+0x0/0x22 @ 1
initcall proc_execdomains_init+0x0/0x22 returned 0 after 6 usecs
calling  ioresources_init+0x0/0x36 @ 1
initcall ioresources_init+0x0/0x36 returned 0 after 11 usecs
calling  uid_cache_init+0x0/0x70 @ 1
initcall uid_cache_init+0x0/0x70 returned 0 after 37 usecs
calling  init_posix_timers+0x0/0x1b5 @ 1
initcall init_posix_timers+0x0/0x1b5 returned 0 after 25 usecs
calling  init_posix_cpu_timers+0x0/0x101 @ 1
initcall init_posix_cpu_timers+0x0/0x101 returned 0 after 1 usecs
calling  nsproxy_cache_init+0x0/0x2d @ 1
initcall nsproxy_cache_init+0x0/0x2d returned 0 after 24 usecs
calling  create_proc_profile+0x0/0x23b @ 1
initcall create_proc_profile+0x0/0x23b returned 0 after 0 usecs
calling  timekeeping_init_device+0x0/0x22 @ 1
initcall timekeeping_init_device+0x0/0x22 returned 0 after 62 usecs
calling  init_clocksource_sysfs+0x0/0x50 @ 1
initcall init_clocksource_sysfs+0x0/0x50 returned 0 after 59 usecs
calling  init_timer_list_procfs+0x0/0x2c @ 1
initcall init_timer_list_procfs+0x0/0x2c returned 0 after 6 usecs
calling  init_tstats_procfs+0x0/0x2c @ 1
initcall init_tstats_procfs+0x0/0x2c returned 0 after 6 usecs
calling  futex_init+0x0/0x63 @ 1
initcall futex_init+0x0/0x63 returned 0 after 9 usecs
calling  proc_dma_init+0x0/0x22 @ 1
initcall proc_dma_init+0x0/0x22 returned 0 after 6 usecs
calling  proc_modules_init+0x0/0x22 @ 1
initcall proc_modules_init+0x0/0x22 returned 0 after 6 usecs
calling  kallsyms_init+0x0/0x25 @ 1
initcall kallsyms_init+0x0/0x25 returned 0 after 9 usecs
calling  snapshot_device_init+0x0/0x12 @ 1
initcall snapshot_device_init+0x0/0x12 returned 0 after 44 usecs
calling  crash_save_vmcoreinfo_init+0x0/0x46d @ 1
initcall crash_save_vmcoreinfo_init+0x0/0x46d returned 0 after 22 usecs
calling  crash_notes_memory_init+0x0/0x36 @ 1
initcall crash_notes_memory_init+0x0/0x36 returned 0 after 6 usecs
calling  pid_namespaces_init+0x0/0x2d @ 1
initcall pid_namespaces_init+0x0/0x2d returned 0 after 38 usecs
calling  audit_init+0x0/0x133 @ 1
audit: initializing netlink socket (disabled)
type=3D2000 audit(1259751385.989:1): initialized
initcall audit_init+0x0/0x133 returned 0 after 34178 usecs
calling  audit_tree_init+0x0/0x49 @ 1
initcall audit_tree_init+0x0/0x49 returned 0 after 2 usecs
calling  init_kprobes+0x0/0x167 @ 1
initcall init_kprobes+0x0/0x167 returned 0 after 7162 usecs
calling  hung_task_init+0x0/0x53 @ 1
initcall hung_task_init+0x0/0x53 returned 0 after 58 usecs
calling  utsname_sysctl_init+0x0/0x14 @ 1
initcall utsname_sysctl_init+0x0/0x14 returned 0 after 3 usecs
calling  init_tracepoints+0x0/0x17 @ 1
initcall init_tracepoints+0x0/0x17 returned 0 after 0 usecs
calling  init_lstats_procfs+0x0/0x25 @ 1
initcall init_lstats_procfs+0x0/0x25 returned 0 after 8 usecs
calling  ftrace_mod_cmd_init+0x0/0x12 @ 1
initcall ftrace_mod_cmd_init+0x0/0x12 returned 0 after 1 usecs
calling  init_events+0x0/0x62 @ 1
initcall init_events+0x0/0x62 returned 0 after 6 usecs
calling  init_sched_switch_trace+0x0/0x12 @ 1
initcall init_sched_switch_trace+0x0/0x12 returned 0 after 1 usecs
calling  init_stack_trace+0x0/0x12 @ 1
initcall init_stack_trace+0x0/0x12 returned 0 after 1 usecs
calling  init_function_trace+0x0/0x3e @ 1
initcall init_function_trace+0x0/0x3e returned 0 after 1 usecs
calling  init_wakeup_tracer+0x0/0x22 @ 1
initcall init_wakeup_tracer+0x0/0x22 returned 0 after 1 usecs
calling  stack_trace_init+0x0/0x6b @ 1
initcall stack_trace_init+0x0/0x6b returned 0 after 18 usecs
calling  init_graph_trace+0x0/0x32 @ 1
initcall init_graph_trace+0x0/0x32 returned 0 after 1 usecs
calling  init_kmem_tracer+0x0/0x56 @ 1
initcall init_kmem_tracer+0x0/0x56 returned 0 after 2 usecs
calling  init_blk_tracer+0x0/0x57 @ 1
initcall init_blk_tracer+0x0/0x57 returned 0 after 2 usecs
calling  perf_event_sysfs_init+0x0/0x19 @ 1
initcall perf_event_sysfs_init+0x0/0x19 returned 0 after 7 usecs
calling  init_per_zone_wmark_min+0x0/0x70 @ 1
initcall init_per_zone_wmark_min+0x0/0x70 returned 0 after 502 usecs
calling  kswapd_init+0x0/0x4d @ 1
initcall kswapd_init+0x0/0x4d returned 0 after 98 usecs
calling  setup_vmstat+0x0/0xae @ 1
initcall setup_vmstat+0x0/0xae returned 0 after 30 usecs
calling  mm_sysfs_init+0x0/0x29 @ 1
initcall mm_sysfs_init+0x0/0x29 returned 0 after 7 usecs
calling  proc_vmalloc_init+0x0/0x25 @ 1
initcall proc_vmalloc_init+0x0/0x25 returned 0 after 6 usecs
calling  procswaps_init+0x0/0x22 @ 1
initcall procswaps_init+0x0/0x22 returned 0 after 6 usecs
calling  hugetlb_init+0x0/0x31a @ 1
HugeTLB registered 2 MB page size, pre-allocated 0 pages
initcall hugetlb_init+0x0/0x31a returned 0 after 27370 usecs
calling  ksm_init+0x0/0x16f @ 1
initcall ksm_init+0x0/0x16f returned 0 after 167 usecs
calling  slab_proc_init+0x0/0x25 @ 1
initcall slab_proc_init+0x0/0x25 returned 0 after 7 usecs
calling  slab_sysfs_init+0x0/0xf0 @ 1
initcall slab_sysfs_init+0x0/0xf0 returned 0 after 6445 usecs
calling  fasync_init+0x0/0x2a @ 1
initcall fasync_init+0x0/0x2a returned 0 after 99 usecs
calling  proc_filesystems_init+0x0/0x22 @ 1
initcall proc_filesystems_init+0x0/0x22 returned 0 after 7 usecs
calling  dnotify_init+0x0/0x80 @ 1
initcall dnotify_init+0x0/0x80 returned 0 after 205 usecs
calling  inotify_setup+0x0/0x12 @ 1
initcall inotify_setup+0x0/0x12 returned 0 after 0 usecs
calling  inotify_user_setup+0x0/0xbe @ 1
initcall inotify_user_setup+0x0/0xbe returned 0 after 221 usecs
calling  aio_setup+0x0/0x9f @ 1
initcall aio_setup+0x0/0x9f returned 0 after 388 usecs
calling  proc_locks_init+0x0/0x22 @ 1
initcall proc_locks_init+0x0/0x22 returned 0 after 40 usecs
calling  init_sys32_ioctl+0x0/0x7c @ 1
initcall init_sys32_ioctl+0x0/0x7c returned 0 after 14 usecs
calling  init_mbcache+0x0/0x14 @ 1
initcall init_mbcache+0x0/0x14 returned 0 after 1 usecs
calling  dquot_init+0x0/0xfe @ 1
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
initcall dquot_init+0x0/0xfe returned 0 after 34791 usecs
calling  init_v2_quota_format+0x0/0x12 @ 1
initcall init_v2_quota_format+0x0/0x12 returned 0 after 0 usecs
calling  proc_cmdline_init+0x0/0x22 @ 1
initcall proc_cmdline_init+0x0/0x22 returned 0 after 14 usecs
calling  proc_cpuinfo_init+0x0/0x22 @ 1
initcall proc_cpuinfo_init+0x0/0x22 returned 0 after 5 usecs
calling  proc_devices_init+0x0/0x22 @ 1
initcall proc_devices_init+0x0/0x22 returned 0 after 5 usecs
calling  proc_interrupts_init+0x0/0x22 @ 1
initcall proc_interrupts_init+0x0/0x22 returned 0 after 5 usecs
calling  proc_loadavg_init+0x0/0x22 @ 1
initcall proc_loadavg_init+0x0/0x22 returned 0 after 5 usecs
calling  proc_meminfo_init+0x0/0x22 @ 1
initcall proc_meminfo_init+0x0/0x22 returned 0 after 5 usecs
calling  proc_stat_init+0x0/0x22 @ 1
initcall proc_stat_init+0x0/0x22 returned 0 after 5 usecs
calling  proc_uptime_init+0x0/0x22 @ 1
initcall proc_uptime_init+0x0/0x22 returned 0 after 5 usecs
calling  proc_version_init+0x0/0x22 @ 1
initcall proc_version_init+0x0/0x22 returned 0 after 5 usecs
calling  proc_softirqs_init+0x0/0x22 @ 1
initcall proc_softirqs_init+0x0/0x22 returned 0 after 5 usecs
calling  proc_kcore_init+0x0/0xb5 @ 1
initcall proc_kcore_init+0x0/0xb5 returned 0 after 14 usecs
calling  vmcore_init+0x0/0x8e2 @ 1
initcall vmcore_init+0x0/0x8e2 returned 0 after 1 usecs
calling  proc_kmsg_init+0x0/0x25 @ 1
initcall proc_kmsg_init+0x0/0x25 returned 0 after 5 usecs
calling  proc_page_init+0x0/0x3c @ 1
initcall proc_page_init+0x0/0x3c returned 0 after 10 usecs
calling  configfs_init+0x0/0xb3 @ 1
initcall configfs_init+0x0/0xb3 returned 0 after 124 usecs
calling  init_devpts_fs+0x0/0x4d @ 1
initcall init_devpts_fs+0x0/0x4d returned 0 after 42 usecs
calling  init_ext3_fs+0x0/0x6b @ 1
initcall init_ext3_fs+0x0/0x6b returned 0 after 221 usecs
calling  journal_init+0x0/0x99 @ 1
initcall journal_init+0x0/0x99 returned 0 after 410 usecs
calling  init_ramfs_fs+0x0/0x12 @ 1
initcall init_ramfs_fs+0x0/0x12 returned 0 after 1 usecs
calling  init_hugetlbfs_fs+0x0/0x98 @ 1
initcall init_hugetlbfs_fs+0x0/0x98 returned 0 after 122 usecs
calling  init_iso9660_fs+0x0/0x6c @ 1
initcall init_iso9660_fs+0x0/0x6c returned 0 after 126 usecs
calling  init_nls_cp437+0x0/0x12 @ 1
initcall init_nls_cp437+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_ascii+0x0/0x12 @ 1
initcall init_nls_ascii+0x0/0x12 returned 0 after 0 usecs
calling  ipc_init+0x0/0x2f @ 1
msgmni has been set to 16004
initcall ipc_init+0x0/0x2f returned 0 after 14631 usecs
calling  ipc_sysctl_init+0x0/0x14 @ 1
initcall ipc_sysctl_init+0x0/0x14 returned 0 after 2 usecs
calling  init_mqueue_fs+0x0/0xb4 @ 1
initcall init_mqueue_fs+0x0/0xb4 returned 0 after 126 usecs
calling  key_proc_init+0x0/0x53 @ 1
initcall key_proc_init+0x0/0x53 returned 0 after 13 usecs
calling  selinux_nf_ip_init+0x0/0x60 @ 1
initcall selinux_nf_ip_init+0x0/0x60 returned 0 after 0 usecs
calling  init_sel_fs+0x0/0x69 @ 1
initcall init_sel_fs+0x0/0x69 returned 0 after 0 usecs
calling  selnl_init+0x0/0x4d @ 1
initcall selnl_init+0x0/0x4d returned 0 after 18 usecs
calling  sel_netif_init+0x0/0x66 @ 1
initcall sel_netif_init+0x0/0x66 returned 0 after 0 usecs
calling  sel_netnode_init+0x0/0x72 @ 1
initcall sel_netnode_init+0x0/0x72 returned 0 after 0 usecs
calling  sel_netport_init+0x0/0x72 @ 1
initcall sel_netport_init+0x0/0x72 returned 0 after 0 usecs
calling  aurule_init+0x0/0x37 @ 1
initcall aurule_init+0x0/0x37 returned 0 after 1 usecs
calling  crypto_wq_init+0x0/0x2e @ 1
initcall crypto_wq_init+0x0/0x2e returned 0 after 211 usecs
calling  crypto_algapi_init+0x0/0xd @ 1
initcall crypto_algapi_init+0x0/0xd returned 0 after 8 usecs
calling  skcipher_module_init+0x0/0x35 @ 1
initcall skcipher_module_init+0x0/0x35 returned 0 after 0 usecs
calling  chainiv_module_init+0x0/0x12 @ 1
initcall chainiv_module_init+0x0/0x12 returned 0 after 2 usecs
calling  eseqiv_module_init+0x0/0x12 @ 1
initcall eseqiv_module_init+0x0/0x12 returned 0 after 0 usecs
calling  hmac_module_init+0x0/0x12 @ 1
initcall hmac_module_init+0x0/0x12 returned 0 after 0 usecs
calling  md5_mod_init+0x0/0x12 @ 1
initcall md5_mod_init+0x0/0x12 returned 0 after 106 usecs
calling  sha1_generic_mod_init+0x0/0x12 @ 1
initcall sha1_generic_mod_init+0x0/0x12 returned 0 after 82 usecs
calling  crc32c_mod_init+0x0/0x12 @ 1
initcall crc32c_mod_init+0x0/0x12 returned 0 after 154 usecs
calling  krng_mod_init+0x0/0x12 @ 1
alg: No test for stdrng (krng)
initcall krng_mod_init+0x0/0x12 returned 0 after 14468 usecs
calling  proc_genhd_init+0x0/0x36 @ 1
initcall proc_genhd_init+0x0/0x36 returned 0 after 12 usecs
calling  bsg_init+0x0/0x12e @ 1
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
initcall bsg_init+0x0/0x12e returned 0 after 33205 usecs
calling  noop_init+0x0/0x14 @ 1
io scheduler noop registered
initcall noop_init+0x0/0x14 returned 0 after 13699 usecs
calling  as_init+0x0/0x14 @ 1
io scheduler anticipatory registered
initcall as_init+0x0/0x14 returned 0 after 17331 usecs
calling  deadline_init+0x0/0x14 @ 1
io scheduler deadline registered
initcall deadline_init+0x0/0x14 returned 0 after 15610 usecs
calling  cfq_init+0x0/0x94 @ 1
io scheduler cfq registered (default)
initcall cfq_init+0x0/0x94 returned 0 after 19533 usecs
calling  percpu_counter_startup+0x0/0x19 @ 1
initcall percpu_counter_startup+0x0/0x19 returned 0 after 2 usecs
calling  dynamic_debug_init+0x0/0x12b @ 1
initcall dynamic_debug_init+0x0/0x12b returned 0 after 143 usecs
calling  pci_proc_init+0x0/0x6a @ 1
initcall pci_proc_init+0x0/0x6a returned 0 after 424 usecs
calling  pcie_portdrv_init+0x0/0x4c @ 1
  alloc irq_desc for 62 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:00:0b.0: irq 62 for MSI/MSI-X
pcieport 0000:00:0b.0: setting latency timer to 64
  alloc irq_desc for 63 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:00:0c.0: irq 63 for MSI/MSI-X
pcieport 0000:00:0c.0: setting latency timer to 64
  alloc irq_desc for 64 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:00:0d.0: irq 64 for MSI/MSI-X
pcieport 0000:00:0d.0: setting latency timer to 64
  alloc irq_desc for 65 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:00:0e.0: irq 65 for MSI/MSI-X
pcieport 0000:00:0e.0: setting latency timer to 64
  alloc irq_desc for 66 on node 1
  alloc kstat_irqs on node 1
pcieport 0000:40:0c.0: irq 66 for MSI/MSI-X
pcieport 0000:40:0c.0: setting latency timer to 64
  alloc irq_desc for 67 on node 1
  alloc kstat_irqs on node 1
pcieport 0000:40:0d.0: irq 67 for MSI/MSI-X
pcieport 0000:40:0d.0: setting latency timer to 64
  alloc irq_desc for 68 on node 1
  alloc kstat_irqs on node 1
pcieport 0000:40:0e.0: irq 68 for MSI/MSI-X
pcieport 0000:40:0e.0: setting latency timer to 64
initcall pcie_portdrv_init+0x0/0x4c returned 0 after 522816 usecs
calling  aer_service_init+0x0/0x2b @ 1
aer 0000:00:0b.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:00:0c.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:00:0d.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:00:0e.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:40:0c.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:40:0d.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:40:0e.0:pcie02: AER service couldn't init device: no _OSC support
initcall aer_service_init+0x0/0x2b returned 0 after 259858 usecs
calling  pci_hotplug_init+0x0/0x1d @ 1
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
initcall pci_hotplug_init+0x0/0x1d returned 0 after 24451 usecs
calling  pcied_init+0x0/0x7a @ 1
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
initcall pcied_init+0x0/0x7a returned 0 after 30345 usecs
calling  acpiphp_init+0x0/0x5f @ 1
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
initcall acpiphp_init+0x0/0x5f returned -19 after 28726 usecs
calling  pci_stub_init+0x0/0x12a @ 1
pci-stub: invalid id string ""
initcall pci_stub_init+0x0/0x12a returned 0 after 14273 usecs
calling  fb_console_init+0x0/0x12a @ 1
initcall fb_console_init+0x0/0x12a returned 0 after 50 usecs
calling  xenfb_init+0x0/0x44 @ 1
initcall xenfb_init+0x0/0x44 returned -19 after 0 usecs
calling  vesafb_init+0x0/0x235 @ 1
initcall vesafb_init+0x0/0x235 returned 0 after 92 usecs
calling  efifb_init+0x0/0x1f2 @ 1
initcall efifb_init+0x0/0x1f2 returned -19 after 4 usecs
calling  acpi_reserve_resources+0x0/0xeb @ 1
initcall acpi_reserve_resources+0x0/0xeb returned 0 after 6 usecs
calling  irqrouter_init_sysfs+0x0/0x38 @ 1
initcall irqrouter_init_sysfs+0x0/0x38 returned 0 after 58 usecs
calling  acpi_ac_init+0x0/0x45 @ 1
initcall acpi_ac_init+0x0/0x45 returned 0 after 71 usecs
calling  acpi_button_init+0x0/0x56 @ 1
input: Power Button as /class/input/input0
ACPI: Power Button [PWRF]
initcall acpi_button_init+0x0/0x56 returned 0 after 34923 usecs
calling  acpi_fan_init+0x0/0x56 @ 1
initcall acpi_fan_init+0x0/0x56 returned 0 after 44 usecs
calling  acpi_pci_slot_init+0x0/0x20 @ 1
initcall acpi_pci_slot_init+0x0/0x20 returned 0 after 1306 usecs
calling  acpi_processor_init+0x0/0x10e @ 1
processor LNXCPU:00: registered as cooling_device0
processor LNXCPU:01: registered as cooling_device1
processor LNXCPU:02: registered as cooling_device2
processor LNXCPU:03: registered as cooling_device3
initcall acpi_processor_init+0x0/0x10e returned 0 after 101232 usecs
calling  acpi_container_init+0x0/0x42 @ 1
initcall acpi_container_init+0x0/0x42 returned 0 after 3767 usecs
calling  acpi_thermal_init+0x0/0x7b @ 1
initcall acpi_thermal_init+0x0/0x7b returned 0 after 119 usecs
calling  acpi_battery_init+0x0/0x16 @ 1
initcall acpi_battery_init+0x0/0x16 returned 0 after 5 usecs
calling  1_acpi_battery_init_async+0x0/0x3c @ 76
initcall 1_acpi_battery_init_async+0x0/0x3c returned 0 after 70 usecs
calling  hypervisor_subsys_init+0x0/0x25 @ 1
initcall hypervisor_subsys_init+0x0/0x25 returned -19 after 0 usecs
calling  hyper_sysfs_init+0x0/0xb3 @ 1
initcall hyper_sysfs_init+0x0/0xb3 returned -19 after 0 usecs
calling  rand_initialize+0x0/0x31 @ 1
initcall rand_initialize+0x0/0x31 returned 0 after 16 usecs
calling  tty_init+0x0/0xf5 @ 1
initcall tty_init+0x0/0xf5 returned 0 after 3142 usecs
calling  pty_init+0x0/0x284 @ 1
initcall pty_init+0x0/0x284 returned 0 after 63 usecs
calling  sysrq_init+0x0/0x25 @ 1
initcall sysrq_init+0x0/0x25 returned 0 after 12 usecs
calling  xen_init+0x0/0x78 @ 1
initcall xen_init+0x0/0x78 returned -19 after 0 usecs
calling  raw_init+0x0/0xe5 @ 1
initcall raw_init+0x0/0xe5 returned 0 after 81 usecs
calling  hpet_init+0x0/0x6a @ 1
initcall hpet_init+0x0/0x6a returned 0 after 218 usecs
calling  nvram_init+0x0/0x82 @ 1
Non-volatile memory driver v1.3
initcall nvram_init+0x0/0x82 returned 0 after 16632 usecs
calling  agp_init+0x0/0x26 @ 1
Linux agpgart interface v0.103
initcall agp_init+0x0/0x26 returned 0 after 15534 usecs
calling  agp_intel_init+0x0/0x29 @ 1
initcall agp_intel_init+0x0/0x29 returned 0 after 64 usecs
calling  agp_sis_init+0x0/0x29 @ 1
initcall agp_sis_init+0x0/0x29 returned 0 after 45 usecs
calling  agp_via_init+0x0/0x29 @ 1
initcall agp_via_init+0x0/0x29 returned 0 after 47 usecs
calling  init_tis+0x0/0x91 @ 1
initcall init_tis+0x0/0x91 returned 0 after 50 usecs
calling  cn_proc_init+0x0/0x3d @ 1
initcall cn_proc_init+0x0/0x3d returned 0 after 4 usecs
calling  serial8250_init+0x0/0x14c @ 1
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
async_waiting @ 1
async_continuing @ 1 after 0 usec
async_waiting @ 1
async_continuing @ 1 after 0 usec
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
async_waiting @ 1
async_continuing @ 1 after 0 usec
async_waiting @ 1
async_continuing @ 1 after 0 usec
serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
initcall serial8250_init+0x0/0x14c returned 0 after 636950 usecs
calling  serial8250_pnp_init+0x0/0x12 @ 1
00:09: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
initcall serial8250_pnp_init+0x0/0x12 returned 0 after 23544 usecs
calling  serial8250_pci_init+0x0/0x1b @ 1
initcall serial8250_pci_init+0x0/0x1b returned 0 after 100 usecs
calling  init_kgdboc+0x0/0x16 @ 1
initcall init_kgdboc+0x0/0x16 returned 0 after 1 usecs
calling  topology_sysfs_init+0x0/0x53 @ 1
initcall topology_sysfs_init+0x0/0x53 returned 0 after 87 usecs
calling  brd_init+0x0/0x160 @ 1
brd: module loaded
initcall brd_init+0x0/0x160 returned 0 after 9873 usecs
calling  loop_init+0x0/0x189 @ 1
loop: module loaded
initcall loop_init+0x0/0x189 returned 0 after 10711 usecs
calling  init_kgdbts+0x0/0x16 @ 1
initcall init_kgdbts+0x0/0x16 returned 0 after 0 usecs
calling  mac_hid_init+0x0/0x8e @ 1
input: Macintosh mouse button emulation as /class/input/input1
initcall mac_hid_init+0x0/0x8e returned 0 after 31259 usecs
calling  scsi_dh_init+0x0/0x3f @ 1
initcall scsi_dh_init+0x0/0x3f returned 0 after 1 usecs
calling  init_sd+0x0/0x181 @ 1
initcall init_sd+0x0/0x181 returned 0 after 240 usecs
calling  init_sr+0x0/0x49 @ 1
initcall init_sr+0x0/0x49 returned 0 after 35 usecs
calling  init_sg+0x0/0x122 @ 1
initcall init_sg+0x0/0x122 returned 0 after 89 usecs
calling  piix_init+0x0/0x29 @ 1
initcall piix_init+0x0/0x29 returned 0 after 61 usecs
calling  fixed_mdio_bus_init+0x0/0xf4 @ 1
Fixed MDIO Bus: probed
initcall fixed_mdio_bus_init+0x0/0xf4 returned 0 after 11175 usecs
calling  bnx2_init+0x0/0x1b @ 1
Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v2.0.2 (Aug 21, 2009)
ACPI: PCI Interrupt Link [LNKX] enabled at IRQ 17
  alloc irq_desc for 17 on node 0
  alloc kstat_irqs on node 0
bnx2 0000:03:00.0: PCI INT A -> Link[LNKX] -> GSI 17 (level, high) -> IRQ 17
bnx2 0000:03:00.0: firmware: using built-in firmware bnx2/bnx2-mips-06-5.0.=
0.j3.fw
bnx2 0000:03:00.0: firmware: using built-in firmware bnx2/bnx2-rv2p-06-5.0.=
0.j3.fw
eth0: Broadcom NetXtreme II BCM5708 1000Base-SX (B2) PCI-X 64-bit 133MHz fo=
und at mem f8000000, IRQ 17, node addr 00:18:fe:35:26:f6
ACPI: PCI Interrupt Link [LNKW] enabled at IRQ 16
  alloc irq_desc for 16 on node 0
  alloc kstat_irqs on node 0
bnx2 0000:05:00.0: PCI INT A -> Link[LNKW] -> GSI 16 (level, high) -> IRQ 16
bnx2 0000:05:00.0: firmware: using built-in firmware bnx2/bnx2-mips-06-5.0.=
0.j3.fw
bnx2 0000:05:00.0: firmware: using built-in firmware bnx2/bnx2-rv2p-06-5.0.=
0.j3.fw
eth1: Broadcom NetXtreme II BCM5708 1000Base-SX (B2) PCI-X 64-bit 133MHz fo=
und at mem fa000000, IRQ 16, node addr 00:18:fe:35:26:f4
initcall bnx2_init+0x0/0x1b returned 0 after 407371 usecs
calling  net_olddevs_init+0x0/0xa0 @ 1
initcall net_olddevs_init+0x0/0xa0 returned 0 after 5 usecs
calling  init_netconsole+0x0/0x206 @ 1
netconsole: local port 50000
netconsole: local IP 139.185.50.77
netconsole: interface eth0
netconsole: remote port 50000
netconsole: remote IP 139.185.50.76
netconsole: remote ethernet address 00:18:fe:34:1c:3d
netconsole: device eth0 not up yet, forcing it
  alloc irq_desc for 69 on node 0
  alloc kstat_irqs on node 0
bnx2 0000:03:00.0: irq 69 for MSI/MSI-X
bnx2: eth0: using MSI
bnx2: eth0 NIC SerDes Link is Up,=20
netconsole: carrier detect appears untrustworthy, waiting 4 seconds
1000 Mbps full duplex, receive & transmit flow control ON
bnx2: eth0 NIC SerDes Link is Down
bnx2: eth0 NIC SerDes Link is Up, 1000 Mbps full duplex, receive & transmit=
 flow control ON
Clocksource tsc unstable (delta =3D 4398045351495 ns)
console [netcon0] enabled
netconsole: network logging started
initcall init_netconsole+0x0/0x206 returned 0 after 34267379 usecs
calling  cdrom_init+0x0/0xd @ 1
initcall cdrom_init+0x0/0xd returned 0 after 21 usecs
calling  mon_init+0x0/0x103 @ 1
initcall mon_init+0x0/0x103 returned 0 after 167 usecs
calling  ehci_hcd_init+0x0/0xc0 @ 1
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ACPI: PCI Interrupt Link [LNU2] enabled at IRQ 23
  alloc irq_desc for 23 on node 0
  alloc kstat_irqs on node 0
ehci_hcd 0000:00:02.1: PCI INT B -> Link[LNU2] -> GSI 23 (level, high) -> I=
RQ 23
ehci_hcd 0000:00:02.1: setting latency timer to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.1: debug port 1
ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
ehci_hcd 0000:00:02.1: irq 23, io mem 0xf7dd0000
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=3D1d6b, idProduct=3D0002
usb usb1: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.32-rc8-git4 ehci_hcd
usb usb1: SerialNumber: 0000:00:02.1
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
initcall ehci_hcd_init+0x0/0xc0 returned 0 after 443576 usecs
calling  ohci_hcd_mod_init+0x0/0x92 @ 1
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LNU0] enabled at IRQ 22
  alloc irq_desc for 22 on node 0
  alloc kstat_irqs on node 0
ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNU0] -> GSI 22 (level, high) -> I=
RQ 22
ohci_hcd 0000:00:02.0: setting latency timer to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 22, io mem 0xf7de0000
usb usb2: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb2: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.32-rc8-git4 ohci_hcd
usb usb2: SerialNumber: 0000:00:02.0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
initcall ohci_hcd_mod_init+0x0/0x92 returned 0 after 431801 usecs
calling  uhci_hcd_init+0x0/0xc1 @ 1
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:01:04.4: PCI INT B -> Link[LNKX] -> GSI 17 (level, high) -> I=
RQ 17
uhci_hcd 0000:01:04.4: UHCI Host Controller
uhci_hcd 0000:01:04.4: new USB bus registered, assigned bus number 3
uhci_hcd 0000:01:04.4: port count misdetected? forcing to 2 ports
uhci_hcd 0000:01:04.4: HCRESET not completed yet!
uhci_hcd 0000:01:04.4: irq 17, io base 0x00001800
usb usb3: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb3: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.32-rc8-git4 uhci_hcd
usb usb3: SerialNumber: 0000:01:04.4
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
initcall uhci_hcd_init+0x0/0xc1 returned 0 after 286548 usecs
calling  i8042_init+0x0/0x3f9 @ 1
PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
initcall i8042_init+0x0/0x3f9 returned 0 after 69045 usecs
calling  serport_init+0x0/0x34 @ 1
initcall serport_init+0x0/0x34 returned 0 after 0 usecs
calling  mousedev_init+0x0/0x62 @ 1
mice: PS/2 mouse device common for all mice
initcall mousedev_init+0x0/0x62 returned 0 after 21133 usecs
calling  evdev_init+0x0/0x12 @ 1
initcall evdev_init+0x0/0x12 returned 0 after 109 usecs
usb 3-1: new full speed USB device using uhci_hcd and address 2
calling  atkbd_init+0x0/0x27 @ 1
initcall atkbd_init+0x0/0x27 returned 0 after 46 usecs
calling  psmouse_init+0x0/0x70 @ 1
initcall psmouse_init+0x0/0x70 returned 0 after 102 usecs
calling  xenkbd_init+0x0/0x44 @ 1
initcall xenkbd_init+0x0/0x44 returned -19 after 0 usecs
usb 3-1: New USB device found, idVendor=3D03f0, idProduct=3D1027
usb 3-1: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
usb 3-1: Product: Virtual Keyboard
usb 3-1: Manufacturer: HP
usb 3-1: configuration #1 chosen from 1 choice
usb 3-2: new full speed USB device using uhci_hcd and address 3
calling  cmos_init+0x0/0x6d @ 1
Driver 'rtc_cmos' needs updating - please use bus_type methods
rtc_cmos rtc_cmos: RTC can wake from S4
rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
initcall cmos_init+0x0/0x6d returned 0 after 88493 usecs
usb 3-2: New USB device found, idVendor=3D03f0, idProduct=3D1327
usb 3-2: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
usb 3-2: Product: Virtual Hub
usb 3-2: Manufacturer: HP
usb 3-2: configuration #1 chosen from 1 choice
hub 3-2:1.0: USB hub found
hub 3-2:1.0: 7 ports detected
calling  dm_init+0x0/0x49 @ 1
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redha=
t.com
initcall dm_init+0x0/0x49 returned 0 after 51762 usecs
calling  dm_snapshot_init+0x0/0x238 @ 1
initcall dm_snapshot_init+0x0/0x238 returned 0 after 403 usecs
calling  dm_mirror_init+0x0/0x79 @ 1
initcall dm_mirror_init+0x0/0x79 returned 0 after 106 usecs
calling  dm_dirty_log_init+0x0/0x59 @ 1
initcall dm_dirty_log_init+0x0/0x59 returned 0 after 1 usecs
calling  dm_zero_init+0x0/0x31 @ 1
initcall dm_zero_init+0x0/0x31 returned 0 after 0 usecs
calling  init_ladder+0x0/0x12 @ 1
cpuidle: using governor ladder
initcall init_ladder+0x0/0x12 returned 0 after 14649 usecs
calling  init_menu+0x0/0x12 @ 1
cpuidle: using governor menu
initcall init_menu+0x0/0x12 returned 0 after 13681 usecs
calling  efivars_init+0x0/0x1f9 @ 1
initcall efivars_init+0x0/0x1f9 returned -19 after 0 usecs
calling  hid_init+0x0/0x66 @ 1
initcall hid_init+0x0/0x66 returned 0 after 103 usecs
calling  a4_init+0x0/0x1b @ 1
initcall a4_init+0x0/0x1b returned 0 after 48 usecs
calling  apple_init+0x0/0x38 @ 1
initcall apple_init+0x0/0x38 returned 0 after 52 usecs
calling  belkin_init+0x0/0x1b @ 1
initcall belkin_init+0x0/0x1b returned 0 after 37 usecs
calling  ch_init+0x0/0x1b @ 1
initcall ch_init+0x0/0x1b returned 0 after 36 usecs
calling  ch_init+0x0/0x1b @ 1
initcall ch_init+0x0/0x1b returned 0 after 37 usecs
calling  cp_init+0x0/0x1b @ 1
initcall cp_init+0x0/0x1b returned 0 after 41 usecs
calling  dr_init+0x0/0x1b @ 1
initcall dr_init+0x0/0x1b returned 0 after 37 usecs
calling  ez_init+0x0/0x1b @ 1
initcall ez_init+0x0/0x1b returned 0 after 36 usecs
calling  gyration_init+0x0/0x1b @ 1
initcall gyration_init+0x0/0x1b returned 0 after 40 usecs
calling  ks_init+0x0/0x1b @ 1
initcall ks_init+0x0/0x1b returned 0 after 36 usecs
calling  kye_init+0x0/0x1b @ 1
initcall kye_init+0x0/0x1b returned 0 after 36 usecs
calling  lg_init+0x0/0x1b @ 1
initcall lg_init+0x0/0x1b returned 0 after 36 usecs
calling  ms_init+0x0/0x1b @ 1
initcall ms_init+0x0/0x1b returned 0 after 36 usecs
calling  mr_init+0x0/0x1b @ 1
initcall mr_init+0x0/0x1b returned 0 after 41 usecs
calling  ntrig_init+0x0/0x1b @ 1
initcall ntrig_init+0x0/0x1b returned 0 after 36 usecs
calling  pl_init+0x0/0x1b @ 1
initcall pl_init+0x0/0x1b returned 0 after 37 usecs
calling  pl_init+0x0/0x1b @ 1
initcall pl_init+0x0/0x1b returned 0 after 37 usecs
calling  samsung_init+0x0/0x1b @ 1
initcall samsung_init+0x0/0x1b returned 0 after 36 usecs
calling  sjoy_init+0x0/0x1b @ 1
initcall sjoy_init+0x0/0x1b returned 0 after 37 usecs
calling  sony_init+0x0/0x1b @ 1
initcall sony_init+0x0/0x1b returned 0 after 36 usecs
calling  sp_init+0x0/0x1b @ 1
initcall sp_init+0x0/0x1b returned 0 after 37 usecs
calling  ga_init+0x0/0x1b @ 1
initcall ga_init+0x0/0x1b returned 0 after 41 usecs
calling  tm_init+0x0/0x1b @ 1
initcall tm_init+0x0/0x1b returned 0 after 37 usecs
calling  ts_init+0x0/0x1b @ 1
initcall ts_init+0x0/0x1b returned 0 after 36 usecs
calling  twinhan_init+0x0/0x1b @ 1
initcall twinhan_init+0x0/0x1b returned 0 after 37 usecs
calling  zp_init+0x0/0x1b @ 1
initcall zp_init+0x0/0x1b returned 0 after 37 usecs
calling  hid_init+0x0/0xc7 @ 1
usbcore: registered new interface driver hiddev
input: HP Virtual Keyboard as /class/input/input2
generic-usb 0003:03F0:1027.0001: input,hidraw0: USB HID v1.01 Keyboard [HP =
Virtual Keyboard] on usb-0000:01:04.4-1/input0
input: HP Virtual Keyboard as /class/input/input3
generic-usb 0003:03F0:1027.0002: input,hidraw1: USB HID v1.01 Mouse [HP Vir=
tual Keyboard] on usb-0000:01:04.4-1/input1
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
initcall hid_init+0x0/0xc7 returned 0 after 151333 usecs
calling  staging_init+0x0/0x8 @ 1
initcall staging_init+0x0/0x8 returned 0 after 0 usecs
calling  flow_cache_init+0x0/0x187 @ 1
initcall flow_cache_init+0x0/0x187 returned 0 after 162 usecs
calling  blackhole_module_init+0x0/0x12 @ 1
initcall blackhole_module_init+0x0/0x12 returned 0 after 1 usecs
calling  init_cgroup_cls+0x0/0x12 @ 1
initcall init_cgroup_cls+0x0/0x12 returned 0 after 1 usecs
calling  nf_conntrack_standalone_init+0x0/0x12 @ 1
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=3D1 kernel parameter, acct=3D1 nf_conntrack module option=
 or
sysctl net.netfilter.nf_conntrack_acct=3D1 to enable it.
initcall nf_conntrack_standalone_init+0x0/0x12 returned 0 after 125023 usecs
calling  xt_init+0x0/0x129 @ 1
initcall xt_init+0x0/0x129 returned 0 after 7 usecs
calling  tcpudp_mt_init+0x0/0x17 @ 1
initcall tcpudp_mt_init+0x0/0x17 returned 0 after 1 usecs
calling  conntrack_mt_init+0x0/0x17 @ 1
initcall conntrack_mt_init+0x0/0x17 returned 0 after 0 usecs
calling  state_mt_init+0x0/0x17 @ 1
initcall state_mt_init+0x0/0x17 returned 0 after 0 usecs
calling  sysctl_ipv4_init+0x0/0x4e @ 1
initcall sysctl_ipv4_init+0x0/0x4e returned 0 after 10 usecs
calling  init_syncookies+0x0/0x19 @ 1
initcall init_syncookies+0x0/0x19 returned 0 after 26 usecs
calling  ipv4_netfilter_init+0x0/0x17 @ 1
initcall ipv4_netfilter_init+0x0/0x17 returned 0 after 1 usecs
calling  nf_conntrack_l3proto_ipv4_init+0x0/0x12d @ 1
initcall nf_conntrack_l3proto_ipv4_init+0x0/0x12d returned 0 after 19 usecs
calling  nf_defrag_init+0x0/0x17 @ 1
initcall nf_defrag_init+0x0/0x17 returned 0 after 0 usecs
calling  ip_tables_init+0x0/0xaf @ 1
ip_tables: (C) 2000-2006 Netfilter Core Team
initcall ip_tables_init+0x0/0xaf returned 0 after 21189 usecs
calling  iptable_filter_init+0x0/0x6c @ 1
initcall iptable_filter_init+0x0/0x6c returned 0 after 35 usecs
calling  reject_tg_init+0x0/0x12 @ 1
initcall reject_tg_init+0x0/0x12 returned 0 after 7 usecs
calling  cubictcp_register+0x0/0x6e @ 1
TCP cubic registered
initcall cubictcp_register+0x0/0x6e returned 0 after 9736 usecs
calling  xfrm_user_init+0x0/0x4d @ 1
Initializing XFRM netlink socket
initcall xfrm_user_init+0x0/0x4d returned 0 after 7770 usecs
calling  packet_init+0x0/0x47 @ 1
NET: Registered protocol family 17
initcall packet_init+0x0/0x47 returned 0 after 16553 usecs
calling  dsa_init_module+0x0/0x14 @ 1
initcall dsa_init_module+0x0/0x14 returned 0 after 1 usecs
calling  edsa_init_module+0x0/0x14 @ 1
initcall edsa_init_module+0x0/0x14 returned 0 after 0 usecs
calling  trailer_init_module+0x0/0x14 @ 1
initcall trailer_init_module+0x0/0x14 returned 0 after 1 usecs
calling  mv88e6060_init+0x0/0x14 @ 1
initcall mv88e6060_init+0x0/0x14 returned 0 after 0 usecs
calling  mv88e6123_61_65_init+0x0/0x14 @ 1
initcall mv88e6123_61_65_init+0x0/0x14 returned 0 after 0 usecs
calling  mv88e6131_init+0x0/0x14 @ 1
initcall mv88e6131_init+0x0/0x14 returned 0 after 0 usecs
calling  dsa_init_module+0x0/0x12 @ 1
initcall dsa_init_module+0x0/0x12 returned 0 after 43 usecs
calling  dcbnl_init+0x0/0x32 @ 1
initcall dcbnl_init+0x0/0x32 returned 0 after 1 usecs
calling  mce_debugfs_init+0x0/0x3b @ 1
initcall mce_debugfs_init+0x0/0x3b returned 0 after 9 usecs
calling  severities_debugfs_init+0x0/0x3b @ 1
initcall severities_debugfs_init+0x0/0x3b returned 0 after 5 usecs
calling  hpet_insert_resource+0x0/0x23 @ 1
initcall hpet_insert_resource+0x0/0x23 returned 0 after 2 usecs
calling  update_mp_table+0x0/0x470 @ 1
initcall update_mp_table+0x0/0x470 returned 0 after 0 usecs
calling  lapic_insert_resource+0x0/0x40 @ 1
initcall lapic_insert_resource+0x0/0x40 returned 0 after 1 usecs
calling  init_lapic_nmi_sysfs+0x0/0x39 @ 1
initcall init_lapic_nmi_sysfs+0x0/0x39 returned 0 after 63 usecs
calling  io_apic_bug_finalize+0x0/0x1b @ 1
initcall io_apic_bug_finalize+0x0/0x1b returned 0 after 0 usecs
calling  check_early_ioremap_leak+0x0/0x65 @ 1
initcall check_early_ioremap_leak+0x0/0x65 returned 0 after 0 usecs
calling  pat_memtype_list_init+0x0/0x29 @ 1
initcall pat_memtype_list_init+0x0/0x29 returned 0 after 13 usecs
calling  sched_init_debug+0x0/0x24 @ 1
initcall sched_init_debug+0x0/0x24 returned 0 after 4 usecs
calling  init_oops_id+0x0/0x36 @ 1
initcall init_oops_id+0x0/0x36 returned 0 after 3 usecs
calling  disable_boot_consoles+0x0/0x45 @ 1
initcall disable_boot_consoles+0x0/0x45 returned 0 after 0 usecs
calling  pm_qos_power_init+0x0/0x61 @ 1
initcall pm_qos_power_init+0x0/0x61 returned 0 after 159 usecs
calling  software_resume+0x0/0x1f1 @ 1
PM: Resume from disk failed.
initcall software_resume+0x0/0x1f1 returned -2 after 14678 usecs
initcall software_resume+0x0/0x1f1 returned with error code -2=20
calling  debugfs_kprobe_init+0x0/0x8e @ 1
initcall debugfs_kprobe_init+0x0/0x8e returned 0 after 11 usecs
calling  taskstats_init+0x0/0x95 @ 1
registered taskstats version 1
initcall taskstats_init+0x0/0x95 returned 0 after 11210 usecs
calling  clear_boot_tracer+0x0/0x2d @ 1
initcall clear_boot_tracer+0x0/0x2d returned 0 after 0 usecs
calling  max_swapfiles_check+0x0/0x8 @ 1
initcall max_swapfiles_check+0x0/0x8 returned 0 after 0 usecs
calling  init_ima+0x0/0x1a @ 1
No TPM chip found, activating TPM-bypass!
initcall init_ima+0x0/0x1a returned 0 after 20750 usecs
calling  random32_reseed+0x0/0x92 @ 1
initcall random32_reseed+0x0/0x92 returned 0 after 15 usecs
calling  pci_resource_alignment_sysfs_init+0x0/0x19 @ 1
initcall pci_resource_alignment_sysfs_init+0x0/0x19 returned 0 after 4 usecs
calling  pci_sysfs_init+0x0/0x4c @ 1
initcall pci_sysfs_init+0x0/0x4c returned 0 after 743 usecs
calling  boot_wait_for_devices+0x0/0x19 @ 1
initcall boot_wait_for_devices+0x0/0x19 returned 0 after 0 usecs
calling  regulator_init_complete+0x0/0x136 @ 1
initcall regulator_init_complete+0x0/0x136 returned 0 after 1 usecs
calling  seqgen_init+0x0/0xf @ 1
initcall seqgen_init+0x0/0xf returned 0 after 9 usecs
calling  late_resume_init+0x0/0xf9 @ 1
  Magic number: 5:137:931
initcall late_resume_init+0x0/0xf9 returned 0 after 14010 usecs
calling  scsi_complete_async_scans+0x0/0xfe @ 1
initcall scsi_complete_async_scans+0x0/0xfe returned 0 after 0 usecs
calling  rtc_hctosys+0x0/0x167 @ 1
rtc_cmos rtc_cmos: setting system clock to 2009-12-02 10:57:22 UTC (1259751=
442)
initcall rtc_hctosys+0x0/0x167 returned 0 after 30428 usecs
calling  memmap_init+0x0/0xa3 @ 1
initcall memmap_init+0x0/0xa3 returned 0 after 101 usecs
calling  pci_mmcfg_late_insert_resources+0x0/0x171 @ 1
initcall pci_mmcfg_late_insert_resources+0x0/0x171 returned 0 after 8 usecs
calling  init_net_drop_monitor+0x0/0x147 @ 1
Initalizing network drop monitor service
initcall init_net_drop_monitor+0x0/0x147 returned 0 after 20567 usecs
calling  tcp_congestion_default+0x0/0x12 @ 1
initcall tcp_congestion_default+0x0/0x12 returned 0 after 1 usecs
calling  initialize_hashrnd+0x0/0x19 @ 1
initcall initialize_hashrnd+0x0/0x19 returned 0 after 3 usecs
async_waiting @ 1
async_continuing @ 1 after 0 usec
Freeing unused kernel memory: 940k freed
Write protecting the kernel read-only data: 6600k
calling  cciss_init+0x0/0xa3 [cciss] @ 88
HP CISS Driver (v 3.6.20)
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 54
  alloc irq_desc for 54 on node 1
  alloc kstat_irqs on node 1
cciss 0000:42:08.0: PCI INT A -> Link[LNKA] -> GSI 54 (level, high) -> IRQ =
54
  alloc irq_desc for 70 on node 1
  alloc kstat_irqs on node 1
cciss 0000:42:08.0: irq 70 for MSI/MSI-X
IRQ 70/cciss0: IRQF_DISABLED is not guaranteed on shared IRQs
cciss0: <0x3238> at PCI 0000:42:08.0 IRQ 70 using DAC
 cciss/c0d0: p1 p2 p3 p4
 cciss/c0d1: p1 p2
initcall cciss_init+0x0/0xa3 [cciss] returned 0 after 257303 usecs
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
calling  edac_init+0x0/0xcf [edac_core] @ 328
EDAC MC: Ver: 2.1.0 Dec  2 2009
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
calling  snd_mem_init+0x0/0x2c [snd_page_alloc] @ 278
initcall snd_mem_init+0x0/0x2c [snd_page_alloc] returned 0 after 15 usecs
calling  init_soundcore+0x0/0x8b [soundcore] @ 278
initcall init_soundcore+0x0/0x8b [soundcore] returned 0 after 44 usecs
calling  shpcd_init+0x0/0x68 [shpchp] @ 360
calling  ipmi_init_msghandler_mod+0x0/0xd [ipmi_msghandler] @ 504
ipmi message handler version 39.2
initcall ipmi_init_msghandler_mod+0x0/0xd [ipmi_msghandler] returned 0 afte=
r 63 usecs
calling  init_ipmi_si+0x0/0x78c [ipmi_si] @ 504
IPMI System Interface driver.
ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xca2, sl=
ave address 0x20, irq 0
calling  k8temp_init+0x0/0x20 [k8temp] @ 357
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_pci_sysfs.c, line at 537: edac_pci_dev_par=
ity_clear()
EDAC DEBUG: in drivers/edac/edac_mc_sysfs.c, line at 905: edac_sysfs_setup_=
mc_kset()
EDAC DEBUG: in drivers/edac/edac_mc_sysfs.c, line at 922: edac_sysfs_setup_=
mc_kset() Registered '.../edac/mc' kobject
initcall edac_init+0x0/0xcf [edac_core] returned 0 after 360400 usecs
calling  alsa_sound_init+0x0/0x8f [snd] @ 278
initcall alsa_sound_init+0x0/0x8f [snd] returned 0 after 75 usecs
calling  hpwdt_init+0x0/0x20 [hpwdt] @ 493
calling  amd64_edac_init+0x0/0x155c [amd64_edac_mod] @ 328
EDAC amd64_edac:  Ver: 3.2.0 Dec  2 2009
calling  alsa_timer_init+0x0/0x187 [snd_timer] @ 278
initcall alsa_timer_init+0x0/0x187 [snd_timer] returned 0 after 98 usecs
ipmi: Found new BMC (man_id: 0x00000b,  prod_id: 0x0000, dev_id: 0x11)
IPMI kcs interface initialized
ipmi_si: Trying ACPI-specified kcs state machine at i/o address 0xca2, slav=
e address 0x0, irq 0
ipmi_si: duplicate interface
calling  alsa_pcm_init+0x0/0x71 [snd_pcm] @ 651
initcall alsa_pcm_init+0x0/0x71 [snd_pcm] returned 0 after 16 usecs
calling  i2c_init+0x0/0x70 [i2c_core] @ 488
initcall i2c_init+0x0/0x70 [i2c_core] returned 0 after 117 usecs
calling  serio_raw_init+0x0/0x20 [serio_raw] @ 453
initcall serio_raw_init+0x0/0x20 [serio_raw] returned 0 after 60 usecs
calling  floppy_module_init+0x0/0xd73 [floppy] @ 723
Floppy drive(s): fd0 is 1.44M
k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #1=
41
hpwdt 0000:01:04.0: NMI sourcing is disabled. To enable this functionality =
you must reboot with nmi_watchdog=3D0 and load the hpwdt driver with priori=
ty=3D1.
hpwdt 0000:01:04.0: PCI INT A -> Link[LNKW] -> GSI 16 (level, high) -> IRQ =
16
EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 3085: (MC node=3D0,mc_typ=
e=3D'RevF')
calling  alsa_mixer_oss_init+0x0/0x3a [snd_mixer_oss] @ 694
initcall alsa_mixer_oss_init+0x0/0x3a [snd_mixer_oss] returned 0 after 1 us=
ecs
calling  alsa_pcm_oss_init+0x0/0xa5 [snd_pcm_oss] @ 694
initcall alsa_pcm_oss_init+0x0/0xa5 [snd_pcm_oss] returned 0 after 2 usecs
hpwdt: New timer passed in is 30 seconds.
hp Watchdog Timer Driver: 1.1.1, timer margin: 30 seconds (nowayout=3D0), a=
llow kernel dump: OFF (default =3D 0/OFF), priority: LAST (default =3D 0/LA=
ST).
EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 2365:     Addr Map device=
 PCI Bus ID:	0000:00:18.1
initcall hpwdt_init+0x0/0x20 [hpwdt] returned 0 after 2437870 usecs
EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 2367:     DRAM MEM-CTL PC=
I Bus ID:	0000:00:18.2
EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 2369:     Misc device PCI=
 Bus ID:	0000:00:18.3
EDAC amd64: ECC is enabled by BIOS.
ipmi_si 0000:01:04.6: PCI INT A -> Link[LNKW] -> GSI 16 (level, high) -> IR=
Q 16
ipmi_si: Trying PCI-specified kcs state machine at mem address 0xf7ef0000, =
slave address 0x0, irq 16
EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 2814: core: 0, MCG_CTL: 0=
x1f, NB MSR is enabled
EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 2814: core: 2, MCG_CTL: 0=
x0, NB MSR is disabled
EDAC amd64: NB MCE bank disabled, set MSR 0x0000017b[4] on node 0 to enable.
EDAC amd64: WARNING: ECC is disabled by BIOS. Module will NOT be loaded.
 Either Enable ECC in the BIOS, or set 'ecc_enable_override'.
 Also, use of the override can cause unknown side effects.
EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 3094: ret=3D-22
amd64_edac: probe of 0000:00:18.2 failed with error -22
k8temp 0000:00:19.3: Temperature readouts might be wrong - check erratum #1=
41
IRQ 16/ipmi_si: IRQF_DISABLED is not guaranteed on shared IRQs
  Using irq 16
calling  init_ipmi_devintf+0x0/0x106 [ipmi_devintf] @ 1115
ipmi device interface
initcall k8temp_init+0x0/0x20 [k8temp] returned 0 after 3119253 usecs
EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 3085: (MC node=3D1,mc_typ=
e=3D'RevF')
EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 2365:     Addr Map device=
 PCI Bus ID:	0000:00:19.1
EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 2367:     DRAM MEM-CTL PC=
I Bus ID:	0000:00:19.2
EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 2369:     Misc device PCI=
 Bus ID:	0000:00:19.3
EDAC amd64: ECC is enabled by BIOS.
EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 2814: core: 1, MCG_CTL: 0=
x1f, NB MSR is enabled
EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 2814: core: 3, MCG_CTL: 0=
x0, NB MSR is disabled
EDAC amd64: NB MCE bank disabled, set MSR 0x0000017b[4] on node 1 to enable.
EDAC amd64: WARNING: ECC is disabled by BIOS. Module will NOT be loaded.
 Either Enable ECC in the BIOS, or set 'ecc_enable_override'.
 Also, use of the override can cause unknown side effects.
EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 3094: ret=3D-22
amd64_edac: probe of 0000:00:19.2 failed with error -22
initcall amd64_edac_init+0x0/0x155c [amd64_edac_mod] returned 0 after 30520=
50 usecs
floppy0: no floppy controllers found
initcall floppy_module_init+0x0/0xd73 [floppy] returned -19 after 2940311 u=
secs
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
initcall shpcd_init+0x0/0x68 [shpchp] returned 0 after 1593727 usecs
calling  drm_core_init+0x0/0x129 [drm] @ 488
[drm] Initialized drm 1.1.0 20060810
initcall drm_core_init+0x0/0x129 [drm] returned 0 after 77 usecs
calling  alsa_seq_device_init+0x0/0x60 [snd_seq_device] @ 1433
initcall alsa_seq_device_init+0x0/0x60 [snd_seq_device] returned 0 after 9 =
usecs
calling  ttm_init+0x0/0x6f [ttm] @ 488
initcall ttm_init+0x0/0x6f [ttm] returned 0 after 48 usecs
ipmi: interfacing existing BMC (man_id: 0x00000b, prod_id: 0x0000, dev_id: =
0x11)
IPMI kcs interface initialized
initcall init_ipmi_si+0x0/0x78c [ipmi_si] returned 0 after 3899575 usecs
initcall init_ipmi_devintf+0x0/0x106 [ipmi_devintf] returned 0 after 881875=
 usecs
calling  alsa_seq_init+0x0/0x57 [snd_seq] @ 1497
initcall alsa_seq_init+0x0/0x57 [snd_seq] returned 0 after 114 usecs
calling  alsa_seq_midi_event_init+0x0/0x8 [snd_seq_midi_event] @ 1497
initcall alsa_seq_midi_event_init+0x0/0x8 [snd_seq_midi_event] returned 0 a=
fter 0 usecs
calling  alsa_seq_oss_init+0x0/0x19e [snd_seq_oss] @ 1497
calling  scsi_tgt_init+0x0/0x82 [scsi_tgt] @ 1449
initcall scsi_tgt_init+0x0/0x82 [scsi_tgt] returned 0 after 1439 usecs
calling  radeon_init+0x0/0xc5 [radeon] @ 488
[drm] radeon defaulting to kernel modesetting.
[drm] radeon kernel modesetting enabled.
calling  alsa_seq_dummy_init+0x0/0xcd [snd_seq_dummy] @ 1515
initcall alsa_seq_dummy_init+0x0/0xcd [snd_seq_dummy] returned 0 after 16 u=
secs
ACPI: PCI Interrupt Link [LNKY] enabled at IRQ 18
  alloc irq_desc for 18 on node 0
  alloc kstat_irqs on node 0
radeon 0000:01:03.0: PCI INT A -> Link[LNKY] -> GSI 18 (level, high) -> IRQ=
 18
[drm] radeon: Initializing kernel modesetting.
initcall alsa_seq_oss_init+0x0/0x19e [snd_seq_oss] returned 0 after 286043 =
usecs
calling  pcsp_init+0x0/0x20 [snd_pcsp] @ 278
input: PC Speaker as /class/input/input4
initcall pcsp_init+0x0/0x20 [snd_pcsp] returned 0 after 862 usecs
calling  fc_transport_init+0x0/0x4c [scsi_transport_fc] @ 1449
initcall fc_transport_init+0x0/0x4c [scsi_transport_fc] returned 0 after 13=
3 usecs
calling  pcspkr_init+0x0/0x12 [pcspkr] @ 278
Error: Driver 'pcspkr' is already registered, aborting...
initcall pcspkr_init+0x0/0x12 [pcspkr] returned -16 after 4 usecs
initcall pcspkr_init+0x0/0x12 [pcspkr] returned with error code -16=20
calling  lpfc_init+0x0/0xd3 [lpfc] @ 1449
Emulex LightPulse Fibre Channel SCSI driver 8.3.4
Copyright(c) 2004-2009 Emulex.  All rights reserved.
[drm] register mmio base: 0xF7FF0000
initcall shpcd_init+0x0/0x68 [shpchp] returned with error code -16=20
[drm] register mmio size: 65536
lpfc 0000:08:00.0: PCI INT A -> Link[LNKY] -> GSI 18 (level, high) -> IRQ 18
lpfc 0000:08:00.0: setting latency timer to 64
[drm] GPU reset succeed (RBBM_STATUS=3D0x00000140)
calling  shpcd_init+0x0/0x68 [shpchp] @ 755
Error: Driver 'shpchp' is already registered, aborting...
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
initcall shpcd_init+0x0/0x68 [shpchp] returned -16 after 6 usecs
initcall shpcd_init+0x0/0x68 [shpchp] returned with error code -16=20
[drm] radeon: VRAM 64M
[drm] radeon: VRAM from 0x00000000 to 0x03FFFFFF
[drm] radeon: GTT 512M
[drm] radeon: GTT from 0x20000000 to 0x3FFFFFFF
scsi0 :  on PCI bus 08 device 00 irq 18
[drm] radeon: irq initialized.
[drm] Detected VRAM RAM=3D64M, BAR=3D128M
[drm] RAM width 16bits DDR
calling  shpcd_init+0x0/0x68 [shpchp] @ 1629
general protection fault: 0000 [#1] SMP=20
last sysfs file: /sys/class/sound/dsp/dev
CPU 2=20
Modules linked in: shpchp(+) lpfc(+)calling  tg3_init+0x0/0x20 [tg3] @ 1610
[TTM] Zone  kernel: Available graphics memory: 4097698 kiB.
[TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[drm] radeon: 32M of VRAM memory ready
[drm] radeon: 512M of GTT memory ready.
[drm] GART: num cpu pages 131072, num gpu pages 131072
tg3.c:v3.102 (September 1, 2009)
ACPI: PCI Interrupt Link [LNKZ] enabled at IRQ 19
  alloc irq_desc for 19 on node 0
  alloc kstat_irqs on node 0
tg3 0000:07:04.0: PCI INT A -> Link[LNKZ] -> GSI 19 (level, high) -> IRQ 19
[drm] radeon: cp idle (0x00008080)
 scsi_transport_fc snd_pcsp snd_seq_dummy radeon(+) scsi_tgt snd_seq_oss sn=
d_seq_midi_event snd_seq ttm drm_kms_helper snd_seq_device drm ipmi_devintf=
 snd_pcm_oss snd_mixer_oss i2c_algo_bit serio_raw i2c_core snd_pcm snd_time=
r amd64_edac_mod hpwdt snd ipmi_si ipmi_msghandler soundcore snd_page_alloc=
 edac_core cciss
Pid: 1629, comm: modprobe Not tainted 2.6.32-rc8-git4 #1 ProLiant BL685c G1
RIP: 0010:[<ffffffff811f18e8>]  [<ffffffff811f18e8>] kobject_put+0x11/0x4c
RSP: 0018:ffff88017a27be68  EFLAGS: 00010202
RAX: ffffffffa004ccc0 RBX: 6b6b6b6b6b6b6b6b RCX: 0000000000000016
RDX: ffffffffa004ccc0 RSI: 0000003000000018 RDI: 6b6b6b6b6b6b6b6b
RBP: ffff88017a27be78 R08: ffff88017a27bf38 R09: ffff88017fc20000
R10: ffff88017a27bcc8 R11: 0000000000000000 R12: ffffffffa00f7cc0
R13: ffffffffa00f7cc0 R14: 00007fd8a32fe010 R15: 00007fd8a32fe010
FS:  00007fd8a34e26f0(0000) GS:ffff880005700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f7af107c110 CR3: 000000017a13e000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 1629, threadinfo ffff88017a27a000, task ffff88017a1f=
2ec0)
Stack:
 00007fd8a32fe010 ffffffffa00f7c60 ffff88017a27be88 ffffffff812a5a95
<0> ffff88017a27bec8 ffffffff812a5b18 0000000000000286 ffffffffa00f7c60
<0> ffffffffa003b000 ffffffffa00f7cc0 00007fd8a32fe010 00007fd8a32fe010
Call Trace:
 [<ffffffff812a5a95>] put_driver+0x12/0x14
 [<ffffffff812a5b18>] driver_register+0x81/0x11a
 [<ffffffffa003b000>] ? shpcd_init+0x0/0x68 [shpchp]
 [<ffffffff812078d5>] __pci_register_driver+0x55/0xb2
 [<ffffffffa003b000>] ? shpcd_init+0x0/0x68 [shpchp]
 [<ffffffffa003b023>] shpcd_init+0x23/0x68 [shpchp]
 [<ffffffff8100a06a>] do_one_initcall+0x5f/0x15a
 [<ffffffff8108f801>] sys_init_module+0xd0/0x22b
 [<ffffffff81011d72>] system_call_fastpath+0x16/0x1b
Code: 12 48 c7 c6 50 35 6f 81 48 89 c7 48 89 c3 e8 65 ff ff ff 5f 48 89 d8 =
5b c9 c3 55 48 89 e5 53 48 89 fb 48 83 ec 08 48 85 ff 74 36 <f6> 47 3c 01 7=
5 20 48 8b 0f 49 89 f8 48 c7 c2 8c ca 5f 81 be 53=20
RIP  [<ffffffff811f18e8>] kobject_put+0x11/0x4c
 RSP <ffff88017a27be68>
---[ end trace 31abc5284a8461b5 ]---
[drm] Loading R100 Microcode
platform radeon_cp.0: firmware: requesting radeon/R100_cp.bin
eth2: Tigon3 [partno(011276-001) rev 9003] (PCIX:133MHz:64-bit) MAC address=
 00:18:fe:34:1c:2f
eth2: attached PHY is 5714 (1000Base-SX Ethernet) (WireSpeed[0])
eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
eth2: dma_rwctrl[76148000] dma_mask[40-bit]
tg3 0000:07:04.1: PCI INT B -> Link[LNKW] -> GSI 16 (level, high) -> IRQ 16
eth3: Tigon3 [partno(011276-001) rev 9003] (PCIX:133MHz:64-bit) MAC address=
 00:18:fe:34:1c:30
eth3: attached PHY is 5714 (1000Base-SX Ethernet) (WireSpeed[0])
eth3: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
eth3: dma_rwctrl[76148000] dma_mask[40-bit]
initcall tg3_init+0x0/0x20 [tg3] returned 0 after 1547119 usecs
[drm] radeon: ring at 0x0000000020000000
[drm] ring test succeeded in 1 usecs
[drm] radeon: ib pool ready.
[drm] ib test succeeded in 0 usecs
[drm] Radeon Display Connectors
[drm] Connector 0:
[drm]   VGA
[drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[drm]   Encoders:
[drm]     CRT1: INTERNAL_DAC1
[drm] Connector 1:
[drm]   VGA
[drm]   DDC: 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c
[drm]   Encoders:
[drm]     CRT2: INTERNAL_DAC2
lpfc 0000:08:00.1: PCI INT B -> Link[LNKZ] -> GSI 19 (level, high) -> IRQ 19
lpfc 0000:08:00.1: setting latency timer to 64
[drm] fb mappable at 0xE8040000
[drm] vram apper at 0xE8000000
[drm] size 1920000
[drm] fb depth is 24
[drm]    pitch is 3200
scsi1 :  on PCI bus 08 device 01 irq 19
lpfc 0000:08:00.0: 0:1303 Link Up Event x1 received Data: x1 xf7 x10 x2 x0 =
x0 0
[drm] DAC-8: set mode 800x600 19
Console: switching to colour frame buffer device 100x37
fb0: radeondrmfb frame buffer device
registered panic notifier
[drm] Initialized radeon 2.0.0 20080528 for 0000:01:03.0 on minor 0
initcall radeon_init+0x0/0xc5 [radeon] returned 0 after 3730385 usecs
scsi 0:0:0:0: RAID              COMPAQ   MSA1000          5.20 PQ: 0 ANSI: 4
scsi 0:0:0:0: Attached scsi generic sg0 type 12
scsi 0:0:0:8: Direct-Access     COMPAQ   MSA1000 VOLUME   5.20 PQ: 0 ANSI: 4
sd 0:0:0:8: Attached scsi generic sg1 type 0
scsi 0:0:1:0: Enclosure         HP       MSA2212fc        J200 PQ: 0 ANSI: 5
sd 0:0:0:8: [sda] 2187605616 512-byte logical blocks: (1.12 TB/1.01 TiB)
sd 0:0:0:8: [sda] Write Protect is off
sd 0:0:0:8: [sda] Mode Sense: 83 00 00 08
sd 0:0:0:8: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
 sda: sda1
scsi 0:0:1:0: Attached scsi generic sg2 type 13
sd 0:0:0:8: [sda] Attached SCSI disk
scsi 0:0:2:0: RAID              COMPAQ   MSA1000          5.20 PQ: 0 ANSI: 4
scsi 0:0:2:0: Attached scsi generic sg3 type 12
initcall lpfc_init+0x0/0xd3 [lpfc] returned 0 after 4881202 usecs
lpfc 0000:08:00.1: 1:1303 Link Up Event x1 received Data: x1 xf7 x10 x2 x0 =
x0 0
calling  enclosure_init+0x0/0x19 [enclosure] @ 1955
initcall enclosure_init+0x0/0x19 [enclosure] returned 0 after 2899 usecs
calling  ses_init+0x0/0x40 [ses] @ 1955
ses 0:0:1:0: Attached Enclosure device
initcall ses_init+0x0/0x40 [ses] returned 0 after 10118 usecs
scsi 1:0:0:0: RAID              COMPAQ   MSA1000          5.20 PQ: 0 ANSI: 4
scsi 1:0:0:0: Attached scsi generic sg4 type 12
scsi 1:0:1:0: RAID              COMPAQ   MSA1000          5.20 PQ: 0 ANSI: 4
scsi 1:0:1:0: Attached scsi generic sg5 type 12
scsi 1:0:1:8: Direct-Access     COMPAQ   MSA1000 VOLUME   5.20 PQ: 0 ANSI: 4
sd 1:0:1:8: Attached scsi generic sg6 type 0
sd 1:0:1:8: [sdb] 2187605616 512-byte logical blocks: (1.12 TB/1.01 TiB)
sd 1:0:1:8: [sdb] Write Protect is off
sd 1:0:1:8: [sdb] Mode Sense: 83 00 00 08
sd 1:0:1:8: [sdb] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
 sdb: sdb1
scsi 1:0:2:0: Enclosure         HP       MSA2212fc        J200 PQ: 0 ANSI: 5
sd 1:0:1:8: [sdb] Attached SCSI disk
ses 1:0:2:0: Attached Enclosure device
ses 1:0:2:0: Attached scsi generic sg7 type 13
 rport-0:0-19: blocked FC remote port time out: removing rport
 rport-1:0-20: blocked FC remote port time out: removing rport
calling  floppy_module_init+0x0/0xd73 [floppy] @ 2405
Floppy drive(s): fd0 is 1.44M
floppy0: no floppy controllers found
initcall floppy_module_init+0x0/0xd73 [floppy] returned -19 after 2988902 u=
secs
calling  parport_default_proc_register+0x0/0x1b [parport] @ 2434
initcall parport_default_proc_register+0x0/0x1b [parport] returned 0 after =
196 usecs
calling  lp_init_module+0x0/0x274 [lp] @ 2436
calling  parport_pc_init+0x0/0x357 [parport_pc] @ 2439
initcall parport_pc_init+0x0/0x357 [parport_pc] returned 0 after 758 usecs
lp: driver loaded but no devices found
initcall lp_init_module+0x0/0x274 [lp] returned 0 after 91445 usecs
calling  acpi_memory_device_init+0x0/0x7a [acpi_memhotplug] @ 2470
initcall acpi_memory_device_init+0x0/0x7a [acpi_memhotplug] returned 0 afte=
r 5613 usecs
calling  acpi_smb_hc_init+0x0/0x18 [sbshc] @ 2478
initcall acpi_smb_hc_init+0x0/0x18 [sbshc] returned 0 after 74 usecs
calling  acpi_sbs_init+0x0/0x4f [sbs] @ 2485
initcall acpi_sbs_init+0x0/0x4f [sbs] returned 0 after 68 usecs
calling  video_output_class_init+0x0/0x19 [output] @ 2489
initcall video_output_class_init+0x0/0x19 [output] returned 0 after 45 usecs
calling  acpi_video_init+0x0/0x70 [video] @ 2489
initcall acpi_video_init+0x0/0x70 [video] returned 0 after 171 usecs
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
EXT3 FS on cciss/c0d0p3, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on cciss/c0d0p1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Can't find ext3 filesystem on dev cciss/c0d0p4.
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on cciss/c0d1p1, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on cciss/c0d1p2, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
Adding 8385920k swap on /dev/cciss/c0d0p2.  Priority:-1 extents:1 across:83=
85920k=20
warning: process `kudzu' used the deprecated sysctl system call with 1.23.
calling  inet6_init+0x0/0x2b2 [ipv6] @ 2706
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
initcall inet6_init+0x0/0x2b2 [ipv6] returned 0 after 55473 usecs
process `sysctl' is using deprecated sysctl (syscall) net.ipv6.neigh.defaul=
t.retrans_time; Use net.ipv6.neigh.default.retrans_time_ms instead.
calling  init_sunrpc+0x0/0x5d [sunrpc] @ 3118
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
initcall init_sunrpc+0x0/0x5d [sunrpc] returned 0 after 77868 usecs
warning: `dbus-daemon' uses 32-bit capabilities (legacy support in use)
calling  rfkill_init+0x0/0x79 [rfkill] @ 3178
initcall rfkill_init+0x0/0x79 [rfkill] returned 0 after 298 usecs
calling  bt_init+0x0/0x5d [bluetooth] @ 3178
Bluetooth: Core ver 2.15
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
initcall bt_init+0x0/0x5d [bluetooth] returned 0 after 93454 usecs
calling  l2cap_init+0x0/0xe5 [l2cap] @ 3203
Bluetooth: L2CAP ver 2.14
Bluetooth: L2CAP socket layer initialized
initcall l2cap_init+0x0/0xe5 [l2cap] returned 0 after 47677 usecs
calling  rfcomm_init+0x0/0xd4 [rfcomm] @ 3203
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
initcall rfcomm_init+0x0/0xd4 [rfcomm] returned 0 after 81877 usecs
calling  init_rpcsec_gss+0x0/0x4d [auth_rpcgss] @ 3228
initcall init_rpcsec_gss+0x0/0x4d [auth_rpcgss] returned 0 after 39 usecs
calling  fscache_init+0x0/0xb9 [fscache] @ 3228
Slow work thread pool: Starting up
Slow work thread pool: Ready
FS-Cache: Loaded
initcall fscache_init+0x0/0xb9 [fscache] returned 0 after 54980 usecs
calling  init_nlm+0x0/0x22 [lockd] @ 3228
initcall init_nlm+0x0/0x22 [lockd] returned 0 after 11 usecs
calling  init_nfs_fs+0x0/0x139 [nfs] @ 3228
FS-Cache: Netfs 'nfs' registered for caching
initcall init_nfs_fs+0x0/0x139 [nfs] returned 0 after 85729 usecs
svc: failed to register lockdv1 RPC service (errno 97).
VFS: Can't find ext3 filesystem on dev cciss/c0d0p4.
SysRq : HELP : loglevel(0-9) reBoot Crash terminate-all-tasks(E) memory-ful=
l-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-=
active-cpus(L) show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-regi=
sters(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount force-fb=
(V) show-blocked-tasks(W) dump-ftrace-buffer(Z)=20
calling  hidp_init+0x0/0x60 [hidp] @ 3307
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
initcall hidp_init+0x0/0x60 [hidp] returned 0 after 34203 usecs
calling  init_autofs4_fs+0x0/0x26 [autofs4] @ 3321
initcall init_autofs4_fs+0x0/0x26 [autofs4] returned 0 after 102 usecs
eth0: no IPv6 routers present

--Multipart=_Wed__2_Dec_2009_10_11_08_-0800_Uta+bOFaVS9jY_Ru--
