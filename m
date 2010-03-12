Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264Ab0CLOnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 09:43:08 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:50962 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756373Ab0CLOnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 09:43:05 -0500
Date: Fri, 12 Mar 2010 15:43:03 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, x86 <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?J=F6rg_R=F6del?= <joerg.roedel@amd.com>
Subject: [PATCH -v2] x86, k8 nb: Enable k8_northbridges unconditionally on
 AMD
Message-ID: <20100312144303.GA29262@aftab>
References: <20100308170637.GA26565@aftab>
 <20100311132202.GF11837@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100311132202.GF11837@elte.hu>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Thu, Mar 11, 2010 at 02:22:02PM +0100

> alas, your patch doesnt always build:
> 
> drivers/built-in.o: In function `agp_amd64_probe':
> amd64-agp.c:(.devinit.text+0x81d2): undefined reference to `cache_k8_northbridges'
> amd64-agp.c:(.devinit.text+0x8207): undefined reference to `k8_northbridges'
> amd64-agp.c:(.devinit.text+0x8409): undefined reference to `num_k8_northbridges'
> amd64-agp.c:(.devinit.text+0x8500): undefined reference to `k8_northbridges'

Ok, this is because this patch inverts dependencies and I need AGP_AMD64
and GART_IOMMU to depend explicitly on K8_NB, which is the more natural
thing to do. Here's a better version, it survived a couple of hundred
randconfig builds last night:

--
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Mon, 8 Mar 2010 14:27:01 +0100
Subject: [PATCH -v2] x86, k8 nb: Enable k8_northbridges unconditionally on AMD

de957628ce7c84764ff41331111036b3ae5bad0f changed setting of the
x86_init.iommu.iommu_init function ptr only when GART IOMMU is found.

One side effect of it is that num_k8_northbridges
is not initialized anymore if not explicitly
called. This resulted in uninitialized pointers in
<arch/x86/kernel/cpu/intel_cacheinfo.c:amd_calc_l3_indices()>,
for example, which uses the num_k8_northbridges thing through
node_to_k8_nb_misc().

Fix that through an initcall that runs right after the PCI subsystem and
does all the scanning. Then, remove initialization in gart_iommu_init()
which is a rootfs_initcall and we're running before that.

What is more, since num_k8_northbridges is being used in other places
beside GART IOMMU, include it whenever we add AMD CPU support. The
previous dependency chain in kconfig contained

K8_NB depends on AGP_AMD64|GART_IOMMU

which was clearly incorrect. The more natural way in terms of hardware
dependency should be

AGP_AMD64|GART_IOMMU depends on K8_NB depends on CPU_SUP_AMD && PCI.
Make it so Number One!

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Tested-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/Kconfig              |    4 ++--
 arch/x86/kernel/k8.c          |   14 ++++++++++++++
 arch/x86/kernel/pci-gart_64.c |    2 +-
 drivers/char/agp/Kconfig      |    2 +-
 4 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e984403..736b1b6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -659,7 +659,7 @@ config GART_IOMMU
 	bool "GART IOMMU support" if EMBEDDED
 	default y
 	select SWIOTLB
-	depends on X86_64 && PCI
+	depends on X86_64 && PCI && K8_NB
 	---help---
 	  Support for full DMA access of devices with 32bit memory access only
 	  on systems with more than 3GB. This is usually needed for USB,
@@ -2058,7 +2058,7 @@ endif # X86_32
 
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
-- 
1.7.0.2


-- 
Regards/Gruss,
Boris.

-
Advanced Micro Devices, Inc.
Operating Systems Research Center
