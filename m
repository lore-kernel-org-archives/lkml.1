Return-Path: <linux-kernel-owner+w=401wt.eu-S1759543AbZAIWQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759543AbZAIWQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 17:16:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757593AbZAIWQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 17:16:07 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:50330 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758511AbZAIWQF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 17:16:05 -0500
Message-ID: <4967CBB9.1060403@cosmosbay.com>
Date: Fri, 09 Jan 2009 23:12:09 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: David Miller <davem@davemloft.net>, ben@zeus.com, jarkao2@gmail.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
References: <20090108173028.GA22531@1wt.eu> <49667534.5060501@zeus.com> <20090108.135515.85489589.davem@davemloft.net> <4966F2F4.9080901@cosmosbay.com> <49677074.5090802@cosmosbay.com> <20090109185448.GA1999@1wt.eu> <4967B8C5.10803@cosmosbay.com> <20090109212400.GA3727@1wt.eu> <20090109220737.GA4111@1wt.eu>
In-Reply-To: <20090109220737.GA4111@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 09 Jan 2009 23:12:10 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau a écrit :
> On Fri, Jan 09, 2009 at 10:24:00PM +0100, Willy Tarreau wrote:
>> On Fri, Jan 09, 2009 at 09:51:17PM +0100, Eric Dumazet wrote:
>> (...)
>>>> Also, in your second mail, you're saying that your change
>>>> might return more data than requested by the user. I can't
>>>> find why, could you please explain to me, as I'm still quite
>>>> ignorant in this area ?
>>> Well, I just tested various user programs and indeed got this
>>> strange result :
>>>
>>> Here I call splice() with len=1000 (0x3e8), and you can see
>>> it gives a result of 1460 at the second call.
> 
> OK finally I could reproduce it and found why we have this. It's
> expected in fact.
> 
> The problem when we loop in tcp_read_sock() is that tss->len is
> not decremented by the amount of bytes read, this one is done
> only in tcp_splice_read() which is outer.
> 
> The solution I found was to do just like other callers, which means
> use desc->count to keep the remaining number of bytes we want to
> read. In fact, tcp_read_sock() is designed to use that one as a stop
> condition, which explains why you first had to hide it.
> 
> Now with the attached patch as a replacement for my previous one,
> both issues are solved :
>   - I splice 1000 bytes if I ask to do so
>   - I splice as much as possible if available (typically 23 kB).
> 
> My observed performances are still at the top of earlier results
> and IMHO that way of counting bytes makes sense for an actor called
> from tcp_read_sock().
> 
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 35bcddf..51ff3aa 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -522,8 +522,12 @@ static int tcp_splice_data_recv(read_descriptor_t *rd_desc, struct sk_buff *skb,
>  				unsigned int offset, size_t len)
>  {
>  	struct tcp_splice_state *tss = rd_desc->arg.data;
> +	int ret;
>  
> -	return skb_splice_bits(skb, offset, tss->pipe, tss->len, tss->flags);
> +	ret = skb_splice_bits(skb, offset, tss->pipe, rd_desc->count, tss->flags);
> +	if (ret > 0)
> +		rd_desc->count -= ret;
> +	return ret;
>  }
>  
>  static int __tcp_splice_read(struct sock *sk, struct tcp_splice_state *tss)
> @@ -531,6 +535,7 @@ static int __tcp_splice_read(struct sock *sk, struct tcp_splice_state *tss)
>  	/* Store TCP splice context information in read_descriptor_t. */
>  	read_descriptor_t rd_desc = {
>  		.arg.data = tss,
> +		.count = tss->len,
>  	};
>  
>  	return tcp_read_sock(sk, &rd_desc, tcp_splice_data_recv);
> 

OK, I came to a different patch. Please check other tcp_read_sock() callers in tree :)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 23808df..96b49e1 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -100,13 +100,11 @@ static void iscsi_sw_tcp_data_ready(struct sock *sk, int flag)
 
 	/*
 	 * Use rd_desc to pass 'conn' to iscsi_tcp_recv.
-	 * We set count to 1 because we want the network layer to
-	 * hand us all the skbs that are available. iscsi_tcp_recv
-	 * handled pdus that cross buffers or pdus that still need data.
+	 * iscsi_tcp_recv handled pdus that cross buffers or pdus that
+	 * still need data.
 	 */
 	rd_desc.arg.data = conn;
