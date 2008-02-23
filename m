Return-Path: <linux-kernel-owner+w=401wt.eu-S1762788AbYBWGTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762788AbYBWGTw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 01:19:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757936AbYBWGTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 01:19:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34042 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757488AbYBWGT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 01:19:29 -0500
Date: Sat, 23 Feb 2008 07:18:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Morris <jmorris@namei.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Regression [Was: Boot hang with stack protector on x86_64]
Message-ID: <20080223061856.GA26185@elte.hu>
References: <Xine.LNX.4.64.0802221121340.20800@us.intercode.com.au> <20080222075950.GB2660@uranus.ravnborg.org> <20080222093621.GG327@elte.hu> <Xine.LNX.4.64.0802222133150.6937@us.intercode.com.au> <20080222121751.GA17889@elte.hu> <Xine.LNX.4.64.0802230000470.14729@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Xine.LNX.4.64.0802230000470.14729@us.intercode.com.au>
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


James,

could you try the fix below ontop of x86.git#testing, does it solve your 
boot hang?

	Ingo

--------------->
Subject: x86: stackprotector fix: do not zap %gs
From: Ingo Molnar <mingo@elte.hu>
Date: Sat Feb 23 07:06:55 CET 2008

pda_init() puts 0 into %gs - that's wrong because any %gs access will 
fault from now on and we already have a dummy PDA set up that can be 
accessed just fine.

This normally does not matter because almost nothing accesses %gs this 
early ... but the stackprotector now does to read the canary ...

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/setup64.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-x86.q/arch/x86/kernel/setup64.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/setup64.c
+++ linux-x86.q/arch/x86/kernel/setup64.c
@@ -165,8 +165,6 @@ void pda_init(int cpu)
 { 
 	struct x8664_pda *pda = cpu_pda(cpu);
 
-	/* Setup up data that may be needed in __get_free_pages early */
-	asm volatile("movl %0,%%fs ; movl %0,%%gs" :: "r" (0)); 
 	/* Memory clobbers used to order PDA accessed */
 	mb();
 	wrmsrl(MSR_GS_BASE, pda);
