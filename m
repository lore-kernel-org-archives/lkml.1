Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbZLDJMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbZLDJMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 04:12:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbZLDJMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 04:12:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:46880 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755520AbZLDJMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 04:12:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,340,1257148800"; 
   d="scan'208";a="575608645"
Message-ID: <4B18D26B.4040500@intel.com>
Date: Fri, 04 Dec 2009 17:12:11 +0800
From: Shane Wang <shane.wang@intel.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Cihula, Joseph" <joseph.cihula@intel.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>, len.brown@intel.com,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm@lists.linux-foundation.org, shane.wang@intel.com
Subject: [PATCH] intel_txt: add s3 userspace memory integrity verification
Content-Type: multipart/mixed;
 boundary="------------050301070503070502000505"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050301070503070502000505
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch added verification for userspace memory integrity after S3 resume.
Integrity verification for other memory (say kernel itself) has been done by tboot.

Thanks
Shane

---
  arch/x86/kernel/entry_64.S |   20 +++
  arch/x86/kernel/tboot.c    |  226 +++++++++++++++++++++++++++++++++++
  drivers/acpi/sleep.c       |    3
  include/linux/mm.h         |    8 -
  include/linux/tboot.h      |    3
  security/Kconfig           |    2
  6 files changed, 256 insertions(+), 6 deletions(-)

Signed-off-by: Shane Wang <shane.wang@intel.com>
Signed-off-by: Joseph Cihula <joseph.cihula@intel.com>

diff -r c878d454dc8b arch/x86/kernel/entry_64.S
--- a/arch/x86/kernel/entry_64.S	Wed Dec 02 01:06:32 2009 -0800
+++ b/arch/x86/kernel/entry_64.S	Thu Dec 03 07:22:17 2009 -0800
@@ -1275,6 +1275,26 @@ ENTRY(call_softirq)
  	CFI_ENDPROC
  END(call_softirq)

+#ifdef CONFIG_INTEL_TXT
+/* void tboot_switch_stack_call(void (*target_func)(void), u64 new_rsp) */
+ENTRY(tboot_switch_stack_call)
+	CFI_STARTPROC
+	push %rbp
+	CFI_ADJUST_CFA_OFFSET	8
+	CFI_REL_OFFSET	rbp,0
+	mov %rsp, %rbp
+	CFI_DEF_CFA_REGISTER	rbp
+	mov %rsi, %rsp
+	push %rbp
+	call *%rdi
+	leaveq
+	CFI_DEF_CFA_REGISTER	rsp
+	CFI_ADJUST_CFA_OFFSET	-8
+	ret
+	CFI_ENDPROC
+END(tboot_switch_stack_call)
+#endif
+
  #ifdef CONFIG_XEN
  zeroentry xen_hypervisor_callback xen_do_hypervisor_callback

diff -r c878d454dc8b arch/x86/kernel/tboot.c
--- a/arch/x86/kernel/tboot.c	Wed Dec 02 01:06:32 2009 -0800
+++ b/arch/x86/kernel/tboot.c	Thu Dec 03 07:22:17 2009 -0800
@@ -20,6 +20,7 @@
   */

  #include <linux/dma_remapping.h>
+#include <linux/scatterlist.h>
  #include <linux/init_task.h>
  #include <linux/spinlock.h>
  #include <linux/delay.h>
@@ -30,12 +31,17 @@
  #include <linux/pfn.h>
  #include <linux/mm.h>
  #include <linux/tboot.h>
+#include <linux/random.h>
+
+#include <crypto/vmac.h>
+#include <crypto/hash.h>

  #include <asm/trampoline.h>
  #include <asm/processor.h>
  #include <asm/bootparam.h>
  #include <asm/pgtable.h>
  #include <asm/pgalloc.h>
+#include <asm/percpu.h>
  #include <asm/fixmap.h>
  #include <asm/proto.h>
  #include <asm/setup.h>
