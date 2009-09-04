Return-Path: <linux-kernel-owner+w=401wt.eu-S1756335AbZIDB0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbZIDB0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 21:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756134AbZIDB0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 21:26:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756093AbZIDB0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 21:26:40 -0400
Date: Thu, 3 Sep 2009 21:25:59 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
       akpm@linux-foundation.org, linux-kbuild@vger.kernel.org,
       Amerigo Wang <amwang@redhat.com>, Sam Ravnborg <sam@ravnborg.org>
Message-Id: <20090904012827.3749.82833.sendpatchset@localhost.localdomain>
In-Reply-To: <20090904012755.3749.69645.sendpatchset@localhost.localdomain>
References: <20090904012755.3749.69645.sendpatchset@localhost.localdomain>
Subject: [Patch 4/5] scripts: add gen_gcov.sh
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add scripts/gen_gcov.sh which will be used by the later patch.
It is used to generate .gcov file from .c file.

Signed-off-by: WANG Cong <amwang@redhat.com>

---
Index: linux-2.6/scripts/gen_gcov.sh
===================================================================
--- /dev/null
+++ linux-2.6/scripts/gen_gcov.sh
@@ -0,0 +1,49 @@
+#!/bin/bash
+# WANG Cong <xiyou.wangcong@gmail.com>
+# GPLv2 applies.
+
+GCOV_BASE=/sys/kernel/debug/gcov$(readlink /lib/modules/`uname -r`/build)
+target=""
+trap  "rm -f *.gcov" INT
+
+function usage()
+{
+	echo "$0 [GCOV_BASE_DIR] target_file.c"
+	echo "The default directory is: /sys/kernel/debug/gcov/path/to/compile."
+}
+
+if [ $# -eq 2 ];
+then
+	GCOV_BASE="$1"
+	target="$2"
+elif [ $# -eq 1 ];
+then
+	target="$1"
+	if [ ! -d "$GCOV_BASE" ];
+	then
+		echo "You have to provide the base directory for gcov." >&2
+		exit 1
+	fi
+else
+	usage
+	exit 1
+fi
+
+if [ ! -f "$target" ];
+then
+	echo "File $target doesn't exist.\n" 1>&2
+	exit 1
+fi
+
+target_base_name=$(basename "$target")
+target_dir_name=$(dirname "$target")
+
+${GCOV} -o "$GCOV_BASE/$target_dir_name" "$target_base_name"
+if [ -f "${target_base_name}.gcov" ];
+then
+	mv *.gcov "$target_dir_name"
+	exit 0
+else
+	exit 1
+fi
+
