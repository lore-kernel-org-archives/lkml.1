Return-Path: <linux-kernel-owner+w=401wt.eu-S1758041AbZABL4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041AbZABL4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 06:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757301AbZABL43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 06:56:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49854 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757180AbZABL41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 06:56:27 -0500
Date: Fri, 2 Jan 2009 12:55:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, rdreier@cisco.com, ian.campbell@citrix.com,
       jeremy.fitzhardinge@citrix.com, deller@gmx.de, rusty@rustcorp.com.au,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       kyle@mcmartin.ca, randolph@tausq.org, sam@ravnborg.org,
       dave@hiauly1.hia.nrc.ca
Subject: [PATCH] kbuild: Disallow GCC 4.1.0 / 4.1.1
Message-ID: <20090102115547.GB3027@elte.hu>
References: <alpine.LFD.2.00.0812310942110.5086@localhost.localdomain> <20081231105425.9ccac21d.akpm@linux-foundation.org> <alpine.LFD.2.00.0812311318420.5086@localhost.localdomain> <20081231.141408.60544902.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081231.141408.60544902.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Wed, 31 Dec 2008 13:22:53 -0800 (PST)
> 
> > On Wed, 31 Dec 2008, Andrew Morton wrote:
> > > 
> > > Adrian claimed that it was gcc-4.1.0 and 4.1.1 only.  He proposed
> > > banning them: http://lkml.org/lkml/2008/8/5/444
> > 
> > If it really is just those releases, then yes, considering the number 
> > of cases we apparently have, and considering how ugly it is in some 
> > cases to move the weak function anywhere else, maybe banning those 
> > versions is the proper thing to do.
> > 
> > It probably won't hurt very many people - yeah, some people will be 
> > forced to upgrade, but I have this memory of early 4.1 having had 
> > other bugs anyway, so it's probably a good idea.
> 
> I think this is probably the best way to handle this.

okay - to move this matter from the discussion-space to the 
solution-space, how about the patch below? (tested on x86 with a 
non-affected compiler version.)

	Ingo

-------------->
>From e6346e5ab54dcf12888a79dfd5402f5de09b3fad Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 2 Jan 2009 12:46:22 +0100
Subject: [PATCH] kbuild: Disallow GCC 4.1.0 / 4.1.1

Impact: fix crashes that can trigger if built with GCC 4.1.0 or 4.1.1

GCC 4.1.0 and 4.1.1 has a bug that can miscompile __weak symbols,
by inlining __weak functions into same-file call sites - breaking the
kernel if the __weak symbol is overriden later on.

In the past we tried to work around this problem by artificially
isolating call site and definition site - but these bugs tend to
pop up regularly:

 43a2563: sparseirq: move __weak symbols into separate compilation unit
 13a0c3c: sparseirq: work around compiler optimizing away __weak functions

And Linus has extended Sparse to report same-file callsites for __weak
symbols - which gave two dozen hits.

We have not found a clean way to work around this bug on the source
code level (noinline and explicit barrier()s are ignored by GCC), so we do
not allow these compilers (which are quite rare these days, have other bugs
and are superceded by the 4.1.2 bugfix release anyway).

Kernel builds under gcc 410 or 411 will now fail with this error message:

  Sorry, your compiler is too old, too buggy or not recognized.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/compiler.h |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index ea7c6be..dd558ce 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -36,12 +36,25 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 
 #ifdef __KERNEL__
 
-#if __GNUC__ >= 4
+/*
+ * GCC 4.1.0 and 4.1.1 has a bug that can miscompile __weak symbols,
+ * by inlining __weak functions into same-file call sites - breaking the
+ * kernel if the __weak symbol is overriden later on.
+ *
+ * We have not found a clean way to work around this bug on the source
+ * code level, so we do not allow these compilers (which are quite
+ * rare these days, have other bugs and are superceded by the 4.1.2
+ * bugfix release anyway):
+ */
+#define gcc41_inlining_bug \
+	(__GNUC__ == 4 && __GNUC_MINOR__ == 1 && __GNUC_PATCHLEVEL__ <= 1)
+
+#if __GNUC__ >= 4 && !gcc41_inlining_bug
 # include <linux/compiler-gcc4.h>
 #elif __GNUC__ == 3 && __GNUC_MINOR__ >= 2
 # include <linux/compiler-gcc3.h>
 #else
-# error Sorry, your compiler is too old/not recognized.
+# error Sorry, your compiler is too old, too buggy or not recognized.
 #endif
 
 #define notrace __attribute__((no_instrument_function))
