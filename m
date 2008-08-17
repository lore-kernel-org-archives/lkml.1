Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbYHQReN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbYHQReN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 13:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbYHQRd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 13:33:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37530 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320AbYHQRd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 13:33:56 -0400
Date: Sun, 17 Aug 2008 19:33:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] debug: fix BUILD_BUG_ON() for non-constant expressions
Message-ID: <20080817173319.GA2450@elte.hu>
References: <20080816100948.GB19926@martell.zuzino.mipt.ru> <200808162055.45136.rusty@rustcorp.com.au> <alpine.LFD.1.10.0808161305170.3324@nehalem.linux-foundation.org> <20080817103241.GB21303@elte.hu> <alpine.LFD.1.10.0808170936260.3324@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.1.10.0808170936260.3324@nehalem.linux-foundation.org>
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

> 
> 
> On Sun, 17 Aug 2008, Ingo Molnar wrote:
> > +/*
> > + * Force a compilation error if condition is true [array index becomes
> > + * negative], and a linker error if condition is not constant [non-defined
> > + * variable is used as an array index]:
> > + *
> > + * ( The linker trick relies on gcc optimizing out a multiplication with
> > + *   constant zero - which should be reasonable enough. )
> > + */
> > +extern unsigned int __BUILD_BUG_ON_non_constant;
> > +
> > +#define BUILD_BUG_ON(condition)					\
> > +do {								\
> > +	(void)sizeof(char[1 - 2*!!(condition)]);		\
> > +	if (!__builtin_constant_p(condition))			\
> > +		__BUILD_BUG_ON_non_constant++;			\
> > +} while (0)
> 
> Gag me now.
> 
> Why not just do
> 
>  #define __BBO(c)                sizeof(const char[1 - 2*!!(c)])
>  #define __BBONC(c)              __BBO(!__builtin_constant_p(c))
>  #define BUILD_BUG_ON_ZERO(c)    (__BBO(c) - __BBONC(c))
>  #define BUILD_BUG_ON(c)         (void)BUILD_BUG_ON_ZERO(c)
> 
> and be done with it?

yeah, i first tried a few variants of that (compile-time warnings are 
much better than link time warnings), but none worked when i tested 
various failure modes.

try the patch below - it only gives this error during build:

 kernel/sched.c: In function ‘test':
 kernel/sched.c:9193: error: size of array ‘type name' is negative
 make[1]: *** [kernel/sched.o] Error 1

it doesnt notice the error on the next line. I suspect this is because 
__builtin_constant_p() is special (or broken). I tried it with gcc 4.2.3 
and 4.3.0.

	Ingo

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -9181,3 +9181,16 @@ struct cgroup_subsys cpuacct_subsys = {
 	.subsys_id = cpuacct_subsys_id,
 };
 #endif	/* CONFIG_CGROUP_CPUACCT */
+
+#define __BBO(c)                sizeof(const char[1 - 2*!!(c)])
+#define __BBONC(c)              __BBO(!__builtin_constant_p(c))
+#define BUILD_BUG_ON_ZERO2(c)    (__BBO(c) - __BBONC(c))
+#define BUILD_BUG_ON2(c)         (void)BUILD_BUG_ON_ZERO(c)
+
+void test(void)
+{
+	BUILD_BUG_ON2(0);
+	BUILD_BUG_ON2(1);
+	BUILD_BUG_ON2(panic_timeout);
+}
+
