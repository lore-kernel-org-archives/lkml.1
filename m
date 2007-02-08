Return-Path: <linux-kernel-owner+w=401wt.eu-S1161512AbXBHBmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161512AbXBHBmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 20:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422822AbXBHBmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 20:42:42 -0500
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:51410 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161512AbXBHBmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 20:42:42 -0500
Message-ID: <45CA8010.70803@kernel.org>
Date: Wed, 07 Feb 2007 17:42:40 -0800
From: Josh Triplett <josh@kernel.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Richard Knutsson <ricknu-0@student.ltu.se>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH 3/3] rcutorture: Remove redundant assignment to cur_ops
 in for loop
References: <45CA206C.2080205@kernel.org>	<45CA212A.7000504@kernel.org>	<45CA6711.40502@student.ltu.se>	<20070207162228.bd7fd822.akpm@linux-foundation.org> <20070207162410.581bcc98.akpm@linux-foundation.org>
In-Reply-To: <20070207162410.581bcc98.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 7 Feb 2007 16:22:28 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
>> I suspect we can do better than that...
[...]

Much better; please go ahead and replace my patch with this one.

Signed-off-by: Josh Triplett <josh@kernel.org>

- Josh Triplett

> --- a/kernel/rcutorture.c~rcutorture-remove-redundant-assignment-to-cur_ops-in
> +++ a/kernel/rcutorture.c
> @@ -569,10 +569,6 @@ static struct rcu_torture_ops sched_ops 
>  	.name = "sched"
>  };
>  
> -static struct rcu_torture_ops *torture_ops[] =
> -	{ &rcu_ops, &rcu_sync_ops, &rcu_bh_ops, &rcu_bh_sync_ops,
> -	  &srcu_ops, &qrcu_ops, &sched_ops, NULL };
> -
>  /*
>   * RCU torture writer kthread.  Repeatedly substitutes a new structure
>   * for that pointed to by rcu_torture_current, freeing the old structure
> @@ -939,16 +935,17 @@ rcu_torture_init(void)
>  	int i;
>  	int cpu;
>  	int firsterr = 0;
> +	static struct rcu_torture_ops *torture_ops[] =
> +		{ &rcu_ops, &rcu_sync_ops, &rcu_bh_ops, &rcu_bh_sync_ops,
> +		  &srcu_ops, &qrcu_ops, &sched_ops, };
>  
>  	/* Process args and tell the world that the torturer is on the job. */
> -
> -	for (i = 0; cur_ops = torture_ops[i], cur_ops; i++) {
> +	for (i = 0; i < ARRAY_SIZE(torture_ops); i++) {
>  		cur_ops = torture_ops[i];
> -		if (strcmp(torture_type, cur_ops->name) == 0) {
> +		if (strcmp(torture_type, cur_ops->name) == 0)
>  			break;
> -		}
>  	}
> -	if (cur_ops == NULL) {
> +	if (i == ARRAY_SIZE(torture_ops)) {
>  		printk(KERN_ALERT "rcutorture: invalid torture type: \"%s\"\n",
>  		       torture_type);
>  		return (-EINVAL);
> _
> 
> 
> 

