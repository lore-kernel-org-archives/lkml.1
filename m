Return-Path: <linux-kernel-owner+w=401wt.eu-S1752563AbZIHWti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbZIHWti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 18:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbZIHWti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 18:49:38 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:49338 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbZIHWtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 18:49:36 -0400
Message-ID: <4AA6DF7B.7060105@gmail.com>
Date: Wed, 09 Sep 2009 00:49:31 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
CC: Jike Song <albcamus@gmail.com>, Parag Warudkar <parag.lkml@gmail.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] net: Fix sock_wfree() race
References: <alpine.DEB.2.00.0909072323350.3940@parag-desktop>	 <df9815e70909072151l2686231en76773418aaf9deeb@mail.gmail.com>	 <4AA609E8.3060408@gmail.com> <df9815e70909080109r3d61ee76v3dcba41dbd87b998@mail.gmail.com> <4AA64A11.7090804@gmail.com>
In-Reply-To: <4AA64A11.7090804@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 09 Sep 2009 00:49:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> Jike Song a écrit :
>> On Tue, Sep 8, 2009 at 3:38 PM, Eric Dumazet<eric.dumazet@gmail.com> wrote:
>>> We decrement a refcnt while object already freed.
>>>
>>> (SLUB DEBUG poisons the zone with 0x6B pattern)
>>>
>>> You might add this patch to trigger a WARN_ON when refcnt >= 0x60000000U
>>> in sk_free() : We'll see the path trying to delete an already freed sock
>>>
>>> diff --git a/net/core/sock.c b/net/core/sock.c
>>> index 7633422..1cb85ff 100644
>>> --- a/net/core/sock.c
>>> +++ b/net/core/sock.c
>>> @@ -1058,6 +1058,7 @@ static void __sk_free(struct sock *sk)
>>>
>>>  void sk_free(struct sock *sk)
>>>  {
>>> +       WARN_ON(atomic_read(&sk->sk_wmem_alloc) >= 0x60000000U);
>>>        /*
>>>         * We substract one from sk_wmem_alloc and can know if
>>>        * some packets are still in some tx queue.
>>>
>>>
>> The output of dmesg with this patch appllied is attached.
>>
>>
> 
> Unfortunatly this WARN_ON was not triggered,
> maybe freeing comes from sock_wfree()
> 
> Could you try this patch instead ?
> 
> Thanks
> 
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 7633422..30469dc 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1058,6 +1058,7 @@ static void __sk_free(struct sock *sk)
> 
>  void sk_free(struct sock *sk)
>  {
> +	WARN_ON(atomic_read(&sk->sk_wmem_alloc) >= 0x60000000U);
>  	/*
>  	 * We substract one from sk_wmem_alloc and can know if
>  	* some packets are still in some tx queue.
> @@ -1220,6 +1221,7 @@ void sock_wfree(struct sk_buff *skb)
>  	struct sock *sk = skb->sk;
>  	int res;
> 
> +	WARN_ON(atomic_read(&sk->sk_wmem_alloc) >= 0x60000000U);
>  	/* In case it might be waiting for more memory. */
>  	res = atomic_sub_return(skb->truesize, &sk->sk_wmem_alloc);
>  	if (!sock_flag(sk, SOCK_USE_WRITE_QUEUE))
> 


David, I believe problem could come from a race in sock_wfree()

It used to have two atomic ops.

One doing the atomic_sub(skb->truesize, &sk->sk_wmem_alloc);
then one sock_put() doing the atomic_dec_and_test(&sk->sk_refcnt)

Now, if two cpus are both :

CPU 1 calling sock_wfree() 
CPU 2 calling the 'final' sock_put(),
CPU 1 doing sock_wfree() might call sk->sk_write_space(sk)
while CPU 2 is already freeing the socket.


Please note I did not test this patch, its very late here and I should get some sleep now...

Thanks

[PATCH] net: Fix sock_wfree() race

Commit 2b85a34e911bf483c27cfdd124aeb1605145dc80
(net: No more expensive sock_hold()/sock_put() on each tx)
opens a window in sock_wfree() where another cpu
might free the socket we are working on.

Fix is to call sk->sk_write_space(sk) only
while still holding a reference on sk.

Since doing this call is done before the 
atomic_sub(truesize, &sk->sk_wmem_alloc), we should pass truesize as 
a bias for possible sk_wmem_alloc evaluations.

Reported-by: Jike Song <albcamus@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 include/linux/sunrpc/svcsock.h |    2 +-
 include/net/sock.h             |    9 +++++++--
 net/core/sock.c                |   14 +++++++-------
 net/core/stream.c              |    2 +-
 net/dccp/output.c              |    4 ++--
 net/ipv4/tcp_input.c           |    2 +-
 net/phonet/pep-gprs.c          |    4 ++--
 net/phonet/pep.c               |    4 ++--
 net/sunrpc/svcsock.c           |    8 ++++----
 net/sunrpc/xprtsock.c          |   10 +++++-----
 net/unix/af_unix.c             |   12 ++++++------
 11 files changed, 38 insertions(+), 33 deletions(-)

diff --git a/include/linux/sunrpc/svcsock.h b/include/linux/sunrpc/svcsock.h
index 04dba23..f80ebff 100644
--- a/include/linux/sunrpc/svcsock.h
+++ b/include/linux/sunrpc/svcsock.h
@@ -23,7 +23,7 @@ struct svc_sock {
 	/* We keep the old state_change and data_ready CB's here */
 	void			(*sk_ostate)(struct sock *);
 	void			(*sk_odata)(struct sock *, int bytes);
-	void			(*sk_owspace)(struct sock *);
+	void			(*sk_owspace)(struct sock *, unsigned int bias);
 
 	/* private TCP part */
 	u32			sk_reclen;	/* length of record */
diff --git a/include/net/sock.h b/include/net/sock.h
index 950409d..eee3312 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -296,7 +296,7 @@ struct sock {
 	/* XXX 4 bytes hole on 64 bit */
 	void			(*sk_state_change)(struct sock *sk);
 	void			(*sk_data_ready)(struct sock *sk, int bytes);
-	void			(*sk_write_space)(struct sock *sk);
+	void			(*sk_write_space)(struct sock *sk, unsigned int bias);
 	void			(*sk_error_report)(struct sock *sk);
   	int			(*sk_backlog_rcv)(struct sock *sk,
 						  struct sk_buff *skb);  
@@ -554,7 +554,7 @@ static inline int sk_stream_wspace(struct sock *sk)
 	return sk->sk_sndbuf - sk->sk_wmem_queued;
 }
 
-extern void sk_stream_write_space(struct sock *sk);
+extern void sk_stream_write_space(struct sock *sk, unsigned int bias);
 
 static inline int sk_stream_memory_free(struct sock *sk)
 {
@@ -1433,6 +1433,11 @@ static inline int sock_writeable(const struct sock *sk)
 	return atomic_read(&sk->sk_wmem_alloc) < (sk->sk_sndbuf >> 1);
 }
 
+static inline int sock_writeable_bias(const struct sock *sk, unsigned int bias) 
+{
+	return (atomic_read(&sk->sk_wmem_alloc) - bias) < (sk->sk_sndbuf >> 1);
+}
+
 static inline gfp_t gfp_any(void)
 {
 	return in_softirq() ? GFP_ATOMIC : GFP_KERNEL;
diff --git a/net/core/sock.c b/net/core/sock.c
index 30d5446..da672c0 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -512,7 +512,7 @@ set_sndbuf:
 		 *	Wake up sending tasks if we
 		 *	upped the value.
 		 */
-		sk->sk_write_space(sk);
+		sk->sk_write_space(sk, 0);
 		break;
 
 	case SO_SNDBUFFORCE:
@@ -1230,10 +1230,10 @@ void sock_wfree(struct sk_buff *skb)
 	struct sock *sk = skb->sk;
 	int res;
 
-	/* In case it might be waiting for more memory. */
-	res = atomic_sub_return(skb->truesize, &sk->sk_wmem_alloc);
 	if (!sock_flag(sk, SOCK_USE_WRITE_QUEUE))
-		sk->sk_write_space(sk);
+		sk->sk_write_space(sk, skb->truesize);
+
+	res = atomic_sub_return(skb->truesize, &sk->sk_wmem_alloc);
 	/*
 	 * if sk_wmem_alloc reached 0, we are last user and should
 	 * free this sock, as sk_free() call could not do it.
@@ -1776,20 +1776,20 @@ static void sock_def_readable(struct sock *sk, int len)
 	read_unlock(&sk->sk_callback_lock);
 }
 
-static void sock_def_write_space(struct sock *sk)
+static void sock_def_write_space(struct sock *sk, unsigned int bias)
 {
 	read_lock(&sk->sk_callback_lock);
 
 	/* Do not wake up a writer until he can make "significant"
 	 * progress.  --DaveM
 	 */
-	if ((atomic_read(&sk->sk_wmem_alloc) << 1) <= sk->sk_sndbuf) {
+	if (((atomic_read(&sk->sk_wmem_alloc) - bias) << 1) <= sk->sk_sndbuf) {
 		if (sk_has_sleeper(sk))
 			wake_up_interruptible_sync_poll(sk->sk_sleep, POLLOUT |
 						POLLWRNORM | POLLWRBAND);
 
 		/* Should agree with poll, otherwise some programs break */
-		if (sock_writeable(sk))
+		if (sock_writeable_bias(sk, bias))
 			sk_wake_async(sk, SOCK_WAKE_SPACE, POLL_OUT);
 	}
 
diff --git a/net/core/stream.c b/net/core/stream.c
index a37debf..df720e9 100644
--- a/net/core/stream.c
+++ b/net/core/stream.c
@@ -25,7 +25,7 @@
  *
  * FIXME: write proper description
  */
-void sk_stream_write_space(struct sock *sk)
+void sk_stream_write_space(struct sock *sk, unsigned int bias)
 {
 	struct socket *sock = sk->sk_socket;
 
diff --git a/net/dccp/output.c b/net/dccp/output.c
index c96119f..cf0635e 100644
--- a/net/dccp/output.c
+++ b/net/dccp/output.c
@@ -192,14 +192,14 @@ unsigned int dccp_sync_mss(struct sock *sk, u32 pmtu)
 
 EXPORT_SYMBOL_GPL(dccp_sync_mss);
 
-void dccp_write_space(struct sock *sk)
+void dccp_write_space(struct sock *sk, unsigned int bias)
 {
 	read_lock(&sk->sk_callback_lock);
 
 	if (sk_has_sleeper(sk))
 		wake_up_interruptible(sk->sk_sleep);
 	/* Should agree with poll, otherwise some programs break */
-	if (sock_writeable(sk))
+	if (sock_writeable_bias(sk, bias))
 		sk_wake_async(sk, SOCK_WAKE_SPACE, POLL_OUT);
 
 	read_unlock(&sk->sk_callback_lock);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index af6d6fa..bde1437 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4818,7 +4818,7 @@ static void tcp_new_space(struct sock *sk)
 		tp->snd_cwnd_stamp = tcp_time_stamp;
 	}
 
-	sk->sk_write_space(sk);
+	sk->sk_write_space(sk, 0);
 }
 
 static void tcp_check_space(struct sock *sk)
diff --git a/net/phonet/pep-gprs.c b/net/phonet/pep-gprs.c
index d183509..cc36c31 100644
--- a/net/phonet/pep-gprs.c
+++ b/net/phonet/pep-gprs.c
@@ -38,7 +38,7 @@ struct gprs_dev {
 	struct sock		*sk;
 	void			(*old_state_change)(struct sock *);
 	void			(*old_data_ready)(struct sock *, int);
-	void			(*old_write_space)(struct sock *);
+	void			(*old_write_space)(struct sock *, unsigned int);
 
 	struct net_device	*dev;
 };
@@ -157,7 +157,7 @@ static void gprs_data_ready(struct sock *sk, int len)
 	}
 }
 
-static void gprs_write_space(struct sock *sk)
+static void gprs_write_space(struct sock *sk, unsigned int bias)
 {
 	struct gprs_dev *gp = sk->sk_user_data;
 
diff --git a/net/phonet/pep.c b/net/phonet/pep.c
index b8252d2..d76e2ea 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -268,7 +268,7 @@ static int pipe_rcv_status(struct sock *sk, struct sk_buff *skb)
 		return -EOPNOTSUPP;
 	}
 	if (wake)
-		sk->sk_write_space(sk);
+		sk->sk_write_space(sk, 0);
 	return 0;
 }
 
@@ -394,7 +394,7 @@ static int pipe_do_rcv(struct sock *sk, struct sk_buff *skb)
 	case PNS_PIPE_ENABLED_IND:
 		if (!pn_flow_safe(pn->tx_fc)) {
 			atomic_set(&pn->tx_credits, 1);
-			sk->sk_write_space(sk);
+			sk->sk_write_space(sk, 0);
 		}
 		if (sk->sk_state == TCP_ESTABLISHED)
 			break; /* Nothing to do */
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 23128ee..8c1642c 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -380,7 +380,7 @@ static void svc_sock_setbufsize(struct socket *sock, unsigned int snd,
 	sock->sk->sk_sndbuf = snd * 2;
 	sock->sk->sk_rcvbuf = rcv * 2;
 	sock->sk->sk_userlocks |= SOCK_SNDBUF_LOCK|SOCK_RCVBUF_LOCK;
-	sock->sk->sk_write_space(sock->sk);
+	sock->sk->sk_write_space(sock->sk, 0);
 	release_sock(sock->sk);
 #endif
 }
@@ -405,7 +405,7 @@ static void svc_udp_data_ready(struct sock *sk, int count)
 /*
  * INET callback when space is newly available on the socket.
  */
-static void svc_write_space(struct sock *sk)
+static void svc_write_space(struct sock *sk, unsigned int bias)
 {
 	struct svc_sock	*svsk = (struct svc_sock *)(sk->sk_user_data);
 
@@ -422,13 +422,13 @@ static void svc_write_space(struct sock *sk)
 	}
 }
 
