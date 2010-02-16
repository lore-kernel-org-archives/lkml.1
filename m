Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab0BPOk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 09:40:59 -0500
Received: from mail-forward1.uio.no ([129.240.10.70]:38011 "EHLO
	mail-forward1.uio.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab0BPOk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 09:40:57 -0500
Message-ID: <4B7AAE6E.7080600@simula.no>
Date: Tue, 16 Feb 2010 15:40:46 +0100
From: Andreas Petlund <apetlund@simula.no>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9pre) Gecko/20100209 Shredder/3.0.2pre
MIME-Version: 1.0
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>, shemminger@vyatta.com,
       David Miller <davem@davemloft.net>, william.allen.simpson@gmail.com,
       damian@tvk.rwth-aachen.de, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [net-next PATCH v4 3/3] net: TCP thin dupack
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 40 msgs/h 4 sum rcpts/h 43 sum msgs/h 5 total rcpts 852 max rcpts/h 40 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 64199376BCA7DD1787BC5522FE9DAB1D8C0F5C2B
X-UiO-SPAM-Test: remote_host: 128.39.37.254 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 20 total 20210 max/h 66 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Major changes:
      -Renamed variables, ioctl and sysctl.
      -Added sysctl documentation.
      -Removed redundant allocation

Signed-off-by: Andreas Petlund <apetlund@simula.no>
---
 Documentation/networking/ip-sysctl.txt |   12 ++++++++++++
 include/linux/tcp.h                    |    4 +++-
 include/net/tcp.h                      |    1 +
 net/ipv4/sysctl_net_ipv4.c             |    7 +++++++
 net/ipv4/tcp.c                         |    7 +++++++
 net/ipv4/tcp_input.c                   |   11 +++++++++++
 6 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index f147310..2571a62 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -499,6 +499,18 @@ tcp_thin_linear_timeouts - BOOLEAN
 	Documentation/networking/tcp-thin.txt
 	Default: 0
 
+tcp_thin_dupack - BOOLEAN
+	Enable dynamic triggering of retransmissions after one dupACK
+	for thin streams. If set, a check is performed upon reception
+	of a dupACK to determine if the stream is thin (less than 4
+	packets in flight). As long as the stream is found to be thin,
+	data is retransmitted on the first received dupACK. This
+	improves retransmission latency for non-aggressive thin
+	streams, often found to be time-dependent.
+	For more information on thin streams, see
+	Documentation/networking/tcp-thin.txt
+	Default: 0
+
 UDP variables:
 
 udp_mem - vector of 3 INTEGERs: min, pressure, max
diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 42885af..76b5606 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -104,6 +104,7 @@ enum {
 #define TCP_MD5SIG		14	/* TCP MD5 Signature (RFC2385) */
 #define TCP_COOKIE_TRANSACTIONS	15	/* TCP Cookie Transactions */
 #define TCP_THIN_LINEAR_TIMEOUTS 16      /* Use linear timeouts for thin streams*/
+#define TCP_THIN_DUPACK         17      /* Fast retrans. after 1 dupack */
 
 /* for TCP_INFO socket option */
 #define TCPI_OPT_TIMESTAMPS	1
@@ -343,7 +344,8 @@ struct tcp_sock {
 	u8	frto_counter;	/* Number of new acks after RTO */
 	u8	nonagle;	/* Disable Nagle algorithm?             */
 	u8      thin_lto    : 1,/* Use linear timeouts for thin streams */
-		thin_undef  : 7;
+ 		thin_dupack : 1,/* Fast retransmit on first dupack      */
+ 		thin_undef  : 6;
 
 /* RTT measurement */
 	u32	srtt;		/* smoothed round trip time << 3	*/
diff --git a/include/net/tcp.h b/include/net/tcp.h
index be49356..9180767 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -245,6 +245,7 @@ extern int sysctl_tcp_slow_start_after_idle;
 extern int sysctl_tcp_max_ssthresh;
 extern int sysctl_tcp_cookie_size;
 extern int sysctl_tcp_thin_linear_timeouts;
+extern int sysctl_tcp_thin_dupack;
 
 extern atomic_t tcp_memory_allocated;
 extern struct percpu_counter tcp_sockets_allocated;
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index e6a2460..c1bc074 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -582,6 +582,13 @@ static struct ctl_table ipv4_table[] = {
 		.mode           = 0644,
 		.proc_handler   = proc_dointvec
 	},
+        {
+		.procname       = "tcp_thin_dupack",
+		.data           = &sysctl_tcp_thin_dupack,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec
+	},
 	{
 		.procname	= "udp_mem",
 		.data		= &sysctl_udp_mem,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index a159c0d..07e06dc 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2236,6 +2236,13 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 			tp->thin_lto = val;
 		break;
 
+	case TCP_THIN_DUPACK:
+		if (val < 0 || val > 1)
+			err = -EINVAL;
+		else
+			tp->thin_dupack = val;
+		break;
+
 	case TCP_CORK:
 		/* When set indicates to always queue non-full frames.
 		 * Later the user clears this option and we transmit
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 3fddc69..0f424aa 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -89,6 +89,8 @@ int sysctl_tcp_frto __read_mostly = 2;
 int sysctl_tcp_frto_response __read_mostly;
 int sysctl_tcp_nometrics_save __read_mostly;
 
+int sysctl_tcp_thin_dupack __read_mostly;
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
+	if ((tp->thin_dupack || sysctl_tcp_thin_dupack) &&
+	    tcp_stream_is_thin(tp) && tcp_dupack_heuristics(tp) > 1 &&
+	    tcp_is_sack(tp) && sk->sk_send_head == NULL)
+		return 1;
+
 	return 0;
 }
 
-- 
1.6.3.3

