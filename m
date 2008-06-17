Return-Path: <linux-kernel-owner+w=401wt.eu-S1753366AbYFQJEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbYFQJEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 05:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbYFQJDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 05:03:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54578 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbYFQJDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 05:03:54 -0400
Date: Tue, 17 Jun 2008 11:03:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Hladky <hladky.jiri@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Martin Mares <mj@ucw.cz>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: Bug in arch/i386/lib/delay.c file, delay_loop function
Message-ID: <20080617090330.GB18127@elte.hu>
References: <900048340805300815u57af94b0i3971b22a9d154d1f@mail.gmail.com> <mj+md-20080601.170340.5225.albireo@ucw.cz> <900048340806020300pf0db974k8318162a442968a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <900048340806020300pf0db974k8318162a442968a2@mail.gmail.com>
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


* Jiri Hladky <hladky.jiri@googlemail.com> wrote:

> Hi Ingo, hi Martin!
> 
> As Martin correctly pointed out, my code will fail when loops=0. So I 
> have added a fix for this.

applied to tip/x86/delay, thanks Jiri! If it passes testing it will show 
up in the v2.6.27 kernel.

[ A few small patch format nits: the first hunk of the patch didnt 
  apply, it was whitespace-damaged - i hand-merged that. The assembly 
  had non-standard formatting - nowadays we try to format the assembly
  so that it looks nice in the .c file, not i the .s file. I fixed that 
  too. Also, the best way is to send fixes in the format below, with a 
  nice commit description, followed by a signed-off-by line. I fixed 
  that as well. ]

please double-check the end result. You can pick up tip/master via:

  http://people.redhat.com/mingo/tip.git/README

do "git-log -1 e01b70ef" or "git-log arch/x86/lib/delay_32.c" to see 
your commit.

	Ingo

------------->
commit e01b70ef3eb3080fecc35e15f68cd274c0a48163
Author: Jiri Hladky <hladky.jiri@googlemail.com>
Date:   Mon Jun 2 12:00:19 2008 +0200

    x86: fix bug in arch/i386/lib/delay.c file, delay_loop function
    
    when trying to understand how Bogomips are implemented I have found a
    bug in arch/i386/lib/delay.c file, delay_loop function.
    
    The function fails for loops > 2^31+1. It because SF is set when dec
    returns numbers > 2^31.
    
    The fix is to use jnz instruction instead of jns (and add one decl
    instruction to the end to have exactly the same number of loops as in
    original version).
    
    Martin Mares observed:
    
    > It is a long time since I have hacked that file, but you should definitely
    > make sure that the function is never called with a zero argument. In such
    > case, the original version made just a single pass, but your version
    > makes 2^32 of them.
    
    fixed that.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/lib/delay_32.c b/arch/x86/lib/delay_32.c
index d710f2d..ef69131 100644
--- a/arch/x86/lib/delay_32.c
+++ b/arch/x86/lib/delay_32.c
@@ -3,6 +3,7 @@
  *
  *	Copyright (C) 1993 Linus Torvalds
  *	Copyright (C) 1997 Martin Mares <mj@atrey.karlin.mff.cuni.cz>
+ *	Copyright (C) 2008 Jiri Hladky <hladky _dot_ jiri _at_ gmail _dot_ com>
  *
  *	The __delay function must _NOT_ be inlined as its execution time
  *	depends wildly on alignment on many x86 processors. The additional
@@ -28,16 +29,22 @@
 /* simple loop based delay: */
 static void delay_loop(unsigned long loops)
 {
-	int d0;
-
 	__asm__ __volatile__(
-		"\tjmp 1f\n"
-		".align 16\n"
-		"1:\tjmp 2f\n"
-		".align 16\n"
-		"2:\tdecl %0\n\tjns 2b"
-		:"=&a" (d0)
-		:"0" (loops));
+		"	test %0,%0	\n"
+		"	jz 3f		\n"
+		"	jmp 1f		\n"
+
+		".align 16		\n"
+		"1:	jmp 2f		\n"
+
+		".align 16		\n"
+		"2:	decl %0		\n"
+		"	jnz 2b		\n"
+		"3:	decl %0		\n"
+
+		: /* we don't need output */
+		:"a" (loops)
+	);
 }
 
 /* TSC based delay: */
