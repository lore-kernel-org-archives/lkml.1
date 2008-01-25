Return-Path: <linux-kernel-owner+w=401wt.eu-S1760628AbYAYVr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760628AbYAYVr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:47:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757076AbYAYVrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:47:21 -0500
Received: from 42.sub-75-208-60.myvzw.com ([75.208.60.42]:48625 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756781AbYAYVrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:47:20 -0500
X-Greylist: delayed 894 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jan 2008 16:47:20 EST
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 04 of 11] x86: fix early_ioremap pagetable ops
X-Mercurial-Node: de52cce203cd6edeed0d90d539087ee0c398b79c
Message-Id: <de52cce203cd6edeed0d.1201296193@localhost>
In-Reply-To: <patchbomb.1201296189@localhost>
Date: Fri, 25 Jan 2008 13:23:13 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put appropriate pagetable update hooks in so that paravirt knows
what's going on in there.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/mm/ioremap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -18,6 +18,7 @@
 #include <asm/fixmap.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
+#include <asm/pgalloc.h>
 
 #ifdef CONFIG_X86_64
 
@@ -265,7 +266,7 @@ void __init early_ioremap_init(void)
 
 	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
 	memset(bm_pte, 0, sizeof(bm_pte));
-	set_pmd(pmd, __pmd(__pa(bm_pte) | _PAGE_TABLE));
+	pmd_populate_kernel(&init_mm, pmd, bm_pte);
 
 	/*
 	 * The boot-ioremap range spans multiple pmds, for which
@@ -295,6 +296,7 @@ void __init early_ioremap_clear(void)
 
 	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
 	pmd_clear(pmd);
+	paravirt_release_pt(__pa(bm_pte) >> PAGE_SHIFT);
 	__flush_tlb_all();
 }
 


