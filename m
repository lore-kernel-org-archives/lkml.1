Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbZG2S5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbZG2S5D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 14:57:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbZG2S5C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 14:57:02 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46050 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203AbZG2S47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 14:56:59 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v3 3/3] Security/SELinux: seperate lsm specific mmap_min_addr
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov
Cc: jwcart2@tycho.nsa.gov, eparis@redhat.com, sds@tycho.nsa.gov,
       spender@grsecurity.net, dwalsh@redhat.com, cl@linux-foundation.org,
       arjan@infradead.org, alan@lxorguk.ukuu.org.uk, kees@outflux.net,
       csellers@tresys.com, penguin-kernel@i-love.sakura.ne.jp
Date: Wed, 29 Jul 2009 14:56:33 -0400
Message-ID: <20090729185632.21757.22906.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090729185620.21757.44366.stgit@paris.rdu.redhat.com>
References: <20090729185620.21757.44366.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently SELinux enforcement of controls on the ability to map low memory
is determined by the mmap_min_addr tunable.  This patch causes SELinux to
ignore the tunable and instead use a seperate Kconfig option specific to how
much space the LSM should protect.

The tunable will now only control the need for CAP_SYS_RAWIO and SELinux
permissions will always protect the amount of low memory designated by
DEFAULT_LSM_MMAP_MIN_ADDR.

This allows users who need to disable the mmap_min_addr controls (usual reason
being they run WINE as a non-root user) to do so and still have SELinux
controls preventing confined domains (like a web server) from being able to
map some area of low memory.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/mm.h       |   15 --------------
 include/linux/security.h |   17 ++++++++++++++++
 kernel/sysctl.c          |    7 ++++---
 mm/Kconfig               |    6 +++---
 mm/mmap.c                |    3 ---
 mm/nommu.c               |    3 ---
 security/Kconfig         |   16 +++++++++++++++
 security/Makefile        |    2 +-
 security/commoncap.c     |    2 +-
 security/min_addr.c      |   49 ++++++++++++++++++++++++++++++++++++++++++++++
 security/selinux/hooks.c |    2 +-
 11 files changed, 92 insertions(+), 30 deletions(-)
 create mode 100644 security/min_addr.c

diff --git a/include/linux/mm.h b/include/linux/mm.h
index ba3a7cb..9a72cc7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -34,8 +34,6 @@ extern int sysctl_legacy_va_layout;
 #define sysctl_legacy_va_layout 0
 #endif
 
-extern unsigned long mmap_min_addr;
-
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/processor.h>
@@ -575,19 +573,6 @@ static inline void set_page_links(struct page *page, enum zone_type zone,
 }
 
 /*
- * If a hint addr is less than mmap_min_addr change hint to be as
- * low as possible but still greater than mmap_min_addr
- */
-static inline unsigned long round_hint_to_min(unsigned long hint)
-{
-	hint &= PAGE_MASK;
-	if (((void *)hint != NULL) &&
-	    (hint < mmap_min_addr))
-		return PAGE_ALIGN(mmap_min_addr);
-	return hint;
-}
-
-/*
  * Some inline functions in vmstat.h depend on page_zone()
  */
 #include <linux/vmstat.h>
diff --git a/include/linux/security.h b/include/linux/security.h
index 963a48f..7b43115 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -28,6 +28,7 @@
 #include <linux/resource.h>
 #include <linux/sem.h>
 #include <linux/shm.h>
+#include <linux/mm.h> /* PAGE_ALIGN */
 #include <linux/msg.h>
 #include <linux/sched.h>
 #include <linux/key.h>
@@ -95,6 +96,7 @@ extern int cap_netlink_send(struct sock *sk, struct sk_buff *skb);
 extern int cap_netlink_recv(struct sk_buff *skb, int cap);
 
 extern unsigned long mmap_min_addr;
+extern unsigned long dac_mmap_min_addr;
 /*
  * Values used in the task_security_ops calls
  */
@@ -147,6 +149,21 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
 	opts->num_mnt_opts = 0;
 }
 
