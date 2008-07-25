Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbYGYXMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbYGYXMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 19:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757464AbYGYXLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 19:11:43 -0400
Received: from mx1.suse.de ([195.135.220.2]:58363 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757458AbYGYXLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 19:11:42 -0400
Date: Fri, 25 Jul 2008 16:07:25 -0700
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
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       James Chapman <jchapman@katalix.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 4/9] l2tp: Fix potential memory corruption in
	pppol2tp_recvmsg()
Message-ID: <20080725230725.GE1612@suse.de>
References: <20080725225425.193966072@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0004-l2tp-Fix-potential-memory-corruption-in-pppol2tp_re.patch"
In-Reply-To: <20080725230644.GA1612@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: James Chapman <jchapman@katalix.com>

[ Upstream commit 6b6707a50c7598a83820077393f8823ab791abf8 ]

This patch fixes a potential memory corruption in
pppol2tp_recvmsg(). If skb->len is bigger than the caller's buffer
length, memcpy_toiovec() will go into unintialized data on the kernel
heap, interpret it as an iovec and start modifying memory.

The fix is to change the memcpy_toiovec() call to
skb_copy_datagram_iovec() so that paged packets (rare for PPPOL2TP)
are handled properly. Also check that the caller's buffer is big
enough for the data and set the MSG_TRUNC flag if it is not so.

Reported-by: Ilja <ilja@netric.org>
Signed-off-by: James Chapman <jchapman@katalix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/pppol2tp.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/drivers/net/pppol2tp.c
+++ b/drivers/net/pppol2tp.c
@@ -783,14 +783,18 @@ static int pppol2tp_recvmsg(struct kiocb
 	err = 0;
 	skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
 				flags & MSG_DONTWAIT, &err);
-	if (skb) {
-		err = memcpy_toiovec(msg->msg_iov, (unsigned char *) skb->data,
-				     skb->len);
-		if (err < 0)
-			goto do_skb_free;
-		err = skb->len;
-	}
-do_skb_free:
+	if (!skb)
+		goto end;
+
+	if (len > skb->len)
+		len = skb->len;
+	else if (len < skb->len)
+		msg->msg_flags |= MSG_TRUNC;
+
+	err = skb_copy_datagram_iovec(skb, 0, msg->msg_iov, len);
+	if (likely(err == 0))
+		err = len;
+
 	kfree_skb(skb);
 end:
 	return err;

-- 
