Return-Path: <linux-kernel-owner+w=401wt.eu-S1761756AbYC0Uud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761756AbYC0Uud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 16:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758725AbYC0UuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 16:50:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50420 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758717AbYC0UuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 16:50:24 -0400
Date: Thu, 27 Mar 2008 21:50:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] x86 fixes
Message-ID: <20080327205012.GA21431@elte.hu>
References: <20080327200309.GA18550@elte.hu> <alpine.LFD.1.00.0803271325430.14670@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803271325430.14670@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> >  #ifdef CONFIG_X86_32
> > -	if (!(__supported_pte_mask & _PAGE_NX))
> > +	/* Catch an obscure case of prefetch inside an NX page: */
> > +	if ((__supported_pte_mask & _PAGE_NX) && (error_code & 16))
> >  		return 0;
> >  #endif
> 
> Ingo, this patch makes no sense.
> 
> Two reasons:
> 
>  - "error_code & 16" is senseless. Use PF_INSTR instead, which actually 
>    tells the reader something.

yeah - sorry - the '16' was a blast from the past, i just took the old 
2.6.24 condition on the 32-bit side which didnt use PF_INSTR (PF_INSTR 
came in as a cleanup during the unification), and when the confirmation 
came that this fixed the crash i sent the pull request. That's how this 
nonsensical mixing happened, and that's why i missed the 'if (error_code 
& PF_INSTR)' branch.

The patch below (ontop of the tree) is a first cut at fixing all these 
problems - but i'd wait at least 24 hours with applying this to let it 
be tested through - it affects both 32-bit and 64-bit. The fix further 
cleans up this codepath and removes an #ifdef.

	Ingo

------------------------>
Subject: x86: prefetch fix #2
From: Ingo Molnar <mingo@elte.hu>
Date: Thu Mar 27 21:29:09 CET 2008

Linus noticed a second bug and an uncleanliness:

 - we'd return on any instruction fetch fault

 - we'd use both the value of 16 and the PF_INSTR symbol which are
   the same and make no sense

the cleanup nicely unifies this piece of logic.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/fault.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

Index: linux-x86.q/arch/x86/mm/fault.c
===================================================================
--- linux-x86.q.orig/arch/x86/mm/fault.c
+++ linux-x86.q/arch/x86/mm/fault.c
@@ -103,14 +103,10 @@ static int is_prefetch(struct pt_regs *r
 	int prefetch = 0;
 	unsigned char *max_instr;
 
-#ifdef CONFIG_X86_32
-	/* Catch an obscure case of prefetch inside an NX page: */
-	if ((__supported_pte_mask & _PAGE_NX) && (error_code & 16))
-		return 0;
-#endif
-
-	/* If it was a exec fault on NX page, ignore */
-	if (error_code & PF_INSTR)
+	/*
+	 * Catch an obscure case of prefetch inside an NX page:
+	 */
+	if ((__supported_pte_mask & _PAGE_NX) && (error_code & PF_INSTR))
 		return 0;
 
 	instr = (unsigned char *)convert_ip_to_linear(current, regs);
