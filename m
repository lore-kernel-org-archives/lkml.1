Return-Path: <linux-kernel-owner+w=401wt.eu-S1763607AbYFNAW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763607AbYFNAW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760904AbYFNAOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:14:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:51994 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761980AbYFNAOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:14:30 -0400
Date: Fri, 13 Jun 2008 17:11:42 -0700
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
Subject: [patch 30/47] tcp: fix skb vs fack_count out-of-sync condition
Message-ID: <20080614001142.GD24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline; filename="tcp-fix-skb-vs-fack_count-out-of-sync-condition.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>

[ upstream commit: a6604471db5e7a33474a7f16c64d6b118fae3e74 ]

This bug is able to corrupt fackets_out in very rare cases.
In order for this to cause corruption:
  1) DSACK in the middle of previous SACK block must be generated.
  2) In order to take that particular branch, part or all of the
     DSACKed segment must already be SACKed so that we have that
     in cache in the first place.
  3) The new info must be top enough so that fackets_out will be
     updated on this iteration.
...then fack_count is updated while skb wasn't, then we walk again
that particular segment thus updating fack_count twice for
a single skb and finally that value is assigned to fackets_out
by tcp_sacktag_one.

It is safe to call tcp_sacktag_one just once for a segment (at
DSACK), no need to call again for plain SACK.

Potential problem of the miscount are limited to premature entry
to recovery and to inflated reordering metric (which could even
cancel each other out in the most the luckiest scenarios :-)).
Both are quite insignificant in worst case too and there exists
also code to reset them (fackets_out once sacked_out becomes zero
and reordering metric on RTO).

This has been reported by a number of people, because it occurred
quite rarely, it has been very evasive. Andy Furniss was able to
get it to occur couple of times so that a bit more info was
collected about the problem using a debug patch, though it still
required lot of checking around. Thanks also to others who have
tried to help here.

This is listed as Bugzilla #10346. The bug was introduced by
me in commit 68f8353b48 ([TCP]: Rewrite SACK block processing &
sack_recv_cache use), I probably thought back then that there's
need to scan that entry twice or didn't dare to make it go
through it just once there. Going through twice would have
required restoring fack_count after the walk but as noted above,
I chose to drop the additional walk step altogether here.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/ipv4/tcp_input.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1393,9 +1393,9 @@ static struct sk_buff *tcp_maybe_skippin
 
 	if (before(next_dup->start_seq, skip_to_seq)) {
 		skb = tcp_sacktag_skip(skb, sk, next_dup->start_seq, fack_count);
-		tcp_sacktag_walk(skb, sk, NULL,
-				 next_dup->start_seq, next_dup->end_seq,
-				 1, fack_count, reord, flag);
+		skb = tcp_sacktag_walk(skb, sk, NULL,
+				     next_dup->start_seq, next_dup->end_seq,
+				     1, fack_count, reord, flag);
 	}
 
 	return skb;

-- 
