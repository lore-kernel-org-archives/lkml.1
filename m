Return-Path: <linux-kernel-owner+w=401wt.eu-S1761659AbXGESJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761659AbXGESJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 14:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759245AbXGESJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 14:09:15 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:45578 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759001AbXGESJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 14:09:14 -0400
X-Originating-Ip: 72.143.66.27
Date: Thu, 5 Jul 2007 14:07:00 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][RFC] Add a script to locate "dead" CONFIG variables.
Message-ID: <Pine.LNX.4.64.0707051404560.2340@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Add a script that scans any part of the source tree for references to
CONFIG_-prefixed variables that aren't defined in any Kconfig file.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  might as well just toss this into the tree.

diff --git a/scripts/find_dead_configs.sh b/scripts/find_dead_configs.sh
new file mode 100755
index 0000000..df68773
--- /dev/null
+++ b/scripts/find_dead_configs.sh
@@ -0,0 +1,90 @@
+#!/bin/sh
+#
+#  find_dead_configs.sh
+#
+#  This script scans either all or any selected subdirectory of
+# the kernel source tree and identifies "dead" CONFIG variables;
+# that is, preprocessor tests in any source or header file which
+# test a symbol with a name like "CONFIG_FUBAR" for which there
+# is no associated "config FUBAR" entry in any Kconfig* file
+# anywhere in the entire tree.
+#
+#  This script should always be run from the top-level directory
+# of the tree.  Some sample invocations:
+#
+#    $ .../find_dead_configs.sh fs/
+#    $ .../find_dead_configs.sh sound/
+#    $ .../find_dead_configs.sh drivers/net/
+#    $ .../find_dead_configs.sh		[default of entire tree]
+#
+#  Here's a sample run at the moment:
+#
+#    $ find_dead_configs.sh kernel
+#    ========== PROVE_SPIN_LOCKING ==========
+#    kernel/spinlock.c:308:#ifdef CONFIG_PROVE_SPIN_LOCKING
+#
+#  So kernel/spinlock.c is testing a macro that clearly is not
+# defined in any Kconfig file anywhere in the tree.
+#
+#  NOTES:
+#
+#   1)	Even if you choose to check only a subdirectory, the script
+#	will still look for the corresponding Kconfig entry everywhere
+#	in the tree, just to be thorough.
+#
+#   2)	For each symbol like "FUBAR" identified as being potentially
+#	"dead", the script will grep the entire tree for that string,
+#	just to display anything that might possibly be related.
+#	This sometimes makes typoes immediately obvious.
+#
+#   3)	Sadly, at the moment, this script does generate numerous
+#	false positives as an annoying number of developers have a
+#	bad habit of creating local macro names with a prefix of
+#	"CONFIG_".  Bad developer.  No biscuit.
+#
+#	In any event, it's your job to examine the output manually
+#	afterwards to see if there's anything of interest.
+
+DIR=${1-*}
+
+#
+#  From the selected source and header files, extract all of the
+# "CONFIG_" macro names, strip their leading "CONFIG_" and possible
+# trailing "_MODULE" strings, then uniquely sort what's left to get
+# the macro "names" we're going to sanity check.
+#
+#  As an example, if a source file contains a preprocessor test for
+# the macro CONFIG_FUBAR, the string "FUBAR" will be added to the
+# CVARS list of names to test.
+#
+
+CVARS=$(find ${DIR} -name "*.[ch]" |    \
+        xargs ifnames |                 \
+        grep "^CONFIG_" |               \
+        cut -d' ' -f1 |                 \
+        sed "s/^CONFIG_//" |            \
+        sed "s/_MODULE$//" |            \
+        sort -u)
+
+# echo "${CVARS}"
+
+#
+#  Create a list of *all* Kconfig files throughout the entire
+# tree.
+#
+
+kcfiles=$(find . -name "Kconfig*")
+
+#
+#  For every CONFIG variable that appears to be dead, scan the
+# entire tree for that string.  You just never know what might
+# turn up.
+
+for cv in ${CVARS} ; do
+        grep -wq ${cv} ${kcfiles} || {
+                echo "========== ${cv} =========="
+                grep -rwn "CONFIG_${cv}" ${DIR}
+                grep -rwn "CONFIG_${cv}_MODULE" ${DIR}
+                grep -rwn "${cv}" *
+        }
+done
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
