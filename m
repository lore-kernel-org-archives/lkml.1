Return-Path: <linux-kernel-owner+w=401wt.eu-S1765696AbXHXOiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765696AbXHXOiG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 10:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbXHXOgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 10:36:48 -0400
Received: from 85-18-251-172.ip.fastwebnet.it ([85.18.251.172]:56129 "EHLO
	memento.home.lan" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752534AbXHXOgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 10:36:45 -0400
From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Subject: [PATCH 2/2] Script to check for undefined Kconfig symbols
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Date: Fri, 24 Aug 2007 13:29:02 +0200
Message-ID: <20070824112902.9607.88495.stgit@americanbeauty.home.lan>
In-Reply-To: <20070824112857.9607.22924.stgit@americanbeauty.home.lan>
References: <20070824112857.9607.22924.stgit@americanbeauty.home.lan>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid to look manually for used but undefined Kconfig variables, I've
written a script which tries do this efficiently, in case all other attention
fail. It accounts for _MODULE suffix and for UML_ prefixes to Kconfig variable,
but otherwise looks for exact matches (i.e. \<CONFIG_; this is done to exclude
macros like MMCONFIG_).

Undefined Kconfig variables should be not be removed without care, but for
instance arch/i386/boot/ uses a bunch of undefined Kconfig vars:

$ scripts/checkunknowndefines.sh arch/i386/boot/
arch/i386/boot/video.h uses undefined symbol VIDEO_400_HACK
arch/i386/boot/video-vga.c uses undefined symbol VIDEO_400_HACK
arch/i386/boot/video.c uses undefined symbol VIDEO_RETAIN
arch/i386/boot/video.h uses undefined symbol VIDEO_RETAIN
arch/i386/boot/video.h uses undefined symbol VIDEO_SVGA
arch/i386/boot/video.h uses undefined symbol VIDEO_VESA
arch/i386/boot/video-vesa.c uses undefined symbol VIDEO_VESA

Hope you can merge this in -mm and use it frequently (probably, a script to look for
regressions in its output is useful). It should also be mentioned in
SubmittingPatches if you agree.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
---

 scripts/checkunknowndefines.sh |   59 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/scripts/checkunknowndefines.sh b/scripts/checkunknowndefines.sh
new file mode 100755
index 0000000..d15950e
--- /dev/null
+++ b/scripts/checkunknowndefines.sh
@@ -0,0 +1,59 @@
+#!/bin/sh
+# Find Kconfig variables used in source code but never defined in Kconfig
+# Copyright (C) 2007, Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
+
+# Tested with dash.
+paths="$@"
+[ -z "$paths" ] && paths=.
+
+# Doing this once at the beginning saves a lot of time, on a cache-hot tree.
+Kconfigs="`find . -name 'Kconfig' -o -name 'Kconfig*[^~]'`"
+
+echo "File list \tundefined symbol used"
+find $paths -name '*.[chS]' -o -name 'Makefile' -o -name 'Makefile*[^~]'| while read i
+do
+	# Output the bare Kconfig variable and the filename; the _MODULE part at
+	# the end is not removed here (would need perl an not-hungry regexp for that).
+	sed -ne 's!^.*\<\(UML_\)\?CONFIG_\([0-9A-Z_]\+\).*!\2 '$i'!p' < $i
+done | \
+# Smart "sort|uniq" implemented in awk and tuned to collect the names of all
+# files which use a given symbol
+awk '{map[$1, count[$1]++] = $2; }
+END {
+	for (combIdx in map) {
+		split(combIdx, separate, SUBSEP);
+		# The value may have been removed.
+		if (! ( (separate[1], separate[2]) in map ) )
+			continue;
+		symb=separate[1];
+		printf "%s ", symb;
+		#Use gawk extension to delete the names vector
+		delete names;
+		#Portably delete the names vector
+		#split("", names);
+		for (i=0; i < count[symb]; i++) {
+			names[map[symb, i]] = 1;
+			# Unfortunately, we may still encounter symb, i in the
+			# outside iteration.
+			delete map[symb, i];
+		}
+		i=0;
+		for (name in names) {
+			if (i > 0)
+				printf ", %s", name;
+			else
+				printf "%s", name;
+			i++;
+		}
+		printf "\n";
+	}
+}' |
+while read symb files; do
+	# Remove the _MODULE suffix when checking the variable name. This should
+	# be done only on tristate symbols, actually, but Kconfig parsing is
+	# beyond the purpose of this script.
+	symb_bare=`echo $symb | sed -e 's/_MODULE//'`
+	if ! grep -q $symb_bare $Kconfigs; then
+		echo "$files: \t$symb"
+	fi
+done|sort

