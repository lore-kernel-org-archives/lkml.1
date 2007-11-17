Return-Path: <linux-kernel-owner+w=401wt.eu-S1760115AbXKQDpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760115AbXKQDpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 22:45:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755135AbXKQDpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 22:45:39 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:60880 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754339AbXKQDpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 22:45:38 -0500
To: paul.moore@hp.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, takedakn@nttdata.co.jp
Subject: Re: [TOMOYO #5 18/18] LSM expansion for TOMOYO Linux.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20071116173439.796600895@I-love.SAKURA.ne.jp>
	<20071116173529.826621737@I-love.SAKURA.ne.jp>
	<200711161423.28065.paul.moore@hp.com>
In-Reply-To: <200711161423.28065.paul.moore@hp.com>
Message-Id: <200711171245.HFH05776.LQFOtVMHOSFOFJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 17 Nov 2007 12:45:32 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Thank you for your feedback.

Paul Moore wrote:
> With this patch the 'cpu_flags' variable will be used in two different 
> if-blocks in this function and declared locally within each block.  Please 
> move the 'cpu_flags' declaration to the top of the function so it only needs 
> to be declared once.
I see.

> I might be missing something here, but why do you need to do a skb_peek() 
> again?  You already have the skb and the sock, just do the unlink.
The skb might be already dequeued by other thread while I slept inside
security_post_recv_datagram().

> Two things.  First you can probably just call kfree_skb() instead of 
> skb_free_datagram().
So far, there is no difference between skb_free_datagram() and kfree_skb().

| void skb_free_datagram(struct sock *sk, struct sk_buff *skb)
| {
|         kfree_skb(skb);
| }

udp_recvmsg() thinks it might not be ok to directly call kfree_skb().
But you and skb_kill_datagram() think it is ok to directly call kfree_skb(),
I will do so.

> Second, why not move the 'no_peek' code to just before 'no_packet'?
Oh, I didn't notice I can insert here. Now I can also move the rest code like

|		error = security_post_recv_datagram(sk, skb, flags);
|		if (error)
|                       goto force_dequeue;

|         } while (!wait_for_packet(sk, err, &timeo));
|
|         return NULL;
| force_dequeue:
|         /* dequeue if MSG_PEEK is set. */
| no_packet:
|         *err = error;
|         return NULL;

to reduce indentation.

Thank you.

