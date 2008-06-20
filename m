Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbYFTT5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbYFTT5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 15:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbYFTT5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 15:57:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44302 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094AbYFTT5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 15:57:23 -0400
Date: Fri, 20 Jun 2008 21:56:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, benh@kernel.crashing.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel <kvm-devel@lists.sourceforge.net>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Hugh Dickins <hugh@veritas.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1 of 4] mm: add a ptep_modify_prot transaction
	abstraction
Message-ID: <20080620195620.GA20183@elte.hu>
References: <alpine.LFD.1.10.0806181723400.2907@woody.linux-foundation.org> <4859AA47.2020903@goop.org> <alpine.LFD.1.10.0806181743390.2907@woody.linux-foundation.org> <alpine.LFD.1.10.0806182050470.2907@woody.linux-foundation.org> <20080619115832.GM15228@elte.hu> <alpine.LFD.1.10.0806190928100.2907@woody.linux-foundation.org> <20080619164708.GA32190@elte.hu> <20080620101028.GA23664@elte.hu> <485BFFC4.3070902@goop.org> <alpine.LFD.1.10.0806201211560.3167@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806201211560.3167@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 20 Jun 2008, Jeremy Fitzhardinge wrote:
> > 
> > Blows up on "gcc version 3.4.4 20050314 (prerelease) (Debian 3.4.3-13)":
> 
> Yeah, I was a bit worried about that. Gcc sometimes does insane 
> things.
> 
> We literally just tested that the asm should only _ever_ be generated 
> with a constant value, but if some gcc dead-code removal thing doesn't 
> work, it will then screw up and try to generate the asm even for a 
> non-constant thing.
> 
> The fairly trivial fix is probably to just change the "i" to "ir", 
> safe in the knowledge that any _sane_ case will never use the "r" 
> possibility. I suspect even your insane case will end up then killing 
> the bad choice later.

okay - Jeremy, could you try the fix below? (or tip/master, i just 
pushed this out)

(i dont use gcc 3.x myself to build the kernel, had way too many 
miscompilations in randconfig tests in the past.)

	Ingo

-------------->
commit b68b80b8ab39c42707dc126c41e87d46edc97c27
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Jun 20 21:50:20 2008 +0200

    x86, bitops: make constant-bit set/clear_bit ops faster, gcc workaround
    
    Jeremy Fitzhardinge reported this compiler bug:
    
    Suggestion from Linus: add "r" to the input constraint of the
    set_bit()/clear_bit()'s constant 'nr' branch:
    
    Blows up on "gcc version 3.4.4 20050314 (prerelease) (Debian 3.4.3-13)":
    
     CC      init/main.o
    include2/asm/bitops.h: In function `start_kernel':
    include2/asm/bitops.h:59: warning: asm operand 1 probably doesn't match constraints
    include2/asm/bitops.h:59: warning: asm operand 1 probably doesn't match constraints
    include2/asm/bitops.h:59: warning: asm operand 1 probably doesn't match constraints
    include2/asm/bitops.h:59: error: impossible constraint in `asm'
    include2/asm/bitops.h:59: error: impossible constraint in `asm'
    include2/asm/bitops.h:59: error: impossible constraint in `asm'
    
    Reported-by: Jeremy Fitzhardinge <jeremy@goop.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/include/asm-x86/bitops.h b/include/asm-x86/bitops.h
index 6c50548..4575de4 100644
--- a/include/asm-x86/bitops.h
+++ b/include/asm-x86/bitops.h
@@ -58,7 +58,7 @@ static inline void set_bit(unsigned int nr, volatile unsigned long *addr)
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "orb %1,%0"
 			: CONST_MASK_ADDR(nr, addr)
-			: "i" (CONST_MASK(nr))
+			: "ir" (CONST_MASK(nr))
 			: "memory");
 	} else {
 		asm volatile(LOCK_PREFIX "bts %1,%0"
@@ -95,7 +95,7 @@ static inline void clear_bit(int nr, volatile unsigned long *addr)
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "andb %1,%0"
 			: CONST_MASK_ADDR(nr, addr)
-			: "i" (~CONST_MASK(nr)));
+			: "ir" (~CONST_MASK(nr)));
 	} else {
 		asm volatile(LOCK_PREFIX "btr %1,%0"
 			: BITOP_ADDR(addr)
