Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbZIUVL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbZIUVL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 17:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbZIUVLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 17:11:55 -0400
Received: from claw.goop.org ([74.207.240.146]:40300 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbZIUVLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 17:11:54 -0400
Message-ID: <4AB7EC1D.5010102@goop.org>
Date: Mon, 21 Sep 2009 14:11:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Stable Kernel <stable@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [GIT PULL] xen: Check NX state before setting up GDT mapping
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This is a little followup fix to the previous Xen stack-protector
patches to deal with the case of a 64-bit processor without NX support
(either old Intel or disabled in BIOS).  Before creating the mapping for
the GDT we need to make sure that NX is actually supported or the
processor will fault on us.

This ends up making mm/init.o non-stack-protected.  Given that this file
has some fairly complex functions with local arrays, I've made an
additional change to move the NX setup into its own file to limit the
non-stack-protected code.  I added it as a later delta so that the pure
bugfix can be applied to stable, and the cleanup can go on top into
mainline.

Thanks,
    J

The following changes since commit 79b520e87e1214cfa107bdc8528b5d6c055a8b82:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://oss.sgi.com/xfs/xfs

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git bugfix

Jeremy Fitzhardinge (2):
      xen: check EFER for NX before setting up GDT mapping
      x86: split NX setup into separate file to limit unstack-protected code

 arch/x86/include/asm/pgtable_types.h |    1 +
 arch/x86/mm/Makefile                 |    3 +-
 arch/x86/mm/init.c                   |   63 -------------------------------
 arch/x86/mm/setup_nx.c               |   69 ++++++++++++++++++++++++++++++++++
 arch/x86/xen/enlighten.c             |   10 ++--
 5 files changed, 77 insertions(+), 69 deletions(-)
 create mode 100644 arch/x86/mm/setup_nx.c

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 54cb697..e9918d9 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -277,6 +277,7 @@ static inline pteval_t pte_flags(pte_t pte)
 typedef struct page *pgtable_t;
 
 extern pteval_t __supported_pte_mask;
+extern void set_nx(void);
 extern int nx_enabled;
 
 #define pgprot_writecombine	pgprot_writecombine
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 9b5a9f5..06630d2 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -1,9 +1,10 @@
 obj-y	:=  init.o init_$(BITS).o fault.o ioremap.o extable.o pageattr.o mmap.o \
-	    pat.o pgtable.o physaddr.o gup.o
+	    pat.o pgtable.o physaddr.o gup.o setup_nx.o
 
 # Make sure __phys_addr has no stackprotector
 nostackp := $(call cc-option, -fno-stack-protector)
 CFLAGS_physaddr.o		:= $(nostackp)
+CFLAGS_setup_nx.o		:= $(nostackp)
 
 obj-$(CONFIG_SMP)		+= tlb.o
 
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 0607119..73ffd55 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -28,69 +28,6 @@ int direct_gbpages
 #endif
 ;
 
-int nx_enabled;
-
-#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
-static int disable_nx __cpuinitdata;
-
-/*
- * noexec = on|off
- *
- * Control non-executable mappings for processes.
- *
- * on      Enable
- * off     Disable
- */
-static int __init noexec_setup(char *str)
-{
-	if (!str)
-		return -EINVAL;
-	if (!strncmp(str, "on", 2)) {
-		__supported_pte_mask |= _PAGE_NX;
-		disable_nx = 0;
-	} else if (!strncmp(str, "off", 3)) {
-		disable_nx = 1;
-		__supported_pte_mask &= ~_PAGE_NX;
-	}
-	return 0;
-}
-early_param("noexec", noexec_setup);
-#endif
-
-#ifdef CONFIG_X86_PAE
-static void __init set_nx(void)
-{
-	unsigned int v[4], l, h;
-
-	if (cpu_has_pae && (cpuid_eax(0x80000000) > 0x80000001)) {
-		cpuid(0x80000001, &v[0], &v[1], &v[2], &v[3]);
-
-		if ((v[3] & (1 << 20)) && !disable_nx) {
-			rdmsr(MSR_EFER, l, h);
-			l |= EFER_NX;
-			wrmsr(MSR_EFER, l, h);
-			nx_enabled = 1;
-			__supported_pte_mask |= _PAGE_NX;
-		}
-	}
-}
-#else
-static inline void set_nx(void)
-{
-}
-#endif
-
-#ifdef CONFIG_X86_64
-void __cpuinit check_efer(void)
-{
-	unsigned long efer;
-
-	rdmsrl(MSR_EFER, efer);
-	if (!(efer & EFER_NX) || disable_nx)
-		__supported_pte_mask &= ~_PAGE_NX;
-}
-#endif
-
 static void __init find_early_table_space(unsigned long end, int use_pse,
 					  int use_gbpages)
 {
diff --git a/arch/x86/mm/setup_nx.c b/arch/x86/mm/setup_nx.c
new file mode 100644
index 0000000..513d8ed
--- /dev/null
+++ b/arch/x86/mm/setup_nx.c
@@ -0,0 +1,69 @@
+#include <linux/spinlock.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+
+#include <asm/pgtable.h>
+
+int nx_enabled;
+
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
+static int disable_nx __cpuinitdata;
+
+/*
+ * noexec = on|off
+ *
+ * Control non-executable mappings for processes.
+ *
+ * on      Enable
+ * off     Disable
+ */
+static int __init noexec_setup(char *str)
+{
+	if (!str)
+		return -EINVAL;
+	if (!strncmp(str, "on", 2)) {
+		__supported_pte_mask |= _PAGE_NX;
+		disable_nx = 0;
+	} else if (!strncmp(str, "off", 3)) {
+		disable_nx = 1;
+		__supported_pte_mask &= ~_PAGE_NX;
+	}
+	return 0;
+}
+early_param("noexec", noexec_setup);
+#endif
+
+#ifdef CONFIG_X86_PAE
+void __init set_nx(void)
+{
+	unsigned int v[4], l, h;
+
+	if (cpu_has_pae && (cpuid_eax(0x80000000) > 0x80000001)) {
+		cpuid(0x80000001, &v[0], &v[1], &v[2], &v[3]);
+
+		if ((v[3] & (1 << 20)) && !disable_nx) {
+			rdmsr(MSR_EFER, l, h);
+			l |= EFER_NX;
+			wrmsr(MSR_EFER, l, h);
+			nx_enabled = 1;
+			__supported_pte_mask |= _PAGE_NX;
+		}
+	}
+}
+#else
+void set_nx(void)
+{
+}
+#endif
+
+#ifdef CONFIG_X86_64
+void __cpuinit check_efer(void)
+{
+	unsigned long efer;
+
+	rdmsrl(MSR_EFER, efer);
+	if (!(efer & EFER_NX) || disable_nx)
+		__supported_pte_mask &= ~_PAGE_NX;
+}
+#endif
+
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 0dd0c2c..5d701bf 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1083,6 +1083,11 @@ asmlinkage void __init xen_start_kernel(void)
 
 	__supported_pte_mask |= _PAGE_IOMAP;
 
+#ifdef CONFIG_X86_64
+	/* Work out if we support NX */
+	check_efer();
+#endif
+
 	xen_setup_features();
 
 	/* Get mfn list */
@@ -1123,11 +1128,6 @@ asmlinkage void __init xen_start_kernel(void)
 
 	pgd = (pgd_t *)xen_start_info->pt_base;
 
-#ifdef CONFIG_X86_64
-	/* Work out if we support NX */
-	check_efer();
-#endif
-
 	/* Don't do the full vcpu_info placement stuff until we have a
 	   possible map and a non-dummy shared_info. */
 	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];


