Return-Path: <linux-kernel-owner+w=401wt.eu-S1760799AbYHOQ7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760799AbYHOQ7B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 12:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756132AbYHOQ6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 12:58:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755154AbYHOQ6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 12:58:37 -0400
Date: Fri, 15 Aug 2008 09:58:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Harkes <jaharkes@cs.cmu.edu>
cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
In-Reply-To: <20080815050613.GJ4422@cs.cmu.edu>
Message-ID: <alpine.LFD.1.10.0808150940110.3324@nehalem.linux-foundation.org>
References: <20080812062241.GQ28946@ZenIV.linux.org.uk> <87ej4u9nf5.fsf@devron.myhome.or.jp> <alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org> <20080812181057.GR28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121316570.3462@nehalem.linux-foundation.org>
 <20080812203808.GV28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121351570.3462@nehalem.linux-foundation.org> <20080813000433.GZ28946@ZenIV.linux.org.uk> <20080815050613.GJ4422@cs.cmu.edu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 15 Aug 2008, Jan Harkes wrote:
> 
> If I understood your description, then the following would be the
> correct fix. We return 0 as long as we managed to read some entries, and
> any non-zero return value from filldir otherwise.

This looks fine.

On the other hand, you really _should_ be able to just drop "result" 
entirely, and just do "return ret" at the end.

But no, you can't do it right now, becasue the callers are broken crap. 
But that really isn't your fault.

Also, you don't really need to change the

	if (ret < 0)
		goto out;

to

	if (ret != 0)
		goto out;

because the "filldir()" functions should all do the right thing anyway. 
But there's certainly nothing wrong with doing it either.

However, I think the real fix is something like this. This 

 - fixes all the callers

 - removes more lines than it adds

 - simplifies and clarifies the code

 - avoids pointless goto's

 - makes error handling of vfs_readdir() consistent among the callers
   (some callers already did the error handling _correctly_ before this 
   patch - this makes everybody do it the same way)

but I didn't actually even try to test this. Al? Jan?

