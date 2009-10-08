Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbZJHJ3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbZJHJ3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 05:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756518AbZJHJ3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 05:29:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39891 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756566AbZJHJ3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 05:29:32 -0400
Subject: Re: [PATCH tip/core/rcu 3/3] rcu: place root rcu_node structure in
 separate lockdep class
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
In-Reply-To: <12548908983277-git-send-email->
References: <20091007044748.GA12763@linux.vnet.ibm.com>
	 <12548908983277-git-send-email->
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 08 Oct 2009 11:31:59 +0200
Message-Id: <1254994319.26976.264.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 21:48 -0700, Paul E. McKenney wrote:
> From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Before this patch, all of the rcu_node structures were in the same lockdep
> class, so that lockdep would complain when rcu_preempt_offline_tasks()
> acquired the root rcu_node structure's lock while holding one of the leaf
> rcu_nodes' locks.  This patch changes rcu_init_one() to use a separate
> spin_lock_init() for the root rcu_node structure's lock than is used for
> that of all of the rest of the rcu_node structures, which puts the root
> rcu_node structure's lock in its own lockdep class.
> 
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcutree.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index d8d9865..705f02a 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1647,7 +1647,8 @@ static void __init rcu_init_one(struct rcu_state *rsp)
>  		cpustride *= rsp->levelspread[i];
>  		rnp = rsp->level[i];
>  		for (j = 0; j < rsp->levelcnt[i]; j++, rnp++) {
> -			spin_lock_init(&rnp->lock);
> +			if (rnp != rcu_get_root(rsp))
> +				spin_lock_init(&rnp->lock);
>  			rnp->gpnum = 0;
>  			rnp->qsmask = 0;
>  			rnp->qsmaskinit = 0;
> @@ -1670,6 +1671,7 @@ static void __init rcu_init_one(struct rcu_state *rsp)
>  			INIT_LIST_HEAD(&rnp->blocked_tasks[1]);
>  		}
>  	}
> +	spin_lock_init(&rcu_get_root(rsp)->lock);
>  }
>  
>  /*


An alternative version that would not change any code in the !LOCKDEP
case would read as:

---
 kernel/rcutree.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d8d9865..113f274 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1625,6 +1625,8 @@ static void __init rcu_init_levelspread(struct rcu_state *rsp)
 }
 #endif /* #else #ifdef CONFIG_RCU_FANOUT_EXACT */
 
+static struct lock_class_key rcu_root_class;
+
 /*
  * Helper function for rcu_init() that initializes one rcu_state structure.
  */
@@ -1670,6 +1672,7 @@ static void __init rcu_init_one(struct rcu_state *rsp)
 			INIT_LIST_HEAD(&rnp->blocked_tasks[1]);
 		}
 	}
+	lockdep_set_class(&rcu_get_root(rsp)->lock, &rcu_root_class);
 }
 
 /*

