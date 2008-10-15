Return-Path: <linux-kernel-owner+w=401wt.eu-S1755063AbYJOVsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063AbYJOVsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 17:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbYJOVs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 17:48:28 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:14348 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbYJOVs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 17:48:28 -0400
Subject: [PATCH] disable CPU side GART accesses
From: Bob Montgomery <bob.montgomery@hp.com>
Reply-To: bob.montgomery@hp.com
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: vojtech@suse.cz, Linus Torvalds <torvalds@linux-foundation.org>,
       chandru@in.ibm.com
Content-Type: text/plain
Organization: Contractor at HP
Date: Wed, 15 Oct 2008 15:48:37 -0600
Message-Id: <1224107317.2215.238.camel@amd.troyhebe>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prevents improper access of the GART aperture from kdump
kernels running on AMD systems.  

Symptoms of the problem include hangs, spurious restarts, and MCE
(Machine Check Exception) panics in some AMD Opteron systems that
enable the GART IOMMU and access /proc/vmcore or /dev/oldmem from a
kdump kernel.  Note that the GART IOMMU will not be enabled on systems
with less than 4 GB of RAM, so symptoms will not appear.  This problem
has been reproduced on Family 10H Quad-Core AMD Opteron systems.

This patch changes the initialization of the GART to set the DISGARTCPU
bit in the GART Aperture Control Register (AMD64_GARTAPERTURECTL).
Setting the bit prevents requests from the CPUs from accessing the
GART.  In other words, CPU memory accesses to the aperture address
range will not cause the GART to perform an address translation.
The aperture area is currently being unmapped at the kernel level
with set_memory_np() in gart_iommu_init to prevent accesses from the
CPU, but that kernel level unmapping is not in effect in the kexec'd
kdump kernel.  By disabling the CPU-side accesses within the GART,
which does persist through the kexec of the kdump kernel, the kdump
kernel is prevented from interacting with the GART during accesses
to the dump memory areas which include the address range of the GART
aperture.  Although the patch can be applied to the kdump kernel,
it is not exercised there because the kdump kernel doesn't attempt
to initialize the GART, since it typically runs in less than 4 GB
of memory.


Signed-off-by: Bob Montgomery <bob.montgomery@hp.com>


--- linux-2.6.27/include/asm-x86/gart.h	2008-10-13 16:36:34.000000000 -0600
+++ linux-2.6.27-fix/include/asm-x86/gart.h	2008-10-14 10:37:32.000000000 -0600
@@ -44,7 +44,8 @@ static inline void enable_gart_translati
         /* Enable GART translation for this hammer. */
         pci_read_config_dword(dev, AMD64_GARTAPERTURECTL, &ctl);
         ctl |= GARTEN;
-        ctl &= ~(DISGARTCPU | DISGARTIO);
+        ctl |= DISGARTCPU;
+        ctl &= ~(DISGARTIO);
         pci_write_config_dword(dev, AMD64_GARTAPERTURECTL, ctl);
 }
 


