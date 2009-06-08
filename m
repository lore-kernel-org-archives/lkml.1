Return-Path: <linux-kernel-owner+w=401wt.eu-S1756234AbZFHQFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbZFHQFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 12:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbZFHQF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 12:05:28 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44153 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755417AbZFHQF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 12:05:26 -0400
Date: Mon, 8 Jun 2009 09:05:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jesper Dangaard Brouer <hawk@comx.dk>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, urs.thuermann@volkswagen.de,
       oliver.hartkopp@volkswagen.de, wg@grandegger.com,
       vladislav.yasevich@hp.com, sri@us.ibm.com, linux-sctp@vger.kernel.org,
       Trond.Myklebust@netapp.com, linux-nfs@vger.kernel.org,
       netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 2/5] nfnetlink_queue: Use rcu_barrier() on module
	unload.
Message-ID: <20090608160522.GC6961@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090608130959.10052.54590.stgit@localhost> <20090608131133.10052.40836.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608131133.10052.40836.stgit@localhost>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 03:11:33PM +0200, Jesper Dangaard Brouer wrote:
> This module uses rcu_call() thus it should use rcu_barrier() on module unload.
> 
> Also fixed a trivial typo 'nfetlink' -> 'nfnetlink' in comment.

Assuming that netlink_unregister_notifier(), nfnetlink_subsys_unregister(),
and so on prevent any subsequent calls to call_rcu(), looks good!!!

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>
> ---
> 
>  net/netfilter/nfnetlink_queue.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index 8c86011..71daa09 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -1,6 +1,6 @@
>  /*
>   * This is a module which is used for queueing packets and communicating with
> - * userspace via nfetlink.
> + * userspace via nfnetlink.
>   *
>   * (C) 2005 by Harald Welte <laforge@netfilter.org>
>   * (C) 2007 by Patrick McHardy <kaber@trash.net>
> @@ -932,6 +932,8 @@ static void __exit nfnetlink_queue_fini(void)
>  #endif
>  	nfnetlink_subsys_unregister(&nfqnl_subsys);
>  	netlink_unregister_notifier(&nfqnl_rtnl_notifier);
> +
> +	rcu_barrier(); /* Wait for completion of call_rcu()'s */
>  }
> 
>  MODULE_DESCRIPTION("netfilter packet queue handler");
> 
