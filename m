Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbYAIAny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbYAIAny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 19:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbYAIAnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 19:43:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56293 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbYAIAnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 19:43:45 -0500
Date: Wed, 9 Jan 2008 01:43:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 00 of 10] x86: unify asm/pgtable.h
Message-ID: <20080109004329.GA6603@elte.hu>
References: <20080108224244.GA3768@elte.hu> <20080108231226.GA10744@elte.hu> <478405DA.40303@goop.org> <20080108232803.GA19906@elte.hu> <20080108234449.GA24274@elte.hu> <20080109000146.GA29095@elte.hu> <47841194.2010208@goop.org> <20080109002014.GB31289@elte.hu> <20080109002803.GA3732@elte.hu> <20080109003034.GA4658@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109003034.GA4658@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.7
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.7 required=5.9 tests=BAYES_00,UPPERCASE_50_75 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.8 UPPERCASE_50_75        message body is 50-75% uppercase
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > >>>  #define __PAGE_KERNEL_EXEC						\
> > > >>> -	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_GLOBAL)
> > > >>> +	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED)
> > > >>>     
> > > >
> > > > This shouldn't be necessary.  The old 64-bit code defined everything 
> > > > without _PAGE_GLOBAL, but then used a MAKE_GLOBAL() macro to OR it 
> > > > in later.  This seemed a bit roundabout to me, so I just put it in 
> > > > from the outset.
> > 
> > actually, this is wrong.
> > 
> > a couple of places use __PAGE_* values, which you've now changed to 
> > include the _PAGE_GLOBAL flag.
> 
> yep, fixing this resolves the crash.

but then it crashes init:

 init[1]: segfault at ffffffffff600400 ip ffffffffff600400 sp 
 7fff81bedda8 error5printk: 7740690 messages suppressed.

because you changed __PAGE_KERNEL_VSYSCALL as well, from:

 #define __PAGE_KERNEL_VSYSCALL \
         (_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED)

to:

 #define __PAGE_KERNEL_VSYSCALL          (__PAGE_KERNEL_RO | _PAGE_USER)

but __PAGE_KERNEL_RO is an NX one, so the vsyscall cannot execute 
instructions.

so this wants to be:

 #define __PAGE_KERNEL_VSYSCALL          (__PAGE_KERNEL_RX | _PAGE_USER)

this was the last bug and the resulting kernel boots fine. 3 nasty bugs 
in one patch :-/

	Ingo

---------------->
Subject: x86: move all asm/pgtable constants into one place, fix
From: Ingo Molnar <mingo@elte.hu>

fix.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-x86/pgtable.h |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

Index: linux-x86.q/include/asm-x86/pgtable.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/pgtable.h
+++ linux-x86.q/include/asm-x86/pgtable.h
@@ -68,27 +68,27 @@ extern unsigned long long __PAGE_KERNEL,
 #endif	/* __ASSEMBLER__ */
 #else
 #define __PAGE_KERNEL_EXEC						\
-	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_GLOBAL)
+	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED)
 #define __PAGE_KERNEL		(__PAGE_KERNEL_EXEC | _PAGE_NX)
 #endif
 
 #define __PAGE_KERNEL_RO		(__PAGE_KERNEL & ~_PAGE_RW)
 #define __PAGE_KERNEL_RX		(__PAGE_KERNEL_EXEC & ~_PAGE_RW)
 #define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD | _PAGE_PWT)
-#define __PAGE_KERNEL_VSYSCALL		(__PAGE_KERNEL_RO | _PAGE_USER)
+#define __PAGE_KERNEL_VSYSCALL		(__PAGE_KERNEL_RX | _PAGE_USER)
 #define __PAGE_KERNEL_VSYSCALL_NOCACHE	(__PAGE_KERNEL_VSYSCALL | _PAGE_PCD | _PAGE_PWT)
 #define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
 
-#define PAGE_KERNEL			__pgprot(__PAGE_KERNEL)
-#define PAGE_KERNEL_RO			__pgprot(__PAGE_KERNEL_RO)
-#define PAGE_KERNEL_EXEC		__pgprot(__PAGE_KERNEL_EXEC)
-#define PAGE_KERNEL_RX			__pgprot(__PAGE_KERNEL_RX)
-#define PAGE_KERNEL_NOCACHE		__pgprot(__PAGE_KERNEL_NOCACHE)
-#define PAGE_KERNEL_LARGE		__pgprot(__PAGE_KERNEL_LARGE)
-#define PAGE_KERNEL_LARGE_EXEC		__pgprot(__PAGE_KERNEL_LARGE_EXEC)
-#define PAGE_KERNEL_VSYSCALL		__pgprot(__PAGE_KERNEL_VSYSCALL)
-#define PAGE_KERNEL_VSYSCALL_NOCACHE	__pgprot(__PAGE_KERNEL_VSYSCALL_NOCACHE)
+#define PAGE_KERNEL			__pgprot(__PAGE_KERNEL | _PAGE_GLOBAL)
+#define PAGE_KERNEL_RO			__pgprot(__PAGE_KERNEL_RO | _PAGE_GLOBAL)
+#define PAGE_KERNEL_EXEC		__pgprot(__PAGE_KERNEL_EXEC | _PAGE_GLOBAL)
+#define PAGE_KERNEL_RX			__pgprot(__PAGE_KERNEL_RX | _PAGE_GLOBAL)
+#define PAGE_KERNEL_NOCACHE		__pgprot(__PAGE_KERNEL_NOCACHE | _PAGE_GLOBAL)
+#define PAGE_KERNEL_LARGE		__pgprot(__PAGE_KERNEL_LARGE | _PAGE_GLOBAL)
+#define PAGE_KERNEL_LARGE_EXEC		__pgprot(__PAGE_KERNEL_LARGE_EXEC | _PAGE_GLOBAL)
+#define PAGE_KERNEL_VSYSCALL		__pgprot(__PAGE_KERNEL_VSYSCALL | _PAGE_GLOBAL)
+#define PAGE_KERNEL_VSYSCALL_NOCACHE	__pgprot(__PAGE_KERNEL_VSYSCALL_NOCACHE | _PAGE_GLOBAL)
 
 /*         xwr */
 #define __P000	PAGE_NONE