-	rd_desc.count = 1;
-	tcp_read_sock(sk, &rd_desc, iscsi_sw_tcp_recv);
+	tcp_read_sock(sk, &rd_desc, iscsi_sw_tcp_recv, 65536);
 
 	read_unlock(&sk->sk_callback_lock);
 
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 218235d..b1facd1 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -490,7 +490,7 @@ extern void tcp_get_info(struct sock *, struct tcp_info *);
 typedef int (*sk_read_actor_t)(read_descriptor_t *, struct sk_buff *,
 				unsigned int, size_t);
 extern int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
-			 sk_read_actor_t recv_actor);
+			 sk_read_actor_t recv_actor, size_t tlen);
 
 extern void tcp_initialize_rcv_mss(struct sock *sk);
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index bd6ff90..fbbddf4 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -523,7 +523,7 @@ static int tcp_splice_data_recv(read_descriptor_t *rd_desc, struct sk_buff *skb,
 {
 	struct tcp_splice_state *tss = rd_desc->arg.data;
 
-	return skb_splice_bits(skb, offset, tss->pipe, tss->len, tss->flags);
+	return skb_splice_bits(skb, offset, tss->pipe, len, tss->flags);
 }
 
 static int __tcp_splice_read(struct sock *sk, struct tcp_splice_state *tss)
@@ -533,7 +533,7 @@ static int __tcp_splice_read(struct sock *sk, struct tcp_splice_state *tss)
 		.arg.data = tss,
 	};
 
-	return tcp_read_sock(sk, &rd_desc, tcp_splice_data_recv);
+	return tcp_read_sock(sk, &rd_desc, tcp_splice_data_recv, tss->len);
 }
 
 /**
@@ -611,11 +611,13 @@ ssize_t tcp_splice_read(struct socket *sock, loff_t *ppos,
 		tss.len -= ret;
 		spliced += ret;
 
+		if (!timeo)
+			break;
 		release_sock(sk);
 		lock_sock(sk);
 
 		if (sk->sk_err || sk->sk_state == TCP_CLOSE ||
-		    (sk->sk_shutdown & RCV_SHUTDOWN) || !timeo ||
+		    (sk->sk_shutdown & RCV_SHUTDOWN) ||
 		    signal_pending(current))
 			break;
 	}
@@ -1193,7 +1195,7 @@ static inline struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off)
  *	  (although both would be easy to implement).
  */
 int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
-		  sk_read_actor_t recv_actor)
+		  sk_read_actor_t recv_actor, size_t tlen)
 {
 	struct sk_buff *skb;
 	struct tcp_sock *tp = tcp_sk(sk);
@@ -1209,6 +1211,8 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 			size_t len;
 
 			len = skb->len - offset;
+			if (len > tlen)
+				len = tlen;
 			/* Stop reading if we hit a patch of urgent data */
 			if (tp->urg_data) {
 				u32 urg_offset = tp->urg_seq - seq;
@@ -1226,6 +1230,7 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 				seq += used;
 				copied += used;
 				offset += used;
+				tlen -= used;
 			}
 			/*
 			 * If recv_actor drops the lock (e.g. TCP splice
@@ -1243,7 +1248,7 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 			break;
 		}
 		sk_eat_skb(sk, skb, 0);
-		if (!desc->count)
+		if (!tlen)
 			break;
 	}
 	tp->copied_seq = seq;
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 5cbb404..75f8e83 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1109,8 +1109,7 @@ static void xs_tcp_data_ready(struct sock *sk, int bytes)
 	/* We use rd_desc to pass struct xprt to xs_tcp_data_recv */
 	rd_desc.arg.data = xprt;
 	do {
-		rd_desc.count = 65536;
-		read = tcp_read_sock(sk, &rd_desc, xs_tcp_data_recv);
+		read = tcp_read_sock(sk, &rd_desc, xs_tcp_data_recv, 65536);
 	} while (read > 0);
 out:
 	read_unlock(&sk->sk_callback_lock);


