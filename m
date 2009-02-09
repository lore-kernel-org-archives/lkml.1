Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbZBIMhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbZBIMhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 07:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129AbZBIMh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 07:37:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49683 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753865AbZBIMh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 07:37:27 -0500
Date: Mon, 9 Feb 2009 13:37:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Len Brown <lenb@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-acpi@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: state of some x86 acpi patches
Message-ID: <20090209123711.GK17782@elte.hu>
References: <4947FF4C.80706@goop.org> <20081216192534.GB843@elte.hu> <alpine.LFD.2.00.0812311821110.3854@localhost.localdomain> <495C677F.6080707@goop.org> <20090102153957.GA1180@elte.hu> <4980EE0C.4070308@goop.org> <49810211.9030808@kernel.org> <498CF8DA.30004@goop.org> <498CFD95.5070004@kernel.org> <498E229C.5030205@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498E229C.5030205@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Yinghai Lu wrote:
>> Ingo is too busy...
>> It seems Len already agreed those patches can go through tip.
>>   
>
> OK, I have them prepared as a branch off tip/git pullable from:
>
> The following changes since commit 82eda818f26cbef2b0a6bf6580e52645af62e4fd:
>  Ingo Molnar (1):
>        Merge branch 'core/locking'
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git acpi/map
>
> Jeremy Fitzhardinge (3):
>      x86: use early_ioremap in __acpi_map_table
>      x86: always explicitly map acpi memory
>      acpi: remove final __acpi_map_table mapping before setting acpi_gbl_permanent_mmap
>
> Yinghai Lu (2):
>      acpi/x86: introduce __apci_map_table, v4
>      revert_fix_es7000_compiling
>
> arch/ia64/kernel/acpi.c          |    4 ++++
> arch/x86/include/asm/acpi.h      |    3 ---
> arch/x86/include/asm/fixmap_32.h |    4 ----
> arch/x86/include/asm/fixmap_64.h |    4 ----
> arch/x86/kernel/acpi/boot.c      |   33 ++++++++-------------------------
> arch/x86/kernel/es7000_32.c      |    9 ++++++++-
> drivers/acpi/acpica/tbxface.c    |   17 ++++++++++++++---
> drivers/acpi/osl.c               |   11 +++++++++--
> drivers/acpi/tables.c            |   20 ++++++++++++++------
> include/acpi/acpiosxf.h          |    1 +
> include/acpi/acpixf.h            |    4 ++++
> include/linux/acpi.h             |    1 +
> 12 files changed, 63 insertions(+), 48 deletions(-)

Ok, pulled into tip:x86/acpi, thanks guys!

Len: i've added your Ack to the ACPI commits.

	Ingo

---------------------->
commit b825e6cc7b1401862531df497a4a4daff8102ed5
Author: Yinghai Lu <yhlu.kernel@gmail.com>
Date:   Sat Feb 7 15:39:41 2009 -0800

    x86, es7000: fix ACPI table mappings
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/es7000_32.c b/arch/x86/kernel/es7000_32.c
index 53699c9..71d7be6 100644
--- a/arch/x86/kernel/es7000_32.c
+++ b/arch/x86/kernel/es7000_32.c
@@ -292,24 +292,31 @@ int __init find_unisys_acpi_oem_table(unsigned long *oem_addr)
 {
 	struct acpi_table_header *header = NULL;
 	int i = 0;
+	acpi_size tbl_size;
 
-	while (ACPI_SUCCESS(acpi_get_table("OEM1", i++, &header))) {
+	while (ACPI_SUCCESS(acpi_get_table_with_size("OEM1", i++, &header, &tbl_size))) {
 		if (!memcmp((char *) &header->oem_id, "UNISYS", 6)) {
 			struct oem_table *t = (struct oem_table *)header;
 
 			oem_addrX = t->OEMTableAddr;
 			oem_size = t->OEMTableSize;
+			early_acpi_os_unmap_memory(header, tbl_size);
 
 			*oem_addr = (unsigned long)__acpi_map_table(oem_addrX,
 								    oem_size);
 			return 0;
 		}
+		early_acpi_os_unmap_memory(header, tbl_size);
 	}
 	return -1;
 }
 
 void __init unmap_unisys_acpi_oem_table(unsigned long oem_addr)
 {
+	if (!oem_addr)
+		return;
+
+	__acpi_unmap_table((char *)oem_addr, oem_size);
 }
 #endif
 

commit 7d97277b754d3ee098a5ec69b6aaafb00c94e2f2
Author: Yinghai Lu <yhlu.kernel@gmail.com>
Date:   Sat Feb 7 15:39:41 2009 -0800

    acpi/x86: introduce __apci_map_table, v4
    
    to prevent wrongly overwriting fixmap that still want to use.
    
    ACPI used to rely on low mappings being all linearly mapped and
    grew a habit: it never really unmapped certain kinds of tables
    after use.
    
    This can cause problems - for example the hypothetical case
    when some spurious access still references it.
    
    v2: remove prev_map and prev_size in __apci_map_table
    v3: let acpi_os_unmap_memory() call early_iounmap too, so remove extral calling to
    early_acpi_os_unmap_memory
    v4: fix typo in one acpi_get_table_with_size calling
    
    Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
    Acked-by: Len Brown <len.brown@intel.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index d541671..2363ed1 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -199,6 +199,10 @@ char *__init __acpi_map_table(unsigned long phys_addr, unsigned long size)
 	return __va(phys_addr);
 }
 
