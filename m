Return-Path: <linux-kernel-owner+w=401wt.eu-S1753600AbZI0JHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbZI0JHa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 05:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbZI0JHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 05:07:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:13827 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753407AbZI0JH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 05:07:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,460,1249282800"; 
   d="scan'208";a="554131815"
Message-ID: <4ABF2B50.6070106@intel.com>
Date: Sun, 27 Sep 2009 17:07:28 +0800
From: Shane Wang <shane.wang@intel.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Cihula, Joseph" <joseph.cihula@intel.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>
Subject: [PATCH] intel_txt: add s3 userspace memory integrity verification
References: <4A9CE0B2.5060608@intel.com>
In-Reply-To: <4A9CE0B2.5060608@intel.com>
Content-Type: multipart/mixed;
 boundary="------------030900080801030005090000"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030900080801030005090000
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch added verification for userspace memory integrity after s3 resume.
Integrity verification for other memory (say kernel itself) has been done by tboot.

Thanks for your comments.
Shane

---
  arch/x86/kernel/tboot.c |  170 ++++++++++++++++++++++++++++++++++++++
  drivers/acpi/sleep.c    |    4
  include/linux/tboot.h   |    7 +
  security/Kconfig        |    2
  4 files changed, 182 insertions(+), 1 deletion(-)


Signed-off-by: Shane Wang <shane.wang@intel.com>
Signed-off-by: Joseph Cihula <joseph.cihula@intel.com>

diff -r 42870e183bd5 arch/x86/kernel/tboot.c
--- a/arch/x86/kernel/tboot.c	Fri Sep 25 06:06:39 2009 -0400
+++ b/arch/x86/kernel/tboot.c	Fri Sep 25 11:03:04 2009 -0400
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
@@ -168,6 +174,80 @@ static void tboot_create_trampoline(void
  		      map_base, map_size);
  }

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
+				ret = crypto_hash_update(&desc, sg, PAGE_SIZE);
+				if (ret)
+					return ret;
+			}
+		}
+	}
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
@@ -197,6 +277,16 @@ static int tboot_setup_sleep(void)
  	/* kernel code + data + bss */
  	add_mac_region(virt_to_phys(_text), _end - _text);

+	/* stack */
+	add_mac_region(virt_to_phys(current_thread_info()), THREAD_SIZE);
+
+	/* MAC userspace memory not handled by tboot */
+	get_random_bytes(tboot->s3_key, sizeof(tboot->s3_key));
+	if (tboot_gen_mem_integrity(tboot->s3_key, &mem_mac)) {
+		panic("tboot: vmac generation failed\n");
+		return -1;
+	}
+
  	tboot->acpi_sinfo.kernel_s3_resume_vector = acpi_wakeup_address;

  	return 0;
@@ -212,6 +302,68 @@ static int tboot_setup_sleep(void)
  }

  #endif
