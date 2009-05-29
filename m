Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbZE2BCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbZE2BCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 21:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbZE2BCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 21:02:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:22478 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbZE2BCI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 21:02:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,268,1241420400"; 
   d="scan'208";a="148177319"
From: "Cihula, Joseph" <joseph.cihula@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>, "Wang, Shane" <shane.wang@intel.com>
Date: Thu, 28 May 2009 18:02:00 -0700
Subject: RE: [RFC v3][PATCH 2/2] intel_txt: Intel(R) TXT and tboot kernel
 support
Thread-Topic: [RFC v3][PATCH 2/2] intel_txt: Intel(R) TXT and tboot kernel
 support
Thread-Index: AcnPqrip9LgXOoMWT3a0nsuxTZqjdgPOyUAA
Message-ID: <4F65016F6CB04E49BFFA15D4F7B798D9A26AB5ED@orsmsx506.amr.corp.intel.com>
References: <4A03B9C3.9090607@intel.com>
 <20090507235334.05952fa4.akpm@linux-foundation.org>
In-Reply-To: <20090507235334.05952fa4.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Sent: Thursday, May 07, 2009 11:54 PM
>
> On Thu, 07 May 2009 21:49:07 -0700 Joseph Cihula <joseph.cihula@intel.com> wrote:
>
> > Linux support for Intel(R) Trusted Execution Technology.
> >
> > --- linux-2.6.30-rc4/arch/x86/include/asm/fixmap.h  2009-04-29 21:48:16.000000000 -0700
> > +++ linux-2.6.30-rc4-lkml/arch/x86/include/asm/fixmap.h     2009-05-07 08:07:17.000000000 -
> 0700
> > @@ -132,6 +132,9 @@ enum fixed_addresses {
> >  #ifdef CONFIG_X86_32
> >     FIX_WP_TEST,
> >  #endif
> > +#ifdef CONFIG_INTEL_TXT
> > +   FIX_TBOOT_SHARED_BASE,
> > +#endif
>
> Curious.  Does this "shared" page get documented anywhere in the code?

I've added a brief comment in tboot.h.

> It can't use ioremap() or early_ioremap()?

The tboot_probe() fn that maps the shared page is called too early in boot to use ioremap().  And since the shared page needs to remain mapped for the lifetime of the kernel, it did not seem appropriate to use early_ioremap() (which is specified as being for temporary boot-time mappings).

> >     __end_of_fixed_addresses
> >  };
> >
> >
> > ...
> >
> > +struct tboot_uuid {
> > +   u32    data1;
> > +   u16    data2;
> > +   u16    data3;
> > +   u16    data4;
> > +   u8     data5[6];
> > +} __attribute__ ((__packed__));
>
> Please use __packed everywhere.

Done.

