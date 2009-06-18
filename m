Return-Path: <linux-kernel-owner+w=401wt.eu-S1763577AbZFROHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763577AbZFROHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 10:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759005AbZFROHC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 10:07:02 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:59069 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758566AbZFROHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 10:07:00 -0400
Message-ID: <4A3A49F2.6060705@gmail.com>
Date: Thu, 18 Jun 2009 16:06:42 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, fbl@redhat.com,
       nhorman@redhat.com, davem@redhat.com, oleg@redhat.com
Subject: Re: [RFC] tcp: race in receive part
References: <20090618102727.GC3782@jolsa.lab.eng.brq.redhat.com>
In-Reply-To: <20090618102727.GC3782@jolsa.lab.eng.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 18 Jun 2009 16:06:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa a écrit :
> Hi,
> 
> in RHEL4 we can see a race in the tcp layer. We were not able to reproduce 
> this on the upstream kernel, but since the issue occurs very rarelly
> (once per 8 days), we just might not be lucky.
> 
> I'm affraid this might be a long email, I'll try to structure it nicely.. :)
> 

Thanks for your mail and detailed analysis

> 
> 
> RACE DESCRIPTION
> ================
> 
> There's a nice pdf describing the issue (and sollution using locks) on
> https://bugzilla.redhat.com/attachment.cgi?id=345014

I could not reach this url unfortunatly 

--> "You are not authorized to access bug #494404. "

> 
> 
> The race fires, when following code paths meet, and the tp->rcv_nxt and
> __add_wait_queue updates stay in CPU caches.
> 
> CPU1                         CPU2
> 
> 
> sys_select                   receive packet
>   ...                        ...
>   __add_wait_queue           update tp->rcv_nxt
>   ...                        ...
>   tp->rcv_nxt check          sock_def_readable
>   ...                        {
>   schedule                      ...
>                                 if (sk->sk_sleep && waitqueue_active(sk->sk_sleep))
>                                         wake_up_interruptible(sk->sk_sleep)
>                                 ...
>                              }
> 
> If there were no cache the code would work ok, since the wait_queue and
> rcv_nxt are opposit to each other.
> 
> Meaning that once tp->rcv_nxt is updated by CPU2, the CPU1 either already
> passed the tp->rcv_nxt check and sleeps, or will get the new value for
> tp->rcv_nxt and will return with new data mask.  
> In both cases the process (CPU1) is being added to the wait queue, so the
> waitqueue_active (CPU2) call cannot miss and will wake up CPU1.
> 
> The bad case is when the __add_wait_queue changes done by CPU1 stay in its
> cache , and so does the tp->rcv_nxt update on CPU2 side.  The CPU1 will then
> endup calling schedule and sleep forever if there are no more data on the
> socket.
> 
> Adding smp_mb() calls before sock_def_readable call and after __add_wait_queue
> should prevent the above bad scenario.
> 
> The upstream patch is attached. It seems to prevent the issue.
> 
> 
> 
> CPU BUGS
> ========
> 
> The customer has been able to reproduce this problem only on one CPU model:
> Xeon E5345*2. They didn't reproduce on XEON MV, for example.

Is there an easy way to reproduce the problem ?

> 
> That CPU model happens to have 2 possible issues, that might cause the issue:
> (see errata http://www.intel.com/Assets/PDF/specupdate/315338.pdf)
> 
> AJ39 and AJ18. The first one can be workarounded by BIOS upgrade,
> the other one has following notes:

AJ18 only matters on unaligned accesses, tcp code doesnt do this.

> 
>       Software should ensure at least one of the following is true when
>       modifying shared data by multiple agents:
>              • The shared data is aligned
>              • Proper semaphores or barriers are used in order to
>                 prevent concurrent data accesses.
> 
> 
> 
> RFC
> ===
> 
> I'm aware that not having this issue reproduced on upstream lowers the odds
> having this checked in. However AFAICS the issue is present. I'd appreciate
> any comment/ideas.
> 
> 
> thanks,
> jirka
> 
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> 
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 17b89c5..f5d9dbf 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -340,6 +340,11 @@ unsigned int tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
>  	struct tcp_sock *tp = tcp_sk(sk);
>  
>  	poll_wait(file, sk->sk_sleep, wait);

poll_wait() calls add_wait_queue() which contains a 
spin_lock_irqsave()/spin_unlock_irqrestore() pair

Documentation/memory-barriers.txt states in line 1123 :

	Memory operations issued after the LOCK will be completed after the LOCK
	operation has completed.

and line 1131 states :

	Memory operations issued before the UNLOCK will be completed before the
	UNLOCK operation has completed.

So yes, there is no full smp_mb() in poll_wait()

> +
> +	/* Get in sync with tcp_data_queue, tcp_urg
> +	   and tcp_rcv_established function. */
> +	smp_mb();

If this barrier is really necessary, I guess it should be done in poll_wait() itself.

Documentation/memory-barriers.txt misses some information about poll_wait()




> +
>  	if (sk->sk_state == TCP_LISTEN)
>  		return inet_csk_listen_poll(sk);
>  
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 2bdb0da..0606e5e 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -4362,8 +4362,11 @@ queue_and_out:
>  
>  		if (eaten > 0)
>  			__kfree_skb(skb);
> -		else if (!sock_flag(sk, SOCK_DEAD))
> +		else if (!sock_flag(sk, SOCK_DEAD)) {
> +			/* Get in sync with tcp_poll function. */
> +			smp_mb();
>  			sk->sk_data_ready(sk, 0);
> +		}
>  		return;
>

Oh well... if smp_mb() is needed, I believe it should be done
right before "if (waitqueue_active(sk->sk_sleep) ... "

 	read_lock(&sk->sk_callback_lock);
+	smp_mb();
 	if (sk->sk_sleep && waitqueue_active(sk->sk_sleep))
 		wake_up_interruptible(sk->sk_sleep)

It would match other parts in kernel (see fs/splice.c, fs/aio.c, ...)

Strange thing is that read_lock() on x86 is a full memory barrier, as it uses
"lock subl $0x1,(%eax)"

Maybe we could define a smp_mb_after_read_lock()  (a compiler barrier() on x86)