@@ -168,6 +174,159 @@ static void tboot_create_trampoline(void
  		      map_base, map_size);
  }

+#ifdef CONFIG_X86_64
+static char *new_stack, *new_stack_ptr;
+
+static int tboot_pre_stack_switch(void)
+{
+	BUG_ON((new_stack != NULL) || (new_stack_ptr != NULL));
+
+	/*
+	 * as long as thread info is above 4G, then switch stack,
+	 * since tboot can't access >4G stack for MACing
+	 */
+	if (!((PFN_PHYS(PFN_DOWN(virt_to_phys(current_thread_info())))
+		+ (PFN_UP(THREAD_SIZE) << PAGE_SHIFT))
+		& 0xffffffff00000000UL))
+		return -1;
+
+	new_stack = (char *)__get_free_pages(GFP_DMA32, IRQ_STACK_ORDER);
+
+	BUG_ON(new_stack == NULL);
+	memset(new_stack, 0, IRQ_STACK_SIZE);
+	new_stack_ptr = new_stack + IRQ_STACK_SIZE - 64;
+
+	return 0;
+}
+
+static void tboot_post_stack_switch(void)
+{
+	BUG_ON((new_stack == NULL) || (new_stack_ptr == NULL));
+
+	free_pages((unsigned long)new_stack, IRQ_STACK_ORDER);
+	new_stack = NULL;
+	new_stack_ptr = NULL;
+}
+
+extern void tboot_switch_stack_call(void (*target_func)(void), u64 new_rsp);
+
+#else /* CONFIG_X86_32 */
+
+#define tboot_pre_stack_switch()			(-1)
+#define tboot_post_stack_switch()			do { } while (0)
+#define tboot_switch_stack_call(target_func, new_rsp)	do { } while (0)
+
+#endif
+
+static vmac_t mem_mac;
+static struct crypto_hash *tfm;
+
+static int tboot_gen_mem_integrity(const uint8_t key[], vmac_t *mac)
+{
+	int i, j, ret;
+	pg_data_t *pgdat;
+	struct hash_desc desc;
+	struct scatterlist sg[1];
+	struct page *page;
+	uint64_t paddr, rstart, rend;
+	unsigned long pfn;
+	uint8_t zeroed_key[VMAC_KEY_LEN];
+
+	if (!tfm)
+		tfm = crypto_alloc_hash("vmac(aes)", 0, CRYPTO_ALG_ASYNC);
+
+	if (IS_ERR(tfm)) {
+		tfm = NULL;
+		return -ENOMEM;
+	}
+
+	desc.tfm = tfm;
+	desc.flags = 0;
+
+	sg_init_table(sg, 1);
+
+	ret = crypto_hash_init(&desc);
+	if (ret)
+		return ret;
+	ret = crypto_hash_setkey(desc.tfm, key, VMAC_KEY_LEN);
+	if (ret)
+		return ret;
+
+	for_each_online_pgdat(pgdat) {
+		unsigned long flags;
+
+		pgdat_resize_lock(pgdat, &flags);
+		for (i = 0, pfn = pgdat->node_start_pfn;
+			i < pgdat->node_spanned_pages;
+			i++, pfn = pgdat->node_start_pfn + i) {
+
+			if (!pfn_valid(pfn) || !page_is_ram(pfn))
+				continue;
+
+			page = pfn_to_page(pfn);
+			paddr = page_to_phys(page);
+
+			/* If pg will be MACed by tboot, no need to MAC here */
+			for (j = 0; j < tboot->num_mac_regions; j++) {
+				rstart = tboot->mac_regions[j].start;
+				rend = rstart +	tboot->mac_regions[j].size;
+				if (((paddr + PAGE_SIZE) <= rstart)
+					|| (rend <= paddr))
+					continue;
+				break;
+			}
+
+			if (j == tboot->num_mac_regions) {
+				sg_set_page(sg, page, PAGE_SIZE, 0);
+#ifdef CONFIG_DEBUG_PAGEALLOC
+			/*
+			 * check if the page we are going to MAC is marked as
+			 * present in the kernel page tables.
+			 */
+			if (!kernel_page_present(page)) {
+				kernel_map_pages(page, 1, 1);
+				ret = crypto_hash_update(&desc, sg, PAGE_SIZE);
+				kernel_map_pages(page, 1, 0);
+			} else
+#endif
+				ret = crypto_hash_update(&desc, sg, PAGE_SIZE);
+				if (ret) {
+					pgdat_resize_unlock(pgdat, &flags);
+					return ret;
+				}
+			}
+		}
+		pgdat_resize_unlock(pgdat, &flags);
+	}
+
+#ifdef CONFIG_X86_64
+	/*
+	 * for stack > 4G, we should MAC the stack in the kernel after switch,
+	 * for stack < 4G, the stack is MACed by tboot
+	 */
+	if (new_stack) {
+		for (i = 0, page = virt_to_page((void *)current_thread_info());
+			i < (1 << THREAD_ORDER);
+			i++, page++) {
+			sg_set_page(sg, page, PAGE_SIZE, 0);
+			ret = crypto_hash_update(&desc, sg, PAGE_SIZE);
+			if (ret)
+				return ret;
+		}
+	}
+#endif
+
+	ret = crypto_hash_final(&desc, (uint8_t *)mac);
+	if (ret)
+		return ret;
+
+	/* Clean the key */
+	memset(zeroed_key, 0, sizeof(zeroed_key));
+	crypto_hash_setkey(desc.tfm, zeroed_key, VMAC_KEY_LEN);
+
+	return 0;
+}
+
  #ifdef CONFIG_ACPI_SLEEP

  static void add_mac_region(phys_addr_t start, unsigned long size)
