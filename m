Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbYHLRC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbYHLRC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 13:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbYHLRCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 13:02:46 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:52638 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbYHLRCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 13:02:45 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] readdir mess
References: <20080812062241.GQ28946@ZenIV.linux.org.uk>
Date: Wed, 13 Aug 2008 02:02:38 +0900
In-Reply-To: <20080812062241.GQ28946@ZenIV.linux.org.uk> (Al Viro's message of
	"Tue, 12 Aug 2008 07:22:41 +0100")
Message-ID: <87ej4u9nf5.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> 	An obvious way to deal with that would be to have filldir_t return
> bool; true => stop, false => go on.  However, that's going to cause silent
> breakage of out-of-tree filesystems.  Even though e.g. ext2 had always
> treated any non-zero return value of filldir as "stop", we'd grown filesystems
> that check for return value < 0 instead.  Having it return true (i.e. 1)
> will break all of those.  Note that generic callbacks currently return
> negative values for "stop", so they work with those filesystems right now.
>
> 	FWIW, I'm seriously tempted to go for the following variant:
> new __bitwise type with two values - READDIR_STOP and READDIR_CONTINUE,
> -1 and 0 resp.  The type of filldir_t would become filldir_res_t (*)(......),
> all existing instances of ->readdir() would keep working and sparse
> would catch all mismatches.
>
> 	Another variant is to change filldir_t in visible incompatible way
> that would have bool as return value and let readdir instances adjust or
> refuse to compile; maintainers of out-of-tree code would presumably notice
> that, so we would just have to document the calling conventions and say
> that checking for < 0 doesn't work anymore.

Personally, I'd like latter than would it work. And I hope we don't do
this again...  In the case of -EOVERFLOW, even current generic filldir()
is strange like following, and I saw simular in past.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>


The return value of fillonedir/filldir() is for the caller of
fillonedir/filldir(). If we want to tell the result to the caller of
->readdir(), we need to set it to buf->result/error.

This fixes -EOVERFLOW case, and cleans up related stuff.

[BTW: 32bit compat of ia64/powerpc seems to need to update]

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/readdir.c |   45 ++++++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff -puN fs/readdir.c~filldir-errcode-fix fs/readdir.c
--- linux-2.6/fs/readdir.c~filldir-errcode-fix	2008-02-02 04:03:55.000000000 +0900
+++ linux-2.6-hirofumi/fs/readdir.c	2008-02-02 04:03:55.000000000 +0900
@@ -46,18 +46,15 @@ out:
 
 EXPORT_SYMBOL(vfs_readdir);
 
+#ifdef __ARCH_WANT_OLD_READDIR
 /*
  * Traditional linux readdir() handling..
  *
- * "count=1" is a special case, meaning that the buffer is one
+ * "result=1" is a special case, meaning that the buffer is one
  * dirent-structure in size and that the code can't handle more
  * anyway. Thus the special "fillonedir()" function for that
  * case (the low-level handlers don't need to care about this).
  */
-#define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
-
-#ifdef __ARCH_WANT_OLD_READDIR
-
 struct old_linux_dirent {
 	unsigned long	d_ino;
 	unsigned long	d_offset;
@@ -80,8 +77,10 @@ static int fillonedir(void * __buf, cons
 	if (buf->result)
 		return -EINVAL;
 	d_ino = ino;
-	if (sizeof(d_ino) < sizeof(ino) && d_ino != ino)
-		return -EOVERFLOW;
+	if (sizeof(d_ino) < sizeof(ino) && d_ino != ino) {
+		buf->result = -EOVERFLOW;
+		goto error;
+	}
 	buf->result++;
 	dirent = buf->dirent;
 	if (!access_ok(VERIFY_WRITE, dirent,
@@ -97,7 +96,8 @@ static int fillonedir(void * __buf, cons
 	return 0;
 efault:
 	buf->result = -EFAULT;
-	return -EFAULT;
+error:
+	return buf->result;
 }
 
 asmlinkage long old_readdir(unsigned int fd, struct old_linux_dirent __user * dirent, unsigned int count)
@@ -122,9 +122,10 @@ asmlinkage long old_readdir(unsigned int
 out:
 	return error;
 }
-
 #endif /* __ARCH_WANT_OLD_READDIR */
 
+#define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
+
 /*
  * New, all-improved, singing, dancing, iBCS2-compliant getdents()
  * interface. 
@@ -151,12 +152,15 @@ static int filldir(void * __buf, const c
 	unsigned long d_ino;
 	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 2, sizeof(long));
 
-	buf->error = -EINVAL;	/* only used if we fail.. */
-	if (reclen > buf->count)
-		return -EINVAL;
+	if (reclen > buf->count) {
+		buf->error = -EINVAL;
+		goto error;
+	}
 	d_ino = ino;
-	if (sizeof(d_ino) < sizeof(ino) && d_ino != ino)
-		return -EOVERFLOW;
+	if (sizeof(d_ino) < sizeof(ino) && d_ino != ino) {
+		buf->error = -EOVERFLOW;
+		goto error;
+	}
 	dirent = buf->previous;
 	if (dirent) {
 		if (__put_user(offset, &dirent->d_off))
@@ -180,7 +184,8 @@ static int filldir(void * __buf, const c
 	return 0;
 efault:
 	buf->error = -EFAULT;
-	return -EFAULT;
+error:
+	return buf->error;
 }
 
 asmlinkage long sys_getdents(unsigned int fd, struct linux_dirent __user * dirent, unsigned int count)
@@ -236,9 +241,10 @@ static int filldir64(void * __buf, const
 	struct getdents_callback64 * buf = (struct getdents_callback64 *) __buf;
 	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 1, sizeof(u64));
 
-	buf->error = -EINVAL;	/* only used if we fail.. */
-	if (reclen > buf->count)
-		return -EINVAL;
+	if (reclen > buf->count) {
+		buf->error = -EINVAL;
+		goto error;
+	}
 	dirent = buf->previous;
 	if (dirent) {
 		if (__put_user(offset, &dirent->d_off))
@@ -264,7 +270,8 @@ static int filldir64(void * __buf, const
 	return 0;
 efault:
 	buf->error = -EFAULT;
-	return -EFAULT;
+error:
+	return buf->error;
 }
 
 asmlinkage long sys_getdents64(unsigned int fd, struct linux_dirent64 __user * dirent, unsigned int count)
_
