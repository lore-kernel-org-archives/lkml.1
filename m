Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbZAIUlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbZAIUlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 15:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbZAIUld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 15:41:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41841 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbZAIUlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 15:41:31 -0500
Date: Fri, 9 Jan 2009 21:41:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Message-ID: <20090109204103.GA17212@elte.hu>
References: <20090108141808.GC11629@elte.hu> <1231426014.11687.456.camel@twins> <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain> <20090108183306.GA22916@elte.hu> <20090108190038.GH496@one.firstfloor.org> <4966AB74.2090104@zytor.com> <20090109133710.GB31845@elte.hu> <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain>
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

> On Fri, 9 Jan 2009, Ingo Molnar wrote:
> >  
> > -static inline int constant_test_bit(int nr, const volatile unsigned long *addr)
> > +static __asm_inline int
> > +constant_test_bit(int nr, const volatile unsigned long *addr)
> >  {
> >  	return ((1UL << (nr % BITS_PER_LONG)) &
> >  		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
> 
> Thios makes absolutely no sense.
> 
> It's called "__always_inline", not __asm_inline.

yeah.

Note that meanwhile i also figured out why gcc got the inlining wrong 
there: the 'int nr' combined with the '% BITS_PER_LONG' signed arithmetics 
was too much for it to figure out at the inlining stage - it generated 
IDIV instructions, etc. With forced inlining later optimization stages 
managed to prove that the expression can be simplified.

The second patch below that changes 'int nr' to 'unsigned nr' solves that 
problem, without the need to mark the function __always_inline.


How did i end up with __asm_inline? The thing is, i started the day under 
the assumption that there's some big practical problem here. I expected to 
find a lot of places in need of annotation, so i introduced hpa's 
suggestion and added the __asm_inline (via the patch attached below).

I wrote 40 patches that annotated 200+ asm inline functions, and i was 
fully expected to find that GCC made a mess, and i also wrote a patch to 
disable CONFIG_OPTIMIZE_INLINING on those grounds.

The irony is that indeed pretty much the _only_ annotation that made a 
difference was the one that isnt even an asm() inline (as you noted).

So, should we not remove CONFIG_OPTIMIZE_INLINING, then the correct one 
would be to mark it __always_inline [__asm_inline is senseless there], or 
the second patch below that changes the bit parameter to unsigned int.

	Ingo

---
 include/linux/compiler.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux/include/linux/compiler.h
===================================================================
--- linux.orig/include/linux/compiler.h
+++ linux/include/linux/compiler.h
@@ -223,7 +223,11 @@ void ftrace_likely_update(struct ftrace_
 #define noinline_for_stack noinline
 
 #ifndef __always_inline
-#define __always_inline inline
+# define __always_inline inline
+#endif
+
+#ifndef __asm_inline
+# define __asm_inline __always_inline
 #endif
 
 #endif /* __KERNEL__ */

Index: linux/arch/x86/include/asm/bitops.h
===================================================================
--- linux.orig/arch/x86/include/asm/bitops.h
+++ linux/arch/x86/include/asm/bitops.h
@@ -300,7 +300,7 @@ static inline int test_and_change_bit(in
 	return oldbit;
 }
 
-static inline int constant_test_bit(int nr, const volatile unsigned long *addr)
+static int constant_test_bit(unsigned int nr, const volatile unsigned long *addr)
 {
 	return ((1UL << (nr % BITS_PER_LONG)) &
 		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
