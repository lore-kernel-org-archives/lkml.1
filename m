Return-Path: <linux-kernel-owner+w=401wt.eu-S933450AbZAPMrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933450AbZAPMrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 07:47:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758146AbZAPMro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 07:47:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56884 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841AbZAPMro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 07:47:44 -0500
Date: Fri, 16 Jan 2009 13:47:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386: fix assumed to be contiguous leaf page tables
	for kmap_atomic region (take 2)
Message-ID: <20090116124734.GD5421@elte.hu>
References: <497084B5.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497084B5.76E4.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> Debugging and original patch from Nick Piggin <npiggin@suse.de>
> 
> The early fixmap pmd entry inserted at the very top of the KVA is causing the
> subsequent fixmap mapping code to not provide physically linear pte pages over
> the kmap atomic portion of the fixmap (which relies on said property to
> calculate pte addresses).
> 
> This has caused weird boot failures in kmap_atomic much later in the boot
> process (initial userspace faults) on a 32-bit PAE system with a larger number
> of CPUs (smaller CPU counts tend not to run over into the next page so don't
> show up the problem).
> 
> Solve this by attempting to clear out the page table, and copy any of its
> entries to the new one. Also, add a bug if a nonlinear condition is encountered
> and can't be resolved, which might save some hours of debugging if this fragile
> scheme ever breaks again...
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>
> 
> Once we have such logic, we can also use it to eliminate the early ioremap
> trickery around the page table setup for the fixmap area. This also fixes
> potential issues with FIX_* entries sharing the leaf page table with the early
> ioremap ones getting discarded by early_ioremap_clear() and not restored by
> early_ioremap_reset(). It at once eliminates the temporary (and configuration,
> namely NR_CPUS, dependent) unavailability of early fixed mappings during the
> time the fixmap area page tables get constructed.
> 
> Finally, also replace the hard coded calculation of the initial table space
> needed for the fixmap area with a proper one, allowing kernels configured for
> large CPU counts to actually boot.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  arch/x86/include/asm/io.h |    1 
>  arch/x86/mm/init_32.c     |   48 +++++++++++++++++++++++++++++++++++++++++++---
>  arch/x86/mm/ioremap.c     |   25 -----------------------
>  3 files changed, 45 insertions(+), 29 deletions(-)

Much cleaner - applied to tip/x86/urgent, thanks Jan!

	Ingo
