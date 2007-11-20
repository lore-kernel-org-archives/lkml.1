Return-Path: <linux-kernel-owner+w=401wt.eu-S1763671AbXKTSds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763671AbXKTSds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:33:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761725AbXKTS1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:27:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51949 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758034AbXKTS1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:27:04 -0500
Date: Tue, 20 Nov 2007 10:24:33 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Beulich <jbeulich@novell.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 18/29] i386: avoid temporarily inconsistent pte-s
Message-ID: <20071120182433.GT28611@kroah.com>
References: <20071120181733.702234406@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-avoid-inconsistent-ptes.patch"
In-Reply-To: <20071120182248.GA28611@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Jan Beulich <jbeulich@novell.com>

patch aa506dc7b12d03fbf8fd11aab752aed1aadd9c07 in mainline.

i386: avoid temporarily inconsistent pte-s

One more of these issues (which were considered fixed a few releases
back): other than on x86-64, i386 allows set_fixmap() to replace
already present mappings. Consequently, on PAE, care must be taken to
not update the high half of a pte while the low half is still holding
the old value.

[ tglx: arch/x86 adaptation ]

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/i386/mm/pgtable.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/i386/mm/pgtable.c
+++ b/arch/i386/mm/pgtable.c
@@ -97,8 +97,7 @@ static void set_pte_pfn(unsigned long va
 	}
 	pte = pte_offset_kernel(pmd, vaddr);
 	if (pgprot_val(flags))
-		/* <pfn,flags> stored as-is, to permit clearing entries */
-		set_pte(pte, pfn_pte(pfn, flags));
+		set_pte_present(&init_mm, vaddr, pte, pfn_pte(pfn, flags));
 	else
 		pte_clear(&init_mm, vaddr, pte);
 

-- 
