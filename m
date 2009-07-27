Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbZG0SU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbZG0SU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 14:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbZG0SU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 14:20:58 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:33656 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbZG0SU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 14:20:57 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] driver core: simplify platform_get_resource()
Date: Mon, 27 Jul 2009 14:20:56 -0400
Message-Id: <1248718856-22287-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The platform_get_resource() function takes a number for the desired index
into the resource array, but then does a for loop on the array to get to
that index.  Considering the array is linear, the loop overhead is just
that -- overhead.  So unless I missed something, convert it into an index
check and access the desired resource directly.  Resulting code makes a
lot more sense considering its purpose.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/base/platform.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 81cb01b..dc8c943 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -37,14 +37,12 @@ EXPORT_SYMBOL_GPL(platform_bus);
 struct resource *platform_get_resource(struct platform_device *dev,
 				       unsigned int type, unsigned int num)
 {
-	int i;
-
-	for (i = 0; i < dev->num_resources; i++) {
-		struct resource *r = &dev->resource[i];
-
-		if (type == resource_type(r) && num-- == 0)
+	if (num >= 0 && num < dev->num_resources) {
+		struct resource *r = &dev->resource[num];
+		if (type == resource_type(r))
 			return r;
 	}
+
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(platform_get_resource);
-- 
1.6.3.3

