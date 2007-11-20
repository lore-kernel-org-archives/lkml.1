Return-Path: <linux-kernel-owner+w=401wt.eu-S1763992AbXKTSe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763992AbXKTSe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761814AbXKTS1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:27:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51992 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761790AbXKTS1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:27:17 -0500
Date: Tue, 20 Nov 2007 10:24:43 -0800
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
       Huang Ying <ying.huang@intel.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 21/29] x86: NX bit handling in change_page_attr()
Message-ID: <20071120182443.GW28611@kroah.com>
References: <20071120181733.702234406@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-nx-bit-handling-in-change-page-attr.patch"
In-Reply-To: <20071120182248.GA28611@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Huang, Ying <ying.huang@intel.com>

patch 84e0fdb1754d066dd0a8b257de7299f392d1e727 in mainline.

x86: NX bit handling in change_page_attr()

This patch fixes a bug of change_page_attr/change_page_attr_addr on
Intel x86_64 CPUs.  After changing page attribute to be executable with
these functions, the page remains un-executable on Intel x86_64 CPU.
Because on Intel x86_64 CPU, only if the "NX" bits of all four level
page tables are cleared, the corresponding page is executable (refer to
section 4.13.2 of Intel 64 and IA-32 Architectures Software Developer's
Manual).  So, the bug is fixed through clearing the "NX" bit of PMD when
splitting the huge PMD.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86_64/mm/pageattr.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86_64/mm/pageattr.c
+++ b/arch/x86_64/mm/pageattr.c
@@ -148,6 +148,7 @@ __change_page_attr(unsigned long address
 			split = split_large_page(address, prot, ref_prot2);
 			if (!split)
 				return -ENOMEM;
+			pgprot_val(ref_prot2) &= ~_PAGE_NX;
 			set_pte(kpte, mk_pte(split, ref_prot2));
 			kpte_page = split;
 		}

-- 
