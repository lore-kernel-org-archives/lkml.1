Return-Path: <linux-kernel-owner+w=401wt.eu-S933130AbYDQBUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130AbYDQBUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759350AbYDQBIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:08:24 -0400
Received: from sous-sol.org ([216.99.217.87]:58922 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759952AbYDQBIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:08:22 -0400
Message-Id: <20080417010349.605609589@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:02:04 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Patrick McHardy <kaber@trash.net>, David S Miller <davem@davemloft.net>
Subject: VLAN: Dont copy ALLMULTI/PROMISC flags from underlying device
Content-Disposition: inline; filename=vlan-don-t-copy-allmulti-promisc-flags-from-underlying-device.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Patrick McHardy <kaber@trash.net>

Upstream commit: 0ed21b321a13421e2dfeaa70a6c324e05e3e91e6

Changing these flags requires to use dev_set_allmulti/dev_set_promiscuity
or dev_change_flags. Setting it directly causes two unwanted effects:

- the next dev_change_flags call will notice a difference between
  dev->gflags and the actual flags, enable promisc/allmulti
  mode and incorrectly update dev->gflags

- this keeps the underlying device in promisc/allmulti mode until
  the VLAN device is deleted

[ Ported back to 2.6.24 VLAN code. -DaveM ]

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/8021q/vlan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -326,7 +326,7 @@ static int vlan_dev_init(struct net_devi
 	int subclass = 0;
 
 	/* IFF_BROADCAST|IFF_MULTICAST; ??? */
-	dev->flags  = real_dev->flags & ~IFF_UP;
+	dev->flags  = real_dev->flags & ~(IFF_UP | IFF_PROMISC | IFF_ALLMULTI);
 	dev->iflink = real_dev->ifindex;
 	dev->state  = (real_dev->state & ((1<<__LINK_STATE_NOCARRIER) |
 					  (1<<__LINK_STATE_DORMANT))) |

-- 
