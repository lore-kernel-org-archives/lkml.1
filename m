Return-Path: <linux-kernel-owner+w=401wt.eu-S1760277AbXJaP00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760277AbXJaP00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759874AbXJaPY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:24:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33452 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759868AbXJaPY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:24:27 -0400
Date: Wed, 31 Oct 2007 08:11:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       Ilpo J?rvinen <ilpo.jarvinen@helsinki.fi>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 10/26] Fix TCPs ->fastpath_cnt_hit handling.
Message-ID: <20071031151131.GK2437@kroah.com>
References: <20071031150535.967437651@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline; filename="fix-tcp-s-fastpath_cnt_hit-handling.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071031151015.GA2437@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>

changeset 48611c47d09023d9356e78550d1cadb8d61da9c8 in mainline.

When only GSO skb was partially ACKed, no hints are reset,
therefore fastpath_cnt_hint must be tweaked too or else it can
corrupt fackets_out. The corruption to occur, one must have
non-trivial ACK/SACK sequence, so this bug is not very often
that harmful. There's a fackets_out state reset in TCP because
fackets_out is known to be inaccurate and that fixes the issue
eventually anyway.

In case there was also at least one skb that got fully ACKed,
the fastpath_skb_hint is set to NULL which causes a recount for
fastpath_cnt_hint (the old value won't be accessed anymore),
thus it can safely be decremented without additional checking.

Reported by Cedric Le Goater <clg@fr.ibm.com>

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/tcp_input.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2403,6 +2403,9 @@ static int tcp_tso_acked(struct sock *sk
 			__u32 dval = min(tp->fackets_out, packets_acked);
 			tp->fackets_out -= dval;
 		}
+		/* hint's skb might be NULL but we don't need to care */
+		tp->fastpath_cnt_hint -= min_t(u32, packets_acked,
+					       tp->fastpath_cnt_hint);
 		tp->packets_out -= packets_acked;
 
 		BUG_ON(tcp_skb_pcount(skb) == 0);

-- 
