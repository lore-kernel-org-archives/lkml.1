Return-Path: <linux-kernel-owner+w=401wt.eu-S1161390AbXDKXBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161390AbXDKXBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 19:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161362AbXDKWzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:55:09 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55677 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161348AbXDKWy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:54:57 -0400
Date: Wed, 11 Apr 2007 15:52:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 18/31] Fix IPSEC replay window handling
Message-ID: <20070411225219.GS24814@kroah.com>
References: <20070411224329.866978349@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-ipsec-replay-window-handling.patch"
In-Reply-To: <20070411225100.GA24814@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Herbert Xu <herbert@gondor.apana.org.au>

[IPSEC]: Reject packets within replay window but outside the bit mask

Up until this point we've accepted replay window settings greater than
32 but our bit mask can only accomodate 32 packets.  Thus any packet
with a sequence number within the window but outside the bit mask would
be accepted.

This patch causes those packets to be rejected instead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/xfrm/xfrm_state.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1220,7 +1220,8 @@ int xfrm_replay_check(struct xfrm_state 
 		return 0;
 
 	diff = x->replay.seq - seq;
-	if (diff >= x->props.replay_window) {
+	if (diff >= min_t(unsigned int, x->props.replay_window,
+			  sizeof(x->replay.bitmap) * 8)) {
 		x->stats.replay_window++;
 		return -EINVAL;
 	}

-- 
