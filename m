Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbZGQUXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbZGQUXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbZGQUTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:19:39 -0400
Received: from kroah.org ([198.145.64.141]:43058 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470AbZGQUTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:19:37 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jul 17 13:12:28 2009
Message-Id: <20090717201228.282566328@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 17 Jul 2009 13:08:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Christoph Lameter <cl@linux-foundation.org>,
       Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>
Subject: [patch 02/24] security: use mmap_min_addr indepedently of security models
References: <20090717200851.907421303@mini.kroah.org>
Content-Disposition: inline; filename=security-use-mmap_min_addr-indepedently-of-security-models.patch
In-Reply-To: <20090717201639.GA14209@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christoph Lameter <cl@linux-foundation.org>

commit e0a94c2a63f2644826069044649669b5e7ca75d3 upstream.

This patch removes the dependency of mmap_min_addr on CONFIG_SECURITY.
It also sets a default mmap_min_addr of 4096.

mmapping of addresses below 4096 will only be possible for processes
with CAP_SYS_RAWIO.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Acked-by: Eric Paris <eparis@redhat.com>
Looks-ok-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/mm.h       |    2 --
 include/linux/security.h |    2 ++
 kernel/sysctl.c          |    2 --
 mm/Kconfig               |   19 +++++++++++++++++++
 mm/mmap.c                |    3 +++
 security/Kconfig         |   22 +---------------------
 security/security.c      |    3 ---
 7 files changed, 25 insertions(+), 28 deletions(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -580,12 +580,10 @@ static inline void set_page_links(struct
  */
 static inline unsigned long round_hint_to_min(unsigned long hint)
 {
-#ifdef CONFIG_SECURITY
 	hint &= PAGE_MASK;
 	if (((void *)hint != NULL) &&
 	    (hint < mmap_min_addr))
 		return PAGE_ALIGN(mmap_min_addr);
-#endif
 	return hint;
 }
 
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -2197,6 +2197,8 @@ static inline int security_file_mmap(str
 				     unsigned long addr,
 				     unsigned long addr_only)
 {
+	if ((addr < mmap_min_addr) && !capable(CAP_SYS_RAWIO))
+		return -EACCES;
 	return 0;
 }
 
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1225,7 +1225,6 @@ static struct ctl_table vm_table[] = {
 		.strategy	= &sysctl_jiffies,
 	},
 #endif
-#ifdef CONFIG_SECURITY
 	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "mmap_min_addr",
@@ -1234,7 +1233,6 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_doulongvec_minmax,
 	},
-#endif
 #ifdef CONFIG_NUMA
 	{
 		.ctl_name	= CTL_UNNUMBERED,
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -226,6 +226,25 @@ config HAVE_MLOCKED_PAGE_BIT
 config MMU_NOTIFIER
 	bool
 
+config DEFAULT_MMAP_MIN_ADDR
+        int "Low address space to protect from user allocation"
+        default 4096
+        help
+	  This is the portion of low virtual memory which should be protected
+	  from userspace allocation.  Keeping a user from writing to low pages
+	  can help reduce the impact of kernel NULL pointer bugs.
+
+	  For most ia64, ppc64 and x86 users with lots of address space
+	  a value of 65536 is reasonable and should cause no problems.
+	  On arm and other archs it should not be higher than 32768.
+	  Programs which use vm86 functionality would either need additional
+	  permissions from either the LSM or the capabilities module or have
+	  this protection disabled.
+
+	  This value can be changed after boot using the
+	  /proc/sys/vm/mmap_min_addr tunable.
+
+
 config NOMMU_INITIAL_TRIM_EXCESS
 	int "Turn on mmap() excess space trimming before booting"
 	depends on !MMU
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -87,6 +87,9 @@ int sysctl_overcommit_ratio = 50;	/* def
 int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
 struct percpu_counter vm_committed_as;
 
+/* amount of vm to protect from userspace access */
+unsigned long mmap_min_addr = CONFIG_DEFAULT_MMAP_MIN_ADDR;
+
 /*
  * Check that a process has enough memory to allocate a new virtual
  * mapping. 0 means there is enough memory for the allocation to
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -110,28 +110,8 @@ config SECURITY_ROOTPLUG
 
 	  See <http://www.linuxjournal.com/article.php?sid=6279> for
 	  more information about this module.
-	  
-	  If you are unsure how to answer this question, answer N.
-
-config SECURITY_DEFAULT_MMAP_MIN_ADDR
-        int "Low address space to protect from user allocation"
-        depends on SECURITY
-        default 0
-        help
-	  This is the portion of low virtual memory which should be protected
-	  from userspace allocation.  Keeping a user from writing to low pages
-	  can help reduce the impact of kernel NULL pointer bugs.
-
-	  For most ia64, ppc64 and x86 users with lots of address space
-	  a value of 65536 is reasonable and should cause no problems.
-	  On arm and other archs it should not be higher than 32768.
-	  Programs which use vm86 functionality would either need additional
-	  permissions from either the LSM or the capabilities module or have
-	  this protection disabled.
-
-	  This value can be changed after boot using the
-	  /proc/sys/vm/mmap_min_addr tunable.
 
+	  If you are unsure how to answer this question, answer N.
 
 source security/selinux/Kconfig
 source security/smack/Kconfig
--- a/security/security.c
+++ b/security/security.c
@@ -26,9 +26,6 @@ extern void security_fixup_ops(struct se
 
 struct security_operations *security_ops;	/* Initialized to NULL */
 
-/* amount of vm to protect from userspace access */
-unsigned long mmap_min_addr = CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR;
-
 static inline int verify(struct security_operations *ops)
 {
 	/* verify the security_operations structure exists */


