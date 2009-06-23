Return-Path: <linux-kernel-owner+w=401wt.eu-S1760623AbZFWPFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760623AbZFWPFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759116AbZFWPEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:04:11 -0400
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:36366 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759803AbZFWPEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:04:08 -0400
From: Jesper Dangaard Brouer <hawk@comx.dk>
Subject: [PATCH 03/10] mac80211: Use rcu_barrier() on unload.
To: "David S. Miller" <davem@davemloft.net>
Cc: Jesper Dangaard Brouer <hawk@comx.dk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, dougthompson@xmission.com,
       bluesmoke-devel@lists.sourceforge.net, axboe@kernel.dk,
       "Patrick McHardy" <kaber@trash.net>, christine.caulfield@googlemail.com,
       Trond.Myklebust@netapp.com, linux-wireless@vger.kernel.org,
       johannes@sipsolutions.net, yoshfuji@linux-ipv6.org,
       shemminger@linux-foundation.org, linux-nfs@vger.kernel.org,
       bfields@fieldses.org, neilb@suse.de, linux-ext4@vger.kernel.org,
       tytso@mit.edu, adilger@sun.com, netfilter-devel@vger.kernel.org
Date: Tue, 23 Jun 2009 17:04:09 +0200
Message-ID: <20090623150409.22490.99106.stgit@localhost>
In-Reply-To: <20090623150330.22490.87327.stgit@localhost>
References: <20090623150330.22490.87327.stgit@localhost>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mac80211 module uses rcu_call() thus it should use rcu_barrier()
on module unload.

I'm having a hardtime verifying that no more call_rcu() callbacks can
be schedules in the module unload path.  Could a maintainer please
look into this?

Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>
---

 net/mac80211/main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 092a017..e9f70ce 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1100,6 +1100,8 @@ static void __exit ieee80211_exit(void)
 		ieee80211s_stop();
 
 	ieee80211_debugfs_netdev_exit();
+
+	rcu_barrier(); /* Wait for completion of call_rcu()'s */
 }
 
 