@@ -196,6 +355,27 @@ static int tboot_setup_sleep(void)

  	/* kernel code + data + bss */
  	add_mac_region(virt_to_phys(_text), _end - _text);
+
+	/* stack */
+#ifdef CONFIG_X86_64
+	/*
+	 * if stack > 4G, we should MAC the stack in the kernel after switch,
+	 * if stack < 4G, the stack is MACed by tboot
+	 */
+	if (new_stack)
+		add_mac_region(virt_to_phys(new_stack),
+				IRQ_STACK_SIZE); /* > 4G */
+	else
+#endif
+		add_mac_region(virt_to_phys(current_thread_info()),
+				THREAD_SIZE); /* < 4G */
+
+	/* MAC userspace memory not handled by tboot */
+	get_random_bytes(tboot->s3_key, sizeof(tboot->s3_key));
+	if (tboot_gen_mem_integrity(tboot->s3_key, &mem_mac)) {
+		panic("tboot: vmac generation failed\n");
+		return -1;
+	}

  	tboot->acpi_sinfo.kernel_s3_resume_vector = acpi_wakeup_address;

@@ -292,6 +472,52 @@ void tboot_sleep(u8 sleep_state, u32 pm1
  	}

  	tboot_shutdown(acpi_shutdown_map[sleep_state]);
+}
+
+static void tboot_sx_resume(void)
+{
+	vmac_t mac;
+
+	if (tboot_gen_mem_integrity(tboot->s3_key, &mac))
+		panic("tboot: vmac generation failed\n");
+	else if (mac != mem_mac)
+#ifdef CONFIG_DEBUG_KERNEL
+		pr_debug("tboot: memory integrity %llx -> %llx\n",
+				mem_mac, mac);
+#else
+		panic("tboot: memory integrity was lost on resume\n");
+#endif
+	else
+		pr_info("memory integrity OK\n");
+
+	/* Clean s3_key */
+	memset(tboot->s3_key, 0, sizeof(tboot->s3_key));
+}
+
+extern void do_suspend_lowlevel(void);
+
+static void tboot_do_suspend_lowlevel_call(void)
+{
+	do_suspend_lowlevel();
+	tboot_sx_resume();
+}
+
+void tboot_do_suspend_lowlevel(void)
+{
+	int ret = -1;
+
+	if (!tboot_enabled()) {
+		do_suspend_lowlevel();
+		return;
+	}
+
+	ret = tboot_pre_stack_switch();
+	if (!ret) {
+		tboot_switch_stack_call(tboot_do_suspend_lowlevel_call,
+					(u64)new_stack_ptr);
+		tboot_post_stack_switch();
+	} else
+		tboot_do_suspend_lowlevel_call();
  }

  static atomic_t ap_wfs_count;
