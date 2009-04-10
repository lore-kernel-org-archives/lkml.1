Return-Path: <linux-kernel-owner+w=401wt.eu-S938073AbZDJMgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938073AbZDJMgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937867AbZDJMfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:35:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:45698 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937770AbZDJMft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:35:49 -0400
Date: Fri, 10 Apr 2009 12:33:58 GMT
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090409212708.373330000@intel.com>
References: <20090409212708.373330000@intel.com>
Subject: [tip:x86/pat] x86, CPA: Change idmap attribute before ioremap attribute setup
Message-ID: <tip-43a432b1559798d33970261f710030f787770231@git.kernel.org>
Git-Commit-ID: 43a432b1559798d33970261f710030f787770231
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Apr 2009 12:33:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  43a432b1559798d33970261f710030f787770231
Gitweb:     http://git.kernel.org/tip/43a432b1559798d33970261f710030f787770231
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Thu, 9 Apr 2009 14:26:47 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Apr 2009 13:55:46 +0200

x86, CPA: Change idmap attribute before ioremap attribute setup

Change the identity mapping with the requested attribute first, before
we setup the virtual memory mapping with the new requested attribute.

This makes sure that there is no window when identity map'ed attribute
may disagree with ioremap range on the attribute type.

This also avoids doing cpa on the ioremap'ed address twice (first in
ioremap_page_range and then in ioremap_change_attr using vaddr), and
should improve ioremap performance a bit.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
LKML-Reference: <20090409212708.373330000@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/ioremap.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 0dfa09d..329387e 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -280,15 +280,16 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 		return NULL;
 	area->phys_addr = phys_addr;
 	vaddr = (unsigned long) area->addr;
-	if (ioremap_page_range(vaddr, vaddr + size, phys_addr, prot)) {
+
+	if (kernel_map_sync_memtype(phys_addr, size, prot_val)) {
 		free_memtype(phys_addr, phys_addr + size);
 		free_vm_area(area);
 		return NULL;
 	}
 
-	if (ioremap_change_attr(vaddr, size, prot_val) < 0) {
+	if (ioremap_page_range(vaddr, vaddr + size, phys_addr, prot)) {
 		free_memtype(phys_addr, phys_addr + size);
-		vunmap(area->addr);
+		free_vm_area(area);
 		return NULL;
 	}
 