-static void svc_tcp_write_space(struct sock *sk)
+static void svc_tcp_write_space(struct sock *sk, unsigned int bias)
 {
 	struct socket *sock = sk->sk_socket;
 
 	if (sk_stream_wspace(sk) >= sk_stream_min_wspace(sk) && sock)
 		clear_bit(SOCK_NOSPACE, &sock->flags);
-	svc_write_space(sk);
+	svc_write_space(sk, bias);
 }
 
 /*
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 83c73c4..11e4d35 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -262,7 +262,7 @@ struct sock_xprt {
 	 */
 	void			(*old_data_ready)(struct sock *, int);
 	void			(*old_state_change)(struct sock *);
-	void			(*old_write_space)(struct sock *);
+	void			(*old_write_space)(struct sock *, unsigned int);
 	void			(*old_error_report)(struct sock *);
 };
 
@@ -1491,12 +1491,12 @@ static void xs_write_space(struct sock *sk)
  * progress, otherwise we'll waste resources thrashing kernel_sendmsg
  * with a bunch of small requests.
  */
-static void xs_udp_write_space(struct sock *sk)
+static void xs_udp_write_space(struct sock *sk, unsigned int bias)
 {
 	read_lock(&sk->sk_callback_lock);
 
 	/* from net/core/sock.c:sock_def_write_space */
-	if (sock_writeable(sk))
+	if (sock_writeable_bias(sk, bias))
 		xs_write_space(sk);
 
 	read_unlock(&sk->sk_callback_lock);
@@ -1512,7 +1512,7 @@ static void xs_udp_write_space(struct sock *sk)
  * progress, otherwise we'll waste resources thrashing kernel_sendmsg
  * with a bunch of small requests.
  */
-static void xs_tcp_write_space(struct sock *sk)
+static void xs_tcp_write_space(struct sock *sk, unsigned int bias)
 {
 	read_lock(&sk->sk_callback_lock);
 
@@ -1535,7 +1535,7 @@ static void xs_udp_do_set_buffer_size(struct rpc_xprt *xprt)
 	if (transport->sndsize) {
 		sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
 		sk->sk_sndbuf = transport->sndsize * xprt->max_reqs * 2;
-		sk->sk_write_space(sk);
+		sk->sk_write_space(sk, 0);
 	}
 }
 
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index fc3ebb9..9f90ead 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -306,15 +306,15 @@ found:
 	return s;
 }
 
