Return-Path: <linux-kernel-owner+w=401wt.eu-S940088AbYCTARt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940088AbYCTARt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756317AbYCSXfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 19:35:24 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50604 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933547AbYCSXfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 19:35:19 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080319114844.GK10722@ZenIV.linux.org.uk> (message from Al Viro
	on Wed, 19 Mar 2008 11:48:44 +0000)
Subject: Re: [patch 3/6] vfs: mountinfo stable peer group id
References: <20080313212641.989467982@szeredi.hu> <20080313212735.741834181@szeredi.hu> <20080319114844.GK10722@ZenIV.linux.org.uk>
Message-Id: <E1Jc1Ln-0003jm-Bt@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 19 Mar 2008 17:41:15 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Add a stable identifier for shared mounts.
> 
> > +static DEFINE_SPINLOCK(mnt_pgid_lock);
> 
> Um?  Do you ever need to take it outside of vfsmount_lock?
> 

Tried to think this through:

It's always called with namespace_sem, which is enough, no need for a
new lock.  The bigger problem, is that it _is_ called with
vfsmount_lock in one case, which is bad, since the allocation may
sleep.

That is in do_change_type().  But do we really need to hold
vfsmount_lock in that case?  I think not, the propagation tree has no
relevance outside namespace_sem, so that one should be sufficient.

This patch should fix it (untested, just for review).

I have a half mind to throw out the IDR allocation altogether, and
just go with a 64bit counter, some poeple would much prefer that...

Thanks,
Miklos

---
 fs/namespace.c |    2 --
 fs/pnode.c     |   20 ++++++++------------
 2 files changed, 8 insertions(+), 14 deletions(-)

Index: linux/fs/pnode.c
===================================================================
--- linux.orig/fs/pnode.c	2008-03-19 16:39:28.000000000 +0100
+++ linux/fs/pnode.c	2008-03-19 17:26:44.000000000 +0100
@@ -12,7 +12,6 @@
 #include <linux/idr.h>
 #include "pnode.h"
 
-static DEFINE_SPINLOCK(mnt_pgid_lock);
 static DEFINE_IDA(mnt_pgid_ida);
 
 /* return the next shared peer mount of @p */
@@ -37,19 +36,19 @@ static void __set_mnt_shared(struct vfsm
 	mnt->mnt_flags |= MNT_SHARED;
 }
 
+/*
+ * - must hold namespace_sem to protect the mnt_pgid_ida
+ * - must not hold vfsmount_lock, because this function might sleep
+ */
 void set_mnt_shared(struct vfsmount *mnt)
 {
 	int res;
 
- retry:
-	spin_lock(&mnt_pgid_lock);
-	if (IS_MNT_SHARED(mnt)) {
-		spin_unlock(&mnt_pgid_lock);
+	might_sleep();
+	if (IS_MNT_SHARED(mnt))
 		return;
-	}
-
+ retry:
 	res = ida_get_new(&mnt_pgid_ida, &mnt->mnt_pgid);
-	spin_unlock(&mnt_pgid_lock);
 	if (res == -EAGAIN) {
 		if (ida_pre_get(&mnt_pgid_ida, GFP_KERNEL))
 			goto retry;
@@ -159,11 +158,8 @@ static int do_make_slave(struct vfsmount
 			peer_mnt = NULL;
 	}
 
-	if (IS_MNT_SHARED(mnt) && list_empty(&mnt->mnt_share)) {
-		spin_lock(&mnt_pgid_lock);
+	if (IS_MNT_SHARED(mnt) && list_empty(&mnt->mnt_share))
 		ida_remove(&mnt_pgid_ida, mnt->mnt_pgid);
-		spin_unlock(&mnt_pgid_lock);
-	}
 	list_del_init(&mnt->mnt_share);
 
 	if (peer_mnt)
Index: linux/fs/namespace.c
===================================================================
--- linux.orig/fs/namespace.c	2008-03-19 16:39:28.000000000 +0100
+++ linux/fs/namespace.c	2008-03-19 17:23:06.000000000 +0100
@@ -1351,10 +1351,8 @@ static noinline int do_change_type(struc
 		return -EINVAL;
 
 	down_write(&namespace_sem);
-	spin_lock(&vfsmount_lock);
 	for (m = mnt; m; m = (recurse ? next_mnt(m, mnt) : NULL))
 		change_mnt_propagation(m, type);
-	spin_unlock(&vfsmount_lock);
 	up_write(&namespace_sem);
 	return 0;
 }