> > +/* used to communicate between tboot and the launched kernel */
> > +
> > +#define TB_KEY_SIZE             64   /* 512 bits */
> > +
> > +#define MAX_TB_MAC_REGIONS      32
> > +struct tboot_mac_region {
> > +  u64  start;         /* must be 64 byte -aligned */
> > +  u32  size;          /* must be 64 byte -granular */
> > +} __attribute__ ((__packed__));
> > +
> > +/* GAS - Generic Address Structure (ACPI 2.0+) */
> > +struct tboot_acpi_generic_address {
> > +  u8  space_id;
> > +  u8  bit_width;
> > +  u8  bit_offset;
> > +  u8  access_width;
> > +  u64 address;
> > +} __attribute__ ((__packed__));
> > +
> > +/* combines Sx info from FADT and FACS tables per ACPI 2.0+ spec
> > +   (http://www.acpi.info/) */
> > +struct tboot_acpi_sleep_info {
> > +  struct tboot_acpi_generic_address pm1a_cnt_blk;
> > +  struct tboot_acpi_generic_address pm1b_cnt_blk;
> > +  struct tboot_acpi_generic_address pm1a_evt_blk;
> > +  struct tboot_acpi_generic_address pm1b_evt_blk;
> > +  u16 pm1a_cnt_val;
> > +  u16 pm1b_cnt_val;
> > +  u64 wakeup_vector;
> > +  u32 vector_width;
> > +  u64 kernel_s3_resume_vector;
>
> Indenting broke in many places.

Fixed.

> I didn't see a `depends on ACPI' in Kconfig.  Is it needed?

Good catch; yes, it will be needed for proper shutdown of the system.  I'll add a dependency on it.

> > +} __attribute__ ((__packed__));
> > +
> > +struct tboot_shared {
> > +   /* version 3+ fields: */
> > +   struct tboot_uuid uuid; /* TBOOT_SHARED_UUID */
> > +   u32  version;           /* Version number: 5 is current */
> > +   u32  log_addr;          /* physical addr of tb_log_t log */
> > +   u32  shutdown_entry;    /* entry point for tboot shutdown */
> > +   u32  shutdown_type;     /* type of shutdown (TB_SHUTDOWN_*) */
> > +   struct tboot_acpi_sleep_info
> > +             acpi_sinfo;   /* where kernel put acpi sleep info in Sx */
> > +   u32  tboot_base;        /* starting addr for tboot */
> > +   u32  tboot_size;        /* size of tboot */
> > +   u8   num_mac_regions;   /* number mem regions to MAC on S3 */
> > +                           /* contig regions memory to MAC on S3 */
> > +   struct tboot_mac_region mac_regions[MAX_TB_MAC_REGIONS];
> > +   /* version 4+ fields: */
> > +                           /* populated by tboot; will be encrypted */
> > +   u8   s3_key[TB_KEY_SIZE];
> > +   /* version 5+ fields: */
> > +   u8   reserved_align[3]; /* used to 4byte-align num_in_wfs */
> > +   u32  num_in_wfs;        /* number of processors in wait-for-SIPI */
> > +} __attribute__ ((__packed__));
> > +
> > +/* UUID for tboot_shared data struct to facilitate matching */
> > +/* {663C8DFF-E8B3-4b82-AABF-19EA4D057A08} */
> > +#define TBOOT_SHARED_UUID     \
> > +           ((struct tboot_uuid){ 0x663c8dff, 0xe8b3, 0x4b82, 0xaabf,   \
> > +                           { 0x19, 0xea, 0x4d, 0x5, 0x7a, 0x8 } })
>
> Strange.  A
>
>       static struct tboot_uuid uuid __initdata = { ... };
>
> within tboot_probe() would suffice.

It seems logical to keep the definition of the UUID in the header file with the data struct that uses it.  But I created a static var in tboot_probe() defined as __initdata to hold it so that the memory can be reclaimed post-init.

> > +extern struct tboot_shared *tboot_shared;
> > +
> > +static inline int tboot_in_measured_env(void)
> > +{
> > +   return tboot_shared != NULL;
> > +}
> > +
> >
> > ...
> >
> > +
> > +#include <linux/init.h>
> > +#include <linux/sched.h>
> > +#include <linux/pfn.h>
> > +#include <linux/mm.h>
> > +#include <linux/spinlock.h>
> > +#include <linux/init_task.h>
>
> a newline here is typical

Done.

