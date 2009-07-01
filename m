Return-Path: <linux-kernel-owner+w=401wt.eu-S1762903AbZGAAni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762903AbZGAAni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760965AbZGAAcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:32:55 -0400
Received: from kroah.org ([198.145.64.141]:59832 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761000AbZGAAcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:32:54 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:15:52 2009
Message-Id: <20090701001551.874389473@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:14:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bob Copeland <me@bobcopeland.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 21/35] mac80211: fix minstrel single-rate memory corruption
References: <20090701001356.007288418@mini.kroah.org>
Content-Disposition: inline; filename=mac80211-fix-minstrel-single-rate-memory-corruption.patch
In-Reply-To: <20090701002825.GA6518@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bob Copeland <me@bobcopeland.com>

commit 5ee58d7e6ad019675b4090582aec4fa1180d8703 upstream.

The minstrel rate controller periodically looks up rate indexes in
a sampling table.  When accessing a specific row and column, minstrel
correctly does a bounds check which, on the surface, appears to handle
the case where mi->n_rates < 2.  However, mi->sample_idx is actually
defined as an unsigned, so the right hand side is taken to be a huge
positive number when negative, and the check will always fail.

Consequently, the RC will overrun the array and cause random memory
corruption when communicating with a peer that has only a single rate.
The max value of mi->sample_idx is around 25 so casting to int should
have no ill effects.

Without the change, uptime is a few minutes under load with an AP
that has a single hard-coded rate, and both the AP and STA could
potentially crash.  With the change, both lasted 12 hours with a
steady load.

Thanks to Ognjen Maric for providing the single-rate clue so I could
reproduce this.

This fixes http://bugzilla.kernel.org/show_bug.cgi?id=12490 on the
regression list (also http://bugzilla.kernel.org/show_bug.cgi?id=13000).

Reported-by: Sergey S. Kostyliov <rathamahata@gmail.com>
Reported-by: Ognjen Maric <ognjen.maric@gmail.com>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/rc80211_minstrel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -216,7 +216,7 @@ minstrel_get_next_sample(struct minstrel
 	unsigned int sample_ndx;
 	sample_ndx = SAMPLE_TBL(mi, mi->sample_idx, mi->sample_column);
 	mi->sample_idx++;
-	if (mi->sample_idx > (mi->n_rates - 2)) {
+	if ((int) mi->sample_idx > (mi->n_rates - 2)) {
 		mi->sample_idx = 0;
 		mi->sample_column++;
 		if (mi->sample_column >= SAMPLE_COLUMNS)


