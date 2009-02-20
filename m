Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbZBTHkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbZBTHkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 02:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbZBTHkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 02:40:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45692 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbZBTHkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 02:40:02 -0500
Date: Fri, 20 Feb 2009 08:39:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Huang Ying <ying.huang@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH, v2] x86: use the right protections for split-up pagetables
Message-ID: <20090220073932.GA17648@elte.hu>
References: <20090220011316.379904625@goodmis.org> <alpine.LFD.2.00.0902191753240.21686@localhost.localdomain> <alpine.DEB.1.10.0902192107230.31658@gandalf.stny.rr.com> <alpine.LFD.2.00.0902191923300.21686@localhost.localdomain> <20090220072915.GB28085@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220072915.GB28085@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> I've queued up the fix below in tip:x86/urgent and will send a 
> pull request later today if it passes testing. Steve, does 
> this solve the bug you've hit?

Updated one below - trivial build fix.

	Ingo

--------------------->
>From 07a66d7c53a538e1a9759954a82bb6c07365eff9 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 20 Feb 2009 08:04:13 +0100
Subject: [PATCH] x86: use the right protections for split-up pagetables

Steven Rostedt found a bug in where in his modified kernel
ftrace was unable to modify the kernel text, due to the PMD
itself having been marked read-only as well in
split_large_page().

The fix, suggested by Linus, is to not try to 'clone' the
reference protection of a huge-page, but to use the standard
(and permissive) page protection bits of KERNPG_TABLE.

The 'cloning' makes sense for the ptes but it's a confused and
incorrect concept at the page table level - because the
pagetable entry is a set of all ptes and hence cannot
'clone' any single protection attribute - the ptes can be any
mixture of protections.

With the permissive KERNPG_TABLE, even if the pte protections
get changed after this point (due to ftrace doing code-patching
or other similar activities like kprobes), the resulting combined
protections will still be correct and the pte's restrictive
(or permissive) protections will control it.

Also update the comment.

This bug was there for a long time but has not caused visible
problems before as it needs a rather large read-only area to
trigger. Steve possibly hacked his kernel with some really
large arrays or so. Anyway, the bug is definitely worth fixing.

[ Huang Ying also experienced problems in this area when writing
  the EFI code, but the real bug in split_large_page() was not
  realized back then. ]

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Reported-by: Huang Ying <ying.huang@intel.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/pageattr.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 8ca0d85..7be47d1 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -508,18 +508,13 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 #endif
 
 	/*
-	 * Install the new, split up pagetable. Important details here:
+	 * Install the new, split up pagetable.
 	 *
-	 * On Intel the NX bit of all levels must be cleared to make a
-	 * page executable. See section 4.13.2 of Intel 64 and IA-32
-	 * Architectures Software Developer's Manual).
-	 *
-	 * Mark the entry present. The current mapping might be
-	 * set to not present, which we preserved above.
+	 * We use the standard kernel pagetable protections for the new
+	 * pagetable protections, the actual ptes set above control the
+	 * primary protection behavior:
 	 */
-	ref_prot = pte_pgprot(pte_mkexec(pte_clrhuge(*kpte)));
-	pgprot_val(ref_prot) |= _PAGE_PRESENT;
-	__set_pmd_pte(kpte, address, mk_pte(base, ref_prot));
+	__set_pmd_pte(kpte, address, mk_pte(base, __pgprot(_KERNPG_TABLE)));
 	base = NULL;
 
 out_unlock:
