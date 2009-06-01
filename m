Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbZFATXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbZFATXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 15:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbZFATXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 15:23:11 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:21685 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbZFATXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 15:23:10 -0400
X-IronPort-AV: E=Sophos;i="4.41,285,1241409600"; 
   d="scan'208";a="1935502"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Sam Ravnborg" <sam@ravnborg.org>,
       "Bernhard Reutner-Fischer" <rep.dot.nop@gmail.com>,
       "Denis Vlasenko" <vda.linux@googlemail.com>,
       "Rob Landley" <rob@landley.net>
Subject: [PATCH] update kernel's scripts/bloat-o-meter from busybox
Date: Mon, 1 Jun 2009 15:26:00 -0400
User-Agent: KMail/1.9.5
CC: "Matt Mackall" <mpm@selenic.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200906011526.01108.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 01 Jun 2009 19:23:09.0659 (UTC) FILETIME=[65E85AB0:01C9E2EE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rob Landley" <rob@landley.net>
From: "Denis Vlasenko" <vda.linux@googlemail.com>
From: "Bernhard Reutner-Fischer" <rep.dot.nop@gmail.com>

Since bloat-o-meter was added to the kernel's source tree, it has received 
little attention - either it works really well - or no one uses it. I suspect 
the first :)

However - some folks who have been using it more (mainly as part of busybox) 
have been poking at it more often - and the output is a little more friendly 
now.

http://git.busybox.net/busybox/log/scripts/bloat-o-meter

I think Rob had been sending early patches both places, but somewhere along 
the line things never made it to lkml.

Acked-by: Robin Getz <rgetz@blackfin.uclinux.org>

---
Since none of this is from me, I can only add my Acked by. Bernhard, Denis, 
and Rob will need to add their Signed-off-by separately.

----


 bloat-o-meter |   37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)



Index: scripts/bloat-o-meter
===================================================================
--- scripts/bloat-o-meter	(revision 6437)
+++ scripts/bloat-o-meter	(working copy)
@@ -9,18 +9,37 @@
 
 import sys, os, re
 
-if len(sys.argv) != 3:
+def usage():
     sys.stderr.write("usage: %s file1 file2\n" % sys.argv[0])
     sys.exit(-1)
 
+if len(sys.argv) < 3:
+    usage()
+
+for f in sys.argv[1], sys.argv[2]:
+    if not os.path.exists(f):
+        sys.stderr.write("Error: file '%s' does not exist\n" % f)
+        usage()
+
+nm_args = " ".join([x for x in sys.argv[3:]])
 def getsizes(file):
     sym = {}
-    for l in os.popen("nm --size-sort " + file).readlines():
-        size, type, name = l[:-1].split()
-        if type in "tTdDbB":
+    for l in os.popen("nm --size-sort %s %s" % (nm_args, file)).readlines():
+    	l = l.strip()
+	# Skip empty lines
+        if not len(l): continue
+	# Skip archive members
+        if len(l.split()) == 1 and l.endswith(':'):
+          continue
+        size, type, name = l.split()
+        if type in "tTdDbBrR":
             # function names begin with '.' on 64-bit powerpc
             if "." in name[1:]: name = "static." + name.split(".")[0]
             sym[name] = sym.get(name, 0) + int(size, 16)
+    for l in os.popen("readelf -S " + file).readlines():
+        x = l.split()
+        if len(x)<6 or x[1] != ".rodata": continue
+        sym[".rodata"] = int(x[5], 16)
     return sym
 
 old = getsizes(sys.argv[1])
@@ -53,8 +72,10 @@
 delta.sort()
 delta.reverse()
 
-print "add/remove: %s/%s grow/shrink: %s/%s up/down: %s/%s (%s)" % \
-      (add, remove, grow, shrink, up, -down, up-down)
-print "%-40s %7s %7s %+7s" % ("function", "old", "new", "delta")
+print "%-48s %7s %7s %+7s" % ("function", "old", "new", "delta")
 for d, n in delta:
-    if d: print "%-40s %7s %7s %+7d" % (n, old.get(n,"-"), new.get(n,"-"), d)
+    if d: print "%-48s %7s %7s %+7d" % (n, old.get(n,"-"), new.get(n,"-"), d)
+print "-"*78
+total="(add/remove: %s/%s grow/shrink: %s/%s up/down: %s/%s)%%sTotal: %s 
bytes"\
+    % (add, remove, grow, shrink, up, -down, up-down)
+print total % (" "*(80-len(total)))

