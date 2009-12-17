Return-Path: <linux-kernel-owner+w=401wt.eu-S935682AbZLQEW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935682AbZLQEW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936045AbZLQEWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:22:00 -0500
Received: from kroah.org ([198.145.64.141]:55836 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935976AbZLQEFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:05:08 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:57 2009
Message-Id: <20091217035656.995669356@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Damian Lukowski <damian@tvk.rwth-aachen.de>,
       =?ISO-8859-15?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       "David S. Miller" <davem@davemloft.net>
Subject: [108/151] tcp: Stalling connections: Fix timeout calculation routine
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Damian Lukowski <damian@tvk.rwth-aachen.de>

[ Upstream commit 07f29bc5bbae4e53e982ab956fed7207990a7786 ]

This patch fixes a problem in the TCP connection timeout calculation.
Currently, timeout decisions are made on the basis of the current
tcp_time_stamp and retrans_stamp, which is usually set at the first
retransmission.
However, if the retransmission fails in tcp_retransmit_skb(),
retrans_stamp is not updated and remains zero. This leads to wrong
decisions in retransmits_timed_out() if tcp_time_stamp is larger than
the specified timeout, which is very likely.
In this case, the TCP connection dies after the first attempted
(and unsuccessful) retransmission.

With this patch, tcp_skb_cb->when is used instead, when retrans_stamp
is not available.

This bug has been introduced together with retransmits_timed_out() in
2.6.32, as the number of retransmissions has been used for timeout
decisions before. The corresponding commit was
6fa12c85031485dff38ce550c24f10da23b0adaa (Revert Backoff [v3]:
Calculate TCP's connection close threshold as a time value.).

Thanks to Ilpo Järvinen for code suggestions and Frederic Leroy for
testing.

Reported-by: Frederic Leroy <fredo@starox.org>
Signed-off-by: Damian Lukowski <damian@tvk.rwth-aachen.de>
Acked-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/net/tcp.h |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1263,14 +1263,20 @@ static inline struct sk_buff *tcp_write_
  * TCP connection after "boundary" unsucessful, exponentially backed-off
  * retransmissions with an initial RTO of TCP_RTO_MIN.
  */
-static inline bool retransmits_timed_out(const struct sock *sk,
+static inline bool retransmits_timed_out(struct sock *sk,
 					 unsigned int boundary)
 {
 	unsigned int timeout, linear_backoff_thresh;
+	unsigned int start_ts;
 
 	if (!inet_csk(sk)->icsk_retransmits)
 		return false;
 
+	if (unlikely(!tcp_sk(sk)->retrans_stamp))
+		start_ts = TCP_SKB_CB(tcp_write_queue_head(sk))->when;
+	else
+		start_ts = tcp_sk(sk)->retrans_stamp;
+
 	linear_backoff_thresh = ilog2(TCP_RTO_MAX/TCP_RTO_MIN);
 
 	if (boundary <= linear_backoff_thresh)
@@ -1279,7 +1285,7 @@ static inline bool retransmits_timed_out
 		timeout = ((2 << linear_backoff_thresh) - 1) * TCP_RTO_MIN +
 			  (boundary - linear_backoff_thresh) * TCP_RTO_MAX;
 
-	return (tcp_time_stamp - tcp_sk(sk)->retrans_stamp) >= timeout;
+	return (tcp_time_stamp - start_ts) >= timeout;
 }
 
 static inline struct sk_buff *tcp_send_head(struct sock *sk)


