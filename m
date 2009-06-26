Return-Path: <linux-kernel-owner+w=401wt.eu-S1752242AbZFZBuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbZFZBuj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 21:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbZFZBua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 21:50:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:35884 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbZFZBu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 21:50:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=QSn/1zcbvvsEjfYNV6qC/mo9oWXvO4qTqMqoXLd3ArCJKPSrHs9rPJF4fvK3dQtkJK
         UwvxQ8VZk2GpoJ2ldmlx5Y6wvtQyC3Hu9fA3NZWaDhJtpte4loL1hzYupBJ/bTaH4Qrb
         6VGA3f6Q3Kt6o+TmHxGya9C9bwvyjx2ysYnuA=
Message-ID: <4A442964.2010406@gmail.com>
Date: Fri, 26 Jun 2009 10:50:28 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, fbl@redhat.com,
       nhorman@redhat.com, davem@redhat.com, oleg@redhat.com,
       eric.dumazet@gmail.com
Subject: Re: [PATCH] net: fix race in the receive/select
References: <20090625122545.GA3625@jolsa.lab.eng.brq.redhat.com>
In-Reply-To: <20090625122545.GA3625@jolsa.lab.eng.brq.redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Jiri Olsa wrote:
> Adding memory barrier to the __pollwait function paired with 
> receive callbacks.  The smp_mb__after_lock define is added, 
> since {read|write|spin}_lock() on x86 are full memory barriers.
> 
> The race fires, when following code paths meet, and the tp->rcv_nxt and
> __add_wait_queue updates stay in CPU caches.
> 
> 
> CPU1                         CPU2
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
> If there was no cache the code would work ok, since the wait_queue and
> rcv_nxt are opposit to each other.
> 
> Meaning that once tp->rcv_nxt is updated by CPU2, the CPU1 either already
> passed the tp->rcv_nxt check and sleeps, or will get the new value for
> tp->rcv_nxt and will return with new data mask.  
> In both cases the process (CPU1) is being added to the wait queue, so the
> waitqueue_active (CPU2) call cannot miss and will wake up CPU1.
> 
> The bad case is when the __add_wait_queue changes done by CPU1 stay in its
> cache, and so does the tp->rcv_nxt update on CPU2 side.  The CPU1 will then
> endup calling schedule and sleep forever if there are no more data on the
> socket.

So, the problem is the half barrier semantics of spin_lock on CPU1's
side and lack of any barrier (read for tp->rcv_nxt check can creep
above the queuelist update) in waitqueue_active() check on CPU2's side
(read for waitqueue list can creep above tcv_nxt update).  Am I
understanding it right?

This is a little bit scary.  The interface kind of suggests that they
have strong enough barrier semantics (well, I would assume that).  I
wonder whether there are more more places where this kind of race
condition exists.

> @@ -219,6 +219,10 @@ static void __pollwait(struct file *filp, wait_queue_head_t *wait_address,
>  	init_waitqueue_func_entry(&entry->wait, pollwake);
>  	entry->wait.private = pwq;
>  	add_wait_queue(wait_address, &entry->wait);
> +
> +	/* This memory barrier is paired with the smp_mb__after_lock
> +	 * in the sk_has_sleeper. */
> +	smp_mb();

I'm not entirely sure this is the correct place to do it while the mb
for the other side lives in network code.  Wouldn't it be better to
move this memory barrier to network select code?  It's strange for an
API to have only single side of a barrier pair and leave the other to
the API user.

Also, maybe we need smp_mb__after_unlock() too?  Maybe
add_wait_queue_mb() possibly paired with wait_queue_active_mb() is
better?  On x86, it wouldn't make any difference tho.

One more thing, can you please use fully winged style for multiline
comments?

Thanks.

-- 
tejun
