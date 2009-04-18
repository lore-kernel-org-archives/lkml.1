Return-Path: <linux-kernel-owner+w=401wt.eu-S1753156AbZDRKDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbZDRKDK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 06:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbZDRKC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 06:02:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49097 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZDRKCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 06:02:54 -0400
To: joseph.cihula@intel.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
       chrisw@sous-sol.org, jmorris@namei.org, jbeulich@novell.com,
       peterm@redhat.com, gang.wei@intel.com, shane.wang@intel.com
Subject: Re: [RFC v2][PATCH 1/1] intel_txt: Intel(R) TXT and tboot kernel support
From: Andi Kleen <andi@firstfloor.org>
References: <49D1A6AB.5090808@intel.com>
Date: Sat, 18 Apr 2009 12:02:49 +0200
In-Reply-To: <49D1A6AB.5090808@intel.com> (Joseph Cihula's message of "Mon, 30 Mar 2009 22:14:19 -0700")
Message-ID: <87d4baqnxy.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joseph Cihula <joseph.cihula@intel.com> writes:

Quick review.

Overall it doesn't seem too bad and looks clean and reasonable
overall, but some details probably need to be fixed.

> diff -uprN ../linux.trees.git/arch/x86/configs/i386_defconfig ./arch/x86/configs/i386_defconfig
> --- ../linux.trees.git/arch/x86/configs/i386_defconfig	2009-03-29 12:12:13.000000000 -0700
> +++ ./arch/x86/configs/i386_defconfig	2009-03-30 13:03:26.000000000 -0700
> @@ -51,6 +51,7 @@ CONFIG_X86_BIOS_REBOOT=y
> CONFIG_X86_TRAMPOLINE=y
> CONFIG_KTIME_SCALAR=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> +# CONFIG_INTEL_TXT is not set

Normally random patches shouldn't update defconfigs, maintainers do that.
Just drop these hunks.

> # General setup
> diff -uprN ../linux.trees.git/arch/x86/include/asm/bootparam.h ./arch/x86/include/asm/bootparam.h
> --- ../linux.trees.git/arch/x86/include/asm/bootparam.h	2009-03-29 12:12:13.000000000 -0700
> +++ ./arch/x86/include/asm/bootparam.h	2009-03-30 13:03:25.000000000 -0700
> @@ -62,6 +62,7 @@ struct setup_header {
> 	__u32	payload_offset;
> 	__u32	payload_length;
> 	__u64	setup_data;
> +	__u32   tboot_shared_addr;
> } __attribute__((packed));

These changes should be documented in Documentation/x86/zero-page.txt

> +/* GAS - Generic Address Structure (ACPI 2.0+) */
> +struct tboot_acpi_generic_address {
> +  u8  space_id;
> +  u8  bit_width;
> +  u8  bit_offset;
> +  u8  access_width;
> +  u64 address;
> +} __attribute__ ((__packed__));

Why not use the existing structure from ACPI?

> +struct tboot_acpi_sleep_info {
> +  struct tboot_acpi_generic_address pm1a_cnt_blk;
> +  struct tboot_acpi_generic_address pm1b_cnt_blk;
> +  struct tboot_acpi_generic_address pm1a_evt_blk;
> +  struct tboot_acpi_generic_address pm1b_evt_blk;
> +  u16 pm1a_cnt_val;
> +  u16 pm1b_cnt_val;
> +  u64 wakeup_vector;

So that vector can be >4GB but the tshared data structure not?

> +  u32 vector_width;
> +  u64 kernel_s3_resume_vector;
> +} __attribute__ ((__packed__));

In general it might be better to put ACPI defined structures somewhere 
in the acpi includes, separated from Linux defined types.

A reference to the spec in a comment would be also useful.

> +
> +struct tboot_shared {
> +	/* version 3+ fields: */
> +	struct tboot_uuid uuid; /* TBOOT_SHARED_UUID */
> +	u32  version;      	/* Version number: 5 is current */
> +	u32  log_addr;     	/* physical addr of tb_log_t log */
> +	u32  shutdown_entry;	/* entry point for tboot shutdown */
> +	u32  shutdown_type;	/* type of shutdown (TB_SHUTDOWN_*) */
> +	struct tboot_acpi_sleep_info
> +		  acpi_sinfo;	/* where kernel put acpi sleep info in Sx */
> +	u32  tboot_base;	/* starting addr for tboot */
> +	u32  tboot_size;	/* size of tboot */
> +	u8   num_mac_regions;   /* number mem regions to MAC on S3 */
> +				/* contig regions memory to MAC on S3 */
> +	struct tboot_mac_region mac_regions[MAX_TB_MAC_REGIONS];
> +	/* version 4+ fields: */
> +				/* populated by tboot; will be encrypted */
> +	u8   s3_key[TB_KEY_SIZE];
> +	/* version 5+ fields: */
> +	u8   reserved_align[3]; /* used to 4byte-align num_in_wfs */
> +	u32  num_in_wfs;        /* number of processors in wait-for-SIPI */

You could use __attribute__ aligned instead 

> 	*((unsigned short *)__va(0x472)) = reboot_mode;
>
> @@ -500,11 +504,17 @@ static void native_machine_emergency_res
>
> void native_machine_shutdown(void)
> {
> -	/* Stop the cpus and apics */
> #ifdef CONFIG_SMP
> -
> 	/* The boot cpu is always logical cpu 0 */
> 	int reboot_cpu_id = 0;
> +#endif
> +
> +	/* TXT requires VMX to be off for all shutdowns */
> +	if (tboot_in_measured_env())
> +		emergency_vmx_disable_all();

I thought KVM did that already in its shutdown handler? Why is this needed again?


> +#include <asm/pgalloc.h>
> +#include <asm/processor.h>
> +#include <asm/bootparam.h>
> +#include <asm/setup.h>
> +#include <asm/io.h>
> +#include <asm/tboot.h>
> +
> +/* Global pointer to shared data; NULL means no measured launch. */
> +struct tboot_shared *tboot_shared;

Should be __read_mostly probably

> +
> +static spinlock_t pgtable_lock;

Locks should have comments describing what they protect and possibly
required locking order if applicable.

Also should be using DEFINE_SPINLOCK (or maybe DEFINE_RAW_SPINLOCK, 
are all these contexts lockdep safe?)



> +void __init tboot_probe(void)
> +{
> +	/* Look for valid page-aligned address for shared page. */
> +	if (boot_params.hdr.tboot_shared_addr == 0)
> +		return;
> +
> +	/* Map and check for tboot UUID. */
> +	set_fixmap(FIX_TBOOT_SHARED_BASE, boot_params.hdr.tboot_shared_addr);

I would do a quick check here if this actually points to something
in the e820 map. Just to be paranoid and avoid crashes for junk input
data.


> +		tboot_shared = NULL;
> +		return;
> +	}
> +	if (tboot_shared->version < 5) {
> +		printk(KERN_WARNING "tboot_shared version is invalid: %u\n",
> +		       tboot_shared->version);

This would likely benefit from a more instructive prefix that points what
wentg wrong. TXT: ? "Measured-launch:"? TBOOT: ? Similar for other messages.


> +		return;
> +	}
> +
> +	spin_lock_init(&pgtable_lock);

Ok drop that and use DEFINE_*_SPINLOCK

> +	printk(KERN_INFO "TBOOT: found shared page at phys addr 0x%lx:\n",
> +	       (unsigned long)boot_params.hdr.tboot_shared_addr);
> +	printk(KERN_DEBUG "  version: %d\n", tboot_shared->version);
> +	printk(KERN_DEBUG "  log_addr: 0x%08x\n", tboot_shared->log_addr);
> +	printk(KERN_DEBUG "  shutdown_entry: 0x%x\n",
> +	       tboot_shared->shutdown_entry);
> +	printk(KERN_DEBUG "  tboot_base: 0x%08x\n", tboot_shared->tboot_base);
> +	printk(KERN_DEBUG "  tboot_size: 0x%x\n", tboot_shared->tboot_size);
> +}

Seem to be a lot more dependencies on all this stuff being < 4GB. Was that intended?

> +static pgd_t *tboot_pg_dir;
> +static u32 map_base, map_size;
> +static struct mm_struct tboot_mm = INIT_MM(tboot_mm);
> +
> +static inline void switch_to_tboot_pt(void)
> +{
> +	wbinvd();

Is the wbinvd really needed? If yes there should be a comment.

> +	native_write_cr3(virt_to_phys(tboot_pg_dir));

This means it explodes with paravirt, right? Do you have a check early
for that?

> +static void clean_up_tboot_mapping(void)
> +{
> +	pgd_t *pgd;
> +	pud_t *pud;
> +	pmd_t *pmd;
> +	pte_t *pte;
> +	unsigned long vaddr, i, j;
> +
> +	if (!tboot_in_measured_env())
> +		return;
> +
> +	/* The following loop is to release the pages allocated for building
> +	 * tboot page table. It releases pte pages, then pmd pages, then pud
> +	 * pages and finally the pgd page by using variable i to control
> +	 * the process, where
> +	 *  i = 0 denotes to release pte,
> +	 *  i = 1 denotes to release pmd,
> +	 *  i = 2 denotes to release pud,
> +	 *  and i > 2 denotes to release pgd
> +	 */
> +	i = 0;
> +	while (tboot_pg_dir) {
> +		for (j = 0, vaddr = map_base << PAGE_SHIFT;
> +		     j < map_size;
> +		     j++, vaddr += PAGE_SIZE) {
> +			if (i > 2) {
> +				if (tboot_pg_dir)
> +					pgd_free(&tboot_mm, tboot_pg_dir);

pgd_free() does a lot of things, some of them likely specific to user mappings.
Have you checked if that is all ok?

> +				tboot_pg_dir = 0;
> +				break;
> +			} else {
> +				pgd = pgd_offset(&tboot_mm, vaddr);
> +				if ((!pgd) || (!pgd_present(*pgd)))

The NULL checks here and below are all not needed. *_offset never returns NULL.

> +
> +			/* release pte */
> +			pte = pte_offset_kernel(pmd, 0);

So you assume the pte is in lowmem here..

> +			if (pte)
> +				pte_free_kernel(&tboot_mm, pte);
> +			pmd_clear(pmd);
> +		}
> +		i++;
> +	}
> +}
> +
> +static int map_page_for_tboot(unsigned long vaddr, unsigned long pfn,
> +			      pgprot_t prot)
> +{
> +	pgd_t *pgd;
> +	pud_t *pud;
> +	pmd_t *pmd;
> +	pte_t *pte;
> +
> +	pgd = pgd_offset(&tboot_mm, vaddr);
> +	pud = pud_alloc(&tboot_mm, pgd, vaddr);
> +	if (!pud)
> +		return -1;
> +	pmd = pmd_alloc(&tboot_mm, pud, vaddr);
> +	if (!pmd)
> +		return -1;
> +	pte = pte_alloc_map(&tboot_mm, pmd, vaddr);
> +	if (!pte)
> +		return -1;

... but not here. That seems inconsistent and might cause crashes with highpte on 32bit.
better to make sure none of them are in highmem.


> +	set_pte_at(&tboot_mm, vaddr, pte, pfn_pte(pfn, prot));
> +	pte_unmap(pte);
> +	return 0;
> +}
> +
> +static int map_pages_for_tboot(unsigned long vaddr, unsigned long start_pfn,
> +			       unsigned long nr)
> +{
> +	/* Reuse the original kernel mapping */
> +	tboot_pg_dir = pgd_alloc(&tboot_mm);

That puts the PGD into the pgd_list and then pageattr.c will actually
walk that list and change ptes, assuming it's a standard kernel 
mapping. Can you tolerate that? It seems dangerous. Better to use
a pgd_alloc_kernel(). There's none, but you could add one.

> +#include "acpi/realmode/wakeup.h"
> +#include <asm/trampoline.h>
> +
> +void tboot_shutdown(u32 shutdown_type)
> +{
> +	if (!tboot_in_measured_env())
> +		return;
> +
> +	/* only create the table once */
> +	spin_lock(&pgtable_lock);
> +	if (!tboot_pg_dir) {
> +		/* page alloc routines need interrupts enabled else they */
> +		/* generate debug warnings; we'll disable them afterwards */
> +		local_irq_enable();

Sorry but that doesn't work. It's still not safe to sleep with a spinlock
and there are other counters e.g. on preempt kernels.

It's probably not too bad in your case because there shouldn't be multiple
callers of tboot and probably also only in single CPU contexts, but
all the debugging infrastructure won't like it.

So likely you can just drop the spinlock. Perhaps add a WARN_ON() somewhere
for parallel entry using a simple flag.

Also I'm not sure it's a good idea to enable interrupts so deep
down in shutdown/suspend, it might confuse other code too. Better don't
do it.


> +			PFN_UP(WAKEUP_SIZE) << PAGE_SHIFT;
> +		/* AP trampoline code */
> +		tboot_shared->mac_regions[1].start =
> +			PFN_PHYS(PFN_DOWN(virt_to_phys(trampoline_base)));
> +		tboot_shared->mac_regions[1].size =
> +			PFN_UP(TRAMPOLINE_SIZE) << PAGE_SHIFT;
> +		/* kernel code + data + bss */
> +		tboot_shared->mac_regions[2].start =
> +			PFN_PHYS(PFN_DOWN(virt_to_phys(&_text)));
> +		tboot_shared->mac_regions[2].size =
> +			PFN_PHYS(PFN_UP(virt_to_phys(&_end))) -
> +			PFN_PHYS(PFN_DOWN(virt_to_phys(&_text)));
> +	}
> +
> +	tboot_shared->shutdown_type = shutdown_type;
> +
> +	switch_to_tboot_pt();

What happens with the NMIs? (nmi watchdog etc.) Are they all disabled at this point?
Machine checks probably too.

It might be safer to load a special IDT too that just returns.


> +
> +	((void(*)(void))(unsigned long)tboot_shared->shutdown_entry)();
> +
> +	BUG(); /* should not reach here */

The bug will explode because the kernel is gone. 

> +}
> +
> +void tboot_sleep(u8 sleep_state)
> +{
> +	uint32_t shutdown_type;
> +
> +	switch (sleep_state) {
> +	case ACPI_STATE_S3:
> +		shutdown_type = TB_SHUTDOWN_S3;
> +		break;
> +	case ACPI_STATE_S4:
> +		shutdown_type = TB_SHUTDOWN_S4;
> +		break;
> +	case ACPI_STATE_S5:
> +		shutdown_type = TB_SHUTDOWN_S5;
> +		break;
> +	default:
> +		return;
> +	}

That's a simple table lookup, could be done much shorter this way.


> +#define TXT_PUB_CONFIG_REGS_BASE       0xfed30000
> +#define TXT_PRIV_CONFIG_REGS_BASE      0xfed20000

Really no way to discover that? 

> +			    *(u64 *)(config + TXTCR_HEAP_SIZE));
> +	iounmap(config);
> +	if (heap_base == NULL)
> +		return NULL;
> +
> +	/* walk heap to SinitMleData */
> +	/* skip BiosData */
> +	heap_ptr = heap_base + *(uint64_t *)heap_base;

Normally using u64. i would add some sanity checks for out of bounds etc.
Normally it's a good idea to sanity check anything coming from the BIOS.

Also isn't this reinventing ACPI table parser code? Perhaps the ACPI code
could be used directly instead. or is this too early?


> +	tbg.access_width = g.access_width;  \
> +	tbg.address = g.address;
> +
> +	if (tboot_in_measured_env()) {
> +		TB_COPY_GAS(tboot_shared->acpi_sinfo.pm1a_cnt_blk,
> +			    acpi_gbl_FADT.xpm1a_control_block);
> +		TB_COPY_GAS(tboot_shared->acpi_sinfo.pm1b_cnt_blk,
> +			    acpi_gbl_FADT.xpm1b_control_block);
> +		TB_COPY_GAS(tboot_shared->acpi_sinfo.pm1a_evt_blk,
> +			    acpi_gbl_FADT.xpm1a_event_block);
> +		TB_COPY_GAS(tboot_shared->acpi_sinfo.pm1b_evt_blk,
> +			    acpi_gbl_FADT.xpm1b_event_block);
> +		tboot_shared->acpi_sinfo.pm1a_cnt_val = PM1Acontrol;
> +		tboot_shared->acpi_sinfo.pm1b_cnt_val = PM1Bcontrol;
> +		/* we need phys addr of waking vector, but can't use
> +		   virt_to_phys() on &acpi_gbl_FACS because it is ioremap'ed,
> +		   so calc from FACS phys addr */
> +		tboot_shared->acpi_sinfo.wakeup_vector = acpi_gbl_FADT.facs +
> +			((void *)&acpi_gbl_FACS->firmware_waking_vector -
> +			 (void *)acpi_gbl_FACS);

That's an opencoded offsetof ?

And you assign the address of the field in the FACS, not the value?

> @@ -404,6 +406,8 @@ int disable_nonboot_cpus(void)
> 			break;
> 		}
> 	}
> +	/* ensure all CPUs have gone into wait-for-SIPI */
> +	tboot_wait_for_aps(num_cpus);

That looks like something that should be done generically. Wait for 
the other CPUs to be "dead". 

>
>
> +config INTEL_TXT
> +        bool "Enable Intel(R) Trusted Execution Technology (Intel(R) TXT)"
> +        depends on EXPERIMENTAL && X86
> +        help
> +          This option enables support for booting the kernel with
> +          the Trusted Boot (tboot) module. This will utilize
> +          Intel(R) Trusted Execution Technology to perform a
> +          measured launch of the kernel. 

One-two sentences here what value a a measured launch brings to the user.

> If the system does not
> +          support Intel(R) TXT, this will have no effect.
> +
> +          See <http://www.intel.com/technology/security/> for more
> +          information about Intel(R) TXT.
> +          And see <http://tboot.sourceforge.net> for more information
> +          about tboot.
> +
> +          If you are unsure as to whether this is required, answer N.

Putting the howto you had in the intro somewhere in Documentation/*
and adding a pointer to it here would be a good idea.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
