Return-Path: <linux-kernel-owner+w=401wt.eu-S1761282AbYLKTmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761282AbYLKTmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:42:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757107AbYLKTTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:19:19 -0500
Received: from kroah.org ([198.145.64.141]:56630 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756767AbYLKTTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:19:16 -0500
Date: Thu, 11 Dec 2008 11:16:15 -0800
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
       alan@lxorguk.ukuu.org.uk, Divy Le Ray <divy@chelsio.com>,
       Jeff Garzik <jgarzik@redhat.com>, Hannes Reinecke <hare@suse.de>
Subject: [patch 66/83] cxgb3 - remove duplicate tests in lro
Message-ID: <20081211191615.GN5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cxgb3-remove-duplicate-tests-in-lro.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Divy Le Ray <divy@chelsio.com>

commit 004f23b9d3874efc81d2d1cf18fd0fe48dc2f26f upstream.

The generic lro code checks TCP flags/options.
Remove duplicate tests done in the driver.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/cxgb3/sge.c |   35 -----------------------------------
 1 file changed, 35 deletions(-)

--- a/drivers/net/cxgb3/sge.c
+++ b/drivers/net/cxgb3/sge.c
@@ -1934,38 +1934,6 @@ static inline int lro_frame_ok(const str
 		eh->h_proto == htons(ETH_P_IP) && ih->ihl == (sizeof(*ih) >> 2);
 }
 
-#define TCP_FLAG_MASK (TCP_FLAG_CWR | TCP_FLAG_ECE | TCP_FLAG_URG |\
-                       TCP_FLAG_ACK | TCP_FLAG_PSH | TCP_FLAG_RST |\
-		                       TCP_FLAG_SYN | TCP_FLAG_FIN)
-#define TSTAMP_WORD ((TCPOPT_NOP << 24) | (TCPOPT_NOP << 16) |\
-                     (TCPOPT_TIMESTAMP << 8) | TCPOLEN_TIMESTAMP)
-
-/**
- *	lro_segment_ok - check if a TCP segment is eligible for LRO
- *	@tcph: the TCP header of the packet
- *
- *	Returns true if a TCP packet is eligible for LRO.  This requires that
- *	the packet have only the ACK flag set and no TCP options besides
- *	time stamps.
- */
-static inline int lro_segment_ok(const struct tcphdr *tcph)
-{
-	int optlen;
-
-	if (unlikely((tcp_flag_word(tcph) & TCP_FLAG_MASK) != TCP_FLAG_ACK))
-		return 0;
-
-	optlen = (tcph->doff << 2) - sizeof(*tcph);
-	if (optlen) {
-		const u32 *opt = (const u32 *)(tcph + 1);
-
-		if (optlen != TCPOLEN_TSTAMP_ALIGNED ||
-		    *opt != htonl(TSTAMP_WORD) || !opt[2])
-			return 0;
-	}
-	return 1;
-}
-
 static int t3_get_lro_header(void **eh,  void **iph, void **tcph,
 			     u64 *hdr_flags, void *priv)
 {
@@ -1978,9 +1946,6 @@ static int t3_get_lro_header(void **eh, 
 	*iph = (struct iphdr *)((struct ethhdr *)*eh + 1);
 	*tcph = (struct tcphdr *)((struct iphdr *)*iph + 1);
 
-	 if (!lro_segment_ok(*tcph))
-		return -1;
-
 	*hdr_flags = LRO_IPV4 | LRO_TCP;
 	return 0;
 }

