Return-Path: <linux-kernel-owner+w=401wt.eu-S1755851AbYGJAwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbYGJAwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 20:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbYGJAwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 20:52:25 -0400
Received: from sh.osrg.net ([192.16.179.4]:58367 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbYGJAwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 20:52:24 -0400
Date: Thu, 10 Jul 2008 09:50:50 +0900
To: mingo@elte.hu
Cc: pavel@suse.cz, joerg.roedel@amd.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 01/34] AMD IOMMU: add Kconfig entry
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080709084837.GA5358@elte.hu>
References: <1214508490-29683-2-git-send-email-joerg.roedel@amd.com>
	<20080708124504.GA16313@elf.ucw.cz>
	<20080709084837.GA5358@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080710095053A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jul 2008 10:48:37 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Pavel Machek <pavel@suse.cz> wrote:
> 
> > > +config AMD_IOMMU
> > > +	bool "AMD IOMMU support"
> > > +	select SWIOTL
> > 
> > SWIOTLB?
> 
> yep, that typo got already fixed via the patch below.
> 
> 	Ingo
> 
> --------------->
> commit 07c40e8a1acdb56fca485a6deeb252ebf19509a1
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Fri Jun 27 11:31:28 2008 +0200
> 
>     x86, AMD IOMMU: build fix #3
>     
>     fix typo causing:
>     
>     arch/x86/kernel/built-in.o: In function `__unmap_single':
>     amd_iommu.c:(.text+0x17771): undefined reference to `iommu_area_free'
>     arch/x86/kernel/built-in.o: In function `__map_single':
>     amd_iommu.c:(.text+0x1797a): undefined reference to `iommu_area_alloc'
>     amd_iommu.c:(.text+0x179a2): undefined reference to `iommu_area_alloc'
>     
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 62a2820..8aae462 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -551,7 +551,7 @@ config CALGARY_IOMMU_ENABLED_BY_DEFAULT
>  
>  config AMD_IOMMU
>  	bool "AMD IOMMU support"
> -	select SWIOTL
> +	select SWIOTLB
>  	depends on X86_64 && PCI && ACPI
>  	help
>  	  Select this to get support for AMD IOMMU hardware in your system.

This fix is fine though the explicit fix is that AMD_IOMMU depends on
IOMMU_HELPER since they are the IOMMU helper functions. SWIOTLB
requires IOMMU_HELPER so declaring that AMD_IOMMU depends on SWIOTLB
properly fixes the problems.


diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f98e1c3..4d85501 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -579,7 +579,7 @@ config SWIOTLB
 	  3 GB of memory. If unsure, say Y.
 
 config IOMMU_HELPER
-	def_bool (CALGARY_IOMMU || GART_IOMMU || SWIOTLB)
+	def_bool (CALGARY_IOMMU || GART_IOMMU || SWIOTLB || AMD_IOMMU)
 config MAXSMP
 	bool "Configure Maximum number of SMP Processors and NUMA Nodes"
 	depends on X86_64 && SMP
