Return-Path: <linux-kernel-owner+w=401wt.eu-S932431AbZBNBjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431AbZBNBjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764124AbZBNBQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:16:36 -0500
Received: from kroah.org ([198.145.64.141]:50494 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763372AbZBNBQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:16:26 -0500
Date: Fri, 13 Feb 2009 17:13:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Eric Dumazet <dada1@cosmosbay.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 28/48] udp: increments sk_drops in __udp_queue_rcv_skb()
Message-ID: <20090214011315.GC17706@kroah.com>
References: <20090214010805.419403436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="udp-increments-sk_drops-in-__udp_queue_rcv_skb.patch"
In-Reply-To: <20090214011208.GA17706@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Dumazet <dada1@cosmosbay.com>

[ Upstream commit e408b8dcb5ce42243a902205005208e590f28454 ]

Commit 93821778def10ec1e69aa3ac10adee975dad4ff3 (udp: Fix rcv socket
locking) accidentally removed sk_drops increments for UDP IPV4
sockets.

This field can be used to detect incorrect sizing of socket receive
buffers.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/udp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -942,9 +942,11 @@ static int __udp_queue_rcv_skb(struct so
 
 	if ((rc = sock_queue_rcv_skb(sk, skb)) < 0) {
 		/* Note that an ENOMEM error is charged twice */
-		if (rc == -ENOMEM)
+		if (rc == -ENOMEM) {
 			UDP_INC_STATS_BH(sock_net(sk), UDP_MIB_RCVBUFERRORS,
 					 is_udplite);
+			atomic_inc(&sk->sk_drops);
+		}
 		goto drop;
 	}
 

