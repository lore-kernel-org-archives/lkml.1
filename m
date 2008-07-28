Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbYG1VdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbYG1VdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbYG1VdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:33:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbYG1VdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:33:00 -0400
Date: Mon, 28 Jul 2008 18:32:09 -0300
From: Eduardo Habkost <ehabkost@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Eduardo Habkost <ehabkost@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] xen_alloc_ptpage: cast PFN_PHYS() argument to unsigned long
Message-ID: <20080728213209.GF13240@blackpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Oops, I forgot to CC lkml when sending this patch previously. Sorry]

Currently paravirt_ops alloc_p*() uses u32 for the pfn args. We should
change that later, but while the pfn parameter is still u32, we need to
cast the PFN_PHYS() argument at xen_alloc_ptpage() to unsigned long,
otherwise it will lose bits on the shift.

I think PFN_PHYS() should behave better when fed with smaller integers,
but a cast to unsigned long won't be enough for all cases on 32-bit PAE,
and a cast to u64 would be overkill for most users of PFN_PHYS().

We could have two different flavors of PFN_PHYS: one for low pages
only (unsigned long) and another that works for any page (u64)),
but while we don't have it, we will need the cast to unsigned long on
xen_alloc_ptpage().

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index fc4db93..4b50c0a 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -942,7 +942,7 @@ static void xen_alloc_ptpage(struct mm_struct *mm, u32 pfn, unsigned level)
 		SetPagePinned(page);
 
 		if (!PageHighMem(page)) {
-			make_lowmem_page_readonly(__va(PFN_PHYS(pfn)));
+			make_lowmem_page_readonly(__va(PFN_PHYS((unsigned long)pfn)));
 			if (level == PT_PTE)
 				pin_pagetable_pfn(MMUEXT_PIN_L1_TABLE, pfn);
 		} else
-- 
1.5.5.GIT


