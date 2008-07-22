Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbYGVXTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbYGVXTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755619AbYGVXRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:17:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:57421 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755289AbYGVXRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:17:40 -0400
Date: Tue, 22 Jul 2008 16:14:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Johannes Berg <johannes@sipsolutions.net>
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
       linux-wireless@vger.kernel.org,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 04/47] mac80211: detect driver tx bugs
Message-ID: <20080722231427.GE8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mac80211-detect-driver-tx-bugs.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Johannes Berg <johannes@sipsolutions.net>

When a driver rejects a frame in it's ->tx() callback, it must also
stop queues, otherwise mac80211 can go into a loop here. Detect this
situation and abort the loop after five retries, warning about the
driver bug.

This patch was added to mainline as
commit ef3a62d272f033989e83eb1f26505f93f93e3e69.

Thanks to Larry Finger <Larry.Finger@lwfinger.net> for doing the -stable
port.

Cc: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
 net/mac80211/tx.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1090,7 +1090,7 @@ static int ieee80211_tx(struct net_devic
 	ieee80211_tx_handler *handler;
 	struct ieee80211_txrx_data tx;
 	ieee80211_txrx_result res = TXRX_DROP, res_prepare;
-	int ret, i;
+	int ret, i, retries = 0;
 
 	WARN_ON(__ieee80211_queue_pending(local, control->queue));
 
@@ -1181,6 +1181,13 @@ retry:
 		if (!__ieee80211_queue_stopped(local, control->queue)) {
 			clear_bit(IEEE80211_LINK_STATE_PENDING,
 				  &local->state[control->queue]);
+			retries++;
+			/*
+			 * Driver bug, it's rejecting packets but
+			 * not stopping queues.
+			 */
+			if (WARN_ON_ONCE(retries > 5))
+				goto drop;
 			goto retry;
 		}
 		memcpy(&store->control, control,

-- 
