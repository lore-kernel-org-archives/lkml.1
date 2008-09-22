Return-Path: <linux-kernel-owner+w=401wt.eu-S1753750AbYIVVER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbYIVVER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 17:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbYIVVEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 17:04:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:33556 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbYIVVD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 17:03:59 -0400
Date: Mon, 22 Sep 2008 14:04:02 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, mingo@elte.hu,
       Hugh Dickins <hugh@veritas.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 1/2]  corruption check: move the corruption checks into
 their own file
Message-ID: <20080922140402.166de1ba@infradead.org>
In-Reply-To: <20080920203544.53a5148e@infradead.org>
References: <20080920203544.53a5148e@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>
Date: Mon, 22 Sep 2008 09:35:06 -0700
Subject: [PATCH] corruption check: move the corruption checks into their own file

The corruption check code is rather sizable and it's likely to grow over time when
we add checks for more types of corruptions (there's a few candidates in kerneloops.org
that I want to add checks for)... so lets move it to its own file

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

---
 arch/x86/kernel/Makefile          |    1 +
 arch/x86/kernel/corruptioncheck.c |  156 +++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup.c           |  151 -----------------------------------
 include/asm-x86/setup.h           |    4 +
 4 files changed, 161 insertions(+), 151 deletions(-)
 create mode 100644 arch/x86/kernel/corruptioncheck.c

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 8db0877..29f9ef2 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -36,6 +36,7 @@ obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o i8237.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o
 obj-y			+= tsc.o io_delay.o rtc.o
+obj-y			+= corruptioncheck.o
 
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline.o
 obj-y				+= process.o
