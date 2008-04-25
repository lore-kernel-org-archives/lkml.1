Return-Path: <linux-kernel-owner+w=401wt.eu-S1765578AbYDYXe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765578AbYDYXe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 19:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756931AbYDYXeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 19:34:46 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:15999 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525AbYDYXep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 19:34:45 -0400
Date: Fri, 25 Apr 2008 16:33:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: samr <sam@ravnborg.org>, akpm <akpm@linux-foundation.org>,
       torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] documentation: remove smart-config.txt
Message-Id: <20080425163348.a030dc7a.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

As requested by Sam Ravnborg:
Remove Documentation/smart-config.txt.  It is outdated and has been
(functionally) replaced by Documentation/kbuild/*.txt.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/smart-config.txt |   98 -------------------------------
 1 file changed, 98 deletions(-)

--- linux-2.6.25-git7.orig/Documentation/smart-config.txt
+++ /dev/null
@@ -1,98 +0,0 @@
-Smart CONFIG_* Dependencies
-1 August 1999
-
-Michael Chastain   <mec@shout.net>
-Werner Almesberger <almesber@lrc.di.epfl.ch>
-Martin von Loewis  <martin@mira.isdn.cs.tu-berlin.de>
-
-Here is the problem:
-
-    Suppose that drivers/net/foo.c has the following lines:
-
-	#include <linux/config.h>
-
-	...
-
-	#ifdef CONFIG_FOO_AUTOFROB
-	    /* Code for auto-frobbing */
-	#else
-	    /* Manual frobbing only */
-	#endif
-
-	...
-
-	#ifdef CONFIG_FOO_MODEL_TWO
-	    /* Code for model two */
-	#endif
-
-    Now suppose the user (the person building kernels) reconfigures the
-    kernel to change some unrelated setting.  This will regenerate the
-    file include/linux/autoconf.h, which will cause include/linux/config.h
-    to be out of date, which will cause drivers/net/foo.c to be recompiled.
-
-    Most kernel sources, perhaps 80% of them, have at least one CONFIG_*
-    dependency somewhere.  So changing _any_ CONFIG_* setting requires
-    almost _all_ of the kernel to be recompiled.
-
-Here is the solution:
-
-    We've made the dependency generator, mkdep.c, smarter.  Instead of
-    generating this dependency:
-
-	drivers/net/foo.c: include/linux/config.h
-
-    It now generates these dependencies:
-
-	drivers/net/foo.c: \
-	    include/config/foo/autofrob.h \
-	    include/config/foo/model/two.h
-
-    So drivers/net/foo.c depends only on the CONFIG_* lines that
-    it actually uses.
-
-    A new program, split-include.c, runs at the beginning of
-    compilation (make bzImage or make zImage).  split-include reads
-    include/linux/autoconf.h and updates the include/config/ tree,
-    writing one file per option.  It updates only the files for options
-    that have changed.
-
-Flag Dependencies
-
-    Martin Von Loewis contributed another feature to this patch:
-    'flag dependencies'.  The idea is that a .o file depends on
-    the compilation flags used to build it.  The file foo.o has
-    its flags stored in .flags.foo.o.
-
-    Suppose the user changes the foo driver from resident to modular.
-    'make' will notice that the current foo.o was not compiled with
-    -DMODULE and will recompile foo.c.
-
-    All .o files made from C source have flag dependencies.  So do .o
-    files made with ld, and .a files made with ar.  However, .o files
-    made from assembly source do not have flag dependencies (nobody
-    needs this yet, but it would be good to fix).
-
-Per-source-file Flags
-
-    Flag dependencies also work with per-source-file flags.
-    You can specify compilation flags for individual source files
-    like this:
-
-	CFLAGS_foo.o = -DSPECIAL_FOO_DEFINE
-
-    This helps clean up drivers/net/Makefile, drivers/scsi/Makefile,
-    and several other Makefiles.
-
-Credit
-
-    Werner Almesberger had the original idea and wrote the first
-    version of this patch.
-    
-    Michael Chastain picked it up and continued development.  He is
-    now the principal author and maintainer.  Please report any bugs
-    to him.
-
-    Martin von Loewis wrote flag dependencies, with some modifications
-    by Michael Chastain.
-
-    Thanks to all of the beta testers.
