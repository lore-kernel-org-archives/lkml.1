Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab0BHPEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 10:04:43 -0500
Received: from mail-forward2.uio.no ([129.240.10.71]:46100 "EHLO
	mail-forward2.uio.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab0BHPEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 10:04:42 -0500
Message-ID: <4B701EE8.4090106@simula.no>
Date: Mon, 08 Feb 2010 15:25:44 +0100
From: Andreas Petlund <apetlund@simula.no>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>, shemminger@vyatta.com,
       David Miller <davem@davemloft.net>, william.allen.simpson@gmail.com
Subject: [net-next PATCH v2 3/3] net: TCP thin dupack
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 32 msgs/h 4 sum rcpts/h 32 sum msgs/h 4 total rcpts 749 max rcpts/h 37 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 147DF96246C19CB52FDE522E6F0F54363B7FB048
X-UiO-SPAM-Test: remote_host: 128.39.37.254 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 16 total 18730 max/h 66 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Major changes:
1) Use thin dupACK only if SACK-option is available (to avoid corner-case
   series of spurious retransmissions).
2) Use thin dupACK only if there are no new data waiting to be sent. 

>From 00a2b08fadda20d19e1ff4b9f1c04cc978e40f84 Mon Sep 17 00:00:00 2001
From: Andreas Petlund <apetlund@simula.no>
Date: Mon, 8 Feb 2010 14:06:45 +0100
Subject: [PATCH 3/3] net: TCP thin dupack


Signed-off-by: Andreas Petlund <apetlund@simula.no>
---
 include/linux/sysctl.h     |    1 +
 include/linux/tcp.h        |    4 +++-
 include/net/tcp.h          |    1 +
 net/ipv4/sysctl_net_ipv4.c |    7 +++++++
 net/ipv4/tcp.c             |    5 +++++
 net/ipv4/tcp_input.c       |   11 +++++++++++
 6 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index d840d75..ded3f20 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -426,6 +426,7 @@ enum
 	NET_TCP_MAX_SSTHRESH=124,
 	NET_TCP_FRTO_RESPONSE=125,
 	NET_TCP_FORCE_THIN_LINEAR_TIMEOUTS=126,
+	NET_TCP_FORCE_THIN_LINEAR_DUPACK=127,
 };
 
 enum {
diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 67da706..c30ed17 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -104,6 +104,7 @@ enum {
 #define TCP_MD5SIG		14	/* TCP MD5 Signature (RFC2385) */
 #define TCP_COOKIE_TRANSACTIONS	15	/* TCP Cookie Transactions */
 #define TCP_THIN_LT             16      /* Use linear timeouts for thin streams*/
+#define TCP_THIN_DUPACK         17      /* Fast retrans. after 1 dupack */
 
 /* for TCP_INFO socket option */
 #define TCPI_OPT_TIMESTAMPS	1
@@ -343,7 +344,8 @@ struct tcp_sock {
 	u8	frto_counter;	/* Number of new acks after RTO */
 	u8	nonagle;	/* Disable Nagle algorithm?             */
 	u8      thin_lt     : 1,/* Use linear timeouts for thin streams */
-		thin_undef  : 7;
+		thin_dupack : 1,/* Fast retransmit on first dupack      */
+		thin_undef  : 6;
 
 /* RTT measurement */
 	u32	srtt;		/* smoothed round trip time << 3	*/
diff --git a/include/net/tcp.h b/include/net/tcp.h
index bc5856a..af1253c 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -245,6 +245,7 @@ extern int sysctl_tcp_slow_start_after_idle;
 extern int sysctl_tcp_max_ssthresh;
 extern int sysctl_tcp_cookie_size;
 extern int sysctl_tcp_force_thin_linear_timeouts;
+extern int sysctl_tcp_force_thin_dupack;
 
 extern atomic_t tcp_memory_allocated;
 extern struct percpu_counter tcp_sockets_allocated;
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index cb2ed35..b097a58 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -582,6 +582,13 @@ static struct ctl_table ipv4_table[] = {
 		.mode           = 0644,
 		.proc_handler   = proc_dointvec
 	},
+        {
+		.procname       = "tcp_force_thin_dupack",
+		.data           = &sysctl_tcp_force_thin_dupack,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec
+	},
 	{
 		.procname	= "udp_mem",
 		.data		= &sysctl_udp_mem,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index cbc1ee3..b542af0 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2234,6 +2234,11 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 			tp->thin_lt = 1;
 		break;
 
+	case TCP_THIN_DUPACK:
+		if (val)
+			tp->thin_dupack = 1;
+		break;
+
 	case TCP_CORK:
 		/* When set indicates to always queue non-full frames.
 		 * Later the user clears this option and we transmit
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 28e0296..eaf2c77 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -89,6 +89,8 @@ int sysctl_tcp_frto __read_mostly = 2;
 int sysctl_tcp_frto_response __read_mostly;
 int sysctl_tcp_nometrics_save __read_mostly;
 
+int sysctl_tcp_force_thin_dupack __read_mostly;
+
 int sysctl_tcp_moderate_rcvbuf __read_mostly = 1;
 int sysctl_tcp_abc __read_mostly;
 
@@ -2447,6 +2449,15 @@ static int tcp_time_to_recover(struct sock *sk)
 		return 1;
 	}
 
+	/* If a thin stream is detected, retransmit after first
+	 * received dupack. Employ only if SACK is supported in order
+	 * to avoid possible corner-case series of spurious retransmissions 
+	 * Use only if there are no unsent data. */
+	if ((tp->thin_dupack || sysctl_tcp_force_thin_dupack) &&
+	    tcp_stream_is_thin(tp) && tcp_dupack_heuristics(tp) > 1 &&
+	    tcp_is_sack(tp) && sk->sk_send_head == NULL)
+		return 1;
+
 	return 0;
 }
 
-- 
1.6.3.3




