Return-Path: <linux-kernel-owner+w=401wt.eu-S1751719AbZHSKnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbZHSKnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 06:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbZHSKne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 06:43:34 -0400
Received: from waste.org ([173.11.57.241]:34606 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbZHSKnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 06:43:32 -0400
Subject: Re: [PATCH] netpoll: WARN_ONCE for start_xmit returns with
 interrupts enabled
From: Matt Mackall <mpm@selenic.com>
To: DDD <Dongdong.deng@windriver.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1250678607.17891.26.camel@dengdd-desktop>
References: <1250678607.17891.26.camel@dengdd-desktop>
Content-Type: text/plain
Date: Wed, 19 Aug 2009 05:43:16 -0500
Message-Id: <1250678596.3937.182.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-19 at 18:43 +0800, DDD wrote:
> The NETPOLL API requires that interrupts remain disabled in
> netpoll_send_skb().
> 
> Add a WARN_ONCE when ndo_start_xmit returns with interrupts enabled
> in netpoll_send_skb().
> 
> Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
> ---
>  net/core/netpoll.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/net/core/netpoll.c b/net/core/netpoll.c
> index df30feb..d38103f 100644
> --- a/net/core/netpoll.c
> +++ b/net/core/netpoll.c
> @@ -319,6 +319,12 @@ static void netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
>  
>  			udelay(USEC_PER_POLL);
>  		}
> +
> +		WARN_ONCE(!irqs_disabled(),
> +			KERN_WARNING "netpoll_send_skb(): [net driver %s]"
> +			"ndo_start_xmit() shouldn't return with interrupts"
> +			"enabled!", dev->name);

Hmm, perhaps:

"netpoll_send_skb(): %s enabled interrupts in poll (%pF)\n",
dev->name, ops->ndo_start_xmit

That'll give us a real function name and maybe even a module name.

-- 
http://selenic.com : development and support for Mercurial and Linux


