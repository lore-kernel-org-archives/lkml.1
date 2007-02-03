Return-Path: <linux-kernel-owner+w=401wt.eu-S1946264AbXBCCmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946264AbXBCCmn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946274AbXBCCmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:42:01 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53454 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946264AbXBCClu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:41:50 -0500
Message-Id: <20070203024706.178736000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:36:00 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Patrick McHardy <kaber@trash.net>,
       Netfilter Development Mailinglist 
	<netfilter-devel@lists.netfilter.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 56/59] NETFILTER: xt_connbytes: fix division by zero
Content-Disposition: inline; filename=netfilter-xt_connbytes-fix-division-by-zero.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Patrick McHardy <kaber@trash.net>

When the packet counter of a connection is zero a division by zero
occurs in div64_64(). Fix that by using zero as average value, which
is correct as long as the packet counter didn't overflow, at which
point we have lost anyway.

Additionally we're probably going to go back to 64 bit counters
in 2.6.21.

Based on patch from Jonas Berlin <xkr47@outerspace.dyndns.org>,
with suggestions from KOVACS Krisztian <hidden@balabit.hu>.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/netfilter/xt_connbytes.c |   29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

--- linux-2.6.19.2.orig/net/netfilter/xt_connbytes.c
+++ linux-2.6.19.2/net/netfilter/xt_connbytes.c
@@ -52,6 +52,8 @@ match(const struct sk_buff *skb,
 {
 	const struct xt_connbytes_info *sinfo = matchinfo;
 	u_int64_t what = 0;	/* initialize to make gcc happy */
+	u_int64_t bytes = 0;
+	u_int64_t pkts = 0;
 	const struct ip_conntrack_counter *counters;
 
 	if (!(counters = nf_ct_get_counters(skb)))
@@ -89,29 +91,22 @@ match(const struct sk_buff *skb,
 	case XT_CONNBYTES_AVGPKT:
 		switch (sinfo->direction) {
 		case XT_CONNBYTES_DIR_ORIGINAL:
-			what = div64_64(counters[IP_CT_DIR_ORIGINAL].bytes,
-					counters[IP_CT_DIR_ORIGINAL].packets);
+			bytes = counters[IP_CT_DIR_ORIGINAL].bytes;
+			pkts  = counters[IP_CT_DIR_ORIGINAL].packets;
 			break;
 		case XT_CONNBYTES_DIR_REPLY:
-			what = div64_64(counters[IP_CT_DIR_REPLY].bytes,
-					counters[IP_CT_DIR_REPLY].packets);
+			bytes = counters[IP_CT_DIR_REPLY].bytes;
+			pkts  = counters[IP_CT_DIR_REPLY].packets;
 			break;
 		case XT_CONNBYTES_DIR_BOTH:
-			{
-				u_int64_t bytes;
-				u_int64_t pkts;
-				bytes = counters[IP_CT_DIR_ORIGINAL].bytes +
-					counters[IP_CT_DIR_REPLY].bytes;
-				pkts = counters[IP_CT_DIR_ORIGINAL].packets+
-					counters[IP_CT_DIR_REPLY].packets;
-
-				/* FIXME_THEORETICAL: what to do if sum
-				 * overflows ? */
-
-				what = div64_64(bytes, pkts);
-			}
+			bytes = counters[IP_CT_DIR_ORIGINAL].bytes +
+				counters[IP_CT_DIR_REPLY].bytes;
+			pkts  = counters[IP_CT_DIR_ORIGINAL].packets +
+				counters[IP_CT_DIR_REPLY].packets;
 			break;
 		}
+		if (pkts != 0)
+			what = div64_64(bytes, pkts);
 		break;
 	}
 

--
