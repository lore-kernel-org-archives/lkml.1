Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbYHYBdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbYHYBdd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 21:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbYHYBdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 21:33:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52277 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbYHYBdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 21:33:21 -0400
Date: Mon, 25 Aug 2008 02:33:16 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
Message-ID: <20080825013316.GR28946@ZenIV.linux.org.uk>
References: <alpine.LFD.1.10.0808121316570.3462@nehalem.linux-foundation.org> <20080812203808.GV28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121351570.3462@nehalem.linux-foundation.org> <20080813000433.GZ28946@ZenIV.linux.org.uk> <20080815050613.GJ4422@cs.cmu.edu> <alpine.LFD.1.10.0808150940110.3324@nehalem.linux-foundation.org> <20080824101014.GN28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808241017580.3363@nehalem.linux-foundation.org> <20080824195908.GQ28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808241644330.3363@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808241644330.3363@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2008 at 04:51:46PM -0700, Linus Torvalds wrote:
> 
> 
> On Sun, 24 Aug 2008, Al Viro wrote:
> >
> > The fact that coda_readdir() will _not_ be returning 0 with your change
> > when called with the arguments old_readdir() gives it?  You'll get ret
> > from filldir, i.e. what you'll normally see will be -EINVAL in case of
> > fillonedir as callback.
> 
> Ahh. A light finally goes on. No on the first filldir() callback, but on 
> the second.
 
> -	if (error >= 0)
> +	if (buf.result || error >= 0)
>  		error = buf.result;

Actually, in vfs-2.6.git/for-next patch I'd done simply
	if (buf.result)
		error = buf.result;

If we have !buf.result, we know that foo_readdir() hadn't called filldir at
all.  I.e. it's either an error or a genuine EOF.  And no ->readdir()
instances return a positive in the latter case, so there's no need to bother.

FWIW, below is the patch in question (commit cb81e118...).  I have _not_
touched the mess in nfs4 code; it's badly broken and I strongly suspect
that the right thing to do is to evict that crap to userland.  Another
omission is ecryptfs_readdir(), but since that sucker is badly broken
as well *and* I can't even guess WTF had it been trying to achieve...
I'd asked mhalcrow, but looks like he's on vacation ;-/

