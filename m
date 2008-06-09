Return-Path: <linux-kernel-owner+w=401wt.eu-S1757829AbYFIOmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829AbYFIOmb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 10:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbYFIOmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 10:42:20 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1192 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbYFIOmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 10:42:19 -0400
Date: Mon, 9 Jun 2008 15:41:27 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: make generic arch support NUMAQ v5
Message-ID: <20080609144127.GD6701@shadowen.org>
References: <200806050309.11197.yhlu.kernel@gmail.com> <200806061441.59984.yhlu.kernel@gmail.com> <200806070031.35322.yhlu.kernel@gmail.com> <200806081831.54869.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806081831.54869.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2008 at 06:31:54PM -0700, Yinghai Lu wrote:
> 
> so it could fallback to normal numa.
> NUMAQ depends on GENERICARCH
> also decouple genericarch numa with acpi.
> also make it fallback to bigsmp if apicid > 8.
> 
> v3: return early if not found_numaq in pci_numa_init
>     remove xquad_portio in misc.c
> v4: make summit, bigsmp and es7000 depend on GENERICARCH too
> v5: seperate apicid check for bigsmp to another patch
> 	[PATCH] x86: introduce max_physical_apicid for bigsmp switching

Do you have a NUMA-Q to test this on?  Also, what is the baseline here
as I would like to test it?

> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> Index: linux-2.6/arch/x86/Kconfig
> ===================================================================
> --- linux-2.6.orig/arch/x86/Kconfig
> +++ linux-2.6/arch/x86/Kconfig
> @@ -264,36 +264,6 @@ config X86_VOYAGER
>  	  If you do not specifically know you have a Voyager based machine,
>  	  say N here, otherwise the kernel you build will not be bootable.
>  
> -config X86_NUMAQ
> -	bool "NUMAQ (IBM/Sequent)"
> -	depends on SMP && X86_32 && PCI
> -	select NUMA
> -	help
> -	  This option is used for getting Linux to run on a (IBM/Sequent) NUMA
> -	  multiquad box. This changes the way that processors are bootstrapped,
> -	  and uses Clustered Logical APIC addressing mode instead of Flat Logical.
> -	  You will need a new lynxer.elf file to flash your firmware with - send
> -	  email to <Martin.Bligh@us.ibm.com>.
> -
> -config X86_SUMMIT
> -	bool "Summit/EXA (IBM x440)"
> -	depends on X86_32 && SMP
> -	help
> -	  This option is needed for IBM systems that use the Summit/EXA chipset.
> -	  In particular, it is needed for the x440.
> -
> -	  If you don't have one of these computers, you should say N here.
> -	  If you want to build a NUMA kernel, you must select ACPI.
> -
> -config X86_BIGSMP
> -	bool "Support for other sub-arch SMP systems with more than 8 CPUs"
> -	depends on X86_32 && SMP
> -	help
> -	  This option is needed for the systems that have more than 8 CPUs
> -	  and if the system is not of any sub-arch type above.
> -
> -	  If you don't have such a system, you should say N here.
> -
>  config X86_VISWS
>  	bool "SGI 320/540 (Visual Workstation)"
>  	depends on X86_32 && !PCI
> @@ -307,12 +277,33 @@ config X86_VISWS
>  	  and vice versa. See <file:Documentation/sgi-visws.txt> for details.
>  
>  config X86_GENERICARCH
> -       bool "Generic architecture (Summit, bigsmp, ES7000, default)"
> +       bool "Generic architecture"
>  	depends on X86_32
>         help
> -          This option compiles in the Summit, bigsmp, ES7000, default subarchitectures.
> -	  It is intended for a generic binary kernel.
> -	  If you want a NUMA kernel, select ACPI.   We need SRAT for NUMA.
> +          This option compiles in the NUMAQ, Summit, bigsmp, ES7000, default
> +	  subarchitectures.  It is intended for a generic binary kernel.
> +	  if you select them all, kernel will probe it one by one. and will
> +	  fallback to default.
> +
> +if X86_GENERICARCH
> +
> +config X86_NUMAQ
> +	bool "NUMAQ (IBM/Sequent)"
> +	depends on SMP && X86_32 && PCI

Can we not just add && X86_GENERICARCH here instead of putting them in
that if ?

