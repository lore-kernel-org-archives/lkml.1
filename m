Return-Path: <linux-kernel-owner+w=401wt.eu-S1763939AbZBNBOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763939AbZBNBOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761480AbZBNBB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:01:59 -0500
Received: from kroah.org ([198.145.64.141]:39846 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761411AbZBNBB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:01:57 -0500
Date: Fri, 13 Feb 2009 16:59:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Eric Dumazet <dada1@cosmosbay.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 35/47] tcp: splice as many packets as possible at once
Message-ID: <20090214005913.GJ11282@kroah.com>
References: <20090214005130.617401075@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="tcp-splice-as-many-packets-as-possible-at-once.patch"
In-Reply-To: <20090214005726.GA11282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Willy Tarreau <w@1wt.eu>

[ Upstream commit 33966dd0e2f68f26943cd9ee93ec6abbc6547a8e ]

As spotted by Willy Tarreau, current splice() from tcp socket to pipe is not
optimal. It processes at most one segment per call.
This results in low performance and very high overhead due to syscall rate
when splicing from interfaces which do not support LRO.

Willy provided a patch inside tcp_splice_read(), but a better fix
is to let tcp_read_sock() process as many segments as possible, so
that tcp_rcv_space_adjust() and tcp_cleanup_rbuf() are called less
often.

With this change, splice() behaves like tcp_recvmsg(), being able
to consume many skbs in one system call. With typical 1460 bytes
of payload per frame, that means splice(SPLICE_F_NONBLOCK) can return
16*1460 = 23360 bytes.

Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/tcp.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -518,8 +518,12 @@ static int tcp_splice_data_recv(read_des
 				unsigned int offset, size_t len)
 {
 	struct tcp_splice_state *tss = rd_desc->arg.data;
+	int ret;
 
-	return skb_splice_bits(skb, offset, tss->pipe, tss->len, tss->flags);
+	ret = skb_splice_bits(skb, offset, tss->pipe, rd_desc->count, tss->flags);
+	if (ret > 0)
+		rd_desc->count -= ret;
+	return ret;
 }
 
 static int __tcp_splice_read(struct sock *sk, struct tcp_splice_state *tss)
@@ -527,6 +531,7 @@ static int __tcp_splice_read(struct sock
 	/* Store TCP splice context information in read_descriptor_t. */
 	read_descriptor_t rd_desc = {
 		.arg.data = tss,
+		.count	  = tss->len,
 	};
 
 	return tcp_read_sock(sk, &rd_desc, tcp_splice_data_recv);
@@ -611,11 +616,13 @@ ssize_t tcp_splice_read(struct socket *s
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

