Return-Path: <linux-kernel-owner+w=401wt.eu-S1756770AbZBAUFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbZBAUFk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 15:05:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbZBAUE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 15:04:27 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:47037 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbZBAUE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 15:04:26 -0500
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Date: Sun, 01 Feb 2009 12:04:23 -0800
Subject: [patch 3/6] epoll keyed wakeups v2 - make sockets use keyed wakeups
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.13601.1233518665.3>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch adds support for event-aware wakeups to
the sockets code. Events are delivered to the wakeup target,
so that epoll can avoid spurious wakeups for non-interesting
events.


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 net/core/sock.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.mod/net/core/sock.c
===================================================================
--- linux-2.6.mod.orig/net/core/sock.c	2009-01-31 14:55:13.000000000 -0800
+++ linux-2.6.mod/net/core/sock.c	2009-01-31 15:34:41.000000000 -0800
@@ -1628,7 +1628,7 @@ static void sock_def_error_report(struct
 {
 	read_lock(&sk->sk_callback_lock);
 	if (sk->sk_sleep && waitqueue_active(sk->sk_sleep))
-		wake_up_interruptible(sk->sk_sleep);
+		wake_up_interruptible_poll(sk->sk_sleep, POLLERR);
 	sk_wake_async(sk, SOCK_WAKE_IO, POLL_ERR);
 	read_unlock(&sk->sk_callback_lock);
 }
@@ -1637,7 +1637,7 @@ static void sock_def_readable(struct soc
 {
 	read_lock(&sk->sk_callback_lock);
 	if (sk->sk_sleep && waitqueue_active(sk->sk_sleep))
-		wake_up_interruptible_sync(sk->sk_sleep);
+		wake_up_interruptible_sync_poll(sk->sk_sleep, POLLIN);
 	sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_IN);
 	read_unlock(&sk->sk_callback_lock);
 }
@@ -1651,7 +1651,7 @@ static void sock_def_write_space(struct 
 	 */
 	if ((atomic_read(&sk->sk_wmem_alloc) << 1) <= sk->sk_sndbuf) {
 		if (sk->sk_sleep && waitqueue_active(sk->sk_sleep))
-			wake_up_interruptible_sync(sk->sk_sleep);
+			wake_up_interruptible_sync_poll(sk->sk_sleep, POLLOUT);
 
 		/* Should agree with poll, otherwise some programs break */
 		if (sock_writeable(sk))

