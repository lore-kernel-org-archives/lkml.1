Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbYFKA2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbYFKA2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 20:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407AbYFKA14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 20:27:56 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:38498 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbYFKA1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 20:27:54 -0400
X-BigFish: VPS-30(zz1435N1432R98dR1805Mzz10d3izzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <484F1B8F.9000804@am.sony.com>
Date: Tue, 10 Jun 2008 17:25:51 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] add diffconfig utility
References: <484ED902.9040000@am.sony.com> <20080610212158.GB23855@uranus.ravnborg.org>
In-Reply-To: <20080610212158.GB23855@uranus.ravnborg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jun 2008 00:27:42.0021 (UTC) FILETIME=[F6068750:01C8CB59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> I know this is unix style to be very short in usage - but then they 
> have man pages.
> Could we add a bit more from the nice description above to usage?
Good idea.  Might as well make it visible.

David Woodhouse wrote:
> It'd be really nice if it could give its output in the same form as
> the .config file itself -- so it'd look something like:
> 
> # CONFIG_FOO is not set
> CONFIG_BAR=y

OK, a new version is below.  Right now, when printing in "merge" style,
the code omits items that are absent in the new config.  These should get set
correctly (removed) if you do a 'make oldconfig'.  It would be trivial
to have them output as well, if you think that would be better.

I am experimentally trying to attach a git-style file mode
to this patch.  I did this by hand, so it might not work.
(The index line is totally made up). Let me know if there are problems.

Diffconfig is a simple utility for comparing two .config files.
See usage in the script for more info.

Signed-off-by: Tim Bird <tim.bird@am.sony.com>

 scripts/diffconfig |  108 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 108 insertions(+)
 create mode 100755 scripts/diffconfig

diff --git a/scripts/diffconfig b/scripts/diffconfig
new file mode 100755
index 0000000..aa6cfe1
--- /dev/null
+++ b/scripts/diffconfig
@@ -0,0 +1,108 @@
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
+merge_style = 0
+if "-m" in sys.argv:
+    merge_style = 1
+    sys.argv.remove("-m")
+
+if "-h" in sys.argv or len(sys.argv) < 3:
+    print "Usage: diffconfig [-h] [-m] <config1> <config2>\n"
+    print """Diffconfig is a simple utility for comparing two .config files.
+Using standard diff to compare .config files often includes
+extraneous and distracting information.  This utility produces
+sorted output with only the changes in configuration values
+between the two files.
+
+Added and removed items are shown with a leading plus or minus,
+respectively.  Changed items show the old and new values on a
+single line.
+
+If -m is specified, then output will be in "merge" style,
+which has the changed and new values in kernel config option format.
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
+a = readconfig(file(sys.argv[1]))
+b = readconfig(file(sys.argv[2]))
+
+def print_config(op, config, value, new_value):
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
+# print items in a but not b (accumulate, sort and print)
+old = []
+for config in a:
+    if config not in b:
+        old.append(config)
+
+old.sort()
+
+for config in old:
+    print_config("-", config, a[config], None)
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
+    print_config("->", config, a[config], b[config])
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
+    print_config("+", config, None, b[config])


