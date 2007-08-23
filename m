Return-Path: <linux-kernel-owner+w=401wt.eu-S934215AbXHWWhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934215AbXHWWhN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932504AbXHWW3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:29:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33188 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765928AbXHWW3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:29:18 -0400
Date: Thu, 23 Aug 2007 15:27:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@stuata.de,
       Ilpo J?rvinen <ilpo.jarvinen@helsinki.fi>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 19/28] TCP: Fix TCP handling of SACK in bidirectional flows.
Message-ID: <20070823222727.GS18559@kroah.com>
References: <20070823220656.101239233@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline; filename="tcp-fix-tcp-handling-of-sack-in-bidirectional-flows.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070823221811.GA18559@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>

It's possible that new SACK blocks that should trigger new LOST
markings arrive with new data (which previously made is_dupack
false). In addition, I think this fixes a case where we get
a cumulative ACK with enough SACK blocks to trigger the fast
recovery (is_dupack would be false there too).

I'm not completely pleased with this solution because readability
of the code is somewhat questionable as 'is_dupack' in SACK case
is no longer about dupacks only but would mean something like
'lost_marker_work_todo' too... But because of Eifel stuff done
in CA_Recovery, the FLAG_DATA_SACKED check cannot be placed to
the if statement which seems attractive solution. Nevertheless,
I didn't like adding another variable just for that either... :-)

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/tcp_input.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2112,7 +2112,10 @@ tcp_fastretrans_alert(struct sock *sk, u
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
-	int is_dupack = (tp->snd_una == prior_snd_una && !(flag&FLAG_NOT_DUP));
+	int is_dupack = (tp->snd_una == prior_snd_una &&
+			 (!(flag&FLAG_NOT_DUP) ||
+			  ((flag&FLAG_DATA_SACKED) &&
+			   (tp->fackets_out > tp->reordering))));
 
 	/* Some technical things:
 	 * 1. Reno does not count dupacks (sacked_out) automatically. */

-- 
