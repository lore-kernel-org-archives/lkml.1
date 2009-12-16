Return-Path: <linux-kernel-owner+w=401wt.eu-S1761289AbZLPK0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761289AbZLPK0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 05:26:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761244AbZLPK0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 05:26:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41666 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761283AbZLPK0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 05:26:40 -0500
Subject: Re: [PATCH RFC tip/core/rcu 15/18] rcu: give different levels of
 the rcu_node hierarchy distinct lockdep names
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
In-Reply-To: <12609181611666-git-send-email->
References: <20091215230213.GA9093@linux.vnet.ibm.com>
	 <12609181611666-git-send-email->
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Dec 2009 11:26:00 +0100
Message-ID: <1260959160.17860.39.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-15 at 15:02 -0800, Paul E. McKenney wrote:
> From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Proposed for 2.6.34, not for inclusion.
> 
> Previously, each level of the rcu_node hierarchy had the same rather
> unimaginative name: "&rcu_node_class[i]".  This makes lockdep diagnostics
> involving these lockdep classes less helpful than would be nice.  This
> patch fixes this by giving each level of the rcu_node hierarchy a distinct
> name: "rcu_node_level_0", "rcu_node_level_1", and so on.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcutree.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 0a4c328..a6e45f6 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1811,11 +1811,17 @@ static void __init rcu_init_levelspread(struct rcu_state *rsp)
>   */
>  static void __init rcu_init_one(struct rcu_state *rsp)
>  {
> +	static char *buf[] = { "rcu_node_level_0",
> +			       "rcu_node_level_1",
> +			       "rcu_node_level_2",
> +			       "rcu_node_level_3" };  /* Match MAX_RCU_LVLS */
>  	int cpustride = 1;
>  	int i;
>  	int j;
>  	struct rcu_node *rnp;
>  
> +	WARN_ON_ONCE(MAX_RCU_LVLS > 4);  /* Fix buf[] initialization! */

So you're going to WARN here,

>  	/* Initialize the level-tracking arrays. */
>  
>  	for (i = 1; i < NUM_RCU_LVLS; i++)
> @@ -1829,7 +1835,8 @@ static void __init rcu_init_one(struct rcu_state *rsp)
>  		rnp = rsp->level[i];
>  		for (j = 0; j < rsp->levelcnt[i]; j++, rnp++) {
>  			spin_lock_init(&rnp->lock);
> -			lockdep_set_class(&rnp->lock, &rcu_node_class[i]);
> +			lockdep_set_class_and_name(&rnp->lock,
> +						   &rcu_node_class[i], buf[i]);

and segfault here because i overruns its bounds?

Might as well BUG_ON then.

