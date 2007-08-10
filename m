Return-Path: <linux-kernel-owner+w=401wt.eu-S938324AbXHJOoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938324AbXHJOoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 10:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763350AbXHJOno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 10:43:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:54771 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762469AbXHJOnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 10:43:43 -0400
Message-Id: <20070810143847.060182988@suse.de>
User-Agent: quilt/0.46-1
Date: Fri, 10 Aug 2007 16:22:11 +0200
From: Andreas Gruenbacher <agruen@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, John Johansen <jjohansen@suse.de>,
       Jan Blunck <jblunck@suse.de>, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [patch 3/4] Introduce pathget
References: <20070808171622.632749741@suse.de> <20070808171643.542685765@suse.de>
 <20070808193209.GA31354@infradead.org>
 <20070810142208.827949199@suse.de>
Content-Disposition: inline; filename=pathget.diff
Replace-Subject: Introduce pathget
Recipient-Cc: Jan Blunck <jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the symmetric operation to pathput.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

---
 fs/namei.c            |    9 +++------
 include/linux/namei.h |    8 --------
 2 files changed, 3 insertions(+), 14 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1003,14 +1003,12 @@ static int fastcall link_path_walk(const
 	int result;
 
 	/* make sure the stuff we saved doesn't go away */
-	dget(save.lookup.path.dentry);
-	mntget(save.lookup.path.mnt);
+	pathget(&save.lookup.path);
 
 	result = __link_path_walk(name, nd);
 	if (result == -ESTALE) {
 		*nd = save;
-		dget(nd->lookup.path.dentry);
-		mntget(nd->lookup.path.mnt);
+		pathget(&nd->lookup.path);
 		nd->lookup.flags |= LOOKUP_REVAL;
 		result = __link_path_walk(name, nd);
 	}
@@ -1140,8 +1138,7 @@ static int fastcall do_path_lookup(int d
 		if (retval)
 			goto fput_fail;
 
-		mntget(nd->lookup.path.mnt);
-		dget(nd->lookup.path.dentry);
+		pathget(&nd->lookup.path);
 
 		fput_light(file, fput_needed);
 	}
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -102,6 +102,14 @@ static inline char *nd_get_link(struct n
 	return nd->saved_names[nd->depth];
 }
 
+static inline struct path *pathget(struct path *path)
+{
+	mntget(path->mnt);
+	dget(path->dentry);
+
+	return path;
+}
+
 static inline void pathput(struct path *path)
 {
 	dput(path->dentry);

