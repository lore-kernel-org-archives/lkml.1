Return-Path: <linux-kernel-owner+w=401wt.eu-S1762822AbYFNAUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762822AbYFNAUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761646AbYFNAOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:14:11 -0400
Received: from mail.suse.de ([195.135.220.2]:34413 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761615AbYFNAOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:14:09 -0400
Date: Fri, 13 Jun 2008 17:11:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Sridhar Samudrala <sri@us.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 25/47] tcp: TCP connection times out if ICMP frag needed is
	delayed
Message-ID: <20080614001129.GY24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="tcp-tcp-connection-times-out-if-icmp-frag-needed-is-delayed.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Sridhar Samudrala <sri@us.ibm.com>

[ upstream commit: 7d227cd235c809c36c847d6a597956ad9e9d2bae ]

We are seeing an issue with TCP in handling an ICMP frag needed
message that is received after net.ipv4.tcp_retries1 retransmits.
The default value of retries1 is 3. So if the path mtu changes
and ICMP frag needed is lost for the first 3 retransmits or if
it gets delayed until 3 retransmits are done, TCP doesn't update
MSS correctly and continues to retransmit the orginal message
until it timesout after tcp_retries2 retransmits.

I am seeing this issue even with the latest 2.6.25.4 kernel.

In tcp_retransmit_timer(), when retransmits counter exceeds
tcp_retries1 value, the dst cache entry of the socket is reset.
At this time, if we receive an ICMP frag needed message, the
dst entry gets updated with the new MTU, but the TCP sockets
dst_cache entry remains NULL.

So the next time when we try to retransmit after the ICMP frag
needed is received, tcp_retransmit_skb() gets called. Here the
cur_mss value is calculated at the start of the routine with
a NULL sk_dst_cache. Instead we should call tcp_current_mss after
the rebuild_header that caches the dst entry with the updated mtu.
Also the rebuild_header should be called before tcp_fragment
so that skb is fragmented if the mss goes down.

Signed-off-by: Sridhar Samudrala <sri@us.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/ipv4/tcp_output.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1836,7 +1836,7 @@ int tcp_retransmit_skb(struct sock *sk, 
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
-	unsigned int cur_mss = tcp_current_mss(sk, 0);
+	unsigned int cur_mss;
 	int err;
 
 	/* Inconslusive MTU probe */
@@ -1858,6 +1858,11 @@ int tcp_retransmit_skb(struct sock *sk, 
 			return -ENOMEM;
 	}
 
+	if (inet_csk(sk)->icsk_af_ops->rebuild_header(sk))
+		return -EHOSTUNREACH; /* Routing failure or similar. */
+
+	cur_mss = tcp_current_mss(sk, 0);
+
 	/* If receiver has shrunk his window, and skb is out of
 	 * new window, do not retransmit it. The exception is the
 	 * case, when window is shrunk to zero. In this case
@@ -1884,9 +1889,6 @@ int tcp_retransmit_skb(struct sock *sk, 
 	    (sysctl_tcp_retrans_collapse != 0))
 		tcp_retrans_try_collapse(sk, skb, cur_mss);
 
-	if (inet_csk(sk)->icsk_af_ops->rebuild_header(sk))
-		return -EHOSTUNREACH; /* Routing failure or similar. */
-
 	/* Some Solaris stacks overoptimize and ignore the FIN on a
 	 * retransmit when old data is attached.  So strip it off
 	 * since it is cheap to do so and saves bytes on the network.

-- 
