Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbYJAS5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbYJAS5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 14:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbYJAS5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 14:57:09 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:5874 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753695AbYJAS5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 14:57:08 -0400
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH 18/30] netvm: INET reserves.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Daniel Lezcano <dlezcano@fr.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       Pekka Enberg <penberg@cs.helsinki.fi>, Neil Brown <neilb@suse.de>
In-Reply-To: <48E3612E.1020607@fr.ibm.com>
References: <20080724140042.408642539@chello.nl>
	 <20080724141530.573585429@chello.nl>  <48E3612E.1020607@fr.ibm.com>
Content-Type: text/plain
Date: Wed, 01 Oct 2008 20:56:59 +0200
Message-Id: <1222887419.8695.22.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-01 at 13:38 +0200, Daniel Lezcano wrote:

> I removed a big portion of code because the remarks below apply to the 
> rest of the code.
> 
> > +static int sysctl_intvec_route(struct ctl_table *table,
> > +		int __user *name, int nlen,
> > +		void __user *oldval, size_t __user *oldlenp,
> > +		void __user *newval, size_t newlen)
> > +{
> > +	struct net *net = current->nsproxy->net_ns;
> 
> I think you can use the container_of and get rid of using 
> current->nsproxy->net_ns.
> 
> 	struct net *net = container_of(table->data, struct net,
> 				ipv6.sysctl.ip6_rt_max_size);

D'oh - why didn't I think of that... yes very nice.


> > +	int write = (newval && newlen);
> > +	int new_size, ret;
> > +
> > +	mutex_lock(&net->ipv6.sysctl.ip6_rt_lock);
> > +
> > +	if (write)
> > +		table->data = &new_size;
> > +
> > +	ret = sysctl_intvec(table, name, nlen, oldval, oldlenp, newval, newlen);
> > +
> > +	if (!ret && write) {
> > +		ret = mem_reserve_kmem_cache_set(&net->ipv6.ip6_rt_reserve,
> > +				net->ipv6.ip6_dst_ops.kmem_cachep, new_size);
> > +		if (!ret)
> > +			net->ipv6.sysctl.ip6_rt_max_size = new_size;
> > +	}
> > +
> > +	if (write)
> > +		table->data = &net->ipv6.sysctl.ip6_rt_max_size;
> > +
> > +	mutex_unlock(&net->ipv6.sysctl.ip6_rt_lock);
> > +
> > +	return ret;
> > +}
> 
> Dancing with the table->data looks safe but it is not very nice.
> Isn't possible to use a temporary table like in the function 
> "ipv4_sysctl_local_port_range" ?

Ah, nice solution. Thanks!

> > Index: linux-2.6/net/ipv6/af_inet6.c
> > ===================================================================
> > --- linux-2.6.orig/net/ipv6/af_inet6.c
> > +++ linux-2.6/net/ipv6/af_inet6.c
> > @@ -851,6 +851,20 @@ static int inet6_net_init(struct net *ne
> >  	net->ipv6.sysctl.ip6_rt_min_advmss = IPV6_MIN_MTU - 20 - 40;
> >  	net->ipv6.sysctl.icmpv6_time = 1*HZ;
> > 
> > +	mem_reserve_init(&net->ipv6.ip6_rt_reserve, "IPv6 route cache",
> > +			 &net_rx_reserve);
> > +	/*
> > +	 * XXX: requires that net->ipv6.ip6_dst_ops is already set-up
> > +	 *      but afaikt its impossible to order the various
> > +	 *      pernet_subsys calls so that this one is done after
> > +	 *      ip6_route_net_init().
> > +	 */
> 
> As this code seems related to the routes, is there a particular reason 
> to not put it at the end of "ip6_route_net_init" function ? You will be 
> sure "net->ipv6.ip6_dst_ops is already set-up", no ?

Ah, the problem is that I need both dst_ops and ip6_rt_max_size set.

The former is set in ip6_route_net_init() while the later is set in
inet6_net_init(), both are registered pernet_ops without specified
order.

So where exactly do I hook in?

> > +	err = mem_reserve_kmem_cache_set(&net->ipv6.ip6_rt_reserve,
> > +			net->ipv6.ip6_dst_ops.kmem_cachep,
> > +			net->ipv6.sysctl.ip6_rt_max_size);
> > +	if (err)
> > +		goto reserve_fail;
> > +
> >  #ifdef CONFIG_PROC_FS
> >  	err = udp6_proc_init(net);
> >  	if (err)
> > @@ -861,8 +875,8 @@ static int inet6_net_init(struct net *ne
> >  	err = ac6_proc_init(net);
> >  	if (err)
> >  		goto proc_ac6_fail;
> > -out:
> >  #endif
> > +out:
> >  	return err;
> > 
> >  #ifdef CONFIG_PROC_FS
> > @@ -870,8 +884,10 @@ proc_ac6_fail:
> >  	tcp6_proc_exit(net);
> >  proc_tcp6_fail:
> >  	udp6_proc_exit(net);
> > -	goto out;
> >  #endif
> > +reserve_fail:
> > +	mem_reserve_disconnect(&net->ipv6.ip6_rt_reserve);
> 
> Idem.
> 
> > +	goto out;
> >  }
> > 
> >  static void inet6_net_exit(struct net *net)
> 
> Isn't "mem_reserve_disconnect" missing here ? (but going to 
> ip6_route_net_exit)

Probably, I'll go over the exit paths once I get the init path ;-)

> I hope this review helped :)

It did, much appreciated!

