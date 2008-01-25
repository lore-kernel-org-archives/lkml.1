Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbYAYFTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbYAYFTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 00:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbYAYFTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 00:19:06 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:55686 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbYAYFTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 00:19:05 -0500
Message-ID: <47997130.6010202@ak.jp.nec.com>
Date: Fri, 25 Jan 2008 14:18:40 +0900
From: Kohei KaiGai <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: morgan@kernel.org
CC: akpm@osdl.org, serue@us.ibm.com, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH 3/3] exporting capability code/name pairs (try 2nd)
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can apply this patch to libcap.

This patch enables setcap command to print the list
of capabilities running kernel supported, if the kernel
exports capability code/name pairs.
It is useful to confirm the name of capability when setting.

Thanks,
----
Signed-off-by: KaiGai Kohei <kaigai@ak.jp.nec.com>

diff --git a/progs/setcap.c b/progs/setcap.c
index dc13c06..1b9ed45 100644
--- a/progs/setcap.c
+++ b/progs/setcap.c
@@ -4,6 +4,7 @@
  * This sets the capabilities of a given file.
  */

+#include <dirent.h>
 #include <errno.h>
 #include <stdio.h>
 #include <string.h>
@@ -13,10 +14,34 @@

 static void usage(void)
 {
+    DIR *dirp;
+
     fprintf(stderr,
 	    "usage: setcap [-q] (-r|-|<caps>) <filename> "
 	    "[ ... (-r|-|<capsN>) <filenameN> ]\n"
 	);
+
+    dirp = opendir("/sys/kernel/capability");
+    if (dirp) {
+	struct dirent *dent;
+	int len, width = 99999;
+
+	fprintf(stderr,
+		"\nsupported capabilities:");
+	while ((dent = readdir(dirp)) != NULL) {
+	    if (!!strncmp("cap_", dent->d_name, 4))
+		continue;
+	    len = strlen(dent->d_name);
+	    if (width + len > 72) {
+		fprintf(stderr, "\n\t");
+		width = 8;
+	    }
+	    fprintf(stderr, "%s ", dent->d_name);
+	    width += len;
+	}
+	fputc('\n', stderr);
+	closedir(dirp);
+    }
     exit(1);
 }


-- 
OSS Platform Development Division, NEC
KaiGai Kohei <kaigai@ak.jp.nec.com>
