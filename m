Return-Path: <linux-kernel-owner+w=401wt.eu-S1759163AbZDHCfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759163AbZDHCfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 22:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758107AbZDHCfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 22:35:04 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:39988 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832AbZDHCfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 22:35:03 -0400
Date: Tue, 07 Apr 2009 22:34:56 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: weidong.han@intel.com, David.Woodhouse@intel.com,
       Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: 2.6.30-rc1 build failure - drivers/pci/dmar.o
Message-id: <alpine.LFD.2.00.0904072224590.4799@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 2.6.30-rc1, drivers/pci/dmar.o fails to build when CONFIG_ACPI=n.

There are two ways to build dmar.o,
CONFIG_DMAR and CONFIG_INTR_REMAP,
and they both depend on CONFIG_ACPI.

The problem appears to be that CONFIG_INTR_REMAP can now be selected
when its dependences are not satisfied.  It seems this regression
starts with the patch below.

Len Brown, Intel Open Source Technology Center


Author: Han, Weidong <weidong.han@intel.com>  2009-04-03 05:15:50
Committer: David Woodhouse <David.Woodhouse@intel.com>  2009-04-04 
05:42:28
Parent: 34aaaa948e3c9dd65b27fa499c5c9e8d8f1227cf (x86, dmar: check if it's 
initialized before disable queue invalidation)
Branches: master, remotes/origin/master
Follows: v2.6.29
Precedes: v2.6.30-rc1

    x2apic/intr-remap: decouple interrupt remapping from x2apic
    
    interrupt remapping must be enabled before enabling x2apic, but
    interrupt remapping doesn't depend on x2apic, it can be used
    separately. Enable interrupt remapping in init_dmars even x2apic
    is not supported.
    
    [dwmw2: Update Kconfig accordingly, fix build with INTR_REMAP && 
!X2APIC]
    
    Signed-off-by: Weidong Han <weidong.han@intel.com>
    Acked-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
------------------------------- arch/x86/Kconfig 
-------------------------------
index 3f27e5c..229cf61 100644
@@ -251,6 +251,7 @@ config SMP
 config X86_X2APIC
 	bool "Support x2apic"
 	depends on X86_LOCAL_APIC && X86_64
+	select INTR_REMAP
 	---help---
 	  This enables x2apic support on CPUs that have this feature.
 
@@ -1879,7 +1880,6 @@ config DMAR_FLOPPY_WA
 config INTR_REMAP
 	bool "Support for Interrupt Remapping (EXPERIMENTAL)"
 	depends on X86_64 && X86_IO_APIC && PCI_MSI && ACPI && 
EXPERIMENTAL
-	select X86_X2APIC
 	---help---
 	  Supports Interrupt remapping for IO-APIC and MSI devices.
 	  To use x2apic mode in the CPU's which support x2APIC 
enhancements or
