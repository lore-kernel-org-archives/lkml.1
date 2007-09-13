Return-Path: <linux-kernel-owner+w=401wt.eu-S1764704AbXIMEZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764704AbXIMEZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 00:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbXIMEZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 00:25:40 -0400
Received: from ozlabs.org ([203.10.76.45]:48888 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbXIMEZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 00:25:40 -0400
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>
Message-Id: <096fae99bd9797c5484ed8f4b87b82e58737cdc0.1189657514.git.michael@ellerman.id.au>
From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH] Allow sysfs_remove_group() to be called on non-added groups
Date: Thu, 13 Sep 2007 14:25:38 +1000 (EST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It would be nice to be able to do:

for_each_thing(thing) {
 	error = sysfs_create_group(&thing->kobj, attrs);
 	if (error) {
 		for_each_thing(thing)
 			sysfs_remove_group(&thing->kobj, attrs);
		return error;
	}
}

But there's a BUG_ON() in sysfs_remove_group() which hits if the attributes
were never added.

As discussed here ...
http://ozlabs.org/pipermail/cbe-oss-dev/2007-July/002774.html

.. we should just return in that case instead of BUG'ing.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 fs/sysfs/group.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index f318b73..a256775 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -73,7 +73,8 @@ void sysfs_remove_group(struct kobject * kobj,
 
 	if (grp->name) {
 		sd = sysfs_get_dirent(dir_sd, grp->name);
-		BUG_ON(!sd);
+		if (!sd)
+			return;
 	} else
 		sd = sysfs_get(dir_sd);
 
-- 
1.5.1.3.g7a33b

