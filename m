Return-Path: <linux-kernel-owner+w=401wt.eu-S1762104AbYEEUgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762104AbYEEUgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbYEEUgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:36:00 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44783 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbYEEUf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:35:58 -0400
To: trond.myklebust@fys.uio.no
CC: miklos@szeredi.hu, viro@ZenIV.linux.org.uk, weigelt@metux.de,
       linux-kernel@vger.kernel.org
In-reply-to: <1210018599.7448.1.camel@localhost> (message from Trond Myklebust
	on Mon, 05 May 2008 16:16:39 -0400)
Subject: Re: VFS + path walktrough
References: <20080505124041.GB32019@nibiru.local>
	 <20080505130623.GC32019@nibiru.local>
	 <20080505131307.GM5882@ZenIV.linux.org.uk>
	 <20080505134315.GF32019@nibiru.local>
	 <20080505153501.GN5882@ZenIV.linux.org.uk>
	 <E1Jt3nB-0006ZP-6S@pomaz-ex.szeredi.hu>
	 <20080505171425.GO5882@ZenIV.linux.org.uk>
	 <E1Jt4Ye-0006hz-9i@pomaz-ex.szeredi.hu>
	 <20080505174048.GP5882@ZenIV.linux.org.uk>
	 <E1Jt526-0006le-04@pomaz-ex.szeredi.hu>
	 <E1Jt5Td-0006rG-3E@pomaz-ex.szeredi.hu> <1210018599.7448.1.camel@localhost>
Message-Id: <E1Jt7PY-0007IR-Uq@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 05 May 2008 22:35:48 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 2008-05-05 at 20:31 +0200, Miklos Szeredi wrote:
> > > > > >  Take a look at 9P walk - it does *not* give
> > > > > > you anything resembling stat, you just get qids of intermediates.
> > > > > 
> > > > > Which is exactly what's needed to populate the dentry tree, no?
> > > > 
> > > > No - you need inodes as well (i.e. as the absolute least you want
> > > > mode and ownership).  Which is to say, you need to issue stat on
> > > > each component in such situation anyway.  Not a win...
> > 
> > And actually even that *could* be a win, if the network latency is
> > large.  Because by doing the lookup first, the stats can be performed
> > in parallel.  So a path with an arbitrary number of components could
> > be resolved in just 2 RTTs.
> 
> ...and NFSv4 could do it in a single RPC call (assuming no symlinks or
> submounts).

And just to show how utterly trivially this could be done, here's a
patch (totally untested).

Hack?  Hell, yes.

Miklos

---
 fs/namei.c         |   20 ++++++++++++--------
 include/linux/fs.h |    1 +
 2 files changed, 13 insertions(+), 8 deletions(-)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-05-05 12:03:24.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-05-05 22:25:52.000000000 +0200
@@ -519,14 +519,18 @@ static struct dentry * real_lookup(struc
 	 */
 	result = d_lookup(parent, name);
 	if (!result) {
-		struct dentry * dentry = d_alloc(parent, name);
-		result = ERR_PTR(-ENOMEM);
-		if (dentry) {
-			result = dir->i_op->lookup(dir, dentry, nd);
-			if (result)
-				dput(dentry);
-			else
-				result = dentry;
+		if (dir->i_op->lookup_path) {
+			result = dir->i_op->lookup_path(dir, name);
+		} else  {
+			struct dentry * dentry = d_alloc(parent, name);
+			result = ERR_PTR(-ENOMEM);
+			if (dentry) {
+				result = dir->i_op->lookup(dir, dentry, nd);
+				if (result)
+					dput(dentry);
+				else
+					result = dentry;
+			}
 		}
 		mutex_unlock(&dir->i_mutex);
 		return result;
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-05-05 12:03:24.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2008-05-05 22:26:59.000000000 +0200
@@ -1251,6 +1251,7 @@ struct file_operations {
 struct inode_operations {
 	int (*create) (struct inode *,struct dentry *,int, struct nameidata *);
 	struct dentry * (*lookup) (struct inode *,struct dentry *, struct nameidata *);
+	struct dentry * (*lookup_path) (struct inode *, struct qstr *);
 	int (*link) (struct dentry *,struct inode *,struct dentry *);
 	int (*unlink) (struct inode *,struct dentry *);
 	int (*symlink) (struct inode *,struct dentry *,const char *);





