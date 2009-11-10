Return-Path: <linux-kernel-owner+w=401wt.eu-S1757419AbZKJRkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbZKJRkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 12:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757167AbZKJRkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 12:40:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51090 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756395AbZKJRkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 12:40:42 -0500
Date: Tue, 10 Nov 2009 18:40:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20091110174032.GA30851@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Borislav Petkov (1):
      x86, amd-ucode: Check UCODE_MAGIC before loading the container file

Simon Kagstrom (1):
      x86: Add Phoenix/MSC BIOSes to lowmem corruption list

Xiaotian Feng (1):
      x86: Fix error return sequence in __ioremap_caller()


 arch/x86/kernel/microcode_amd.c |    6 ++++++
 arch/x86/kernel/setup.c         |    7 +++++++
 arch/x86/mm/ioremap.c           |   24 +++++++++++-------------
 3 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 366baa1..f4c538b 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -317,6 +317,12 @@ static enum ucode_state request_microcode_fw(int cpu, struct device *device)
 		return UCODE_NFOUND;
 	}
 
+	if (*(u32 *)firmware->data != UCODE_MAGIC) {
+		printk(KERN_ERR "microcode: invalid UCODE_MAGIC (0x%08x)\n",
+		       *(u32 *)firmware->data);
+		return UCODE_ERROR;
+	}
+
 	ret = generic_load_microcode(cpu, firmware->data, firmware->size);
 
 	release_firmware(firmware);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index e09f0e2..2a34f9c 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -660,6 +660,13 @@ static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
 		},
 	},
 	{
+		.callback = dmi_low_memory_corruption,
+		.ident = "Phoenix/MSC BIOS",
+		.matches = {
+			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix/MSC"),
+		},
+	},
+	{
 	/*
 	 * AMI BIOS with low memory corruption was found on Intel DG45ID board.
 	 * It hase different DMI_BIOS_VENDOR = "Intel Corp.", for now we will
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 334e63c..2feb9bd 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -170,8 +170,7 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 				(unsigned long long)phys_addr,
 				(unsigned long long)(phys_addr + size),
 				prot_val, new_prot_val);
-			free_memtype(phys_addr, phys_addr + size);
-			return NULL;
+			goto err_free_memtype;
 		}
 		prot_val = new_prot_val;
 	}
@@ -197,26 +196,25 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 	 */
 	area = get_vm_area_caller(size, VM_IOREMAP, caller);
 	if (!area)
-		return NULL;
+		goto err_free_memtype;
 	area->phys_addr = phys_addr;
 	vaddr = (unsigned long) area->addr;
 
-	if (kernel_map_sync_memtype(phys_addr, size, prot_val)) {
-		free_memtype(phys_addr, phys_addr + size);
-		free_vm_area(area);
-		return NULL;
-	}
+	if (kernel_map_sync_memtype(phys_addr, size, prot_val))
+		goto err_free_area;
 
-	if (ioremap_page_range(vaddr, vaddr + size, phys_addr, prot)) {
-		free_memtype(phys_addr, phys_addr + size);
-		free_vm_area(area);
-		return NULL;
-	}
+	if (ioremap_page_range(vaddr, vaddr + size, phys_addr, prot))
+		goto err_free_area;
 
 	ret_addr = (void __iomem *) (vaddr + offset);
 	mmiotrace_ioremap(unaligned_phys_addr, unaligned_size, ret_addr);
 
 	return ret_addr;
+err_free_area:
+	free_vm_area(area);
+err_free_memtype:
+	free_memtype(phys_addr, phys_addr + size);
+	return NULL;
 }
 
 /**
