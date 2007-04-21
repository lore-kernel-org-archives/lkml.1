Return-Path: <linux-kernel-owner+w=401wt.eu-S1753682AbXDUNSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbXDUNSL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 09:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbXDUNSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 09:18:11 -0400
Received: from as1.cineca.com ([130.186.84.251]:34245 "EHLO as1.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753682AbXDUNSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 09:18:09 -0400
Message-ID: <462A0F06.9020602@cineca.it>
From: Andrea Righi <a.righi@cineca.it>
Reply-To: a.righi@cineca.it
Organization: CINECA
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Vladimir V. Saveliev" <vs@namesys.com>, linux-kernel@vger.kernel.org,
       reiserfs-dev@namesys.com, Edward Shishkin <edward@namesys.com>,
       zam@clusterfs.com, ak@suse.de
Subject: Re: Fwd: Fw: [2.6.20.4] BUG: dentry xattrs still in use in shrink_dcache_for_umount()
 with reiserfs
References: <20070413095219.02075323.akpm@linux-foundation.org>	<462536B2.5060308@users.sourceforge.net>	<c04ebacf0704180152qdc72fcdnd0755dbf070b40d2@mail.gmail.com>	<200704181816.21166.vs@namesys.com>	<46263270.9010108@suse.com> <20070420170738.e269fcae.akpm@linux-foundation.org> <46296CB8.3090100@suse.com>
In-Reply-To: <46296CB8.3090100@suse.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Date: Sat, 21 Apr 2007 15:17:57 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Mahoney wrote:
> I have the patchset that I mentioned, but I'm not proposing it for 2.6.21.
> It's much too invasive to be introduced in an -rc7, but it does include
> locking changes that I believe avoid this bug.
> 
> Vladimir was right in his analysis that sometimes get_xa_root() takes the
> reference once and other times twice, but not for the right reasons.  I save
> a reference to the xattr dir to avoid a lookup later, but when there are multiple
> getxattrs or listxattrs as the first xattr operation on the file system, we can end
> up taking a second reference when we shouldn't. This is because those operations
> are protected by read locks and the ->xattr_root pointer isn't protected by anything
> else. A quick fix would be to just extend the protection of the priv root's i_mutex
> around the assignment, and test first. The right fix involves a complete rework of
> the locking, and I have code to do that, it's just too late to include it in 2.6.21.
> 
> I'd love to know what Andrea (and now Andi Kleen) are doing to hit this now. There
> haven't been any changes in this code in a while, and the shrink_dcache_for_umount()
> has been around since October. I'm unable to reproduce locally so far, so if Andrea
> or Andi could see if this fixes it for them, I'd appreciate it.

Jeff, your patch doesn't resolve, but you hit the problem. Actually, I
think the xattr_root pointer must be protected also in get_xa_root()
using the same private root i_mutex.

I've tested the following patch and it resolves in my case. What do you
think about it? could it be a reasonable fix?
 
Thanks!
-Andrea

--- linux/fs/reiserfs/xattr.c.orig	2007-04-14 18:53:02.000000000 +0200
+++ linux/fs/reiserfs/xattr.c	2007-04-21 14:16:02.000000000 +0200
@@ -72,14 +72,16 @@ static struct dentry *create_xa_root(str
 		err =
 		    privroot->d_inode->i_op->mkdir(privroot->d_inode, xaroot,
 						   0700);
-		mutex_unlock(&privroot->d_inode->i_mutex);
 
 		if (err) {
+			mutex_unlock(&privroot->d_inode->i_mutex);
 			dput(xaroot);
 			dput(privroot);
 			return ERR_PTR(err);
 		}
-		REISERFS_SB(sb)->xattr_root = dget(xaroot);
+		if (REISERFS_SB(sb)->xattr_root == NULL)
+			REISERFS_SB(sb)->xattr_root = dget(xaroot);
+		mutex_unlock(&privroot->d_inode->i_mutex);
 	}
 
       out:
@@ -122,12 +124,26 @@ static struct dentry *__get_xa_root(stru
  */
 static inline struct dentry *get_xa_root(struct super_block *s)
 {
-	struct dentry *dentry = dget(REISERFS_SB(s)->xattr_root);
+	struct dentry *privroot = dget(REISERFS_SB(s)->priv_root);
+	struct dentry *xaroot = NULL;
+
+	if (!privroot)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	if (!privroot->d_inode)
+		goto out;
+
+	mutex_lock(&privroot->d_inode->i_mutex);
+
+	xaroot = (REISERFS_SB(s)->xattr_root) ?
+			dget(REISERFS_SB(s)->xattr_root) :
+			__get_xa_root(s);
 
-	if (!dentry)
-		dentry = __get_xa_root(s);
+	mutex_unlock(&privroot->d_inode->i_mutex);
 
-	return dentry;
+      out:
+	dput(privroot);
+	return xaroot;
 }
 
 /* Opens the directory corresponding to the inode's extended attribute store.
