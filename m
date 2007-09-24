Return-Path: <linux-kernel-owner+w=401wt.eu-S1763374AbXIXQnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763374AbXIXQnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761232AbXIXQ2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:28:46 -0400
Received: from canuck.infradead.org ([209.217.80.40]:58151 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761227AbXIXQ2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:28:44 -0400
Date: Mon, 24 Sep 2007 09:22:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [47/50] Fix datagram recvmsg NULL iov handling regression.
Message-ID: <20070924162245.GV13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-datagram-recvmsg-null-iov-handling-regression.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

commit ef8aef55ce61fd0e2af798695f7386ac756ae1e7 in mainline

Subject: [47/50] [PATCH] [NET]: Do not dereference iov if length is zero

When msg_iovlen is zero we shouldn't try to dereference
msg_iov.  Right now the only thing that tries to do so
is skb_copy_and_csum_datagram_iovec.  Since the total
length should also be zero if msg_iovlen is zero, it's
sufficient to check the total length there and simply
return if it's zero.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/datagram.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -450,6 +450,9 @@ int skb_copy_and_csum_datagram_iovec(str
 	__wsum csum;
 	int chunk = skb->len - hlen;
 
+	if (!chunk)
+		return 0;
+
 	/* Skip filled elements.
 	 * Pretty silly, look at memcpy_toiovec, though 8)
 	 */

-- 