cb81e1183a8192b0fd5bf869987eb11267fcedbd
diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 8509dad..f25f6c4 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -165,14 +165,11 @@ osf_getdirentries(unsigned int fd, struct osf_dirent __user *dirent,
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
 
- out_putf:
 	fput(file);
  out:
 	return error;
diff --git a/arch/parisc/hpux/fs.c b/arch/parisc/hpux/fs.c
index 69ff671..b1312bb 100644
--- a/arch/parisc/hpux/fs.c
+++ b/arch/parisc/hpux/fs.c
@@ -127,9 +127,8 @@ int hpux_getdents(unsigned int fd, struct hpux_dirent __user *dirent, unsigned i
 	buf.error = 0;
 
 	error = vfs_readdir(file, filldir, &buf);
-	if (error < 0)
-		goto out_putf;
-	error = buf.error;
+	if (error >= 0)
+		error = buf.error;
 	lastdirent = buf.previous;
 	if (lastdirent) {
 		if (put_user(file->f_pos, &lastdirent->d_off))
diff --git a/fs/compat.c b/fs/compat.c
index 075d050..d2aa6a2 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -830,7 +830,7 @@ asmlinkage long compat_sys_old_readdir(unsigned int fd,
 	buf.dirent = dirent;
 
 	error = vfs_readdir(file, compat_fillonedir, &buf);
-	if (error >= 0)
+	if (buf.result)
 		error = buf.result;
 
 	fput(file);
@@ -917,9 +917,8 @@ asmlinkage long compat_sys_getdents(unsigned int fd,
 	buf.error = 0;
 
 	error = vfs_readdir(file, compat_filldir, &buf);
-	if (error < 0)
-		goto out_putf;
-	error = buf.error;
+	if (error >= 0)
+		error = buf.error;
 	lastdirent = buf.previous;
 	if (lastdirent) {
 		if (put_user(file->f_pos, &lastdirent->d_off))
@@ -927,8 +926,6 @@ asmlinkage long compat_sys_getdents(unsigned int fd,
 		else
 			error = count - buf.count;
 	}
-
-out_putf:
 	fput(file);
 out:
 	return error;
@@ -1008,19 +1005,16 @@ asmlinkage long compat_sys_getdents64(unsigned int fd,
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
 		if (__put_user_unaligned(d_off, &lastdirent->d_off))
-			goto out_putf;
-		error = count - buf.count;
+			error = -EFAULT;
+		else
+			error = count - buf.count;
 	}
-
-out_putf:
 	fput(file);
 out:
 	return error;
diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index 9960bbf..890e018 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -280,13 +280,14 @@ static int get_name(struct vfsmount *mnt, struct dentry *dentry,
 		int old_seq = buffer.sequence;
 
 		error = vfs_readdir(file, filldir_one, &buffer);
+		if (buffer.found) {
+			error = 0;
+			break;
+		}
 
 		if (error < 0)
 			break;
 
-		error = 0;
-		if (buffer.found)
-			break;
 		error = -ENOENT;
 		if (old_seq == buffer.sequence)
 			break;
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 8291591..77ad3a5 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1832,6 +1832,7 @@ struct buffered_dirent {
 struct readdir_data {
 	char		*dirent;
 	size_t		used;
+	int		full;
 };
 
 static int nfsd_buffered_filldir(void *__buf, const char *name, int namlen,
@@ -1842,8 +1843,10 @@ static int nfsd_buffered_filldir(void *__buf, const char *name, int namlen,
 	unsigned int reclen;
 
 	reclen = ALIGN(sizeof(struct buffered_dirent) + namlen, sizeof(u64));
-	if (buf->used + reclen > PAGE_SIZE)
+	if (buf->used + reclen > PAGE_SIZE) {
+		buf->full = 1;
 		return -EINVAL;
+	}
 
 	de->namlen = namlen;
 	de->offset = offset;
@@ -1875,9 +1878,13 @@ static int nfsd_buffered_readdir(struct file *file, filldir_t func,
 		unsigned int reclen;
 
 		buf.used = 0;
+		buf.full = 0;
 
 		host_err = vfs_readdir(file, nfsd_buffered_filldir, &buf);
-		if (host_err)
+		if (buf.full)
+			host_err = 0;
+
+		if (host_err < 0)
 			break;
 
 		size = buf.used;
diff --git a/fs/readdir.c b/fs/readdir.c
index 93a7559..b318d9b 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -117,7 +117,7 @@ asmlinkage long old_readdir(unsigned int fd, struct old_linux_dirent __user * di
 	buf.dirent = dirent;
 
 	error = vfs_readdir(file, fillonedir, &buf);
-	if (error >= 0)
+	if (buf.result)
 		error = buf.result;
 
 	fput(file);
@@ -209,9 +209,8 @@ asmlinkage long sys_getdents(unsigned int fd, struct linux_dirent __user * diren
 	buf.error = 0;
 
 	error = vfs_readdir(file, filldir, &buf);
-	if (error < 0)
-		goto out_putf;
-	error = buf.error;
+	if (error >= 0)
+		error = buf.error;
 	lastdirent = buf.previous;
 	if (lastdirent) {
 		if (put_user(file->f_pos, &lastdirent->d_off))
@@ -219,8 +218,6 @@ asmlinkage long sys_getdents(unsigned int fd, struct linux_dirent __user * diren
 		else
 			error = count - buf.count;
 	}
-
-out_putf:
 	fput(file);
 out:
 	return error;
@@ -293,19 +290,16 @@ asmlinkage long sys_getdents64(unsigned int fd, struct linux_dirent64 __user * d
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
 		if (__put_user(d_off, &lastdirent->d_off))
-			goto out_putf;
-		error = count - buf.count;
+			error = -EFAULT;
+		else
+			error = count - buf.count;
 	}
-
-out_putf:
 	fput(file);
 out:
 	return error;
