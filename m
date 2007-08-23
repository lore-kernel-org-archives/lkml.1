Return-Path: <linux-kernel-owner+w=401wt.eu-S933325AbXHWW3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933325AbXHWW3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932484AbXHWW2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:28:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50662 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283AbXHWW2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:28:10 -0400
Date: Thu, 23 Aug 2007 15:26:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, zach@vmware.com, ak@suse.de, jeremy@goop.org
Subject: [patch 05/28] i386: fix lazy mode vmalloc synchronization for
	paravirt
Message-ID: <20070823222615.GF18559@kroah.com>
References: <20070823220656.101239233@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="i386-fix-lazy-mode-vmalloc-synchronization-for-paravirt.patch"
In-Reply-To: <20070823221811.GA18559@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zachary Amsden <zach@vmware.com>

Found this looping Ubuntu installs with VMI.

If unlucky enough to hit a vmalloc sync fault during a lazy mode
operation (from an IRQ handler for a module which was not yet populated
in current page directory, or from inside copy_one_pte, which touches
swap_map, and hit in an unused 4M region), the required PDE update would
never get flushed, causing an infinite page fault loop.

This bug affects any paravirt-ops backend which uses lazy updates, I
believe that makes it a bug in Xen, VMI and lguest.  It only happens on
LOWMEM kernels.


Touching vmalloc memory in the middle of a lazy mode update can generate a
kernel PDE update, which must be flushed immediately.  The fix is to leave
lazy mode when doing a vmalloc sync.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/i386/mm/fault.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/i386/mm/fault.c
+++ b/arch/i386/mm/fault.c
@@ -249,9 +249,10 @@ static inline pmd_t *vmalloc_sync_one(pg
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

-- 
