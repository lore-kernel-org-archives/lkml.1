Return-Path: <linux-kernel-owner+w=401wt.eu-S1761580AbYFNAWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761580AbYFNAWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760961AbYFNAOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:14:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:52022 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762013AbYFNAOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:14:34 -0400
Date: Fri, 13 Jun 2008 17:11:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Ilpo =?utf-8?B?SsOD4oKscnZpbmVu?= <ilpo.jarvinen@helsinki.fi>,
       "David S. Miller" <davem@davemloft.net>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 31/47] tcp FRTO: Fix fallback to conventional recovery
Message-ID: <20080614001145.GE24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline; filename="tcp-frto-fix-fallback-to-conventional-recovery.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>

[ upstream commit: a1c1f281b84a751fdb5ff919da3b09df7297619f ]

It seems that commit 009a2e3e4ec ("[TCP] FRTO: Improve
interoperability with other undo_marker users") run into
another land-mine which caused fallback to conventional
recovery to break:

1. Cumulative ACK arrives after FRTO retransmission
2. tcp_try_to_open sees zero retrans_out, clears retrans_stamp
   which should be kept like in CA_Loss state it would be
3. undo_marker change allowed tcp_packet_delayed to return
   true because of the cleared retrans_stamp once FRTO is
   terminated causing LossUndo to occur, which means all loss
   markings FRTO made are reverted.

This means that the conventional recovery basically recovered
one loss per RTT, which is not that efficient. It was quite
unobvious that the undo_marker change broken something like
this, I had a quite long session to track it down because of
the non-intuitiviness of the bug (luckily I had a trivial
reproducer at hand and I was also able to learn to use kprobes
in the process as well :-)).

This together with the NewReno+FRTO fix and FRTO in-order
workaround this fixes Damon's problems, this and the first
mentioned are enough to fix Bugzilla #10063.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Reported-by: Damon L. Chesser <damon@damtek.com>
Tested-by: Damon L. Chesser <damon@damtek.com>
Tested-by: Sebastian Hyrwall <zibbe@cisko.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/ipv4/tcp_input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2465,7 +2465,7 @@ static void tcp_try_to_open(struct sock 
 
 	tcp_verify_left_out(tp);
 
-	if (tp->retrans_out == 0)
+	if (!tp->frto_counter && tp->retrans_out == 0)
 		tp->retrans_stamp = 0;
 
 	if (flag & FLAG_ECE)

-- 
