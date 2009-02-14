Return-Path: <linux-kernel-owner+w=401wt.eu-S1758564AbZBNBfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbZBNBfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:35:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763371AbZBNBQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:16:24 -0500
Received: from kroah.org ([198.145.64.141]:50353 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763579AbZBNBQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:16:16 -0500
Date: Fri, 13 Feb 2009 17:12:56 -0800
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
Subject: [patch 18/48] sctp: Properly timestamp outgoing data chunks for
	rtx purposes
Message-ID: <20090214011256.GS17706@kroah.com>
References: <20090214010805.419403436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sctp-properly-timestamp-outgoing-data-chunks-for-rtx-purposes.patch"
In-Reply-To: <20090214011208.GA17706@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vlad Yasevich <vladislav.yasevich@hp.com>

[ Upstream commit 759af00ebef858015eb68876ac1f383bcb6a1774 ]

Recent changes to the retransmit code exposed a long standing
bug where it was possible for a chunk to be time stamped
after the retransmit timer was reset.  This caused a rare
situation where the retrnamist timer has expired, but
nothing was marked for retrnasmission because all of
timesamps on data were less then 1 rto ago.  As result,
the timer was never restarted since nothing was retransmitted,
and this resulted in a hung association that did couldn't
complete the data transfer.  The solution is to timestamp
the chunk when it's added to the packet for transmission
purposes.  After the packet is trsnmitted the rtx timer
is restarted.  This guarantees that when the timer expires,
there will be data to retransmit.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sctp/output.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -324,14 +324,16 @@ append:
 	switch (chunk->chunk_hdr->type) {
 	    case SCTP_CID_DATA:
 		retval = sctp_packet_append_data(packet, chunk);
+		if (SCTP_XMIT_OK != retval)
+			goto finish;
 		/* Disallow SACK bundling after DATA. */
 		packet->has_sack = 1;
 		/* Disallow AUTH bundling after DATA */
 		packet->has_auth = 1;
 		/* Let it be knows that packet has DATA in it */
 		packet->has_data = 1;
-		if (SCTP_XMIT_OK != retval)
-			goto finish;
+		/* timestamp the chunk for rtx purposes */
+		chunk->sent_at = jiffies;
 		break;
 	    case SCTP_CID_COOKIE_ECHO:
 		packet->has_cookie_echo = 1;
@@ -470,7 +472,6 @@ int sctp_packet_transmit(struct sctp_pac
 			} else
 				chunk->resent = 1;
 
-			chunk->sent_at = jiffies;
 			has_data = 1;
 		}
 

