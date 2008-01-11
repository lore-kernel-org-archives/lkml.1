Return-Path: <linux-kernel-owner+w=401wt.eu-S1759249AbYAKDKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249AbYAKDKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 22:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755742AbYAKDKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 22:10:22 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:43933 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbYAKDKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 22:10:21 -0500
Date: Thu, 10 Jan 2008 19:14:47 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86-64: disable the GART early
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <clameter@sgi.com>, ebiederm@xmission.com
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <200801101914.47967.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this one is against to linus tree.
in case some one need to use kexec to new kernel from old kernel with gart_shutdown.

YH

[PATCH] x86-64: disable the GART early

For K8 system: 4G RAM with memory hole remapping enabled, or more than 4G RAM
installed.

when try to use kexec second kernel, and the first doesn't include gart_shutdown.
the second kernel could have different aper position than the first kernel. and second
kernel could use that hole as RAM that is still used by GART set by the first kernel.
esp. when try to kexec 2.6.24 with sparse mem enable from previous kernel (from RHEL 5
or SLES 10). the new kernel will use aper by GART (set by first kernel) for vmemmap.
and after new kernel setting one new GART. the position will be real RAM. the _mapcount
set is lost.


Bad page state in process 'swapper'
page:ffffe2000e600020 flags:0x0000000000000000 mapping:0000000000000000 mapcount:1 count:0
Trying to fix it up, but a reboot is needed
Backtrace:
Pid: 0, comm: swapper Not tainted 2.6.24-rc7-smp-gcdf71a10-dirty #13

Call Trace:
 [<ffffffff8026401f>] bad_page+0x63/0x8d
 [<ffffffff80264169>] __free_pages_ok+0x7c/0x2a5
 [<ffffffff80ba75d1>] free_all_bootmem_core+0xd0/0x198
 [<ffffffff80ba3a42>] numa_free_all_bootmem+0x3b/0x76
 [<ffffffff80ba3461>] mem_init+0x3b/0x152
 [<ffffffff80b959d3>] start_kernel+0x236/0x2c2
 [<ffffffff80b9511a>] _sinittext+0x11a/0x121

and
 [ffffe2000e600000-ffffe2000e7fffff] PMD ->ffff81001c200000 on node 0
phys addr is : 0x1c200000

RHEL 5.1 kernel -53 said:
PCI-DMA: aperture base @ 1c000000 size 65536 KB

new kernel said:
Mapping aperture over 65536 KB of RAM @ 3c000000

So try to disable that GART as early as possible.


Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/kernel/aperture_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/aperture_64.c
+++ linux-2.6/arch/x86/kernel/aperture_64.c
@@ -204,6 +204,73 @@ static __u32 __init search_agp_bridge(u3
 	return 0;
 }
 
+void __init early_gart_iommu_disable(void)
+{
+	/*
+	 * disable it in case it is enabled before, esp for kexec/kdump,
+	 * previous kernel already enable that. otherwise memset called
+	 * by allocate_aperture/__alloc_bootmem_nopanic cause restart.
+	 * or second kernel have different position for GART hole. and new
+	 * kernel could use hole as RAM that is still used by GART set by
+	 * first kernel
+	 */
+	int fix, num;
+	u32 ctl;
+        u32 aper_size, aper_alloc = 0, aper_order = 0, last_aper_order = 0;
+        u64 aper_base, last_aper_base = 0;
+        int valid_agp = 0;
+
+        if (!early_pci_allowed())
+                return;
+
+	fix = 0;
+        for (num = 24; num < 32; num++) {
+                if (!early_is_k8_nb(read_pci_config(0, num, 3, 0x00)))
+                        continue;
+
+                aper_order = (read_pci_config(0, num, 3, 0x90) >> 1) & 7;
+                aper_size = (32 * 1024 * 1024) << aper_order;
+                aper_base = read_pci_config(0, num, 3, 0x94) & 0x7fff;
+                aper_base <<= 25;
+
+                if (!aperture_valid(aper_base, aper_size)) {
+                        fix = 1;
+                        break;
+                }
+
+                if ((last_aper_order && aper_order != last_aper_order) ||
+                    (last_aper_base && aper_base != last_aper_base)) {
+                        fix = 1;
+                        break;
+                }
+                last_aper_order = aper_order;
+                last_aper_base = aper_base;
+        }
+
+	if (!fix)
+		return;
+
+	aper_alloc = search_agp_bridge(&aper_order, &valid_agp);
+
+	if (aper_alloc) {
+		/*
+		 * could get aper later or before from the AGP bridge,
+		 * so it is safe
+		 */
+		return;
+	}
+
+	for (num = 24; num < 32; num++) {
+		if (!early_is_k8_nb(read_pci_config(0, num, 3, 0x00)))
+			continue;
+
+		ctl = read_pci_config(0, num, 3, 0x90);
+		ctl &= ~1;
+		write_pci_config(0, num, 3, 0x90, 0);
+	}
+
+}
+
 void __init gart_iommu_hole_init(void)
 { 
 	int fix, num; 
Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -256,6 +256,8 @@ static void discover_ebda(void)
 		ebda_size = 64*1024;
 }
 
+extern void early_gart_iommu_disable(void);
+
 void __init setup_arch(char **cmdline_p)
 {
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
@@ -309,6 +311,8 @@ void __init setup_arch(char **cmdline_p)
 
 	discover_ebda();
 
+	early_gart_iommu_disable();
+
 	init_memory_mapping(0, (end_pfn_map << PAGE_SHIFT));
 
 	dmi_scan_machine();
