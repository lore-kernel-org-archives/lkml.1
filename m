Return-Path: <linux-kernel-owner+w=401wt.eu-S1758932AbYGVX1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932AbYGVX1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756717AbYGVXTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:19:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:57866 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757212AbYGVXTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:19:52 -0400
Date: Tue, 22 Jul 2008 16:16:29 -0700
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
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
       Patrick McHardy <kaber@trash.net>
Subject: [patch 28/47] netfilter: nf_conntrack_tcp: fixing to check the
	lower bound of valid ACK
Message-ID: <20080722231629.GC8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline; filename="netfilter-nf_conntrack_tcp-fixing-to-check-the-lower-bound-of-valid-ack.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Upstream commit 84ebe1c:

Lost connections was reported by Thomas Bätzler (running 2.6.25 kernel) on
the netfilter mailing list (see the thread "Weird nat/conntrack Problem
with PASV FTP upload"). He provided tcpdump recordings which helped to
find a long lingering bug in conntrack.

In TCP connection tracking, checking the lower bound of valid ACK could
lead to mark valid packets as INVALID because:

 - We have got a "higher or equal" inequality, but the test checked
   the "higher" condition only; fixed.
 - If the packet contains a SACK option, it could occur that the ACK
   value was before the left edge of our (S)ACK "window": if a previous
   packet from the other party intersected the right edge of the window
   of the receiver, we could move forward the window parameters beyond
   accepting a valid ack. Therefore in this patch we check the rightmost
   SACK edge instead of the ACK value in the lower bound of valid (S)ACK
   test.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
 net/netfilter/nf_conntrack_proto_tcp.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -332,12 +332,13 @@ static unsigned int get_conntrack_index(
 
    I.   Upper bound for valid data:	seq <= sender.td_maxend
    II.  Lower bound for valid data:	seq + len >= sender.td_end - receiver.td_maxwin
-   III.	Upper bound for valid ack:      sack <= receiver.td_end
-   IV.	Lower bound for valid ack:	ack >= receiver.td_end - MAXACKWINDOW
+   III.	Upper bound for valid (s)ack:   sack <= receiver.td_end
+   IV.	Lower bound for valid (s)ack:	sack >= receiver.td_end - MAXACKWINDOW
 
-   where sack is the highest right edge of sack block found in the packet.
+   where sack is the highest right edge of sack block found in the packet
+   or ack in the case of packet without SACK option.
 
-   The upper bound limit for a valid ack is not ignored -
+   The upper bound limit for a valid (s)ack is not ignored -
    we doesn't have to deal with fragments.
 */
 
@@ -607,12 +608,12 @@ static int tcp_in_window(const struct nf
 		 before(seq, sender->td_maxend + 1),
 		 after(end, sender->td_end - receiver->td_maxwin - 1),
 		 before(sack, receiver->td_end + 1),
-		 after(ack, receiver->td_end - MAXACKWINDOW(sender)));
+		 after(sack, receiver->td_end - MAXACKWINDOW(sender) - 1));
 
 	if (before(seq, sender->td_maxend + 1) &&
 	    after(end, sender->td_end - receiver->td_maxwin - 1) &&
 	    before(sack, receiver->td_end + 1) &&
-	    after(ack, receiver->td_end - MAXACKWINDOW(sender))) {
+	    after(sack, receiver->td_end - MAXACKWINDOW(sender) - 1)) {
 		/*
 		 * Take into account window scaling (RFC 1323).
 		 */

-- 