diff -r c878d454dc8b drivers/acpi/sleep.c
--- a/drivers/acpi/sleep.c	Wed Dec 02 01:06:32 2009 -0800
+++ b/drivers/acpi/sleep.c	Thu Dec 03 07:22:17 2009 -0800
@@ -16,6 +16,7 @@
  #include <linux/device.h>
  #include <linux/suspend.h>
  #include <linux/reboot.h>
+#include <linux/tboot.h>

  #include <asm/io.h>

@@ -244,7 +245,7 @@ static int acpi_suspend_enter(suspend_st
  		break;

  	case ACPI_STATE_S3:
-		do_suspend_lowlevel();
+		tboot_do_suspend_lowlevel();
  		break;
  	}

diff -r c878d454dc8b include/linux/mm.h
--- a/include/linux/mm.h	Wed Dec 02 01:06:32 2009 -0800
+++ b/include/linux/mm.h	Thu Dec 03 07:22:17 2009 -0800
@@ -1263,18 +1263,18 @@ static inline void enable_debug_pageallo
  {
  	debug_pagealloc_enabled = 1;
  }
-#ifdef CONFIG_HIBERNATION
+#if defined(CONFIG_HIBERNATION) || defined(CONFIG_INTEL_TXT)
  extern bool kernel_page_present(struct page *page);
-#endif /* CONFIG_HIBERNATION */
+#endif /* CONFIG_HIBERNATION || CONFIG_INTEL_TXT */
  #else
  static inline void
  kernel_map_pages(struct page *page, int numpages, int enable) {}
  static inline void enable_debug_pagealloc(void)
  {
  }
-#ifdef CONFIG_HIBERNATION
+#if defined(CONFIG_HIBERNATION) || defined(CONFIG_INTEL_TXT)
  static inline bool kernel_page_present(struct page *page) { return true; }
-#endif /* CONFIG_HIBERNATION */
+#endif /* CONFIG_HIBERNATION || CONFIG_INTEL_TXT */
  #endif

  extern struct vm_area_struct *get_gate_vma(struct task_struct *tsk);
diff -r c878d454dc8b include/linux/tboot.h
--- a/include/linux/tboot.h	Wed Dec 02 01:06:32 2009 -0800
+++ b/include/linux/tboot.h	Thu Dec 03 07:22:17 2009 -0800
@@ -147,7 +147,7 @@ extern struct acpi_table_header *tboot_g
  extern struct acpi_table_header *tboot_get_dmar_table(
  				      struct acpi_table_header *dmar_tbl);
  extern int tboot_force_iommu(void);
-
+extern void tboot_do_suspend_lowlevel(void);
  #else

  #define tboot_probe()			do { } while (0)
@@ -156,6 +156,7 @@ extern int tboot_force_iommu(void);
  					do { } while (0)
  #define tboot_get_dmar_table(dmar_tbl)	(dmar_tbl)
  #define tboot_force_iommu()		0
+#define tboot_do_suspend_lowlevel()	do_suspend_lowlevel()

  #endif /* !CONFIG_INTEL_TXT */

