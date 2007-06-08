Return-Path: <linux-kernel-owner+w=401wt.eu-S970686AbXFHQfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970686AbXFHQfp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969246AbXFHQfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:35:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968696AbXFHQfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:35:33 -0400
Date: Fri, 8 Jun 2007 12:35:27 -0400
From: Jeff Layton <jlayton@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-cifs-client@lists.samba.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] RFC: have tcp_recvmsg() check kthread_should_stop() and
 treat it as if it were signalled
Message-Id: <20070608123527.9b4cdafe.jlayton@redhat.com>
In-Reply-To: <20070606085550.GA7351@infradead.org>
References: <20070605152340.f09fa6f2.jlayton@redhat.com>
	<20070606085550.GA7351@infradead.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This one's sort of outside my normal area of expertise so sending this
as an RFC to gather feedback on the idea.

Some background:

The cifs_mount() and cifs_umount() functions currently send a signal to
the cifsd kthread prior to calling kthread_stop on it. The reasoning is
apparently that it's likely that cifsd will have called kernel_recvmsg()
and if it doesn't do this there can be a rather long delay when a
filesystem is unmounted.

The following patch is a first stab at removing this need. It makes it
so that in tcp_recvmsg() we also check kthread_should_stop() at any
point where we currently check to see if the task was signalled. If
that returns true, then it acts as if it were signalled and returns to
the calling function.

I've tested this on a fairly recent kernel with a cifs module that
doesn't send signals on unmount and it seems to work as expected. I'm
just not clear on whether it will have any adverse side-effects.

Obviously if this approach is OK then we'll probably also want to fix
up other recvmsg functions (udp_recvmsg, etc).

Anyone care to comment?

Thanks,

Signed-off-by: Jeff Layton <jlayton@redhat.com>

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index bd4c295..1ad91fa 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -258,6 +258,7 @@
 #include <linux/cache.h>
 #include <linux/err.h>
 #include <linux/crypto.h>
+#include <linux/kthread.h>
 
 #include <net/icmp.h>
 #include <net/tcp.h>
@@ -1154,7 +1155,7 @@ int tcp_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 		if (tp->urg_data && tp->urg_seq == *seq) {
 			if (copied)
 				break;
-			if (signal_pending(current)) {
+			if (signal_pending(current) || kthread_should_stop()) {
 				copied = timeo ? sock_intr_errno(timeo) : -EAGAIN;
 				break;
 			}
@@ -1197,6 +1198,7 @@ int tcp_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 			    (sk->sk_shutdown & RCV_SHUTDOWN) ||
 			    !timeo ||
 			    signal_pending(current) ||
+			    kthread_should_stop() ||
 			    (flags & MSG_PEEK))
 				break;
 		} else {
@@ -1227,7 +1229,7 @@ int tcp_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 				break;
 			}
 
-			if (signal_pending(current)) {
+			if (signal_pending(current) || kthread_should_stop()) {
 				copied = sock_intr_errno(timeo);
 				break;
 			}
