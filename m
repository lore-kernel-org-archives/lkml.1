Return-Path: <linux-kernel-owner+w=401wt.eu-S1762677AbZBDS6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762677AbZBDS6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758697AbZBDSt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:49:27 -0500
Received: from kroah.org ([198.145.64.141]:60978 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761371AbZBDStT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:49:19 -0500
Date: Wed, 4 Feb 2009 10:46:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
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
       alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@elte.hu>,
       venkatesh.pallipadi@intel.com,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 19/41] x86: fix page attribute corruption with cpa()
Message-ID: <20090204184626.GT25246@kroah.com>
References: <20090204184029.881610776@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-fix-page-attribute-corruption-with-cpa.patch"
In-Reply-To: <20090204184539.GA25246@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Suresh Siddha <suresh.b.siddha@intel.com>

commit a1e46212a410793d575718818e81ddc442a65283 upstream.

Impact: fix sporadic slowdowns and warning messages

This patch fixes a performance issue reported by Linus on his
Nehalem system. While Linus reverted the PAT patch (commit
58dab916dfb57328d50deb0aa9b3fc92efa248ff) which exposed the issue,
existing cpa() code can potentially still cause wrong(page attribute
corruption) behavior.

This patch also fixes the "WARNING: at arch/x86/mm/pageattr.c:560" that
various people reported.

In 64bit kernel, kernel identity mapping might have holes depending
on the available memory and how e820 reports the address range
covering the RAM, ACPI, PCI reserved regions. If there is a 2MB/1GB hole
in the address range that is not listed by e820 entries, kernel identity
mapping will have a corresponding hole in its 1-1 identity mapping.

If cpa() happens on the kernel identity mapping which falls into these
holes,
existing code fails like this:

__change_page_attr_set_clr()
	__change_page_attr()
		returns 0 because of if (!kpte). But doesn't
		set cpa->numpages and cpa->pfn.
	cpa_process_alias()
		uses uninitialized cpa->pfn (random value)
		which can potentially lead to changing the page
		attribute of kernel text/data, kernel identity
		mapping of RAM pages etc. oops!

This bug was easily exposed by another PAT patch which was doing
cpa() more often on kernel identity mapping holes (physical range
between
max_low_pfn_mapped and 4GB), where in here it was setting the
cache disable attribute(PCD) for kernel identity mappings aswell.

Fix cpa() to handle the kernel identity mapping holes. Retain
the WARN() for cpa() calls to other not present address ranges
(kernel-text/data, ioremap() addresses)

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 arch/x86/mm/pageattr.c |   49 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 34 insertions(+), 15 deletions(-)

--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -582,6 +582,36 @@ out_unlock:
 	return 0;
 }
 
+static int __cpa_process_fault(struct cpa_data *cpa, unsigned long vaddr,
+			       int primary)
+{
+	/*
+	 * Ignore all non primary paths.
+	 */
+	if (!primary)
+		return 0;
+
+	/*
+	 * Ignore the NULL PTE for kernel identity mapping, as it is expected
+	 * to have holes.
+	 * Also set numpages to '1' indicating that we processed cpa req for
+	 * one virtual address page and its pfn. TBD: numpages can be set based
+	 * on the initial value and the level returned by lookup_address().
+	 */
+	if (within(vaddr, PAGE_OFFSET,
+		   PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT))) {
+		cpa->numpages = 1;
+		cpa->pfn = __pa(vaddr) >> PAGE_SHIFT;
+		return 0;
+	} else {
+		WARN(1, KERN_WARNING "CPA: called for zero pte. "
+			"vaddr = %lx cpa->vaddr = %lx\n", vaddr,
+			cpa->vaddr);
+
+		return -EINVAL;
+	}
+}
+
 static int __change_page_attr(struct cpa_data *cpa, int primary)
 {
 	unsigned long address = cpa->vaddr;
@@ -592,17 +622,11 @@ static int __change_page_attr(struct cpa
 repeat:
 	kpte = lookup_address(address, &level);
 	if (!kpte)
-		return 0;
+		return __cpa_process_fault(cpa, address, primary);
 
 	old_pte = *kpte;
-	if (!pte_val(old_pte)) {
-		if (!primary)
-			return 0;
-		WARN(1, KERN_WARNING "CPA: called for zero pte. "
-		       "vaddr = %lx cpa->vaddr = %lx\n", address,
-		       cpa->vaddr);
-		return -EINVAL;
-	}
+	if (!pte_val(old_pte))
+		return __cpa_process_fault(cpa, address, primary);
 
 	if (level == PG_LEVEL_4K) {
 		pte_t new_pte;
@@ -676,12 +700,7 @@ static int cpa_process_alias(struct cpa_
 	 * mapping already:
 	 */
 	if (!(within(cpa->vaddr, PAGE_OFFSET,
-		    PAGE_OFFSET + (max_low_pfn_mapped << PAGE_SHIFT))
-#ifdef CONFIG_X86_64
-		|| within(cpa->vaddr, PAGE_OFFSET + (1UL<<32),
-		    PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT))
-#endif
-	)) {
+		    PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT)))) {
 
 		alias_cpa = *cpa;
 		alias_cpa.vaddr = (unsigned long) __va(cpa->pfn << PAGE_SHIFT);

