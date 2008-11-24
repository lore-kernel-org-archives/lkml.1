Return-Path: <linux-kernel-owner+w=401wt.eu-S1752520AbYKXCIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbYKXCIk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 21:08:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYKXCIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 21:08:30 -0500
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:53914 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbYKXCI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 21:08:29 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: [PATCH] loop file resizable 
To: Karel Zak <kzak@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, tomas@slax.org,
       linux-kernel@vger.kernel.org, akinobu.mita@gmail.com,
       util-linux-ng@vger.kernel.org
In-Reply-To: <20081121124432.GL2961@nb.net.home>
References: <492120DC.1070407@slax.org> <20081118164207.137e92be.akpm@linux-foundation.org> <16149.1227066661@jrobl> <20081120132654.4c649eb0.akpm@linux-foundation.org> <20081121101209.GJ2961@nb.net.home> <7554.1227270228@jrobl> <20081121124432.GL2961@nb.net.home>
Date: Mon, 24 Nov 2008 11:08:02 +0900
Message-ID: <22572.1227492482@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Karel Zak:
> On Fri, Nov 21, 2008 at 09:23:48PM +0900, hooanon05@yahoo.co.jp wrote:
	:::
> > If you tell me the URL of the base version of losetup, I will make a
> > patch.
> 
>  git://git.kernel.org/pub/scm/utils/util-linux-ng/util-linux-ng.git

Thanx.


>  Note, that I'll commit the patch when the kernel side will be in
>  Linus's tree.

Sure.
Here is the patch.

J. R. Okajima

----------------------------------------------------------------------

Subject: [PATCH 1/1] grow the size of loopback device and its backend file

introduce a new option, "-g | --grow <new_size> <loopdev> [file]" which
requres the kernel patch titled
"Subject: + loop-add-ioctl-to-resize-a-loop-device.patch added to -mm tree"
on 21 Nov 2008.

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 mount/lomount.c |  154 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 mount/loop.h    |    2 +
 2 files changed, 152 insertions(+), 4 deletions(-)

diff --git a/mount/lomount.c b/mount/lomount.c
index 5675eac..c705b43 100644
--- a/mount/lomount.c
+++ b/mount/lomount.c
@@ -24,6 +24,7 @@
 #include "xmalloc.h"
 #include "realpath.h"
 #include "pathnames.h"
+#include "blkdev.h"
 
 #define SIZE(a) (sizeof(a)/sizeof(a[0]))
 
@@ -827,6 +828,136 @@ del_loop (const char *device) {
 	return 0;
 }
 
+void grow_err(const char *name, unsigned long long old, unsigned long long new)
+{
+	fprintf(stderr, "size (%llu) must be larger than current %s (%llu)\n",
+		new, name, old);
+}
+
+int grow_file(const char *file, unsigned long long new)
+{
+	int err, fd;
+	unsigned long long append;
+	size_t sz;
+	ssize_t ssz;
+	const size_t one_g = 1 << 30;
+	struct stat st;
+	char *p;
+
+	err = -1;
+	fd = open(file, O_WRONLY | O_APPEND);
+	if (fd < 0)
+		goto out_p;
+
+	err = fstat(fd, &st);
+	if (err)
+		goto out_p;
+
+	err = -1;
+	if (new < st.st_size) {
+		grow_err(file, st.st_size, new);
+		goto out;
+	}
+
+	append = new - st.st_size;
+	sz = append;
+	if (sz > one_g)
+		sz = one_g;
+	while (1) {
+		p = calloc(sz, 1);
+		if (p)
+			break;
+		sz >>= 1;
+		if (!sz) {
+			errno = ENOMEM;
+			goto out_p;
+		}
+	}
+
+	/*
+	 * instread of ftrundate(2),
+	 * allocate disk blocks to support ENOSPC
+	 * on the loopback mounted filesystem
+	 */
+	err = 0;
+	while (append > 0) {
+		if (append < sz)
+			sz = append;
+		ssz = write(fd, p, sz);
+		if (ssz == -1) {
+			if (errno == EAGAIN || errno == EINTR)
+				continue;
+			err = errno;
+			break;
+		}
+		append -= ssz;
+	}
+	free(p);
+	if (err) {
+		errno = err;
+		goto out_p;
+	}
+
+	err = fsync(fd);
+	if (err)
+		goto out_p;
+	err = close(fd);
+	if (!err)
+		goto out; /* success */
+
+ out_p:
+	perror(file);
+ out:
+	return err;
+}
+
+int grow_capacity(unsigned long long new, const char *device,
+		  const char *file)
+{
+	int err, fd;
+	unsigned long long old;
+
+	fd = open(device, O_RDONLY);
+	if (fd < 0) {
+		err = errno;
+		perror(device);
+		goto out;
+	}
+
+	err = ioctl(fd, BLKGETSIZE64, &old);
+	if (err) {
+		err = errno;
+		perror("ioctl BLKGETSIZE64");
+		goto out;
+	}
+
+	if (!new) {
+		printf("%llu\n", old);
+		goto out;
+	}
+
+	if (new < old) {
+		err = EINVAL;
+		grow_err(device, old, new);
+		goto out;
+	}
+
+	if (file) {
+		err = grow_file(file, new);
+		if (err)
+			goto out;
+	}
+
+	err = ioctl(fd, LOOP_SET_CAPACITY, new);
+	if (err) {
+		err = errno;
+		perror("ioctl LOOP_SET_CAPACITY");
+	}
+
+ out:
+	return err;
+}
+
 #else /* no LOOP_SET_FD defined */
 static void
 mutter(void) {
@@ -872,6 +1003,7 @@ usage(void) {
   " %1$s -d | --detach <loopdev>                 delete\n"
   " %1$s -f | --find                             find unused\n"
   " %1$s -j | --associated <file> [-o <num>]     list all associated with <file>\n"
+  " %1$s -g | --grow <new_size> <loopdev> [file] grow capacity\n"
   " %1$s [ options ] {-f|--find|loopdev} <file>  setup\n"),
 		progname);
 
