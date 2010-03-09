Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab0CIQWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 11:22:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58163 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751813Ab0CIQWh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 11:22:37 -0500
Date: Tue, 9 Mar 2010 08:22:03 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Subject: Re: [2.6.34-rc1] CPU stalls when closing TCP sockets.
Message-ID: <20100309082203.18c13609@nehalam>
In-Reply-To: <1268150156.3113.12.camel@edumazet-laptop>
References: <201003090319.o293J6WF026448@www262.sakura.ne.jp>
	<1268116647.2819.64.camel@edumazet-laptop>
	<201003090654.o296sCnh065487@www262.sakura.ne.jp>
	<1268150156.3113.12.camel@edumazet-laptop>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Mar 2010 16:55:56 +0100
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Le mardi 09 mars 2010 à 15:54 +0900, Tetsuo Handa a écrit :
> > Eric Dumazet wrote:
> > > Nothing comes to my mind, I'll try to reproduce this here.
> > 
> > When stopped at (8), Ctrl-C doesn't work.
> > 
> > > Is 2.6.33 OK ?
> > 
> > Yes. 2.6.33 and earlier are OK.
> 
> OK thanks !
> 
> I believe commit d218d11133d888f9745802146a50255a4781d37a
> (tcp: Generalized TTL Security Mechanism) might be the bug origin.
> 
> I am testing following patch, based on latest net-2.6 tree (including
> the LINUX_MIB_TCPMINTTLDROP bit)
> 
> [PATCH] tcp: Fix tcp_v4_rcv()
> 
> Commit d218d111 (tcp: Generalized TTL Security Mechanism) added a bug
> for TIMEWAIT sockets. We should not test min_ttl for TW sockets.
> 
> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> ---
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 8d51d39..70df409 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -1651,15 +1651,15 @@ int tcp_v4_rcv(struct sk_buff *skb)
>  	if (!sk)
>  		goto no_tcp_socket;
>  
> +process:
> +	if (sk->sk_state == TCP_TIME_WAIT)
> +		goto do_time_wait;
> +
>  	if (unlikely(iph->ttl < inet_sk(sk)->min_ttl)) {
>  		NET_INC_STATS_BH(net, LINUX_MIB_TCPMINTTLDROP);
>  		goto discard_and_relse;
>  	}
>  
> -process:
> -	if (sk->sk_state == TCP_TIME_WAIT)
> -		goto do_time_wait;
> -
>  	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb))
>  		goto discard_and_relse;
>  	nf_reset(skb);
> 
> 

Agreed.
Acked-by: Stephen Hemminger <shemminger@vyatta.com>


-- 