+/*
+ * If a hint addr is less than mmap_min_addr change hint to be as
+ * low as possible but still greater than mmap_min_addr
+ */
+static inline unsigned long round_hint_to_min(unsigned long hint)
+{
+	hint &= PAGE_MASK;
+	if (((void *)hint != NULL) &&
+	    (hint < mmap_min_addr))
+		return PAGE_ALIGN(mmap_min_addr);
+	return hint;
+}
+
+extern int mmap_min_addr_handler(struct ctl_table *table, int write, struct file *filp,
+				 void __user *buffer, size_t *lenp, loff_t *ppos);
 /**
  * struct security_operations - main security structure
  *
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 98e0232..58be760 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -49,6 +49,7 @@
 #include <linux/acpi.h>
 #include <linux/reboot.h>
 #include <linux/ftrace.h>
+#include <linux/security.h>
 #include <linux/slow-work.h>
 #include <linux/perf_counter.h>
 
@@ -1306,10 +1307,10 @@ static struct ctl_table vm_table[] = {
 	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "mmap_min_addr",
-		.data		= &mmap_min_addr,
-		.maxlen         = sizeof(unsigned long),
+		.data		= &dac_mmap_min_addr,
+		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &proc_doulongvec_minmax,
+		.proc_handler	= &mmap_min_addr_handler,
 	},
 #ifdef CONFIG_NUMA
 	{
diff --git a/mm/Kconfig b/mm/Kconfig
index c948d4c..fe5f674 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -225,9 +225,9 @@ config DEFAULT_MMAP_MIN_ADDR
 	  For most ia64, ppc64 and x86 users with lots of address space
 	  a value of 65536 is reasonable and should cause no problems.
 	  On arm and other archs it should not be higher than 32768.
-	  Programs which use vm86 functionality would either need additional
-	  permissions from either the LSM or the capabilities module or have
-	  this protection disabled.
+	  Programs which use vm86 functionality or have some need to map
+	  this low address space will need CAP_SYS_RAWIO or disable this
+	  protection by setting the value to 0.
 
 	  This value can be changed after boot using the
 	  /proc/sys/vm/mmap_min_addr tunable.
diff --git a/mm/mmap.c b/mm/mmap.c
index 34579b2..8101de4 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -88,9 +88,6 @@ int sysctl_overcommit_ratio = 50;	/* default is 50% */
 int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
 struct percpu_counter vm_committed_as;
 
-/* amount of vm to protect from userspace access */
-unsigned long mmap_min_addr = CONFIG_DEFAULT_MMAP_MIN_ADDR;
-
 /*
  * Check that a process has enough memory to allocate a new virtual
  * mapping. 0 means there is enough memory for the allocation to
diff --git a/mm/nommu.c b/mm/nommu.c
index 53cab10..28754c4 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -69,9 +69,6 @@ int sysctl_max_map_count = DEFAULT_MAX_MAP_COUNT;
 int sysctl_nr_trim_pages = CONFIG_NOMMU_INITIAL_TRIM_EXCESS;
 int heap_stack_gap = 0;
 
-/* amount of vm to protect from userspace access */
-unsigned long mmap_min_addr = CONFIG_DEFAULT_MMAP_MIN_ADDR;
-
 atomic_long_t mmap_pages_allocated;
 
 EXPORT_SYMBOL(mem_map);
diff --git a/security/Kconfig b/security/Kconfig
index d23c839..9c60c34 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -113,6 +113,22 @@ config SECURITY_ROOTPLUG
 
 	  If you are unsure how to answer this question, answer N.
 
+config LSM_MMAP_MIN_ADDR
+	int "Low address space for LSM to from user allocation"
+	depends on SECURITY && SECURITY_SELINUX
+	default 65535
+	help
+	  This is the portion of low virtual memory which should be protected
+	  from userspace allocation.  Keeping a user from writing to low pages
+	  can help reduce the impact of kernel NULL pointer bugs.
+
+	  For most ia64, ppc64 and x86 users with lots of address space
+	  a value of 65536 is reasonable and should cause no problems.
+	  On arm and other archs it should not be higher than 32768.
+	  Programs which use vm86 functionality or have some need to map
+	  this low address space will need the permission specific to the
+	  systems running LSM.
+
 source security/selinux/Kconfig
 source security/smack/Kconfig
 source security/tomoyo/Kconfig
