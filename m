Return-Path: <linux-kernel-owner+w=401wt.eu-S1755294AbXKSOaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbXKSOaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 09:30:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbXKSOaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 09:30:00 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:58127 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbXKSO37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 09:29:59 -0500
To: paul.moore@hp.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, takedakn@nttdata.co.jp
Subject: Re: [TOMOYO #5 18/18] LSM expansion for TOMOYO Linux.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20071116173439.796600895@I-love.SAKURA.ne.jp>
	<200711171810.00404.paul.moore@hp.com>
	<200711181300.III52155.FtFQJOLSMOHOVF@I-love.SAKURA.ne.jp>
	<200711190836.12940.paul.moore@hp.com>
In-Reply-To: <200711190836.12940.paul.moore@hp.com>
Message-Id: <200711192329.JGB18772.tLHOOSMVFFQOFJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Mon, 19 Nov 2007 23:29:52 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Paul Moore wrote:
> If that is the case then the second call to 
> skb_peek() will return a different skb then the one you passed to 
> security_post_recv_datagram().
Yes. The second call to skb_peek() might return a different skb than the one
I passed to security_post_recv_datagram().

skb_peek() itself doesn't modify reference count nor queue.
| static inline struct sk_buff *skb_peek(struct sk_buff_head *list_)
| {
| 	struct sk_buff *list = ((struct sk_buff *)list_)->next;
| 	if (list == (struct sk_buff *)list_)
| 		list = NULL;
| 	return list;
| }

> This is significant because you always throw
> away this second skb without first consulting the LSM via 
> security_post_recv_datagram().
I just dequeue skb returned by *first* call to skb_peek().
I'm not handling skb returned by *second* call to skb_peek().
The skb returned by *second* call to skb_peek() is later handled by
somebody else's *first* call to skb_peek().

All skb returned by *first* call to skb_peek() are passed to security_post_recv_datagram().
Only skb returned by *first* call to skb_peek() can become candidate for that skb_recv_datagram() call.
No skb returned by *second* call to skb_peek() can become candidate for that skb_recv_datagram() call,
but can become candidate for subsequent skb_recv_datagram() call if the skb is returned by
*first* call to skb_peek().



Let's consider with named packets.

Suppose a socket has n packets in it's receive queue.
---------------
P0 P1 P2 ... Pn
---------------

Case 1:

  Thread T0 picks up P0 with MSG_PEEK flag and then calls security_post_recv_datagram().

  While T0 is in security_post_recv_datagram(),
  another thread T1 picks up P0 without MSG_PEEK flag and then calls security_post_recv_datagram().

  security_post_recv_datagram(P0) from T0 returns -EAGAIN (which means "Don't deliver this packet to caller."),
  T0 checks whether P0 is still in socket queue.
  T0 finds that P0 is already dequeued, and just drop reference count of P0.

  security_post_recv_datagram(P0) from T1 returns -EAGAIN,
  T1 drops reference count of P0.

Case 2:

  Thread T0 picks up P0 with MSG_PEEK flag and then calls security_post_recv_datagram().

  While T0 is in security_post_recv_datagram(),
  T1 picks up P0 with MSG_PEEK flag and then calls security_post_recv_datagram().

  security_post_recv_datagram(P0) from T0 returns -EAGAIN,
  T0 checks whether P0 is still in socket queue.
  T0 finds that P0 is still in queue, and dequeues P0 and drop reference count of P0.

  security_post_recv_datagram(P0) from T1 returns -EAGAIN,
  T1 checks whether P0 is still in socket queue,
  T1 finds that P0 is already dequeued, and just drop reference count of P0.

Case 3:

  Thread T0 picks up P0 with MSG_PEEK flag and then calls security_post_recv_datagram().

  While T0 is in security_post_recv_datagram(),
  T1 picks up P0 with MSG_PEEK flag and then calls security_post_recv_datagram().

  security_post_recv_datagram(P0) from T1 returns -EAGAIN,
  T1 checks whether P0 is still in socket queue.
  T1 finds that P0 is still in queue, and dequeues P0 and drop reference count of P0.

  security_post_recv_datagram(P0) from T0 returns -EAGAIN,
  T0 checks whether P0 is still in socket queue,
  T0 finds that P0 is already dequeued, and just drop reference count of P0.

In which case did you find racy condition that P0 is passed to userland without LSM check?

Regards.