diff -r c878d454dc8b security/Kconfig
--- a/security/Kconfig	Wed Dec 02 01:06:32 2009 -0800
+++ b/security/Kconfig	Thu Dec 03 07:22:17 2009 -0800
@@ -116,6 +116,8 @@ config INTEL_TXT
  config INTEL_TXT
  	bool "Enable Intel(R) Trusted Execution Technology (Intel(R) TXT)"
  	depends on HAVE_INTEL_TXT
+	select CRYPTO_VMAC
+	select CRYPTO_AES
  	help
  	  This option enables support for booting the kernel with the
  	  Trusted Boot (tboot) module. This will utilize

--------------050301070503070502000505
Content-Type: text/plain;
 name="s3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="s3.patch"

This patch added verification for userspace memory integrity after S3 resume.
Integrity verification for other memory (say kernel itself) has been done by tboot.

Signed-off-by: Shane Wang <shane.wang@intel.com>
Signed-off-by: Joseph Cihula <joseph.cihula@intel.com>

diff -r c878d454dc8b arch/x86/kernel/entry_64.S
--- a/arch/x86/kernel/entry_64.S	Wed Dec 02 01:06:32 2009 -0800
+++ b/arch/x86/kernel/entry_64.S	Thu Dec 03 07:22:17 2009 -0800
@@ -1275,6 +1275,26 @@ ENTRY(call_softirq)
 	CFI_ENDPROC
 END(call_softirq)
 
+#ifdef CONFIG_INTEL_TXT
+/* void tboot_switch_stack_call(void (*target_func)(void), u64 new_rsp) */
+ENTRY(tboot_switch_stack_call)
+	CFI_STARTPROC
+	push %rbp
+	CFI_ADJUST_CFA_OFFSET	8
+	CFI_REL_OFFSET	rbp,0
+	mov %rsp, %rbp
+	CFI_DEF_CFA_REGISTER	rbp
+	mov %rsi, %rsp
+	push %rbp
+	call *%rdi
+	leaveq
+	CFI_DEF_CFA_REGISTER	rsp
+	CFI_ADJUST_CFA_OFFSET	-8
+	ret
+	CFI_ENDPROC
+END(tboot_switch_stack_call)
+#endif
+
 #ifdef CONFIG_XEN
 zeroentry xen_hypervisor_callback xen_do_hypervisor_callback
 
diff -r c878d454dc8b arch/x86/kernel/tboot.c
--- a/arch/x86/kernel/tboot.c	Wed Dec 02 01:06:32 2009 -0800
+++ b/arch/x86/kernel/tboot.c	Thu Dec 03 07:22:17 2009 -0800
@@ -20,6 +20,7 @@
  */
 
 #include <linux/dma_remapping.h>
+#include <linux/scatterlist.h>
 #include <linux/init_task.h>
 #include <linux/spinlock.h>
 #include <linux/delay.h>
@@ -30,12 +31,17 @@
 #include <linux/pfn.h>
 #include <linux/mm.h>
 #include <linux/tboot.h>
+#include <linux/random.h>
+
+#include <crypto/vmac.h>
+#include <crypto/hash.h>
 
 #include <asm/trampoline.h>
 #include <asm/processor.h>
 #include <asm/bootparam.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
+#include <asm/percpu.h>
 #include <asm/fixmap.h>
 #include <asm/proto.h>
 #include <asm/setup.h>
@@ -168,6 +174,159 @@ static void tboot_create_trampoline(void
 		      map_base, map_size);
 }
 
