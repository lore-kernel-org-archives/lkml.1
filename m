Return-Path: <linux-kernel-owner+w=401wt.eu-S1755086AbYIDBlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbYIDBlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 21:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbYIDBlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 21:41:08 -0400
Received: from webmail.mrv.com ([66.43.110.11]:33066 "EHLO
	chmailsrv.int.mrv.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752557AbYIDBlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 21:41:06 -0400
Date: Wed, 3 Sep 2008 18:40:52 -0700
From: Nye Liu <nyet@mrv.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] INITRAMFS: Preserve mtime from INITRAMFS cpio images
Message-ID: <20080904014052.GA26086@mrv.com>
References: <20080805195232.GA5183@curtisfong.org> <20080903202938.GA9065@curtisfong.org> <20080903152231.6b82d9bf.akpm@linux-foundation.org> <20080903224130.GA16630@curtisfong.org> <20080903154840.69c049cf.akpm@linux-foundation.org> <20080903230430.GA13874@mrv.com> <20080903161955.fef7362e.akpm@linux-foundation.org> <20080903233056.GA17404@mrv.com> <20080903164144.27c94bae.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080903164144.27c94bae.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 04 Sep 2008 01:42:47.0554 (UTC) FILETIME=[88A50E20:01C90E2F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

one last shot :)

supercedes
initramfs-add-option-to-preserve-mtime-from-initramfs-cpio-images.patch

Signed-off-by: Nye Liu <nyet@nyet.org>

diff --git a/init/initramfs.c b/init/initramfs.c
index 644fc01..4f5ba75 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -6,6 +6,7 @@
 #include <linux/delay.h>
 #include <linux/string.h>
 #include <linux/syscalls.h>
+#include <linux/utime.h>
 
 static __initdata char *message;
 static void __init error(char *x)
@@ -72,6 +73,49 @@ static void __init free_hash(void)
 	}
 }
 
+static long __init do_utime(char __user *filename, time_t mtime)
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
+static void __init dir_utime(void)
+{
+	struct dir_entry *de, *tmp;
+	list_for_each_entry_safe(de, tmp, &dir_list, list) {
+		list_del(&de->list);
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
@@ -97,6 +141,7 @@ static void __init parse_header(char *s)
 	uid = parsed[2];
 	gid = parsed[3];
 	nlink = parsed[4];
+	mtime = parsed[5];
 	body_len = parsed[6];
 	major = parsed[7];
 	minor = parsed[8];
@@ -130,6 +175,7 @@ static inline void __init eat(unsigned n)
 	count -= n;
 }
 
+static __initdata char *vcollected;
 static __initdata char *collected;
 static __initdata int remains;
 static __initdata char *collect;
@@ -271,6 +317,7 @@ static int __init do_name(void)
 			if (wfd >= 0) {
 				sys_fchown(wfd, uid, gid);
 				sys_fchmod(wfd, mode);
+				vcollected = kstrdup(collected, GFP_KERNEL);
 				state = CopyFile;
 			}
 		}
@@ -278,12 +325,14 @@ static int __init do_name(void)
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
@@ -294,6 +343,8 @@ static int __init do_copy(void)
 	if (count >= body_len) {
 		sys_write(wfd, victim, body_len);
 		sys_close(wfd);
+		do_utime(vcollected, mtime);
+		kfree(vcollected);
 		eat(body_len);
 		state = SkipIt;
 		return 0;
@@ -311,6 +362,7 @@ static int __init do_symlink(void)
 	clean_path(collected, 0);
 	sys_symlink(collected + N_ALIGN(name_len), collected);
 	sys_lchown(collected, uid, gid);
+	do_utime(collected, mtime);
 	state = SkipIt;
 	next_state = Reset;
 	return 0;
@@ -466,6 +518,7 @@ static char * __init unpack_to_rootfs(char *buf, unsigned len, int check_only)
 		buf += inptr;
 		len -= inptr;
 	}
+	dir_utime();
 	kfree(window);
 	kfree(name_buf);
 	kfree(symlink_buf);
On Wed, Sep 03, 2008 at 04:41:44PM -0700, Andrew Morton wrote:
> On Wed, 3 Sep 2008 16:30:56 -0700
> Nye Liu <nyet@mrv.com> wrote:
> 
> > > > +static long __init do_utime(char __user *filename,
> > > > +	time_t mtime)
> > > 
> > > Please avoid wrapping things which don't need it.
> > 
> > Hard to avoid, unless you want me composing the following every place 
> > i'm currently calling do_utime():
> 
> I meant "wordwrapping":
> 
> static long __init do_utime(char __user *filename, time_t mtime)
> 
> easily fits in 80-cols.

-- 
Nye Liu
nliu@mrv.com
(818) 772-6235x248
(818) 772-0576 fax

"Who would be stupid enough to quote a fictitious character?"
	-- Don Quixote
