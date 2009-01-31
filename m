Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbZAaCso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbZAaCso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 21:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZAaCqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:46:39 -0500
Received: from kroah.org ([198.145.64.141]:54740 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752975AbZAaCqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:46:37 -0500
Date: Fri, 30 Jan 2009 18:39:49 -0800
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
Subject: [patch 05/32] mac80211: decrement ref count to netdev after
	launching mesh discovery
Message-ID: <20090131023949.GF12147@kroah.com>
References: <20090131023411.032399235@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mac80211-decrement-ref-count-to-netdev-after-launching-mesh-discovery.patch"
In-Reply-To: <20090131023906.GA12147@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

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
 net/mac80211/tx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1335,8 +1335,10 @@ int ieee80211_master_start_xmit(struct s
 			if (is_multicast_ether_addr(hdr->addr3))
 				memcpy(hdr->addr1, hdr->addr3, ETH_ALEN);
 			else
-				if (mesh_nexthop_lookup(skb, odev))
+				if (mesh_nexthop_lookup(skb, odev)) {
+					dev_put(odev);
 					return  0;
+				}
 			if (memcmp(odev->dev_addr, hdr->addr4, ETH_ALEN) != 0)
 				IEEE80211_IFSTA_MESH_CTR_INC(&osdata->u.sta,
 							     fwded_frames);

