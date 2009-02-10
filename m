Return-Path: <linux-kernel-owner+w=401wt.eu-S1759133AbZBJTWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759133AbZBJTWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755789AbZBJTEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:04:31 -0500
Received: from kroah.org ([198.145.64.141]:34050 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756016AbZBJTEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:04:30 -0500
Date: Tue, 10 Feb 2009 11:01:41 -0800
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
Subject: [patch 53/53] sctp: Fix another socket race during accept/peeloff
Message-ID: <20090210190141.GB14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sctp-fix-another-socket-race-during-accept-peeloff.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Vlad Yasevich <vladislav.yasevich@hp.com>

commit ae53b5bd77719fed58086c5be60ce4f22bffe1c6 upstream.

There is a race between sctp_rcv() and sctp_accept() where we
have moved the association from the listening socket to the
accepted socket, but sctp_rcv() processing cached the old
socket and continues to use it.

The easy solution is to check for the socket mismatch once we've
grabed the socket lock.  If we hit a mis-match, that means
that were are currently holding the lock on the listening socket,
but the association is refrencing a newly accepted socket.  We need
to drop the lock on the old socket and grab the lock on the new one.

A more proper solution might be to create accepted sockets when
the new association is established, similar to TCP.  That would
eliminate the race for 1-to-1 style sockets, but it would still
existing for 1-to-many sockets where a user wished to peeloff an
association.  For now, we'll live with this easy solution as
it addresses the problem.

Reported-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sctp/input.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -249,6 +249,19 @@ int sctp_rcv(struct sk_buff *skb)
 	 */
 	sctp_bh_lock_sock(sk);
 
+	if (sk != rcvr->sk) {
+		/* Our cached sk is different from the rcvr->sk.  This is
+		 * because migrate()/accept() may have moved the association
+		 * to a new socket and released all the sockets.  So now we
+		 * are holding a lock on the old socket while the user may
+		 * be doing something with the new socket.  Switch our veiw
+		 * of the current sk.
+		 */
+		sctp_bh_unlock_sock(sk);
+		sk = rcvr->sk;
+		sctp_bh_lock_sock(sk);
+	}
+
 	if (sock_owned_by_user(sk)) {
 		SCTP_INC_STATS_BH(SCTP_MIB_IN_PKT_BACKLOG);
 		sctp_add_backlog(sk, skb);

