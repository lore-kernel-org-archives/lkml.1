Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab0BXAMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 19:12:24 -0500
Received: from adelie.canonical.com ([91.189.90.139]:42570 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab0BXAMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 19:12:21 -0500
From: john.johansen@canonical.com
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel-owner@vger.kernel.org,
       John Johansen <john.johansen@canonical.com>
Subject: [PATCH] Fix __d_path for lazy unmounts
Date: Tue, 23 Feb 2010 16:12:09 -0800
Message-Id: <1266970329-28068-2-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <20100223010413.GA31046@us.ibm.com>
References: <20100223010413.GA31046@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Johansen <john.johansen@canonical.com>

When __d_path() hits a lazily unmounted mount point, it tries to prepend
the name of the lazily unmounted dentry to the path name.  It gets this wrong,
and also overwrites the slash that separates the name from the following
pathname component. This patch fixes that; if a process was in directory
/foo/bar and /foo got lazily unmounted, the old result was ``foobar'' (note the
missing slash), while the new result with this patch is ``/foo/bar''.

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 fs/dcache.c |   27 +++++++++++++++++++++++----
 1 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 953173a..46096b4 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1922,11 +1922,9 @@ char *__d_path(const struct path *path, struct path *root,
 	retval = end-1;
 	*retval = '/';
 
-	for (;;) {
+	while (dentry != root->dentry || vfsmnt != root->mnt) {
 		struct dentry * parent;
 
-		if (dentry == root->dentry && vfsmnt == root->mnt)
-			break;
 		if (dentry == vfsmnt->mnt_root || IS_ROOT(dentry)) {
 			/* Global root? */
 			if (vfsmnt->mnt_parent == vfsmnt) {
@@ -1950,9 +1948,30 @@ out:
 	return retval;
 
 global_root:
-	retval += 1;	/* hit the slash */
+	/*
+	 * We went past the (vfsmount, dentry) we were looking for and have
+	 * either hit a root dentry, a lazily unmounted dentry, an
+	 * unconnected dentry, or the file is on a pseudo filesystem.
+	 */
+	if ((dentry->d_sb->s_flags & MS_NOUSER) ||
+	    (dentry->d_name.len == 1 && *dentry->d_name.name == '/')) {
+		/*
+		 * Historically, we also glue together the root dentry and
+		 * remaining name for pseudo filesystems like pipefs, which
+		 * have the MS_NOUSER flag set. This results in pathnames
+		 * like "pipe:[439336]".
+		 */
+		retval += 1;	/* overwrite the slash */
+		buflen++;
+	}
 	if (prepend_name(&retval, &buflen, &dentry->d_name) != 0)
 		goto Elong;
+
+	/* connect lazily unmounted mount point */
+	if (*retval != '/' && !(dentry->d_sb->s_flags & MS_NOUSER) &&
+	    prepend(&retval, &buflen, "/", 1) != 0)
+		goto Elong;
+
 	root->mnt = vfsmnt;
 	root->dentry = dentry;
 	goto out;
-- 
1.6.6.1

