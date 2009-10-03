Return-Path: <linux-kernel-owner+w=401wt.eu-S1754005AbZJCIw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbZJCIw7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 04:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbZJCIw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 04:52:59 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:50158 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbZJCIw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 04:52:58 -0400
Message-ID: <4AC710DF.5070705@gmail.com>
Date: Sat, 03 Oct 2009 10:52:47 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Wei Yongjun <yjwei@cn.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [Bug #14301] WARNING: at net/ipv4/af_inet.c:154
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <COE24pZSBH.A.mdH.sMTxKB@chimera> <4AC70D20.4060009@gmail.com>
In-Reply-To: <4AC70D20.4060009@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sat, 03 Oct 2009 10:52:49 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> Rafael J. Wysocki a écrit :
>> This message has been generated automatically as a part of a report
>> of regressions introduced between 2.6.30 and 2.6.31.
>>
>> The following bug entry is on the current list of known regressions
>> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
>> be listed and let me know (either way).
>>
>>
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14301
>> Subject		: WARNING: at net/ipv4/af_inet.c:154
>> Submitter	: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
>> Date		: 2009-09-30 12:24 (2 days old)
>> References	: http://marc.info/?l=linux-kernel&m=125431350218137&w=4
>>
>>
> 
> If commit d99927f4d93f36553699573b279e0ff98ad7dea6
> (net: Fix sock_wfree() race) doesnt fix this problem, then
> maybe we should take a look at an old patch.
> 
> < data mining... running... output results to lkml/netdev >
> 
> Random guesses
> 
>  1) : commit d55d87fdff8252d0e2f7c28c2d443aee17e9d70f
> (net: Move rx skb_orphan call to where needed)
> 
> A similar problem on SCTP was fixed by commit 
> 1bc4ee4088c9a502db0e9c87f675e61e57fa1734
> (sctp: fix warning at inet_sock_destruct() while release sctp socket)
> 
> 2) CORK and UDP sockets
>   It seems we can leave an UDP socket with a frame in sk_write_queue
>   Purge of this queue is done by udp_flush_pending_frames()
>    This calls ip_flush_pending_frames()
>    But this function only calls kfree_skb(), not sk_wmem_free_skb()...
> 
> 
> Could you try following patch ?
> 

Hmm, I missed the ip_cork_release(), here is an updated version.


[PATCH] net: UDP should not use ip_flush_pending_frames()

Now xmit UDP messages are charged, we must take care of calling right
skb freeing function.

In case a close() is performed on a socket where CORKED frame
is still queued in sk_write_queue, calling ip_flush_pending_frames()
leads to sk_forward_alloc leak.

Fix this by calling sk_write_queue_purge() and ip_cork_release()
instead.

Reported-by: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 include/net/ip.h    |    1 +
 include/net/sock.h  |   10 ++++++++++
 include/net/tcp.h   |   10 ----------
 net/ipv4/tcp.c      |    2 +-
 net/ipv4/tcp_ipv4.c |    2 +-
 net/ipv4/udp.c      |    3 ++-
 6 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 2f47e54..c8d8828 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -117,6 +117,7 @@ extern int		ip_generic_getfrag(void *from, char *to, int offset, int len, int od
 extern ssize_t		ip_append_page(struct sock *sk, struct page *page,
 				int offset, size_t size, int flags);
 extern int		ip_push_pending_frames(struct sock *sk);
+extern void     ip_cork_release(struct inet_sock *);
 extern void		ip_flush_pending_frames(struct sock *sk);
 
 /* datagram.c */
diff --git a/include/net/sock.h b/include/net/sock.h
index 1621935..7c80fec 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -882,6 +882,16 @@ static inline void sk_wmem_free_skb(struct sock *sk, struct sk_buff *skb)
 	__kfree_skb(skb);
 }
 
+/* write queue abstraction */
+static inline void sk_write_queue_purge(struct sock *sk)
+{
+	struct sk_buff *skb;
+
+	while ((skb = __skb_dequeue(&sk->sk_write_queue)) != NULL)
+		sk_wmem_free_skb(sk, skb);
+	sk_mem_reclaim(sk);
+}
+
 /* Used by processes to "lock" a socket state, so that
  * interrupts and bottom half handlers won't change it
  * from under us. It essentially blocks any incoming
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 03a49c7..4c7036a 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1220,16 +1220,6 @@ static inline void		tcp_put_md5sig_pool(void)
 	put_cpu();
 }
 
-/* write queue abstraction */
-static inline void tcp_write_queue_purge(struct sock *sk)
-{
-	struct sk_buff *skb;
-
-	while ((skb = __skb_dequeue(&sk->sk_write_queue)) != NULL)
-		sk_wmem_free_skb(sk, skb);
-	sk_mem_reclaim(sk);
-}
-
 static inline struct sk_buff *tcp_write_queue_head(struct sock *sk)
 {
 	return skb_peek(&sk->sk_write_queue);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 64d0af6..0124f5b 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1992,7 +1992,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 
 	tcp_clear_xmit_timers(sk);
 	__skb_queue_purge(&sk->sk_receive_queue);
-	tcp_write_queue_purge(sk);
+	sk_write_queue_purge(sk);
 	__skb_queue_purge(&tp->out_of_order_queue);
 #ifdef CONFIG_NET_DMA
 	__skb_queue_purge(&sk->sk_async_wait_queue);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 7cda24b..76e59df 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1845,7 +1845,7 @@ void tcp_v4_destroy_sock(struct sock *sk)
 	tcp_cleanup_congestion_control(sk);
 
 	/* Cleanup up the write buffer. */
-	tcp_write_queue_purge(sk);
+	sk_write_queue_purge(sk);
 
 	/* Cleans up our, hopefully empty, out_of_order_queue. */
 	__skb_queue_purge(&tp->out_of_order_queue);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 6ec6a8a..b6370d0 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -464,7 +464,8 @@ void udp_flush_pending_frames(struct sock *sk)
 	if (up->pending) {
 		up->len = 0;
 		up->pending = 0;
-		ip_flush_pending_frames(sk);
+		sk_write_queue_purge(sk);
+		ip_cork_release(inet_sk(sk));
 	}
 }
 EXPORT_SYMBOL(udp_flush_pending_frames);
