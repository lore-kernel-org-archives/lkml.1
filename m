Return-Path: <linux-kernel-owner+w=401wt.eu-S1760929AbYHEJ23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760929AbYHEJ23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 05:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbYHEJ2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 05:28:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59157 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752860AbYHEJ2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 05:28:18 -0400
Message-ID: <48981C57.10902@cn.fujitsu.com>
Date: Tue, 05 Aug 2008 17:24:39 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] Prevent from passing NULL pointer to tcp_v6_md5_do_lookup()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If skb->sk == NULL when calling tcp_v6_md5_do_lookup(), kernel
will panic. Don't let this thing happen.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 net/ipv6/tcp_ipv6.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 78185a4..5b90b36 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -69,7 +69,8 @@
 #include <linux/scatterlist.h>
 
 static void	tcp_v6_send_reset(struct sock *sk, struct sk_buff *skb);
-static void	tcp_v6_reqsk_send_ack(struct sk_buff *skb, struct request_sock *req);
+static void	tcp_v6_reqsk_send_ack(struct sock *sk, struct sk_buff *skb,
+				      struct request_sock *req);
 
 static int	tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb);
 
@@ -1138,10 +1139,11 @@ static void tcp_v6_timewait_ack(struct sock *sk, struct sk_buff *skb)
 	inet_twsk_put(tw);
 }
 
-static void tcp_v6_reqsk_send_ack(struct sk_buff *skb, struct request_sock *req)
+static void tcp_v6_reqsk_send_ack(struct sock *sk, struct sk_buff *skb,
+				  struct request_sock *req)
 {
 	tcp_v6_send_ack(skb, tcp_rsk(req)->snt_isn + 1, tcp_rsk(req)->rcv_isn + 1, req->rcv_wnd, req->ts_recent,
-			tcp_v6_md5_do_lookup(skb->sk, &ipv6_hdr(skb)->daddr));
+			tcp_v6_md5_do_lookup(sk, &ipv6_hdr(skb)->daddr));
 }
 
 
-- 
1.5.3



