Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab0BAJSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 04:18:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570Ab0BAJSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 04:18:33 -0500
Date: Mon, 1 Feb 2010 04:18:28 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Amerigo Wang <amwang@redhat.com>, David Miller <davem@davemloft.net>
Message-Id: <20100201092153.4194.91507.sendpatchset@localhost.localdomain>
Subject: [Patch v2] net: export TCP send buffer size via netlink
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V1 -> V2:
Keep ABI compatiblity of struct tcp_info.

Currently, we can only get TCP send buffer size by
getsockopt (SO_SNDBUF or TCP_INFO), this is not enough
for the tools like netstat or ss to read.

Show TCP send buffer size via netlink NETLINK_INET_DIAG.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>

---

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 7fee8a4..b63f541 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -163,6 +163,8 @@ struct tcp_info {
 	__u32	tcpi_rcv_space;
 
 	__u32	tcpi_total_retrans;
+
+	__u32	tcpi_sndbuf;
 };
 
 /* for TCP_MD5SIG socket option */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index b0a26bb..b3d6a62 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2385,6 +2385,7 @@ void tcp_get_info(struct sock *sk, struct tcp_info *info)
 	info->tcpi_retransmits = icsk->icsk_retransmits;
 	info->tcpi_probes = icsk->icsk_probes_out;
 	info->tcpi_backoff = icsk->icsk_backoff;
+	info->tcpi_sndbuf = sk->sk_sndbuf;
 
 	if (tp->rx_opt.tstamp_ok)
 		info->tcpi_options |= TCPI_OPT_TIMESTAMPS;
