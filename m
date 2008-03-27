Return-Path: <linux-kernel-owner+w=401wt.eu-S1761464AbYC0VYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761464AbYC0VYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 17:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757463AbYC0VY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 17:24:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56650 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756994AbYC0VY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 17:24:27 -0400
Date: Thu, 27 Mar 2008 22:24:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] x86 fixes
Message-ID: <20080327212414.GA24580@elte.hu>
References: <20080327200309.GA18550@elte.hu> <alpine.LFD.1.00.0803271325430.14670@woody.linux-foundation.org> <20080327205012.GA21431@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327205012.GA21431@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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

> The patch below (ontop of the tree) is a first cut at fixing all these 
> problems - but i'd wait at least 24 hours with applying this to let it 
> be tested through - it affects both 32-bit and 64-bit. The fix further 
> cleans up this codepath and removes an #ifdef.

scratch that 24 hours - the patch is obviously correct as it only 
removes the nonsensical bits that get duplicated below anyway.

Linus, please pull the latest x86 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git for-linus

Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      x86: prefetch fix #2

 arch/x86/mm/fault.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index c0c82bc..ec08d83 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -91,13 +91,10 @@ static int is_prefetch(struct pt_regs *regs, unsigned long addr,
 	int prefetch = 0;
 	unsigned char *max_instr;
 
-#ifdef CONFIG_X86_32
-	/* Catch an obscure case of prefetch inside an NX page: */
-	if ((__supported_pte_mask & _PAGE_NX) && (error_code & 16))
-		return 0;
-#endif
-
-	/* If it was a exec fault on NX page, ignore */
+	/*
+	 * If it was a exec (instruction fetch) fault on NX page, then
+	 * do not ignore the fault:
+	 */
 	if (error_code & PF_INSTR)
 		return 0;
 
