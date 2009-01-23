Return-Path: <linux-kernel-owner+w=401wt.eu-S1752501AbZAWGTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbZAWGTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 01:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757994AbZAWGQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 01:16:27 -0500
Received: from kroah.org ([198.145.64.141]:36145 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756037AbZAWGQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 01:16:26 -0500
Date: Thu, 22 Jan 2009 22:13:20 -0800
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
       alan@lxorguk.ukuu.org.uk, Lennert Buytenhek <buytenh@marvell.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 08/40] tcp: dont mask EOF and socket errors on nonblocking
	splice receive
Message-ID: <20090123061320.GH2922@kroah.com>
References: <20090123001330.046404396@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="tcp-don-t-mask-eof-and-socket-errors-on-nonblocking-splice-receive.patch"
In-Reply-To: <20090123001908.GA7397@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lennert Buytenhek <buytenh@marvell.com>

[ Upstream commit: 4f7d54f59bc470f0aaa932f747a95232d7ebf8b1 ]

Currently, setting SPLICE_F_NONBLOCK on splice from a TCP socket
results in masking of EOF (RDHUP) and error conditions on the socket
by an -EAGAIN return.  Move the NONBLOCK check in tcp_splice_read()
to be after the EOF and error checks to fix this.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/tcp.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -576,10 +576,6 @@ ssize_t tcp_splice_read(struct socket *s
 		else if (!ret) {
 			if (spliced)
 				break;
-			if (flags & SPLICE_F_NONBLOCK) {
-				ret = -EAGAIN;
-				break;
-			}
 			if (sock_flag(sk, SOCK_DONE))
 				break;
 			if (sk->sk_err) {
@@ -597,6 +593,10 @@ ssize_t tcp_splice_read(struct socket *s
 					ret = -ENOTCONN;
 				break;
 			}
+			if (flags & SPLICE_F_NONBLOCK) {
+				ret = -EAGAIN;
+				break;
+			}
 			if (!timeo) {
 				ret = -EAGAIN;
 				break;

