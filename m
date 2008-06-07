Return-Path: <linux-kernel-owner+w=401wt.eu-S1760814AbYFGBLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760814AbYFGBLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760675AbYFGBIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:08:54 -0400
Received: from sous-sol.org ([216.99.217.87]:42301 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760630AbYFGBIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:08:51 -0400
Message-Id: <20080607010613.616541338@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:39 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jack Morgenstein <jackm@dev.mellanox.co.il>,
       Roland Dreier <rolandd@cisco.com>
Subject: [patch 24/50] IPoIB: Test for NULL broadcast object in ipiob_mcast_join_finish()
Content-Disposition: inline; filename=ipoib-test-for-null-broadcast-object-in-ipiob_mcast_join_finish.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jack Morgenstein <jackm@dev.mellanox.co.il>

upstream commit: e1d50dce5af77cb6d33555af70e2b8748dd84009

We saw a kernel oops in our regression testing when a multicast "join
finish" occurred just after the interface was -- this is
<https://bugs.openfabrics.org/show_bug.cgi?id=1040>.  The test
randomly causes the HCA physical port to go down then up.

The cause of this is that ipoib_mcast_join_finish() processing happen
just after ipoib_mcast_dev_flush() was invoked (in which case the
broadcast pointer is NULL).  This patch tests for and handles the case
where priv->broadcast is NULL.

Cc: <stable@kernel.org>
Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -194,7 +194,13 @@ static int ipoib_mcast_join_finish(struc
 	/* Set the cached Q_Key before we attach if it's the broadcast group */
 	if (!memcmp(mcast->mcmember.mgid.raw, priv->dev->broadcast + 4,
 		    sizeof (union ib_gid))) {
+		spin_lock_irq(&priv->lock);
+		if (!priv->broadcast) {
+			spin_unlock_irq(&priv->lock);
+			return -EAGAIN;
+		}
 		priv->qkey = be32_to_cpu(priv->broadcast->mcmember.qkey);
+		spin_unlock_irq(&priv->lock);
 		priv->tx_wr.wr.ud.remote_qkey = priv->qkey;
 	}
 

-- 
