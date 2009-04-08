Return-Path: <linux-kernel-owner+w=401wt.eu-S1761504AbZDHCsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761504AbZDHCsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 22:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759174AbZDHCsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 22:48:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:17165 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761291AbZDHCsO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 22:48:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,341,1235980800"; 
   d="scan'208";a="504530732"
From: "Han, Weidong" <weidong.han@intel.com>
To: "'Len Brown'" <lenb@kernel.org>,
       "Woodhouse, David" <david.woodhouse@intel.com>,
       "'Ingo Molnar'" <mingo@elte.hu>
CC: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       "'Jesse Barnes'" <jbarnes@virtuousgeek.org>
Date: Wed, 8 Apr 2009 10:46:28 +0800
Subject: RE: 2.6.30-rc1 build failure - drivers/pci/dmar.o
Thread-Topic: 2.6.30-rc1 build failure - drivers/pci/dmar.o
Thread-Index: Acm38p+17FqYfU/kQo+9CT7yWQGkxgAAOCVQ
Message-ID: <715D42877B251141A38726ABF5CABF2C01A2F7C978@pdsmsx503.ccr.corp.intel.com>
References: <alpine.LFD.2.00.0904072224590.4799@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904072224590.4799@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's found and fixed by Ingo and David yesterday. The patch is posted belew. Ingo said he applied it to x86/urgent and will get it to Linus.

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4b34082..bc25b9f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -252,17 +252,13 @@ config SMP
 
 config X86_X2APIC
 	bool "Support x2apic"
-	depends on X86_LOCAL_APIC && X86_64
-	select INTR_REMAP
+	depends on X86_LOCAL_APIC && X86_64 && INTR_REMAP
 	---help---
 	  This enables x2apic support on CPUs that have this feature.
 
 	  This allows 32-bit apic IDs (so it can support very large systems),
 	  and accesses the local apic via MSRs not via mmio.
 
-	  ( On certain CPU models you may need to enable INTR_REMAP too,
-	    to get functional x2apic mode. )
-
 	  If you don't know what to do here, say N.
 
 config SPARSE_IRQ


Regards,
Weidong

Len Brown wrote:
> In 2.6.30-rc1, drivers/pci/dmar.o fails to build when CONFIG_ACPI=n.
> 
> There are two ways to build dmar.o,
> CONFIG_DMAR and CONFIG_INTR_REMAP,
> and they both depend on CONFIG_ACPI.
> 
> The problem appears to be that CONFIG_INTR_REMAP can now be selected
> when its dependences are not satisfied.  It seems this regression
> starts with the patch below.
> 
> Len Brown, Intel Open Source Technology Center
> 
> 
> Author: Han, Weidong <weidong.han@intel.com>  2009-04-03 05:15:50
> Committer: David Woodhouse <David.Woodhouse@intel.com>  2009-04-04
> 05:42:28
> Parent: 34aaaa948e3c9dd65b27fa499c5c9e8d8f1227cf (x86, dmar: check if
> it's initialized before disable queue invalidation)
> Branches: master, remotes/origin/master
> Follows: v2.6.29
> Precedes: v2.6.30-rc1
> 
>     x2apic/intr-remap: decouple interrupt remapping from x2apic
> 
>     interrupt remapping must be enabled before enabling x2apic, but
>     interrupt remapping doesn't depend on x2apic, it can be used
>     separately. Enable interrupt remapping in init_dmars even x2apic
>     is not supported.
> 
>     [dwmw2: Update Kconfig accordingly, fix build with INTR_REMAP &&
> !X2APIC]
> 
>     Signed-off-by: Weidong Han <weidong.han@intel.com>
>     Acked-by: Ingo Molnar <mingo@elte.hu>
>     Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> ------------------------------- arch/x86/Kconfig
> -------------------------------
> index 3f27e5c..229cf61 100644
> @@ -251,6 +251,7 @@ config SMP
>  config X86_X2APIC
>  	bool "Support x2apic"
>  	depends on X86_LOCAL_APIC && X86_64
> +	select INTR_REMAP
>  	---help---
>  	  This enables x2apic support on CPUs that have this feature.
> 
> @@ -1879,7 +1880,6 @@ config DMAR_FLOPPY_WA
>  config INTR_REMAP
>  	bool "Support for Interrupt Remapping (EXPERIMENTAL)"
>  	depends on X86_64 && X86_IO_APIC && PCI_MSI && ACPI &&
> EXPERIMENTAL
> -	select X86_X2APIC
>  	---help---
>  	  Supports Interrupt remapping for IO-APIC and MSI devices.
>  	  To use x2apic mode in the CPU's which support x2APIC
> enhancements or