diff --git a/security/Makefile b/security/Makefile
index c67557c..b56e7f9 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -8,7 +8,7 @@ subdir-$(CONFIG_SECURITY_SMACK)		+= smack
 subdir-$(CONFIG_SECURITY_TOMOYO)        += tomoyo
 
 # always enable default capabilities
-obj-y		+= commoncap.o
+obj-y		+= commoncap.o min_addr.o
 
 # Object file lists
 obj-$(CONFIG_SECURITY)			+= security.o capability.o
diff --git a/security/commoncap.c b/security/commoncap.c
index 9a731d7..0269b5c 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -1003,7 +1003,7 @@ int cap_file_mmap(struct file *file, unsigned long reqprot,
 		  unsigned long prot, unsigned long flags,
 		  unsigned long addr, unsigned long addr_only)
 {
-	if (addr < mmap_min_addr)
+	if (addr < dac_mmap_min_addr)
 		return cap_capable(current, current_cred(), CAP_SYS_RAWIO,
 				   SECURITY_CAP_AUDIT);
 	return 0;
diff --git a/security/min_addr.c b/security/min_addr.c
new file mode 100644
index 0000000..14cc7b3
--- /dev/null
+++ b/security/min_addr.c
@@ -0,0 +1,49 @@
+#include <linux/init.h>
+#include <linux/mm.h>
+#include <linux/security.h>
+#include <linux/sysctl.h>
+
+/* amount of vm to protect from userspace access by both DAC and the LSM*/
+unsigned long mmap_min_addr;
+/* amount of vm to protect from userspace using CAP_SYS_RAWIO (DAC) */
+unsigned long dac_mmap_min_addr = CONFIG_DEFAULT_MMAP_MIN_ADDR;
+/* amount of vm to protect from userspace using the LSM = CONFIG_LSM_MMAP_MIN_ADDR */
+
+/*
+ * Update mmap_min_addr = max(dac_mmap_min_addr, CONFIG_LSM_MMAP_MIN_ADDR)
+ */
+static void update_mmap_min_addr(void)
+{
+#ifdef CONFIG_LSM_MMAP_MIN_ADDR
+	if (dac_mmap_min_addr > CONFIG_LSM_MMAP_MIN_ADDR)
+		mmap_min_addr = dac_mmap_min_addr;
+	else
+		mmap_min_addr = CONFIG_LSM_MMAP_MIN_ADDR;
+#else
+	mmap_min_addr = dac_mmap_min_addr;
+#endif
+}
+
+/*
+ * sysctl handler which just sets dac_mmap_min_addr = the new value and then
+ * calls update_mmap_min_addr() so non MAP_FIXED hints get rounded properly
+ */
+int mmap_min_addr_handler(struct ctl_table *table, int write, struct file *filp,
+			  void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	int ret;
+
+	ret = proc_doulongvec_minmax(table, write, filp, buffer, lenp, ppos);
+
+	update_mmap_min_addr();
+
+	return ret;
+}
+
+int __init init_mmap_min_addr(void)
+{
+	update_mmap_min_addr();
+
+	return 0;
+}
+pure_initcall(init_mmap_min_addr);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 8a78f58..5dee883 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3040,7 +3040,7 @@ static int selinux_file_mmap(struct file *file, unsigned long reqprot,
 	 * at bad behaviour/exploit that we always want to get the AVC, even
 	 * if DAC would have also denied the operation.
 	 */
-	if (addr < mmap_min_addr) {
+	if (addr < CONFIG_LSM_MMAP_MIN_ADDR) {
 		rc = avc_has_perm(sid, sid, SECCLASS_MEMPROTECT,
 				  MEMPROTECT__MMAP_ZERO, NULL);
 		if (rc)

