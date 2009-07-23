Return-Path: <linux-kernel-owner+w=401wt.eu-S1753103AbZGWOpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbZGWOpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 10:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbZGWOpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 10:45:44 -0400
Received: from adelie.canonical.com ([91.189.90.139]:45716 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbZGWOpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 10:45:44 -0400
Message-ID: <4A687796.80200@canonical.com>
Date: Thu, 23 Jul 2009 16:45:42 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
CC: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
       Andy Whitcroft <apw@canonical.com>, Christophe Dumez <dchris@gmail.com>
Subject: [PATCH] jfs: Fix early release of acl in jfs_get_acl
Content-Type: multipart/mixed;
 boundary="------------000906070704060503070504"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000906070704060503070504
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Commit 073aaa1b142461d91f83da66db1184d7c1b1edea "helpers for acl
caching + switch to those" introduced new helper functions for
acl handling but seems to have introduced a regression for jfs as the
acl is released before returning it to the caller, instead of
leaving this for the caller to do.
This causes the acl object to be used after freeing it, leading
to kernel panics in completely different places.

Thanks to Christophe Dumez for reporting and bisecting into this.

Reported-by: Christophe Dumez <dchris@gmail.com>
Tested-by: Christophe Dumez <dchris@gmail.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Acked-by: Andy Whitcroft <apw@canonical.com>
---
  fs/jfs/acl.c |    4 +---
  1 files changed, 1 insertions(+), 3 deletions(-)


--------------000906070704060503070504
Content-Type: text/x-diff;
 name="0001-jfs-Fix-early-release-of-acl-in-jfs_get_acl.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-jfs-Fix-early-release-of-acl-in-jfs_get_acl.patch"

>From a345a80ca7a926c9c6e322a1e8add4817c834d0f Mon Sep 17 00:00:00 2001
From: Stefan Bader <stefan.bader@canonical.com>
Date: Thu, 23 Jul 2009 11:26:05 +0200
Subject: [PATCH] jfs: Fix early release of acl in jfs_get_acl

BugLink: http://bugs.launchpad.net/ubuntu/+bug/396780

Commit 073aaa1b142461d91f83da66db1184d7c1b1edea "helpers for acl
caching + switch to those" introduced new helper functions for
acl handling but seems to have introduced a regression for jfs as
the acl is released before returning it to the caller, instead of
leaving this for the caller to do.
This causes the acl object to be used after freeing it, leading
to kernel panics in completely different places.

Thanks to Christophe Dumez for reporting and bisecting into this.

Reported-by: Christophe Dumez <dchris@gmail.com>
Tested-by: Christophe Dumez <dchris@gmail.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Acked-by: Andy Whitcroft <apw@canonical.com>
---
 fs/jfs/acl.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/jfs/acl.c b/fs/jfs/acl.c
index f272bf0..3c88d1b 100644
--- a/fs/jfs/acl.c
+++ b/fs/jfs/acl.c
@@ -67,10 +67,8 @@ static struct posix_acl *jfs_get_acl(struct inode *inode, int type)
 		acl = posix_acl_from_xattr(value, size);
 	}
 	kfree(value);
-	if (!IS_ERR(acl)) {
+	if (!IS_ERR(acl))
 		set_cached_acl(inode, type, acl);
-		posix_acl_release(acl);
-	}
 	return acl;
 }
 
-- 
1.5.4.3


--------------000906070704060503070504--
