Return-Path: <linux-kernel-owner+w=401wt.eu-S1765513AbZD3RTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765513AbZD3RTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764602AbZD3RHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:07:44 -0400
Received: from kroah.org ([198.145.64.141]:56378 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764494AbZD3RHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:07:35 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:42 2009
Message-Id: <20090430165742.157178847@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:15 -0700
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
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 26/88] af_rose/x25: Sanity check the maximum user frame size
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=0043-af_rose-x25-Sanity-check-the-maximum-user-frame-siz.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Cox <alan@lxorguk.ukuu.org.uk>

upstream commit: 83e0bbcbe2145f160fbaa109b0439dae7f4a38a9

CVE-2009-0795.

Otherwise we can wrap the sizes and end up sending garbage.

Closes #10423

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/netrom/af_netrom.c |    6 +++++-
 net/rose/af_rose.c     |    4 ++++
 net/x25/af_x25.c       |    6 ++++++
 3 files changed, 15 insertions(+), 1 deletion(-)

--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -1082,7 +1082,11 @@ static int nr_sendmsg(struct kiocb *iocb
 
 	SOCK_DEBUG(sk, "NET/ROM: sendto: Addresses built.\n");
 
-	/* Build a packet */
+	/* Build a packet - the conventional user limit is 236 bytes. We can
+	   do ludicrously large NetROM frames but must not overflow */
+	if (len > 65536)
+		return -EMSGSIZE;
+
 	SOCK_DEBUG(sk, "NET/ROM: sendto: building packet.\n");
 	size = len + NR_NETWORK_LEN + NR_TRANSPORT_LEN;
 
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -1124,6 +1124,10 @@ static int rose_sendmsg(struct kiocb *io
 
 	/* Build a packet */
 	SOCK_DEBUG(sk, "ROSE: sendto: building packet.\n");
+	/* Sanity check the packet size */
+	if (len > 65535)
+		return -EMSGSIZE;
+
 	size = len + AX25_BPQ_HEADER_LEN + AX25_MAX_HEADER_LEN + ROSE_MIN_LEN;
 
 	if ((skb = sock_alloc_send_skb(sk, size, msg->msg_flags & MSG_DONTWAIT, &err)) == NULL)
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -1037,6 +1037,12 @@ static int x25_sendmsg(struct kiocb *ioc
 		sx25.sx25_addr   = x25->dest_addr;
 	}
 
+	/* Sanity check the packet size */
+	if (len > 65535) {
+		rc = -EMSGSIZE;
+		goto out;
+	}
+
 	SOCK_DEBUG(sk, "x25_sendmsg: sendto: Addresses built.\n");
 
 	/* Build a packet */


