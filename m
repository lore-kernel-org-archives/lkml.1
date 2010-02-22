Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab0BVNaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 08:30:35 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:62195 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab0BVNad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 08:30:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=QrBRO8DAuvKv+tH12z2mIxjpUPVFGB6Zlm9P+ibPzG31RzCrv7kjAX7LW4YJZwRzmW
         Bf/aHMGZTFuEpDHgnq0KW7xijXpSTcy4sRCEy8K24iZ1GbgqDtGgJdBcqNmimQRjew+r
         5R/puDHBagPTWGNVXYA3FS25u/jX4FpKS1mJk=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] vfs: notify_changes() error handling
References: <1266608845-13212-1-git-send-email-dmonakhov@openvz.org>
	<20100222103516.GA5131@atrey.karlin.mff.cuni.cz>
	<20100222111510.GT9738@laptop>
Date: Mon, 22 Feb 2010 16:30:26 +0300
In-Reply-To: <20100222111510.GT9738@laptop> (Nick Piggin's message of "Mon, 22
	Feb 2010 22:15:10 +1100")
Message-ID: <87eikdo0st.fsf@openvz.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Nick Piggin <npiggin@suse.de> writes:

> On Mon, Feb 22, 2010 at 11:35:17AM +0100, Jan Kara wrote:
>>   Hi Dmitry,
>> 
>> > Current inode attr setting path looks like follows
>> > 
>> >  ret = inode_change_ok()
>> >  if(ret)
>> >      goto out;
>> >  /*
>> >   perform private-fs specific logic here
>> >   */
>> >  if(ia_valid & ATTR_UID || ...)
>> >     ret = vfs_dq_transfer()
>> > 
>> >  /*
>> >    more private-fs specific logic
>> >    for example update on_disk data structures.
>> >    */
>> > 
>> >   ret = inode_setattr()
>> > 
>> > In fact inode_setattr() call vmtruncate() which may fail in number
>> > of reasons IS_SWAPFILE, RLIMIT_FSIZE. After this many filesystem is
>> > unable to rollback changes. And just live inode in inconsistent
>> > state. We may check IS_SWAPFILE at the very beginning(currently it
>> > is not checked), but RLIMIT_FSIZE may changed under our feet.
>> > In order make things straight. Let's divide vmtruncate() in to
>> > two parts which perform all checks, and second which can not fail.
>> > After this notify_change() perform all necessary checks inside
>> > inode_change_ok() and simply call nofail version of vmtruncate().
>>   Actually, there are more problems than these in the truncate path.  Some
>> filesystems can decide to fail truncate only in their .truncate method but that
>> is called only after i_size is set which is too late.  Nick Piggin has a patch
>> set which was addressing this problem and should be basically a superset of
>> your changes. But I'm not sure whether the patch series is available somewhere
>> or what it's current status. Nick?
>
> I think Al is happy with it in principle, I changed it as he suggested.
> Maybe it was put on hold for other reasons. Anyway, here is the core
> patch again. It now is basically just adding more helpers, so it's not
> so intrusive.
>
> Al, what are your thoughts on merging? It doesn't appear to conflict
> with the -vfs tree.
>
> Dmitry, this doesn't solve your quota problem, but they obviously clash
> rather heavily. Do you see any problems with the way my patch goes?
In fact i dont tried to solve quota issue. I just want to understand
why error paths in my code becomes so huge and why they so differ
from existing code, now i do understand why :)
As soon as i understand this patch add changes only for core part.
And later other filesystems will handle the rest.
I am agree with it, vmtruncate is nightmare.
But imho also we have to solve generic inode attr check/set issue
fs_XXX_setattr()
{
...
   ret = inode_size_ok(inode, attr)
   if (ret)
        goto bad;
   if(private_fs_update_on_disk_data(new_size))
        goto bad;
   if(simple_setsize(inode,new_size)) {
     /* We still can get in to this because RLIMIT_FSIZE may be
      * changed after inode_size_ok();
      * So we have to roll back all fs-speciffic data which may be 
      * paintfull or impossible
      */
      ret = private_fs_update_on_disk_data(old_size)
      BUG_ON(ret)
    }
}
So my purpose is:
1) to move inode_size_ok check in to inode_change_ok()
2) Introduce simple_setsize_nocheck() which just do it's work
   after all checks was already done.
   And call simple_setsize_nocheck() inside fsXXX_setattr instead
   of simple_setsize().

Patch prepared agains yours "truncate: introduce new sequence"


--=-=-=
Content-Disposition: inline;
 filename=0001-vfs-inode_change_ok-have-to-perform-all-necessery-ch.patch

