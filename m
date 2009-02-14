Return-Path: <linux-kernel-owner+w=401wt.eu-S1764607AbZBNB15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764607AbZBNB15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:27:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764088AbZBNBQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:16:00 -0500
Received: from kroah.org ([198.145.64.141]:50114 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763257AbZBNBP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:15:59 -0500
Date: Fri, 13 Feb 2009 17:12:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alok N Kataria <akataria@vmware.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 01/48] x86, vmi: put a missing paravirt_release_pmd in
	pgd_dtor
Message-ID: <20090214011221.GB17706@kroah.com>
References: <20090214010805.419403436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-vmi-put-a-missing-paravirt_release_pmd-in-pgd_dtor.patch"
In-Reply-To: <20090214011208.GA17706@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alok Kataria <akataria@vmware.com>

commit 55a8ba4b7f76bebd7e8ce3f74c04b140627a1bad upstream.

Commit 6194ba6ff6ccf8d5c54c857600843c67aa82c407 ("x86: don't special-case
pmd allocations as much") made changes to the way we handle pmd allocations,
and while doing that it dropped a call to  paravirt_release_pd on the
pgd page from the pgd_dtor code path.

As a result of this missing release, the hypervisor is now unaware of the
pgd page being freed, and as a result it ends up tracking this page as a
page table page.

After this the guest may start using the same page for other purposes, and
depending on what use the page is put to, it may result in various performance
and/or functional issues ( hangs, reboots).

Since this release is only required for VMI, I now release the pgd page from
the (vmi)_pgd_free hook.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/vmi_32.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -430,6 +430,16 @@ static void vmi_release_pmd(unsigned lon
 }
 
 /*
+ * We use the pgd_free hook for releasing the pgd page:
+ */
+static void vmi_pgd_free(struct mm_struct *mm, pgd_t *pgd)
+{
+	unsigned long pfn = __pa(pgd) >> PAGE_SHIFT;
+
+	vmi_ops.release_page(pfn, VMI_PAGE_L2);
+}
+
+/*
  * Helper macros for MMU update flags.  We can defer updates until a flush
  * or page invalidation only if the update is to the current address space
  * (otherwise, there is no flush).  We must check against init_mm, since
@@ -881,6 +891,7 @@ static inline int __init activate_vmi(vo
 	if (vmi_ops.release_page) {
 		pv_mmu_ops.release_pte = vmi_release_pte;
 		pv_mmu_ops.release_pmd = vmi_release_pmd;
+		pv_mmu_ops.pgd_free = vmi_pgd_free;
 	}
 
 	/* Set linear is needed in all cases */

