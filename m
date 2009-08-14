Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbZHNFjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbZHNFjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 01:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbZHNFjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 01:39:45 -0400
Received: from mail.atheros.com ([12.36.123.2]:18162 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbZHNFjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 01:39:44 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <devel@driverdev.osuosl.org>,
       <mcgrof@gmail.com>, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Julia Lawall <julia@diku.dk>, Joe Perches <joe@perches.com>,
       Nicolas Palix <npalix@diku.dk>,
       Yoann Padioleau <yoann.padioleau@gmail.com>
Subject: [PATCH v2] scripts: add typdef removal tool
Date: Thu, 13 Aug 2009 22:39:44 -0700
Message-ID: <1250228384-19823-1-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you are porting drivers and need to remove tydpefs you can use
this to help you port the driver faster. Until we don't have a fully
correct and complete way to do this through Coccinelle spatch we
might as well help developers porting drivers with something. spatch
also has a learning curve, people working on staging may not end
up using it for a while.

Cc: Julia Lawall <julia@diku.dk>
Cc: Joe Perches <joe@perches.com>
Cc: Nicolas Palix <npalix@diku.dk>
Cc: Yoann Padioleau <yoann.padioleau@gmail.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

 scripts/remove-typedef |   70 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 70 insertions(+), 0 deletions(-)
 create mode 100755 scripts/remove-typedef

diff --git a/scripts/remove-typedef b/scripts/remove-typedef
new file mode 100755
index 0000000..17b8034
--- /dev/null
+++ b/scripts/remove-typedef
@@ -0,0 +1,70 @@
+#!/bin/bash
+#
+# Copyright 2009 Joe Perches <joe@perches.com>
+# Copyright 2009 Luis R. Rodriguez <mcgrof@gmail.com>
+#
+# Lets you remove typedefs from C/header files.
+#
+# We do simple sed substituation for logical places where you would
+# use the typedef, and also replace the typedef declaration to a simple
+# struct declaration.
+
+function usage()
+{
+	echo "Usage $0 <typedef-name> <struct-name> <paths>"
+	exit 1
+}
+
+function remove_typedef()
+{
+	if [ ! -f $1 ]; then
+		return;
+	fi
+
+	# This replaces the typedef usages with simple structs
+	sed -r -i -e "s/\b$from\b/struct $to/g" $1
+	sed -r -i -e "s/\bP$from\b/struct $to \*/g" $1
+	sed -r -i -e "s/struct $to\s*\*\s*\b/struct $to \*/g" $1
+	sed -r -i -e "s/\(struct $to\s*\*\)\s*/\(struct $to \*\)/g" $1
+
+	# This replaces the typedef declaration for a simple struct declaration - style 0
+	perl -i -e "local $/; while(<>) { s/\btypedef\s+struct\s+([\d\D]+?)\s*\{([\d\D]+?)\}\s*struct\s+$to\b[^;]*;/struct $to \{\2\};/g; print; }" $1
+
+	# This replaces the typedef declaration for a simple struct declaration - style 1
+	perl -i -e "local $/; while(<>) { s/\btypedef\s+struct\s+_$from\s*\{([\d\D]+?)\}\s*struct\s+$to\b[^;]*;/struct $to \{\1\};/g; print; }" $1
+
+	# This replaces the typedef declaration for a simple struct declaration - style 2
+	perl -i -e "local $/; while(<>) { s/\btypedef\s+struct\s+$to\s*\{([\d\D]+?)\}\s*$from\b[^;]*;/struct $to \{\1\};/g; print; }" $1
+
+}
+
+if [[ $# -lt 3 ]]; then
+	usage
+fi
+
+from=$1
+to=$2
+shift
+
+echo "Converting typedef $from to struct $to"
+
+while shift; do
+	REM_PATH=$1
+
+	if [ -z $REM_PATH ]; then
+		continue;
+	fi
+
+	if [ ! -d $REM_PATH ]; then
+		echo "No directory $REM_PATH";
+		continue;
+	fi
+
+	for i in $(find $REM_PATH -type f -name *.c); do
+		remove_typedef $i
+	done
+
+	for i in $(find $REM_PATH -type f -name *.h); do
+		remove_typedef $i
+	done
+done
-- 
1.6.3.3

