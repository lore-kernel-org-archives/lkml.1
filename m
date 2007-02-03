Return-Path: <linux-kernel-owner+w=401wt.eu-S1946293AbXBCCo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946293AbXBCCo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:44:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946285AbXBCCom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:44:42 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:36751 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946280AbXBCCog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:44:36 -0500
Message-Id: <20070203024654.196322000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:58 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Miller <davem@davemloft.net>, bunk@stusta.de,
       Baruch Even <baruch@ev-en.org>
Subject: [patch 54/59] TCP: Fix sorting of SACK blocks.
Content-Disposition: inline; filename=tcp-fix-sorting-of-sack-blocks.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Baruch Even <baruch@ev-en.org>

The sorting of SACK blocks actually munges them rather than sort,
causing the TCP stack to ignore some SACK information and breaking the
assumption of ordered SACK blocks after sorting.

The sort takes the data from a second buffer which isn't moved causing
subsequent data moves to occur from the wrong location. The fix is to
use a temporary buffer as a normal sort does.

Signed-off-By: Baruch Even <baruch@ev-en.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/ipv4/tcp_input.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- linux-2.6.19.2.orig/net/ipv4/tcp_input.c
+++ linux-2.6.19.2/net/ipv4/tcp_input.c
@@ -1011,10 +1011,11 @@ tcp_sacktag_write_queue(struct sock *sk,
 			for (j = 0; j < i; j++){
 				if (after(ntohl(sp[j].start_seq),
 					  ntohl(sp[j+1].start_seq))){
-					sp[j].start_seq = htonl(tp->recv_sack_cache[j+1].start_seq);
-					sp[j].end_seq = htonl(tp->recv_sack_cache[j+1].end_seq);
-					sp[j+1].start_seq = htonl(tp->recv_sack_cache[j].start_seq);
-					sp[j+1].end_seq = htonl(tp->recv_sack_cache[j].end_seq);
+					struct tcp_sack_block_wire tmp;
+
+					tmp = sp[j];
+					sp[j] = sp[j+1];
+					sp[j+1] = tmp;
 				}
 
 			}

--
