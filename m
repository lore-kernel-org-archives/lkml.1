Return-Path: <linux-kernel-owner+w=401wt.eu-S1758679AbYJFXbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679AbYJFXbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756751AbYJFXXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:23:09 -0400
Received: from mail.suse.de ([195.135.220.2]:41106 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757048AbYJFXXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:23:08 -0400
Date: Mon, 6 Oct 2008 16:17:59 -0700
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
Subject: [patch 27/28] sctp: Fix oops when INIT-ACK indicates that peer
	doesnt support AUTH
Message-ID: <20081006231759.GB20567@suse.de>
References: <20081006225949.357365087@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0005-sctp-Fix-oops-when-INIT-ACK-indicates-that-peer-doe.patch"
In-Reply-To: <20081006231639.GA20567@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Vlad Yasevich <vladislav.yasevich@hp.com>

[ Upstream commit add52379dde2e5300e2d574b172e62c6cf43b3d3 ]

If INIT-ACK is received with SupportedExtensions parameter which
indicates that the peer does not support AUTH, the packet will be
silently ignore, and sctp_process_init() do cleanup all of the
transports in the association.
When T1-Init timer is expires, OOPS happen while we try to choose
a different init transport.

The solution is to only clean up the non-active transports, i.e
the ones that the peer added.  However, that introduces a problem
with sctp_connectx(), because we don't mark the proper state for
the transports provided by the user.  So, we'll simply mark
user-provided transports as ACTIVE.  That will allow INIT
retransmissions to work properly in the sctp_connectx() context
and prevent the crash.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sctp/associola.c     |    9 +++++----
 net/sctp/sm_make_chunk.c |    6 ++----
 2 files changed, 7 insertions(+), 8 deletions(-)

--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -588,11 +588,12 @@ struct sctp_transport *sctp_assoc_add_pe
 	/* Check to see if this is a duplicate. */
 	peer = sctp_assoc_lookup_paddr(asoc, addr);
 	if (peer) {
+		/* An UNKNOWN state is only set on transports added by
+		 * user in sctp_connectx() call.  Such transports should be
+		 * considered CONFIRMED per RFC 4960, Section 5.4.
+		 */
 		if (peer->state == SCTP_UNKNOWN) {
-			if (peer_state == SCTP_ACTIVE)
-				peer->state = SCTP_ACTIVE;
-			if (peer_state == SCTP_UNCONFIRMED)
-				peer->state = SCTP_UNCONFIRMED;
+			peer->state = SCTP_ACTIVE;
 		}
 		return peer;
 	}
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2321,12 +2321,10 @@ clean_up:
 	/* Release the transport structures. */
 	list_for_each_safe(pos, temp, &asoc->peer.transport_addr_list) {
 		transport = list_entry(pos, struct sctp_transport, transports);
-		list_del_init(pos);
-		sctp_transport_free(transport);
+		if (transport->state != SCTP_ACTIVE)
+			sctp_assoc_rm_peer(asoc, transport);
 	}
 
-	asoc->peer.transport_count = 0;
-
 nomem:
 	return 0;
 }

-- 
