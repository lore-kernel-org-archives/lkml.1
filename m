Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbZJHIRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbZJHIRO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 04:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755279AbZJHIRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 04:17:13 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:35513 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884AbZJHIRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 04:17:10 -0400
From: Jim Meyering <jim@meyering.net>
To: Stuart Kemp <stuart_kemp@hotmail.com>
Cc: <bug-coreutils@gnu.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: master list of FS magic numbers? [Re: stat reports UNKNOWN for cifs
In-Reply-To: <BAY142-W153DBB9A3927A52DEA97B396CD0@phx.gbl> (Stuart Kemp's
	message of "Wed, 7 Oct 2009 17:13:44 +0000")
References: <BAY142-W153DBB9A3927A52DEA97B396CD0@phx.gbl>
Date: Thu, 08 Oct 2009 10:16:26 +0200
Message-ID: <87vdiquwpx.fsf@meyering.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stuart Kemp wrote:
> Using coreutils 7.6 on Linux
> Running "stat -f /path/to/cifs" on a cifs-mounted path (i.e. mount -t cifs) reports
>
>   Type: UNKNOWN (0xff534d42)
>
>
> CIFS_MAGIC_NUMBER is listed in the statfs(2) man-page
>
>     CIFS_MAGIC_NUMBER 0xFF534D42
>
> but is not in the switch statement in human_fstype function in stat.c

Thanks!
We were long overdue for an update.
Another new one was listed in that man page: HFS.
However, there were many more in <linux/magic.h>.
So here are two patches to add support for the following names:

   afs
   cifs
   anon-inode FS
   btrfs
   cgroupfs
   cramfs-wend
   debugfs
   futexfs
   hfs
   inotifyfs
   minux3
   securityfs
   selinux
   xenfs
   nilfs

I've made it so "stat -f" will report the following strings
for "file system name".  If anyone knows that one of those names
should be spelled differently, please let me know ASAP.  In particular,
anon-inode FS seemed better than "anoninodefs", and there's precedent
for names containing spaces.  Likewise, I chose cramfs-wend rather
than "cramfswend".  However, if there's precedent or any other good
reason for a different spelling, let's fix it now.

These changes add Makefile rules (not well factored, btw)
that will help keep up with additions to the man page and to
<linux/magic.h>, but we should be able to do better.  For example,
"nilfs" was not on either, but I was able to dig up its magic number.
If anyone can point to other places that list file system names
and magic numbers, please let us know.


>From 8e323907160db1cb3f9425204013597c81384492 Mon Sep 17 00:00:00 2001
From: Jim Meyering <meyering@redhat.com>
Date: Thu, 8 Oct 2009 09:05:08 +0200
Subject: [PATCH 1/2] stat: recognize CIFS and HFS file system types

* src/stat.c (human_fstype) [CIFS, HFS]: Add new file system types.
Prompted by a report from Stuart Kemp.
Normalize the form of a few hexadecimal magic numbers.
Alphabetize on S_MAGIC_ case names.
* src/Makefile.am (fs-magic-compare, fs-def, fs-magic): New rules, to
automate comparison of our list with that in the Linux statfs man page.
* NEWS (Bug fixes): Mention it.
---
 NEWS            |    2 ++
 src/Makefile.am |   31 +++++++++++++++++++++++++++++++
 src/stat.c      |   18 +++++++++++-------
 3 files changed, 44 insertions(+), 7 deletions(-)

diff --git a/NEWS b/NEWS
index ff5e9a2..cca3328 100644
--- a/NEWS
+++ b/NEWS
@@ -4,6 +4,8 @@ GNU coreutils NEWS                                    -*- outline -*-

 ** Bug fixes

+  stat -f recognizes more file system types: CIFS, HFS
+
 ** New features

   md5sum --check now also accepts openssl-style checksums.
diff --git a/src/Makefile.am b/src/Makefile.am
index 0aa7599..3bba86d 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -330,6 +330,37 @@ wheel.h: wheel-gen.pl Makefile.am
 # Tell automake to exempt then from that installcheck test.
 AM_INSTALLCHECK_STD_OPTIONS_EXEMPT = false test

+# Compare fs.h with the list of file system names/magic-numbers in the
+# Linux statfs man page.  This target prints any new name/number pairs.
+.PHONY: fs-magic-compare
+fs-magic-compare: fs-magic fs-def
+	join -v1 -t@ fs-magic fs-def
+
+CLEANFILES += fs-magic fs-def
+fs-def: fs.h
+	grep '^# *define ' $< > $@-t && mv $@-t $@
+
+fs-magic:
+	man statfs \
+          |perl -ne '/File system types:/.../Nobody kno/ and print'	\
+          |grep 0x | perl -p						\
+            -e 's/MINIX_SUPER_MAGIC\b/MINIX/;'				\
+            -e 's/MINIX_SUPER_MAGIC2\b/MINIX_30/;'			\
+            -e 's/MINIX2_SUPER_MAGIC\b/MINIX_V2/;'			\
+            -e 's/MINIX2_SUPER_MAGIC2\b/MINIX_V2_30/;'			\
+            -e 's/CIFS_MAGIC_NUMBER/CIFS/;'				\
+            -e 's/(_SUPER)?_MAGIC//;'					\
+            -e 's/\s+0x(\S+)/" 0x" . uc $$1/e;'				\
+            -e 's/^\s+//;'						\
+            -e 's/^_(XIAFS)/$$1/;'					\
+            -e 's/^USBDEVICE/USBDEVFS/;'				\
+            -e 's/NTFS_SB/NTFS/;'					\
+            -e 's/^/# define S_MAGIC_/;'				\
+            -e 's,\s*/\* .*? \*/,,;'					\
+          | grep -v S_MAGIC_EXT3					\
+          | LC_ALL=C sort						\
+          > $@-t && mv $@-t $@
+
 BUILT_SOURCES += fs.h
 fs.h: stat.c extract-magic
 	$(AM_V_GEN)rm -f $@
diff --git a/src/stat.c b/src/stat.c
index 14654b1..87f93b8 100644
--- a/src/stat.c
+++ b/src/stat.c
@@ -225,8 +225,10 @@ human_fstype (STRUCT_STATVFS const *statfsbuf)
       return "befs";
     case S_MAGIC_BFS: /* 0x1BADFACE */
       return "bfs";
-    case S_MAGIC_BINFMT_MISC: /* 0x42494e4d */
+    case S_MAGIC_BINFMT_MISC: /* 0x42494E4D */
       return "binfmt_misc";
+    case S_MAGIC_CIFS: /* 0xFF534D42 */
+      return "cifs";
     case S_MAGIC_CODA: /* 0x73757245 */
       return "coda";
     case S_MAGIC_COH: /* 0x012FF7B7 */
@@ -237,7 +239,7 @@ human_fstype (STRUCT_STATVFS const *statfsbuf)
       return "devfs";
     case S_MAGIC_DEVPTS: /* 0x1CD1 */
       return "devpts";
-    case S_MAGIC_EFS: /* 0x414A53 */
+    case S_MAGIC_EFS: /* 0x00414A53 */
       return "efs";
     case S_MAGIC_EXT: /* 0x137D */
       return "ext";
@@ -249,9 +251,11 @@ human_fstype (STRUCT_STATVFS const *statfsbuf)
       return "fat";
     case S_MAGIC_FUSECTL: /* 0x65735543 */
       return "fusectl";
+    case S_MAGIC_HFS: /* 0x4244 */
+      return "hfs";
     case S_MAGIC_HPFS: /* 0xF995E849 */
       return "hpfs";
-    case S_MAGIC_HUGETLBFS: /* 0x958458f6 */
+    case S_MAGIC_HUGETLBFS: /* 0x958458F6 */
       return "hugetlbfs";
     case S_MAGIC_ISOFS: /* 0x9660 */
       return "isofs";
@@ -259,10 +263,10 @@ human_fstype (STRUCT_STATVFS const *statfsbuf)
       return "isofs";
     case S_MAGIC_ISOFS_WIN: /* 0x4000 */
       return "isofs";
-    case S_MAGIC_JFFS2: /* 0x72B6 */
-      return "jffs2";
     case S_MAGIC_JFFS: /* 0x07C0 */
       return "jffs";
+    case S_MAGIC_JFFS2: /* 0x72B6 */
+      return "jffs2";
     case S_MAGIC_JFS: /* 0x3153464A */
       return "jfs";
     case S_MAGIC_LUSTRE: /* 0x0BD00BD0 */
@@ -285,7 +289,7 @@ human_fstype (STRUCT_STATVFS const *statfsbuf)
       return "nfsd";
     case S_MAGIC_NTFS: /* 0x5346544E */
       return "ntfs";
-    case S_MAGIC_OPENPROM: /* 0x9fa1 */
+    case S_MAGIC_OPENPROM: /* 0x9FA1 */
       return "openprom";
     case S_MAGIC_PROC: /* 0x9FA0 */
       return "proc";
@@ -307,7 +311,7 @@ human_fstype (STRUCT_STATVFS const *statfsbuf)
       return "sysv2";
     case S_MAGIC_SYSV4: /* 0x012FF7B5 */
       return "sysv4";
-    case S_MAGIC_TMPFS: /* 0x1021994 */
+    case S_MAGIC_TMPFS: /* 0x01021994 */
       return "tmpfs";
     case S_MAGIC_UDF: /* 0x15013346 */
       return "udf";
--
1.6.5.rc2.204.g8ea19


>From cfbe92608b83975a8348f0ad485fb0dffdb0caae Mon Sep 17 00:00:00 2001
From: Jim Meyering <meyering@redhat.com>
Date: Thu, 8 Oct 2009 10:06:42 +0200
Subject: [PATCH 2/2] stat: add support for many more file system types

* src/stat.c (human_fstype): Add the following FS types,
from <linux/magic.h>: afs, anon-inode FS, btrfs, cgroupfs,
cramfs-wend, debugfs, futexfs, inotifyfs, minux3, securityfs,
selinux, xenfs.
Also add "nilfs".
* src/Makefile.am (fs-kernel-magic): New rule.
---
 src/Makefile.am |   32 ++++++++++++++++++++++++++++----
 src/stat.c      |   28 +++++++++++++++++++++++++++-
 2 files changed, 55 insertions(+), 5 deletions(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index 3bba86d..0c70914 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -333,14 +333,16 @@ AM_INSTALLCHECK_STD_OPTIONS_EXEMPT = false test
 # Compare fs.h with the list of file system names/magic-numbers in the
 # Linux statfs man page.  This target prints any new name/number pairs.
 .PHONY: fs-magic-compare
-fs-magic-compare: fs-magic fs-def
+fs-magic-compare: fs-magic fs-kernel-magic fs-def
 	join -v1 -t@ fs-magic fs-def
+	join -v1 -t@ fs-kernel-magic fs-def

-CLEANFILES += fs-magic fs-def
+CLEANFILES += fs-def
 fs-def: fs.h
 	grep '^# *define ' $< > $@-t && mv $@-t $@

-fs-magic:
+CLEANFILES += fs-magic
+fs-magic: Makefile
 	man statfs \
           |perl -ne '/File system types:/.../Nobody kno/ and print'	\
           |grep 0x | perl -p						\
@@ -357,7 +359,29 @@ fs-magic:
             -e 's/NTFS_SB/NTFS/;'					\
             -e 's/^/# define S_MAGIC_/;'				\
             -e 's,\s*/\* .*? \*/,,;'					\
-          | grep -v S_MAGIC_EXT3					\
+          | grep -Ev 'S_MAGIC_EXT[34]|STACK_END'			\
+          | LC_ALL=C sort						\
+          > $@-t && mv $@-t $@
+
+CLEANFILES += fs-kernel-magic
+fs-kernel-magic: Makefile
+	perl -ne '/^#define.*0x/ and print' /usr/include/linux/magic.h	\
+          | perl -p							\
+            -e 's/MINIX_SUPER_MAGIC\b/MINIX/;'				\
+            -e 's/MINIX_SUPER_MAGIC2\b/MINIX_30/;'			\
+            -e 's/MINIX2_SUPER_MAGIC\b/MINIX_V2/;'			\
+            -e 's/MINIX2_SUPER_MAGIC2\b/MINIX_V2_30/;'			\
+            -e 's/MINIX3_SUPER_MAGIC\b/MINIX_V3/;'			\
+            -e 's/(_SUPER)?_MAGIC//;'					\
+            -e 's/\s+0x(\S+)/" 0x" . uc $$1/e;'				\
+            -e 's/(\s+0x)(\X{3})\b/$${1}0$$2/;'				\
+            -e 's/(\s+0x)(\X{6})\b/$${1}00$$2/;'			\
+            -e 's/(\s+0x)(\X{7})\b/$${1}0$$2/;'				\
+            -e 's/^#define\s+//;'					\
+            -e 's/^USBDEVICE/USBDEVFS/;'				\
+            -e 's/^/# define S_MAGIC_/;'				\
+            -e 's,\s*/\* .*? \*/,,;'					\
+          | grep -Ev 'S_MAGIC_EXT[34]|STACK_END'			\
           | LC_ALL=C sort						\
           > $@-t && mv $@-t $@

diff --git a/src/stat.c b/src/stat.c
index 87f93b8..02d0ead 100644
--- a/src/stat.c
+++ b/src/stat.c
@@ -219,7 +219,11 @@ human_fstype (STRUCT_STATVFS const *statfsbuf)
       return "adfs";
     case S_MAGIC_AFFS: /* 0xADFF */
       return "affs";
-    case S_MAGIC_AUTOFS: /* 0x187 */
+    case S_MAGIC_AFS: /* 0x5346414F */
+      return "afs";
+    case S_MAGIC_ANON_INODE_FS: /* 0x09041934 */
+      return "anon-inode FS";
+    case S_MAGIC_AUTOFS: /* 0x0187 */
       return "autofs";
     case S_MAGIC_BEFS: /* 0x42465331 */
       return "befs";
@@ -227,6 +231,10 @@ human_fstype (STRUCT_STATVFS const *statfsbuf)
       return "bfs";
     case S_MAGIC_BINFMT_MISC: /* 0x42494E4D */
       return "binfmt_misc";
+    case S_MAGIC_BTRFS: /* 0x9123683E */
+      return "btrfs";
+    case S_MAGIC_CGROUP: /* 0x0027E0EB */
+      return "cgroupfs";
     case S_MAGIC_CIFS: /* 0xFF534D42 */
       return "cifs";
     case S_MAGIC_CODA: /* 0x73757245 */
@@ -235,6 +243,10 @@ human_fstype (STRUCT_STATVFS const *statfsbuf)
       return "coh";
     case S_MAGIC_CRAMFS: /* 0x28CD3D45 */
       return "cramfs";
+    case S_MAGIC_CRAMFS_WEND: /* 0x453DCD28 */
+      return "cramfs-wend";
+    case S_MAGIC_DEBUGFS: /* 0x64626720 */
+      return "debugfs";
     case S_MAGIC_DEVFS: /* 0x1373 */
       return "devfs";
     case S_MAGIC_DEVPTS: /* 0x1CD1 */
@@ -251,12 +263,16 @@ human_fstype (STRUCT_STATVFS const *statfsbuf)
       return "fat";
     case S_MAGIC_FUSECTL: /* 0x65735543 */
       return "fusectl";
+    case S_MAGIC_FUTEXFS: /* 0x0BAD1DEA */
+      return "futexfs";
     case S_MAGIC_HFS: /* 0x4244 */
       return "hfs";
     case S_MAGIC_HPFS: /* 0xF995E849 */
       return "hpfs";
     case S_MAGIC_HUGETLBFS: /* 0x958458F6 */
       return "hugetlbfs";
+    case S_MAGIC_INOTIFYFS: /* 0x2BAD1DEA */
+      return "inotifyfs";
     case S_MAGIC_ISOFS: /* 0x9660 */
       return "isofs";
     case S_MAGIC_ISOFS_R_WIN: /* 0x4004 */
@@ -279,6 +295,8 @@ human_fstype (STRUCT_STATVFS const *statfsbuf)
       return "minix v2";
     case S_MAGIC_MINIX_V2_30: /* 0x2478 */
       return "minix v2 (30 char.)";
+    case S_MAGIC_MINIX_V3: /* 0x4D5A */
+      return "minux3";
     case S_MAGIC_MSDOS: /* 0x4D44 */
       return "msdos";
     case S_MAGIC_NCP: /* 0x564C */
@@ -287,6 +305,8 @@ human_fstype (STRUCT_STATVFS const *statfsbuf)
       return "nfs";
     case S_MAGIC_NFSD: /* 0x6E667364 */
       return "nfsd";
+    case S_MAGIC_NILFS: /* 0x3434 */
+      return "nilfs";
     case S_MAGIC_NTFS: /* 0x5346544E */
       return "ntfs";
     case S_MAGIC_OPENPROM: /* 0x9FA1 */
@@ -301,6 +321,10 @@ human_fstype (STRUCT_STATVFS const *statfsbuf)
       return "reiserfs";
     case S_MAGIC_ROMFS: /* 0x7275 */
       return "romfs";
+    case S_MAGIC_SECURITYFS: /* 0x73636673 */
+      return "securityfs";
+    case S_MAGIC_SELINUX: /* 0xF97CFF8C */
+      return "selinux";
     case S_MAGIC_SMB: /* 0x517B */
       return "smb";
     case S_MAGIC_SQUASHFS: /* 0x73717368 */
@@ -323,6 +347,8 @@ human_fstype (STRUCT_STATVFS const *statfsbuf)
       return "usbdevfs";
     case S_MAGIC_VXFS: /* 0xA501FCF5 */
       return "vxfs";
+    case S_MAGIC_XENFS: /* 0xABBA1974 */
+      return "xenfs";
     case S_MAGIC_XENIX: /* 0x012FF7B4 */
       return "xenix";
     case S_MAGIC_XFS: /* 0x58465342 */
--
1.6.5.rc2.204.g8ea19