+#ifdef CONFIG_X86_64
+static char *new_stack, *new_stack_ptr;
+
+static int tboot_pre_stack_switch(void)
+{
+	BUG_ON((new_stack != NULL) || (new_stack_ptr != NULL));
+
+	/*
+	 * as long as thread info is above 4G, then switch stack,
+	 * since tboot can't access >4G stack for MACing
+	 */
+	if (!((PFN_PHYS(PFN_DOWN(virt_to_phys(current_thread_info())))
+		+ (PFN_UP(THREAD_SIZE) << PAGE_SHIFT))
+		& 0xffffffff00000000UL))
+		return -1;
+
+	new_stack = (char *)__get_free_pages(GFP_DMA32, IRQ_STACK_ORDER);
+
+	BUG_ON(new_stack == NULL);
+	memset(new_stack, 0, IRQ_STACK_SIZE);
+	new_stack_ptr = new_stack + IRQ_STACK_SIZE - 64;
+
+	return 0;
+}
+
+static void tboot_post_stack_switch(void)
+{
+	BUG_ON((new_stack == NULL) || (new_stack_ptr == NULL));
+
+	free_pages((unsigned long)new_stack, IRQ_STACK_ORDER);
+	new_stack = NULL;
+	new_stack_ptr = NULL;
+}
+
+extern void tboot_switch_stack_call(void (*target_func)(void), u64 new_rsp);
+
+#else /* CONFIG_X86_32 */
+
+#define tboot_pre_stack_switch()			(-1)
+#define tboot_post_stack_switch()			do { } while (0)
+#define tboot_switch_stack_call(target_func, new_rsp)	do { } while (0)
+
+#endif
+
+static vmac_t mem_mac;
+static struct crypto_hash *tfm;
+
+static int tboot_gen_mem_integrity(const uint8_t key[], vmac_t *mac)
+{
+	int i, j, ret;
+	pg_data_t *pgdat;
+	struct hash_desc desc;
+	struct scatterlist sg[1];
+	struct page *page;
+	uint64_t paddr, rstart, rend;
+	unsigned long pfn;
+	uint8_t zeroed_key[VMAC_KEY_LEN];
+
+	if (!tfm)
+		tfm = crypto_alloc_hash("vmac(aes)", 0, CRYPTO_ALG_ASYNC);
+
+	if (IS_ERR(tfm)) {
+		tfm = NULL;
+		return -ENOMEM;
+	}
+
+	desc.tfm = tfm;
+	desc.flags = 0;
+
+	sg_init_table(sg, 1);
+
+	ret = crypto_hash_init(&desc);
+	if (ret)
+		return ret;
+	ret = crypto_hash_setkey(desc.tfm, key, VMAC_KEY_LEN);
+	if (ret)
+		return ret;
+
+	for_each_online_pgdat(pgdat) {
+		unsigned long flags;
+
+		pgdat_resize_lock(pgdat, &flags);
+		for (i = 0, pfn = pgdat->node_start_pfn;
+			i < pgdat->node_spanned_pages;
+			i++, pfn = pgdat->node_start_pfn + i) {
+
+			if (!pfn_valid(pfn) || !page_is_ram(pfn))
+				continue;
+
+			page = pfn_to_page(pfn);
+			paddr = page_to_phys(page);
+
+			/* If pg will be MACed by tboot, no need to MAC here */
+			for (j = 0; j < tboot->num_mac_regions; j++) {
+				rstart = tboot->mac_regions[j].start;
+				rend = rstart +	tboot->mac_regions[j].size;
+				if (((paddr + PAGE_SIZE) <= rstart)
+					|| (rend <= paddr))
+					continue;
+				break;
+			}
+
+			if (j == tboot->num_mac_regions) {
+				sg_set_page(sg, page, PAGE_SIZE, 0);
+#ifdef CONFIG_DEBUG_PAGEALLOC
+			/*
+			 * check if the page we are going to MAC is marked as
+			 * present in the kernel page tables.
+			 */
+			if (!kernel_page_present(page)) {
+				kernel_map_pages(page, 1, 1);
+				ret = crypto_hash_update(&desc, sg, PAGE_SIZE);
+				kernel_map_pages(page, 1, 0);
+			} else
+#endif
+				ret = crypto_hash_update(&desc, sg, PAGE_SIZE);
+				if (ret) {
+					pgdat_resize_unlock(pgdat, &flags);
+					return ret;
+				}
+			}
+		}
+		pgdat_resize_unlock(pgdat, &flags);
+	}
+
+#ifdef CONFIG_X86_64
+	/*
+	 * for stack > 4G, we should MAC the stack in the kernel after switch,
+	 * for stack < 4G, the stack is MACed by tboot
+	 */
+	if (new_stack) {
+		for (i = 0, page = virt_to_page((void *)current_thread_info());
+			i < (1 << THREAD_ORDER);
+			i++, page++) {
+			sg_set_page(sg, page, PAGE_SIZE, 0);
+			ret = crypto_hash_update(&desc, sg, PAGE_SIZE);
+			if (ret)
+				return ret;
+		}
+	}
+#endif
+
+	ret = crypto_hash_final(&desc, (uint8_t *)mac);
+	if (ret)
+		return ret;
+
+	/* Clean the key */
+	memset(zeroed_key, 0, sizeof(zeroed_key));
+	crypto_hash_setkey(desc.tfm, zeroed_key, VMAC_KEY_LEN);
+
+	return 0;
+}
+
 #ifdef CONFIG_ACPI_SLEEP
 
 static void add_mac_region(phys_addr_t start, unsigned long size)
