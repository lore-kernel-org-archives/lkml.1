Return-Path: <linux-kernel-owner+w=401wt.eu-S932781AbXBEONM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781AbXBEONM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:13:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932785AbXBEONL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:13:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932749AbXBEONJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:13:09 -0500
Subject: [GFS2] BZ 217008 fsfuzzer fix [15/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Russell Cattelan <cattelan@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:21:12 +0000
Message-Id: <1170685272.11001.300.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8e0a86bd172405ea03feb6bc81adf6bcc389e8a5 Mon Sep 17 00:00:00 2001
From: Russell Cattelan <cattelan@redhat.com>
Date: Mon, 8 Jan 2007 17:47:51 -0600
Subject: [PATCH] [GFS2] BZ 217008 fsfuzzer fix.

Update the quilt header comments to match the
code changes.

Change gfs2_lookup_simple to return an error in the case
of a NULL inode.
The callers of gfs2_lookup_simple do not check for NULL
in the no entry case and such would end up dereferencing a NULL ptr.

This fixes:
http://projects.info-pull.com/mokb/MOKB-15-11-2006.html

Signed-off-by: Russell Cattelan <cattelan@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 6bc4436..bab338f 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -361,8 +361,18 @@ out:
 struct inode *gfs2_lookup_simple(struct inode *dip, const char *name)
 {
 	struct qstr qstr;
+	struct inode *inode;
 	gfs2_str2qstr(&qstr, name);
-	return gfs2_lookupi(dip, &qstr, 1, NULL);
+	inode = gfs2_lookupi(dip, &qstr, 1, NULL);
+	/* gfs2_lookupi has inconsistent callers: vfs
+	 * related routines expect NULL for no entry found,
+	 * gfs2_lookup_simple callers expect ENOENT
+	 * and do not check for NULL.
+	 */
+	if (inode == NULL)
+		return ERR_PTR(-ENOENT);
+	else
+		return inode;
 }
 
 
-- 
1.4.4.2



