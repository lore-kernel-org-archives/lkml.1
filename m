Return-Path: <linux-kernel-owner+w=401wt.eu-S1760642AbXLNGw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642AbXLNGw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 01:52:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284AbXLNGws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 01:52:48 -0500
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:1466 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbXLNGwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 01:52:46 -0500
Message-ID: <4762281A.8000600@fr.ibm.com>
Date: Fri, 14 Dec 2007 07:52:10 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
CC: David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>
Subject: Re: 2.6.24-rc4-mm1 - BUG in tcp_fragment
References: <20071204211701.994dfce6.akpm@linux-foundation.org> <47616FA6.1010607@fr.ibm.com> <Pine.LNX.4.64.0712140024360.12376@kivilampi-30.cs.helsinki.fi>
In-Reply-To: <Pine.LNX.4.64.0712140024360.12376@kivilampi-30.cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ilpo Järvinen wrote:
> On Thu, 13 Dec 2007, Cedric Le Goater wrote:
> 
>> I got this one while compiling on NFS.
>>
>> C.
>>
>> kernel BUG at /home/legoater/linux/2.6.24-rc4-mm1/include/net/tcp.h:1480!
> 
> I'm not exactly sure what patches you have applied and which patches are 
> not, with rc4-mm1 there are two patches (first one was incomplete, I 
> assume you had at least that one based on your other mail) to really fix 
> the issues in (__|)tcp_reset_fack_counts(...). 

Yes I only have the first patch you sent on lkml on top of 2.6.24-rc4-mm1.
attached below. I didn't see the second one on lkml ?  

> However, there seems to be so much breakage that I have a bit trouble to 
> decide where to start... The situation seems bit scary :-).

my n/w environment seems to reproduce these issues quite easily. if you
need some testing, just ping me.

Cheers,

C. 

> So, I might soon prepare a revert patch for most of the questionable 
> TCP parts and ask Dave to apply it (and drop them fully during next 
> rebase) unless I suddently figure something out soon which explains 
> all/most of the problems, then return to drawing board. ...As it seems 
> that the cumulative ACK processing problem discovered later on (having 
> rather cumbersome solution with skbs only) will make part of the work 
> that's currently in net-2.6.25 quite useless/duplicate effort. But thanks 
> anyway for reporting these.
> 
> 

Subject: [PATCH] [TCP]: Fix fack_count miscountings (multiple places)

1) Fack_count is set incorrectly if the highest sent skb is
already sacked (the skb->prev won't return it because it's on
the other list already). These manifest as fackets_out counting
error later on, the second-order effects are very hard to track,
so it may fix all out-standing TCP bug reports.

2) Prev == NULL check was wrong way around

3) Last skb's fack count was incorrectly skipped while() {} loop

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
---
 include/net/tcp.h |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 9dbed0b..11a7e3e 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1337,10 +1337,20 @@ static inline struct sk_buff *tcp_send_head(struct sock *sk)
 static inline void tcp_advance_send_head(struct sock *sk, struct sk_buff *skb)
 {
        struct sk_buff *prev = tcp_write_queue_prev(sk, skb);
+       unsigned int fc = 0;
+
+       if (prev == (struct sk_buff *)&sk->sk_write_queue)
+               prev = NULL;
+       else if (!tcp_skb_adjacent(sk, prev, skb))
+               prev = NULL;
 
-       if (prev != (struct sk_buff *)&sk->sk_write_queue)
-               TCP_SKB_CB(skb)->fack_count = TCP_SKB_CB(prev)->fack_count +
-                                             tcp_skb_pcount(prev);
+       if ((prev == NULL) && !__tcp_write_queue_empty(sk, TCP_WQ_SACKED))
+               prev = __tcp_write_queue_tail(sk, TCP_WQ_SACKED);
+
+       if (prev != NULL)
+               fc = TCP_SKB_CB(prev)->fack_count + tcp_skb_pcount(prev);
+
+       TCP_SKB_CB(skb)->fack_count = fc;
 
        sk->sk_send_head = tcp_write_queue_next(sk, skb);
        if (sk->sk_send_head == (struct sk_buff *)&sk->sk_write_queue)
@@ -1464,7 +1474,7 @@ static inline struct sk_buff *__tcp_reset_fack_counts(struct sock *sk,
 {
        unsigned int fc = 0;
 
-       if (prev == NULL)
+       if (prev != NULL)
                fc = TCP_SKB_CB(*prev)->fack_count + tcp_skb_pcount(*prev);
 
        BUG_ON((*prev != NULL) && !tcp_skb_adjacent(sk, *prev, skb));
@@ -1521,7 +1531,7 @@ static inline void tcp_reset_fack_counts(struct sock *sk, struct sk_buff *inskb)
                skb[otherq] = prev->next;
        }
 
-       while (skb[queue] != __tcp_write_queue_tail(sk, queue)) {
+       do {
                /* Lazy find for the other queue */
                if (skb[queue] == NULL) {
                        skb[queue] = tcp_write_queue_find(sk, TCP_SKB_CB(prev)->seq,
@@ -1535,7 +1545,7 @@ static inline void tcp_reset_fack_counts(struct sock *sk, struct sk_buff *inskb)
                        break;
 
                queue ^= TCP_WQ_SACKED;
-       }
+       } while (skb[queue] != __tcp_write_queue_tail(sk, queue));
 }
 
 static inline void __tcp_insert_write_queue_after(struct sk_buff *skb,
-- 1.5.0.6
