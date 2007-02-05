Return-Path: <linux-kernel-owner+w=401wt.eu-S932697AbXBEOMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697AbXBEOMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932755AbXBEOMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:12:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932740AbXBEOMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:12:23 -0500
Subject: [GFS2] Fix ordering of page disposal vs. glock_dq [14/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:20:27 +0000
Message-Id: <1170685227.11001.298.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From cb0d445259232c2ec717de827338e31650b7b07b Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Mon, 8 Jan 2007 14:31:40 +0000
Subject: [PATCH] [GFS2] Fix ordering of page disposal vs. glock_dq

In case of unlinked files with dirty pages GFS2 wasn't clearing
the pages in quite the right order. This patch clears the pages
earlier (before the qlock_dq) to avoid the situation that the
release of the glock results in attempting to write back data that
has already been deallocated.

This fixes Red Hat bugzilla: #220117

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_super.c b/fs/gfs2/ops_super.c
index b283783..c22738c 100644
--- a/fs/gfs2/ops_super.c
+++ b/fs/gfs2/ops_super.c
@@ -429,6 +429,12 @@ static void gfs2_delete_inode(struct inode *inode)
 	}
 
 	error = gfs2_dinode_dealloc(ip);
+	/*
+	 * Must do this before unlock to avoid trying to write back
+	 * potentially dirty data now that inode no longer exists
+	 * on disk.
+	 */
+	truncate_inode_pages(&inode->i_data, 0);
 
 out_unlock:
 	gfs2_glock_dq(&ip->i_iopen_gh);
-- 
1.4.4.2



