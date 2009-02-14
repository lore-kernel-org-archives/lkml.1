Return-Path: <linux-kernel-owner+w=401wt.eu-S1761864AbZBNBPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761864AbZBNBPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:15:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761486AbZBNBCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:02:00 -0500
Received: from kroah.org ([198.145.64.141]:39856 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753599AbZBNBB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:01:58 -0500
Date: Fri, 13 Feb 2009 16:59:15 -0800
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
       alan@lxorguk.ukuu.org.uk, Dimitris Michailidis <dm@chelsio.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 36/47] tcp: Fix length tcp_splice_data_recv passes to
	skb_splice_bits.
Message-ID: <20090214005915.GK11282@kroah.com>
References: <20090214005130.617401075@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="tcp-fix-length-tcp_splice_data_recv-passes-to-skb_splice_bits.patch"
In-Reply-To: <20090214005726.GA11282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dimitris Michailidis <dm@chelsio.com>

[ Upstream commit 9fa5fdf291c9b58b1cb8b4bb2a0ee57efa21d635 ]

tcp_splice_data_recv has two lengths to consider: the len parameter it
gets from tcp_read_sock, which specifies the amount of data in the skb,
and rd_desc->count, which is the amount of data the splice caller still
wants.  Currently it passes just the latter to skb_splice_bits, which then
splices min(rd_desc->count, skb->len - offset) bytes.

Most of the time this is fine, except when the skb contains urgent data.
In that case len goes only up to the urgent byte and is less than
skb->len - offset.  By ignoring len tcp_splice_data_recv may a) splice
data tcp_read_sock told it not to, b) return to tcp_read_sock a value > len.

Now, tcp_read_sock doesn't handle used > len and leaves the socket in a
bad state (both sk_receive_queue and copied_seq are bad at that point)
resulting in duplicated data and corruption.

Fix by passing min(rd_desc->count, len) to skb_splice_bits.

Signed-off-by: Dimitris Michailidis <dm@chelsio.com>
Acked-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/tcp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -520,7 +520,8 @@ static int tcp_splice_data_recv(read_des
 	struct tcp_splice_state *tss = rd_desc->arg.data;
 	int ret;
 
-	ret = skb_splice_bits(skb, offset, tss->pipe, rd_desc->count, tss->flags);
+	ret = skb_splice_bits(skb, offset, tss->pipe, min(rd_desc->count, len),
+			      tss->flags);
 	if (ret > 0)
 		rd_desc->count -= ret;
 	return ret;

