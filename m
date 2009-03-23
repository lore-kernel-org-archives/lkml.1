Return-Path: <linux-kernel-owner+w=401wt.eu-S1759024AbZCWPWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759024AbZCWPWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759036AbZCWPV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:21:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37735 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759029AbZCWPVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:21:55 -0400
Date: Mon, 23 Mar 2009 16:19:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, oleg@redhat.com, peterz@infradead.org,
       roland@redhat.com, efault@gmx.de, rjw@sisk.pl, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       stable@kernel.org
Subject: Re: [patch] fix ptrace slowness
Message-ID: <20090323151954.GC21267@elte.hu>
References: <E1LllkK-0000zF-1h@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LllkK-0000zF-1h@pomaz-ex.szeredi.hu>
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


* Miklos Szeredi <miklos@szeredi.hu> wrote:

> This one incorporates comments from Oleg and Ingo.  Please apply 
> to 2.6.29 and 2.6.2[78]-stable trees.

The fix first needs to go upstream. There's an alternative patch 
below. Would you mind to give it a test? Chances are that it will 
make UML even faster than your fix.

	Ingo

diff --git a/kernel/sched.c b/kernel/sched.c
index 3e827b8..2d60f23 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2119,7 +2119,8 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 		 * yield - it could be a while.
 		 */
 		if (unlikely(on_rq)) {
-			schedule_timeout_uninterruptible(1);
+			cpu_relax();
+			cond_resched();
 			continue;
 		}
 
