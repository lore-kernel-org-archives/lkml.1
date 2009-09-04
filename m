Return-Path: <linux-kernel-owner+w=401wt.eu-S932372AbZIDB0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372AbZIDB0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 21:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932323AbZIDB0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 21:26:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932309AbZIDB01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 21:26:27 -0400
Date: Thu, 3 Sep 2009 21:25:51 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Amerigo Wang <amwang@redhat.com>,
       Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
       akpm@linux-foundation.org, Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild@vger.kernel.org
Message-Id: <20090904012819.3749.33913.sendpatchset@localhost.localdomain>
In-Reply-To: <20090904012755.3749.69645.sendpatchset@localhost.localdomain>
References: <20090904012755.3749.69645.sendpatchset@localhost.localdomain>
Subject: [Patch 3/5] doc: move the scripts in gcov.txt to tools/gcov/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Move the two bash scripts in gcov.txt into tools/gcov/,
so that we can use them directly.

Signed-off-by: WANG Cong <amwang@redhat.com>

---
Index: linux-2.6/Documentation/gcov.txt
===================================================================
--- linux-2.6.orig/Documentation/gcov.txt
+++ linux-2.6/Documentation/gcov.txt
@@ -8,8 +8,6 @@ Using gcov with the Linux kernel
 5. Modules
 6. Separated build and test machines
 7. Troubleshooting
-Appendix A: sample script: gather_on_build.sh
-Appendix B: sample script: gather_on_test.sh
 
 
 1. Introduction
@@ -155,6 +153,8 @@ exact same file system location on the t
 machine. If any of the path components is symbolic link, the actual
 directory needs to be used instead (due to make's CURDIR handling).
 
+Try tools/gcov/gather_on_build.sh.
+
 b) gcov is run on the BUILD machine
 
 The following files need to be copied after each test case from test
@@ -167,6 +167,8 @@ from the gcov directory in sysfs:
 These files can be copied to any location on the build machine. gcov
 must then be called with the -o option pointing to that directory.
 
+Try tools/gcov/gather_on_test.sh.
+
 Example directory setup on the build machine:
 
   /tmp/linux:    kernel source tree
@@ -192,62 +194,6 @@ Problem:  Files copied from sysfs appear
 Cause:    Due to the way seq_file works, some tools such as cp or tar
           may not correctly copy files from sysfs.
 Solution: Use 'cat' to read .gcda files and 'cp -d' to copy links.
-          Alternatively use the mechanism shown in Appendix B.
-
-
-Appendix A: gather_on_build.sh
-==============================
-
-Sample script to gather coverage meta files on the build machine
-(see 6a):
-#!/bin/bash
-
-KSRC=$1
-KOBJ=$2
-DEST=$3
-
-if [ -z "$KSRC" ] || [ -z "$KOBJ" ] || [ -z "$DEST" ]; then
-  echo "Usage: $0 <ksrc directory> <kobj directory> <output.tar.gz>" >&2
-  exit 1
-fi
-
-KSRC=$(cd $KSRC; printf "all:\n\t@echo \${CURDIR}\n" | make -f -)
-KOBJ=$(cd $KOBJ; printf "all:\n\t@echo \${CURDIR}\n" | make -f -)
-
-find $KSRC $KOBJ \( -name '*.gcno' -o -name '*.[ch]' -o -type l \) -a \
-                 -perm /u+r,g+r | tar cfz $DEST -P -T -
-
-if [ $? -eq 0 ] ; then
-  echo "$DEST successfully created, copy to test system and unpack with:"
-  echo "  tar xfz $DEST -P"
-else
-  echo "Could not create file $DEST"
-fi
-
-
-Appendix B: gather_on_test.sh
-=============================
-
-Sample script to gather coverage data files on the test machine
-(see 6b):
-
-#!/bin/bash -e
-
-DEST=$1
-GCDA=/sys/kernel/debug/gcov
-
-if [ -z "$DEST" ] ; then
-  echo "Usage: $0 <output.tar.gz>" >&2
-  exit 1
-fi
-
-TEMPDIR=$(mktemp -d)
-echo Collecting data..
-find $GCDA -type d -exec mkdir -p $TEMPDIR/\{\} \;
-find $GCDA -name '*.gcda' -exec sh -c 'cat < $0 > '$TEMPDIR'/$0' {} \;
-find $GCDA -name '*.gcno' -exec sh -c 'cp -d $0 '$TEMPDIR'/$0' {} \;
-tar czf $DEST -C $TEMPDIR sys
-rm -rf $TEMPDIR
+          Alternatively use the mechanism shown in
+          tools/gcov/gather_on_test.sh.
 
-echo "$DEST successfully created, copy to build system and unpack with:"
-echo "  tar xfz $DEST"
Index: linux-2.6/tools/gcov/gather_on_build.sh
===================================================================
--- /dev/null
+++ linux-2.6/tools/gcov/gather_on_build.sh
@@ -0,0 +1,24 @@
+#!/bin/bash
+
+KSRC=$1
+KOBJ=$2
+DEST=$3
+
+if [ -z "$KSRC" ] || [ -z "$KOBJ" ] || [ -z "$DEST" ]; then
+  echo "Usage: $0 <ksrc directory> <kobj directory> <output.tar.gz>" >&2
+  exit 1
+fi
+
+KSRC=$(cd $KSRC; printf "all:\n\t@echo \${CURDIR}\n" | make -f -)
+KOBJ=$(cd $KOBJ; printf "all:\n\t@echo \${CURDIR}\n" | make -f -)
+
+find $KSRC $KOBJ \( -name '*.gcno' -o -name '*.[ch]' -o -type l \) -a \
+                 -perm /u+r,g+r | tar cfz $DEST -P -T -
+
+if [ $? -eq 0 ] ; then
+  echo "$DEST successfully created, copy to test system and unpack with:"
+  echo "  tar xfz $DEST -P"
+else
+  echo "Could not create file $DEST"
+fi
+
Index: linux-2.6/tools/gcov/gather_on_test.sh
===================================================================
--- /dev/null
+++ linux-2.6/tools/gcov/gather_on_test.sh
@@ -0,0 +1,20 @@
+#!/bin/bash -e
+
+DEST=$1
+GCDA=/sys/kernel/debug/gcov
+
+if [ -z "$DEST" ] ; then
+  echo "Usage: $0 <output.tar.gz>" >&2
+  exit 1
+fi
+
+TEMPDIR=$(mktemp -d)
+echo Collecting data..
+find $GCDA -type d -exec mkdir -p $TEMPDIR/\{\} \;
+find $GCDA -name '*.gcda' -exec sh -c 'cat < $0 > '$TEMPDIR'/$0' {} \;
+find $GCDA -name '*.gcno' -exec sh -c 'cp -d $0 '$TEMPDIR'/$0' {} \;
+tar czf $DEST -C $TEMPDIR sys
+rm -rf $TEMPDIR
+
+echo "$DEST successfully created, copy to build system and unpack with:"
+echo "  tar xfz $DEST"
