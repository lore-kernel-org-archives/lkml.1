Return-Path: <linux-kernel-owner+w=401wt.eu-S1753929AbYLCSLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbYLCSLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 13:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbYLCSLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 13:11:08 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:55836 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751268AbYLCSLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 13:11:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAL9aNklMROB9/2dsb2JhbACBbdE+gn8
Date: Wed, 3 Dec 2008 13:11:05 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] [PATCH] add tracepoints to track change in napi
	states on network receive
Message-ID: <20081203181105.GA6794@Krystal>
References: <20081202195129.GA30042@hmsreliant.think-freely.org> <20081202200150.GA27282@Krystal> <20081203160134.GA6549@hmsreliant.think-freely.org> <20081203172507.GA4471@Krystal> <20081203174500.GB6549@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081203174500.GB6549@hmsreliant.think-freely.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:10:10 up 16 days, 18:50,  2 users,  load average: 2.86, 1.05,
	0.70
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Neil Horman (nhorman@tuxdriver.com) wrote:
> On Wed, Dec 03, 2008 at 12:25:07PM -0500, Mathieu Desnoyers wrote:
> > Almost there :)
> > 
> > There is a extra whitespace above,
> > 
> > and also  "schedule napi_struct" should probably be changed into
> > napi_struct only, this removes the whitespace and duplicated information
> > (I guess we know that given we are in event net_napi_schedule, this will
> > have something to do with schedule...). Same applies to trace_mark_tp
> > below.
> > 
> > Thanks,
> > 
> > Mathieu
> 
> 
> Sure, here you go, new patch
> 
> Patch to trace napi states for various net devices and their napi instances.
> Traces scheduling, servicing and completion of a napi poll request.
> 
> Regards
> Neil
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 

Actually I notice that you used the old "DEFINE_TRACE" tracepoint API.
I'll update your patch to the new DECLARE/DEFINE_TRACE tracepoint API.

Mathieu

> 
>  include/linux/netdevice.h |    5 +++++
>  include/trace/netdevice.h |   30 ++++++++++++++++++++++++++++++
>  ltt/probes/net-trace.c    |   22 ++++++++++++++++++++++
>  net/core/dev.c            |    7 ++++++-
>  4 files changed, 63 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 488c56e..7da71eb 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -43,6 +43,9 @@
>  
>  #include <net/net_namespace.h>
>  
> +struct napi_struct;
> +#include <trace/netdevice.h>
> +
>  struct vlan_group;
>  struct ethtool_ops;
>  struct netpoll_info;
> @@ -386,6 +389,7 @@ static inline void napi_complete(struct napi_struct *n)
>  	local_irq_save(flags);
>  	__napi_complete(n);
>  	local_irq_restore(flags);
> +	trace_napi_complete(n);
>  }
>  
>  /**
> @@ -1726,6 +1730,7 @@ static inline int skb_bond_should_drop(struct sk_buff *skb)
>  	return 0;
>  }
>  
> +
>  #endif /* __KERNEL__ */
>  
>  #endif	/* _LINUX_DEV_H */
> diff --git a/include/trace/netdevice.h b/include/trace/netdevice.h
> new file mode 100644
> index 0000000..ba48f6c
> --- /dev/null
> +++ b/include/trace/netdevice.h
> @@ -0,0 +1,30 @@
> +#ifndef _INCLUDE_NETDEVICE_H_
> +#define _INCLUDE_NETDEVICE_H_
> +
> +#include <linux/netdevice.h>
> +
> +/* Tracepoints */
> +
> +/*
> + * Note these first 2 traces are actually in __napi_schedule and net_rx_action
> + * respectively.  The former is in __napi_schedule because it uses at-most-once
> + * logic and placing it in the calling routine (napi_schedule) would produce
> + * countless trace events that were effectively  no-ops.  napi_poll is
> + * implemented in net_rx_action, because thats where we do our polling on
> + * devices.  The last trace point is in napi_complete, right where you would
> + * think it would be.
> + */
> +DEFINE_TRACE(napi_schedule,
> +	TPPROTO(struct napi_struct *n),
> +	TPARGS(n));
> +
> +DEFINE_TRACE(napi_poll,
> +	TPPROTO(struct napi_struct *n),
> +	TPARGS(n));
> +
> +DEFINE_TRACE(napi_complete,
> +	TPPROTO(struct napi_struct *n),
> +	TPARGS(n));
> +
> +#endif
> +
> diff --git a/ltt/probes/net-trace.c b/ltt/probes/net-trace.c
> index bac2b21..e887e70 100644
> --- a/ltt/probes/net-trace.c
> +++ b/ltt/probes/net-trace.c
> @@ -9,6 +9,7 @@
>  #include <trace/ipv4.h>
>  #include <trace/ipv6.h>
>  #include <trace/socket.h>
> +#include <trace/netdevice.h>
>  
>  void probe_net_dev_xmit(struct sk_buff *skb)
>  {
> @@ -104,6 +105,27 @@ void probe_socket_call(int call, unsigned long a0)
>  		"call %d a0 %lu", call, a0);
>  }
>  
> +void probe_napi_schedule(struct napi_struct *n)
> +{
> +	trace_mark_tp(net_napi_schedule, napi_schedule, probe_napi_schedule,
> +		"napi_struct %p name  %s",
> +		n, n->dev->name);
> +}
> +
> +void probe_napi_poll(struct napi_struct *n)
> +{
> +	trace_mark_tp(net_napi_poll, napi_poll, probe_napi_poll,
> +		"napi_struct %p name %s",
> +		n, n->dev->name);
> +}
> +
> +void probe_napi_complete(struct napi_struct *n)
> +{
> +	trace_mark_tp(net_napi_complete, napi_complete, probe_napi_complete,
> +		"napi_struct %p name %s",
> +		n, n->dev->name);
> +}
> +
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Mathieu Desnoyers");
>  MODULE_DESCRIPTION("Net Tracepoint Probes");
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 836fe6e..0c55c0f 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -128,6 +128,7 @@
>  #include <linux/jhash.h>
>  #include <linux/random.h>
>  #include <trace/net.h>
> +#include <trace/netdevice.h>
>  
>  #include "net-sysfs.h"
>  
> @@ -2329,6 +2330,8 @@ void __napi_schedule(struct napi_struct *n)
>  {
>  	unsigned long flags;
>  
> +	trace_napi_poll(n);
> +
>  	local_irq_save(flags);
>  	list_add_tail(&n->poll_list, &__get_cpu_var(softnet_data).poll_list);
>  	__raise_softirq_irqoff(NET_RX_SOFTIRQ);
> @@ -2380,8 +2383,10 @@ static void net_rx_action(struct softirq_action *h)
>  		 * accidently calling ->poll() when NAPI is not scheduled.
>  		 */
>  		work = 0;
> -		if (test_bit(NAPI_STATE_SCHED, &n->state))
> +		if (test_bit(NAPI_STATE_SCHED, &n->state)) {
> +			trace_napi_poll(n);
>  			work = n->poll(n, weight);
> +		}
>  
>  		WARN_ON_ONCE(work > weight);
>  
> -- 
> /****************************************************
>  * Neil Horman <nhorman@tuxdriver.com>
>  * Software Engineer, Red Hat
>  ****************************************************/
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
