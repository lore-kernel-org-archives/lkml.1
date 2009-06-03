Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbZFCTAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbZFCTAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 15:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbZFCS76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 14:59:58 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:46092 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753823AbZFCS75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 14:59:57 -0400
Date: Wed, 3 Jun 2009 14:59:51 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Larry H." <research@subreption.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, pageexec@freemail.hu
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change
 ZERO_SIZE_PTR to point at unmapped space)
In-Reply-To: <alpine.LFD.2.01.0906031145460.4880@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0906031458250.9269@gentwo.org>
References: <20090530230022.GO6535@oblivion.subreption.com> <alpine.LFD.2.01.0905301902010.3435@localhost.localdomain> <20090531022158.GA9033@oblivion.subreption.com> <alpine.DEB.1.10.0906021130410.23962@gentwo.org> <20090602203405.GC6701@oblivion.subreption.com>
 <alpine.DEB.1.10.0906031047390.15621@gentwo.org> <20090603182949.5328d411@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0906031032390.4880@localhost.localdomain> <20090603180037.GB18561@oblivion.subreption.com> <alpine.LFD.2.01.0906031109150.4880@localhost.localdomain>
 <20090603183939.GC18561@oblivion.subreption.com> <alpine.LFD.2.01.0906031142390.4880@localhost.localdomain> <alpine.LFD.2.01.0906031145460.4880@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We could just move the check for mmap_min_addr out from
CONFIG_SECURITY?


Use mmap_min_addr indepedently of security models

This patch removes the dependency of mmap_min_addr on CONFIG_SECURITY.
It also sets a default mmap_min_addr of 4096.

mmapping of addresses below 4096 will only be possible for processes
with CAP_SYS_RAWIO.


Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 include/linux/mm.h    |    2 --
 kernel/sysctl.c       |    2 --
 mm/Kconfig            |   19 +++++++++++++++++++
 mm/mmap.c             |    6 ++++++
 security/Kconfig      |   20 --------------------
 security/capability.c |    2 --
 security/security.c   |    3 ---
 7 files changed, 25 insertions(+), 29 deletions(-)

Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2009-06-03 13:48:01.000000000 -0500
+++ linux-2.6/include/linux/mm.h	2009-06-03 13:48:10.000000000 -0500
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

Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c	2009-06-03 13:48:01.000000000 -0500
+++ linux-2.6/kernel/sysctl.c	2009-06-03 13:48:10.000000000 -0500
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
Index: linux-2.6/mm/mmap.c
===================================================================
--- linux-2.6.orig/mm/mmap.c	2009-06-03 13:48:01.000000000 -0500
+++ linux-2.6/mm/mmap.c	2009-06-03 13:48:10.000000000 -0500
@@ -87,6 +87,9 @@ int sysctl_overcommit_ratio = 50;	/* def
 int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
 struct percpu_counter vm_committed_as;

+/* amount of vm to protect from userspace access */
+unsigned long mmap_min_addr = CONFIG_DEFAULT_MMAP_MIN_ADDR;
+
 /*
  * Check that a process has enough memory to allocate a new virtual
  * mapping. 0 means there is enough memory for the allocation to
@@ -1043,6 +1046,9 @@ unsigned long do_mmap_pgoff(struct file
 		}
 	}

+	if ((addr < mmap_min_addr) && !capable(CAP_SYS_RAWIO))
+		return -EACCES;
+
 	error = security_file_mmap(file, reqprot, prot, flags, addr, 0);
 	if (error)
 		return error;
Index: linux-2.6/security/security.c
===================================================================
--- linux-2.6.orig/security/security.c	2009-06-03 13:48:01.000000000 -0500
+++ linux-2.6/security/security.c	2009-06-03 13:48:10.000000000 -0500
@@ -26,9 +26,6 @@ extern void security_fixup_ops(struct se

 struct security_operations *security_ops;	/* Initialized to NULL */

-/* amount of vm to protect from userspace access */
-unsigned long mmap_min_addr = CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR;
-
 static inline int verify(struct security_operations *ops)
 {
 	/* verify the security_operations structure exists */
Index: linux-2.6/mm/Kconfig
===================================================================
--- linux-2.6.orig/mm/Kconfig	2009-06-03 13:48:01.000000000 -0500
+++ linux-2.6/mm/Kconfig	2009-06-03 13:48:10.000000000 -0500
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
Index: linux-2.6/security/Kconfig
===================================================================
--- linux-2.6.orig/security/Kconfig	2009-06-03 13:48:01.000000000 -0500
+++ linux-2.6/security/Kconfig	2009-06-03 13:48:10.000000000 -0500
@@ -113,26 +113,6 @@ config SECURITY_ROOTPLUG

 	  If you are unsure how to answer this question, answer N.

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
-
-
 source security/selinux/Kconfig
 source security/smack/Kconfig
 source security/tomoyo/Kconfig
Index: linux-2.6/security/capability.c
===================================================================
--- linux-2.6.orig/security/capability.c	2009-06-03 13:48:01.000000000 -0500
+++ linux-2.6/security/capability.c	2009-06-03 13:48:10.000000000 -0500
@@ -334,8 +334,6 @@ static int cap_file_mmap(struct file *fi
 			 unsigned long prot, unsigned long flags,
 			 unsigned long addr, unsigned long addr_only)
 {
-	if ((addr < mmap_min_addr) && !capable(CAP_SYS_RAWIO))
-		return -EACCES;
 	return 0;
 }