diff --git a/arch/x86/kernel/corruptioncheck.c b/arch/x86/kernel/corruptioncheck.c
new file mode 100644
index 0000000..a7e80ed
--- /dev/null
+++ b/arch/x86/kernel/corruptioncheck.c
@@ -0,0 +1,156 @@
+#include <linux/module.h>
+#include <linux/sched.h>
+
+#include <asm/e820.h>
+#include <asm/proto.h>
+
+/*
+ * Some BIOSes seem to corrupt the low 64k of memory during events
+ * like suspend/resume and unplugging an HDMI cable.  Reserve all
+ * remaining free memory in that area and fill it with a distinct
+ * pattern.
+ */
+#ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
+#define MAX_SCAN_AREAS	8
+
+static int __read_mostly memory_corruption_check = -1;
+
+static unsigned __read_mostly corruption_check_size = 64*1024;
+static unsigned __read_mostly corruption_check_period = 60; /* seconds */
+
+static struct e820entry scan_areas[MAX_SCAN_AREAS];
+static int num_scan_areas;
+
+
+static int set_corruption_check(char *arg)
+{
+	char *end;
+
+	memory_corruption_check = simple_strtol(arg, &end, 10);
+
+	return (*end == 0) ? 0 : -EINVAL;
+}
+early_param("memory_corruption_check", set_corruption_check);
+
+static int set_corruption_check_period(char *arg)
+{
+	char *end;
+
+	corruption_check_period = simple_strtoul(arg, &end, 10);
+
+	return (*end == 0) ? 0 : -EINVAL;
+}
+early_param("memory_corruption_check_period", set_corruption_check_period);
+
+static int set_corruption_check_size(char *arg)
+{
+	char *end;
+	unsigned size;
+
+	size = memparse(arg, &end);
+
+	if (*end == '\0')
+		corruption_check_size = size;
+
+	return (size == corruption_check_size) ? 0 : -EINVAL;
+}
+early_param("memory_corruption_check_size", set_corruption_check_size);
+
+
+void __init setup_bios_corruption_check(void)
+{
+	u64 addr = PAGE_SIZE;	/* assume first page is reserved anyway */
+
+	if (memory_corruption_check == -1) {
+		memory_corruption_check =
+#ifdef CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK
+			1
+#else
+			0
+#endif
+			;
+	}
+
+	if (corruption_check_size == 0)
+		memory_corruption_check = 0;
+
+	if (!memory_corruption_check)
+		return;
+
+	corruption_check_size = round_up(corruption_check_size, PAGE_SIZE);
+
+	while(addr < corruption_check_size && num_scan_areas < MAX_SCAN_AREAS) {
+		u64 size;
+		addr = find_e820_area_size(addr, &size, PAGE_SIZE);
+
+		if (addr == 0)
+			break;
+
+		if ((addr + size) > corruption_check_size)
+			size = corruption_check_size - addr;
+
+		if (size == 0)
+			break;
+
+		e820_update_range(addr, size, E820_RAM, E820_RESERVED);
+		scan_areas[num_scan_areas].addr = addr;
+		scan_areas[num_scan_areas].size = size;
+		num_scan_areas++;
+
+		/* Assume we've already mapped this early memory */
+		memset(__va(addr), 0, size);
+
+		addr += size;
+	}
+
+	printk(KERN_INFO "Scanning %d areas for low memory corruption\n",
+	       num_scan_areas);
+	update_e820();
+}
+
+static struct timer_list periodic_check_timer;
+
+void check_for_bios_corruption(void)
+{
+	int i;
+	int corruption = 0;
+
+	if (!memory_corruption_check)
+		return;
+
+	for(i = 0; i < num_scan_areas; i++) {
+		unsigned long *addr = __va(scan_areas[i].addr);
+		unsigned long size = scan_areas[i].size;
+
+		for(; size; addr++, size -= sizeof(unsigned long)) {
+			if (!*addr)
+				continue;
+			printk(KERN_ERR "Corrupted low memory at %p (%lx phys) = %08lx\n",
+			       addr, __pa(addr), *addr);
+			corruption = 1;
+			*addr = 0;
+		}
+	}
+
+	WARN(corruption, KERN_ERR "Memory corruption detected in low memory\n");
+}
+
+static void periodic_check_for_corruption(unsigned long data)
+{
+	check_for_bios_corruption();
+	mod_timer(&periodic_check_timer, round_jiffies(jiffies + corruption_check_period*HZ));
+}
+
+void start_periodic_check_for_corruption(void)
+{
+	if (!memory_corruption_check || corruption_check_period == 0)
+		return;
+
+	printk(KERN_INFO "Scanning for low memory corruption every %d seconds\n",
+	       corruption_check_period);
+
+	init_timer(&periodic_check_timer);
+	periodic_check_timer.function = &periodic_check_for_corruption;
+	periodic_check_for_corruption(0);
+}
+#endif
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index a9998cb..8fa04e8 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -581,157 +581,6 @@ static struct x86_quirks default_x86_quirks __initdata;
 
 struct x86_quirks *x86_quirks __initdata = &default_x86_quirks;
 
