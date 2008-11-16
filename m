Return-Path: <linux-kernel-owner+w=401wt.eu-S1756692AbYKPAEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbYKPAEf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 19:04:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbYKPADs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 19:03:48 -0500
Received: from ns2.suse.de ([195.135.220.15]:55070 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbYKPADq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 19:03:46 -0500
From: Bernhard Walle <bwalle@suse.de>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Bernhard Walle <bwalle@suse.de>
Subject: [PATCH 2/2] Add dev.mem.restricted sysctl
Date: Sun, 16 Nov 2008 01:03:43 +0100
Message-Id: <1226793823-32360-3-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1226793823-32360-1-git-send-email-bwalle@suse.de>
References: <1226793823-32360-1-git-send-email-bwalle@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_STRICT_DEVMEM is set, live debugging is not possible with the
crash utility (see http://people.redhat.com/~anderson). For distributors
who ship a generic kernel it's difficult: Disabling CONFIG_STRICT_DEVMEM
is possible, but in general the protection provided by CONFIG_STRICT_DEVMEM
is useful. However, live debugging should be still neceessary.

This patch now adds a dev.mem.restricted sysctl that defaults to 0 (off).
When set to 1 (on), /dev/mem access is unrestricted and crash can be used.

>From a security point of view the sysctl should be no problem. It's already
possible to circumvent that restriction if you have root access by loading
a kernel module that installs a kretprobe that returns 1 for the check function.

I thought of a command line parameter first, but we already have lots of
command line parameters and rebooting the machine is more difficult than
just setting a sysctl to 1. It may be possible to implement setting that
variable in the tools automatically, but that's out of the scope of that
patch for the kernel and should also not be discussed on LKML.


Signed-off-by: Bernhard Walle <bwalle@suse.de>
---
 arch/x86/include/asm/page.h |    7 +++++
 arch/x86/mm/pat.c           |    9 +------
 drivers/char/mem.c          |   57 +++++++++++++++++++++++++++++++++++++-----
 include/linux/sysctl.h      |    6 ++++
 kernel/sysctl_check.c       |    7 +++++
 5 files changed, 71 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index b768401..e5fe778 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -65,6 +65,13 @@ extern void unmap_devmem(unsigned long pfn, unsigned long size,
 			 pgprot_t vma_prot);
 #define __HAVE_ARCH_RANGE_IS_ALLOWED 1
 
+
+#ifdef CONFIG_STRICT_DEVMEM
+extern int devmem_restricted;
+#else
+#define devmem_restricted 0
+#endif
+
 extern unsigned long max_low_pfn_mapped;
 extern unsigned long max_pfn_mapped;
 
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index eb1bf00..c80ced4 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -26,6 +26,7 @@
 #include <asm/msr.h>
 #include <asm/pat.h>
 #include <asm/io.h>
+#include <asm/page.h>
 
 #ifdef CONFIG_X86_PAT
 int __read_mostly pat_enabled = 1;
@@ -474,13 +475,6 @@ pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 	return vma_prot;
 }
 
-#ifdef CONFIG_STRICT_DEVMEM
-/* This check is done in drivers/char/mem.c in case of STRICT_DEVMEM*/
-static inline int range_is_allowed(unsigned long pfn, unsigned long size)
-{
-	return 1;
-}
-#else
 /* This check is needed to avoid cache aliasing when PAT is enabled */
 static inline int range_is_allowed(unsigned long pfn, unsigned long size)
 {
@@ -503,7 +497,6 @@ static inline int range_is_allowed(unsigned long pfn, unsigned long size)
 	}
 	return 1;
 }
-#endif /* CONFIG_STRICT_DEVMEM */
 
 int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 				unsigned long size, pgprot_t *vma_prot)
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 6431f69..562438e 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -27,6 +27,7 @@
 #include <linux/splice.h>
 #include <linux/pfn.h>
 #include <linux/smp_lock.h>
+#include <linux/sysctl.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
@@ -35,6 +36,48 @@
 # include <linux/efi.h>
 #endif
 
