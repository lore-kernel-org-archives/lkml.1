Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbXHVBfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbXHVBfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 21:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbXHVBfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 21:35:43 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:40824 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751971AbXHVBfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 21:35:42 -0400
Message-ID: <46CB91BC.2010808@vmware.com>
Date: Tue, 21 Aug 2007 18:30:36 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@osdl.org>
CC: Ben Collins <ben.collins@ubuntu.com>
Subject: [PATCH] Fix lazy mode vmalloc synchronization for paravirt
Content-Type: multipart/mixed;
 boundary="------------060406000404010004030508"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060406000404010004030508
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Found this looping Ubuntu installs with VMI.

If unlucky enough to hit a vmalloc sync fault during a lazy mode 
operation (from an IRQ handler for a module which was not yet populated 
in current page directory, or from inside copy_one_pte, which touches 
swap_map, and hit in an unused 4M region), the required PDE update would 
never get flushed, causing an infinite page fault loop.

This bug affects any paravirt-ops backend which uses lazy updates, I 
believe that makes it a bug in Xen, VMI and lguest.  It only happens on 
LOWMEM kernels.

Currently for 2.6.23, but we'll want to backport to -stable as well.

Zach

--------------060406000404010004030508
Content-Type: text/x-patch;
 name="i386-linus-vmalloc-paravirt-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="i386-linus-vmalloc-paravirt-fix.patch"

    Touching vmalloc memory in the middle of a lazy mode update can generate
    a kernel PDE update, which must be flushed immediately.  The fix is to
    leave lazy mode when doing a vmalloc sync.
    
    Signed-off-by: Zachary Amsden <zach@vmware.com>

diff --git a/arch/i386/mm/fault.c b/arch/i386/mm/fault.c
diff --git a/arch/i386/mm/fault.c b/arch/i386/mm/fault.c
index 01ffdd4..fcb38e7 100644
--- a/arch/i386/mm/fault.c
+++ b/arch/i386/mm/fault.c
@@ -249,9 +249,10 @@ static inline pmd_t *vmalloc_sync_one(pgd_t *pgd, unsigned long address)
 	pmd_k = pmd_offset(pud_k, address);
 	if (!pmd_present(*pmd_k))
 		return NULL;
-	if (!pmd_present(*pmd))
+	if (!pmd_present(*pmd)) {
 		set_pmd(pmd, *pmd_k);
-	else
+		arch_flush_lazy_mmu_mode();
+	} else
 		BUG_ON(pmd_page(*pmd) != pmd_page(*pmd_k));
 	return pmd_k;
 }

--------------060406000404010004030508--
