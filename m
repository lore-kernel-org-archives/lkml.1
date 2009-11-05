Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbZKECo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbZKECo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 21:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755193AbZKECo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 21:44:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178AbZKECo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 21:44:26 -0500
From: Xiaotian Feng <dfeng@redhat.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>
Subject: [PATCH V2] x86: fix error return sequence in __ioremap_caller
Date: Thu,  5 Nov 2009 10:43:51 +0800
Message-Id: <1257389031-20429-1-git-send-email-dfeng@redhat.com>
In-Reply-To: <20091104105149.GC13194@elte.hu>
References: <20091104105149.GC13194@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel missed to free memtype if get_vm_area_caller failed in __ioremap_caller.
This patch introduces error path to fix this and cleanup the repetitive error
return sequence.  

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/mm/ioremap.c |   24 +++++++++++-------------
 1 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 334e63c..7574575 100644
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
-- 
1.6.2.5

