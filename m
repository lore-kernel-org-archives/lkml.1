Return-Path: <linux-kernel-owner+w=401wt.eu-S1756963AbZLKDfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963AbZLKDfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 22:35:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756215AbZLKDfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 22:35:39 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:39221 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176AbZLKDfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 22:35:37 -0500
Date: Fri, 11 Dec 2009 14:35:42 +1100
From: Simon Horman <horms@verge.net.au>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Wensong Zhang <wensong@linux-vs.org>,
       Julian Anastasov <ja@ssi.bg>, "David S. Miller" <davem@davemloft.net>,
       Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ipvs: fix synchronization on connection close
Message-ID: <20091211033542.GA28136@verge.net.au>
References: <1260434502-14166-1-git-send-email-dfeng@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260434502-14166-1-git-send-email-dfeng@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 04:41:42PM +0800, Xiaotian Feng wrote:
> commit 9d3a0de makes slaves expire as they would do on the master
> with much shorter timeouts. But it introduces another problem:
> When we close a connection, on master server the connection became
> CLOSE_WAIT/TIME_WAIT, it was synced to slaves, but if master is
> finished within it's timeouts (CLOSE), it will not be synced to
> slaves. Then slaves will be kept on CLOSE_WAIT/TIME_WAIT until
> timeout reaches. Thus we should also sync with CLOSE.
> 
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> Cc: Wensong Zhang <wensong@linux-vs.org>
> Cc: Simon Horman <horms@verge.net.au>
> Cc: Julian Anastasov <ja@ssi.bg>
> Cc: David S. Miller <davem@davemloft.net>

This seems reasonable to me.

Acked-by: Simon Horman <horms@verge.net.au>

> ---
>  net/netfilter/ipvs/ip_vs_core.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> index b95699f..847ffca 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c
> @@ -1366,6 +1366,7 @@ ip_vs_in(unsigned int hooknum, struct sk_buff *skb,
>  	       == sysctl_ip_vs_sync_threshold[0])) ||
>  	     ((cp->protocol == IPPROTO_TCP) && (cp->old_state != cp->state) &&
>  	      ((cp->state == IP_VS_TCP_S_FIN_WAIT) ||
> +	       (cp->state == IP_VS_TCP_S_CLOSE) ||
>  	       (cp->state == IP_VS_TCP_S_CLOSE_WAIT) ||
>  	       (cp->state == IP_VS_TCP_S_TIME_WAIT)))))
>  		ip_vs_sync_conn(cp);
> -- 
> 1.6.5.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