+
+static struct thread_info *low_ti, *current_ti;
+
+static void tboot_do_stack_switch(struct thread_info *new_ti,
+				struct thread_info *old_ti)
+{
+	memcpy(new_ti, old_ti, THREAD_SIZE);
+#ifdef CONFIG_X86_32
+	asm volatile (
+		" and %0, %%esp;        "
+		" add %1, %%esp;        "
+		: : "i" (THREAD_SIZE - 1), "r" (new_ti));
+#else
+	asm volatile (
+		" and %0, %%rsp;        "
+		" add %1, %%rsp;        "
+		: : "i" (THREAD_SIZE - 1), "r" (new_ti));
+	percpu_write(kernel_stack, (unsigned long)new_ti -
+				KERNEL_STACK_OFFSET + THREAD_SIZE);
+#endif
+	current->stack = new_ti;
+}
+
+void tboot_switch_stack(void)
+{
+	if (!tboot_enabled())
+		return;
+
+	current_ti = current_thread_info();
+
+	/* If thread info is above 4G, then switch stack */
+	if (!((PFN_PHYS(PFN_DOWN(virt_to_phys(current_ti)))
+		+ (PFN_UP(THREAD_SIZE) << PAGE_SHIFT))
+		& 0xffffffff00000000ULL))
+		return;
+
+	if (low_ti == NULL)
+		low_ti = (struct thread_info *)
+				__get_free_pages(GFP_DMA32, THREAD_ORDER);
+
+	tboot_do_stack_switch(low_ti, current_ti);
+}
+
+void tboot_restore_stack(void)
+{
+	if (!tboot_enabled())
+		return;
+
+	if (current_ti == NULL)
+		BUG();
+
+	/* If thread info is above 4G, then restore stack */
+	if (!((PFN_PHYS(PFN_DOWN(virt_to_phys(current_ti)))
+		+ (PFN_UP(THREAD_SIZE) << PAGE_SHIFT))
+		& 0xffffffff00000000ULL))
+		return;
+
+	if (low_ti == NULL)
+		BUG();
+
+	tboot_do_stack_switch(current_ti, low_ti);
+}

  void tboot_shutdown(u32 shutdown_type)
  {
@@ -292,6 +444,24 @@ void tboot_sleep(u8 sleep_state, u32 pm1
  	}

  	tboot_shutdown(acpi_shutdown_map[sleep_state]);
+}
+
+void tboot_sx_resume(void)
+{
+	vmac_t mac;
+
+	if (!tboot_enabled())
+		return;
+
+	if (tboot_gen_mem_integrity(tboot->s3_key, &mac))
+		panic("tboot: vmac generation failed\n");
+	else if (mac != mem_mac)
+		panic("tboot: memory integrity was lost on resume\n");
+	else
+		pr_info("memory integrity OK\n");
+
+	/* Clean s3_key */
+	memset(tboot->s3_key, 0, sizeof(tboot->s3_key));
  }

  static atomic_t ap_wfs_count;
diff -r 42870e183bd5 drivers/acpi/sleep.c
--- a/drivers/acpi/sleep.c	Fri Sep 25 06:06:39 2009 -0400
+++ b/drivers/acpi/sleep.c	Fri Sep 25 11:03:04 2009 -0400
@@ -16,6 +16,7 @@
  #include <linux/device.h>
  #include <linux/suspend.h>
  #include <linux/reboot.h>
+#include <linux/tboot.h>

  #include <asm/io.h>

@@ -244,7 +245,10 @@ static int acpi_suspend_enter(suspend_st
  		break;

  	case ACPI_STATE_S3:
+		tboot_switch_stack();
  		do_suspend_lowlevel();
+		tboot_sx_resume();
+		tboot_restore_stack();
  		break;
  	}

diff -r 42870e183bd5 include/linux/tboot.h
--- a/include/linux/tboot.h	Fri Sep 25 06:06:39 2009 -0400
+++ b/include/linux/tboot.h	Fri Sep 25 11:03:04 2009 -0400
@@ -147,7 +147,9 @@ extern struct acpi_table_header *tboot_g
  extern struct acpi_table_header *tboot_get_dmar_table(
  				      struct acpi_table_header *dmar_tbl);
  extern int tboot_force_iommu(void);
-
+extern void tboot_sx_resume(void);
+extern void tboot_switch_stack(void);
+extern void tboot_restore_stack(void);
  #else

  #define tboot_probe()			do { } while (0)
@@ -156,6 +158,9 @@ extern int tboot_force_iommu(void);
  					do { } while (0)
  #define tboot_get_dmar_table(dmar_tbl)	(dmar_tbl)
  #define tboot_force_iommu()		0
+#define tboot_sx_resume()		do { } while (0)
+#define tboot_switch_stack()		do { } while (0)
+#define tboot_restore_stack()		do { } while (0)

  #endif /* !CONFIG_INTEL_TXT */