> +	select NUMA
> +	help
> +	  This option is used for getting Linux to run on a NUMAQ (IBM/Sequent)
> +	  NUMA multiquad box. This changes the way that processors are
> +	  bootstrapped, and uses Clustered Logical APIC addressing mode instead
> +	  of Flat Logical.  You will need a new lynxer.elf file to flash your
> +	  firmware with - send email to <Martin.Bligh@us.ibm.com>.
> +
> +config X86_SUMMIT
> +	bool "Summit/EXA (IBM x440)"
> +	depends on X86_32 && SMP
> +	help
> +	  This option is needed for IBM systems that use the Summit/EXA chipset.
> +	  In particular, it is needed for the x440.
>  
>  config X86_ES7000
>  	bool "Support for Unisys ES7000 IA32 series"
> @@ -320,8 +311,15 @@ config X86_ES7000
>  	help
>  	  Support for Unisys ES7000 systems.  Say 'Y' here if this kernel is
>  	  supposed to run on an IA32-based Unisys ES7000 system.
> -	  Only choose this option if you have such a system, otherwise you
> -	  should say N here.
> +
> +config X86_BIGSMP
> +	bool "Support for big SMP systems with more than 8 CPUs"
> +	depends on X86_32 && SMP
> +	help
> +	  This option is needed for the systems that have more than 8 CPUs
> +	  and if the system is not of any sub-arch type above.
> +
> +endif
>  
>  config X86_RDC321X
>  	bool "RDC R-321x SoC"
> @@ -908,9 +906,9 @@ config X86_PAE
>  config NUMA
>  	bool "Numa Memory Allocation and Scheduler Support (EXPERIMENTAL)"
>  	depends on SMP
> -	depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || (X86_SUMMIT || X86_GENERICARCH) && ACPI) && EXPERIMENTAL)
> +	depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || X86_GENERICARCH || X86_SUMMIT && ACPI) && EXPERIMENTAL)
>  	default n if X86_PC
> -	default y if (X86_NUMAQ || X86_SUMMIT)
> +	default y if (X86_NUMAQ || X86_SUMMIT || X86_GENERICARCH)

If I am reading this right we are making all genericarch kernels NUMA,
which before they were not.  Hmmm is that going to cause problems
elsewhere?  Mind you can you get non-numa boxes any more?

If its only NUMAQ which makes that requireemnt it seems wrong to add
GENERICARCH here.  ie. its NUMAQ or SUMMIT that brings the requirement.