@@ -889,13 +1021,14 @@ usage(void) {
 
 int
 main(int argc, char **argv) {
-	char *p, *offset, *sizelimit, *encryption, *passfd, *device, *file, *assoc;
+	char *p, *offset, *sizelimit, *encryption, *passfd, *device, *file,
+		*assoc, *grow;
 	int delete, find, c, all;
 	int res = 0;
 	int showdev = 0;
 	int ro = 0;
 	int pfd = -1;
-	unsigned long long off, slimit;
+	unsigned long long off, slimit, new_size;
 	struct option longopts[] = {
 		{ "all", 0, 0, 'a' },
 		{ "detach", 0, 0, 'd' },
@@ -903,6 +1036,7 @@ main(int argc, char **argv) {
 		{ "find", 0, 0, 'f' },
 		{ "help", 0, 0, 'h' },
 		{ "associated", 1, 0, 'j' },
+		{ "grow", 1, 0, 'g' },
 		{ "offset", 1, 0, 'o' },
 		{ "sizelimit", 1, 0, 128 },
 		{ "pass-fd", 1, 0, 'p' },
@@ -919,13 +1053,13 @@ main(int argc, char **argv) {
 	delete = find = all = 0;
 	off = 0;
         slimit = 0;
-	assoc = offset = sizelimit = encryption = passfd = NULL;
+	assoc = offset = sizelimit = encryption = passfd = grow = NULL;
 
 	progname = argv[0];
 	if ((p = strrchr(progname, '/')) != NULL)
 		progname = p+1;
 
-	while ((c = getopt_long(argc, argv, "ade:E:fhj:o:p:rsv",
+	while ((c = getopt_long(argc, argv, "ade:E:fg:hj:o:p:rsv",
 				longopts, NULL)) != -1) {
 		switch (c) {
 		case 'a':
@@ -944,6 +1078,9 @@ main(int argc, char **argv) {
 		case 'f':
 			find = 1;
 			break;
+		case 'g':
+			grow = optarg;
+			break;
 		case 'j':
 			assoc = optarg;
 			break;
@@ -984,6 +1121,10 @@ main(int argc, char **argv) {
 	} else if (assoc) {
 		if (encryption || showdev || passfd || ro)
 			usage();
+	} else if (grow) {
+		if (all || assoc || find
+		    || (argc != 4 && argc != 5))
+			usage();
 	} else {
 		if (argc < optind+1 || argc > optind+2)
 			usage();
@@ -995,6 +1136,9 @@ main(int argc, char **argv) {
 	if (sizelimit && sscanf(sizelimit, "%llu", &slimit) != 1)
 		usage();
 
+	if (grow && sscanf(grow, "%llu", &new_size) != 1)
+		usage();
+
 	if (all)
 		return show_used_loop_devices();
 	else if (assoc)
@@ -1020,6 +1164,8 @@ main(int argc, char **argv) {
 
 	if (delete)
 		res = del_loop(device);
+	else if (grow)
+		res = grow_capacity(new_size, device, file);
 	else if (file == NULL)
 		res = show_loop(device);
 	else {
diff --git a/mount/loop.h b/mount/loop.h
index 6068852..c6d244e 100644
--- a/mount/loop.h
+++ b/mount/loop.h
@@ -22,6 +22,8 @@
 #define LOOP_GET_STATUS		0x4C03
 #define LOOP_SET_STATUS64	0x4C04
 #define LOOP_GET_STATUS64	0x4C05
+/* #define LOOP_CHANGE_FD		0x4C06 */
+#define LOOP_SET_CAPACITY	0x4C07
 
 /* Flags for loop_into{64,}->lo_flags */
 enum {
-- 
1.5.5.4.dirty

