Return-Path: <linux-kernel-owner+w=401wt.eu-S1758630AbYEWQpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630AbYEWQpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 12:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbYEWQpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 12:45:08 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:50020 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbYEWQpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 12:45:04 -0400
Message-ID: <4836F48A.70008@kerlabs.com>
Date: Fri, 23 May 2008 18:44:58 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
Organization: Kerlabs
User-Agent: IceDove 1.5.0.14pre (X11/20071018)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_bohort-25504-1211561028-0001-2"
To: Joel.Becker@oracle.com
CC: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 4/4] configfs: Make multiple default_group destructions
 lockdep friendly
References: <20080522114048.265996107@kerlabs.com> <20080522114947.927196541@kerlabs.com>
In-Reply-To: <20080522114947.927196541@kerlabs.com>
X-Enigmail-Version: 0.94.2.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-25504-1211561028-0001-2
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit

Louis Rilling a écrit :
> When destroying a config_group having multiple (nested or not) default groups,
> lockdep raises a warning because multiple locks of class I_MUTEX_NORMAL are
> taken in configfs_detach_prep().
> 
> This patch makes such default group destructions lockdep-friendly by increasing
> the i_mutex sub-class from I_MUTEX_CHILD + 1 onwards for each default group
> locked under a being-destroyed config_group.

I discovered two bugs, as described below, and fixed in the attached
version of the patch. Sorry for the noise.

