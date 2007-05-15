Return-Path: <linux-kernel-owner+w=401wt.eu-S1760944AbXEOHbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760944AbXEOHbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 03:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494AbXEOHbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 03:31:18 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:48791 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbXEOHbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 03:31:16 -0400
Date: Tue, 15 May 2007 09:29:39 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH  7/14] Union-mount mounting
In-Reply-To: <20070514094150.GI4139@in.ibm.com>
Message-ID: <Pine.LNX.4.61.0705150921300.9570@yvahk01.tjqt.qr>
References: <20070514093722.GB4139@in.ibm.com> <20070514094150.GI4139@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 14 2007 15:11, Bharata B Rao wrote:
>
>TODO: bind and move mounts aren't yet supported with union mounts.

Are the semantics already set?

>@@ -294,6 +294,10 @@ static struct vfsmount *clone_mnt(struct
> 	if (!mnt)
> 		goto alloc_failed;
> 
>+	/*
>+	 * As of now, cloning of union mounted mnt isn't permitted.
>+	 */
>+	BUG_ON(mnt->mnt_flags & MNT_UNION);

One, please avoid BUG_ONs. Now I am not sure if clone_mnt is called
as part of kthread creation when CLONE_FS is it. If so, get rid of
this one real fast. Also see chunk "@@ -1031,.. @@ do_loopback"
below.

	if(mnt->mnt_flags & MNT_UNION)
		goto return_einval;

or something.

>+#ifdef CONFIG_UNION_MOUNT
>+	struct union_info *uinfo = NULL;
>+#endif
> 
> 	retval = security_sb_umount(mnt, flags);
> 	if (retval)
>@@ -685,6 +696,14 @@ static int do_umount(struct vfsmount *mn
> 	}
> 
> 	down_write(&namespace_sem);
>+#ifdef CONFIG_UNION_MOUNT
>+	/*
>+	 * Grab a reference to the union_info which gets detached
>+	 * from the dentries in release_mounts().
>+	 */
>+	if (mnt->mnt_flags & MNT_UNION)
>+		uinfo = union_lock_and_get(mnt->mnt_root);
>+#endif
> 	spin_lock(&vfsmount_lock);
> 	event++;
> 
>@@ -699,6 +718,15 @@ static int do_umount(struct vfsmount *mn
> 		security_sb_umount_busy(mnt);
> 	up_write(&namespace_sem);
> 	release_mounts(&umount_list);
>+#ifdef CONFIG_UNION_MOUNT
>+	if (uinfo) {
>+		if (atomic_read(&uinfo->u_count) == 1)
>+			/* We are the last user of this union_info */
>+			union_release(uinfo);
>+		else
>+			union_put_and_unlock(uinfo);
>+	}
>+#endif
> 	return retval;
> }
> 

Is it feasible to do with with some less #if/#endif magic?:

>@@ -1031,6 +1070,15 @@ static int do_loopback(struct nameidata 
> 	if (err)
> 		return err;
> 
>+	/*
>+	 * bind mounting to or from union mounts is not supported
>+	 */
>+	err = -EINVAL;
>+	if (nd->mnt->mnt_flags & MNT_UNION)
>+		goto out_unlocked;
>+	if (old_nd.mnt->mnt_flags & MNT_UNION)
>+		goto out_unlocked;
>+

Do the same in clone_mnt.

> 	down_write(&namespace_sem);
> 	err = -EINVAL;
> 	if (IS_MNT_UNBINDABLE(old_nd.mnt))
>@@ -1064,6 +1112,7 @@ static int do_loopback(struct nameidata 
> 
> out:
> 	up_write(&namespace_sem);
>+out_unlocked:
> 	path_release(&old_nd);
> 	return err;
> }

>+++ b/include/linux/fs.h
>@@ -1984,6 +1984,9 @@ static inline ino_t parent_ino(struct de
> /* kernel/fork.c */
> extern int unshare_files(void);
> 
>+/* fs/union.c */
>+#include <linux/union.h>
>+
> /* Transaction based IO helpers */
> 
> /*

This raises a big eyebrow. If linux/fs.h can compile without the
inclusion of linux/union.h, do not put linux/union.h in fs.h.

>+#ifdef CONFIG_UNION_MOUNT
>+
>+#include <linux/fs_struct.h>
>+
>+/* namespace stuff used at mount time */
>+extern void attach_mnt_union(struct vfsmount *, struct nameidata *);
>+extern void detach_mnt_union(struct vfsmount *, struct path *);

You do not need that #include I suppose. Just predeclare the structs.

	struct path;
	struct vfsmount;
	extern void ...

Saves us the "compiler slurps in so many .h files" problem.


	Jan
-- 
