Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab0CBL17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 06:27:59 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:34529 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab0CBL15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 06:27:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XGP+aIjHzcoU1pAFp9L8uyFI8bny1L1Vnw8P00rqUldrmoBEKg8Eu/3L1RZ7r/0Pbc
         Le0Q5+/Ay+Yf3uyG/EJHfJK7IbXWob89TYiAwnTFygJQpgS2nLbWsKirSH6j7ZWnWVRj
         Bi7nBjiPzeM2uZ//wD5ULMTerSOs15cNYsbbc=
Subject: Re: [rfc/rft][patch] should use scheduler sync hint in
 tcp_prequeue()?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1267522901.25906.101.camel@marge.simson.net>
References: <1267522901.25906.101.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Mar 2010 12:27:53 +0100
Message-ID: <1267529273.2964.111.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 02 mars 2010 à 10:41 +0100, Mike Galbraith a écrit :
> Greetings network land.
> 
> The reason for this query is that wake_affine() fails if there is one
> and only one task on a runqueue to encourage tasks spreading out, which
> increases cpu utilization.  However, for tasks which are communicating
> at high frequency, the cost of the resulting cache misses, should
> partners land in non-shared caches, is horrible to behold.  My Q6600 has
> shared caches, which may or may not be hit IFF something perturbs the
> system, and bounces partner to the right core.  That won't happen on a
> box with no shared caches of course, and even with shared caches
> available, the pain is highly visible in the TCP numbers below. 
> 
> The sync hint tells wake_affine() that the waker is likely going to
> sleep soonish, so it subtracts the waker from the load imbalance
> calculation, allowing the partner task to be awakened affine.  In the
> shared cache available case, that is also an enabler that the task be
> placed in an idle shared cache, which can increase throughput quite a
> bit (see .31 vs .33 AF UNIX), or may cost a bit if there is little to no
> execution overlap (see pipe).
> 
> Now, I _could_ change wake_affine() to globally succeed in the one task
> case, but am loath to do so because that very well may upset delicate
> load balancing apple cart.  I think it's much safer to target the spot
> that I know hurts like hell.  Thoughts?
> 
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 34f5cc2..ba3fc64 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -939,7 +939,7 @@ static inline int tcp_prequeue(struct sock *sk, struct sk_buff *skb)
>  
>  		tp->ucopy.memory = 0;
>  	} else if (skb_queue_len(&tp->ucopy.prequeue) == 1) {
> -		wake_up_interruptible_poll(sk->sk_sleep,
> +		wake_up_interruptible_sync_poll(sk->sk_sleep,
>  					   POLLIN | POLLRDNORM | POLLRDBAND);
>  		if (!inet_csk_ack_scheduled(sk))
>  			inet_csk_reset_xmit_timer(sk, ICSK_TIME_DACK,
> 

I suspect this discussion is more a lkml topic but anyway...

This wake_up_interruptible_sync_poll() change might be good for loopback
communications (and pleases tbench), but is it desirable for regular
multi flows NIC traffic ? 

Ingo probably can answer to this question, since he changed
sock_def_readable() (and others) in commit 6f3d09291b498299
I suspect he missed tcp_prequeue() case, maybe not...

sched, net: socket wakeups are sync

'sync' wakeups are a hint towards the scheduler that (certain)
networking related wakeups likely create coupling between tasks.