(Side note: if this were a commit, I'd fix the _users_ of vfs_readdir() in 
one patch, and then the fs/coda/dir.c patch would be the next commit, but 
I'm sending it out as one single patch for comments/testing)

		Linus

---
 arch/alpha/kernel/osf_sys.c     |    8 ++------
 arch/ia64/ia32/sys_ia32.c       |    6 ++----
 arch/parisc/hpux/fs.c           |    7 ++-----
 arch/powerpc/kernel/sys_ppc32.c |    7 ++-----
 fs/coda/dir.c                   |    6 +-----
 fs/compat.c                     |   21 +++++++--------------
 fs/readdir.c                    |   22 +++++++---------------
 7 files changed, 23 insertions(+), 54 deletions(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 6e94313..869484e 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -160,14 +160,10 @@ osf_getdirentries(unsigned int fd, struct osf_dirent __user *dirent,
 	buf.error = 0;
 
 	error = vfs_readdir(file, osf_filldir, &buf);
-	if (error < 0)
-		goto out_putf;
-
-	error = buf.error;
+	if (error >= 0)
+		error = buf.error;
 	if (count != buf.count)
 		error = count - buf.count;
-
- out_putf:
 	fput(file);
  out:
 	return error;
diff --git a/arch/ia64/ia32/sys_ia32.c b/arch/ia64/ia32/sys_ia32.c
index 465116a..e70fb30 100644
--- a/arch/ia64/ia32/sys_ia32.c
+++ b/arch/ia64/ia32/sys_ia32.c
@@ -1278,9 +1278,8 @@ sys32_getdents (unsigned int fd, struct compat_dirent __user *dirent, unsigned i
 	buf.error = 0;
 
 	error = vfs_readdir(file, filldir32, &buf);
-	if (error < 0)
-		goto out_putf;
-	error = buf.error;
+	if (error >= 0)
+		error = buf.error;
 	lastdirent = buf.previous;
 	if (lastdirent) {
 		if (put_user(file->f_pos, &lastdirent->d_off))
@@ -1289,7 +1288,6 @@ sys32_getdents (unsigned int fd, struct compat_dirent __user *dirent, unsigned i
 			error = count - buf.count;
 	}
 
-out_putf:
 	fput(file);
 out:
 	return error;
diff --git a/arch/parisc/hpux/fs.c b/arch/parisc/hpux/fs.c
index 1263f00..ca0cd1b 100644
--- a/arch/parisc/hpux/fs.c
+++ b/arch/parisc/hpux/fs.c
@@ -121,16 +121,13 @@ int hpux_getdents(unsigned int fd, struct hpux_dirent __user *dirent, unsigned i
 	buf.error = 0;
 
 	error = vfs_readdir(file, filldir, &buf);
-	if (error < 0)
-		goto out_putf;
-	error = buf.error;
+	if (error >= 0)
+		error = buf.error;
 	lastdirent = buf.previous;
 	if (lastdirent) {
 		put_user(file->f_pos, &lastdirent->d_off);
 		error = count - buf.count;
 	}
-
-out_putf:
 	fput(file);
 out:
 	return error;
diff --git a/arch/powerpc/kernel/sys_ppc32.c b/arch/powerpc/kernel/sys_ppc32.c
index 709f8cb..b2a1634 100644
--- a/arch/powerpc/kernel/sys_ppc32.c
+++ b/arch/powerpc/kernel/sys_ppc32.c
@@ -100,11 +100,8 @@ asmlinkage int old32_readdir(unsigned int fd, struct old_linux_dirent32 __user *
 	buf.dirent = dirent;
 
 	error = vfs_readdir(file, (filldir_t)fillonedir, &buf);
-	if (error < 0)
-		goto out_putf;
-	error = buf.count;
-
-out_putf:
+	if (error >= 0)
+		error = buf.count;
 	fput(file);
 out:
 	return error;
diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index c591622..c4b1d58 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -488,7 +488,6 @@ static inline unsigned int CDT2DT(unsigned char cdt)
 static int coda_venus_readdir(struct file *coda_file, void *buf,
 			      filldir_t filldir)
 {
-	int result = 0; /* # of entries returned */
 	struct coda_file_info *cfi;
 	struct coda_inode_info *cii;
 	struct file *host_file;
@@ -515,14 +514,12 @@ static int coda_venus_readdir(struct file *coda_file, void *buf,
 		ret = filldir(buf, ".", 1, 0, de->d_inode->i_ino, DT_DIR);
 		if (ret < 0)
 			goto out;
-		result++;
 		coda_file->f_pos++;
 	}
 	if (coda_file->f_pos == 1) {
 		ret = filldir(buf, "..", 2, 1, de->d_parent->d_inode->i_ino, DT_DIR);
 		if (ret < 0)
 			goto out;
-		result++;
 		coda_file->f_pos++;
 	}
 	while (1) {
@@ -573,7 +570,6 @@ static int coda_venus_readdir(struct file *coda_file, void *buf,
 				      coda_file->f_pos, ino, type);
 			/* failure means no space for filling in this round */
 			if (ret < 0) break;
-			result++;
 		}
 		/* we'll always have progress because d_reclen is unsigned and
 		 * we've already established it is non-zero. */
@@ -581,7 +577,7 @@ static int coda_venus_readdir(struct file *coda_file, void *buf,
 	}
 out:
 	kfree(vdir);
-	return result ? result : ret;
+	return ret;
 }
 
 /* called when a cache lookup succeeds */
diff --git a/fs/compat.c b/fs/compat.c
index c9d1472..f4432fc 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -913,18 +913,14 @@ asmlinkage long compat_sys_getdents(unsigned int fd,
 	buf.error = 0;
 
 	error = vfs_readdir(file, compat_filldir, &buf);
-	if (error < 0)
-		goto out_putf;
-	error = buf.error;
+	if (error >= 0)
+		error = buf.error;
 	lastdirent = buf.previous;
 	if (lastdirent) {
+		error = count - buf.count;
 		if (put_user(file->f_pos, &lastdirent->d_off))
 			error = -EFAULT;
-		else
-			error = count - buf.count;
 	}
-
-out_putf:
 	fput(file);
 out:
 	return error;
@@ -1004,19 +1000,16 @@ asmlinkage long compat_sys_getdents64(unsigned int fd,
 	buf.error = 0;
 
 	error = vfs_readdir(file, compat_filldir64, &buf);
-	if (error < 0)
-		goto out_putf;
-	error = buf.error;
+	if (error >= 0)
+		error = buf.error;
 	lastdirent = buf.previous;
 	if (lastdirent) {
 		typeof(lastdirent->d_off) d_off = file->f_pos;
-		error = -EFAULT;
-		if (__put_user_unaligned(d_off, &lastdirent->d_off))
-			goto out_putf;
 		error = count - buf.count;
+		if (__put_user_unaligned(d_off, &lastdirent->d_off))
+			error = -EFAULT;
 	}
 
-out_putf:
 	fput(file);
 out:
 	return error;
diff --git a/fs/readdir.c b/fs/readdir.c
index 4e026e5..f5c02bc 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -205,18 +205,14 @@ asmlinkage long sys_getdents(unsigned int fd, struct linux_dirent __user * diren
 	buf.error = 0;
 
 	error = vfs_readdir(file, filldir, &buf);
-	if (error < 0)
-		goto out_putf;
-	error = buf.error;
+	if (error >= 0)
+		error = buf.error;
 	lastdirent = buf.previous;
 	if (lastdirent) {
+		error = count - buf.count;
 		if (put_user(file->f_pos, &lastdirent->d_off))
 			error = -EFAULT;
-		else
-			error = count - buf.count;
 	}
-
-out_putf:
 	fput(file);
 out:
 	return error;
@@ -289,19 +285,15 @@ asmlinkage long sys_getdents64(unsigned int fd, struct linux_dirent64 __user * d
 	buf.error = 0;
 
 	error = vfs_readdir(file, filldir64, &buf);
-	if (error < 0)
-		goto out_putf;
-	error = buf.error;
+	if (error >= 0)
+		error = buf.error;
 	lastdirent = buf.previous;
 	if (lastdirent) {
 		typeof(lastdirent->d_off) d_off = file->f_pos;
-		error = -EFAULT;
-		if (__put_user(d_off, &lastdirent->d_off))
-			goto out_putf;
 		error = count - buf.count;
+		if (__put_user(d_off, &lastdirent->d_off))
+			error = -EFAULT;
 	}
-
-out_putf:
 	fput(file);
 out:
 	return error;
