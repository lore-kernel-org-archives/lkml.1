Return-Path: <linux-kernel-owner+w=401wt.eu-S1761939AbXEPE5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761939AbXEPE5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 00:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757332AbXEPE5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 00:57:05 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:34082 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288AbXEPE5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 00:57:02 -0400
Date: Wed, 16 May 2007 10:34:08 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH  7/14] Union-mount mounting
Message-ID: <20070516050408.GA4403@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070514093722.GB4139@in.ibm.com> <20070514094150.GI4139@in.ibm.com> <Pine.LNX.4.61.0705150921300.9570@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0705150921300.9570@yvahk01.tjqt.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2007 at 09:29:39AM +0200, Jan Engelhardt wrote:
> 
> On May 14 2007 15:11, Bharata B Rao wrote:
> >
> >TODO: bind and move mounts aren't yet supported with union mounts.
> 
> Are the semantics already set?

Not yet.

> 
> >@@ -294,6 +294,10 @@ static struct vfsmount *clone_mnt(struct
> > 	if (!mnt)
> > 		goto alloc_failed;
> > 
> >+	/*
> >+	 * As of now, cloning of union mounted mnt isn't permitted.
> >+	 */
> >+	BUG_ON(mnt->mnt_flags & MNT_UNION);
> 
> One, please avoid BUG_ONs. Now I am not sure if clone_mnt is called
> as part of kthread creation when CLONE_FS is it. If so, get rid of
> this one real fast. Also see chunk "@@ -1031,.. @@ do_loopback"
> below.

Looks like not CLONE_FS but CLONE_NEWNS ends up calling clone_mnt.

> 
> 	if(mnt->mnt_flags & MNT_UNION)
> 		goto return_einval;
> 
> or something.

Will do this for now, but eventually we need to get this working sanely anyway.

> 
> >+#ifdef CONFIG_UNION_MOUNT
> >+	struct union_info *uinfo = NULL;
> >+#endif
> > 
> > 	retval = security_sb_umount(mnt, flags);
> > 	if (retval)
> >@@ -685,6 +696,14 @@ static int do_umount(struct vfsmount *mn
> > 	}
> > 
> > 	down_write(&namespace_sem);
> >+#ifdef CONFIG_UNION_MOUNT
> >+	/*
> >+	 * Grab a reference to the union_info which gets detached
> >+	 * from the dentries in release_mounts().
> >+	 */
> >+	if (mnt->mnt_flags & MNT_UNION)
> >+		uinfo = union_lock_and_get(mnt->mnt_root);
> >+#endif
> > 	spin_lock(&vfsmount_lock);
> > 	event++;
> > 
> >@@ -699,6 +718,15 @@ static int do_umount(struct vfsmount *mn
> > 		security_sb_umount_busy(mnt);
> > 	up_write(&namespace_sem);
> > 	release_mounts(&umount_list);
> >+#ifdef CONFIG_UNION_MOUNT
> >+	if (uinfo) {
> >+		if (atomic_read(&uinfo->u_count) == 1)
> >+			/* We are the last user of this union_info */
> >+			union_release(uinfo);
> >+		else
> >+			union_put_and_unlock(uinfo);
> >+	}
> >+#endif
> > 	return retval;
> > }
> > 
> 
> Is it feasible to do with with some less #if/#endif magic?:
> 

Will try. We need union_info here which is available only with
CONFIG_UNION_MOUNT.

> >@@ -1031,6 +1070,15 @@ static int do_loopback(struct nameidata 
> > 	if (err)
> > 		return err;
> > 
> >+	/*
> >+	 * bind mounting to or from union mounts is not supported
> >+	 */
> >+	err = -EINVAL;
> >+	if (nd->mnt->mnt_flags & MNT_UNION)
> >+		goto out_unlocked;
> >+	if (old_nd.mnt->mnt_flags & MNT_UNION)
> >+		goto out_unlocked;
> >+
> 
> Do the same in clone_mnt.
> 
> > 	down_write(&namespace_sem);
> > 	err = -EINVAL;
> > 	if (IS_MNT_UNBINDABLE(old_nd.mnt))
> >@@ -1064,6 +1112,7 @@ static int do_loopback(struct nameidata 
> > 
> > out:
> > 	up_write(&namespace_sem);
> >+out_unlocked:
> > 	path_release(&old_nd);
> > 	return err;
> > }
> 
> >+++ b/include/linux/fs.h
> >@@ -1984,6 +1984,9 @@ static inline ino_t parent_ino(struct de
> > /* kernel/fork.c */
> > extern int unshare_files(void);
> > 
> >+/* fs/union.c */
> >+#include <linux/union.h>
> >+
> > /* Transaction based IO helpers */
> > 
> > /*
> 
> This raises a big eyebrow. If linux/fs.h can compile without the
> inclusion of linux/union.h, do not put linux/union.h in fs.h.
> 

Ok, better to include union.h in the appropriate .c file which needs it.

> >+#ifdef CONFIG_UNION_MOUNT
> >+
> >+#include <linux/fs_struct.h>
> >+
> >+/* namespace stuff used at mount time */
> >+extern void attach_mnt_union(struct vfsmount *, struct nameidata *);
> >+extern void detach_mnt_union(struct vfsmount *, struct path *);
> 
> You do not need that #include I suppose. Just predeclare the structs.
> 
> 	struct path;
> 	struct vfsmount;
> 	extern void ...
> 
> Saves us the "compiler slurps in so many .h files" problem.

Sure. And thanks for the review.

Regards,
Bharata.
