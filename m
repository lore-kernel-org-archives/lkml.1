Return-Path: <linux-kernel-owner+w=401wt.eu-S932789AbXBEOSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789AbXBEOSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:18:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932795AbXBEOSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:18:43 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932789AbXBEOSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:18:42 -0500
Subject: [GFS2] gfs2 knows of directories which it chooses not to display
	[21/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Robert Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:26:41 +0000
Message-Id: <1170685601.11001.313.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 318bb21324745d6cd3575c43d64513809568443f Mon Sep 17 00:00:00 2001
From: Robert Peterson <rpeterso@redhat.com>
Date: Thu, 11 Jan 2007 13:25:00 -0600
Subject: [PATCH] [GFS2] gfs2 knows of directories which it chooses not to display

This is for Red Hat bugzilla bug bz #222302:

Moving a virtual IP from node to node between two NFS-over-GFS2
servers was causing one of the GFS2 servers to become confused and
reference a deleted inode.  The problem was due to vfs dentries that did
not reference the gfs2_dops and therefore didn't call the gfs2 revalidate
code to revalidate a dentry after a directory had been deleted & recreated.
This patch is a crosswrite from a RHEL4 bug found in GFS1 as
bz #190756 and it is against the latest -nmw git tree.

Signed-off-by: Robert Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_export.c b/fs/gfs2/ops_export.c
index b4e7b87..6ea979c 100644
--- a/fs/gfs2/ops_export.c
+++ b/fs/gfs2/ops_export.c
@@ -22,6 +22,7 @@
 #include "glock.h"
 #include "glops.h"
 #include "inode.h"
+#include "ops_dentry.h"
 #include "ops_export.h"
 #include "rgrp.h"
 #include "util.h"
@@ -189,6 +190,7 @@ static struct dentry *gfs2_get_parent(struct dentry *child)
 		return ERR_PTR(-ENOMEM);
 	}
 
+	dentry->d_op = &gfs2_dops;
 	return dentry;
 }
 
@@ -269,6 +271,7 @@ out_inode:
 		return ERR_PTR(-ENOMEM);
 	}
 
+	dentry->d_op = &gfs2_dops;
 	return dentry;
 
 fail_rgd:
-- 
1.4.4.2