+char *__init __acpi_unmap_table(unsigned long virt_addr, unsigned long size)
+{
+}
+
 /* --------------------------------------------------------------------------
                             Boot-time Table Parsing
    -------------------------------------------------------------------------- */
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 7217834..4c2aaea 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -121,21 +121,18 @@ enum acpi_irq_model_id acpi_irq_model = ACPI_IRQ_MODEL_PIC;
  */
 char *__init __acpi_map_table(unsigned long phys, unsigned long size)
 {
-	static char *prev_map;
-	static unsigned long prev_size;
-
-	if (prev_map) {
-		early_iounmap(prev_map, prev_size);
-		prev_map = NULL;
-	}
 
 	if (!phys || !size)
 		return NULL;
 
-	prev_size = size;
-	prev_map = early_ioremap(phys, size);
+	return early_ioremap(phys, size);
+}
+void __init __acpi_unmap_table(char *map, unsigned long size)
+{
+	if (!map || !size)
+		return;
 
-	return prev_map;
+	early_iounmap(map, size);
 }
 
 #ifdef CONFIG_PCI_MMCONFIG
diff --git a/drivers/acpi/acpica/tbxface.c b/drivers/acpi/acpica/tbxface.c
index c3e841f..ab0aff3 100644
--- a/drivers/acpi/acpica/tbxface.c
+++ b/drivers/acpi/acpica/tbxface.c
@@ -365,7 +365,7 @@ ACPI_EXPORT_SYMBOL(acpi_unload_table_id)
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_get_table
+ * FUNCTION:    acpi_get_table_with_size
  *
  * PARAMETERS:  Signature           - ACPI signature of needed table
  *              Instance            - Which instance (for SSDTs)
@@ -377,8 +377,9 @@ ACPI_EXPORT_SYMBOL(acpi_unload_table_id)
  *
  *****************************************************************************/
 acpi_status