-static inline int unix_writable(struct sock *sk)
+static inline int unix_writable(struct sock *sk, unsigned int bias)
 {
-	return (atomic_read(&sk->sk_wmem_alloc) << 2) <= sk->sk_sndbuf;
+	return ((atomic_read(&sk->sk_wmem_alloc) - bias) << 2) <= sk->sk_sndbuf;
 }
 
-static void unix_write_space(struct sock *sk)
+static void unix_write_space(struct sock *sk, unsigned int bias)
 {
 	read_lock(&sk->sk_callback_lock);
-	if (unix_writable(sk)) {
+	if (unix_writable(sk, bias)) {
 		if (sk_has_sleeper(sk))
 			wake_up_interruptible_sync(sk->sk_sleep);
 		sk_wake_async(sk, SOCK_WAKE_SPACE, POLL_OUT);
@@ -2010,7 +2010,7 @@ static unsigned int unix_poll(struct file *file, struct socket *sock, poll_table
 	 * we set writable also when the other side has shut down the
 	 * connection. This prevents stuck sockets.
 	 */
-	if (unix_writable(sk))
+	if (unix_writable(sk, 0))
 		mask |= POLLOUT | POLLWRNORM | POLLWRBAND;
 
 	return mask;
@@ -2048,7 +2048,7 @@ static unsigned int unix_dgram_poll(struct file *file, struct socket *sock,
 	}
 
 	/* writable? */
-	writable = unix_writable(sk);
+	writable = unix_writable(sk, 0);
 	if (writable) {
 		other = unix_peer_get(sk);
 		if (other) {
