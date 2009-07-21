Return-Path: <linux-kernel-owner+w=401wt.eu-S1756482AbZGUXEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbZGUXEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 19:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756422AbZGUXEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 19:04:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59223 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755960AbZGUXEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 19:04:23 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v2 2/2] Security/SELinux: seperate lsm specific mmap_min_addr
To: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Cc: sds@tycho.nsa.gov, jmorris@namei.org, spender@grsecurity.net,
       dwalsh@redhat.com, cl@linux-foundation.org, arjan@infradead.org,
       alan@lxorguk.ukuu.org.uk, kyle@mcmartin.ca, cpardy@redhat.com,
       arnd@arndb.de
Date: Tue, 21 Jul 2009 19:03:46 -0400
Message-ID: <20090721230346.20180.31799.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090721230339.20180.99803.stgit@paris.rdu.redhat.com>
References: <20090721230339.20180.99803.stgit@paris.rdu.redhat.com>
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

 include/linux/mm.h       |    3 +++
 include/linux/security.h |    1 -
 kernel/sysctl.c          |    4 ++--
 mm/Kconfig               |    6 +++---
 mm/Makefile              |    2 +-
 mm/min_addr.c            |   39 +++++++++++++++++++++++++++++++++++++++
 mm/mmap.c                |    9 +++------
 mm/mremap.c              |    4 ++--
 mm/nommu.c               |    5 +----
 security/Kconfig         |   16 ++++++++++++++++
 security/selinux/hooks.c |    2 +-
 11 files changed, 71 insertions(+), 20 deletions(-)
 create mode 100644 mm/min_addr.c

diff --git a/include/linux/mm.h b/include/linux/mm.h
index ba3a7cb..dc7276a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -35,6 +35,7 @@ extern int sysctl_legacy_va_layout;
 #endif
 
 extern unsigned long mmap_min_addr;
+extern unsigned long dac_mmap_min_addr;
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
@@ -587,6 +588,8 @@ static inline unsigned long round_hint_to_min(unsigned long hint)
 	return hint;
 }
 
+extern int mmap_min_addr_handler(struct ctl_table *table, int write, struct file *filp,
+				 void __user *buffer, size_t *lenp, loff_t *ppos);
 /*
  * Some inline functions in vmstat.h depend on page_zone()
  */
diff --git a/include/linux/security.h b/include/linux/security.h
index f7d198a..de774f7 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -91,7 +91,6 @@ struct seq_file;
 extern int cap_netlink_send(struct sock *sk, struct sk_buff *skb);
 extern int cap_netlink_recv(struct sk_buff *skb, int cap);
 