>From a876d30dd06dfa772ca2a2184416762843fc3708 Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Mon, 22 Feb 2010 16:15:57 +0300
Subject: [PATCH] vfs: inode_change_ok have to perform all necessery checks

Usually this is the only function which called before inode
attributes manipulation. In fact inode_change_ok performs only
posix checks. But it new_size check is also important. Otherwise
we mail fail in very late stage.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/attr.c          |   20 ++++++++++++++++++--
 fs/libfs.c         |   26 +++++++++++++++++++-------
 include/linux/fs.h |    5 +++--
 3 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index 1bca479..007c706 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -18,7 +18,7 @@
 /* Taken over from the old code... */
 
 /* POSIX UID/GID verification for setting inode attributes. */
-int inode_change_ok(const struct inode *inode, struct iattr *attr)
+int inode_change_posix_ok(const struct inode *inode, struct iattr *attr)
 {
 	int retval = -EPERM;
 	unsigned int ia_valid = attr->ia_valid;
@@ -60,7 +60,7 @@ fine:
 error:
 	return retval;
 }
-EXPORT_SYMBOL(inode_change_ok);
+EXPORT_SYMBOL(inode_change_posix_ok);
 
 /**
  * inode_newsize_ok - may this inode be truncated to a given size
@@ -105,6 +105,22 @@ out_big:
 }
 EXPORT_SYMBOL(inode_newsize_ok);
 
+/*
+ * General verification for setting inode attributes.
+ */
+int inode_change_ok(const struct inode *inode, struct iattr *attr)
+{
+	int ret;
+	ret = inode_change_posix_ok(inode, attr);
+	if (ret)
+		return ret;
+	if (attr->ia_valid & ATTR_SIZE)
+		ret = inode_newsize_ok(inode, attr->ia_size);
+	return ret;
+}
+EXPORT_SYMBOL(inode_change_ok);
+
+
 /**
  * generic_setattr - copy simple metadata updates into the generic inode
  * @inode:	the inode to be updated
diff --git a/fs/libfs.c b/fs/libfs.c
index 338575b..2aa89d7 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -329,6 +329,23 @@ int simple_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	return 0;
 }
+/**
+ * simple_setsize_nocheck - handle core mm and vfs requirements for file
+ * size change
+ * @inode: inode
+ * @newsize: new file size
+ * simple_setsize_nocheck must be called with inode_mutex held.
+ *
+ * Caller is responsible for all appropriate checks
+ */
+void simple_setsize_nocheck(struct inode *inode, loff_t newsize)
+{
+	loff_t oldsize;
+	oldsize = inode->i_size;
+	i_size_write(inode, newsize);
+	truncate_pagecache(inode, oldsize, newsize);
+}
+EXPORT_SYMBOL(simple_setsize_nocheck);
 
 /**
  * simple_setsize - handle core mm and vfs requirements for file size change
@@ -358,18 +375,13 @@ int simple_rename(struct inode *old_dir, struct dentry *old_dentry,
  */
 int simple_setsize(struct inode *inode, loff_t newsize)
 {
-	loff_t oldsize;
 	int error;
 
 	error = inode_newsize_ok(inode, newsize);
 	if (error)
 		return error;
-
-	oldsize = inode->i_size;
-	i_size_write(inode, newsize);
-	truncate_pagecache(inode, oldsize, newsize);
-
-	return error;
+	simple_setsize_nocheck(inode, newsize);
+	return 0;
 }
 EXPORT_SYMBOL(simple_setsize);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f5638e5..1097e28 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2361,6 +2361,7 @@ extern int simple_unlink(struct inode *, struct dentry *);
 extern int simple_rmdir(struct inode *, struct dentry *);
 extern int simple_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
 extern int simple_setsize(struct inode *inode, loff_t newsize);
+extern void simple_setsize_nocheck(struct inode *inode, loff_t newsize);
 extern int simple_sync_file(struct file *, struct dentry *, int);
 extern int simple_empty(struct dentry *);
 extern int simple_readpage(struct file *file, struct page *page);
@@ -2395,11 +2396,11 @@ extern int buffer_migrate_page(struct address_space *,
 #define buffer_migrate_page NULL
 #endif
 
-extern int inode_change_ok(const struct inode *, struct iattr *);
+extern int inode_change_posix_ok(const struct inode *, struct iattr *);
 extern int inode_newsize_ok(const struct inode *, loff_t offset);
+extern int inode_change_ok(const struct inode *, struct iattr *);
 extern int __must_check inode_setattr(struct inode *, const struct iattr *);
 extern void generic_setattr(struct inode *inode, const struct iattr *attr);
-
 extern void file_update_time(struct file *file);
 
 extern int generic_show_options(struct seq_file *m, struct vfsmount *mnt);
-- 
1.6.6


--=-=-=--
