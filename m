Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242Ab0BRMp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 07:45:56 -0500
Received: from mail-forward1.uio.no ([129.240.10.70]:34921 "EHLO
	mail-forward1.uio.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab0BRMpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 07:45:55 -0500
Message-ID: <4B7D3679.407@simula.no>
Date: Thu, 18 Feb 2010 13:45:45 +0100
From: Andreas Petlund <apetlund@simula.no>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9pre) Gecko/20100209 Shredder/3.0.2pre
MIME-Version: 1.0
To: Netdev <netdev@vger.kernel.org>
CC: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       eric.dumazet@gmail.com, hannemann@nets.rwth-aachen.de,
       LKML <linux-kernel@vger.kernel.org>, shemminger@vyatta.com,
       william.allen.simpson@gmail.com, damian@tvk.rwth-aachen.de,
       ebiederm@xmission.com, David Miller <davem@davemloft.net>,
       Franco Fichtner <franco@lastsummer.de>
Subject: [net-next PATCH v5 1/3] net: TCP thin-stream detection
References: <4B7D35A5.10106@simula.no>
In-Reply-To: <4B7D35A5.10106@simula.no>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 22 msgs/h 2 sum rcpts/h 34 sum msgs/h 3 total rcpts 911 max rcpts/h 40 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 4D890EE6B5B0418210B195FEA29E97B587A9BC86
X-UiO-SPAM-Test: remote_host: 128.39.37.254 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 29 total 20759 max/h 66 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inline function to dynamically detect thin streams based on
the number of packets in flight. Used to dynamically trigger
thin-stream mechanisms if enabled by ioctl or sysctl.

Signed-off-by: Andreas Petlund <apetlund@simula.no>
---
 Documentation/networking/tcp-thin.txt |   47 +++++++++++++++++++++++++++++++++
 include/net/tcp.h                     |    8 +++++
 2 files changed, 55 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/networking/tcp-thin.txt

diff --git a/Documentation/networking/tcp-thin.txt b/Documentation/networking/tcp-thin.txt
new file mode 100644
index 0000000..151e229
--- /dev/null
+++ b/Documentation/networking/tcp-thin.txt
@@ -0,0 +1,47 @@
+Thin-streams and TCP
+====================
+A wide range of Internet-based services that use reliable transport
+protocols display what we call thin-stream properties. This means
+that the application sends data with such a low rate that the
+retransmission mechanisms of the transport protocol are not fully
+effective. In time-dependent scenarios (like online games, control
+systems, stock trading etc.) where the user experience depends
+on the data delivery latency, packet loss can be devastating for
+the service quality. Extreme latencies are caused by TCP's
+dependency on the arrival of new data from the application to trigger
+retransmissions effectively through fast retransmit instead of
+waiting for long timeouts.
+
+After analysing a large number of time-dependent interactive
+applications, we have seen that they often produce thin streams
+and also stay with this traffic pattern throughout its entire
+lifespan. The combination of time-dependency and the fact that the
+streams provoke high latencies when using TCP is unfortunate.
+
+In order to reduce application-layer latency when packets are lost,
+a set of mechanisms has been made, which address these latency issues
+for thin streams. In short, if the kernel detects a thin stream,
+the retransmission mechanisms are modified in the following manner:
+
+1) If the stream is thin, fast retransmit on the first dupACK.
+2) If the stream is thin, do not apply exponential backoff.
+
+These enhancements are applied only if the stream is detected as
+thin. This is accomplished by defining a threshold for the number
+of packets in flight. If there are less than 4 packets in flight,
+fast retransmissions can not be triggered, and the stream is prone
+to experience high retransmission latencies.
+
+Since these mechanisms are targeted at time-dependent applications,
+they must be specifically activated by the application using the
+TCP_THIN_LINEAR_TIMEOUTS and TCP_THIN_DUPACK IOCTLS or the
+tcp_thin_linear_timeouts and tcp_thin_dupack sysctls. Both
+modifications are turned off by default.
+
+References
+==========
+More information on the modifications, as well as a wide range of
+experimental data can be found here:
+"Improving latency for interactive, thin-stream applications over
+reliable transport"
+http://simula.no/research/nd/publications/Simula.nd.477/simula_pdf_file
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 75a00c8..0bdc3f6 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1386,6 +1386,14 @@ static inline void tcp_highest_sack_combine(struct sock *sk,
 		tcp_sk(sk)->highest_sack = new;
 }
 
+/* Determines whether this is a thin stream (which may suffer from
+ * increased latency). Used to trigger latency-reducing mechanisms.
+ */
+static inline unsigned int tcp_stream_is_thin(struct tcp_sock *tp)
+{
+	return tp->packets_out < 4 && !tcp_in_initial_slowstart(tp);
+}
+
 /* /proc */
 enum tcp_seq_states {
 	TCP_SEQ_STATE_LISTENING,
-- 
1.6.3.3
