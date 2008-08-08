Return-Path: <linux-kernel-owner+w=401wt.eu-S1753029AbYHHFEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029AbYHHFEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 01:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbYHHFEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 01:04:37 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:54781 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbYHHFEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 01:04:36 -0400
Date: Fri, 8 Aug 2008 15:04:33 +1000
From: Simon Horman <horms@verge.net.au>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jan Beulich <jbeulich@novell.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Allow compile with CONFIG_DEBUG_INFO=y, X86_PAE not set on gcc
	3.4.5
Message-ID: <20080808050429.GA8473@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It appears that "x86: preallocate and prepopulate separately"
(d8d5900ef8afc562088f8470feeaf17c4747790f) introduced a minor regression.
The build fails on gcc 3.4.5 if CONFIG_DEBUG_INFO=y (that is gcc is
called with -g) and X86_PAE not set.

There was previously some discussion of this without resolution.
http://lkml.org/lkml/2008/7/18/250

	arch/x86/mm/pgtable.c: In function `pgd_prepopulate_pmd':
	arch/x86/mm/pgtable.c:222: internal compiler error: in remove_insn, at emit-rtl.c:3746
	Please submit a full bug report,
	with preprocessed source if appropriate.
	See <URL:http://gcc.gnu.org/bugs.html> for instructions.

	# i686-unknown-linux-gnu-gcc --version
	i686-unknown-linux-gnu-gcc (GCC) 3.4.5

My investigations seem to show that gcc 3.4.5 can't cope with the following
construct:

	for (i = 0; i < 0; i++)
		...

or more specifically:

	for (i = 0; i < PREALLOCTED_PMDS; i++)
		...

when PREALLOCTED_PMDS is 0. That is, when X86_PAE is not set.

This patch resolves this problem by moving the relevant code inside
#define X86_PAE and providing dummy functions outside !X86_PAE.

Signed-off-by: Simon Horman <horms@verge.net.au>

Index: linux-2.6/arch/x86/mm/pgtable.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pgtable.c	2008-08-08 14:35:29.000000000 +1000
+++ linux-2.6/arch/x86/mm/pgtable.c	2008-08-08 15:00:07.000000000 +1000
@@ -141,12 +141,6 @@ void pud_populate(struct mm_struct *mm, 
 	if (mm == current->active_mm)
 		write_cr3(read_cr3());
 }
-#else  /* !CONFIG_X86_PAE */
-
-/* No need to prepopulate any pagetable entries in non-PAE modes. */
-#define PREALLOCATED_PMDS	0
-
-#endif	/* CONFIG_X86_PAE */
 
 static void free_pmds(pmd_t *pmds[])
 {
@@ -221,6 +215,19 @@ static void pgd_prepopulate_pmd(struct m
 	}
 }
 
+#else  /* !CONFIG_X86_PAE */
+
+/* No need to prepopulate any pagetable entries in non-PAE modes. */
+#define PREALLOCATED_PMDS	0
+
+static int preallocate_pmds(pmd_t *pmds[]) { return 0; }
+static void pgd_prepopulate_pmd(struct mm_struct *mm, pgd_t *pgd, pmd_t *pmds[])
+{ }
+static void free_pmds(pmd_t *pmds[]) { }
+static void pgd_mop_up_pmds(struct mm_struct *mm, pgd_t *pgdp) { }
+
+#endif	/* CONFIG_X86_PAE */
+
 pgd_t *pgd_alloc(struct mm_struct *mm)
 {
 	pgd_t *pgd;
