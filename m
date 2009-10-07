Return-Path: <linux-kernel-owner+w=401wt.eu-S1756341AbZJGGQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbZJGGQB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 02:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbZJGGQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 02:16:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41834 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166AbZJGGQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 02:16:00 -0400
Date: Wed, 7 Oct 2009 08:14:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 0/3] rcu: prevent hangs by simplifying
	rcu_barrier/CPU-hotplug, fix lockdep complaint
Message-ID: <20091007061448.GA21673@elte.hu>
References: <20091007044748.GA12763@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007044748.GA12763@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> This patchset fixes a couple of issues with TREE_PREEMPT_RCU:
> 
> 1.	The current implementation of rcu_barrier() waits for any
> 	prior CPU-hotplug operation to complete.  This code path has
> 	resulted in some hangs, so first move this code from rcupdate.c
> 	to rcutree.c and then use a simpler algorithm that avoids the
> 	waiting, eliminating the possibility of such hangs.
> 
> 2.	The lockdep facility complains from time to time due to the
> 	fact that certain combinations of CPU-hotplug operations can
> 	cause the TREE_PREEMPT_RCU code to acquire the root rcu_node
> 	structure's lock while holding a leaf rcu_node structure's
> 	lock.  This patch places the root rcu_node structure's lock
> 	into its own lockdep class to prevent this false positive.
> 
> Ingo, please rewind tip/core/rcu to commit #135c8aea before applying this
> series, as these patches really need to go into 2.6.32.  Reworked and
> retested rcutiny (for 2.6.33, as Linus requested) will follow in a
> few days.  Or more patches for more bug fixes, as the case may be.  ;-)
> 
>  b/kernel/rcupdate.c       |  120 -----------------------------------
>  b/kernel/rcutree.c        |  120 +++++++++++++++++++++++++++++++++++
>  b/kernel/rcutree.h        |   11 ++-
>  b/kernel/rcutree_plugin.h |   34 ++++++++++
>  b/kernel/rcutree_trace.c  |    5 -
>  kernel/rcutree.c          |  156 ++++++++++++++++++++++++----------------------
>  6 files changed, 248 insertions(+), 198 deletions(-)

Applied, thanks Paul!

I dropped these commits for now:

 3ffea79: rcu: Make hot-unplugged CPU relinquish its own RCU callbacks
 eddd962: rcu: Move rcu_barrier() to rcutree, make lightweight rcu_barrier() for rcutiny
 a39e7d5: rcu-tiny: The Bloatwatch Edition, v6

We can apply rcu-tiny for .33 again, once the dust has settled.

	Ingo
