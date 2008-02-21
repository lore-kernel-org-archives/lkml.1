Return-Path: <linux-kernel-owner+w=401wt.eu-S1764523AbYBUHHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764523AbYBUHHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 02:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbYBUHHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 02:07:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46314 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753843AbYBUHHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 02:07:45 -0500
Date: Thu, 21 Feb 2008 08:07:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peter@programming.kicks-ass.net>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: Make yield_task_fair more efficient
Message-ID: <20080221070733.GA13694@elte.hu>
References: <20080221053321.GA26918@balbir.in.ibm.com> <20080221060427.GA9159@elte.hu> <47BD1F75.5030506@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BD1F75.5030506@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> I disagree. The cost is only adding a field to cfs_rq [...]

wrong. The cost is "only" of adding a field to cfs_rq and _updating it_, 
in the hottest paths of the scheduler:

@@ -256,6 +257,7 @@ static void __enqueue_entity(struct cfs_
                 */
                if (key < entity_key(cfs_rq, entry)) {
                        link = &parent->rb_left;
+                       rightmost = 0;
                } else {
                        link = &parent->rb_right;
                        leftmost = 0;
@@ -268,6 +270,8 @@ static void __enqueue_entity(struct cfs_
         */
        if (leftmost)
                cfs_rq->rb_leftmost = &se->run_node;
+       if (rightmost)
+               cfs_rq->rb_rightmost = &se->run_node;

> [...] For a large number of tasks - say 10000, we need to walk 14 
> levels before we reach the node (each time). [...]

10,000 yield-ing tasks is not a common workload we care about. It's not 
even a rare workload we care about. _Especially_ we dont care about it 
if it slows down every other workload (a tiny bit).

> [...] Doesn't matter if the data is cached, we are still spending CPU 
> time looking through pointers and walking to the right node. [...]

have you actually measured how much it takes to walk the tree that deep
on recent hardware? I have.

	Ingo
