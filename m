Return-Path: <linux-kernel-owner+w=401wt.eu-S1755412AbYFRNM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbYFRNM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 09:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbYFRNMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 09:12:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38765 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbYFRNMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 09:12:49 -0400
Date: Wed, 18 Jun 2008 15:08:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, josh@freedesktop.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, dino@in.ibm.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, vegard.nossum@gmail.com,
       adobriyan@gmail.com, oleg@tv-sign.ru, bunk@kernel.org, rjw@sisk.pl
Subject: Re: [PATCH] Make rcutorture more vicious: add stutter feature
Message-ID: <20080618130840.GA11501@elte.hu>
References: <20080618122144.GA27143@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080618122144.GA27143@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello!
> 
> This patch takes a step towards making rcutorture more brutal by 
> allowing the test to be automatically periodically paused, with the 
> default being to run the test for five seconds then pause for five 
> seconds and repeat. This behavior can be controlled using a new 
> "stutter" module parameter, so that "stutter=0" gives the old default 
> behavior of running continuously.
> 
> Starting and stopping rcutorture more heavily stresses RCU's 
> interaction with the scheduler, as well as exercising more paths 
> through the grace-period detection code.

cool! Applied to tip/core/rcu.

> Note that the default to "shuffle_interval" has also been adjusted 
> from 5 seconds to 3 seconds to provide varying overlap with the 
> "stutter" interval.
> 
> I am still unable to provoke the failures that Alexey has been seeing, 
> even with this patch, but will be doing a few additional things to 
> beef up rcutorture.

neither am i able to see any rcu-preempt+rcu-torture failures in my 
testing, despite having added the patch below to tip/core/rcu as well to 
make any failures more apparent.

	Ingo

------------------>
commit 5af970a48f3ba0dd96a036b196c79dc923f28231
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Jun 18 10:09:48 2008 +0200

    rcutorture: WARN_ON_ONCE(1) when detecting an error
    
    this makes it easier for automated tests to pick up such failures.

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 0334b6a..0ca7e9b 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -687,6 +687,7 @@ rcu_torture_printk(char *page)
 	if (i > 1) {
 		cnt += sprintf(&page[cnt], "!!! ");
 		atomic_inc(&n_rcu_torture_error);
+		WARN_ON_ONCE(1);
 	}
 	cnt += sprintf(&page[cnt], "Reader Pipe: ");
 	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++)