> > +#include <asm/pgtable.h>
> > +#include <asm/pgalloc.h>
> > +#include <asm/processor.h>
> > +#include <asm/bootparam.h>
> > +#include <asm/setup.h>
> > +#include <asm/io.h>
> > +#include <asm/e820.h>
> > +#include <asm/tboot.h>
> > +
> > +/* Global pointer to shared data; NULL means no measured launch. */
> > +struct tboot_shared *tboot_shared __read_mostly;
> > +
> > +void __init tboot_probe(void)
> > +{
> > +   /* Look for valid page-aligned address for shared page. */
> > +   if (boot_params.tboot_shared_addr == 0)
> > +           return;
> > +   /* also verify that it is mapped as we expect it before calling
> > +      set_fixmap(), to reduce chance of garbage value causing crash */
> > +   if (!e820_any_mapped(boot_params.tboot_shared_addr,
> > +                        boot_params.tboot_shared_addr, E820_UNUSABLE)) {
> > +           printk(KERN_WARNING "TXT: non-0 tboot_shared_addr but it is not of type
> E820_UNUSABLE\n");
> > +           return;
> > +   }
> > +
> > +   /* only a natively booted kernel should be using TXT */
> > +   if (paravirt_enabled()) {
> > +           printk(KERN_WARNING "TXT: non-0 tboot_shared_addr but pv_ops is enabled\n");
> > +           return;
> > +   }
> > +
> > +   /* Map and check for tboot UUID. */
> > +   set_fixmap(FIX_TBOOT_SHARED_BASE, boot_params.tboot_shared_addr);
> > +   tboot_shared = (struct tboot_shared *)
> > +                           fix_to_virt(FIX_TBOOT_SHARED_BASE);
> > +   if (memcmp(&TBOOT_SHARED_UUID, &tboot_shared->uuid,
> > +              sizeof(struct tboot_uuid))) {
> > +           printk(KERN_WARNING "TXT: tboot_shared at 0x%lx is invalid\n",
> > +                  (unsigned long)boot_params.tboot_shared_addr);
>
> That's a peculiar way of printing a u64, especially on 32 bit.
>
> The code appears to be enabled for 32-bit.  Is that a
> supported/tested/realistic combination?

Both 32b and 64b are supported and have been tested.  TXT has some address restrictions (<4GB) that resulted in some of these.  However, I have converted these to %llx and removed the cast.

> > +           tboot_shared = NULL;
> > +           return;
> > +   }
> > +   if (tboot_shared->version < 5) {
> > +           printk(KERN_WARNING "TXT: tboot_shared version is invalid: %u\n",
> > +                  tboot_shared->version);
> > +           tboot_shared = NULL;
> > +           return;
> > +   }
> > +
> > +   printk(KERN_INFO "TXT: found shared page at phys addr 0x%lx:\n",
> > +          (unsigned long)boot_params.tboot_shared_addr);
> > +   printk(KERN_DEBUG "TXT:  version: %d\n", tboot_shared->version);
> > +   printk(KERN_DEBUG "TXT:  log_addr: 0x%08x\n", tboot_shared->log_addr);
> > +   printk(KERN_DEBUG "TXT:  shutdown_entry: 0x%x\n",
> > +          tboot_shared->shutdown_entry);
> > +   printk(KERN_DEBUG "TXT:  tboot_base: 0x%08x\n",
> > +          tboot_shared->tboot_base);
> > +   printk(KERN_DEBUG "TXT:  tboot_size: 0x%x\n",
> > +          tboot_shared->tboot_size);
> > +}
> > +
> >
> > ...
> >
> > +void tboot_shutdown(u32 shutdown_type)
> > +{
> > +   if (!tboot_in_measured_env())
> > +           return;
> > +
> > +   /* if we're being called before the 1:1 mapping is set up then just
> > +      return and let the normal shutdown happen; this should only be
> > +      due to very early panic() */
> > +   if (!tboot_pg_dir)
> > +           return;
> > +
> > +   local_irq_disable();
>
> Mystery local_irq_disable() needs a comment, methinks.

This isn't needed after all and has been removed.

> > +   /* if this is S3 then set regions to MAC */
> > +   if (shutdown_type == TB_SHUTDOWN_S3) {
> > +           tboot_shared->num_mac_regions = 3;
> > +           /* S3 resume code */
> > +           tboot_shared->mac_regions[0].start =
> > +                   PFN_PHYS(PFN_DOWN(acpi_wakeup_address));
> > +           tboot_shared->mac_regions[0].size =
> > +                   PFN_UP(WAKEUP_SIZE) << PAGE_SHIFT;
> > +           /* AP trampoline code */
> > +           tboot_shared->mac_regions[1].start =
> > +                   PFN_PHYS(PFN_DOWN(virt_to_phys(trampoline_base)));
> > +           tboot_shared->mac_regions[1].size =
> > +                   PFN_UP(TRAMPOLINE_SIZE) << PAGE_SHIFT;
> > +           /* kernel code + data + bss */
> > +           tboot_shared->mac_regions[2].start =
> > +                   PFN_PHYS(PFN_DOWN(virt_to_phys(&_text)));
> > +           tboot_shared->mac_regions[2].size =
> > +                   PFN_PHYS(PFN_UP(virt_to_phys(&_end))) -
> > +                   PFN_PHYS(PFN_DOWN(virt_to_phys(&_text)));
> > +   }
> > +
> > +   tboot_shared->shutdown_type = shutdown_type;
> > +
> > +   switch_to_tboot_pt();
> > +
> > +   ((void(*)(void))(unsigned long)tboot_shared->shutdown_entry)();
> > +
> > +   /* should not reach here */
> > +   while (1)
> > +           halt();
> > +}
> > +
> >
> > ...
> >
> > +struct acpi_table_header *tboot_get_dmar_table(void)
> > +{
> > +   void *heap_base, *heap_ptr, *config;
> > +   struct acpi_table_header *dmar_table;
> > +
> > +   /* ACPI tables may not be DMA protected by tboot, so use DMAR copy */
> > +   /* SINIT saved in SinitMleData in TXT heap (which is DMA protected) */
> > +
> > +   /* map config space in order to get heap addr */
> > +   config = ioremap(TXT_PUB_CONFIG_REGS_BASE, NR_TXT_CONFIG_PAGES *
> > +                    PAGE_SIZE);
> > +   if (config == NULL)
> > +           return NULL;
> > +
> > +   /* now map TXT heap */
> > +   heap_base = ioremap(*(u64 *)(config + TXTCR_HEAP_BASE),
> > +                       *(u64 *)(config + TXTCR_HEAP_SIZE));
> > +   iounmap(config);
> > +   if (heap_base == NULL)
> > +           return NULL;
> > +
> > +   /* walk heap to SinitMleData */
> > +   /* skip BiosData */
> > +   heap_ptr = heap_base + *(u64 *)heap_base;
> > +   /* skip OsMleData */
> > +   heap_ptr += *(u64 *)heap_ptr;
> > +   /* skip OsSinitData */
> > +   heap_ptr += *(u64 *)heap_ptr;
> > +   /* now points to SinitMleDataSize; set to SinitMleData */
> > +   heap_ptr += sizeof(u64);
> > +   /* get addr of DMAR table */
> > +   dmar_table = (struct acpi_table_header *)(heap_ptr +
> > +                   ((struct sinit_mle_data *)heap_ptr)->vtd_dmars_off -
> > +                     sizeof(u64));
> > +
> > +   /* don't unmap heap because dmar.c needs access to this */
> > +
> > +   return dmar_table;
> > +}
>
> This function trusts BIOS authors rather a lot.

Not really--this data structure gets validated as part of the TXT launch process and only tboot and the kernel execute after that point.  So since none of them modify this structure, it should still be valid (as valid as any other kernel data struct which does not get re-validated on every use).

> > ...
> >
> > +config INTEL_TXT
> > +        bool "Enable Intel(R) Trusted Execution Technology (Intel(R) TXT)"
> > +        depends on EXPERIMENTAL && X86 && DMAR
> > +        help
> > +          This option enables support for booting the kernel with the
> > +     Trusted Boot (tboot) module. This will utilize
> > +          Intel(R) Trusted Execution Technology to perform a measured launch
> > +     of the kernel. If the system does not support Intel(R) TXT, this
> > +     will have no effect.
> > +
> > +     Intel TXT will provide higher assurance of sysem configuration and
> > +     initial state as well as data reset protection.  This is used to
> > +     create a robust initial kernel measurement and verification.
> > +
> > +          See <http://www.intel.com/technology/security/> for more information
> > +     about Intel(R) TXT.
> > +          See <http://tboot.sourceforge.net> for more information about tboot.
> > +     See Documentation/intel_txt.txt for a description of how to enable
> > +     Intel TXT support in a kernel boot.
> > +
> > +          If you are unsure as to whether this is required, answer N.
> > +
>
> The help uses a mix of tab- and space-indenting which is why it looks
> all messy when quoted.

Fixed.

