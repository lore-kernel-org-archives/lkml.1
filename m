Return-Path: <linux-kernel-owner+w=401wt.eu-S1756481AbYICWzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481AbYICWzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 18:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbYICWzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 18:55:03 -0400
Received: from chmailsrv.int.mrv.com ([66.43.110.11]:24627 "EHLO
	chmailsrv.int.mrv.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752191AbYICWzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 18:55:00 -0400
Date: Wed, 3 Sep 2008 15:54:59 -0700
From: Nye Liu <nyet@mrv.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nye Liu <nyet@nyet.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] INITRAMFS: Add option to preserve mtime from INITRAMFS
	cpio images
Message-ID: <20080903225459.GB9893@mrv.com>
References: <20080805195232.GA5183@curtisfong.org> <20080903202938.GA9065@curtisfong.org> <20080903152231.6b82d9bf.akpm@linux-foundation.org> <20080903224130.GA16630@curtisfong.org> <20080903154840.69c049cf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080903154840.69c049cf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 03 Sep 2008 22:56:54.0536 (UTC) FILETIME=[5C2F0880:01C90E18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 03:48:40PM -0700, Andrew Morton wrote:
> On Wed, 3 Sep 2008 15:41:31 -0700
> Nye Liu <nyet@nyet.org> wrote:
> 
> > > >  	collected[N_ALIGN(name_len) + body_len] = '\0';
> > > >  	clean_path(collected, 0);
> > > >  	sys_symlink(collected + N_ALIGN(name_len), collected);
> > > >  	sys_lchown(collected, uid, gid);
> > > > +	do_lutime(collected, &mtime);
> > > >  	state = SkipIt;
> > > >  	next_state = Reset;
> > > >  	return 0;
> > > > @@ -466,6 +520,7 @@ static char * __init unpack_to_rootfs(char *buf, unsigned len, int check_only)
> > > >  		buf += inptr;
> > > >  		len -= inptr;
> > > >  	}
> > > > +	dir_utime();
> > > 
> > > Perhaps this is the simplest implementation - I didn't check the fine
> > > details.  What's your thinking here?  
> > > 
> > 
> > The main problem is that i need to save off the entire list for later
> > processing of the directory mtimes... if i process the directory mtimes
> > in the same pass as the file/link mtimes, touching the directory inode
> > when creating/modifying the file/links updates the directory mtime, and
> > overwrites whatever mtime i set the directory to when i created it.
> > 
> > The only solution is to do a two pass, which is why the list is
> > necessary. If there is a better way, i did not find it :(
> > 
> > It could be that i misunderstood your question though :)
> 
> I'm wondering whether this code need to use `struct utimbuf' at all. 
> Or at least, as much as it does.  utimbuf is more a userspace-facing
> thing whereas in-kernel timespecs and timevals are more common.
> 
> The code as you have it does a fair few conversions into utimbuf format
> (both directly and via the existing functions which it calls).  Would
> it be simpler if it dealt in terms of timespecs?
> 

maybe something like this:


diff --git a/init/initramfs.c b/init/initramfs.c
index 644fc01..89d3e53 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -6,6 +6,7 @@
 #include <linux/delay.h>
 #include <linux/string.h>
 #include <linux/syscalls.h>
+#include <linux/utime.h>
 
 static __initdata char *message;
 static void __init error(char *x)
@@ -72,6 +73,45 @@ static void __init free_hash(void)
 	}
 }
 
