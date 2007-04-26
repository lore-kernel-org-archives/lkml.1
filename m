Return-Path: <linux-kernel-owner+w=401wt.eu-S1031238AbXDZOuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031238AbXDZOuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 10:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031233AbXDZOuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 10:50:54 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:39226 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031238AbXDZOux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 10:50:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=JfhmxGMOImKb8uW4uJlmsOS4VQcRuOARG4emrXdA7FzpMDIavpMo/NFIUSpBHvQQu7lcWdkUfYcgxizr53uCmh+JKMW0/kHKqJI7pue8BG168qkLoG2/929IA4bEjZ3OCnejAaO0N/juhT8qGWmkFAALBbobFii+lKQ8oOsW83I=
Date: Thu, 26 Apr 2007 23:50:47 +0900
From: Tejun Heo <htejun@gmail.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       greg@kroah.com
Subject: [PATCH] sysfs: use different lockdep subclass for s_active deactivation
Message-ID: <20070426145047.GF17130@htj.dyndns.org>
References: <a44ae5cd0704242215w1b474c52r7860f0d49bc64d6c@mail.gmail.com> <462EE4B7.6000708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462EE4B7.6000708@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A sysfs node can delete other sysfs files when accessed.  This results
in recursive s_active locking - read lock for file access, down lock
of the vicitim for deactivation.  Tell lockdep that it's okay.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
Miles, please test this patch.  It should remove the lockdep warning.
Fixes for the other two problems will soon follow.

Greg, Andrew, after all the fixes are verified, I'll merge the fixes
into the original patches and resend all the sysfs updates in better
shape.  Sorry about all the trouble.

Thanks.

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 8f7b65e..4a418bd 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -60,7 +60,8 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
 	 * previous lie.
 	 */
 	if (!down_write_trylock(&sd->s_active))
-		rwsem_acquire(&sd->s_active.dep_map, 0, 0, _RET_IP_);
+		rwsem_acquire(&sd->s_active.dep_map,
+			      SYSFS_S_ACTIVE_DEACTIVATE, 0, _RET_IP_);
 	up_write(&sd->s_active);
 
 	sysfs_free_ino(sd->s_ino);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 4ed6f77..add2725 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -41,6 +41,17 @@ struct sysfs_dirent {
 	atomic_t		s_event;
 };
 
+/*
+ * A sysfs file which deletes another file when written to need to
+ * write lock the s_active of the victim while its s_active is read
+ * locked for the write operation.  Tell lockdep that this is okay.
+ */
+enum sysfs_s_active_class
+{
+	SYSFS_S_ACTIVE_NORMAL,		/* file r/w access, etc - default */
+	SYSFS_S_ACTIVE_DEACTIVATE,	/* file deactivation */
+};
+
 extern struct vfsmount * sysfs_mount;
 extern struct kmem_cache *sysfs_dir_cachep;
 
@@ -172,7 +183,7 @@ static inline void sysfs_put_active_two(struct sysfs_dirent *sd)
  */
 static inline void sysfs_deactivate(struct sysfs_dirent *sd)
 {
-	down_write(&sd->s_active);
+	down_write_nested(&sd->s_active, SYSFS_S_ACTIVE_DEACTIVATE);
 
 	/* s_active will be unlocked by the thread doing the final put
 	 * on @sd.  Lie to lockdep.
