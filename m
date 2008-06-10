Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbYFJToR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbYFJToR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 15:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753752AbYFJToB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 15:44:01 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:19540 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbYFJToA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 15:44:00 -0400
X-BigFish: VPS-13(zz7efVzz10d3izzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <484ED902.9040000@am.sony.com>
Date: Tue, 10 Jun 2008 12:41:54 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-embedded <linux-embedded@vger.kernel.org>
CC: linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] add diffconfig utility
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Jun 2008 19:43:42.0779 (UTC) FILETIME=[49D888B0:01C8CB32]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diffconfig is a simple utility for comparing two .config files.
Using standard diff to compare .config files often includes
extraneous and distracting information.  This utility produces
sorted output with only the changes in configuration values
between the two files.

I have found this handy for use in testing to
detect when option dependencies unexpectedly affect
other options.

To use, apply the patch and 'chmod a+x scripts/diffconfig'

Signed-off-by: Tim Bird <tim.bird@am.sony.com>

 diffconfig |   90 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 90 insertions(+)

--- linux-2.6.24.orig/scripts/diffconfig	1969-12-31 16:00:00.000000000 -0800
+++ test-linux/scripts/diffconfig	2008-06-10 12:11:14.000000000 -0700
@@ -0,0 +1,90 @@
+#!/usr/bin/python
+#
+# diffconfig - a tool to compare .config files.
+#
+# originally written in 2006 by Matt Mackall
+#  (at least, this was in his bloatwatch source code)
+#
+# diffconfig is a simple utility for comparing two .config files.
+# Using standard diff to compare .config files often includes
+# extraneous and distracting information.  This utility produces
+# sorted output with only the changes in configuration values
+# between the two files.
+#
+# Added and removed items are shown with a leading plus or minus,
+# respectively.  Changed items show the old and new values on a
+# single line.
+#
+# Example usage:
+# $ diffconfig .config config-test-nfs-off
+# -LOCKD  y
+# -LOCKD_V4  y
+# -NFS_COMMON  y
+# -NFS_DIRECTIO  n
+# -NFS_V3  y
+# -NFS_V3_ACL  n
+# -NFS_V4  n
+# -ROOT_NFS  y
+# -RPCSEC_GSS_KRB5  n
+# -RPCSEC_GSS_SPKM3  n
+# -SUNRPC  y
+# -SUNRPC_BIND34  n
+#  NFS_FS  y -> n
+
+import sys, os
+
+if len(sys.argv) < 3:
+	print "Usage: diffconfig <config1> <config2>"
+	sys.exit(0)
+
+# returns a dictionary of name/value pairs for config items in the file
+def readconfig(config_file):
+    d = {}
+    for line in config_file:
+        line = line[:-1]
+        if line[:7] == "CONFIG_":
+            name, val = line[7:].split("=", 1)
+            d[name] = val
+        if line[-11:] == " is not set":
+            d[line[9:-11]] = "n"
+    return d
+
+a = readconfig(file(sys.argv[1]))
+b = readconfig(file(sys.argv[2]))
+
+# print items in a but not b (accumulate, sort and print)
+old = []
+for config in a:
+    if config not in b:
+        old.append(config)
+
+old.sort()
+
+for config in old:
+    print "-%s  %s" % (config, a[config])
+    del a[config]
+
+# print items that changed (accumulate, sort, and print)
+changed = []
+for config in a:
+    if a[config] != b[config]:
+        changed.append(config)
+    else:
+        del b[config]
+
+changed.sort()
+
+for config in changed:
+    print " %s  %s -> %s" % (config, a[config], b[config])
+    del b[config]
+
+# now print items in b but not in a
+
+# the items from b that were in a (either the same or that changed) were removed
+# the only items left were not in a
+new = b.keys()
+
+new.sort()
+
+for config in new:
+    print "+%s  %s" % (config, b[config])