[...]
> 
> Index: b/fs/configfs/dir.c
> ===================================================================
> --- a/fs/configfs/dir.c	2008-05-22 12:38:02.000000000 +0200
> +++ b/fs/configfs/dir.c	2008-05-22 12:49:08.000000000 +0200
[...]
> @@ -383,7 +395,15 @@ static int configfs_detach_prep(struct d
>  		if (sd->s_type & CONFIGFS_NOT_PINNED)
>  			continue;
>  		if (sd->s_type & CONFIGFS_USET_DEFAULT) {
> -			mutex_lock(&sd->s_dentry->d_inode->i_mutex);
> +			lock_level = set_dirent_lock_level(parent_sd, sd);
> +			if (lock_level < 0) {
> +				/* Bad bad bad! We cannot remove a directory
> +				 * that we let be created! */
> +				ret = -ELOOP;
> +				break;
> +			}
> +			mutex_lock_nested(&sd->s_dentry->d_inode->i_mutex,
> +					  I_MUTEX_CHILD + lock_level);
>  			/* Mark that we've taken i_mutex */
>  			sd->s_type |= CONFIGFS_USET_DROPPING;
>  

Here setting lock_level before acquiring the mutex may race with mkdir
(and thus configfs_attach_group()) in the default group. A corrected
version of the patch is attached.

[...]
> @@ -1206,7 +1230,11 @@ static int configfs_rmdir(struct inode *
>  		return -EINVAL;
>  	}
>  
> +	/* The inode of the config_item being removed is already locked by
> +	 * vfs_rmdir() with subclass I_MUTEX_CHILD. Account for it. */
> +	set_dirent_lock_level(parent_item->ci_dentry->d_fsdata, sd);
>  	ret = configfs_detach_prep(dentry);
> +	reset_dirent_lock_level(sd);
>  	if (ret) {
>  		configfs_detach_rollback(dentry);
>  		config_item_put(parent_item);

lock_level should be reset on rollback, since mkdir may be called again
after a failure of rmdir. Again, fixed in the new version of the patch
in attachment.

Louis

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-25504-1211561028-0001-2
Content-Type: text/x-diff; name*0="configfs-make-default-group-destruction-lockdep-friendly-2.patch"; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename*0="configfs-make-default-group-destruction-lockdep-friendly-2.p";
 filename*1="atch"

configfs: Make multiple default_group destructions lockdep friendly

When destroying a config_group having multiple (nested or not) default gr=
oups,
lockdep raises a warning because multiple locks of class I_MUTEX_NORMAL a=
re
taken in configfs_detach_prep().

This patch makes such default group destructions lockdep-friendly by incr=
easing
the i_mutex sub-class from I_MUTEX_CHILD + 1 onwards for each default gro=
up
locked under a being-destroyed config_group.

With this patch and lockdep compiled-in, the number of default groups (wh=
atever
their depth in the tree) under a user-created config_group (resp. registe=
red
subsystem) is limited to MAX_LOCKDEP_SUBCLASSES - I_MUTEX_CHILD - 1 =3D=3D=
 3. This
limit is removed when not compiling lockdep.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[ INFO: possible recursive locking detected ]
2.6.26-rc3 #5
---------------------------------------------
rmdir/1499 is trying to acquire lock:
 (&sb->s_type->i_mutex_key#11){--..}, at: [<ffffffff802d2529>] configfs_d=
etach_prep+0x54/0x89

but task is already holding lock:
 (&sb->s_type->i_mutex_key#11){--..}, at: [<ffffffff80296513>] vfs_rmdir+=
0x49/0xac

other info that might help us debug this:
2 locks held by rmdir/1499:
 #0:  (&sb->s_type->i_mutex_key#3/1){--..}, at: [<ffffffff80298138>] do_r=
mdir+0x82/0x108
 #1:  (&sb->s_type->i_mutex_key#11){--..}, at: [<ffffffff80296513>] vfs_r=
mdir+0x49/0xac

stack backtrace:
Pid: 1499, comm: rmdir Not tainted 2.6.26-rc3 #5

Call Trace:
 [<ffffffff8024afe9>] __lock_acquire+0x8d2/0xc78
 [<ffffffff80266399>] filemap_fault+0x1cf/0x332
 [<ffffffff802d2529>] configfs_detach_prep+0x54/0x89
 [<ffffffff8024b762>] lock_acquire+0x51/0x6c
 [<ffffffff802d2529>] configfs_detach_prep+0x54/0x89
 [<ffffffff80248331>] debug_mutex_lock_common+0x16/0x23
 [<ffffffff805d6244>] mutex_lock_nested+0xcd/0x23b
 [<ffffffff802d2529>] configfs_detach_prep+0x54/0x89
 [<ffffffff802d3656>] configfs_rmdir+0xb8/0x1c3
 [<ffffffff80296535>] vfs_rmdir+0x6b/0xac
 [<ffffffff8029816d>] do_rmdir+0xb7/0x108
 [<ffffffff8024a2a2>] trace_hardirqs_on+0xef/0x113
 [<ffffffff805d7364>] trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff8020b0cb>] system_call_after_swapgs+0x7b/0x80


Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>
---
 fs/configfs/dir.c |   74 +++++++++++++++++++++++++++++++++++++++++++++++=
+------
 1 file changed, 66 insertions(+), 8 deletions(-)

Index: b/fs/configfs/dir.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- a/fs/configfs/dir.c	2008-05-22 13:36:06.000000000 +0200
+++ b/fs/configfs/dir.c	2008-05-23 16:46:43.000000000 +0200
@@ -37,16 +37,32 @@
 DECLARE_RWSEM(configfs_rename_sem);
=20
 #ifdef CONFIG_LOCKDEP
+static inline int __future_dirent_lock_level(struct configfs_dirent *pre=
v_sd,
+					     struct configfs_dirent *sd)
+{
+	int lock_level =3D prev_sd->s_lock_level + 1;
+	return (lock_level + I_MUTEX_CHILD < MAX_LOCKDEP_SUBCLASSES) ?
+		lock_level : -ELOOP;
+}
+
+static inline void __set_dirent_lock_level(struct configfs_dirent *sd,
+					   int lock_level)
+{
+	sd->s_lock_level =3D lock_level;
+}
+
 static inline int set_dirent_lock_level(struct configfs_dirent *prev_sd,=

 					struct configfs_dirent *sd)
 {
-	int lock_level =3D prev_sd->s_lock_level + 1;
-	if (lock_level + I_MUTEX_CHILD < MAX_LOCKDEP_SUBCLASSES) {
-		sd->s_lock_level =3D lock_level;
-		return lock_level;
-	}
-	sd->s_lock_level =3D -1;
-	return -ELOOP;
+	int lock_level =3D __future_dirent_lock_level(prev_sd, sd);
+	__set_dirent_lock_level(sd, lock_level < 0 ? -1 : lock_level);
+	return lock_level;
+}
+
+static inline void copy_dirent_lock_level(struct configfs_dirent *from,
+					  struct configfs_dirent *to)
+{
+	to->s_lock_level =3D from->s_lock_level;
 }
=20
 static inline void reset_dirent_lock_level(struct configfs_dirent *sd)
@@ -56,12 +72,28 @@ static inline void reset_dirent_lock_lev
=20
 #else /* CONFIG_LOCKDEP */
=20
+static inline int __future_dirent_lock_level(struct configfs_dirent *pre=
v_sd,
+					     struct configfs_dirent *sd)
+{
+	return 0;
+}
+
+static inline void __set_dirent_lock_level(struct configfs_dirent *sd,
+					   int lock_level)
+{
+}
+
 static inline int set_dirent_lock_level(struct configfs_dirent *prev_sd,=

 					struct configfs_dirent *sd)
 {
 	return 0;
 }
=20
+static inline void copy_dirent_lock_level(struct configfs_dirent *from,
+					  struct configfs_dirent *to)
+{
+}
+
 static inline void reset_dirent_lock_level(struct configfs_dirent *sd)
 {
 }
@@ -372,6 +404,7 @@ static int configfs_detach_prep(struct d
 {
 	struct configfs_dirent *parent_sd =3D dentry->d_fsdata;
 	struct configfs_dirent *sd;
+	int lock_level;
 	int ret;
=20
 	ret =3D -EBUSY;
@@ -383,7 +416,19 @@ static int configfs_detach_prep(struct d
 		if (sd->s_type & CONFIGFS_NOT_PINNED)
 			continue;
 		if (sd->s_type & CONFIGFS_USET_DEFAULT) {
-			mutex_lock(&sd->s_dentry->d_inode->i_mutex);
+			/* Do not set lock_level before we acquire the mutex,
+			 * otherwise a racing mkdir in sd could start from a
+			 * too high lock_level */
+			lock_level =3D __future_dirent_lock_level(parent_sd, sd);
+			if (lock_level < 0) {
+				/* Bad bad bad! We cannot remove a directory
+				 * that we let be created! */
+				ret =3D -ELOOP;
+				break;
+			}
+			mutex_lock_nested(&sd->s_dentry->d_inode->i_mutex,
+					  I_MUTEX_CHILD + lock_level);
+			__set_dirent_lock_level(sd, lock_level);
 			/* Mark that we've taken i_mutex */
 			sd->s_type |=3D CONFIGFS_USET_DROPPING;
=20
@@ -392,6 +437,10 @@ static int configfs_detach_prep(struct d
 			 * deep nesting of default_groups
 			 */
 			ret =3D configfs_detach_prep(sd->s_dentry);
+			/* Update parent's lock_level so that remaining
+			 * sibling children keep on globally increasing
+			 * lock_level */
+			copy_dirent_lock_level(sd, parent_sd);
 			if (!ret)
 				continue;
 		} else
@@ -419,6 +468,7 @@ static void configfs_detach_rollback(str
=20
 			if (sd->s_type & CONFIGFS_USET_DROPPING) {
 				sd->s_type &=3D ~CONFIGFS_USET_DROPPING;
+				reset_dirent_lock_level(sd);
 				mutex_unlock(&sd->s_dentry->d_inode->i_mutex);
 			}
 		}
@@ -1206,9 +1256,14 @@ static int configfs_rmdir(struct inode *
 		return -EINVAL;
 	}
=20
+	/* The inode of the config_item being removed is already locked by
+	 * vfs_rmdir() with subclass I_MUTEX_CHILD. Account for it. */
+	set_dirent_lock_level(parent_item->ci_dentry->d_fsdata, sd);
 	ret =3D configfs_detach_prep(dentry);
+	reset_dirent_lock_level(sd);
 	if (ret) {
 		configfs_detach_rollback(dentry);
+		reset_dirent_lock_level(sd);
 		config_item_put(parent_item);
 		return ret;
 	}
@@ -1492,10 +1547,13 @@ void configfs_unregister_subsystem(struc
=20
 	mutex_lock_nested(&configfs_sb->s_root->d_inode->i_mutex,
 			  I_MUTEX_PARENT);
+	/* Sets subsys's configfs_dirent lock_level to 0 */
+	set_dirent_lock_level(configfs_sb->s_root->d_fsdata, dentry->d_fsdata);=

 	mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
 	if (configfs_detach_prep(dentry)) {
 		printk(KERN_ERR "configfs: Tried to unregister non-empty subsystem!\n"=
);
 	}
+	reset_dirent_lock_level(dentry->d_fsdata);
 	configfs_detach_group(&group->cg_item);
 	dentry->d_inode->i_flags |=3D S_DEAD;
 	mutex_unlock(&dentry->d_inode->i_mutex);

--=_bohort-25504-1211561028-0001-2--
