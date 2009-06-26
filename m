Return-Path: <linux-kernel-owner+w=401wt.eu-S1755075AbZFZKxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbZFZKxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 06:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbZFZKxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 06:53:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:53099 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753621AbZFZKxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 06:53:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,296,1243839600"; 
   d="scan'208";a="528034825"
Subject: [PATCH 2.6.31-rc1] dm: fix exstore lookup error
From: Yi Yang <yi.y.yang@intel.com>
To: linux-kernel@vger.kernel.org
Cc: jbrassow@redhat.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Content-Type: text/plain
Date: Fri, 26 Jun 2009 18:51:23 +0800
Message-Id: <1246013483.3289.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Live image with 2.6.30 kernel created by livecd-tools can't boot because
of device mapper driver regression, error info is below:

device-mapper: snapshot exception stores: Module for exstore type "p" not found

commit f6bd4eb73cdf2a5bf954e497972842f39cabb7e3 claimed it fixed a regression,
but actually it introduced another error, 'p' in the above error message will
become 'P' followed by many strange characters.

The root cause is the variable persistent is of type char but it is used as char
*, so commit f6bd4eb73cdf2a5bf954e497972842f39cabb7e3 didn't fix the issue and
introduced one more issue.

This patch can fix this regression and the issue commit
f6bd4eb73cdf2a5bf954e497972842f39cabb7e3 introduced, please consider to apply,
thanks

Signed-off-by: Yi Yang <yi.y.yang@intel.com>
---

diff --git a/drivers/md/dm-exception-store.c b/drivers/md/dm-exception-store.c
index c3ae515..83c0854 100644
--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -197,7 +197,7 @@ int dm_exception_store_create(struct dm_target *ti, int argc, char **argv,
 	int r = 0;
 	struct dm_exception_store_type *type;
 	struct dm_exception_store *tmp_store;
-	char persistent;
+	char persistent[2];
 
 	if (argc < 3) {
 		ti->error = "Insufficient exception store arguments";
@@ -210,13 +210,14 @@ int dm_exception_store_create(struct dm_target *ti, int argc, char **argv,
 		return -ENOMEM;
 	}
 
-	persistent = toupper(*argv[1]);
-	if (persistent != 'P' && persistent != 'N') {
+	persistent[0] = toupper(*argv[1]);
+	if (persistent[0] != 'P' && persistent[0] != 'N') {
 		ti->error = "Persistent flag is not P or N";
 		return -EINVAL;
 	}
 
-	type = get_type(&persistent);
+	persistent[1] = '\0';
+	type = get_type(persistent);
 	if (!type) {
 		ti->error = "Exception store type not recognised";
 		r = -EINVAL;


