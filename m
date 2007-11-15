Return-Path: <linux-kernel-owner+w=401wt.eu-S932208AbXKOG3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208AbXKOG3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:29:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764708AbXKOGWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:22:23 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46007 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764427AbXKOGWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:22:21 -0500
Date: Wed, 14 Nov 2007 22:20:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 15/23] Fix netlink timeouts.
Message-ID: <20071115062051.GP8282@kroah.com>
References: <20071115055238.692814352@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-netlink-timeouts.patch"
In-Reply-To: <20071115061806.GA8282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Patrick McHardy <kaber@trash.net>

[NETLINK]: Fix unicast timeouts

[ Upstream commit: c3d8d1e30cace31fed6186a4b8c6b1401836d89c ]

Commit ed6dcf4a in the history.git tree broke netlink_unicast timeouts
by moving the schedule_timeout() call to a new function that doesn't
propagate the remaining timeout back to the caller. This means on each
retry we start with the full timeout again.

ipc/mqueue.c seems to actually want to wait indefinitely so this
behaviour is retained.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/netlink.h  |    2 +-
 ipc/mqueue.c             |    6 ++++--
 net/netlink/af_netlink.c |   10 +++++-----
 3 files changed, 10 insertions(+), 8 deletions(-)

--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -175,7 +175,7 @@ extern int netlink_unregister_notifier(s
 /* finegrained unicast helpers: */
 struct sock *netlink_getsockbyfilp(struct file *filp);
 int netlink_attachskb(struct sock *sk, struct sk_buff *skb, int nonblock,
-		long timeo, struct sock *ssk);
+		      long *timeo, struct sock *ssk);
 void netlink_detachskb(struct sock *sk, struct sk_buff *skb);
 int netlink_sendskb(struct sock *sk, struct sk_buff *skb, int protocol);
 
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -1014,6 +1014,8 @@ asmlinkage long sys_mq_notify(mqd_t mqde
 			return -EINVAL;
 		}
 		if (notification.sigev_notify == SIGEV_THREAD) {
+			long timeo;
+
 			/* create the notify skb */
 			nc = alloc_skb(NOTIFY_COOKIE_LEN, GFP_KERNEL);
 			ret = -ENOMEM;
@@ -1042,8 +1044,8 @@ retry:
 				goto out;
 			}
 
-			ret = netlink_attachskb(sock, nc, 0,
-					MAX_SCHEDULE_TIMEOUT, NULL);
+			timeo = MAX_SCHEDULE_TIMEOUT;
+			ret = netlink_attachskb(sock, nc, 0, &timeo, NULL);
 			if (ret == 1)
 		       		goto retry;
 			if (ret) {
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -744,7 +744,7 @@ struct sock *netlink_getsockbyfilp(struc
  * 1: repeat lookup - reference dropped while waiting for socket memory.
  */
 int netlink_attachskb(struct sock *sk, struct sk_buff *skb, int nonblock,
-		long timeo, struct sock *ssk)
+		      long *timeo, struct sock *ssk)
 {
 	struct netlink_sock *nlk;
 
@@ -753,7 +753,7 @@ int netlink_attachskb(struct sock *sk, s
 	if (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf ||
 	    test_bit(0, &nlk->state)) {
 		DECLARE_WAITQUEUE(wait, current);
-		if (!timeo) {
+		if (!*timeo) {
 			if (!ssk || nlk_sk(ssk)->pid == 0)
 				netlink_overrun(sk);
 			sock_put(sk);
@@ -767,7 +767,7 @@ int netlink_attachskb(struct sock *sk, s
 		if ((atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf ||
 		     test_bit(0, &nlk->state)) &&
 		    !sock_flag(sk, SOCK_DEAD))
-			timeo = schedule_timeout(timeo);
+			*timeo = schedule_timeout(*timeo);
 
 		__set_current_state(TASK_RUNNING);
 		remove_wait_queue(&nlk->wait, &wait);
@@ -775,7 +775,7 @@ int netlink_attachskb(struct sock *sk, s
 
 		if (signal_pending(current)) {
 			kfree_skb(skb);
-			return sock_intr_errno(timeo);
+			return sock_intr_errno(*timeo);
 		}
 		return 1;
 	}
@@ -839,7 +839,7 @@ retry:
 		kfree_skb(skb);
 		return PTR_ERR(sk);
 	}
-	err = netlink_attachskb(sk, skb, nonblock, timeo, ssk);
+	err = netlink_attachskb(sk, skb, nonblock, &timeo, ssk);
 	if (err == 1)
 		goto retry;
 	if (err)

-- 
