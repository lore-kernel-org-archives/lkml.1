Return-Path: <linux-kernel-owner+w=401wt.eu-S1754150AbXFZGmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbXFZGmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 02:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbXFZGmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 02:42:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52565 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750797AbXFZGmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 02:42:39 -0400
Date: Mon, 25 Jun 2007 23:42:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Cc: linux-kernel@vger.kernel.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       suresh.b.siddha@intel.com, arjan@linux.intel.com, ashok.raj@intel.com,
       davem@davemloft.net, clameter@sgi.com
Subject: Re: [Intel IOMMU 10/10] Iommu floppy workaround
Message-Id: <20070625234222.a1e09a16.akpm@linux-foundation.org>
In-Reply-To: <20070619213809.110034000@askeshav-devel.jf.intel.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com>
	<20070619213809.110034000@askeshav-devel.jf.intel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007 14:37:11 -0700 "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com> wrote:

> 	This config option (DMAR_FLPY_WA) sets up 1:1 mapping for the
> floppy device so that the floppy device which does not use
> DMA api's will continue to work. 
> 
> Once the floppy driver starts using DMA api's this config option
> can be turn off or this patch can be yanked out of kernel at that
> time.
> 
> 
> Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
> ---
>  arch/x86_64/Kconfig       |   10 ++++++++++
>  drivers/pci/intel-iommu.c |   22 ++++++++++++++++++++++
>  drivers/pci/intel-iommu.h |    7 +++++++
>  3 files changed, 39 insertions(+)
> 
> Index: linux-2.6.22-rc4-mm2/arch/x86_64/Kconfig
> ===================================================================
> --- linux-2.6.22-rc4-mm2.orig/arch/x86_64/Kconfig	2007-06-18 15:45:08.000000000 -0700
> +++ linux-2.6.22-rc4-mm2/arch/x86_64/Kconfig	2007-06-18 15:45:09.000000000 -0700
> @@ -752,6 +752,16 @@
>  	 all the OS visible memory. Hence the driver can continue
>  	 to use physical addresses for DMA.
>  
> +config DMAR_FLPY_WA

FLOPPY is spelled "FLOPPY"!

> ===================================================================
> --- linux-2.6.22-rc4-mm2.orig/drivers/pci/intel-iommu.c	2007-06-18 15:45:08.000000000 -0700
> +++ linux-2.6.22-rc4-mm2/drivers/pci/intel-iommu.c	2007-06-18 15:45:09.000000000 -0700
> @@ -1631,6 +1631,26 @@
>  }
>  #endif
>  
> +#ifdef CONFIG_DMAR_FLPY_WA
> +static inline void iommu_prepare_isa(void)
> +{
> +	struct pci_dev *pdev = NULL;
> +	int ret;
> +
> +	pdev = pci_get_class (PCI_CLASS_BRIDGE_ISA << 8, NULL);
> +	if (!pdev)
> +		return;
> +
> +	printk (KERN_INFO "IOMMU: Prepare 0-16M unity mapping for LPC\n");
> +	ret = iommu_prepare_identity_map(pdev, 0, 16*1024*1024);
> +
> +	if (ret)
> +		printk ("IOMMU: Failed to create 0-64M identity map, \
> +			Floppy might not work\n");
> +
> +}
> +#endif
> +
>  int __init init_dmars(void)
>  {
>  	struct dmar_drhd_unit *drhd;
> @@ -1696,6 +1716,8 @@
>  
>  	iommu_prepare_gfx_mapping();
>  
> +	iommu_prepare_isa();
> +
>  	/*
>  	 * for each drhd
>  	 *   enable fault log
> Index: linux-2.6.22-rc4-mm2/drivers/pci/intel-iommu.h
> ===================================================================
> --- linux-2.6.22-rc4-mm2.orig/drivers/pci/intel-iommu.h	2007-06-18 15:45:08.000000000 -0700
> +++ linux-2.6.22-rc4-mm2/drivers/pci/intel-iommu.h	2007-06-18 15:45:09.000000000 -0700
> @@ -322,4 +322,11 @@
>  }
>  #endif /* !CONFIG_DMAR_GFX_WA */
>  
> +#ifndef CONFIG_DMAR_FLPY_WA
> +static inline void iommu_prepare_isa(void)
> +{
> +	return;
> +}
> +#endif /* !CONFIG_DMAR_FLPY_WA */

Bit weird that this was implemented in the header like that.

How about this?  (Also contains rather a lot of obvious style fixes)


 arch/x86_64/Kconfig       |    2 +-
 drivers/pci/intel-iommu.c |   19 ++++++++++++-------
 drivers/pci/intel-iommu.h |    7 -------
 3 files changed, 13 insertions(+), 15 deletions(-)

diff -puN arch/x86_64/Kconfig~intel-iommu-iommu-floppy-workaround-fix arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~intel-iommu-iommu-floppy-workaround-fix
+++ a/arch/x86_64/Kconfig
@@ -770,7 +770,7 @@ config DMAR_GFX_WA
 	 all the OS visible memory. Hence the driver can continue
 	 to use physical addresses for DMA.
 
-config DMAR_FLPY_WA
+config DMAR_FLOPPY_WA
 	bool "Support for Floppy disk workaround"
 	depends on DMAR
 	default y
diff -puN drivers/pci/intel-iommu.c~intel-iommu-iommu-floppy-workaround-fix drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~intel-iommu-iommu-floppy-workaround-fix
+++ a/drivers/pci/intel-iommu.c
@@ -1631,25 +1631,30 @@ error:
 }
 #endif
 
-#ifdef CONFIG_DMAR_FLPY_WA
+#ifdef CONFIG_DMAR_FLOPPY_WA
 static inline void iommu_prepare_isa(void)
 {
-	struct pci_dev *pdev = NULL;
+	struct pci_dev *pdev;
 	int ret;
 
-	pdev = pci_get_class (PCI_CLASS_BRIDGE_ISA << 8, NULL);
+	pdev = pci_get_class(PCI_CLASS_BRIDGE_ISA << 8, NULL);
 	if (!pdev)
 		return;
 
-	printk (KERN_INFO "IOMMU: Prepare 0-16M unity mapping for LPC\n");
+	printk(KERN_INFO "IOMMU: Prepare 0-16M unity mapping for LPC\n");
 	ret = iommu_prepare_identity_map(pdev, 0, 16*1024*1024);
 
 	if (ret)
-		printk ("IOMMU: Failed to create 0-64M identity map, \
-			Floppy might not work\n");
+		printk("IOMMU: Failed to create 0-64M identity map, "
+			"floppy might not work\n");
 
 }
-#endif
+#else
+static inline void iommu_prepare_isa(void)
+{
+	return;
+}
+#endif /* !CONFIG_DMAR_FLPY_WA */
 
 int __init init_dmars(void)
 {
diff -puN drivers/pci/intel-iommu.h~intel-iommu-iommu-floppy-workaround-fix drivers/pci/intel-iommu.h
--- a/drivers/pci/intel-iommu.h~intel-iommu-iommu-floppy-workaround-fix
+++ a/drivers/pci/intel-iommu.h
@@ -322,11 +322,4 @@ static inline void iommu_prepare_gfx_map
 }
 #endif /* !CONFIG_DMAR_GFX_WA */
 
-#ifndef CONFIG_DMAR_FLPY_WA
-static inline void iommu_prepare_isa(void)
-{
-	return;
-}
-#endif /* !CONFIG_DMAR_FLPY_WA */
-
 #endif
_