+static __initdata LIST_HEAD(dir_list);
+struct dir_entry {
+	struct list_head list;
+	char *name;
+	time_t mtime;
+};
+
+static void __init dir_add(const char *name, time_t mtime)
+{
+	struct dir_entry *de = kmalloc(sizeof(struct dir_entry), GFP_KERNEL);
+	if (!de)
+		panic("can't allocate dir_entry buffer");
+	INIT_LIST_HEAD(&de->list);
+	de->name = kstrdup(name, GFP_KERNEL);
+	de->mtime = mtime;
+	list_add(&de->list, &dir_list);
+}
+
+static void __init do_utime(char *name, time_t mtime)
+{
+	struct utimbuf time;
+	time.actime=time.modtime=mtime;
+	sys_utime(name, &time);
+}
+
+static void __init dir_utime(void)
+{
+	struct list_head *e, *tmp;
+	list_for_each_safe(e, tmp, &dir_list) {
+		struct dir_entry *de = list_entry(e, struct dir_entry, list);
+		list_del(e);
+		do_utime(de->name, de->mtime);
+		kfree(de->name);
+		kfree(de);
+	}
+}
+
+static __initdata time_t mtime;
+
 /* cpio header parsing */
 
 static __initdata unsigned long ino, major, minor, nlink;
@@ -97,6 +137,7 @@ static void __init parse_header(char *s)
 	uid = parsed[2];
 	gid = parsed[3];
 	nlink = parsed[4];
+	mtime = parsed[5];
 	body_len = parsed[6];
 	major = parsed[7];
 	minor = parsed[8];
@@ -130,6 +171,7 @@ static inline void __init eat(unsigned n)
 	count -= n;
 }
 
+static __initdata char *vcollected;
 static __initdata char *collected;
 static __initdata int remains;
 static __initdata char *collect;
@@ -271,6 +313,7 @@ static int __init do_name(void)
 			if (wfd >= 0) {
 				sys_fchown(wfd, uid, gid);
 				sys_fchmod(wfd, mode);
+				vcollected = kstrdup(collected, GFP_KERNEL);
 				state = CopyFile;
 			}
 		}
@@ -278,12 +321,14 @@ static int __init do_name(void)
 		sys_mkdir(collected, mode);
 		sys_chown(collected, uid, gid);
 		sys_chmod(collected, mode);
+		dir_add(collected, mtime);
 	} else if (S_ISBLK(mode) || S_ISCHR(mode) ||
 		   S_ISFIFO(mode) || S_ISSOCK(mode)) {
 		if (maybe_link() == 0) {
 			sys_mknod(collected, mode, rdev);
 			sys_chown(collected, uid, gid);
 			sys_chmod(collected, mode);
+			do_utime(collected, mtime);
 		}
 	}
 	return 0;
@@ -294,6 +339,8 @@ static int __init do_copy(void)
 	if (count >= body_len) {
 		sys_write(wfd, victim, body_len);
 		sys_close(wfd);
+		do_utime(vcollected, mtime);
+		kfree(vcollected);
 		eat(body_len);
 		state = SkipIt;
 		return 0;
@@ -305,12 +352,26 @@ static int __init do_copy(void)
 	}
 }
 
+static long __init do_lutime(char __user *filename,
+	time_t mtime)
+{
+	struct timespec t[2];
+
+	t[0].tv_sec = mtime;
+	t[0].tv_nsec = 0;
+	t[1].tv_sec = mtime;
+	t[1].tv_nsec = 0;
+
+	return do_utimes(AT_FDCWD, filename, t, AT_SYMLINK_NOFOLLOW);
+}
+
 static int __init do_symlink(void)
 {
 	collected[N_ALIGN(name_len) + body_len] = '\0';
 	clean_path(collected, 0);
 	sys_symlink(collected + N_ALIGN(name_len), collected);
 	sys_lchown(collected, uid, gid);
+	do_lutime(collected, mtime);
 	state = SkipIt;
 	next_state = Reset;
 	return 0;
@@ -466,6 +527,7 @@ static char * __init unpack_to_rootfs(char *buf, unsigned len, int check_only)
 		buf += inptr;
 		len -= inptr;
 	}
+	dir_utime();
 	kfree(window);
 	kfree(name_buf);
 	kfree(symlink_buf);
-- 
Nye Liu
nliu@mrv.com
(818) 772-6235x248
(818) 772-0576 fax

"Who would be stupid enough to quote a fictitious character?"
	-- Don Quixote
