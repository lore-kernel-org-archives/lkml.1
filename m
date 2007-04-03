Return-Path: <linux-kernel-owner+w=401wt.eu-S966117AbXDCT2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966117AbXDCT2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 15:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966116AbXDCT2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 15:28:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966105AbXDCT17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 15:27:59 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
To: Al Viro <viro@ftp.linux.org.uk>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       trond.myklebust@fys.uio.no, nfsv4@linux-nfs.org
Subject: [PATCH] Add a struct key pointer to struct nameidata
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Tue, 03 Apr 2007 20:26:57 +0100
Message-ID: <6742.1175628417@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Al,

I'd like you to consider approving something like the attached patch.  It
allows a key to be obtained by a filesystem during a pathwalk to be used in
subsequent operations in the pathwalk.

The way I envision it working is this:

 (1) The nameidata::key pointer is initialised to NULL at the start of the
     pathwalk.  path_release() and co. release the key it points to.

 (2) Any filesystem operation performed during the pathwalk (lookup,
     permission, follow_link) can look at the key - if non-NULL - and if it's
     what they're looking for they can use it.

     If there's a key there of potential interest, the key's type and
     description should be checked to make sure the key is permissible.

     If so, key_validate() should be called to make sure the key is still
     usable.  If it isn't, the error should be passed back rather than the key
     lookup being redone on the basis that some earlier step is now no longer
     valid.

 (3) Any operation that is not interested in the key can either ignore it or
     release it and clear the pointer.

 (4) If an operation wants to put its own key there, it would release the old
     key and then point the nameidata at its own key, with the usage count
     incremented.  This could be encapsulated in a function something like
     this:

	void set_nd_key(struct nameidata *nd, struct key *key)
	{
		key_put(nd->key);
		nd->key = key_get(key);
	}

Then a filesystem, such as AFS, could call request_key() just once and pass the
key on between lookup() and permission() calls, as long as the cell doesn't
change.  The alternative is to call request_key() each time.

Unfortunately there isn't currently a way to pass the key onto the inode
operations for create, link, unlink, and suchlike, nor is there a way to pass
it to the open file op without adding a struct key pointer argument to each of
these.

This might also be useful for NFS and CIFS.

David

diff --git a/fs/namei.c b/fs/namei.c
index ee60cc4..660d478 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -350,6 +350,7 @@ void path_release(struct nameidata *nd)
 {
 	dput(nd->dentry);
 	mntput(nd->mnt);
+	key_put(nd->key);
 }
 
 /*
@@ -360,6 +361,7 @@ void path_release_on_umount(struct nameidata *nd)
 {
 	dput(nd->dentry);
 	mntput_no_expire(nd->mnt);
+	key_put(nd->key);
 }
 
 /**
@@ -1108,6 +1110,7 @@ static int fastcall do_path_lookup(int dfd, const char *name,
 	struct file *file;
 	struct fs_struct *fs = current->fs;
 
+	nd->key = NULL;
 	nd->last_type = LAST_ROOT; /* if there are only slashes... */
 	nd->flags = flags;
 	nd->depth = 0;
diff --git a/fs/open.c b/fs/open.c
index c989fb4..740df56 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -822,10 +822,12 @@ struct file *nameidata_to_filp(struct nameidata *nd, int flags)
 	/* Pick up the filp from the open intent */
 	filp = nd->intent.open.file;
 	/* Has the filesystem initialised the file for us? */
-	if (filp->f_path.dentry == NULL)
+	if (filp->f_path.dentry == NULL) {
 		filp = __dentry_open(nd->dentry, nd->mnt, flags, filp, NULL);
-	else
+		key_put(nd->key);
+	} else {
 		path_release(nd);
+	}
 	return filp;
 }
 
diff --git a/include/linux/namei.h b/include/linux/namei.h
index d39a5a6..d677408 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -17,6 +17,7 @@ enum { MAX_NESTED_LINKS = 8 };
 struct nameidata {
 	struct dentry	*dentry;
 	struct vfsmount *mnt;
+	struct key	*key;
 	struct qstr	last;
 	unsigned int	flags;
 	int		last_type;
