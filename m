Return-Path: <linux-kernel-owner+w=401wt.eu-S1758215AbYFQTAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215AbYFQTAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 15:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbYFQTAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 15:00:41 -0400
Received: from mss-uk.mssgmbh.com ([217.174.251.109]:51066 "EHLO
	mss-uk.mssgmbh.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229AbYFQTAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 15:00:40 -0400
X-Greylist: delayed 807 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jun 2008 15:00:40 EDT
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.25.7] af_unix: fix 'poll for write'/ connected DGRAM sockets
Message-ID: <871w2wca3r.fsf@fever.mssgmbh.com>
From: Rainer Weikusat <rweikusat@mssgmbh.com>
Date: Tue, 17 Jun 2008 20:47:02 +0200
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rainer Weikusat <rweikusat@mssgmbh.com>

The unix_dgram_sendmsg routine implements a (somewhat crude)
form of receiver-imposed flow control by comparing the length of the
receive queue of the 'peer socket' with the max_ack_backlog value
stored in the corresponding sock structure, either blocking
the thread which caused the send-routine to be called or returning
EAGAIN. This routine is used by both SOCK_DGRAM and SOCK_SEQPACKET
sockets. The poll-implementation for these socket types is
datagram_poll from core/datagram.c. A socket is deemed to be writeable
by this routine when the memory presently consumed by datagrams
owned by it is less than the configured socket send buffer size. This
is always wrong for connected PF_UNIX non-stream sockets when the
abovementioned receive queue is currently considered to be full.
'poll' will then return, indicating that the socket is writeable, but
a subsequent write result in EAGAIN, effectively causing an
(usual) application to 'poll for writeability by repeated send request
with O_NONBLOCK set' until it has consumed its time quantum.

The change below uses a suitably modified variant of the datagram_poll
routines for both type of PF_UNIX sockets, which tests if the
recv-queue of the peer a socket is connected to is presently
considered to be 'full' as part of the 'is this socket
writeable'-checking code. The socket being polled is additionally
put onto the peer_wait wait queue associated with its peer, because the
unix_dgram_sendmsg routine does a wake up on this queue after a
datagram was received and the 'other wakeup call' is done implicitly
as part of skb destruction, meaning, a process blocked in poll
because of a full peer receive queue could otherwise sleep forever
if no datagram owned by its socket was already sitting on this queue.
Among this change is a small (inline) helper routine named
'unix_recvq_full', which consolidates the actual testing code (in three
different places) into a single location.

Signed-off-by: <rweikusat@mssgmbh.com>
---
diff -pru linux-2.6.25.7/net/unix/af_unix.c linux-2.6.25.7-patched/net/unix/af_unix.c
--- linux-2.6.25.7/net/unix/af_unix.c	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25.7-patched/net/unix/af_unix.c	2008-06-17 20:13:48.000000000 +0200
@@ -169,6 +169,11 @@ static inline int unix_may_send(struct s
 	return (unix_peer(osk) == NULL || unix_our_peer(sk, osk));
 }
 
