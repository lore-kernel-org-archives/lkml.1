Return-Path: <linux-kernel-owner+w=401wt.eu-S1756593AbYFTNft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbYFTNft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 09:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbYFTNfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 09:35:41 -0400
Received: from mss-uk.mssgmbh.com ([217.174.251.109]:51094 "EHLO
	mss-uk.mssgmbh.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbYFTNfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 09:35:40 -0400
To: David Miller <davem@davemloft.net>
Cc: rweikusat@mssgmbh.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.25.7 v1-v2] af_unix: fix 'poll for write'/connected DGRAM sockets
In-Reply-To: <20080619.161313.90488863.davem@davemloft.net> (David Miller's message of "Thu, 19 Jun 2008 16:13:13 -0700 (PDT)")
References: <874p7qsz5g.fsf@fever.mssgmbh.com>
	<20080618.144830.35409576.davem@davemloft.net>
	<87tzfpse93.fsf_-_@fever.mssgmbh.com>
	<20080619.161313.90488863.davem@davemloft.net>
From: Rainer Weikusat <rweikusat@mssgmbh.com>
Date: Fri, 20 Jun 2008 15:35:25 +0200
Message-ID: <87bq1wp6ua.fsf@fever.mssgmbh.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rainer Weikusat <rweikusat@mssgmbh.com>

For n:1 'datagram connections' (eg /dev/log), the unix_dgram_sendmsg
routine implements a form of receiver-imposed flow control by
comparing the length of the receive queue of the 'peer socket' with
the max_ack_backlog value stored in the corresponding sock structure,
either blocking the thread which caused the send-routine to be called
or returning EAGAIN. This routine is used by both SOCK_DGRAM and
SOCK_SEQPACKET sockets. The poll-implementation for these socket types
is datagram_poll from core/datagram.c. A socket is deemed to be
writeable by this routine when the memory presently consumed by
datagrams owned by it is less than the configured socket send buffer
size. This is always wrong for PF_UNIX non-stream sockets connected to
server sockets dealing with (potentially) multiple clients if the
abovementioned receive queue is currently considered to be full.
'poll' will then return, indicating that the socket is writeable, but
a subsequent write result in EAGAIN, effectively causing an (usual)
application to 'poll for writeability by repeated send request with
O_NONBLOCK set' until it has consumed its time quantum.

The change below uses a suitably modified variant of the datagram_poll
routines for both type of PF_UNIX sockets, which tests if the
recv-queue of the peer a socket is connected to is presently
considered to be 'full' as part of the 'is this socket
writeable'-checking code. The socket being polled is additionally
put onto the peer_wait wait queue associated with its peer, because the
unix_dgram_recvmsg routine does a wake up on this queue after a
datagram was received and the 'other wakeup call' is done implicitly
as part of skb destruction, meaning, a process blocked in poll
because of a full peer receive queue could otherwise sleep forever
if no datagram owned by its socket was already sitting on this queue.
Among this change is a small (inline) helper routine named
'unix_recvq_full', which consolidates the actual testing code (in three
different places) into a single location.

Signed-off-by: Rainer Weikusat <rweikusat@mssgmbh.com>
---
--- linux-2.6/net/unix/af_unix.c	2008-06-20 12:43:08.000000000 +0200
+++ linux-2.6-new/net/unix/af_unix.c	2008-06-20 13:03:07.000000000 +0200
@@ -487,8 +487,8 @@ static int unix_socketpair(struct socket
 static int unix_accept(struct socket *, struct socket *, int);
 static int unix_getname(struct socket *, struct sockaddr *, int *, int);
 static unsigned int unix_poll(struct file *, struct socket *, poll_table *);
-static unsigned int unix_datagram_poll(struct file *, struct socket *,
-				       poll_table *);
+static unsigned int unix_dgram_poll(struct file *, struct socket *,
+				    poll_table *);
 static int unix_ioctl(struct socket *, unsigned int, unsigned long);
 static int unix_shutdown(struct socket *, int);
 static int unix_stream_sendmsg(struct kiocb *, struct socket *,
@@ -534,7 +534,7 @@ static const struct proto_ops unix_dgram
 	.socketpair =	unix_socketpair,
 	.accept =	sock_no_accept,
 	.getname =	unix_getname,
-	.poll =		unix_datagram_poll,
+	.poll =		unix_dgram_poll,
 	.ioctl =	unix_ioctl,
 	.listen =	sock_no_listen,
 	.shutdown =	unix_shutdown,
@@ -555,7 +555,7 @@ static const struct proto_ops unix_seqpa
 	.socketpair =	unix_socketpair,
 	.accept =	unix_accept,
 	.getname =	unix_getname,
-	.poll =		unix_datagram_poll,
+	.poll =		unix_dgram_poll,
 	.ioctl =	unix_ioctl,
 	.listen =	unix_listen,
 	.shutdown =	unix_shutdown,
@@ -1994,29 +1994,13 @@ static unsigned int unix_poll(struct fil
 	return mask;
 }
 
-static unsigned int unix_datagram_poll(struct file *file, struct socket *sock,
-				       poll_table *wait)
+static unsigned int unix_dgram_poll(struct file *file, struct socket *sock,
+				    poll_table *wait)
 {
-	struct sock *sk = sock->sk, *peer;
-	unsigned int mask;
+	struct sock *sk = sock->sk, *other;
+	unsigned int mask, writable;
 
 	poll_wait(file, sk->sk_sleep, wait);
-
-	peer = unix_peer_get(sk);
-	if (peer) {
-		if (peer != sk) {
-			/*
-			 * Writability of a connected socket additionally
-			 * depends on the state of the receive queue of the
-			 * peer.
-			 */
-			poll_wait(file, &unix_sk(peer)->peer_wait, wait);
-		} else {
-			sock_put(peer);
-			peer = NULL;
-		}
-	}
-
 	mask = 0;
 
 	/* exceptional events? */
@@ -2042,14 +2026,26 @@ static unsigned int unix_datagram_poll(s
 	}
 
 	/* writable? */
-	if (unix_writable(sk) && !(peer && unix_recvq_full(peer)))
+	writable = unix_writable(sk);
+	if (writable) {
+		other = unix_peer_get(sk);
+		if (other) {
+			if (unix_peer(other) != sk) {
+				poll_wait(file, &unix_sk(other)->peer_wait,
+					  wait);
+				if (unix_recvq_full(other))
+					writable = 0;
+			}
+
+			sock_put(other);
+		}
+	}
+
+	if (writable)
 		mask |= POLLOUT | POLLWRNORM | POLLWRBAND;
 	else
 		set_bit(SOCK_ASYNC_NOSPACE, &sk->sk_socket->flags);
 
-	if (peer)
-		sock_put(peer);
-
 	return mask;
 }
 
