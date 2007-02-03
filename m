Return-Path: <linux-kernel-owner+w=401wt.eu-S1946290AbXBCCn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946290AbXBCCn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:43:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946285AbXBCCnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:43:43 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53543 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946280AbXBCCn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:43:28 -0500
Message-Id: <20070203024533.636518000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:51 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Miller <davem@davemloft.net>, bunk@stusta.de,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Steven Whitehouse <steve@chygwyn.com>
Subject: [patch 47/59] DECNET: Handle a failure in neigh_parms_alloc (take 2)
Content-Disposition: inline; filename=decnet-handle-a-failure-in-neigh_parms_alloc.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Eric W. Biederman <ebiederm@xmission.com>

While enhancing the neighbour code to handle multiple network
namespaces I noticed that decnet is assuming neigh_parms_alloc
will allways succeed, which is clearly wrong.  So handle the
failure.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Steven Whitehouse <steve@chygwyn.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/decnet/dn_dev.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- linux-2.6.19.2.orig/net/decnet/dn_dev.c
+++ linux-2.6.19.2/net/decnet/dn_dev.c
@@ -1116,16 +1116,23 @@ struct dn_dev *dn_dev_create(struct net_
 	init_timer(&dn_db->timer);
 
 	dn_db->uptime = jiffies;
+
+	dn_db->neigh_parms = neigh_parms_alloc(dev, &dn_neigh_table);
+	if (!dn_db->neigh_parms) {
+		dev->dn_ptr = NULL;
+		kfree(dn_db);
+		return NULL;
+	}
+
 	if (dn_db->parms.up) {
 		if (dn_db->parms.up(dev) < 0) {
+			neigh_parms_release(&dn_neigh_table, dn_db->neigh_parms);
 			dev->dn_ptr = NULL;
 			kfree(dn_db);
 			return NULL;
 		}
 	}
 
-	dn_db->neigh_parms = neigh_parms_alloc(dev, &dn_neigh_table);
-
 	dn_dev_sysctl_register(dev, &dn_db->parms);
 
 	dn_dev_set_timer(dev);

--
