Return-Path: <linux-kernel-owner+w=401wt.eu-S1760230AbZFIKRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230AbZFIKRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759931AbZFIKPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:15:54 -0400
Received: from kroah.org ([198.145.64.141]:59761 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759999AbZFIKPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:15:53 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:40:54 2009
Message-Id: <20090609094053.920368638@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:38:56 -0700
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
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 08/87] Revert "rose: zero length frame filtering in af_rose.c"
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=revert-rose-zero-length-frame-filtering-in-af_rose.c.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit 6fd4777a1fec1f7757b5a302ad3fdcc1eae2abba ]

This reverts commit 244f46ae6e9e18f6fc0be7d1f49febde4762c34b.

Alan Cox did the research, and just like the other radio protocols
zero-length frames have meaning because at the top level ROSE is
X.25 PLP.

So this zero-length filtering is invalid.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/rose/af_rose.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -1072,10 +1072,6 @@ static int rose_sendmsg(struct kiocb *io
 	unsigned char *asmptr;
 	int n, size, qbit = 0;
 
-	/* ROSE empty frame has no meaning : don't send */
-	if (len == 0)
-		return 0;
-
 	if (msg->msg_flags & ~(MSG_DONTWAIT|MSG_EOR|MSG_CMSG_COMPAT))
 		return -EINVAL;
 
@@ -1273,12 +1269,6 @@ static int rose_recvmsg(struct kiocb *io
 	skb_reset_transport_header(skb);
 	copied     = skb->len;
 
-	/* ROSE empty frame has no meaning : ignore it */
-	if (copied == 0) {
-		skb_free_datagram(sk, skb);
-		return copied;
-	}
-
 	if (copied > size) {
 		copied = size;
 		msg->msg_flags |= MSG_TRUNC;