>  	help
>  	  Enable NUMA (Non Uniform Memory Access) support.
>  	  The kernel will try to allocate memory used by a CPU on the
> Index: linux-2.6/arch/x86/kernel/io_apic_32.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/io_apic_32.c
> +++ linux-2.6/arch/x86/kernel/io_apic_32.c
> @@ -1715,7 +1715,6 @@ void disable_IO_APIC(void)
>   * by Matt Domsch <Matt_Domsch@dell.com>  Tue Dec 21 12:25:05 CST 1999
>   */
>  
> -#ifndef CONFIG_X86_NUMAQ
>  static void __init setup_ioapic_ids_from_mpc(void)
>  {
>  	union IO_APIC_reg_00 reg_00;
> @@ -1725,6 +1724,11 @@ static void __init setup_ioapic_ids_from
>  	unsigned char old_id;
>  	unsigned long flags;
>  
> +#ifdef CONFIG_X86_NUMAQ
> +	if (found_numaq)
> +		return;
> +#endif
> +

Could this not be always compiled in?  As long as found_numaq is never 1
we should be ok.

>  	/*
>  	 * Don't check I/O APIC IDs for xAPIC systems.  They have
>  	 * no meaning without the serial APIC bus.
> @@ -1821,9 +1825,6 @@ static void __init setup_ioapic_ids_from
>  			apic_printk(APIC_VERBOSE, " ok.\n");
>  	}
>  }
> -#else
> -static void __init setup_ioapic_ids_from_mpc(void) { }
> -#endif
>  
>  int no_timer_check __initdata;
>  
> Index: linux-2.6/arch/x86/kernel/mpparse.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/mpparse.c
> +++ linux-2.6/arch/x86/kernel/mpparse.c
> @@ -49,15 +49,73 @@ static int __init mpf_checksum(unsigned 
>  }
>  
>  #ifdef CONFIG_X86_NUMAQ
> +int found_numaq;
>  /*
>   * Have to match translation table entries to main table entries by counter
>   * hence the mpc_record variable .... can't see a less disgusting way of
>   * doing this ....
>   */
> +struct mpc_config_translation {
> +	unsigned char mpc_type;
> +	unsigned char trans_len;
> +	unsigned char trans_type;
> +	unsigned char trans_quad;
> +	unsigned char trans_global;
> +	unsigned char trans_local;
> +	unsigned short trans_reserved;
> +};
> +
>  
>  static int mpc_record;
>  static struct mpc_config_translation *translation_table[MAX_MPC_ENTRY]
>      __cpuinitdata;
> +
> +static inline int generate_logical_apicid(int quad, int phys_apicid)
> +{
> +	return (quad << 4) + (phys_apicid ? phys_apicid << 1 : 1);
> +}
> +
> +
> +static inline int mpc_apic_id(struct mpc_config_processor *m,
> +			struct mpc_config_translation *translation_record)
> +{
> +	int quad = translation_record->trans_quad;
> +	int logical_apicid = generate_logical_apicid(quad, m->mpc_apicid);
> +
> +	printk(KERN_DEBUG "Processor #%d %u:%u APIC version %d (quad %d, apic %d)\n",
> +	       m->mpc_apicid,
> +	       (m->mpc_cpufeature & CPU_FAMILY_MASK) >> 8,
> +	       (m->mpc_cpufeature & CPU_MODEL_MASK) >> 4,
> +	       m->mpc_apicver, quad, logical_apicid);
> +	return logical_apicid;
> +}
> +
> +int mp_bus_id_to_node[MAX_MP_BUSSES];
> +
> +int mp_bus_id_to_local[MAX_MP_BUSSES];
> +
> +static void mpc_oem_bus_info(struct mpc_config_bus *m, char *name,
> +	struct mpc_config_translation *translation)
> +{
> +	int quad = translation->trans_quad;
> +	int local = translation->trans_local;
> +
> +	mp_bus_id_to_node[m->mpc_busid] = quad;
> +	mp_bus_id_to_local[m->mpc_busid] = local;
> +	printk(KERN_INFO "Bus #%d is %s (node %d)\n",
> +	       m->mpc_busid, name, quad);
> +}
> +
> +int quad_local_to_mp_bus_id [NR_CPUS/4][4];
> +static void mpc_oem_pci_bus(struct mpc_config_bus *m,
> +	struct mpc_config_translation *translation)
> +{
> +	int quad = translation->trans_quad;
> +	int local = translation->trans_local;
> +
> +	quad_local_to_mp_bus_id[quad][local] = m->mpc_busid;
> +}
> +
>  #endif
>  
>  static void __cpuinit MP_processor_info(struct mpc_config_processor *m)
> @@ -321,11 +382,11 @@ static void __init smp_read_mpc_oem(stru
>  	}
>  }
>  
> -static inline void mps_oem_check(struct mp_config_table *mpc, char *oem,
> +void numaq_mps_oem_check(struct mp_config_table *mpc, char *oem,
>  				 char *productid)
>  {
>  	if (strncmp(oem, "IBM NUMA", 8))
> -		printk("Warning!  May not be a NUMA-Q system!\n");
> +		printk("Warning!  Not a NUMA-Q system!\n");
>  	else
>  		found_numaq = 1;
>  
> @@ -388,7 +449,16 @@ static int __init smp_read_mpc(struct mp
>  		return 0;
>  
>  #ifdef CONFIG_X86_32
> -	mps_oem_check(mpc, oem, str);
> +	/*
> +	 * need to make sure summit and es7000's mps_oem_check is safe to be
> +	 * called early via genericarch 's mps_oem_check
> +	 */
> +	if (early) {
> +#ifdef CONFIG_X86_NUMAQ
> +		numaq_mps_oem_check(mpc, oem, str);
> +#endif

Is there any reason we cannot use:

		if (found_numaq)
			numaq_mps_oem_check(mpc, oem, str);

Also why is this dependant on 'early'.  There doesn't seem to be such
a check in the original path?


> +	} else
> +		mps_oem_check(mpc, oem, str);
>  #endif
>  
>  	/* save the local APIC address, it might be non-default */
> Index: linux-2.6/arch/x86/kernel/numaq_32.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/numaq_32.c
> +++ linux-2.6/arch/x86/kernel/numaq_32.c
> @@ -36,8 +36,6 @@
>  
>  #define	MB_TO_PAGES(addr) ((addr) << (20 - PAGE_SHIFT))
>  
> -int found_numaq;
> -
>  /*
>   * Function: smp_dump_qct()
>   *
> @@ -105,13 +103,3 @@ static int __init numaq_tsc_disable(void
>  }
>  arch_initcall(numaq_tsc_disable);
>  
> -#ifdef CONFIG_ACPI
> -/*
> - * Dummy implementation:
> - */
> -struct pci_bus * __devinit
> -pci_acpi_scan_root(struct acpi_device *device, int domain, int busnum)
> -{
> -	return NULL;
> -}
> -#endif
> Index: linux-2.6/arch/x86/mach-generic/Makefile
> ===================================================================
> --- linux-2.6.orig/arch/x86/mach-generic/Makefile
> +++ linux-2.6/arch/x86/mach-generic/Makefile
> @@ -2,7 +2,11 @@
>  # Makefile for the generic architecture
>  #
>  
> -EXTRA_CFLAGS	:= -Iarch/x86/kernel
> +EXTRA_CFLAGS			:= -Iarch/x86/kernel
>  
> -obj-y		:= probe.o summit.o bigsmp.o es7000.o default.o 
> -obj-y		+= ../../x86/mach-es7000/
> +obj-y				:= probe.o default.o
> +obj-$(CONFIG_X86_NUMAQ)		+= numaq.o
> +obj-$(CONFIG_X86_SUMMIT)	+= summit.o
> +obj-$(CONFIG_X86_BIGSMP)	+= bigsmp.o
> +obj-$(CONFIG_X86_ES7000)	+= es7000.o
> +obj-$(CONFIG_X86_ES7000)	+= ../../x86/mach-es7000/
> Index: linux-2.6/arch/x86/mach-generic/probe.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mach-generic/probe.c
> +++ linux-2.6/arch/x86/mach-generic/probe.c
> @@ -16,6 +16,7 @@
>  #include <asm/apicdef.h>
>  #include <asm/genapic.h>
>  
> +extern struct genapic apic_numaq;
>  extern struct genapic apic_summit;
>  extern struct genapic apic_bigsmp;
>  extern struct genapic apic_es7000;
> @@ -24,9 +25,18 @@ extern struct genapic apic_default;
>  struct genapic *genapic = &apic_default;
>  
>  static struct genapic *apic_probe[] __initdata = {
> +#ifdef CONFIG_X86_NUMAQ
> +	&apic_numaq,
> +#endif
> +#ifdef CONFIG_X86_SUMMIT
>  	&apic_summit,
> +#endif
> +#ifdef CONFIG_X86_BIGSMP
>  	&apic_bigsmp,
> +#endif
> +#ifdef CONFIG_X86_ES7000
>  	&apic_es7000,
> +#endif
>  	&apic_default,	/* must be last */
>  	NULL,
>  };
> @@ -54,6 +64,7 @@ early_param("apic", parse_apic);
>  
>  void __init generic_bigsmp_probe(void)
>  {
> +#if CONFIG_X86_BIGSMP
>  	/*
>  	 * This routine is used to switch to bigsmp mode when
>  	 * - There is no apic= option specified by the user
> @@ -67,6 +78,7 @@ void __init generic_bigsmp_probe(void)
>  			printk(KERN_INFO "Overriding APIC driver with %s\n",
>  			       genapic->name);
>  		}
> +#endif
>  }
>  
>  void __init generic_apic_probe(void)
> @@ -88,7 +100,8 @@ void __init generic_apic_probe(void)
>  
>  /* These functions can switch the APIC even after the initial ->probe() */
>  
> -int __init mps_oem_check(struct mp_config_table *mpc, char *oem, char *productid)
> +int __init mps_oem_check(struct mp_config_table *mpc, char *oem,
> +				 char *productid)
>  {
>  	int i;
>  	for (i = 0; apic_probe[i]; ++i) {

That looks like an unrelated cleanup?

> Index: linux-2.6/arch/x86/pci/Makefile_32
> ===================================================================
> --- linux-2.6.orig/arch/x86/pci/Makefile_32
> +++ linux-2.6/arch/x86/pci/Makefile_32
> @@ -13,10 +13,11 @@ pci-y				:= fixup.o
>  pci-$(CONFIG_ACPI)		+= acpi.o
>  pci-y				+= legacy.o irq.o
>  
> -# Careful: VISWS and NUMAQ overrule the pci-y above. The colons are
> +# Careful: VISWS overrule the pci-y above. The colons are
>  # therefor correct. This needs a proper fix by distangling the code.
>  pci-$(CONFIG_X86_VISWS)		:= visws.o fixup.o
> -pci-$(CONFIG_X86_NUMAQ)		:= numa.o irq.o
> +
> +pci-$(CONFIG_X86_NUMAQ)		+= numa.o
>  
>  # Necessary for NUMAQ as well
>  pci-$(CONFIG_NUMA)		+= mp_bus_to_node.o
> Index: linux-2.6/arch/x86/pci/numa.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/pci/numa.c
> +++ linux-2.6/arch/x86/pci/numa.c
> @@ -6,45 +6,21 @@
>  #include <linux/init.h>
>  #include <linux/nodemask.h>
>  #include <mach_apic.h>
> +#include <asm/mpspec.h>
>  #include "pci.h"
>  
>  #define XQUAD_PORTIO_BASE 0xfe400000
>  #define XQUAD_PORTIO_QUAD 0x40000  /* 256k per quad. */
>  
> -int mp_bus_id_to_node[MAX_MP_BUSSES];
>  #define BUS2QUAD(global) (mp_bus_id_to_node[global])
>  
> -int mp_bus_id_to_local[MAX_MP_BUSSES];
>  #define BUS2LOCAL(global) (mp_bus_id_to_local[global])
>  
> -void mpc_oem_bus_info(struct mpc_config_bus *m, char *name,
> -	struct mpc_config_translation *translation)
> -{
> -	int quad = translation->trans_quad;
> -	int local = translation->trans_local;
> -
> -	mp_bus_id_to_node[m->mpc_busid] = quad;
> -	mp_bus_id_to_local[m->mpc_busid] = local;
> -	printk(KERN_INFO "Bus #%d is %s (node %d)\n",
> -	       m->mpc_busid, name, quad);
> -}
> -
> -int quad_local_to_mp_bus_id [NR_CPUS/4][4];
>  #define QUADLOCAL2BUS(quad,local) (quad_local_to_mp_bus_id[quad][local])
> -void mpc_oem_pci_bus(struct mpc_config_bus *m,
> -	struct mpc_config_translation *translation)
> -{
> -	int quad = translation->trans_quad;
> -	int local = translation->trans_local;
> -
> -	quad_local_to_mp_bus_id[quad][local] = m->mpc_busid;
> -}
>  
>  /* Where the IO area was mapped on multiquad, always 0 otherwise */
>  void *xquad_portio;
> -#ifdef CONFIG_X86_NUMAQ
>  EXPORT_SYMBOL(xquad_portio);
> -#endif
>  
>  #define XQUAD_PORT_ADDR(port, quad) (xquad_portio + (XQUAD_PORTIO_QUAD*quad) + port)
>  
> @@ -179,6 +155,9 @@ static int __init pci_numa_init(void)
>  {
>  	int quad;
>  
> +	if (!found_numaq)
> +		return 0;
> +
>  	raw_pci_ops = &pci_direct_conf1_mq;
>  
>  	if (pcibios_scanned++)
> Index: linux-2.6/include/asm-x86/mach-generic/mach_mpparse.h
> ===================================================================
> --- linux-2.6.orig/include/asm-x86/mach-generic/mach_mpparse.h
> +++ linux-2.6/include/asm-x86/mach-generic/mach_mpparse.h
> @@ -1,7 +1,10 @@
>  #ifndef _MACH_MPPARSE_H
>  #define _MACH_MPPARSE_H 1
>  
> -int mps_oem_check(struct mp_config_table *mpc, char *oem, char *productid); 
> -int acpi_madt_oem_check(char *oem_id, char *oem_table_id); 
> +
> +extern int mps_oem_check(struct mp_config_table *mpc, char *oem,
> +			 char *productid);
> +
> +extern int acpi_madt_oem_check(char *oem_id, char *oem_table_id);
>  
>  #endif
> Index: linux-2.6/include/asm-x86/mach-numaq/mach_apic.h
> ===================================================================
> --- linux-2.6.orig/include/asm-x86/mach-numaq/mach_apic.h
> +++ linux-2.6/include/asm-x86/mach-numaq/mach_apic.h
> @@ -20,8 +20,14 @@ static inline cpumask_t target_cpus(void
>  #define INT_DELIVERY_MODE dest_LowestPrio
>  #define INT_DEST_MODE 0     /* physical delivery on LOCAL quad */
>   
> -#define check_apicid_used(bitmap, apicid) physid_isset(apicid, bitmap)
> -#define check_apicid_present(bit) physid_isset(bit, phys_cpu_present_map)
> +static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
> +{
> +	return physid_isset(apicid, bitmap);
> +}
> +static inline unsigned long check_apicid_present(int bit)
> +{
> +	return physid_isset(bit, phys_cpu_present_map);
> +}
>  #define apicid_cluster(apicid) (apicid & 0xF0)
>  
>  static inline int apic_id_registered(void)
> @@ -77,11 +83,6 @@ static inline int cpu_present_to_apicid(
>  		return BAD_APICID;
>  }
>  
> -static inline int generate_logical_apicid(int quad, int phys_apicid)
> -{
> -	return (quad << 4) + (phys_apicid ? phys_apicid << 1 : 1);
> -}
> -
>  static inline int apicid_to_node(int logical_apicid) 
>  {
>  	return logical_apicid >> 4;
> @@ -95,30 +96,6 @@ static inline physid_mask_t apicid_to_cp
>  	return physid_mask_of_physid(cpu + 4*node);
>  }
>  
> -struct mpc_config_translation {
> -	unsigned char mpc_type;
> -	unsigned char trans_len;
> -	unsigned char trans_type;
> -	unsigned char trans_quad;
> -	unsigned char trans_global;
> -	unsigned char trans_local;
> -	unsigned short trans_reserved;
> -};
> -
> -static inline int mpc_apic_id(struct mpc_config_processor *m, 
> -			struct mpc_config_translation *translation_record)
> -{
> -	int quad = translation_record->trans_quad;
> -	int logical_apicid = generate_logical_apicid(quad, m->mpc_apicid);
> -
> -	printk("Processor #%d %u:%u APIC version %d (quad %d, apic %d)\n",
> -	       m->mpc_apicid,
> -	       (m->mpc_cpufeature & CPU_FAMILY_MASK) >> 8,
> -	       (m->mpc_cpufeature & CPU_MODEL_MASK) >> 4,
> -	       m->mpc_apicver, quad, logical_apicid);
> -	return logical_apicid;
> -}
> -
>  extern void *xquad_portio;
>  
>  static inline void setup_portio_remap(void)
> Index: linux-2.6/include/asm-x86/mach-numaq/mach_mpparse.h
> ===================================================================
> --- linux-2.6.orig/include/asm-x86/mach-numaq/mach_mpparse.h
> +++ linux-2.6/include/asm-x86/mach-numaq/mach_mpparse.h
> @@ -1,14 +1,7 @@
>  #ifndef __ASM_MACH_MPPARSE_H
>  #define __ASM_MACH_MPPARSE_H
>  
> -extern void mpc_oem_bus_info(struct mpc_config_bus *m, char *name,
> -			     struct mpc_config_translation *translation);
> -extern void mpc_oem_pci_bus(struct mpc_config_bus *m,
> -	struct mpc_config_translation *translation);
> -
> -/* Hook from generic ACPI tables.c */
> -static inline void acpi_madt_oem_check(char *oem_id, char *oem_table_id)
> -{
> -}
> +extern void numaq_mps_oem_check(struct mp_config_table *mpc, char *oem,
> +				char *productid);
>  
>  #endif /* __ASM_MACH_MPPARSE_H */
> Index: linux-2.6/include/asm-x86/mmzone_32.h
> ===================================================================
> --- linux-2.6.orig/include/asm-x86/mmzone_32.h
> +++ linux-2.6/include/asm-x86/mmzone_32.h
> @@ -12,11 +12,9 @@
>  extern struct pglist_data *node_data[];
>  #define NODE_DATA(nid)	(node_data[nid])
>  
> -#ifdef CONFIG_X86_NUMAQ
> -	#include <asm/numaq.h>
> -#elif defined(CONFIG_ACPI_SRAT)/* summit or generic arch */
> -	#include <asm/srat.h>
> -#endif
> +#include <asm/numaq.h>
> +/* summit or generic arch */
> +#include <asm/srat.h>
>  
>  extern int get_memcfg_numa_flat(void);
>  /*
> @@ -26,14 +24,11 @@ extern int get_memcfg_numa_flat(void);
>   */
>  static inline void get_memcfg_numa(void)
>  {
> -#ifdef CONFIG_X86_NUMAQ
> +
>  	if (get_memcfg_numaq())
>  		return;
> -#elif defined(CONFIG_ACPI_SRAT)
>  	if (get_memcfg_from_srat())
>  		return;
> -#endif
> -
>  	get_memcfg_numa_flat();
>  }
>  
> @@ -42,7 +37,6 @@ extern int early_pfn_to_nid(unsigned lon
>  #else /* !CONFIG_NUMA */
>  
>  #define get_memcfg_numa get_memcfg_numa_flat
> -#define get_zholes_size(n) (0)
>  
>  #endif /* CONFIG_NUMA */
>  
> @@ -83,9 +77,6 @@ static inline int pfn_to_nid(unsigned lo
>  	__pgdat->node_start_pfn + __pgdat->node_spanned_pages;		\
>  })
>  
> -#ifdef CONFIG_X86_NUMAQ            /* we have contiguous memory on NUMA-Q */
> -#define pfn_valid(pfn)          ((pfn) < num_physpages)
> -#else
>  static inline int pfn_valid(int pfn)
>  {
>  	int nid = pfn_to_nid(pfn);
> @@ -94,7 +85,6 @@ static inline int pfn_valid(int pfn)
>  		return (pfn < node_end_pfn(nid));
>  	return 0;
>  }
> -#endif /* CONFIG_X86_NUMAQ */

Ok, that is a small change in pfn_valid for numaq, but essentially its a
little less efficient.  We can probabally live with that.

>  #endif /* CONFIG_DISCONTIGMEM */
>  
> Index: linux-2.6/include/asm-x86/numaq.h
> ===================================================================
> --- linux-2.6.orig/include/asm-x86/numaq.h
> +++ linux-2.6/include/asm-x86/numaq.h
> @@ -157,9 +157,10 @@ struct sys_cfg_data {
>  	struct		eachquadmem eq[MAX_NUMNODES];	/* indexed by quad id */
>  };
>  
> -static inline unsigned long *get_zholes_size(int nid)
> +#else
> +static inline int get_memcfg_numaq(void)
>  {
> -	return NULL;
> +	return 0;
>  }
>  #endif /* CONFIG_X86_NUMAQ */
>  #endif /* NUMAQ_H */
> Index: linux-2.6/include/asm-x86/srat.h
> ===================================================================
> --- linux-2.6.orig/include/asm-x86/srat.h
> +++ linux-2.6/include/asm-x86/srat.h
> @@ -27,11 +27,13 @@
>  #ifndef _ASM_SRAT_H_
>  #define _ASM_SRAT_H_
>  
> -#ifndef CONFIG_ACPI_SRAT
> -#error CONFIG_ACPI_SRAT not defined, and srat.h header has been included
> -#endif
> -
> +#ifdef CONFIG_ACPI_SRAT
>  extern int get_memcfg_from_srat(void);
> -extern unsigned long *get_zholes_size(int);
> +#else
> +static inline int get_memcfg_from_srat(void)
> +{
> +	return 0;
> +}
> +#endif
>  
>  #endif /* _ASM_SRAT_H_ */
> Index: linux-2.6/arch/x86/mach-generic/numaq.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6/arch/x86/mach-generic/numaq.c
> @@ -0,0 +1,41 @@
> +/*
> + * APIC driver for the IBM NUMAQ chipset.
> + */
> +#define APIC_DEFINITION 1
> +#include <linux/threads.h>
> +#include <linux/cpumask.h>
> +#include <linux/smp.h>
> +#include <asm/mpspec.h>
> +#include <asm/genapic.h>
> +#include <asm/fixmap.h>
> +#include <asm/apicdef.h>
> +#include <linux/kernel.h>
> +#include <linux/string.h>
> +#include <linux/init.h>
> +#include <asm/mach-numaq/mach_apic.h>
> +#include <asm/mach-numaq/mach_apicdef.h>
> +#include <asm/mach-numaq/mach_ipi.h>
> +#include <asm/mach-numaq/mach_mpparse.h>
> +#include <asm/mach-numaq/mach_wakecpu.h>
> +#include <asm/numaq.h>
> +
> +static int mps_oem_check(struct mp_config_table *mpc, char *oem,
> +		char *productid)
> +{
> +	numaq_mps_oem_check(mpc, oem, productid);
> +	return found_numaq;
> +}
> +
> +static int probe_numaq(void)
> +{
> +	/* already know from get_memcfg_numaq() */
> +	return found_numaq;
> +}
> +
> +/* Hook from generic ACPI tables.c */
> +static int acpi_madt_oem_check(char *oem_id, char *oem_table_id)
> +{
> +	return 0;
> +}
> +
> +struct genapic apic_numaq = APIC_INIT("NUMAQ", probe_numaq);
> Index: linux-2.6/arch/x86/mach-generic/bigsmp.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mach-generic/bigsmp.c
> +++ linux-2.6/arch/x86/mach-generic/bigsmp.c
> @@ -23,10 +23,8 @@ static int dmi_bigsmp; /* can be set by 
>  
>  static int hp_ht_bigsmp(const struct dmi_system_id *d)
>  {
> -#ifdef CONFIG_X86_GENERICARCH
>  	printk(KERN_NOTICE "%s detected: force use of apic=bigsmp\n", d->ident);
>  	dmi_bigsmp = 1;
> -#endif
>  	return 0;
>  }
>  
> Index: linux-2.6/drivers/acpi/Kconfig
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/Kconfig
> +++ linux-2.6/drivers/acpi/Kconfig
> @@ -4,7 +4,6 @@
>  
>  menuconfig ACPI
>  	bool "ACPI (Advanced Configuration and Power Interface) Support"
> -	depends on !X86_NUMAQ
>  	depends on !X86_VISWS
>  	depends on !IA64_HP_SIM
>  	depends on IA64 || X86
> Index: linux-2.6/include/asm-x86/mpspec.h
> ===================================================================
> --- linux-2.6.orig/include/asm-x86/mpspec.h
> +++ linux-2.6/include/asm-x86/mpspec.h
> @@ -13,6 +13,12 @@ extern int apic_version[MAX_APICS];
>  extern u8 apicid_2_node[];
>  extern int pic_mode;
>  
> +#ifdef CONFIG_X86_NUMAQ
> +extern int mp_bus_id_to_node[MAX_MP_BUSSES];
> +extern int mp_bus_id_to_local[MAX_MP_BUSSES];
> +extern int quad_local_to_mp_bus_id [NR_CPUS/4][4];
> +#endif
> +
>  #define MAX_APICID 256
>  
>  #else
> Index: linux-2.6/arch/x86/kernel/summit_32.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/summit_32.c
> +++ linux-2.6/arch/x86/kernel/summit_32.c
> @@ -36,7 +36,9 @@ static struct rio_table_hdr *rio_table_h
>  static struct scal_detail   *scal_devs[MAX_NUMNODES] __initdata;
>  static struct rio_detail    *rio_devs[MAX_NUMNODES*4] __initdata;
>  
> +#ifndef CONFIG_X86_NUMAQ
>  static int mp_bus_id_to_node[MAX_MP_BUSSES] __initdata;
> +#endif
>  
>  static int __init setup_pci_node_map_for_wpeg(int wpeg_num, int last_bus)
>  {
> Index: linux-2.6/arch/x86/boot/compressed/misc.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/boot/compressed/misc.c
> +++ linux-2.6/arch/x86/boot/compressed/misc.c
> @@ -217,10 +217,6 @@ static char *vidmem;
>  static int vidport;
>  static int lines, cols;
>  
> -#ifdef CONFIG_X86_NUMAQ
> -void *xquad_portio;
> -#endif
> -
>  #include "../../../../lib/inflate.c"
>  
>  static void *malloc(int size)
> Index: linux-2.6/arch/x86/Makefile
> ===================================================================
> --- linux-2.6.orig/arch/x86/Makefile
> +++ linux-2.6/arch/x86/Makefile
> @@ -117,29 +117,11 @@ mcore-$(CONFIG_X86_VOYAGER)	:= arch/x86/
>  mflags-$(CONFIG_X86_VISWS)	:= -Iinclude/asm-x86/mach-visws
>  mcore-$(CONFIG_X86_VISWS)	:= arch/x86/mach-visws/
>  
> -# NUMAQ subarch support
> -mflags-$(CONFIG_X86_NUMAQ)	:= -Iinclude/asm-x86/mach-numaq
> -mcore-$(CONFIG_X86_NUMAQ)	:= arch/x86/mach-default/
> -
> -# BIGSMP subarch support
> -mflags-$(CONFIG_X86_BIGSMP)	:= -Iinclude/asm-x86/mach-bigsmp
> -mcore-$(CONFIG_X86_BIGSMP)	:= arch/x86/mach-default/
> -
> -#Summit subarch support
> -mflags-$(CONFIG_X86_SUMMIT)	:= -Iinclude/asm-x86/mach-summit
> -mcore-$(CONFIG_X86_SUMMIT)	:= arch/x86/mach-default/
> -
>  # generic subarchitecture
>  mflags-$(CONFIG_X86_GENERICARCH):= -Iinclude/asm-x86/mach-generic
>  fcore-$(CONFIG_X86_GENERICARCH)	+= arch/x86/mach-generic/
>  mcore-$(CONFIG_X86_GENERICARCH)	:= arch/x86/mach-default/
>  
> -
> -# ES7000 subarch support
> -mflags-$(CONFIG_X86_ES7000)	:= -Iinclude/asm-x86/mach-es7000
> -fcore-$(CONFIG_X86_ES7000)	:= arch/x86/mach-es7000/
> -mcore-$(CONFIG_X86_ES7000)	:= arch/x86/mach-default/
> -
>  # RDC R-321x subarch support
>  mflags-$(CONFIG_X86_RDC321X)	:= -Iinclude/asm-x86/mach-rdc321x
>  mcore-$(CONFIG_X86_RDC321X)	:= arch/x86/mach-default/
> Index: linux-2.6/arch/x86/kernel/acpi/boot.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
> +++ linux-2.6/arch/x86/kernel/acpi/boot.c
> @@ -858,7 +858,7 @@ static int __init acpi_parse_madt_lapic_
>  #ifdef	CONFIG_X86_IO_APIC
>  #define MP_ISA_BUS		0
>  
> -#if defined(CONFIG_X86_ES7000) || defined(CONFIG_X86_GENERICARCH)
> +#ifdef CONFIG_X86_ES7000
>  extern int es7000_plat;
>  #endif
>  
> @@ -1007,7 +1007,7 @@ void __init mp_config_acpi_legacy_irqs(v
>  	set_bit(MP_ISA_BUS, mp_bus_not_pci);
>  	Dprintk("Bus #%d is ISA\n", MP_ISA_BUS);
>  
> -#if defined(CONFIG_X86_ES7000) || defined(CONFIG_X86_GENERICARCH)
> +#ifdef CONFIG_X86_ES7000
>  	/*
>  	 * Older generations of ES7000 have no legacy identity mappings
>  	 */
> Index: linux-2.6/arch/x86/mach-es7000/Makefile
> ===================================================================
> --- linux-2.6.orig/arch/x86/mach-es7000/Makefile
> +++ linux-2.6/arch/x86/mach-es7000/Makefile
> @@ -3,4 +3,3 @@
>  #
>  
>  obj-$(CONFIG_X86_ES7000)	:= es7000plat.o
> -obj-$(CONFIG_X86_GENERICARCH)	:= es7000plat.o
> Index: linux-2.6/arch/x86/mach-es7000/es7000plat.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mach-es7000/es7000plat.c
> +++ linux-2.6/arch/x86/mach-es7000/es7000plat.c
> @@ -177,53 +177,6 @@ find_unisys_acpi_oem_table(unsigned long
>  }
>  #endif
>  
> -/*
> - * This file also gets compiled if CONFIG_X86_GENERICARCH is set. Generic
> - * arch already has got following function definitions (asm-generic/es7000.c)
> - * hence no need to define these for that case.
> - */
> -#ifndef CONFIG_X86_GENERICARCH
> -void es7000_sw_apic(void);
> -void __init enable_apic_mode(void)
> -{
> -	es7000_sw_apic();
> -	return;
> -}
> -
> -__init int mps_oem_check(struct mp_config_table *mpc, char *oem,
> -		char *productid)
> -{
> -	if (mpc->mpc_oemptr) {
> -		struct mp_config_oemtable *oem_table =
> -			(struct mp_config_oemtable *)mpc->mpc_oemptr;
> -		if (!strncmp(oem, "UNISYS", 6))
> -			return parse_unisys_oem((char *)oem_table);
> -	}
> -	return 0;
> -}
> -#ifdef CONFIG_ACPI
> -/* Hook from generic ACPI tables.c */
> -int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
> -{
> -	unsigned long oem_addr;
> -	if (!find_unisys_acpi_oem_table(&oem_addr)) {
> -		if (es7000_check_dsdt())
> -			return parse_unisys_oem((char *)oem_addr);
> -		else {
> -			setup_unisys();
> -			return 1;
> -		}
> -	}
> -	return 0;
> -}
> -#else
> -int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
> -{
> -	return 0;
> -}
> -#endif
> -#endif /* COFIG_X86_GENERICARCH */
> -
>  static void
>  es7000_spin(int n)
>  {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

On the face of it the idea seems sound.  The NUMAQ changes look ok on a
quick scan.  I will need to see this applied and tested to be sure its
really sane.

-apw