+
+#ifdef CONFIG_STRICT_DEVMEM
+
+int devmem_restricted = 1;
+
+#ifdef CONFIG_SYSCTL
+struct ctl_table dev_mem_restricted_sysctl_table[] = {
+	{
+		.ctl_name = DEV_MEM_RESTRICTED,
+		.procname = "restricted",
+		.data = &devmem_restricted,
+		.maxlen = sizeof(int),
+		.mode = 0644,
+		.proc_handler = &proc_dointvec,
+	},
+	{ .ctl_name = 0 }
+};
+
+struct ctl_table dev_mem_sysctl_table[] = {
+	{
+	       .ctl_name = DEV_MEM,
+	       .procname = "mem",
+	       .mode = 0555,
+	       .child = dev_mem_restricted_sysctl_table
+	},
+	{ .ctl_name = 0 }
+};
+
+struct ctl_table dev_sysctl_table[] = {
+	{
+		.ctl_name = CTL_DEV,
+		.procname = "dev",
+		.mode = 0555,
+		.child = dev_mem_sysctl_table
+	},
+	{ .ctl_name = 0 }
+};
+#endif
+
+#endif /* CONFIG_STRICT_DEVMEM */
+
+
 /*
  * Architectures vary in how they handle caching for addresses
  * outside of main memory.
@@ -80,13 +123,15 @@ static inline int valid_mmap_phys_addr_range(unsigned long pfn, size_t size)
 }
 #endif
 
-#ifdef CONFIG_STRICT_DEVMEM
 static inline int range_is_allowed(unsigned long pfn, unsigned long size)
 {
 	u64 from = ((u64)pfn) << PAGE_SHIFT;
 	u64 to = from + size;
 	u64 cursor = from;
 
+	if (!devmem_restricted)
+		return 1;
+
 	while (cursor < to) {
 		if (!devmem_is_allowed(pfn)) {
 			printk(KERN_INFO
@@ -99,12 +144,6 @@ static inline int range_is_allowed(unsigned long pfn, unsigned long size)
 	}
 	return 1;
 }
-#else
-static inline int range_is_allowed(unsigned long pfn, unsigned long size)
-{
-	return 1;
-}
-#endif
 
 void __attribute__((weak)) unxlate_dev_mem_ptr(unsigned long phys, void *addr)
 {
@@ -996,6 +1035,10 @@ static int __init chr_dev_init(void)
 			      MKDEV(MEM_MAJOR, devlist[i].minor), NULL,
 			      devlist[i].name);
 
+#if defined(CONFIG_SYSCTL) && defined(CONFIG_STRICT_DEVMEM)
+	register_sysctl_table(dev_sysctl_table);
+#endif
+
 	return 0;
 }
 
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 39d471d..45ab794 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -858,6 +858,7 @@ enum {
 	DEV_MAC_HID=5,
 	DEV_SCSI=6,
 	DEV_IPMI=7,
+	DEV_MEM=8,
 };
 
 /* /proc/sys/dev/cdrom */
@@ -875,6 +876,11 @@ enum {
 	DEV_PARPORT_DEFAULT=-3
 };
 
+/* /proc/sys/dev/mem */
+enum {
+    DEV_MEM_RESTRICTED=1,
+};
+
 /* /proc/sys/dev/raid */
 enum {
 	DEV_RAID_SPEED_LIMIT_MIN=1,
diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
index c35da23..2cbdd52 100644
--- a/kernel/sysctl_check.c
+++ b/kernel/sysctl_check.c
@@ -870,6 +870,12 @@ static const struct trans_ctl_table trans_parport_table[] = {
 	{}
 };
 
+
+static const struct trans_ctl_table trans_mem_table[] = {
+	{ DEV_MEM_RESTRICTED,	"restricted" },
+	{}
+};
+
 static const struct trans_ctl_table trans_dev_table[] = {
 	{ DEV_CDROM,	"cdrom",	trans_cdrom_table },
 	/* DEV_HWMON unused */
@@ -878,6 +884,7 @@ static const struct trans_ctl_table trans_dev_table[] = {
 	{ DEV_MAC_HID,	"mac_hid",	trans_mac_hid_files },
 	{ DEV_SCSI,	"scsi",		trans_scsi_table },
 	{ DEV_IPMI,	"ipmi",		trans_ipmi_table },
+	{ DEV_MEM,      "mem",          trans_mem_table },
 	{}
 };
 
-- 
1.6.0.4

