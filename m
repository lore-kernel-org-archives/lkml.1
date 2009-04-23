Return-Path: <linux-kernel-owner+w=401wt.eu-S1758720AbZDWHnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbZDWHnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbZDWHay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:30:54 -0400
Received: from sous-sol.org ([216.99.217.87]:50520 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755474AbZDWHaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:30:52 -0400
Message-Id: <20090423072536.813114918@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:05 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
       alan@lxorguk.ukuu.org.uk, Jean Delvare <jdelvare@suse.de>,
       David S Miller <davem@davemloft.net>
Subject: [patch 045/100] net/netrom: Fix socket locking
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=net-netrom-fix-socket-locking.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jean Delvare <jdelvare@suse.de>

upstream commit: cc29c70dd581f85ee7a3e7980fb031f90b90a2ab

Patch "af_rose/x25: Sanity check the maximum user frame size"
(commit 83e0bbcbe2145f160fbaa109b0439dae7f4a38a9) from Alan Cox got
locking wrong. If we bail out due to user frame size being too large,
we must unlock the socket beforehand.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
in net-2.6 on way to Linus

 net/netrom/af_netrom.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -1084,8 +1084,10 @@ static int nr_sendmsg(struct kiocb *iocb
 
 	/* Build a packet - the conventional user limit is 236 bytes. We can
 	   do ludicrously large NetROM frames but must not overflow */
-	if (len > 65536)
-		return -EMSGSIZE;
+	if (len > 65536) {
+		err = -EMSGSIZE;
+		goto out;
+	}
 
 	SOCK_DEBUG(sk, "NET/ROM: sendto: building packet.\n");
 	size = len + NR_NETWORK_LEN + NR_TRANSPORT_LEN;

