Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbYA3Ut1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbYA3Ut1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:49:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbYA3UtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:49:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46294 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbYA3UtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:49:18 -0500
Date: Wed, 30 Jan 2008 12:48:53 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: davej@redhat.com, mingo@elte.hu, tglx@tglx.de, hpa@zytor.com
Subject: [PATCH] x86: introduce /dev/mem restrictions with a config option
Message-ID: <20080130124853.184ef782@laptopd505.fenrus.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] x86: introduce /dev/mem restrictions with a config option

This patch introduces a restriction on /dev/mem: Only non-memory can be
read or written unless the newly introduced config option is set.

The X server needs access to /dev/mem for the PCI space, but it doesn't need
access to memory; both the file permissions and SELinux permissions of /dev/mem
just make X effectively super-super powerful. With the exception of the
BIOS area, there's just no valid app that uses /dev/mem on actual memory.
Other popular users of /dev/mem are rootkits and the like.
(note: mmap access of memory via /dev/mem was already not allowed since
a really long time)

People who want to use /dev/mem for kernel debugging can enable the config
option.

The restrictions of this patch have been in the Fedora and RHEL kernels for
at least 4 years without any problems.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/Kconfig.debug |   12 ++++++++++++
 arch/x86/mm/init_32.c  |   19 +++++++++++++++++++
 arch/x86/mm/init_64.c  |   20 ++++++++++++++++++++
 drivers/char/mem.c     |   28 ++++++++++++++++++++++++++++
 include/asm-x86/page.h |    1 +
 5 files changed, 80 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 2e1e3af..6192c5f 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -5,6 +5,18 @@ config TRACE_IRQFLAGS_SUPPORT
 
 source "lib/Kconfig.debug"
 
+config NONPROMISC_DEVMEM
+	bool "Disable promiscuous /dev/mem"
+	default y
+	help
+	  The /dev/mem file by default only allows userspace access to PCI
+	  space and the BIOS code and data regions. This is sufficient for
+	  dosemu and X and all common users of /dev/mem. With this config
+	  option, you allow userspace access to all of memory, including
+	  kernel and userspace memory. Accidental access to this is
+	  obviously disasterous, but specific access can be used by people
+	  debugging the kernel.
+
 config EARLY_PRINTK
 	bool "Early printk" if EMBEDDED
 	default y
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index da524fb..84a13aa 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -216,6 +216,25 @@ static inline int page_kills_ppro(unsigned long pagenr)
 	return 0;
 }
 
+/*
+ * devmem_is_allowed() checks to see if /dev/mem access to a certain address
+ * is valid. The argument is a physical page number.
+ *
+ *
+ * On x86, access has to be given to the first megabyte of ram because that area
+ * contains bios code and data regions used by X and dosemu and similar apps.
+ * Access has to be given to non-kernel-ram areas as well, these contain the PCI
+ * mmio resources as well as potential bios/acpi data regions.
+ */
+int devmem_is_allowed(unsigned long pagenr)
+{
+	if (pagenr <= 256)
+		return 1;
+	if (!page_is_ram(pagenr))
+		return 1;
+	return 0;
+}
+
 #ifdef CONFIG_HIGHMEM
 pte_t *kmap_pte;
 pgprot_t kmap_prot;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index cc50a13..53d6e15 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -526,6 +526,26 @@ EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
 
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
+/*
+ * devmem_is_allowed() checks to see if /dev/mem access to a certain address
+ * is valid. The argument is a physical page number.
+ *
+ *
+ * On x86, access has to be given to the first megabyte of ram because that area
+ * contains bios code and data regions used by X and dosemu and similar apps.
+ * Access has to be given to non-kernel-ram areas as well, these contain the PCI
+ * mmio resources as well as potential bios/acpi data regions.
+ */
+int devmem_is_allowed(unsigned long pagenr)
+{
+	if (pagenr <= 256)
+		return 1;
+	if (!page_is_ram(pagenr))
+		return 1;
+	return 0;
+}
+
+
 static struct kcore_list kcore_mem, kcore_vmalloc, kcore_kernel,
 			 kcore_modules, kcore_vsyscall;
 
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 20070b7..dcf6e31 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -108,6 +108,30 @@ static inline int valid_mmap_phys_addr_range(unsigned long pfn, size_t size)
 }
 #endif
 
+#ifdef CONFIG_NONPROMISC_DEVMEM
+static inline int range_is_allowed(unsigned long from, unsigned long to)
+{
+	unsigned long cursor;
+
+	cursor = from >> PAGE_SHIFT;
+	while ((cursor << PAGE_SHIFT) < to) {
+		if (!devmem_is_allowed(cursor)) {
+			printk(KERN_INFO "Program %s tried to read /dev/mem "
+				"between %lx->%lx.\n",
+				current->comm, from, to);
+			return 0;
+		}
+		cursor++;
+	}
+	return 1;
+}
+#else
+static inline int range_is_allowed(unsigned long from, unsigned long to)
+{
+	return 1;
+}
+#endif
+
 /*
  * This funcion reads the *physical* memory. The f_pos points directly to the 
  * memory location. 
@@ -157,6 +181,8 @@ static ssize_t read_mem(struct file * file, char __user * buf,
 		 */
 		ptr = xlate_dev_mem_ptr(p);
 
+		if (!range_is_allowed(p, p+count))
+			return -EPERM;
 		if (copy_to_user(buf, ptr, sz))
 			return -EFAULT;
 		buf += sz;
@@ -214,6 +240,8 @@ static ssize_t write_mem(struct file * file, const char __user * buf,
 		 */
 		ptr = xlate_dev_mem_ptr(p);
 
+		if (!range_is_allowed(p, p+sz))
+			return -EPERM;
 		copied = copy_from_user(ptr, buf, sz);
 		if (copied) {
 			written += sz - copied;
diff --git a/include/asm-x86/page.h b/include/asm-x86/page.h
index c8b30ef..a36f9a1 100644
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -49,6 +49,7 @@
 #ifndef __ASSEMBLY__
 
 extern int page_is_ram(unsigned long pagenr);
+extern int devmem_is_allowed(unsigned long pagenr);
 
 struct page;
 
-- 
1.5.3.4



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
