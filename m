Return-Path: <linux-kernel-owner+w=401wt.eu-S1765654AbZBNBem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765654AbZBNBem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:34:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764118AbZBNBQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:16:22 -0500
Received: from kroah.org ([198.145.64.141]:50339 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762592AbZBNBQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:16:15 -0500
Date: Fri, 13 Feb 2009 17:12:55 -0800
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
       alan@lxorguk.ukuu.org.uk, Vlad Yasevich <vladislav.yasevich@hp.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 17/48] sctp: Correctly start rtx timer on new packet
	transmissions.
Message-ID: <20090214011255.GR17706@kroah.com>
References: <20090214010805.419403436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sctp-correctly-start-rtx-timer-on-new-packet-transmissions.patch"
In-Reply-To: <20090214011208.GA17706@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vlad Yasevich <vladislav.yasevich@hp.com>

[ Upstream commit 6574df9a89f9f7da3a4e5cee7633d430319d3350 ]

Commit 62aeaff5ccd96462b7077046357a6d7886175a57
(sctp: Start T3-RTX timer when fast retransmitting lowest TSN)
introduced a regression where it was possible to forcibly
restart the sctp retransmit timer at the transmission of any
new chunk.  This resulted in much longer timeout times and
sometimes hung sctp connections.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sctp/outqueue.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -929,7 +929,6 @@ static int sctp_outq_flush(struct sctp_o
 		}
 
 		/* Finally, transmit new packets.  */
-		start_timer = 0;
 		while ((chunk = sctp_outq_dequeue_data(q)) != NULL) {
 			/* RFC 2960 6.5 Every DATA chunk MUST carry a valid
 			 * stream identifier.
@@ -1028,7 +1027,7 @@ static int sctp_outq_flush(struct sctp_o
 			list_add_tail(&chunk->transmitted_list,
 				      &transport->transmitted);
 
-			sctp_transport_reset_timers(transport, start_timer-1);
+			sctp_transport_reset_timers(transport, 0);
 
 			q->empty = 0;
 

