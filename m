Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbZGCHA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbZGCHA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 03:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbZGCHAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 03:00:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57698 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbZGCHAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 03:00:48 -0400
Date: Fri, 3 Jul 2009 09:00:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       git-commits-head@vger.kernel.org
Subject: [PATCH] kmemleak: Mark nice +10
Message-ID: <20090703070036.GC32687@elte.hu>
References: <200907010300.n6130rRf026194@hera.kernel.org> <20090701075332.GA17252@elte.hu> <1246439937.8492.18.camel@pc1117.cambridge.arm.com> <20090701093015.GA6862@elte.hu> <1246528108.13320.19.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246528108.13320.19.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Catalin Marinas <catalin.marinas@arm.com> wrote:

> On Wed, 2009-07-01 at 11:30 +0200, Ingo Molnar wrote:
> > * Catalin Marinas <catalin.marinas@arm.com> wrote:
> > 
> > > > The minimal fix below removes scan_yield() and adds a 
> > > > cond_resched() to the outmost (safe) place of the scanning 
> > > > thread. This solves the regression.
> > > 
> > > With CONFIG_PREEMPT disabled it won't reschedule during the bss 
> > > scanning but I don't see this as a real issue (task stacks 
> > > scanning probably takes longer anyway).
> > 
> > Yeah. I suspect one more cond_resched() could be added - i just 
> > didnt see an obvious place for it, given that scan_block() is being 
> > called with asymetric held-locks contexts.
> 
> Now that your patch was merged, I propose adding a few more 
> cond_resched() calls, useful for the !PREEMPT case:

note, please also merge the renicing fix you sent. I have it tested 
in tip:out-of-tree, attached below.

	Ingo

>From f6a529517732a9d0e1ad0cd43ad7d2d96de4a4f5 Mon Sep 17 00:00:00 2001
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 1 Jul 2009 10:18:57 +0100
Subject: [PATCH] kmemleak: Mark nice +10

> The background scanning thread could probably also be reniced
> to +10.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 mm/kmemleak.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index e766e1d..6006553 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1039,6 +1039,7 @@ static int kmemleak_scan_thread(void *arg)
 	static int first_run = 1;
 
 	pr_info("Automatic memory scanning thread started\n");
+	set_user_nice(current, 10);
 
 	/*
 	 * Wait before the first scan to allow the system to fully initialize.
