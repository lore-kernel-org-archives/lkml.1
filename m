Return-Path: <linux-kernel-owner+w=401wt.eu-S1946285AbXBCCqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946285AbXBCCqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:46:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946289AbXBCCoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:44:20 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53579 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946281AbXBCCoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:44:01 -0500
Message-Id: <20070203024654.906630000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:59 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Miller <davem@davemloft.net>, bunk@stusta.de,
       Masayuki Nakagawa <nakagawa.msy@ncos.nec.co.jp>
Subject: [patch 55/59] TCP: skb is unexpectedly freed.
Content-Disposition: inline; filename=tcp-skb-is-unexpectedly-freed.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Masayuki Nakagawa <nakagawa.msy@ncos.nec.co.jp>

I encountered a kernel panic with my test program, which is a very
simple IPv6 client-server program.

The server side sets IPV6_RECVPKTINFO on a listening socket, and the
client side just sends a message to the server.  Then the kernel panic
occurs on the server.  (If you need the test program, please let me
know. I can provide it.)

This problem happens because a skb is forcibly freed in
tcp_rcv_state_process().

When a socket in listening state(TCP_LISTEN) receives a syn packet,
then tcp_v6_conn_request() will be called from
tcp_rcv_state_process().  If the tcp_v6_conn_request() successfully
returns, the skb would be discarded by __kfree_skb().

However, in case of a listening socket which was already set
IPV6_RECVPKTINFO, an address of the skb will be stored in
treq->pktopts and a ref count of the skb will be incremented in
tcp_v6_conn_request().  But, even if the skb is still in use, the skb
will be freed.  Then someone still using the freed skb will cause the
kernel panic.

I suggest to use kfree_skb() instead of __kfree_skb().

Signed-off-by: Masayuki Nakagawa <nakagawa.msy@ncos.nec.co.jp>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 net/ipv4/tcp_input.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- linux-2.6.19.2.orig/net/ipv4/tcp_input.c
+++ linux-2.6.19.2/net/ipv4/tcp_input.c
@@ -4411,9 +4411,11 @@ int tcp_rcv_state_process(struct sock *s
 			 * But, this leaves one open to an easy denial of
 		 	 * service attack, and SYN cookies can't defend
 			 * against this problem. So, we drop the data
-			 * in the interest of security over speed.
+			 * in the interest of security over speed unless
+			 * it's still in use.
 			 */
-			goto discard;
+			kfree_skb(skb);
+			return 0;
 		}
 		goto discard;
 

--