@@ -196,6 +355,27 @@ static int tboot_setup_sleep(void)
 
 	/* kernel code + data + bss */
 	add_mac_region(virt_to_phys(_text), _end - _text);
+
+	/* stack */
+#ifdef CONFIG_X86_64
+	/*
+	 * if stack > 4G, we should MAC the stack in the kernel after switch,
+	 * if stack < 4G, the stack is MACed by tboot
+	 */
+	if (new_stack)
+		add_mac_region(virt_to_phys(new_stack),
+				IRQ_STACK_SIZE); /* > 4G */
+	else
+#endif
+		add_mac_region(virt_to_phys(current_thread_info()),
+				THREAD_SIZE); /* < 4G */
+
+	/* MAC userspace memory not handled by tboot */
+	get_random_bytes(tboot->s3_key, sizeof(tboot->s3_key));
+	if (tboot_gen_mem_integrity(tboot->s3_key, &mem_mac)) {
+		panic("tboot: vmac generation failed\n");
+		return -1;
+	}
 
 	tboot->acpi_sinfo.kernel_s3_resume_vector = acpi_wakeup_address;
 
@@ -292,6 +472,52 @@ void tboot_sleep(u8 sleep_state, u32 pm1
 	}
 
 	tboot_shutdown(acpi_shutdown_map[sleep_state]);
+}
+
+static void tboot_sx_resume(void)
+{
+	vmac_t mac;
+
+	if (tboot_gen_mem_integrity(tboot->s3_key, &mac))
+		panic("tboot: vmac generation failed\n");
+	else if (mac != mem_mac)
+#ifdef CONFIG_DEBUG_KERNEL
+		pr_debug("tboot: memory integrity %llx -> %llx\n",
+				mem_mac, mac);
+#else
+		panic("tboot: memory integrity was lost on resume\n");
+#endif
+	else
+		pr_info("memory integrity OK\n");
+
+	/* Clean s3_key */
+	memset(tboot->s3_key, 0, sizeof(tboot->s3_key));
+}
+
+extern void do_suspend_lowlevel(void);
+
+static void tboot_do_suspend_lowlevel_call(void)
+{
+	do_suspend_lowlevel();
+	tboot_sx_resume();
+}
+
+void tboot_do_suspend_lowlevel(void)
+{
+	int ret = -1;
+
+	if (!tboot_enabled()) {
+		do_suspend_lowlevel();
+		return;
+	}
+
+	ret = tboot_pre_stack_switch();
+	if (!ret) {
+		tboot_switch_stack_call(tboot_do_suspend_lowlevel_call,
+					(u64)new_stack_ptr);
+		tboot_post_stack_switch();
+	} else
+		tboot_do_suspend_lowlevel_call();
 }
 
 static atomic_t ap_wfs_count;
