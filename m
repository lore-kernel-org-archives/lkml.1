Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab0BJBJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 20:09:42 -0500
Received: from cantor.suse.de ([195.135.220.2]:41148 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948Ab0BJBJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 20:09:41 -0500
From: Neil Brown <neilb@suse.de>
To: Eric W "." Biederman <ebiederm@xmission.com>
Date: Wed, 10 Feb 2010 12:09:33 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19314.1869.847327.15190@notabene.brown>
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sysfs: differentiate  between locking links and non-links
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,
 I've just spent a while sorting out some lockdep complaints triggered
 by the recent addition of the "s_active" lockdep annotation in sysfs
  (commit 846f99749ab68bbc7f75c74fec305de675b1a1bf)

 Some of them are genuine and I have submitted a fix for those.
 Some are, I think, debatable and I get to that is a minute.  I've
 submitted a fix for them anyway.
 But some are to my mind clearly bogus and I'm hoping that can be
 fixed by the change below (or similar).
 The 'bogus' ones are triggered by writing to a sysfs attribute file
 for which the handler tries to delete a symlink from sysfs.
 This appears to be a recursion on s_active as s_active is held while
 the handler runs and is again needed to effect the delete.  However
 as the thing being deleted is a symlink, it is very clearly a
 different object to the thing triggering the delete, so there is no
 real loop.

 The following patch splits the lockdep context in two - one for
 symlink and one for everything else.  This removes the apparent loop.
 (An example report can be seen in
     http://bugzilla.kernel.org/show_bug.cgi?id=15142).

 The "debatable" dependency loops happen when writing to one attribute
 causes a different attribute to be deleted.  In my (md) case this can
 actually cause a deadlock as both the attributes take the same lock
 while the handler is running.  This is because deleting the attribute
 will block until the all accesses of that attribute have completed (I
 think).
 However it should be possible to delete a name from sysfs while there
 are still accesses pending (it works for normal files!!).  So if
 sysfs could be changed to simply unlink the file and leave deletion to
 happen when the refcount become zero it would certainly make my life
 a lot easier, and allow the removal of some ugly code from md.c.
 I don't know sysfs well enough to suggest a patch though.

Thanks,
NeilBrown



commit 2e502cfe444b68f6ef6b8b2abe83b6112564095b
Author: NeilBrown <neilb@suse.de>
Date:   Wed Feb 10 09:43:45 2010 +1100

    sysfs: differentiate  between locking links and non-links for sysfs
    
    symlinks and non-symlink is sysfs are very different.
    A symlink can never be locked (active) while an attribute
    modification routine is running.  So removing symlink from an
    attribute 'store' routine should be permitted without any lockdep
    warnings.
    
    So split the lockdep context for 's_active' in two, one for symlinks
    and other for everything else.
    
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 699f371..e6eeaf6 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -354,7 +354,10 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 
 	atomic_set(&sd->s_count, 1);
 	atomic_set(&sd->s_active, 0);
-	sysfs_dirent_init_lockdep(sd);
+	if (type & SYSFS_KOBJ_LINK)
+		sysfs_dirent_init_lockdep(sd, "link");
+	else
+		sysfs_dirent_init_lockdep(sd, "non_link");
 
 	sd->s_name = name;
 	sd->s_mode = mode;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index cdd9377..a83a02b 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -89,11 +89,11 @@ static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
 }
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-#define sysfs_dirent_init_lockdep(sd)				\
+#define sysfs_dirent_init_lockdep(sd, type)			\
 do {								\
 	static struct lock_class_key __key;			\
 								\
-	lockdep_init_map(&sd->dep_map, "s_active", &__key, 0);	\
+	lockdep_init_map(&sd->dep_map, "s_active_" type, &__key, 0);	\
 } while(0)
 #else
 #define sysfs_dirent_init_lockdep(sd) do {} while(0)
