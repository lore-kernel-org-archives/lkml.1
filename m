Return-Path: <linux-kernel-owner+w=401wt.eu-S1758212AbZFJDiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbZFJDiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 23:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755910AbZFJDeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 23:34:13 -0400
Received: from kroah.org ([198.145.64.141]:56785 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755962AbZFJDeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 23:34:12 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 17:23:43 2009
Message-Id: <20090610002343.623341993@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 17:13:45 -0700
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
       alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 17/60] x86: work around Fedora-11 x86-32 kernel failures on Intel Atom CPUs
References: <20090610001328.251476848@blue.kroah.org>
Content-Disposition: inline; filename=x86-work-around-fedora-11-x86-32-kernel-failures-on-intel-atom-cpus.patch
In-Reply-To: <20090610032135.GA19346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ingo Molnar <mingo@elte.hu>
commit 211b3d03c7400f48a781977a50104c9d12f4e229 upstream

[Trivial backport to 2.6.27 by cebbert@redhat.com]

x86: work around Fedora-11 x86-32 kernel failures on Intel Atom CPUs

Impact: work around boot crash

Work around Intel Atom erratum AAH41 (probabilistically) - it's triggering
in the field.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Tested-by: Kyle McMartin <kyle@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

---
 arch/x86/mm/pageattr.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -565,6 +565,17 @@ static int split_large_page(pte_t *kpte,
 	ref_prot = pte_pgprot(pte_mkexec(pte_clrhuge(*kpte)));
 	pgprot_val(ref_prot) |= _PAGE_PRESENT;
 	__set_pmd_pte(kpte, address, mk_pte(base, ref_prot));
+
+	/*
+	 * Intel Atom errata AAH41 workaround.
+	 *
+	 * The real fix should be in hw or in a microcode update, but
+	 * we also probabilistically try to reduce the window of having
+	 * a large TLB mixed with 4K TLBs while instruction fetches are
+	 * going on.
+	 */
+	__flush_tlb_all();
+
 	base = NULL;
 
 out_unlock:


