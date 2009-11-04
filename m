Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbZKDGsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbZKDGsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 01:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbZKDGsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 01:48:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbZKDGsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 01:48:37 -0500
From: Xiaotian Feng <dfeng@redhat.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>
Subject: [PATCH] x86: add missing free_memtype if get_vm_area_caller failed
Date: Wed,  4 Nov 2009 14:48:09 +0800
Message-Id: <1257317289-21951-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When __ioremap_caller goes into get_vm_area, kernel already reserved
memtype. so if get_vm_area fails, we need to free it before return.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/mm/ioremap.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 334e63c..7859f77 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -196,8 +196,10 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 	 * Ok, go for it..
 	 */
 	area = get_vm_area_caller(size, VM_IOREMAP, caller);
-	if (!area)
+	if (!area) {
+		free_memtype(phys_addr, phys_addr + size);
 		return NULL;
+	}
 	area->phys_addr = phys_addr;
 	vaddr = (unsigned long) area->addr;
 
-- 
1.6.2.5

