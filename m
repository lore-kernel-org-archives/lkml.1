Return-Path: <linux-kernel-owner+w=401wt.eu-S965443AbXBFBXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965443AbXBFBXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 20:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965444AbXBFBXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 20:23:32 -0500
Received: from raven.upol.cz ([158.194.120.4]:52437 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965443AbXBFBXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 20:23:23 -0500
Message-Id: <20070206012207.805083000@flower.upol.cz>
References: <20070206011819.160359000@flower.upol.cz>
User-Agent: jed + quilt/0.45-1
X-Mailer: formail (procmail)
Date: Tue, 06 Feb 2007 02:18:20 +0100
From: Oleg Verych <olecom@flower.upol.cz>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesper Juhl <jesper.juhl@gmail.com>, Roman Zippel <zippel@linux-m68k.org>,
       Sam Ravnborg <sam@ravnborg.org>, William Stearns <wstearns@pobox.com>,
       Martin Schlemmer <azarah@nosferatu.za.org>
Subject: [patch 1/3, resend] scripts: replace gawk, head, bc with shell, update
Content-Disposition: inline; filename=scripts-replace-gawk-and-by-shell-with-some-cleanup_update.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

scripts: replace gawk, head, bc with shell, update

  Replacing overhead of using some (external) programs
  instead of good old `sh'.

Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: William Stearns <wstearns@pobox.com>
Cc: Martin Schlemmer <azarah@nosferatu.za.org>
Signed-off-by: Oleg Verych <olecom@flower.upol.cz>
---

 Whitespace cleanup included.

 scripts/gen_initramfs_list.sh | 43 +++++++++++++++++++++---------------------
 scripts/makelst               | 34 ++++++++++++++++-----------------
 2 files changed, 39 insertions(+), 38 deletions(-)

Index: linux-2.6.20/scripts/makelst
===================================================================
--- linux-2.6.20.orig/scripts/makelst	2007-02-06 02:12:38.811908000 +0100
+++ linux-2.6.20/scripts/makelst	2007-02-06 02:12:43.688212750 +0100
@@ -1,31 +1,31 @@
-#!/bin/bash
+#!/bin/sh
 # A script to dump mixed source code & assembly
 # with correct relocations from System.map
-# Requires the following lines in Rules.make.
-# Author(s): DJ Barrow (djbarrow@de.ibm.com,barrow_dj@yahoo.com) 
-#            William Stearns <wstearns@pobox.com>
+# Requires the following lines in makefile:
 #%.lst: %.c
 #	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(CFLAGS_$@) -g -c -o $*.o $<
-#	$(TOPDIR)/scripts/makelst $*.o $(TOPDIR)/System.map $(OBJDUMP)
+#	$(srctree)/scripts/makelst $*.o $(objtree)/System.map $(OBJDUMP)
 #
-#    Copyright (C) 2000 IBM Corporation
-#    Author(s): DJ Barrow (djbarrow@de.ibm.com,barrow_dj@yahoo.com) 
+# Copyright (C) 2000 IBM Corporation
+# Author(s): DJ Barrow (djbarrow@de.ibm.com,barrow_dj@yahoo.com)
+#            William Stearns <wstearns@pobox.com>
 #
 
-t1=`$3 --syms $1 | grep .text | grep " F " | head -n 1`
+# awk style field access
+field() {
+  shift $1 ; echo $1
+}
+
+t1=`$3 --syms $1 | grep .text | grep -m1 " F "`
 if [ -n "$t1" ]; then
-  t2=`echo $t1 | gawk '{ print $6 }'`
+  t2=`field 6 $t1`
   if [ ! -r $2 ]; then
     echo "No System.map" >&2
-    t7=0
   else
     t3=`grep $t2 $2`
-    t4=`echo $t3 | gawk '{ print $1 }'`
-    t5=`echo $t1 | gawk '{ print $1 }'`
-    t6=`echo $t4 - $t5 | tr a-f A-F`
-    t7=`( echo  ibase=16 ; echo $t6 ) | bc`
+    t4=`field 1 $t3`
+    t5=`field 1 $t1`
+    t6=`printf "%lu" $((0x$t4 - 0x$t5))`
   fi
-else
-  t7=0
 fi
-$3 -r --source --adjust-vma=$t7 $1
+$3 -r --source --adjust-vma=${t6:-0} $1
Index: linux-2.6.20/scripts/gen_initramfs_list.sh
===================================================================
--- linux-2.6.20.orig/scripts/gen_initramfs_list.sh	2007-02-06 02:12:38.819908500 +0100
+++ linux-2.6.20/scripts/gen_initramfs_list.sh	2007-02-06 02:12:43.688212750 +0100
@@ -1,5 +1,5 @@
 #!/bin/bash
 # Copyright (C) Martin Schlemmer <azarah@nosferatu.za.org>
-# Copyright (c) 2006           Sam Ravnborg <sam@ravnborg.org>
+# Copyright (C) 2006 Sam Ravnborg <sam@ravnborg.org>
 #
 # Released under the terms of the GNU GPL
@@ -18,13 +18,13 @@ Usage:
 $0 [-o <file>] [-u <uid>] [-g <gid>] {-d | <cpio_source>} ...
 	-o <file>      Create gzipped initramfs file named <file> using
-	               gen_init_cpio and gzip
+		       gen_init_cpio and gzip
 	-u <uid>       User ID to map to user ID 0 (root).
-	               <uid> is only meaningful if <cpio_source>
-	               is a directory.
+		       <uid> is only meaningful if <cpio_source>
+		       is a directory.
 	-g <gid>       Group ID to map to group ID 0 (root).
-	               <gid> is only meaningful if <cpio_source>
-	               is a directory.
+		       <gid> is only meaningful if <cpio_source>
+		       is a directory.
 	<cpio_source>  File list or directory for cpio archive.
-	               If <cpio_source> is a .cpio file it will be used
+		       If <cpio_source> is a .cpio file it will be used
 		       as direct input to initramfs.
 	-d             Output the default cpio list.
@@ -37,4 +37,10 @@ EOF
 }
 
+# awk style field access
+# $1 - field number; rest is argument string
+field() {
+	shift $1 ; echo $1
+}
+
 list_default_initramfs() {
 	# echo usr/kinit/kinit
@@ -120,20 +126,15 @@ parse() {
 			;;
 		"nod")
-			local dev_type=
-			local maj=$(LC_ALL=C ls -l "${location}" | \
-					gawk '{sub(/,/, "", $5); print $5}')
-			local min=$(LC_ALL=C ls -l "${location}" | \
-					gawk '{print $6}')
-
-			if [ -b "${location}" ]; then
-				dev_type="b"
-			else
-				dev_type="c"
-			fi
-			str="${ftype} ${name} ${str} ${dev_type} ${maj} ${min}"
+			local dev=`LC_ALL=C ls -l "${location}"`
+			local maj=`field 5 ${dev}`
+			local min=`field 6 ${dev}`
+			maj=${maj%,}
+
+			[ -b "${location}" ] && dev="b" || dev="c"
+
+			str="${ftype} ${name} ${str} ${dev} ${maj} ${min}"
 			;;
 		"slink")
-			local target=$(LC_ALL=C ls -l "${location}" | \
-					gawk '{print $11}')
+			local target=`field 11 $(LC_ALL=C ls -l "${location}")`
 			str="${ftype} ${name} ${target} ${str}"
 			;;

--

