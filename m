Return-Path: <linux-kernel-owner+w=401wt.eu-S935339AbXEUTry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935339AbXEUTry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933890AbXEUT2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:28:24 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52608 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933883AbXEUT2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:28:23 -0400
Message-Id: <20070521191751.108664000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:17:07 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, David Miller <davem@davemloft.net>,
       bunk@stusta.de
Subject: [patch 55/69] SPARC64: Fix recursion in PROM tree building.
Content-Disposition: inline; filename=sparc64-fix-recursion-in-prom-tree-building.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: David Miller <davem@davemloft.net>

Use iteration for scanning of PROM node siblings.

Based upon a patch by Greg Onufer, who found this bug.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 arch/sparc64/kernel/prom.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- linux-2.6.21.1.orig/arch/sparc64/kernel/prom.c
+++ linux-2.6.21.1/arch/sparc64/kernel/prom.c
@@ -1555,10 +1555,21 @@ static struct device_node * __init creat
 
 static struct device_node * __init build_tree(struct device_node *parent, phandle node, struct device_node ***nextp)
 {
+	struct device_node *ret = NULL, *prev_sibling = NULL;
 	struct device_node *dp;
 
-	dp = create_node(node, parent);
-	if (dp) {
+	while (1) {
+		dp = create_node(node, parent);
+		if (!dp)
+			break;
+
+		if (prev_sibling)
+			prev_sibling->sibling = dp;
+
+		if (!ret)
+			ret = dp;
+		prev_sibling = dp;
+
 		*(*nextp) = dp;
 		*nextp = &dp->allnext;
 
@@ -1567,10 +1578,10 @@ static struct device_node * __init build
 
 		dp->child = build_tree(dp, prom_getchild(node), nextp);
 
-		dp->sibling = build_tree(parent, prom_getsibling(node), nextp);
+		node = prom_getsibling(node);
 	}
 
-	return dp;
+	return ret;
 }
 
 void __init prom_build_devicetree(void)

-- 
