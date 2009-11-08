Return-Path: <linux-kernel-owner+w=401wt.eu-S1752070AbZKHLv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbZKHLv5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 06:51:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbZKHLv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 06:51:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:55741 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbZKHLvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 06:51:55 -0500
Date: Sun, 8 Nov 2009 11:51:39 GMT
From: tip-bot for Xiaotian Feng <dfeng@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, dfeng@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, dfeng@redhat.com, mingo@elte.hu
In-Reply-To: <1257389031-20429-1-git-send-email-dfeng@redhat.com>
References: <1257389031-20429-1-git-send-email-dfeng@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix error return sequence in __ioremap_caller()
Message-ID: <tip-de2a47cf2b3f59ef9664b277f4021b91af13598e@git.kernel.org>
Git-Commit-ID: de2a47cf2b3f59ef9664b277f4021b91af13598e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  de2a47cf2b3f59ef9664b277f4021b91af13598e
Gitweb:     http://git.kernel.org/tip/de2a47cf2b3f59ef9664b277f4021b91af13598e
Author:     Xiaotian Feng <dfeng@redhat.com>
AuthorDate: Thu, 5 Nov 2009 10:43:51 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Nov 2009 12:48:58 +0100

x86: Fix error return sequence in __ioremap_caller()

kernel missed to free memtype if get_vm_area_caller failed in
__ioremap_caller.

This patch introduces error path to fix this and cleans up the
repetitive error return sequences that contributed to the
creation of the bug.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <1257389031-20429-1-git-send-email-dfeng@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/ioremap.c |   24 +++++++++++-------------
 1 files changed, 11 insertions(+), 13 deletions(-)

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