diff -r c878d454dc8b drivers/acpi/sleep.c
--- a/drivers/acpi/sleep.c	Wed Dec 02 01:06:32 2009 -0800
+++ b/drivers/acpi/sleep.c	Thu Dec 03 07:22:17 2009 -0800
@@ -16,6 +16,7 @@
 #include <linux/device.h>
 #include <linux/suspend.h>
 #include <linux/reboot.h>
+#include <linux/tboot.h>
 
 #include <asm/io.h>
 
@@ -244,7 +245,7 @@ static int acpi_suspend_enter(suspend_st
 		break;
 
 	case ACPI_STATE_S3:
-		do_suspend_lowlevel();
+		tboot_do_suspend_lowlevel();
 		break;
 	}
 
diff -r c878d454dc8b include/linux/mm.h
--- a/include/linux/mm.h	Wed Dec 02 01:06:32 2009 -0800
+++ b/include/linux/mm.h	Thu Dec 03 07:22:17 2009 -0800
@@ -1263,18 +1263,18 @@ static inline void enable_debug_pageallo
 {
 	debug_pagealloc_enabled = 1;
 }
-#ifdef CONFIG_HIBERNATION
+#if defined(CONFIG_HIBERNATION) || defined(CONFIG_INTEL_TXT)
 extern bool kernel_page_present(struct page *page);
-#endif /* CONFIG_HIBERNATION */
+#endif /* CONFIG_HIBERNATION || CONFIG_INTEL_TXT */
 #else
 static inline void
 kernel_map_pages(struct page *page, int numpages, int enable) {}
 static inline void enable_debug_pagealloc(void)
 {
 }
-#ifdef CONFIG_HIBERNATION
+#if defined(CONFIG_HIBERNATION) || defined(CONFIG_INTEL_TXT)
 static inline bool kernel_page_present(struct page *page) { return true; }
-#endif /* CONFIG_HIBERNATION */
+#endif /* CONFIG_HIBERNATION || CONFIG_INTEL_TXT */
 #endif
 
 extern struct vm_area_struct *get_gate_vma(struct task_struct *tsk);
diff -r c878d454dc8b include/linux/tboot.h
--- a/include/linux/tboot.h	Wed Dec 02 01:06:32 2009 -0800
+++ b/include/linux/tboot.h	Thu Dec 03 07:22:17 2009 -0800
@@ -147,7 +147,7 @@ extern struct acpi_table_header *tboot_g
 extern struct acpi_table_header *tboot_get_dmar_table(
 				      struct acpi_table_header *dmar_tbl);
 extern int tboot_force_iommu(void);
-
+extern void tboot_do_suspend_lowlevel(void);
 #else
 
 #define tboot_probe()			do { } while (0)
@@ -156,6 +156,7 @@ extern int tboot_force_iommu(void);
 					do { } while (0)
 #define tboot_get_dmar_table(dmar_tbl)	(dmar_tbl)
 #define tboot_force_iommu()		0
+#define tboot_do_suspend_lowlevel()	do_suspend_lowlevel()
 
 #endif /* !CONFIG_INTEL_TXT */
 
diff -r c878d454dc8b security/Kconfig
--- a/security/Kconfig	Wed Dec 02 01:06:32 2009 -0800
+++ b/security/Kconfig	Thu Dec 03 07:22:17 2009 -0800
@@ -116,6 +116,8 @@ config INTEL_TXT
 config INTEL_TXT
 	bool "Enable Intel(R) Trusted Execution Technology (Intel(R) TXT)"
 	depends on HAVE_INTEL_TXT
+	select CRYPTO_VMAC
+	select CRYPTO_AES
 	help
 	  This option enables support for booting the kernel with the
 	  Trusted Boot (tboot) module. This will utilize

--------------050301070503070502000505--
