Return-Path: <linux-kernel-owner+w=401wt.eu-S1762197AbZD2W3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762197AbZD2W3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbZD2WV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:21:29 -0400
Received: from kroah.org ([198.145.64.141]:40415 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758323AbZD2WVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:21:25 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Apr 29 15:09:26 2009
Message-Id: <20090429220926.377289559@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 29 Apr 2009 15:07:22 -0700
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
       alan@lxorguk.ukuu.org.uk, Jean Delvare <jdelvare@suse.de>,
       "David S. Miller" <davem@davemloft.net>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 23/58] net/netrom: Fix socket locking
References: <20090429220659.339950874@mini.kroah.org>
Content-Disposition: inline; filename=0044-net-netrom-Fix-socket-locking.patch
In-Reply-To: <20090429221657.GA11765@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jean Delvare <jdelvare@suse.de>

upstream commit: cc29c70dd581f85ee7a3e7980fb031f90b90a2ab

Patch "af_rose/x25: Sanity check the maximum user frame size"
(commit 83e0bbcbe2145f160fbaa109b0439dae7f4a38a9) from Alan Cox got
locking wrong. If we bail out due to user frame size being too large,
we must unlock the socket beforehand.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
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


