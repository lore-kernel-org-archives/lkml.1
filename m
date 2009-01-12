Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbZALMGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbZALMGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 07:06:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbZALMF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 07:05:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47827 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbZALMF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 07:05:58 -0500
Date: Mon, 12 Jan 2009 13:05:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, vatsa@linux.vnet.ibm.com,
       dhaval@linux.vnet.ibm.com, mel@csn.ul.ie,
       Alexey Zaytsev <alexey.zaytsev@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [BUG] 2.6.29-rc1 - Badness at kernel/sched.c:4440 with
	CONFIG_DEBUG_PREEMPT
Message-ID: <20090112120538.GB24266@elte.hu>
References: <20090112113914.GC8409@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112113914.GC8409@linux.vnet.ibm.com>
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


* Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Hi Ingo,
> 
> 	While booting up 2.6.29-rc1 kernel on powerpc machine, Kernel
> Badness warning is seen, when compiled with CONFIG_DEBUG_PREEMPT=y

> kernel warning is not seen after reverting the patch.
> 
> commit 7317d7b87edb41a9135e30be1ec3f7ef817c53dd
> Author: Nick Piggin <nickpiggin@yahoo.com.au>
> Date:   Tue Sep 30 20:50:27 2008 +1000
> 
>     sched: improve preempt debugging

thanks. This has been bisected before by Alexey Zaytsev so i've now 
reverted the commit in tip/sched/urgent and will send it to Linus ASAP. 
The revert commit can be found below.

	Ingo

--------------------->
>From 01e3eb82278bf45221fc38b391bc5ee0f6a314d6 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 12 Jan 2009 13:00:50 +0100
Subject: [PATCH] Revert "sched: improve preempt debugging"

This reverts commit 7317d7b87edb41a9135e30be1ec3f7ef817c53dd.

This has been reported (and bisected) by Alexey Zaytsev and
Kamalesh Babulal to produce annoying warnings during bootup
on both x86 and powerpc.

kernel_locked() is not a valid test in IRQ context (we update the
BKL's ->lock_depth and the preempt count separately and non-atomicalyy),
so we cannot put it into the generic preempt debugging checks which
can run in IRQ contexts too.

Reported-and-bisected-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Reported-and-bisected-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8be2c13..3b630d8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4440,7 +4440,7 @@ void __kprobes sub_preempt_count(int val)
 	/*
 	 * Underflow?
 	 */
-       if (DEBUG_LOCKS_WARN_ON(val > preempt_count() - (!!kernel_locked())))
+	if (DEBUG_LOCKS_WARN_ON(val > preempt_count()))
 		return;
 	/*
 	 * Is the spinlock portion underflowing?