+static inline int unix_recvq_full(struct sock const *sk)
+{
+	return skb_queue_len(&sk->sk_receive_queue) > sk->sk_max_ack_backlog;
+}
+
 static struct sock *unix_peer_get(struct sock *s)
 {
 	struct sock *peer;
@@ -482,6 +487,8 @@ static int unix_socketpair(struct socket
 static int unix_accept(struct socket *, struct socket *, int);
 static int unix_getname(struct socket *, struct sockaddr *, int *, int);
 static unsigned int unix_poll(struct file *, struct socket *, poll_table *);
+static unsigned int unix_datagram_poll(struct file *, struct socket *,
+				       poll_table *);
 static int unix_ioctl(struct socket *, unsigned int, unsigned long);
 static int unix_shutdown(struct socket *, int);
 static int unix_stream_sendmsg(struct kiocb *, struct socket *,
@@ -527,7 +534,7 @@ static const struct proto_ops unix_dgram
 	.socketpair =	unix_socketpair,
 	.accept =	sock_no_accept,
 	.getname =	unix_getname,
-	.poll =		datagram_poll,
+	.poll =		unix_datagram_poll,
 	.ioctl =	unix_ioctl,
 	.listen =	sock_no_listen,
 	.shutdown =	unix_shutdown,
@@ -548,7 +555,7 @@ static const struct proto_ops unix_seqpa
 	.socketpair =	unix_socketpair,
 	.accept =	unix_accept,
 	.getname =	unix_getname,
-	.poll =		datagram_poll,
+	.poll =		unix_datagram_poll,
 	.ioctl =	unix_ioctl,
 	.listen =	unix_listen,
 	.shutdown =	unix_shutdown,
@@ -979,8 +986,7 @@ static long unix_wait_for_peer(struct so
 
 	sched = !sock_flag(other, SOCK_DEAD) &&
 		!(other->sk_shutdown & RCV_SHUTDOWN) &&
-		(skb_queue_len(&other->sk_receive_queue) >
-		 other->sk_max_ack_backlog);
+		unix_recvq_full(other);
 
 	unix_state_unlock(other);
 
@@ -1054,8 +1060,7 @@ restart:
 	if (other->sk_state != TCP_LISTEN)
 		goto out_unlock;
 
-	if (skb_queue_len(&other->sk_receive_queue) >
-	    other->sk_max_ack_backlog) {
+	if (unix_recvq_full(other)) {
 		err = -EAGAIN;
 		if (!timeo)
 			goto out_unlock;
@@ -1424,9 +1429,7 @@ restart:
 			goto out_unlock;
 	}
 
-	if (unix_peer(other) != sk &&
-	    (skb_queue_len(&other->sk_receive_queue) >
-	     other->sk_max_ack_backlog)) {
+	if (unix_peer(other) != sk && unix_recvq_full(other)) {
 		if (!timeo) {
 			err = -EAGAIN;
 			goto out_unlock;
@@ -1987,6 +1990,64 @@ static unsigned int unix_poll(struct fil
 	return mask;
 }
 
+static unsigned int unix_datagram_poll(struct file *file, struct socket *sock,
+				       poll_table *wait)
+{
+	struct sock *sk = sock->sk, *peer;
+	unsigned int mask;
+
+	poll_wait(file, sk->sk_sleep, wait);
+
+	peer = unix_peer_get(sk);
+	if (peer) {
+		if (peer != sk)
+			/*
+			 * Writability of a connected socket additionally
+			 * depends on the state of the receive queue of the
+			 * peer.
+			 */
+			poll_wait(file, &unix_sk(peer)->peer_wait, wait);
+		else {
+			sock_put(peer);
+			peer = NULL;
+		}
+	}
+
+	mask = 0;
+
+	/* exceptional events? */
+	if (sk->sk_err || !skb_queue_empty(&sk->sk_error_queue))
+		mask |= POLLERR;
+	if (sk->sk_shutdown & RCV_SHUTDOWN)
+		mask |= POLLRDHUP;
+	if (sk->sk_shutdown == SHUTDOWN_MASK)
+		mask |= POLLHUP;
+
+	/* readable? */
+	if (!skb_queue_empty(&sk->sk_receive_queue) ||
+	    (sk->sk_shutdown & RCV_SHUTDOWN))
+		mask |= POLLIN | POLLRDNORM;
+
+	/* Connection-based need to check for termination and startup */
+	if (sk->sk_type == SOCK_SEQPACKET) {
+		if (sk->sk_state == TCP_CLOSE)
+			mask |= POLLHUP;
+		/* connection hasn't started yet? */
+		if (sk->sk_state == TCP_SYN_SENT)
+			return mask;
+	}
+
+	/* writable? */
+	if (unix_writable(sk) && !(peer && unix_recvq_full(peer)))
+		mask |= POLLOUT | POLLWRNORM | POLLWRBAND;
+	else
+		set_bit(SOCK_ASYNC_NOSPACE, &sk->sk_socket->flags);
+
+	if (peer)
+	    sock_put(peer);
+
+	return mask;
+}
 
 #ifdef CONFIG_PROC_FS
 static struct sock *first_unix_socket(int *i)
