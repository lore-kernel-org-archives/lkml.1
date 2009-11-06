Return-Path: <linux-kernel-owner+w=401wt.eu-S1760032AbZKFWHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032AbZKFWHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:07:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbZKFWHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:07:30 -0500
Received: from kroah.org ([198.145.64.141]:39813 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758792AbZKFWGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:06:02 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 13:59:53 2009
Message-Id: <20091106215953.252395742@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 13:56:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [25/30] NFSv4: Fix a problem whereby a buggy server can oops the kernel
References: <20091106215603.413650799@mini.kroah.org>
Content-Disposition: inline; filename=nfsv4-fix-a-problem-whereby-a-buggy-server-can-oops-the-kernel.patch
In-Reply-To: <20091106220156.GA13813@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit d953126a28f97ec965d23c69fd5795854c048f30 upstream.

We just had a case in which a buggy server occasionally returns the wrong
attributes during an OPEN call. While the client does catch this sort of
condition in nfs4_open_done(), and causes the nfs4_atomic_open() to return
-EISDIR, the logic in nfs_atomic_lookup() is broken, since it causes a
fallback to an ordinary lookup instead of just returning the error.

When the buggy server then returns a regular file for the fallback lookup,
the VFS allows the open, and bad things start to happen, since the open
file doesn't have any associated NFSv4 state.

The fix is firstly to return the EISDIR/ENOTDIR errors immediately, and
secondly to ensure that we are always careful when dereferencing the
nfs_open_context state pointer.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1025,12 +1025,12 @@ static struct dentry *nfs_atomic_lookup(struct inode *dir, struct dentry *dentry
 				res = NULL;
 				goto out;
 			/* This turned out not to be a regular file */
-			case -EISDIR:
 			case -ENOTDIR:
 				goto no_open;
 			case -ELOOP:
 				if (!(nd->intent.open.flags & O_NOFOLLOW))
 					goto no_open;
+			/* case -EISDIR: */
 			/* case -EINVAL: */
 			default:
 				goto out;
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index df24f67..6917311 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4093,15 +4093,23 @@ nfs4_proc_lock(struct file *filp, int cmd, struct file_lock *request)
 	if (request->fl_start < 0 || request->fl_end < 0)
 		return -EINVAL;
 
-	if (IS_GETLK(cmd))
-		return nfs4_proc_getlk(state, F_GETLK, request);
+	if (IS_GETLK(cmd)) {
+		if (state != NULL)
+			return nfs4_proc_getlk(state, F_GETLK, request);
+		return 0;
+	}
 
 	if (!(IS_SETLK(cmd) || IS_SETLKW(cmd)))
 		return -EINVAL;
 
-	if (request->fl_type == F_UNLCK)
-		return nfs4_proc_unlck(state, cmd, request);
+	if (request->fl_type == F_UNLCK) {
+		if (state != NULL)
+			return nfs4_proc_unlck(state, cmd, request);
+		return 0;
+	}
 
+	if (state == NULL)
+		return -ENOLCK;
 	do {
 		status = nfs4_proc_setlk(state, cmd, request);
 		if ((status != -EAGAIN) || IS_SETLK(cmd))