-acpi_get_table(char *signature,
-	       u32 instance, struct acpi_table_header **out_table)
+acpi_get_table_with_size(char *signature,
+	       u32 instance, struct acpi_table_header **out_table,
+	       acpi_size *tbl_size)
 {
        u32 i;
        u32 j;
@@ -408,6 +409,7 @@ acpi_get_table(char *signature,
 		    acpi_tb_verify_table(&acpi_gbl_root_table_list.tables[i]);
 		if (ACPI_SUCCESS(status)) {
 			*out_table = acpi_gbl_root_table_list.tables[i].pointer;
+			*tbl_size = acpi_gbl_root_table_list.tables[i].length;
 		}
 
 		if (!acpi_gbl_permanent_mmap) {
@@ -420,6 +422,15 @@ acpi_get_table(char *signature,
 	return (AE_NOT_FOUND);
 }
 
+acpi_status
+acpi_get_table(char *signature,
+	       u32 instance, struct acpi_table_header **out_table)
+{
+	acpi_size tbl_size;
+
+	return acpi_get_table_with_size(signature,
+		       instance, out_table, &tbl_size);
+}
 ACPI_EXPORT_SYMBOL(acpi_get_table)
 
 /*******************************************************************************
diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index fb1be7b..765fd1c 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -694,12 +694,6 @@ void __init acpi_early_init(void)
 	if (!acpi_strict)
 		acpi_gbl_enable_interpreter_slack = TRUE;
 
-	/*
-	 * Doing a zero-sized mapping will clear out the previous
-	 * __acpi_map_table() mapping, if any.
-	 */
-	__acpi_map_table(0, 0);
-
 	acpi_gbl_permanent_mmap = 1;
 
 	status = acpi_reallocate_root_table();
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index b3193ec..d1dd516 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -274,12 +274,19 @@ EXPORT_SYMBOL_GPL(acpi_os_map_memory);
 
 void acpi_os_unmap_memory(void __iomem * virt, acpi_size size)
 {
-	if (acpi_gbl_permanent_mmap) {
+	if (acpi_gbl_permanent_mmap)
 		iounmap(virt);
-	}
+	else
+		__acpi_unmap_table(virt, size);
 }
 EXPORT_SYMBOL_GPL(acpi_os_unmap_memory);
 
+void early_acpi_os_unmap_memory(void __iomem * virt, acpi_size size)
+{
+	if (!acpi_gbl_permanent_mmap)
+		__acpi_unmap_table(virt, size);
+}
+
 #ifdef ACPI_FUTURE_USAGE
 acpi_status
 acpi_os_get_physical_address(void *virt, acpi_physical_address * phys)
diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
index a885295..fec1ae3 100644
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -181,14 +181,15 @@ acpi_table_parse_entries(char *id,
 	struct acpi_subtable_header *entry;
 	unsigned int count = 0;
 	unsigned long table_end;
+	acpi_size tbl_size;
 
 	if (!handler)
 		return -EINVAL;
 
 	if (strncmp(id, ACPI_SIG_MADT, 4) == 0)
-		acpi_get_table(id, acpi_apic_instance, &table_header);
+		acpi_get_table_with_size(id, acpi_apic_instance, &table_header, &tbl_size);
 	else
-		acpi_get_table(id, 0, &table_header);
+		acpi_get_table_with_size(id, 0, &table_header, &tbl_size);
 
 	if (!table_header) {
 		printk(KERN_WARNING PREFIX "%4.4s not present\n", id);
@@ -206,8 +207,10 @@ acpi_table_parse_entries(char *id,
 	       table_end) {
 		if (entry->type == entry_id
 		    && (!max_entries || count++ < max_entries))
-			if (handler(entry, table_end))
+			if (handler(entry, table_end)) {
+				early_acpi_os_unmap_memory((char *)table_header, tbl_size);
 				return -EINVAL;
+			}
 
 		entry = (struct acpi_subtable_header *)
 		    ((unsigned long)entry + entry->length);
@@ -217,6 +220,7 @@ acpi_table_parse_entries(char *id,
 		       "%i found\n", id, entry_id, count - max_entries, count);
 	}
 
+	early_acpi_os_unmap_memory((char *)table_header, tbl_size);
 	return count;
 }
 
@@ -241,17 +245,19 @@ acpi_table_parse_madt(enum acpi_madt_type id,
 int __init acpi_table_parse(char *id, acpi_table_handler handler)
 {
 	struct acpi_table_header *table = NULL;
+	acpi_size tbl_size;
 
 	if (!handler)
 		return -EINVAL;
 
 	if (strncmp(id, ACPI_SIG_MADT, 4) == 0)
-		acpi_get_table(id, acpi_apic_instance, &table);
+		acpi_get_table_with_size(id, acpi_apic_instance, &table, &tbl_size);
 	else
-		acpi_get_table(id, 0, &table);
+		acpi_get_table_with_size(id, 0, &table, &tbl_size);
 
 	if (table) {
 		handler(table);
+		early_acpi_os_unmap_memory(table, tbl_size);
 		return 0;
 	} else
 		return 1;
@@ -265,8 +271,9 @@ int __init acpi_table_parse(char *id, acpi_table_handler handler)
 static void __init check_multiple_madt(void)
 {
 	struct acpi_table_header *table = NULL;
+	acpi_size tbl_size;
 
-	acpi_get_table(ACPI_SIG_MADT, 2, &table);
+	acpi_get_table_with_size(ACPI_SIG_MADT, 2, &table, &tbl_size);
 	if (table) {
 		printk(KERN_WARNING PREFIX
 		       "BIOS bug: multiple APIC/MADT found,"
@@ -275,6 +282,7 @@ static void __init check_multiple_madt(void)
 		       "If \"acpi_apic_instance=%d\" works better, "
 		       "notify linux-acpi@vger.kernel.org\n",
 		       acpi_apic_instance ? 0 : 2);
+		early_acpi_os_unmap_memory(table, tbl_size);
 
 	} else
 		acpi_apic_instance = 0;
diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
index a62720a..ab0b85c 100644
--- a/include/acpi/acpiosxf.h
+++ b/include/acpi/acpiosxf.h
@@ -144,6 +144,7 @@ void __iomem *acpi_os_map_memory(acpi_physical_address where,
 				acpi_size length);
 
 void acpi_os_unmap_memory(void __iomem * logical_address, acpi_size size);
+void early_acpi_os_unmap_memory(void __iomem * virt, acpi_size size);
 
 #ifdef ACPI_FUTURE_USAGE
 acpi_status
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index c8e8cf4..cc40102 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -130,6 +130,10 @@ acpi_get_table_header(acpi_string signature,
 		      struct acpi_table_header *out_table_header);
 
 acpi_status
+acpi_get_table_with_size(acpi_string signature,
+	       u32 instance, struct acpi_table_header **out_table,
+	       acpi_size *tbl_size);
+acpi_status
 acpi_get_table(acpi_string signature,
 	       u32 instance, struct acpi_table_header **out_table);
 
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 6fce2fc..d59f0fa 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -79,6 +79,7 @@ typedef int (*acpi_table_handler) (struct acpi_table_header *table);
 typedef int (*acpi_table_entry_handler) (struct acpi_subtable_header *header, const unsigned long end);
 
 char * __acpi_map_table (unsigned long phys_addr, unsigned long size);
+void __init __acpi_unmap_table(char *map, unsigned long size);
 int early_acpi_boot_init(void);
 int acpi_boot_init (void);
 int acpi_boot_table_init (void);

commit 05876f88ed9a66b26af613e222795ae790616252
Author: Jeremy Fitzhardinge <jeremy@goop.org>
Date:   Sat Feb 7 15:39:40 2009 -0800

    acpi: remove final __acpi_map_table mapping before setting acpi_gbl_permanent_mmap
    
    On x86, __acpi_map_table uses early_ioremap() to create the mapping,
    replacing the previous mapping with a new one.  Once enough of the
    kernel is up an running it switches to using normal ioremap().  At
    that point, we need to clean up the final mapping to avoid a warning
    from the early_ioremap subsystem.
    
    This can be removed after all the instances in the ACPI code are fixed
    that rely on early-ioremap's implicit overmapping of previously
    mapped tables.
    
    Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
    Acked-by: Len Brown <len.brown@intel.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 5424a18..7217834 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -124,12 +124,14 @@ char *__init __acpi_map_table(unsigned long phys, unsigned long size)
 	static char *prev_map;
 	static unsigned long prev_size;
 
+	if (prev_map) {
+		early_iounmap(prev_map, prev_size);
+		prev_map = NULL;
+	}
+
 	if (!phys || !size)
 		return NULL;
 
-	if (prev_map)
-		early_iounmap(prev_map, prev_size);
-
 	prev_size = size;
 	prev_map = early_ioremap(phys, size);
 
diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 765fd1c..fb1be7b 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -694,6 +694,12 @@ void __init acpi_early_init(void)
 	if (!acpi_strict)
 		acpi_gbl_enable_interpreter_slack = TRUE;
 
+	/*
+	 * Doing a zero-sized mapping will clear out the previous
+	 * __acpi_map_table() mapping, if any.
+	 */
+	__acpi_map_table(0, 0);
+
 	acpi_gbl_permanent_mmap = 1;
 
 	status = acpi_reallocate_root_table();

commit eecb9a697f0b790e5840dae8a8b866bea49a86ee
Author: Jeremy Fitzhardinge <jeremy@goop.org>
Date:   Sat Feb 7 15:39:38 2009 -0800

    x86: always explicitly map acpi memory
    
    Always map acpi tables, rather than assuming we can use the normal
    linear mapping to access the acpi tables.  This is necessary in a
    virtual environment where the linear mappings are to pseudo-physical
    memory, but the acpi tables exist at a real physical address.  It
    doesn't hurt to map in the normal non-virtual case, so just do it
    unconditionally.
    
    Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
    Acked-by: Len Brown <len.brown@intel.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index c518599..5424a18 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -127,9 +127,6 @@ char *__init __acpi_map_table(unsigned long phys, unsigned long size)
 	if (!phys || !size)
 		return NULL;
 
-	if (phys+size <= (max_low_pfn_mapped << PAGE_SHIFT))
-		return __va(phys);
-
 	if (prev_map)
 		early_iounmap(prev_map, prev_size);
 

commit 1c14fa4937eb73509e07ac12bf8db1fdf4c42a59
Author: Jeremy Fitzhardinge <jeremy@goop.org>
Date:   Sat Feb 7 15:39:38 2009 -0800

    x86: use early_ioremap in __acpi_map_table
    
    __acpi_map_table() effectively reimplements early_ioremap().  Rather
    than have that duplication, just implement it in terms of
    early_ioremap().
    
    However, unlike early_ioremap(), __acpi_map_table() just maintains a
    single mapping which gets replaced each call, and has no corresponding
    unmap function.  Implement this by just removing the previous mapping
    each time its called.  Unfortunately, this will leave a stray mapping
    at the end.
    
    Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 9830681..4518dc5 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -102,9 +102,6 @@ static inline void disable_acpi(void)
 	acpi_noirq = 1;
 }
 
-/* Fixmap pages to reserve for ACPI boot-time tables (see fixmap.h) */
-#define FIX_ACPI_PAGES 4
-
 extern int acpi_gsi_to_irq(u32 gsi, unsigned int *irq);
 
 static inline void acpi_noirq_set(void) { acpi_noirq = 1; }
diff --git a/arch/x86/include/asm/fixmap_32.h b/arch/x86/include/asm/fixmap_32.h
index c7115c1..047d9ba 100644
--- a/arch/x86/include/asm/fixmap_32.h
+++ b/arch/x86/include/asm/fixmap_32.h
@@ -95,10 +95,6 @@ enum fixed_addresses {
 			(__end_of_permanent_fixed_addresses & 255),
 	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_SLOTS - 1,
 	FIX_WP_TEST,
-#ifdef CONFIG_ACPI
-	FIX_ACPI_BEGIN,
-	FIX_ACPI_END = FIX_ACPI_BEGIN + FIX_ACPI_PAGES - 1,
-#endif
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
 	FIX_OHCI1394_BASE,
 #endif
diff --git a/arch/x86/include/asm/fixmap_64.h b/arch/x86/include/asm/fixmap_64.h
index 00a30ab..298d9ba 100644
--- a/arch/x86/include/asm/fixmap_64.h
+++ b/arch/x86/include/asm/fixmap_64.h
@@ -50,10 +50,6 @@ enum fixed_addresses {
 	FIX_PARAVIRT_BOOTMAP,
 #endif
 	__end_of_permanent_fixed_addresses,
-#ifdef CONFIG_ACPI
-	FIX_ACPI_BEGIN,
-	FIX_ACPI_END = FIX_ACPI_BEGIN + FIX_ACPI_PAGES - 1,
-#endif
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
 	FIX_OHCI1394_BASE,
 #endif
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index d37593c..c518599 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -121,8 +121,8 @@ enum acpi_irq_model_id acpi_irq_model = ACPI_IRQ_MODEL_PIC;
  */
 char *__init __acpi_map_table(unsigned long phys, unsigned long size)
 {
-	unsigned long base, offset, mapped_size;
-	int idx;
+	static char *prev_map;
+	static unsigned long prev_size;
 
 	if (!phys || !size)
 		return NULL;
@@ -130,26 +130,13 @@ char *__init __acpi_map_table(unsigned long phys, unsigned long size)
 	if (phys+size <= (max_low_pfn_mapped << PAGE_SHIFT))
 		return __va(phys);
 
-	offset = phys & (PAGE_SIZE - 1);
-	mapped_size = PAGE_SIZE - offset;
-	clear_fixmap(FIX_ACPI_END);
-	set_fixmap(FIX_ACPI_END, phys);
-	base = fix_to_virt(FIX_ACPI_END);
+	if (prev_map)
+		early_iounmap(prev_map, prev_size);
 
-	/*
-	 * Most cases can be covered by the below.
-	 */
-	idx = FIX_ACPI_END;
-	while (mapped_size < size) {
-		if (--idx < FIX_ACPI_BEGIN)
-			return NULL;	/* cannot handle this */
-		phys += PAGE_SIZE;
-		clear_fixmap(idx);
-		set_fixmap(idx, phys);
-		mapped_size += PAGE_SIZE;
-	}
+	prev_size = size;
+	prev_map = early_ioremap(phys, size);
 
-	return ((unsigned char *)base + offset);
+	return prev_map;
 }
 
 #ifdef CONFIG_PCI_MMCONFIG
