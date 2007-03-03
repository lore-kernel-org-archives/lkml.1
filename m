Return-Path: <linux-kernel-owner+w=401wt.eu-S2992926AbXCCCmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992926AbXCCCmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 21:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992922AbXCCCmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 21:42:13 -0500
Received: from [63.64.152.142] ([63.64.152.142]:1464 "EHLO gitlost.site"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992910AbXCCCjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 21:39:12 -0500
From: Chris Leech <christopher.leech@intel.com>
Subject: [PATCH 8/9] I/OAT: warning fix
Date: Fri, 02 Mar 2007 18:24:32 -0800
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Message-Id: <20070303022432.31033.19248.stgit@gitlost.site>
In-Reply-To: <20070303022238.31033.84558.stgit@gitlost.site>
References: <20070303022238.31033.84558.stgit@gitlost.site>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

net/ipv4/tcp.c: In function 'tcp_recvmsg':
net/ipv4/tcp.c:1111: warning: unused variable 'available'

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chris Leech <christopher.leech@intel.com>
---

 net/ipv4/tcp.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 5ccd5e1..69c525d 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1110,7 +1110,6 @@ int tcp_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 	long timeo;
 	struct task_struct *user_recv = NULL;
 	int copied_early = 0;
-	int available = 0;
 	struct sk_buff *skb;
 
 	lock_sock(sk);
@@ -1139,15 +1138,22 @@ int tcp_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 	tp->ucopy.dma_chan = NULL;
 	preempt_disable();
 	skb = skb_peek_tail(&sk->sk_receive_queue);
-	if (skb)
-		available = TCP_SKB_CB(skb)->seq + skb->len - (*seq);
-	if ((available < target) &&
-	    (len > sysctl_tcp_dma_copybreak) && !(flags & MSG_PEEK) &&
-	    !sysctl_tcp_low_latency && __get_cpu_var(softnet_data).net_dma) {
-		preempt_enable_no_resched();
-		tp->ucopy.pinned_list = dma_pin_iovec_pages(msg->msg_iov, len);
-	} else
-		preempt_enable_no_resched();
+	{
+		int available = 0;
+
+		if (skb)
+			available = TCP_SKB_CB(skb)->seq + skb->len - (*seq);
+		if ((available < target) &&
+		    (len > sysctl_tcp_dma_copybreak) && !(flags & MSG_PEEK) &&
+		    !sysctl_tcp_low_latency &&
+		    __get_cpu_var(softnet_data).net_dma) {
+			preempt_enable_no_resched();
+			tp->ucopy.pinned_list =
+					dma_pin_iovec_pages(msg->msg_iov, len);
+		} else {
+			preempt_enable_no_resched();
+		}
+	}
 #endif
 
 	do {

