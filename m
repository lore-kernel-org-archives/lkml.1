Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbYFIUm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbYFIUm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 16:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbYFIUmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 16:42:15 -0400
Received: from ns.suse.de ([195.135.220.2]:54550 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbYFIUmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 16:42:15 -0400
Date: Mon, 9 Jun 2008 22:42:11 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Amul Shah <amul.shah@unisys.com>, Andi Kleen <andi@firstfloor.org>,
       Johannes Weiner <hannes@saeurebad.de>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, anderson@redhat.com,
       "Romer, Benjamin M" <Benjamin.Romer@unisys.com>
Subject: Re: [patch 2/3] Add flags parameter to reserve_bootmem_generic()
Message-ID: <20080609224211.2ef0f74c@kopernikus.site>
In-Reply-To: <20080609202935.GI3542@redhat.com>
References: <20080608134628.757299158@halley.suse.de>
	<20080608134629.743220278@halley.suse.de>
	<87bq2bmvro.fsf@saeurebad.de>
	<20080609132207.GC3542@redhat.com>
	<20080609182341.00d6e746@halley.suse.de>
	<484D5CCB.5020709@firstfloor.org>
	<1213041041.19111.68.camel@ustr-shaha1-linux-dev.na.uis.unisys.com>
	<20080609221732.1e14e5d5@kopernikus.site>
	<20080609202935.GI3542@redhat.com>
Organization: SUSE LINUX Products GmbH
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

* Vivek Goyal <vgoyal@redhat.com> [2008-06-09 16:29]:
>
> Can you please put some more explanation comment here to explain that
> why it is ok to return with success, despite the fact that we never
> reserved any memory.

Do you think that's ok?

    When booting the kdump kernel, the MP tables (for example,
    or other firmware-reserved memory) of the BIOS are beyond
    end_pfn. (kexec-tools adds exactmap parameters to the kernel
    so that the E820 map is no longer used.) Therefore, it's ok
    to return "success" here. For normal boot, the MP tables
    must be reserved normally.



Bernhard

------------------------------------------------------------------------------
From: Bernhard Walle <bwalle@suse.de>
Subject: Add 'flags' parameter to reserve_bootmem_generic()

This patch adds a 'flags' parameter to reserve_bootmem_generic() like it
already has been added in reserve_bootmem() with commit
72a7fe3967dbf86cb34e24fbf1d957fe24d2f246.

It also changes all users to use BOOTMEM_DEFAULT, which doesn't effectively
change the behaviour. Since the change is x86-specific, I don't think it's
necessary to add a new API for migration. There are only 4 users of that
function.

The change is necessary for the next patch, using reserve_bootmem_generic()
for crashkernel reservation.


Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 arch/x86/kernel/e820_64.c |    3 ++-
 arch/x86/kernel/efi_64.c  |    3 ++-
 arch/x86/kernel/mpparse.c |    5 +++--
 arch/x86/mm/init_64.c     |   27 +++++++++++++++++++--------
 include/asm-x86/proto.h   |    2 +-
 5 files changed, 27 insertions(+), 13 deletions(-)

--- a/arch/x86/kernel/e820_64.c
+++ b/arch/x86/kernel/e820_64.c
@@ -118,7 +118,8 @@ void __init early_res_to_bootmem(unsigne
 			continue;
 		printk(KERN_INFO "  early res: %d [%lx-%lx] %s\n", i,
 			final_start, final_end - 1, r->name);
-		reserve_bootmem_generic(final_start, final_end - final_start);
+		reserve_bootmem_generic(final_start, final_end - final_start,
+			BOOTMEM_DEFAULT);
 	}
 }
 
--- a/arch/x86/kernel/efi_64.c
+++ b/arch/x86/kernel/efi_64.c
@@ -100,7 +100,8 @@ void __init efi_call_phys_epilog(void)
 void __init efi_reserve_bootmem(void)
 {
 	reserve_bootmem_generic((unsigned long)memmap.phys_map,
-				memmap.nr_map * memmap.desc_size);
+				memmap.nr_map * memmap.desc_size,
+				BOOTMEM_DEFAULT);
 }
 
 void __iomem * __init efi_ioremap(unsigned long phys_addr, unsigned long size)
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -729,10 +729,11 @@ static int __init smp_scan_config(unsign
 			if (!reserve)
 				return 1;
 
-			reserve_bootmem_generic(virt_to_phys(mpf), PAGE_SIZE);
+			reserve_bootmem_generic(virt_to_phys(mpf), PAGE_SIZE,
+				BOOTMEM_DEFAULT);
 			if (mpf->mpf_physptr)
 				reserve_bootmem_generic(mpf->mpf_physptr,
-							PAGE_SIZE);
+					PAGE_SIZE, BOOTMEM_DEFAULT);
 #endif
 		return 1;
 		}
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -798,24 +798,29 @@ void free_initrd_mem(unsigned long start
 }
 #endif
 
-void __init reserve_bootmem_generic(unsigned long phys, unsigned len)
+int __init reserve_bootmem_generic(unsigned long phys, unsigned len, int flags)
 {
 #ifdef CONFIG_NUMA
 	int nid, next_nid;
 #endif
 	unsigned long pfn = phys >> PAGE_SHIFT;
+	int ret;
 
 	if (pfn >= end_pfn) {
 		/*
-		 * This can happen with kdump kernels when accessing
-		 * firmware tables:
+		 * When booting the kdump kernel, the MP tables (for example,
+		 * or other firmware-reserved memory) of the BIOS are beyond
+		 * end_pfn. (kexec-tools adds exactmap parameters to the kernel
+		 * so that the E820 map is no longer used.) Therefore, it's ok
+		 * to return "success" here. For normal boot, the MP tables
+		 * must be reserved normally.
 		 */
 		if (pfn < max_pfn_mapped)
-			return;
+			return 0;
 
 		printk(KERN_ERR "reserve_bootmem: illegal reserve %lx %u\n",
 				phys, len);
-		return;
+		return -EFAULT;
 	}
 
 	/* Should check here against the e820 map to avoid double free */
@@ -823,17 +828,23 @@ void __init reserve_bootmem_generic(unsi
 	nid = phys_to_nid(phys);
 	next_nid = phys_to_nid(phys + len - 1);
 	if (nid == next_nid)
-		reserve_bootmem_node(NODE_DATA(nid), phys, len, BOOTMEM_DEFAULT);
+		ret = reserve_bootmem_node(NODE_DATA(nid), phys, len, flags);
 	else
-		reserve_bootmem(phys, len, BOOTMEM_DEFAULT);
+		ret = reserve_bootmem(phys, len, flags);
+
 #else
-	reserve_bootmem(phys, len, BOOTMEM_DEFAULT);
+	ret = reserve_bootmem(phys, len, flags);
 #endif
 
+	if (ret != 0)
+		return ret;
+
 	if (phys+len <= MAX_DMA_PFN*PAGE_SIZE) {
 		dma_reserve += len / PAGE_SIZE;
 		set_dma_reserve(dma_reserve);
 	}
+
+	return 0;
 }
 
 int kern_addr_valid(unsigned long addr)
--- a/include/asm-x86/proto.h
+++ b/include/asm-x86/proto.h
@@ -14,7 +14,7 @@ extern void ia32_syscall(void);
 extern void ia32_cstar_target(void);
 extern void ia32_sysenter_target(void);
 
-extern void reserve_bootmem_generic(unsigned long phys, unsigned len);
+extern int reserve_bootmem_generic(unsigned long phys, unsigned len, int flags);
 
 extern void syscall32_cpu_init(void);
 
