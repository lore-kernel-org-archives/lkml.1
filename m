Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbZHKWvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbZHKWvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 18:51:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbZHKWvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 18:51:03 -0400
Received: from mail.atheros.com ([12.36.123.2]:57060 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917AbZHKWvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 18:51:02 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <devel@driverdev.osuosl.org>,
       <joe@perches.com>, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] scripts: add typdef removal tool
Date: Tue, 11 Aug 2009 15:51:01 -0700
Message-ID: <1250031061-16327-1-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you are porting drivers and need to remove tydpefs you can use
this to help you port the driver quicker.

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 scripts/remove-typedefs |   65 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 65 insertions(+), 0 deletions(-)
 create mode 100755 scripts/remove-typedefs

diff --git a/scripts/remove-typedefs b/scripts/remove-typedefs
new file mode 100755
index 0000000..ae6952c
--- /dev/null
+++ b/scripts/remove-typedefs
@@ -0,0 +1,65 @@
+#!/bin/bash
+#
+# Copyright 2009 Joe Perches <joe@perches.com>
+# Copyright 2009 Luis R. Rodriguez <mcgrof@gmail.com>
+#
+# Lets you remove typdefs from C/header files.
+#
+# We do simple sed substituation for logical places where you would use the typdef,
+# and also replace the typdef declaration to a simple struct declaration.
+
+function usage()
+{
+	echo "Usage $0 <typdef-name> <struct-name> <paths>"
+	exit 1
+}
+
+function remove_typedef()
+{
+	if [ ! -f $1 ]; then
+		return;
+	fi
+
+	# This replaces the typdef declaration for a simple struct declaration - style 1
+	perl -i -e "local $/; while(<>) { s/\btypedef\s+struct\s+_$from\s*\{([\d\D]+?)\}\s*struct\s+$to\b[^;]*;/struct $to \{\1\};/g; print; }" $1
+
+	# This replaces the typdef declaration for a simple struct declaration - style 2
+	perl -i -e "local $/; while(<>) { s/\btypedef\s+struct\s+$to\s*\{([\d\D]+?)\}\s*$from\b[^;]*;/struct $to \{\1\};/g; print; }" $1
+
+	# This replaces the typdef usages with simple structs
+	sed -r -i -e "s/\b$from\b/struct $to/g" $1
+	sed -r -i -e "s/\bP$from\b/struct $to \*/g" $1
+	sed -r -i -e "s/struct $to\s*\*\s*\b/struct $to \*/g" $1
+	sed -r -i -e "s/\(struct $to\s*\*\)\s*/\(struct $to \*\)/g" $1
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

