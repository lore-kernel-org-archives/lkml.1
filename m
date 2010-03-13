Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab0CMM1p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 07:27:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:37870 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720Ab0CMM1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 07:27:43 -0500
Date: Sat, 13 Mar 2010 12:26:32 GMT
From: tip-bot for Borislav Petkov <bp@amd64.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp, bp@amd64.org,
       tglx@linutronix.de, mingo@elte.hu, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp, bp@amd64.org,
       tglx@linutronix.de, mingo@elte.hu, borislav.petkov@amd.com
In-Reply-To: <20100312144303.GA29262@aftab>
References: <20100312144303.GA29262@aftab>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, k8 nb: Fix boot crash: enable k8_northbridges unconditionally on AMD systems
Message-ID: <tip-0e152cd7c16832bd5cadee0c2e41d9959bc9b6f9@git.kernel.org>
Git-Commit-ID: 0e152cd7c16832bd5cadee0c2e41d9959bc9b6f9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 13 Mar 2010 12:26:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0e152cd7c16832bd5cadee0c2e41d9959bc9b6f9
Gitweb:     http://git.kernel.org/tip/0e152cd7c16832bd5cadee0c2e41d9959bc9b6f9
Author:     Borislav Petkov <bp@amd64.org>
AuthorDate: Fri, 12 Mar 2010 15:43:03 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 13 Mar 2010 08:36:16 +0100

x86, k8 nb: Fix boot crash: enable k8_northbridges unconditionally on AMD systems

de957628ce7c84764ff41331111036b3ae5bad0f changed setting of the
x86_init.iommu.iommu_init function ptr only when GART IOMMU is
found.

One side effect of it is that num_k8_northbridges
is not initialized anymore if not explicitly
called. This resulted in uninitialized pointers in
<arch/x86/kernel/cpu/intel_cacheinfo.c:amd_calc_l3_indices()>,
for example, which uses the num_k8_northbridges thing through
node_to_k8_nb_misc().

Fix that through an initcall that runs right after the PCI
subsystem and does all the scanning. Then, remove initialization
in gart_iommu_init() which is a rootfs_initcall and we're
running before that.

What is more, since num_k8_northbridges is being used in other
places beside GART IOMMU, include it whenever we add AMD CPU
support. The previous dependency chain in kconfig contained

K8_NB depends on AGP_AMD64|GART_IOMMU

which was clearly incorrect. The more natural way in terms of
hardware dependency should be

AGP_AMD64|GART_IOMMU depends on K8_NB depends on CPU_SUP_AMD &&
PCI. Make it so Number One!

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Joerg Roedel <joerg.roedel@amd.com>
LKML-Reference: <20100312144303.GA29262@aftab>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Tested-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/Kconfig              |    4 ++--
 arch/x86/kernel/k8.c          |   14 ++++++++++++++
 arch/x86/kernel/pci-gart_64.c |    2 +-
 drivers/char/agp/Kconfig      |    2 +-
 4 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index eb40925..ddb52b8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -627,7 +627,7 @@ config GART_IOMMU
 	bool "GART IOMMU support" if EMBEDDED
 	default y
 	select SWIOTLB
-	depends on X86_64 && PCI
+	depends on X86_64 && PCI && K8_NB
 	---help---
 	  Support for full DMA access of devices with 32bit memory access only
 	  on systems with more than 3GB. This is usually needed for USB,
@@ -2026,7 +2026,7 @@ endif # X86_32
 
 config K8_NB
 	def_bool y
-	depends on AGP_AMD64 || (X86_64 && (GART_IOMMU || (PCI && NUMA)))
+	depends on CPU_SUP_AMD && PCI
 
 source "drivers/pcmcia/Kconfig"
 
diff --git a/arch/x86/kernel/k8.c b/arch/x86/kernel/k8.c
index cbc4332..9b89546 100644
--- a/arch/x86/kernel/k8.c
+++ b/arch/x86/kernel/k8.c
@@ -121,3 +121,17 @@ void k8_flush_garts(void)
 }
 EXPORT_SYMBOL_GPL(k8_flush_garts);
 
+static __init int init_k8_nbs(void)
+{
+	int err = 0;
+
+	err = cache_k8_northbridges();
+
+	if (err < 0)
+		printk(KERN_NOTICE "K8 NB: Cannot enumerate AMD northbridges.\n");
+
+	return err;
+}
+
+/* This has to go after the PCI subsystem */
+fs_initcall(init_k8_nbs);
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 34de53b..f3af115 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -735,7 +735,7 @@ int __init gart_iommu_init(void)
 	unsigned long scratch;
 	long i;
 
-	if (cache_k8_northbridges() < 0 || num_k8_northbridges == 0)
+	if (num_k8_northbridges == 0)
 		return 0;
 
 #ifndef CONFIG_AGP_AMD64
diff --git a/drivers/char/agp/Kconfig b/drivers/char/agp/Kconfig
index 2fb3a48..4b66c69 100644
--- a/drivers/char/agp/Kconfig
+++ b/drivers/char/agp/Kconfig
@@ -57,7 +57,7 @@ config AGP_AMD
 
 config AGP_AMD64
 	tristate "AMD Opteron/Athlon64 on-CPU GART support"
-	depends on AGP && X86
+	depends on AGP && X86 && K8_NB
 	help
 	  This option gives you AGP support for the GLX component of
 	  X using the on-CPU northbridge of the AMD Athlon64/Opteron CPUs.
