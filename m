Return-Path: <linux-kernel-owner+w=401wt.eu-S1757893AbYGaADw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893AbYGaADw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbYGaADm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:03:42 -0400
Received: from ns.suse.de ([195.135.220.2]:37636 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798AbYGaADl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:03:41 -0400
Date: Wed, 30 Jul 2008 16:57:42 -0700
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
       alan@lxorguk.ukuu.org.uk, Gerrit Renker <gerrit@erg.abdn.ac.uk>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 02/62] udplite: Protection against coverage value
	wrap-around
Message-ID: <20080730235742.GB12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="udplite-protection-against-coverage-value-wrap-around.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Gerrit Renker <gerrit@erg.abdn.ac.uk>

[ Upstream commit 47112e25da41d9059626033986dc3353e101f815 ]

This patch clamps the cscov setsockopt values to a maximum of 0xFFFF.

Setsockopt values greater than 0xffff can cause an unwanted
wrap-around.  Further, IPv6 jumbograms are not supported (RFC 3838,
3.5), so that values greater than 0xffff are not even useful.

Further changes: fixed a typo in the documentation.

Signed-off-by: Gerrit Renker <gerrit@erg.abdn.ac.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/networking/udplite.txt |    2 +-
 net/ipv4/udp.c                       |    4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/Documentation/networking/udplite.txt
+++ b/Documentation/networking/udplite.txt
@@ -148,7 +148,7 @@
         getsockopt(sockfd, SOL_SOCKET, SO_NO_CHECK, &value, ...);
 
   is meaningless (as in TCP). Packets with a zero checksum field are
-  illegal (cf. RFC 3828, sec. 3.1) will be silently discarded.
+  illegal (cf. RFC 3828, sec. 3.1) and will be silently discarded.
 
   4) Fragmentation
 
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1319,6 +1319,8 @@ int udp_lib_setsockopt(struct sock *sk, 
 			return -ENOPROTOOPT;
 		if (val != 0 && val < 8) /* Illegal coverage: use default (8) */
 			val = 8;
+		else if (val > USHORT_MAX)
+			val = USHORT_MAX;
 		up->pcslen = val;
 		up->pcflag |= UDPLITE_SEND_CC;
 		break;
@@ -1331,6 +1333,8 @@ int udp_lib_setsockopt(struct sock *sk, 
 			return -ENOPROTOOPT;
 		if (val != 0 && val < 8) /* Avoid silly minimal values.       */
 			val = 8;
+		else if (val > USHORT_MAX)
+			val = USHORT_MAX;
 		up->pcrlen = val;
 		up->pcflag |= UDPLITE_RECV_CC;
 		break;

-- 
