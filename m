Return-Path: <linux-kernel-owner+w=401wt.eu-S1753796AbYE2EMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbYE2EMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 00:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750792AbYE2EMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 00:12:30 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:55069 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbYE2EM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 00:12:29 -0400
Date: Wed, 28 May 2008 21:12:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for 2.6.26] Markers Use RCU sched
Message-ID: <20080529041207.GC8920@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080527130457.GA6814@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080527130457.GA6814@Krystal>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 09:04:57AM -0400, Mathieu Desnoyers wrote:
> rcu_barrier_sched and call_rcu_sched has been introduced in 2.6.26 for the
> Markers. Change the marker code to use them.
> 
> It can be seen as a fix since the marker code was using an ugly,
> temporary, #ifdef hack to work around CONFIG_PREEMPT_RCU.

Looks good!

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Paul McKenney <paulmck@us.ibm.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> ---
>  kernel/marker.c |   25 ++++++++-----------------
>  1 file changed, 8 insertions(+), 17 deletions(-)
> 
> Index: linux-2.6-lttng/kernel/marker.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/marker.c	2008-05-27 05:32:09.000000000 -0400
> +++ linux-2.6-lttng/kernel/marker.c	2008-05-27 05:34:22.000000000 -0400
> @@ -443,7 +443,7 @@
>  	hlist_del(&e->hlist);
>  	/* Make sure the call_rcu has been executed */
>  	if (e->rcu_pending)
> -		rcu_barrier();
> +		rcu_barrier_sched();
>  	kfree(e);
>  	return 0;
>  }
> @@ -478,7 +478,7 @@
>  	hlist_del(&(*entry)->hlist);
>  	/* Make sure the call_rcu has been executed */
>  	if ((*entry)->rcu_pending)
> -		rcu_barrier();
> +		rcu_barrier_sched();
>  	kfree(*entry);
>  	*entry = e;
>  	trace_mark(core_marker_format, "name %s format %s",
> @@ -657,7 +657,7 @@
>  	 * make sure it's executed now.
>  	 */
>  	if (entry->rcu_pending)
> -		rcu_barrier();
> +		rcu_barrier_sched();
>  	old = marker_entry_add_probe(entry, probe, probe_private);
>  	if (IS_ERR(old)) {
>  		ret = PTR_ERR(old);
> @@ -672,10 +672,7 @@
>  	entry->rcu_pending = 1;
>  	/* write rcu_pending before calling the RCU callback */
>  	smp_wmb();
> -#ifdef CONFIG_PREEMPT_RCU
> -	synchronize_sched();	/* Until we have the call_rcu_sched() */
> -#endif
> -	call_rcu(&entry->rcu, free_old_closure);
> +	call_rcu_sched(&entry->rcu, free_old_closure);
>  end:
>  	mutex_unlock(&markers_mutex);
>  	return ret;
> @@ -706,7 +703,7 @@
>  	if (!entry)
>  		goto end;
>  	if (entry->rcu_pending)
> -		rcu_barrier();
> +		rcu_barrier_sched();
>  	old = marker_entry_remove_probe(entry, probe, probe_private);
>  	mutex_unlock(&markers_mutex);
>  	marker_update_probes();		/* may update entry */
> @@ -718,10 +715,7 @@
>  	entry->rcu_pending = 1;
>  	/* write rcu_pending before calling the RCU callback */
>  	smp_wmb();
> -#ifdef CONFIG_PREEMPT_RCU
> -	synchronize_sched();	/* Until we have the call_rcu_sched() */
> -#endif
> -	call_rcu(&entry->rcu, free_old_closure);
> +	call_rcu_sched(&entry->rcu, free_old_closure);
>  	remove_marker(name);	/* Ignore busy error message */
>  	ret = 0;
>  end:
> @@ -788,7 +782,7 @@
>  		goto end;
>  	}
>  	if (entry->rcu_pending)
> -		rcu_barrier();
> +		rcu_barrier_sched();
>  	old = marker_entry_remove_probe(entry, NULL, probe_private);
>  	mutex_unlock(&markers_mutex);
>  	marker_update_probes();		/* may update entry */
> @@ -799,10 +793,7 @@
>  	entry->rcu_pending = 1;
>  	/* write rcu_pending before calling the RCU callback */
>  	smp_wmb();
> -#ifdef CONFIG_PREEMPT_RCU
> -	synchronize_sched();	/* Until we have the call_rcu_sched() */
> -#endif
> -	call_rcu(&entry->rcu, free_old_closure);
> +	call_rcu_sched(&entry->rcu, free_old_closure);
>  	remove_marker(entry->name);	/* Ignore busy error message */
>  end:
>  	mutex_unlock(&markers_mutex);
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
