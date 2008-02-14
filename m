Return-Path: <linux-kernel-owner+w=401wt.eu-S1758970AbYBNDcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970AbYBNDcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 22:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbYBNDcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 22:32:20 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:48805 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752236AbYBNDcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 22:32:19 -0500
Date: Thu, 14 Feb 2008 09:02:09 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, shemminger@vyatta.com, davem@davemloft.net,
       netdev@vger.kernel.org, dipankar@in.ibm.com,
       herbert@gondor.apana.org.au, akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] add rcu_assign_index() if ever needed
Message-ID: <20080214033209.GA7266@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20080213220024.GA30729@linux.vnet.ibm.com> <20080213220515.GA10642@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213220515.GA10642@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 02:05:15PM -0800, Paul E. McKenney wrote:
> Hello again!
> 
> This is a speculative patch that as far as I can tell is not yet required.
> If anyone applies RCU to a data structure allocated out of an array, using
> array indexes in place of pointers to link the array elements together,
> then the rcu_assign_index() function in this patch will be needed to
> assign a given element's array index to the RCU-traversed index.  The
> implementation is exactly that of the old rcu_assign_pointer(), so is
> extremely well tested.
> 
> The existing rcu_assign_pointer() will emit a compiler warning in cases
> where rcu_assign_index() is required.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
>  rcupdate.h |   18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff -urpNa -X dontdiff linux-2.6.24-rap/include/linux/rcupdate.h linux-2.6.24-rai/include/linux/rcupdate.h
> --- linux-2.6.24-rap/include/linux/rcupdate.h	2008-02-13 13:36:47.000000000 -0800
> +++ linux-2.6.24-rai/include/linux/rcupdate.h	2008-02-13 10:55:40.000000000 -0800
> @@ -286,6 +286,24 @@ extern struct lockdep_map rcu_lock_map;
>  	})
> 
>  /**
> + * rcu_assign_index - assign (publicize) a index of a newly
> + * initialized array elementg that will be dereferenced by RCU
			^^^^^^^^ 

I hope Andrew got that one while porting against the latest -mm :)

Looks good otherwise.


> + * read-side critical sections.  Returns the value assigned.
> + *
> + * Inserts memory barriers on architectures that require them
> + * (pretty much all of them other than x86), and also prevents
> + * the compiler from reordering the code that initializes the
> + * structure after the index assignment.  More importantly, this
> + * call documents which indexes will be dereferenced by RCU read-side
> + * code.
> + */
> +
> +#define rcu_assign_index(p, v)	({ \
> +					smp_wmb(); \
> +					(p) = (v); \
> +				})
> +
> +/**
>   * synchronize_sched - block until all CPUs have exited any non-preemptive
>   * kernel code sequences.
>   *

-- 
Thanks and Regards
gautham
