Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584AbYJAM0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbYJAM0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 08:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbYJAM0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 08:26:04 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:34639 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752307AbYJAM0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 08:26:03 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@strlen.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ben Dooks <ben-linux@fluff.org>,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@suse.cz>,
       Randy Dunlap <rdunlap@xenotime.net>, Joe Perches <joe@perches.com>
Subject: [PATCH] [RFC] Add a script that searched per-file maintainers for a patch.
Date: Wed,  1 Oct 2008 14:25:54 +0200
Message-Id: <1222863954-13701-1-git-send-email-ukleinek@strlen.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20080929175625.GA3676@ucw.cz>
References: <20080929175625.GA3676@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I assume currently there are no files that have the maintainers noted in
a source file in a way that is understandable by the script, but for
testing you can use scripts/genpatchcc.py itself.  It is meant to be
used with git-send-email --cc-cmd=...

Currently the format to specify a maintainer is

	/*
	 * TOPIC
	 * P: M. Aintainer <ma@intai.ner>
	 * L: some-list@vger.kernel.org
	 */

similar to the format of the MAINTAINERS file.  This has to be specified
in the first comment of a file starting at the file's start.  #-like
comments are supported, too.

---
To test it, apply the patch, and modify scripts/genpatchcc.py.  Then you
can run:

	git diff | scripts/genpatchcc.py

I havn't tested it yet with git-send-email and there are several things
to improve as noted in the comments of the script (and probably more).
And of course some documentation is missing.

Please consider it as a first draft and feel free to comment.

Best regards
Uwe
---
 scripts/genpatchcc.py |   95 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 95 insertions(+), 0 deletions(-)
 create mode 100755 scripts/genpatchcc.py

diff --git a/scripts/genpatchcc.py b/scripts/genpatchcc.py
new file mode 100755
index 0000000..6a757ed
--- /dev/null
+++ b/scripts/genpatchcc.py
@@ -0,0 +1,95 @@
+#! /usr/bin/env python
+# vim: set fileencoding=utf-8
+# (c) Uwe Kleine-König <ukleinek@strlen.de>
+# GPLv2
+#
+# GENPATCHCC
+# P: Uwe Kleine-König <ukleinek@strlen.de>
+
+# wishlist:
+# - support for per-directory '.maintainers' file
+#   when should it be used?  Assume a/b/c/d/file was changed.  The following
+#   files could be used:
+#    * a/b/c/d/.maintainers
+#    * a/b/c/.maintainers
+#    * a/b/.maintainers
+#    * a/.maintainers
+#    * .maintainers
+#   maybe only use the first that exists?  only if the changed file doesn't
+#   have an entry?
+# - (?) option to specify the srcdir
+# - (?) parse the patch if the maintainer entry is changed, use both, old and new version
+# - (?) extract git sha1 sums and parse the objects
+
+import fileinput
+import re
+
+def filename(name):
+    if name[0] == '"':
+        raise NotImplementedError, 'please teach me how to unquote a filename'
+
+    # assume -p1
+    return name[name.index('/') + 1:]
+
+re_changedfile = re.compile(r'(?:---|\+\+\+)\s(?P<file>".*?[^\\]"|[][-^A-Za-z0-9_ !#$%&\'()*+,./:;<=>@?{}~]+)')
+
+changed_files = set()
+
+for line in fileinput.input():
+    mo = re_changedfile.match(line)
+    if mo:
+        changed_files.add(filename(mo.group('file')))
+
+def extract_maintainers(file, compre_dict, dowhile=None):
+    next = ('start', 'topic')
+    anyfield = ('person', 'ml', 'otherfield')
+    next_dict = dict(start=('topic',), topic=anyfield, person=anyfield, ml=anyfield, otherfield=anyfield)
+
+    for line in file:
+        if dowhile is not None:
+            mo = dowhile.match(line)
+            if not mo:
+                break
+
+        for possnext in next:
+            mo = compre_dict[possnext].match(line)
+            if mo:
+                for v in mo.groupdict().itervalues():
+                    print v
+                next = next_dict[possnext]
+                break
+        else:
+            mo = compre_dict['start'].match(line)
+            if mo:
+                next = next_dict['start']
+            else:
+                next = ('start',)
+
+re_dict = dict(start=r'$',
+        topic=r'\S[^:].*',
+        person=r'P:\s*(?P<person>.*)',
+        ml=r'L:\s*(?P<ml>.*)',
+        otherfield=r'(?![PL])[A-Z]:')
+
+re_comment = r'\s*(?:#|/?\*)'
+
+compre_dict = dict((key, re.compile(value)) for key, value in re_dict.iteritems())
+compre_commented_dict = dict((key, re.compile(re_comment + r'\s*' + value)) for key, value in re_dict.iteritems())
+compre_comment = re.compile(re_comment)
+
+mailto_person = set()
+mailto_ml = set()
+
+for file in changed_files:
+    # MAINTAINERS [cw]ould result in many false matches, skip it
+    # alternatively print someone?  who?
+    if file == 'MAINTAINERS':
+        continue
+
+    try:
+        of = open(file)
+    except:
+        # TODO: try harder (e.g. is the patch really -p1?)
+        continue
+
+    extract_maintainers(of, compre_commented_dict, compre_comment)
-- 
1.5.6.5

