Return-Path: <linux-kernel-owner+w=401wt.eu-S1755592AbYGLVdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbYGLVdf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 17:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbYGLVd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 17:33:27 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:45306 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbYGLVd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 17:33:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=b6lJ8oo2b1LuKtdXsYC6F48x/hKCl+YDCU1SyTsB16nftChL6bFycEH8Wes1KulAqK
         6jLI5qj37l9h9ASv3tHSjJmtf5W0+WTYBmWCveNqlwDcNfJELIkzIB01h9YOWAI7FR0Q
         IKmf7OX1BspiiD+HKjbBnTH6+4EGKOxubPbpU=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH] x86: max_low_pfn_mapped fix #1
Date: Sat, 12 Jul 2008 14:30:35 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807092017.51004.yhlu.kernel@gmail.com> <200807102038.26591.yhlu.kernel@gmail.com>
In-Reply-To: <200807102038.26591.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807121430.35505.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix crash on Ingo's big box:
calling  pci_iommu_init+0x0/0x17
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ d0000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
BUG: unable to handle kernel paging request at ffff88000003be88
IP: [<ffffffff8026d377>] __alloc_pages_internal+0xc3/0x3f2
PGD 202063 PUD 206063 PMD 22fc00163 PTE 3b162
Oops: 0000 [1] SMP 
CPU 0 
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.26-rc9 #18193
RIP: 0010:[<ffffffff8026d377>]  [<ffffffff8026d377>] __alloc_pages_internal+0xc3/0x3f2
RSP: 0018:ffff88042f08fd40  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 00000000000080d0 RCX: 0000000000000000
RDX: ffff88000003be80 RSI: 0000000000000000 RDI: 00000000000080d0
RBP: 0000000000000000 R08: 0000000000000040 R09: ffff88082f075278
R10: 0000000000000246 R11: 0000000000000002 R12: ffff88000003be80
R13: 0000000000000000 R14: ffff88022f0994e0 R15: 0000000100000000
FS:  0000000000000000(0000) GS:ffffffff806dbb00(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffff88000003be88 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000

and e820 is
 BIOS-e820: 0000000000000000 - 000000000009ac00 (usable)
 BIOS-e820: 000000000009ac00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000ca000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ff70000 (usable)
 BIOS-e820: 000000007ff70000 - 000000007ff86000 (ACPI data)
 BIOS-e820: 000000007ff86000 - 0000000080000000 (ACPI NVS)
 BIOS-e820: 0000000080000000 - 00000000cfe00000 (usable)
 BIOS-e820: 00000000cfe00000 - 00000000d0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000830000000 (usable)

system get 32G ram installed.
max_low_pfn_mapped is 0xcfe00, and gart aperture is not mapped.

so try to use init_memory_mapping to map that area, because iommu think
that area is ram...

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/pci-gart_64.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: linux-2.6/arch/x86/kernel/pci-gart_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/pci-gart_64.c
+++ linux-2.6/arch/x86/kernel/pci-gart_64.c
@@ -631,6 +631,7 @@ static __init int init_k8_gatt(struct ag
 	struct pci_dev *dev;
 	void *gatt;
 	int i, error;
+	unsigned long start_pfn, end_pfn;
 
 	printk(KERN_INFO "PCI-DMA: Disabling AGP.\n");
 	aper_size = aper_base = info->aper_size = 0;
@@ -675,6 +676,16 @@ static __init int init_k8_gatt(struct ag
 
 	printk(KERN_INFO "PCI-DMA: aperture base @ %x size %u KB\n",
 	       aper_base, aper_size>>10);
+
+	/* need to map that range */
+	end_pfn = (aper_base>>PAGE_SHIFT) + (aper_size>>PAGE_SHIFT);
+	if (end_pfn > max_low_pfn_mapped) {
+		start_pfn = max_low_pfn_mapped;
+		max_low_pfn_mapped = init_memory_mapping(start_pfn<<PAGE_SHIFT,
+							 end_pfn<<PAGE_SHIFT);
+		if (max_pfn_mapped < max_low_pfn_mapped)
+			max_pfn_mapped = max_low_pfn_mapped;
+	}
 	return 0;
 
  nommu:
