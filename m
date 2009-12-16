Return-Path: <linux-kernel-owner+w=401wt.eu-S934456AbZLPBg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934456AbZLPBg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 20:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934381AbZLPBgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 20:36:25 -0500
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:45998 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279AbZLPBgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 20:36:25 -0500
Date: Tue, 15 Dec 2009 16:59:59 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH RFC tip/core/rcu 15/18] rcu: give different levels of
 the rcu_node hierarchy distinct lockdep names
Message-ID: <20091216005959.GC2408@feather>
References: <20091215230213.GA9093@linux.vnet.ibm.com>
 <12609181611666-git-send-email->
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12609181611666-git-send-email->
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 03:02:38PM -0800, Paul E. McKenney wrote:
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
> +

BUILD_BUG_ON seems better.  For that matter, please consider moving
these near the rest of the level-specific defines, making them const,
and ideally not emitting the strings for levels you don't have.

- Josh Triplett
