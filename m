Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbYJFVW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbYJFVW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 17:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbYJFVWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 17:22:45 -0400
Received: from smtp2a.orange.fr ([80.12.242.140]:32754 "EHLO smtp2a.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960AbYJFVWo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 17:22:44 -0400
X-ME-UUID: 20081006212242914.DF5B27000093@mwinf2a23.orange.fr
Message-ID: <48EA8197.6080502@cosmosbay.com>
Date: Mon, 06 Oct 2008 23:22:31 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: minyard@acm.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       shemminger@vyatta.com, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 3/3] Convert the UDP hash lock to RCU
References: <20081006185026.GA10383@minyard.local>
In-Reply-To: <20081006185026.GA10383@minyard.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corey Minyard a écrit :
> Change the UDP hash lock from an rwlock to RCU.
> 
> Signed-off-by: Corey Minyard <cminyard@mvista.com>
> ---
>  include/net/udp.h |    9 +++++----
>  net/ipv4/udp.c    |   47 +++++++++++++++++++++++++++--------------------
>  net/ipv6/udp.c    |   17 +++++++++--------
>  3 files changed, 41 insertions(+), 32 deletions(-)
> 
> diff --git a/include/net/udp.h b/include/net/udp.h
> index addcdc6..35aa104 100644
> --- a/include/net/udp.h
> +++ b/include/net/udp.h
> @@ -51,7 +51,7 @@ struct udp_skb_cb {
>  #define UDP_SKB_CB(__skb)	((struct udp_skb_cb *)((__skb)->cb))
>  
>  extern struct hlist_head udp_hash[UDP_HTABLE_SIZE];
> -extern rwlock_t udp_hash_lock;
> +extern spinlock_t udp_hash_wlock;
>  
>  
>  /* Note: this must match 'valbool' in sock_setsockopt */
> @@ -112,12 +112,13 @@ static inline void udp_lib_hash(struct sock *sk)
>  
>  static inline void udp_lib_unhash(struct sock *sk)
>  {
> -	write_lock_bh(&udp_hash_lock);
> -	if (sk_del_node_init(sk)) {
> +	spin_lock_bh(&udp_hash_wlock);
> +	if (sk_del_node_init_rcu(sk)) {
>  		inet_sk(sk)->num = 0;
>  		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
>  	}
> -	write_unlock_bh(&udp_hash_lock);
> +	spin_unlock_bh(&udp_hash_wlock);
> +	synchronize_rcu();

UDP central rwlock can hurt performance, because of cache line ping pong,
so your patch really makes sense.

Me wondering what impact this synchronize_rcu() can have on mono-threaded
VOIP applications using lot of UDP sockets. What is the maximum delay of
this function ?

For "struct file" freeing, we chose call_rcu() instead of synchronize_rcu()

Maybe we could add a generic rcu head to struct sock, and use call_rcu() in
sk_prot_free() for sockets needing RCU (udp after your patch is applied, maybe
tcp on future patches, while I believe previous work on the subject concluded
RCU was not giving good results for short lived http sessions) ?

Or just add SLAB_DESTROY_BY_RCU to slab creation in proto_register()
for "struct proto udp_prot/udpv6_prot" so that kmem_cache_free() 
done in sk_prot_free() can defer freeing to RCU...