diff -r 42870e183bd5 security/Kconfig
--- a/security/Kconfig	Fri Sep 25 06:06:39 2009 -0400
+++ b/security/Kconfig	Fri Sep 25 11:03:04 2009 -0400
@@ -116,6 +116,8 @@ config INTEL_TXT
  config INTEL_TXT
  	bool "Enable Intel(R) Trusted Execution Technology (Intel(R) TXT)"
  	depends on HAVE_INTEL_TXT
+	select CRYPTO_VMAC
+	select CRYPTO_AES
  	help
  	  This option enables support for booting the kernel with the
  	  Trusted Boot (tboot) module. This will utilize

--------------030900080801030005090000
Content-Type: text/plain;
 name="s3_integrity.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="s3_integrity.patch"

This patch added verification for userspace memory integrity after s3 resume.
Integrity verification for other memory (say kernel itself) has been done by tboot.

Signed-off-by: Shane Wang <shane.wang@intel.com>
Signed-off-by: Joseph Cihula <joseph.cihula@intel.com>

diff -r 42870e183bd5 arch/x86/kernel/tboot.c
--- a/arch/x86/kernel/tboot.c	Fri Sep 25 06:06:39 2009 -0400
+++ b/arch/x86/kernel/tboot.c	Fri Sep 25 11:03:04 2009 -0400
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
@@ -168,6 +174,80 @@ static void tboot_create_trampoline(void
 		      map_base, map_size);
 }
 
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
+				ret = crypto_hash_update(&desc, sg, PAGE_SIZE);
+				if (ret)
+					return ret;
+			}
+		}
+	}
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
@@ -197,6 +277,16 @@ static int tboot_setup_sleep(void)
 	/* kernel code + data + bss */
 	add_mac_region(virt_to_phys(_text), _end - _text);
 
+	/* stack */
+	add_mac_region(virt_to_phys(current_thread_info()), THREAD_SIZE);
+
+	/* MAC userspace memory not handled by tboot */
+	get_random_bytes(tboot->s3_key, sizeof(tboot->s3_key));
+	if (tboot_gen_mem_integrity(tboot->s3_key, &mem_mac)) {
+		panic("tboot: vmac generation failed\n");
+		return -1;
+	}
+
 	tboot->acpi_sinfo.kernel_s3_resume_vector = acpi_wakeup_address;
 
 	return 0;
@@ -212,6 +302,68 @@ static int tboot_setup_sleep(void)
 }
 
 #endif
+
+static struct thread_info *low_ti, *current_ti;
+
+static void tboot_do_stack_switch(struct thread_info *new_ti,
+				struct thread_info *old_ti)
+{
+	memcpy(new_ti, old_ti, THREAD_SIZE);
+#ifdef CONFIG_X86_32
+	asm volatile (
+		" and %0, %%esp;        "
+		" add %1, %%esp;        "
+		: : "i" (THREAD_SIZE - 1), "r" (new_ti));
+#else
+	asm volatile (
+		" and %0, %%rsp;        "
+		" add %1, %%rsp;        "
+		: : "i" (THREAD_SIZE - 1), "r" (new_ti));
+	percpu_write(kernel_stack, (unsigned long)new_ti -
+				KERNEL_STACK_OFFSET + THREAD_SIZE);
+#endif
+	current->stack = new_ti;
+}
+
+void tboot_switch_stack(void)
+{
+	if (!tboot_enabled())
+		return;
+
+	current_ti = current_thread_info();
+
+	/* If thread info is above 4G, then switch stack */
+	if (!((PFN_PHYS(PFN_DOWN(virt_to_phys(current_ti)))
+		+ (PFN_UP(THREAD_SIZE) << PAGE_SHIFT))
+		& 0xffffffff00000000ULL))
+		return;
+
+	if (low_ti == NULL)
+		low_ti = (struct thread_info *)
+				__get_free_pages(GFP_DMA32, THREAD_ORDER);
+
+	tboot_do_stack_switch(low_ti, current_ti);
+}
+
+void tboot_restore_stack(void)
+{
+	if (!tboot_enabled())
+		return;
+
+	if (current_ti == NULL)
+		BUG();
+
+	/* If thread info is above 4G, then restore stack */
+	if (!((PFN_PHYS(PFN_DOWN(virt_to_phys(current_ti)))
+		+ (PFN_UP(THREAD_SIZE) << PAGE_SHIFT))
+		& 0xffffffff00000000ULL))
+		return;
+
+	if (low_ti == NULL)
+		BUG();
+
+	tboot_do_stack_switch(current_ti, low_ti);
+}
 
 void tboot_shutdown(u32 shutdown_type)
 {
@@ -292,6 +444,24 @@ void tboot_sleep(u8 sleep_state, u32 pm1
 	}
 
 	tboot_shutdown(acpi_shutdown_map[sleep_state]);
+}
+
+void tboot_sx_resume(void)
+{
+	vmac_t mac;
+
+	if (!tboot_enabled())
+		return;
+
+	if (tboot_gen_mem_integrity(tboot->s3_key, &mac))
+		panic("tboot: vmac generation failed\n");
+	else if (mac != mem_mac)
+		panic("tboot: memory integrity was lost on resume\n");
+	else
+		pr_info("memory integrity OK\n");
+
+	/* Clean s3_key */
+	memset(tboot->s3_key, 0, sizeof(tboot->s3_key));
 }
 
 static atomic_t ap_wfs_count;
