Return-Path: <linux-kernel-owner+w=401wt.eu-S1755049AbZGVCAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbZGVCAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 22:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbZGVCAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 22:00:04 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59646 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709AbZGVCAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 22:00:03 -0400
Date: Wed, 22 Jul 2009 12:00:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>,
       Christian Lamparter <chunkeey@web.de>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: linux-next: manual merge of the net tree with the wireless-current
 tree
Message-Id: <20090722120000.4b0f2901.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Today's linux-next merge of the net tree got a conflict in
net/wireless/scan.c between commit
9e81eccf199d910e5ea8db377a43478e4eccd033 ("cfg80211: double free in
__cfg80211_scan_done") from the wireless-current tree and commit
667503ddcb96f3b10211f997fe55907fa7509841 ("cfg80211: fix locking") from
the net tree.

Overlapping additions.  I fixed it up (I think - see below) and can carry
the fix as ncessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/wireless/scan.c
index 9271118,4f552c3..0000000
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@@ -35,8 -48,10 +48,8 @@@ void __cfg80211_scan_done(struct work_s
  	else
  		nl80211_send_scan_done(wiphy_to_dev(request->wiphy), dev);
  
 -	wiphy_to_dev(request->wiphy)->scan_req = NULL;
 -
  #ifdef CONFIG_WIRELESS_EXT
- 	if (!aborted) {
+ 	if (!request->aborted) {
  		memset(&wrqu, 0, sizeof(wrqu));
  
  		wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);
@@@ -46,9 -61,24 +59,25 @@@
  	dev_put(dev);
  
   out:
 +	wiphy_to_dev(request->wiphy)->scan_req = NULL;
+ 	cfg80211_unlock_rdev(rdev);
  	kfree(request);
  }
+ 
+ void cfg80211_scan_done(struct cfg80211_scan_request *request, bool aborted)
+ {
+ 	struct net_device *dev = dev_get_by_index(&init_net, request->ifidx);
+ 	if (WARN_ON(!dev)) {
+ 		kfree(request);
+ 		return;
+ 	}
+ 
+ 	WARN_ON(request != wiphy_to_dev(request->wiphy)->scan_req);
+ 
+ 	request->aborted = aborted;
+ 	schedule_work(&wiphy_to_dev(request->wiphy)->scan_done_wk);
+ 	dev_put(dev);
+ }
  EXPORT_SYMBOL(cfg80211_scan_done);
  
  static void bss_release(struct kref *ref)
