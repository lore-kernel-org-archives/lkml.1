Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbYDVFp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbYDVFp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 01:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbYDVFpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 01:45:49 -0400
Received: from namei.org ([69.55.235.186]:41429 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752728AbYDVFps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 01:45:48 -0400
Date: Tue, 22 Apr 2008 15:42:47 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       dwalker@mvista.com, sdietrich@novell.com, dvhltc@us.ibm.com,
       niv@us.ibm.com, Eric Paris <eparis@redhat.com>,
       Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH] SELinux fixups needed for preemptable RCU from -rt
In-Reply-To: <20080422011233.GG9153@linux.vnet.ibm.com>
Message-ID: <Xine.LNX.4.64.0804221537550.23645@us.intercode.com.au>
References: <20080422003412.GA9983@linux.vnet.ibm.com>
 <Pine.LNX.4.58.0804212053530.25185@gandalf.stny.rr.com>
 <20080422011233.GG9153@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, applied to

git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/selinux-2.6.git#for-linus


> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com> (comment change)
> ---
>  security/selinux/avc.c   |    9 +++++++++
>  security/selinux/netif.c |    2 ++
>  2 files changed, 11 insertions(+)
> 
> Index: linux-2.6.24.4-rt4/security/selinux/avc.c
> ===================================================================
> --- linux-2.6.24.4-rt4.orig/security/selinux/avc.c	2008-03-24 19:05:09.000000000 -0400
> +++ linux-2.6.24.4-rt4/security/selinux/avc.c	2008-03-24 19:06:41.000000000 -0400
> @@ -312,6 +312,7 @@ static inline int avc_reclaim_node(void)
>  		if (!spin_trylock_irqsave(&avc_cache.slots_lock[hvalue], flags))
>  			continue;
>  
> +		rcu_read_lock();
>  		list_for_each_entry(node, &avc_cache.slots[hvalue], list) {
>  			if (atomic_dec_and_test(&node->ae.used)) {
>  				/* Recently Unused */
> @@ -319,11 +320,13 @@ static inline int avc_reclaim_node(void)
>  				avc_cache_stats_incr(reclaims);
>  				ecx++;
>  				if (ecx >= AVC_CACHE_RECLAIM) {
> +					rcu_read_unlock();
>  					spin_unlock_irqrestore(&avc_cache.slots_lock[hvalue], flags);
>  					goto out;
>  				}
>  			}
>  		}
> +		rcu_read_unlock();
>  		spin_unlock_irqrestore(&avc_cache.slots_lock[hvalue], flags);
>  	}
>  out:
> @@ -807,8 +810,14 @@ int avc_ss_reset(u32 seqno)
>  
>  	for (i = 0; i < AVC_CACHE_SLOTS; i++) {
>  		spin_lock_irqsave(&avc_cache.slots_lock[i], flag);
> +		/*
> +		 * With preemptable RCU, the outer spinlock does not
> +		 * prevent RCU grace periods from ending.
> +		 */
> +		rcu_read_lock();
>  		list_for_each_entry(node, &avc_cache.slots[i], list)
>  			avc_node_delete(node);
> +		rcu_read_unlock();
>  		spin_unlock_irqrestore(&avc_cache.slots_lock[i], flag);
>  	}
>  
> Index: linux-2.6.24.4-rt4/security/selinux/netif.c
> ===================================================================
> --- linux-2.6.24.4-rt4.orig/security/selinux/netif.c	2008-03-24 19:05:09.000000000 -0400
> +++ linux-2.6.24.4-rt4/security/selinux/netif.c	2008-03-24 19:06:41.000000000 -0400
> @@ -210,6 +210,7 @@ static void sel_netif_flush(void)
>  {
>  	int idx;
>  
> +	rcu_read_lock();
>  	spin_lock_bh(&sel_netif_lock);
>  	for (idx = 0; idx < SEL_NETIF_HASH_SIZE; idx++) {
>  		struct sel_netif *netif;
> @@ -218,6 +219,7 @@ static void sel_netif_flush(void)
>  			sel_netif_destroy(netif);
>  	}
>  	spin_unlock_bh(&sel_netif_lock);
> +	rcu_read_unlock();
>  }
>  
>  static int sel_netif_avc_callback(u32 event, u32 ssid, u32 tsid,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
James Morris
<jmorris@namei.org>