-/*
- * Some BIOSes seem to corrupt the low 64k of memory during events
- * like suspend/resume and unplugging an HDMI cable.  Reserve all
- * remaining free memory in that area and fill it with a distinct
- * pattern.
- */
-#ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
-#define MAX_SCAN_AREAS	8
-
-static int __read_mostly memory_corruption_check = -1;
-
-static unsigned __read_mostly corruption_check_size = 64*1024;
-static unsigned __read_mostly corruption_check_period = 60; /* seconds */
-
-static struct e820entry scan_areas[MAX_SCAN_AREAS];
-static int num_scan_areas;
-
-
-static int set_corruption_check(char *arg)
-{
-	char *end;
-
-	memory_corruption_check = simple_strtol(arg, &end, 10);
-
-	return (*end == 0) ? 0 : -EINVAL;
-}
-early_param("memory_corruption_check", set_corruption_check);
-
-static int set_corruption_check_period(char *arg)
-{
-	char *end;
-
-	corruption_check_period = simple_strtoul(arg, &end, 10);
-
-	return (*end == 0) ? 0 : -EINVAL;
-}
-early_param("memory_corruption_check_period", set_corruption_check_period);
-
-static int set_corruption_check_size(char *arg)
-{
-	char *end;
-	unsigned size;
-
-	size = memparse(arg, &end);
-
-	if (*end == '\0')
-		corruption_check_size = size;
-
-	return (size == corruption_check_size) ? 0 : -EINVAL;
-}
-early_param("memory_corruption_check_size", set_corruption_check_size);
-
-
-static void __init setup_bios_corruption_check(void)
-{
-	u64 addr = PAGE_SIZE;	/* assume first page is reserved anyway */
-
-	if (memory_corruption_check == -1) {
-		memory_corruption_check =
-#ifdef CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK
-			1
-#else
-			0
-#endif
-			;
-	}
-
-	if (corruption_check_size == 0)
-		memory_corruption_check = 0;
-
-	if (!memory_corruption_check)
-		return;
-
-	corruption_check_size = round_up(corruption_check_size, PAGE_SIZE);
-
-	while(addr < corruption_check_size && num_scan_areas < MAX_SCAN_AREAS) {
-		u64 size;
-		addr = find_e820_area_size(addr, &size, PAGE_SIZE);
-
-		if (addr == 0)
-			break;
-
-		if ((addr + size) > corruption_check_size)
-			size = corruption_check_size - addr;
-
-		if (size == 0)
-			break;
-
-		e820_update_range(addr, size, E820_RAM, E820_RESERVED);
-		scan_areas[num_scan_areas].addr = addr;
-		scan_areas[num_scan_areas].size = size;
-		num_scan_areas++;
-
-		/* Assume we've already mapped this early memory */
-		memset(__va(addr), 0, size);
-
-		addr += size;
-	}
-
-	printk(KERN_INFO "Scanning %d areas for low memory corruption\n",
-	       num_scan_areas);
-	update_e820();
-}
-
-static struct timer_list periodic_check_timer;
-
-void check_for_bios_corruption(void)
-{
-	int i;
-	int corruption = 0;
-
-	if (!memory_corruption_check)
-		return;
-
-	for(i = 0; i < num_scan_areas; i++) {
-		unsigned long *addr = __va(scan_areas[i].addr);
-		unsigned long size = scan_areas[i].size;
-
-		for(; size; addr++, size -= sizeof(unsigned long)) {
-			if (!*addr)
-				continue;
-			printk(KERN_ERR "Corrupted low memory at %p (%lx phys) = %08lx\n",
-			       addr, __pa(addr), *addr);
-			corruption = 1;
-			*addr = 0;
-		}
-	}
-
-	WARN(corruption, KERN_ERR "Memory corruption detected in low memory\n");
-}
-
-static void periodic_check_for_corruption(unsigned long data)
-{
-	check_for_bios_corruption();
-	mod_timer(&periodic_check_timer, round_jiffies(jiffies + corruption_check_period*HZ));
-}
-
-void start_periodic_check_for_corruption(void)
-{
-	if (!memory_corruption_check || corruption_check_period == 0)
-		return;
-
-	printk(KERN_INFO "Scanning for low memory corruption every %d seconds\n",
-	       corruption_check_period);
-
-	init_timer(&periodic_check_timer);
-	periodic_check_timer.function = &periodic_check_for_corruption;
-	periodic_check_for_corruption(0);
-}
-#endif
-
 static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
 {
 	printk(KERN_NOTICE
diff --git a/include/asm-x86/setup.h b/include/asm-x86/setup.h
index 11b6cc1..5c55fc1 100644
--- a/include/asm-x86/setup.h
+++ b/include/asm-x86/setup.h
@@ -8,6 +8,10 @@
 /* Interrupt control for vSMPowered x86_64 systems */
 void vsmp_init(void);
 
+
+void setup_bios_corruption_check(void);
+
+
 #ifdef CONFIG_X86_VISWS
 extern void visws_early_detect(void);
 extern int is_visws_box(void);
-- 
1.5.5.1

