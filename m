Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbYFGDxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbYFGDxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 23:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbYFGDxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 23:53:21 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:56379 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbYFGDxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 23:53:21 -0400
Date: Sat, 7 Jun 2008 04:49:22 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Chris Wright <chrisw@sous-sol.org>
cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/50] 2.6.25.6 -stable review
In-Reply-To: <20080607010215.358296706@sous-sol.org>
Message-ID: <Pine.LNX.4.64.0806070444030.18246@blonde.site>
References: <20080607010215.358296706@sous-sol.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008, Chris Wright wrote:
> This is the start of the stable review cycle for the 2.6.25.6 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let us know.  If anyone is a maintainer of the proper subsystem, and
> wants to add a Signed-off-by: line to the patch, please respond with it.

Please add 2.6.26-rc5's 2884f110d5409714f3a04eeb6d2ecd77da66b242
into 2.6.25.6: it's actually not a serious problem, but it does
look as if it's a serious problem, so we should stamp it out.

Thanks,
Hugh

x86: fix bad pmd ffff810000207xxx(9090909090909090)

OGAWA Hirofumi and Fede have reported rare pmd_ERROR messages:
mm/memory.c:127: bad pmd ffff810000207xxx(9090909090909090).

Initialization's cleanup_highmap was leaving alignment filler
behind in the pmd for MODULES_VADDR: when vmalloc's guard page
would occupy a new page table, it's not allocated, and then
module unload's vfree hits the bad 9090 pmd entry left over.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 32ba13b..998a06e 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -206,7 +206,7 @@ void __init cleanup_highmap(void)
 	pmd_t *last_pmd = pmd + PTRS_PER_PMD;
 
 	for (; pmd < last_pmd; pmd++, vaddr += PMD_SIZE) {
-		if (!pmd_present(*pmd))
+		if (pmd_none(*pmd))
 			continue;
 		if (vaddr < (unsigned long) _text || vaddr > end)
 			set_pmd(pmd, __pmd(0));

