Return-Path: <linux-kernel-owner+w=401wt.eu-S1946291AbXBCCwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946291AbXBCCwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946257AbXBCChQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:37:16 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52848 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946255AbXBCChM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:37:12 -0500
Message-Id: <20070203024034.933283000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:23 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Patrick McHardy <kaber@trash.net>, netfilter-devel@lists.netfilter.org,
       davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [patch 19/59] NETFILTER: ctnetlink: check for status attribute existence on conntrack creation
Content-Disposition: inline; filename=ctnetlink-check-for-status-attribute-existence-on-conntrack-creation.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

Check that status flags are available in the netlink message received
to create a new conntrack.

Fixes a crash in ctnetlink_create_conntrack when the CTA_STATUS attribute
is not present.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 net/ipv4/netfilter/ip_conntrack_netlink.c |    8 +++++---
 net/netfilter/nf_conntrack_netlink.c      |    8 +++++---
 2 files changed, 10 insertions(+), 6 deletions(-)

--- linux-2.6.19.2.orig/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ linux-2.6.19.2/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -946,9 +946,11 @@ ctnetlink_create_conntrack(struct nfattr
 	ct->timeout.expires = jiffies + ct->timeout.expires * HZ;
 	ct->status |= IPS_CONFIRMED;
 
-	err = ctnetlink_change_status(ct, cda);
-	if (err < 0)
-		goto err;
+	if (cda[CTA_STATUS-1]) {
+		err = ctnetlink_change_status(ct, cda);
+		if (err < 0)
+			goto err;
+	}
 
 	if (cda[CTA_PROTOINFO-1]) {
 		err = ctnetlink_change_protoinfo(ct, cda);
--- linux-2.6.19.2.orig/net/netfilter/nf_conntrack_netlink.c
+++ linux-2.6.19.2/net/netfilter/nf_conntrack_netlink.c
@@ -963,9 +963,11 @@ ctnetlink_create_conntrack(struct nfattr
 	ct->timeout.expires = jiffies + ct->timeout.expires * HZ;
 	ct->status |= IPS_CONFIRMED;
 
-	err = ctnetlink_change_status(ct, cda);
-	if (err < 0)
-		goto err;
+	if (cda[CTA_STATUS-1]) {
+		err = ctnetlink_change_status(ct, cda);
+		if (err < 0)
+			goto err;
+	}
 
 	if (cda[CTA_PROTOINFO-1]) {
 		err = ctnetlink_change_protoinfo(ct, cda);

--