diff -r 42870e183bd5 drivers/acpi/sleep.c
--- a/drivers/acpi/sleep.c	Fri Sep 25 06:06:39 2009 -0400
+++ b/drivers/acpi/sleep.c	Fri Sep 25 11:03:04 2009 -0400
@@ -16,6 +16,7 @@
 #include <linux/device.h>
 #include <linux/suspend.h>
 #include <linux/reboot.h>
+#include <linux/tboot.h>
 
 #include <asm/io.h>
 
@@ -244,7 +245,10 @@ static int acpi_suspend_enter(suspend_st
 		break;
 
 	case ACPI_STATE_S3:
+		tboot_switch_stack();
 		do_suspend_lowlevel();
+		tboot_sx_resume();
+		tboot_restore_stack();
 		break;
 	}
 
diff -r 42870e183bd5 include/linux/tboot.h
--- a/include/linux/tboot.h	Fri Sep 25 06:06:39 2009 -0400
+++ b/include/linux/tboot.h	Fri Sep 25 11:03:04 2009 -0400
@@ -147,7 +147,9 @@ extern struct acpi_table_header *tboot_g
 extern struct acpi_table_header *tboot_get_dmar_table(
 				      struct acpi_table_header *dmar_tbl);
 extern int tboot_force_iommu(void);
-
+extern void tboot_sx_resume(void);
+extern void tboot_switch_stack(void);
+extern void tboot_restore_stack(void);
 #else
 
 #define tboot_probe()			do { } while (0)
@@ -156,6 +158,9 @@ extern int tboot_force_iommu(void);
 					do { } while (0)
 #define tboot_get_dmar_table(dmar_tbl)	(dmar_tbl)
 #define tboot_force_iommu()		0
+#define tboot_sx_resume()		do { } while (0)
+#define tboot_switch_stack()		do { } while (0)
+#define tboot_restore_stack()		do { } while (0)
 
 #endif /* !CONFIG_INTEL_TXT */
 
diff -r 42870e183bd5 security/Kconfig
--- a/security/Kconfig	Fri Sep 25 06:06:39 2009 -0400
+++ b/security/Kconfig	Fri Sep 25 11:03:04 2009 -0400
@@ -116,6 +116,8 @@ config INTEL_TXT
 config INTEL_TXT
 	bool "Enable Intel(R) Trusted Execution Technology (Intel(R) TXT)"
 	depends on HAVE_INTEL_TXT
+	select CRYPTO_VMAC
+	select CRYPTO_AES
 	help
 	  This option enables support for booting the kernel with the
 	  Trusted Boot (tboot) module. This will utilize

--------------030900080801030005090000--
