Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbYGYSpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbYGYSpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 14:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbYGYSpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 14:45:35 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:54214 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbYGYSpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 14:45:34 -0400
Date: Fri, 25 Jul 2008 19:45:00 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Ingo Molnar <mingo@elte.hu>
cc: Mike Travis <travis@sgi.com>, Ben Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Linuxppc-dev@ozlabs.org
Subject: Re: CONFIG_FRAME_POINTER [was [PATCH] x86: BUILD_IRQ say .text]
In-Reply-To: <20080724104459.GI28817@elte.hu>
Message-ID: <Pine.LNX.4.64.0807251839190.20617@blonde.site>
References: <Pine.LNX.4.64.0807211828470.26173@blonde.site>
 <20080724104459.GI28817@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2008, Ingo Molnar wrote:
> * Hugh Dickins <hugh@veritas.com> wrote:
> 
> > I've been using -fno-unit-at-a-time (to lessen inlining, for easier 
> > debugging) for a long time
> 
> Should we perhaps enable this automatically on CONFIG_FRAME_POINTER=y 
> builds? Although a separate, default-off config option might be better, 

I'm content to go on patching the Makefile to suit my own private debug
proclivities, somewhat reluctant to foist them upon others.  But I must
have found no-unit-at-a-time made things clearer at some point,
and assume it is still being useful.

Whether it deserves its own config option, hmm, not sure of that.
But agree it shouldn't really go into CONFIG_FRAME_POINTER=y
(though notice that already bundles no-optimize-sibling-calls).

I rather think CONFIG_FRAME_POINTER shouldn't exist at all (or be
a private, config-user-invisible, specific-to-a-few-arches thing):
what one wants to configure is how far to sacrifice cpu performance
and kernel smallness to getting a good stacktrace.  Frame pointer
is just an implementation detail on that, appropriate to some arches.
Perhaps three settings: no stacktrace, fair stacktrace, best stacktrace.

I've Cc'ed Ben and linuxppc-dev because I wonder if they're aware
that several options (I got it from LATENCYTOP, but I think LOCKDEP
and FTRACE and some others) are doing a "select FRAME_POINTER",
which forces CONFIG_FRAME_POINTER=y on PowerPC, even though
FRAME_POINTER is not an option offered on PowerPC.  The
resulting kernels appear to run okay, but I was surprised.

> i'd not be surprised if there were more regressions in this area, it's a 
> seldom used build vector.

There'd probably be a lot more if we weren't (recently?) supporting
compilers which only manage no-unit-at-a-time.  The only issue I get
in my kernel builds is with sched_clock() - but I've not been trying
allyesconfig or randconfig.  Here's a patch: but whereas the BUILD_IRQ
one seemed worth sending because the problem might crop up in other
ways and waste someone's time, this one just depends on your taste.


[PATCH] sched: move sched_clock before first use

Move sched_clock() up to stop warning: weak declaration of `sched_clock'
after first use results in unspecified behavior (if -fno-unit-at-a-time).

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 kernel/sched_clock.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- 2.6.26-git/kernel/sched_clock.c	2008-07-18 11:33:34.000000000 +0100
+++ linux/kernel/sched_clock.c	2008-07-18 11:57:46.000000000 +0100
@@ -32,6 +32,15 @@
 #include <linux/ktime.h>
 #include <linux/module.h>
 
+/*
+ * Scheduler clock - returns current time in nanosec units.
+ * This is default implementation.
+ * Architectures and sub-architectures can override this.
+ */
+unsigned long long __attribute__((weak)) sched_clock(void)
+{
+	return (unsigned long long)jiffies * (NSEC_PER_SEC / HZ);
+}
 
 #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
 
@@ -321,16 +330,6 @@ EXPORT_SYMBOL_GPL(sched_clock_idle_wakeu
 
 #endif
 
-/*
- * Scheduler clock - returns current time in nanosec units.
- * This is default implementation.
- * Architectures and sub-architectures can override this.
- */
-unsigned long long __attribute__((weak)) sched_clock(void)
-{
-	return (unsigned long long)jiffies * (NSEC_PER_SEC / HZ);
-}
-
 unsigned long long cpu_clock(int cpu)
 {
 	unsigned long long clock;