-extern unsigned long mmap_min_addr;
 /*
  * Values used in the task_security_ops calls
  */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 98e0232..b77a74a 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1306,10 +1306,10 @@ static struct ctl_table vm_table[] = {
 	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "mmap_min_addr",
-		.data		= &mmap_min_addr,
+		.data		= &dac_mmap_min_addr,
 		.maxlen         = sizeof(unsigned long),
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
diff --git a/mm/Makefile b/mm/Makefile
index b2b96c2..a06a655 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -11,7 +11,7 @@ obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
 			   maccess.o page_alloc.o page-writeback.o \
 			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
-			   page_isolation.o mm_init.o $(mmu-y)
+			   page_isolation.o mm_init.o min_addr.o $(mmu-y)
 obj-y += init-mm.o
 
 obj-$(CONFIG_PROC_PAGE_MONITOR) += pagewalk.o
diff --git a/mm/min_addr.c b/mm/min_addr.c
new file mode 100644
index 0000000..d035b7e
--- /dev/null
+++ b/mm/min_addr.c
@@ -0,0 +1,39 @@
+#include <linux/init.h>
+#include <linux/sysctl.h>
+
+/* amount of vm to protect from userspace access */
+unsigned long mmap_min_addr;
+/* amount of vm to protect from userspace using CAP_SYS_RAWIO */
+unsigned long dac_mmap_min_addr = CONFIG_DEFAULT_MMAP_MIN_ADDR;
+
+static void update_mmap_min_addr(void)
+{
+#ifdef CONFIG_SECURITY
+	if (dac_mmap_min_addr > CONFIG_DEFAULT_LSM_MMAP_MIN_ADDR)
+		mmap_min_addr = dac_mmap_min_addr;
+	else
+		dac_mmap_min_addr = CONFIG_DEFAULT_LSM_MMAP_MIN_ADDR;
+#else   
+	mmap_min_addr = dac_mmap_min_addr;
+#endif
+}
+
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
diff --git a/mm/mmap.c b/mm/mmap.c
index 3bc88c4..0782eb2 100644
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
@@ -1051,7 +1048,7 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 	if (error)
 		return error;
 
-	if ((addr < mmap_min_addr) && !capable(CAP_SYS_RAWIO))
+	if ((addr < dac_mmap_min_addr) && !capable(CAP_SYS_RAWIO))
 		return -EACCES;
 
 	error = ima_file_mmap(file, prot);
@@ -1666,7 +1663,7 @@ static int expand_downwards(struct vm_area_struct *vma,
 	if (error)
 		return error;
 
-	if ((address < mmap_min_addr) && !capable(CAP_SYS_RAWIO))
+	if ((address < dac_mmap_min_addr) && !capable(CAP_SYS_RAWIO))
 		return -EACCES;
 
 	anon_vma_lock(vma);
@@ -2010,7 +2007,7 @@ unsigned long do_brk(unsigned long addr, unsigned long len)
 	if (error)
 		return error;
 
-	if ((addr < mmap_min_addr) && !capable(CAP_SYS_RAWIO))
+	if ((addr < dac_mmap_min_addr) && !capable(CAP_SYS_RAWIO))
 		return -EACCES;
 
 	flags = VM_DATA_DEFAULT_FLAGS | VM_ACCOUNT | mm->def_flags;
diff --git a/mm/mremap.c b/mm/mremap.c
index fc866c3..099efab 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -304,7 +304,7 @@ unsigned long do_mremap(unsigned long addr,
 			goto out;
 
 		ret = -EACCES;
-		if ((new_addr < mmap_min_addr) && !capable(CAP_SYS_RAWIO))
+		if ((new_addr < dac_mmap_min_addr) && !capable(CAP_SYS_RAWIO))
 			goto out;
 
 		ret = do_munmap(mm, new_addr, new_len);
@@ -416,7 +416,7 @@ unsigned long do_mremap(unsigned long addr,
 				goto out;
 
 			ret = -EACCES;
-			if ((new_addr < mmap_min_addr) && !capable(CAP_SYS_RAWIO))
+			if ((new_addr < dac_mmap_min_addr) && !capable(CAP_SYS_RAWIO))
 				goto out;
 		}
 		ret = move_vma(vma, addr, old_len, new_len, new_addr);
diff --git a/mm/nommu.c b/mm/nommu.c
index 891ed70..f239940 100644
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
@@ -999,7 +996,7 @@ static int validate_mmap_request(struct file *file,
 	if (ret < 0)
 		return ret;
 
-	if ((addr < mmap_min_addr) && !capable(CAP_SYS_RAWIO))
+	if ((addr < dac_mmap_min_addr) && !capable(CAP_SYS_RAWIO))
 		return -EACCES;
 
 	/* looks okay */
diff --git a/security/Kconfig b/security/Kconfig
index d23c839..c0538e6 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -113,6 +113,22 @@ config SECURITY_ROOTPLUG
 
 	  If you are unsure how to answer this question, answer N.
 
+config DEFAULT_LSM_MMAP_MIN_ADDR
+        int "Low address space for LSM to from user allocation"
+	depends on SECURITY
+        default 32768
+        help
+          This is the portion of low virtual memory which should be protected
+          from userspace allocation.  Keeping a user from writing to low pages
+          can help reduce the impact of kernel NULL pointer bugs.
+
+          For most ia64, ppc64 and x86 users with lots of address space
+          a value of 65536 is reasonable and should cause no problems.
+          On arm and other archs it should not be higher than 32768.
+          Programs which use vm86 functionality or have some need to map
+          this low address space will need the permission specific to the
+	  systems running LSM.
+
 source security/selinux/Kconfig
 source security/smack/Kconfig
 source security/tomoyo/Kconfig
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index e65677d..9182c27 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3034,7 +3034,7 @@ static int selinux_file_mmap(struct file *file, unsigned long reqprot,
 	int rc = 0;
 	u32 sid = current_sid();
 
-	if (addr < mmap_min_addr)
+	if (addr < CONFIG_DEFAULT_LSM_MMAP_MIN_ADDR)
 		rc = avc_has_perm(sid, sid, SECCLASS_MEMPROTECT,
 				  MEMPROTECT__MMAP_ZERO, NULL);
 	if (rc || addr_only)

