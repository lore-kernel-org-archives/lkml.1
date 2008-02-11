Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbYBKOfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbYBKOfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 09:35:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbYBKOe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 09:34:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171AbYBKOe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 09:34:57 -0500
Date: Mon, 11 Feb 2008 22:23:57 +0800
From: Eugene Teo <eugeneteo@kernel.sg>
To: Miklos Szeredi <mszeredi@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: extend /proc/<pid>/fdinfo/<fd>
Message-ID: <20080211142357.GA3695@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
References: <20080209120157.GA3035@kernel.sg> <1202720907.4739.36.camel@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202720907.4739.36.camel@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

<quote sender="Miklos Szeredi">
> On Sat, 2008-02-09 at 20:01 +0800, Eugene Teo wrote:
> > This patch extends /proc/<pid>/fdinfo/<fd> to report information about open
> > files, and pathname. This information can be useful to know when debugging an
> > application.
> > 
> > For each file descriptor, the information is provided in the following format:
> > 
> > kerndev: ~/code/kernel# cat /proc/`pgrep pickup`/fdinfo/6
> > mode:   0622
> > dev:    253,0
> > ino:    21463057
> 
> These are already available via 'stat /proc/<pid>/fd/<fd>'
> 
> > uid:    89
> > gid:    89
> 
> AFAICS file->f_[ug]id are only used by the netfilter code, but I guess
> it wouldn't hurt to show them here.  But please add fields at the end of
> the file, instead of the beggining.

Ok, will do.

> > rdev:   0,0
> 
> This is in struct stat too.
> 
> > pos:    0
> > flags:  04002 FD_CLOEXEC # if close-on-exec flag is set
> 
> FD_CLOEXEC should be on a separate line, because it's not an O_FOO flag.
> > path:   /var/spool/postfix/public/pickup
> 
> readlink /proc/<pid>/fd/<fd>

Thanks for the review. I agree that some of the information can be omitted
since it can be accessed using stat and readlink. I still think it is useful
to have ino in the output though.

Here's the updated patch:

[PATCH] proc: extend /proc/<pid>/fdinfo/<fd>

This patch extends /proc/<pid>/fdinfo/<fd> to report information about open
files, and pathname. This information can be useful to know when debugging an
application.

For each file descriptor, the information is provided in the following format:

kerndev: ~/code/kernel$ cat /proc/`pgrep firefox-bin`/fdinfo/29
pos:    49152
flags:  02
uid:    500
gid:    500
ino:    13205793
fd_flags:       FD_CLOEXEC # if close-on-exec flag is set

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
---
 fs/proc/base.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index c59852b..5ea5dee 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1402,7 +1402,7 @@ out:
 	return ~0U;
 }
 
-#define PROC_FDINFO_MAX 64
+#define PROC_FDINFO_MAX 128
 
 static int proc_fd_info(struct inode *inode, struct dentry **dentry,
 			struct vfsmount **mnt, char *info)
@@ -1428,12 +1428,26 @@ static int proc_fd_info(struct inode *inode, struct dentry **dentry,
 				*mnt = mntget(file->f_path.mnt);
 			if (dentry)
 				*dentry = dget(file->f_path.dentry);
-			if (info)
+			/* called by proc_fdinfo_read() */
+			if (info) {
+				struct fdtable *fdt = files_fdtable(files);
+				struct dentry *d = dget(file->f_path.dentry);
+				int gcoe = FD_ISSET(fd, fdt->close_on_exec);
+
 				snprintf(info, PROC_FDINFO_MAX,
 					 "pos:\t%lli\n"
-					 "flags:\t0%o\n",
+					 "flags:\t0%o\n"
+					 "uid:\t%d\n"
+					 "gid:\t%d\n"
+					 "ino:\t%ld\n"
+					 "fd_flags:\t%s\n",
 					 (long long) file->f_pos,
-					 file->f_flags);
+					 file->f_flags,
+					 file->f_uid, file->f_gid,
+					 d->d_inode->i_ino,
+					 gcoe ? "FD_CLOEXEC" : "0");
+				dput(d);
+			}
 			spin_unlock(&files->file_lock);
 			put_files_struct(files);
 			return 0;

