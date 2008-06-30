Return-Path: <linux-kernel-owner+w=401wt.eu-S933361AbYF3Vjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933361AbYF3Vjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932897AbYF3Veq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:34:46 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:48264 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932089AbYF3Vef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:34:35 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Tim Bird <tim.bird@am.sony.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 19/24] kconfig: add diffconfig utility
Date: Mon, 30 Jun 2008 23:35:13 +0200
Message-Id: <1214861718-32626-19-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.6.1.93.gef98
In-Reply-To: <20080630213155.GA32479@uranus.ravnborg.org>
References: <20080630213155.GA32479@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Bird <tim.bird@am.sony.com>

Diffconfig is a simple utility for comparing two kernel configuration files.
See usage in the script for more info.

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/diffconfig |  129 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 129 insertions(+), 0 deletions(-)
 create mode 100755 scripts/diffconfig

diff --git a/scripts/diffconfig b/scripts/diffconfig
new file mode 100755
index 0000000..b91f3e3
--- /dev/null
+++ b/scripts/diffconfig
@@ -0,0 +1,129 @@
+#!/usr/bin/python
+#
+# diffconfig - a tool to compare .config files.
+#
+# originally written in 2006 by Matt Mackall
+#  (at least, this was in his bloatwatch source code)
+# last worked on 2008 by Tim Bird
+#
+
+import sys, os
+
+def usage():
+    print """Usage: diffconfig [-h] [-m] [<config1> <config2>]
+
+Diffconfig is a simple utility for comparing two .config files.
+Using standard diff to compare .config files often includes extraneous and
+distracting information.  This utility produces sorted output with only the
+changes in configuration values between the two files.
+
+Added and removed items are shown with a leading plus or minus, respectively.
+Changed items show the old and new values on a single line.
+
+If -m is specified, then output will be in "merge" style, which has the
+changed and new values in kernel config option format.
+
+If no config files are specified, .config and .config.old are used.
+
+Example usage:
+ $ diffconfig .config config-with-some-changes
+-EXT2_FS_XATTR  n
+-EXT2_FS_XIP  n
+ CRAMFS  n -> y
+ EXT2_FS  y -> n
+ LOG_BUF_SHIFT  14 -> 16
+ PRINTK_TIME  n -> y
+"""
+    sys.exit(0)
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
+def print_config(op, config, value, new_value):
+    global merge_style
+
+    if merge_style:
+        if new_value:
+            if new_value=="n":
+                print "# CONFIG_%s is not set" % config
+            else:
+                print "CONFIG_%s=%s" % (config, new_value)
+    else:
+        if op=="-":
+            print "-%s %s" % (config, value)
+        elif op=="+":
+            print "+%s %s" % (config, new_value)
+        else:
+            print " %s %s -> %s" % (config, value, new_value)
+
+def main():
+    global merge_style
+
+    # parse command line args
+    if ("-h" in sys.argv or "--help" in sys.argv):
+	usage()
+
+    merge_style = 0
+    if "-m" in sys.argv:
+        merge_style = 1
+        sys.argv.remove("-m")
+
+    argc = len(sys.argv)
+    if not (argc==1 or argc == 3):
+        print "Error: incorrect number of arguments or unrecognized option"
+        usage()
+
+    if argc == 1:
+        # if no filenames given, assume .config and .config.old
+        build_dir=""
+        if os.environ.has_key("KBUILD_OUTPUT"):
+            build_dir = os.environ["KBUILD_OUTPUT"]+"/"
+
+        configa_filename = build_dir + ".config.old"
+        configb_filename = build_dir + ".config"
+    else:
+        configa_filename = sys.argv[1]
+        configb_filename = sys.argv[2]
+
+    a = readconfig(file(configa_filename))
+    b = readconfig(file(configb_filename))
+
+    # print items in a but not b (accumulate, sort and print)
+    old = []
+    for config in a:
+        if config not in b:
+            old.append(config)
+    old.sort()
+    for config in old:
+        print_config("-", config, a[config], None)
+        del a[config]
+
+    # print items that changed (accumulate, sort, and print)
+    changed = []
+    for config in a:
+        if a[config] != b[config]:
+            changed.append(config)
+        else:
+            del b[config]
+    changed.sort()
+    for config in changed:
+        print_config("->", config, a[config], b[config])
+        del b[config]
+
+    # now print items in b but not in a
+    # (items from b that were in a were removed above)
+    new = b.keys()
+    new.sort()
+    for config in new:
+        print_config("+", config, None, b[config])
+
+main()
-- 
1.5.6.1.93.gef98

