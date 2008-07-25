Return-Path: <linux-kernel-owner+w=401wt.eu-S1758025AbYGYXNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbYGYXNy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 19:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220AbYGYXNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 19:13:42 -0400
Received: from ns2.suse.de ([195.135.220.15]:33666 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755960AbYGYXNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 19:13:41 -0400
Date: Fri, 25 Jul 2008 16:07:38 -0700
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
       Gerrit Renker <gerrit@erg.abdn.ac.uk>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 9/9] udplite: Protection against coverage value wrap-around
Message-ID: <20080725230738.GJ1612@suse.de>
References: <20080725225425.193966072@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0009-udplite-Protection-against-coverage-value-wrap-arou.patch"
In-Reply-To: <20080725230644.GA1612@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Gerrit Renker <gerrit@erg.abdn.ac.uk>

[ Upstream commit 47112e25da41d9059626033986dc3353e101f815 ]

This patch clamps the cscov setsockopt values to a maximum of 0xFFFF.

Setsockopt values greater than 0xffff can cause an unwanted
wrap-around.  Further, IPv6 jumbograms are not supported (RFC 3838,
3.5), so that values greater than 0xffff are not even useful.

Further changes: fixed a typo in the documentation.

[ Add USHORT_MAX from upstream to linux/kernel.h -DaveM ]

Signed-off-by: Gerrit Renker <gerrit@erg.abdn.ac.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/networking/udplite.txt |    2 +-
 include/linux/kernel.h               |    1 +
 net/ipv4/udp.c                       |    4 ++++
 3 files changed, 6 insertions(+), 1 deletion(-)

--- a/Documentation/networking/udplite.txt
+++ b/Documentation/networking/udplite.txt
@@ -148,7 +148,7 @@
         getsockopt(sockfd, SOL_SOCKET, SO_NO_CHECK, &value, ...);
 
   is meaningless (as in TCP). Packets with a zero checksum field are
-  illegal (cf. RFC 3828, sec. 3.1) will be silently discarded.
+  illegal (cf. RFC 3828, sec. 3.1) and will be silently discarded.
 
   4) Fragmentation
 
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -20,6 +20,7 @@
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
 
+#define USHORT_MAX	((u16)(~0U))
 #define INT_MAX		((int)(~0U>>1))
 #define INT_MIN		(-INT_MAX - 1)
 #define UINT_MAX	(~0U)
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1325,6 +1325,8 @@ int udp_lib_setsockopt(struct sock *sk, 
 			return -ENOPROTOOPT;
 		if (val != 0 && val < 8) /* Illegal coverage: use default (8) */
 			val = 8;
+		else if (val > USHORT_MAX)
+			val = USHORT_MAX;
 		up->pcslen = val;
 		up->pcflag |= UDPLITE_SEND_CC;
 		break;
@@ -1337,6 +1339,8 @@ int udp_lib_setsockopt(struct sock *sk, 
 			return -ENOPROTOOPT;
 		if (val != 0 && val < 8) /* Avoid silly minimal values.       */
 			val = 8;
+		else if (val > USHORT_MAX)
+			val = USHORT_MAX;
 		up->pcrlen = val;
 		up->pcflag |= UDPLITE_RECV_CC;
 		break;

-- 
