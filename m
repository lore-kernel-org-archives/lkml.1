Return-Path: <linux-kernel-owner+w=401wt.eu-S1752604AbYLBUCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbYLBUCB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750920AbYLBUBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 15:01:53 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:39450 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750843AbYLBUBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 15:01:52 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAJQeNUlMROB9/2dsb2JhbACBbdEdgXeBCA
Date: Tue, 2 Dec 2008 15:01:50 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] [PATCH] add tracepoints to track change in napi
	states on network receive
Message-ID: <20081202200150.GA27282@Krystal>
References: <20081202195129.GA30042@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081202195129.GA30042@hmsreliant.think-freely.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:56:11 up 15 days, 20:36,  2 users,  load average: 0.35, 0.68,
	0.82
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Neil Horman (nhorman@tuxdriver.com) wrote:
> Hey there-
> 	I thought it would be handy to track the napi receive state of different
> network devices using ltt.  This patch adds trace points to indicate when a napi
> instance has been scheduled, when its serviced and when it completes.
> 

Sounds great, see comments below,

> Regards
> Neil
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> 
>  include/linux/netdevice.h |    4 ++++
>  include/trace/netdevice.h |   36 ++++++++++++++++++++++++++++++++++++
>  ltt/probes/net-trace.c    |   22 ++++++++++++++++++++++
>  net/core/dev.c            |    6 +++++-
>  4 files changed, 67 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 488c56e..9f35f84 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -43,6 +43,8 @@
>  
>  #include <net/net_namespace.h>
>  
> +#include <trace/netdevice.h>
> +
>  struct vlan_group;
>  struct ethtool_ops;
>  struct netpoll_info;
> @@ -386,6 +388,7 @@ static inline void napi_complete(struct napi_struct *n)
>  	local_irq_save(flags);
>  	__napi_complete(n);
>  	local_irq_restore(flags);
> +	trace_napi_complete(n);
>  }
>  
>  /**
> @@ -1726,6 +1729,7 @@ static inline int skb_bond_should_drop(struct sk_buff *skb)
>  	return 0;
>  }
>  
> +
>  #endif /* __KERNEL__ */
>  
>  #endif	/* _LINUX_DEV_H */
> diff --git a/include/trace/netdevice.h b/include/trace/netdevice.h
> new file mode 100644
> index 0000000..c75030b
> --- /dev/null
> +++ b/include/trace/netdevice.h
> @@ -0,0 +1,36 @@
> +#ifndef _INCLUDE_NETDEVICE_H_
> +#define _INCLUDE_NETDEVICE_H_
> +
> +#include <linux/timer.h>
> +#include <linux/delay.h>
> +#include <asm/atomic.h>
> +#include <asm/cache.h>
> +#include <asm/byteorder.h>
> +
> +#include <linux/device.h>
> +#include <linux/percpu.h>
> +#include <linux/dmaengine.h>
> +#include <linux/workqueue.h>
> +
> +#include <net/net_namespace.h>
> +

Hrm ? Do we need all these includes ?

> +/* Tracepoints */
> +
> +/*
> + * Note this is actually the trace for __netif_rx_schedule
> + * since I wanted to trace every call which had us set the RX_SCHED bit

Could you put this comment in the 3rd person ? Also, I wonder if that
mean there might be other cause for schedule we would not trace ?


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
> index bac2b21..3de1ff8 100644
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
> +		"schedule napi instance %p, dev %s",


Field names should have no space, e.g. :

     "napi_struct %p name %s"

Mathieu

> +		n, n->dev->name);
> +}
> +
> +void probe_napi_poll(struct napi_struct *n)
> +{
> +	trace_mark_tp(net_napi_poll, napi_poll, probe_napi_poll,
> +		"service napi instance %p, dev %s",
> +		n, n->dev->name); 
> +}
> +
> +void probe_napi_complete(struct napi_struct *n)
> +{
> +	trace_mark_tp(net_napi_complete, napi_complete, probe_napi_complete,
> +		"complete napi instance %p, dev %s",
> +		n, n->dev->name);
> +}
> +
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Mathieu Desnoyers");
>  MODULE_DESCRIPTION("Net Tracepoint Probes");
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 836fe6e..6021010 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -2329,6 +2329,8 @@ void __napi_schedule(struct napi_struct *n)
>  {
>  	unsigned long flags;
>  
> +	trace_napi_poll(n);
> +
>  	local_irq_save(flags);
>  	list_add_tail(&n->poll_list, &__get_cpu_var(softnet_data).poll_list);
>  	__raise_softirq_irqoff(NET_RX_SOFTIRQ);
> @@ -2380,8 +2382,10 @@ static void net_rx_action(struct softirq_action *h)
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
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
