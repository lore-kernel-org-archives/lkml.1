Return-Path: <linux-kernel-owner+w=401wt.eu-S1759279AbZAaC7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279AbZAaC7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 21:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756600AbZAaCrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:15 -0500
Received: from kroah.org ([198.145.64.141]:55142 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755912AbZAaCrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:08 -0500
Date: Fri, 30 Jan 2009 18:42:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Brian Cavagnolo <brian@cozybit.com>,
       Andrey Yurovsky <andrey@cozybit.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 02/43] mac80211: decrement ref count to netdev after
	launching mesh discovery
Message-ID: <20090131024217.GC12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mac80211-decrement-ref-count-to-netdev-after-launching-mesh-discovery.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Brian Cavagnolo <brian@cozybit.com>

commit 5dc306f3bd1d4cfdf79df39221b3036eab1ddcf3 upstream.

After launching mesh discovery in tx path, reference count was not being
decremented.  This was preventing module unload.

Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/tx.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1299,8 +1299,10 @@ int ieee80211_master_start_xmit(struct s
 		if (is_multicast_ether_addr(hdr->addr3))
 			memcpy(hdr->addr1, hdr->addr3, ETH_ALEN);
 		else
-			if (mesh_nexthop_lookup(skb, osdata))
-				return  0;
+			if (mesh_nexthop_lookup(skb, osdata)) {
+				dev_put(odev);
+				return 0;
+			}
 		if (memcmp(odev->dev_addr, hdr->addr4, ETH_ALEN) != 0)
 			IEEE80211_IFSTA_MESH_CTR_INC(&osdata->u.mesh,
 							    fwded_frames);

