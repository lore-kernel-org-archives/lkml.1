Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbZF2Ipz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbZF2Ipz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 04:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbZF2Ipr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 04:45:47 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:35092 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbZF2Ipq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 04:45:46 -0400
Message-ID: <4A487EB9.7090600@linux.vnet.ibm.com>
Date: Mon, 29 Jun 2009 10:43:37 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       michaele@au1.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] gcov: fix documentation
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

Commonly available versions of cp and tar don't work well with special
files created using seq_file. Mention this problem in the gcov
documentation and update the helper script example to work around
these problems.

Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
---
 Documentation/gcov.txt |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

Index: linux-2.6.31-rc1/Documentation/gcov.txt
===================================================================
--- linux-2.6.31-rc1.orig/Documentation/gcov.txt
+++ linux-2.6.31-rc1/Documentation/gcov.txt
@@ -188,13 +188,18 @@ Solution: Exclude affected source files 
           GCOV_PROFILE := n or GCOV_PROFILE_basename.o := n in the
           corresponding Makefile.
 
+Problem:  Files copied from sysfs appear empty or incomplete.
+Cause:    Due to the way seq_file works, some tools such as cp or tar
+          may not correctly copy files from sysfs.
+Solution: Use 'cat' to read .gcda files and 'cp -d' to copy links.
+          Alternatively use the mechanism shown in Appendix B.
+
 
 Appendix A: gather_on_build.sh
 ==============================
 
 Sample script to gather coverage meta files on the build machine
 (see 6a):
-
 #!/bin/bash
 
 KSRC=$1
@@ -226,7 +231,7 @@ Appendix B: gather_on_test.sh
 Sample script to gather coverage data files on the test machine
 (see 6b):
 
-#!/bin/bash
+#!/bin/bash -e
 
 DEST=$1
 GCDA=/sys/kernel/debug/gcov
@@ -236,11 +241,13 @@ if [ -z "$DEST" ] ; then
   exit 1
 fi
 
-find $GCDA -name '*.gcno' -o -name '*.gcda' | tar cfz $DEST -T -
+TEMPDIR=$(mktemp -d)
+echo Collecting data..
+find $GCDA -type d -exec mkdir -p $TEMPDIR/\{\} \;
+find $GCDA -name '*.gcda' -exec sh -c 'cat < $0 > '$TEMPDIR'/$0' {} \;
+find $GCDA -name '*.gcno' -exec sh -c 'cp -d $0 '$TEMPDIR'/$0' {} \;
+tar czf $DEST -C $TEMPDIR sys
+rm -rf $TEMPDIR
 
-if [ $? -eq 0 ] ; then
-  echo "$DEST successfully created, copy to build system and unpack with:"
-  echo "  tar xfz $DEST"
-else
-  echo "Could not create file $DEST"
-fi
+echo "$DEST successfully created, copy to build system and unpack with:"
+echo "  tar xfz $DEST"

