Return-Path: <linux-kernel-owner+w=401wt.eu-S936151AbZLQEFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936151AbZLQEFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935650AbZLQEEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:04:36 -0500
Received: from kroah.org ([198.145.64.141]:55588 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935631AbZLQEEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:30 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:51 2009
Message-Id: <20091217035651.568432019@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [067/151] mac80211: fix scan abort sanity checks
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes@sipsolutions.net>

commit 6d3560d4fc9c5b9fe1a07a63926ea70512c69c32 upstream.

Since sometimes mac80211 queues up a scan request
to only act on it later, it must be allowed to
(internally) cancel a not-yet-running scan, e.g.
when the interface is taken down. This condition
was missing since we always checked only the
local->scanning variable which isn't yet set in
that situation.

Reported-by: Luis R. Rodriguez <mcgrof@gmail.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/scan.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -264,10 +264,14 @@ void ieee80211_scan_completed(struct iee
 
 	mutex_lock(&local->scan_mtx);
 
-	if (WARN_ON(!local->scanning)) {
-		mutex_unlock(&local->scan_mtx);
-		return;
-	}
+	/*
+	 * It's ok to abort a not-yet-running scan (that
+	 * we have one at all will be verified by checking
+	 * local->scan_req next), but not to complete it
+	 * successfully.
+	 */
+	if (WARN_ON(!local->scanning && !aborted))
+		aborted = true;
 
 	if (WARN_ON(!local->scan_req)) {
 		mutex_unlock(&local->scan_mtx);


