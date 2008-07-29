Return-Path: <linux-kernel-owner+w=401wt.eu-S1759061AbYG2Vyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759061AbYG2Vyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 17:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbYG2Vyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 17:54:43 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:23821 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbYG2Vym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 17:54:42 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] resources: tidy __request_region()
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org
Date: Tue, 29 Jul 2008 15:54:24 -0600
Message-ID: <20080729215403.27539.55909.stgit@tigger.helgaas>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No functional change.  Just return NULL for kzalloc failure immediately,
rather than wrapping the whole function body in the body of an "if".

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 kernel/resource.c |   41 +++++++++++++++++++++--------------------
 1 files changed, 21 insertions(+), 20 deletions(-)


diff --git a/kernel/resource.c b/kernel/resource.c
index 74af2d7..61f60b1 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -524,33 +524,34 @@ struct resource * __request_region(struct resource *parent,
 {
 	struct resource *res = kzalloc(sizeof(*res), GFP_KERNEL);
 
-	if (res) {
-		res->name = name;
-		res->start = start;
-		res->end = start + n - 1;
-		res->flags = IORESOURCE_BUSY;
+	if (!res)
+		return NULL;
 
-		write_lock(&resource_lock);
+	res->name = name;
+	res->start = start;
+	res->end = start + n - 1;
+	res->flags = IORESOURCE_BUSY;
 
-		for (;;) {
-			struct resource *conflict;
+	write_lock(&resource_lock);
 
-			conflict = __request_resource(parent, res);
-			if (!conflict)
-				break;
-			if (conflict != parent) {
-				parent = conflict;
-				if (!(conflict->flags & IORESOURCE_BUSY))
-					continue;
-			}
+	for (;;) {
+		struct resource *conflict;
 
-			/* Uhhuh, that didn't work out.. */
-			kfree(res);
-			res = NULL;
+		conflict = __request_resource(parent, res);
+		if (!conflict)
 			break;
+		if (conflict != parent) {
+			parent = conflict;
+			if (!(conflict->flags & IORESOURCE_BUSY))
+				continue;
 		}
-		write_unlock(&resource_lock);
+
+		/* Uhhuh, that didn't work out.. */
+		kfree(res);
+		res = NULL;
+		break;
 	}
+	write_unlock(&resource_lock);
 	return res;
 }
 EXPORT_SYMBOL(__request_region);

