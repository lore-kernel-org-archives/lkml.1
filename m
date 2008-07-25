Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638AbYGYSg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbYGYSg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 14:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754816AbYGYSgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 14:36:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51302 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbYGYSgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 14:36:00 -0400
Date: Fri, 25 Jul 2008 20:35:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] mm/hugetlb.c: fix build failure
Message-ID: <20080725183549.GA23562@elte.hu>
References: <20080725105741.GA24336@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080725105741.GA24336@elte.hu>
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

> on !CONFIG_SYSCTL on x86 with latest -git i get:
>     
>      mm/hugetlb.c: In function 'decrement_hugepage_resv_vma':
>      mm/hugetlb.c:83: error: 'reserve' undeclared (first use in this function)
>      mm/hugetlb.c:83: error: (Each undeclared identifier is reported only once
>      mm/hugetlb.c:83: error: for each function it appears in.)

the above build error came from a bisection run, the fix i sent was for 
this build error:

  mm/hugetlb.c: In function ‘hugetlb_acct_memory': mm/hugetlb.c:1507:
  error: implicit declaration of function ‘cpuset_mems_nr'

but i also get a second hugetlb build failure on 64-bit x86:

  arch/x86/mm/built-in.o: In function `setup_hugepagesz':
  hugetlbpage.c:(.init.text+0xb49): undefined reference to `hugetlb_add_hstate'

fixed by the patch below.

	Ingo

---------------->
>From 3a13a39219ac145913e51dfddc7c4d912586c15f Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 25 Jul 2008 20:45:52 +0200
Subject: [PATCH] hugetlbfs: fix build failure on 64-bit x86

fix:

 arch/x86/mm/built-in.o: In function `setup_hugepagesz':
 hugetlbpage.c:(.init.text+0xb49): undefined reference to `hugetlb_add_hstate'

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/hugetlbpage.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
index 8f307d9..977d185 100644
--- a/arch/x86/mm/hugetlbpage.c
+++ b/arch/x86/mm/hugetlbpage.c
@@ -425,7 +425,7 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 
 #endif /*HAVE_ARCH_HUGETLB_UNMAPPED_AREA*/
 
-#ifdef CONFIG_X86_64
+#if defined(CONFIG_X86_64) && defined(CONFIG_SYSCTL)
 static __init int setup_hugepagesz(char *opt)
 {
 	unsigned long ps = memparse(opt, &opt);
