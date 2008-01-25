Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbYAYFyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbYAYFyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 00:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbYAYFyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 00:54:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:33340 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141AbYAYFyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 00:54:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,248,1199692800"; 
   d="scan'208";a="329729921"
Subject: [PATCH 1/6] x86: fix NX bit handling in change_page_attr
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 25 Jan 2008 13:54:53 +0800
Message-Id: <1201240493.15972.43.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 25 Jan 2008 05:54:10.0173 (UTC) FILETIME=[B477D2D0:01C85F16]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug of change_page_attr/change_page_attr_addr on
Intel i386/x86_64 CPUs.  After changing page attribute to be
executable with these functions, the page remains un-executable on
Intel i386/x86_64 CPU.  Because on Intel i386/x86_64 CPU, only if the
"NX" bits of all three level page tables are cleared (PAE is enabled),
the corresponding page is executable (refer to section 4.13.2 of Intel
64 and IA-32 Architectures Software Developer's Manual).  So, the bug
is fixed through clearing the "NX" bit of PMD when splitting the huge
PMD.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/mm/pageattr.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -124,6 +124,7 @@ static int split_large_page(pte_t *kpte,
 	/*
 	 * Install the new, split up pagetable:
 	 */
+	pgprot_val(ref_prot) &= ~_PAGE_NX;
 	__set_pmd_pte(kpte, address, mk_pte(base, ref_prot));
 	base = NULL;
 

