Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbZKLXDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbZKLXDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 18:03:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754981AbZKLXDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 18:03:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36842 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932AbZKLXDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 18:03:21 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, greg@kroah.com, akpm@linux-foundation.org,
       mcgrof@gmail.com, lrodriguez@atheros.com
Subject: [RFC] scripts: add gen-linux-conf for remote kernel configuration
Date: Thu, 12 Nov 2009 18:03:26 -0500
Message-Id: <1258067006-2205-1-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.6.2.rc1.3.g81d3f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new 'make localmodconfig' proves very useful but on low end
systems we do not want to 'git clone' an entire kernel tree or
download a whole kernel but just cross compile the kernel on a
bigger machine. The .config generated with 'make localmodconfig'
is still very helpfup though so to aid users and developers
with that add a script which builds a tarball with only the
necessary kernel glue stuff to be able to generate a local
minimum kernel configuration with 'make localmodconfig'.

With this you can copy to your target device a relatively
small tarball (1.2 MB currenty) and, allows you to modify
the kernel config for your tree (mconf, conf, etc) and
finally run 'make localmodconfig'.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

I had an itch to scratch and that was to use 'localmodconfig'
on a small netbook but I didn't want to clone a whole tree
or even compile an entire kernel on it. This did the trick,
thought others might find it useful.

A little grimy the bash script, but hey it works and its simple
enough. I tried to reduce the Makefile count to only arch/ but
found that that didn't do the trick. Perhaps this can be optimized
more, suggestions welcomed. Maybe it should be written in Go :)

What would be *real* nice is to give an IP address of a box and
have it build and fetch a localmodconfig .config for you.

  Luis

 scripts/gen-linux-conf |   61 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 61 insertions(+), 0 deletions(-)
 create mode 100755 scripts/gen-linux-conf

diff --git a/scripts/gen-linux-conf b/scripts/gen-linux-conf
new file mode 100755
index 0000000..5c88a50
--- /dev/null
+++ b/scripts/gen-linux-conf
@@ -0,0 +1,61 @@
+#!/bin/bash
+
+DEST=linux-conf
+rm -rf $DEST
+
+KCONFIGS=$(find ./ -type f -name Kconfig\*)
+MAKEFILES=$(find ./ -type f -name Makefile\*)
+KBUILDS=$(find ./ -type f -name Kbuild\*)
+
+COUNT=0
+echo -en "\nAdding Kconfigs"
+for i in ${KCONFIGS}; do
+	FILE=$(basename $i)
+	DIR=$(dirname $i)
+	DIR=${DEST}/${DIR}
+	mkdir -p ${DIR}
+	cp $i ${DIR}
+	echo -en "."
+	let COUNT=$COUNT+1
+done
+echo "$COUNT files copied"
+
+COUNT=0
+echo -en "Adding Makefiles"
+for i in ${MAKEFILES}; do
+	FILE=$(basename $i)
+	DIR=$(dirname $i)
+	DIR=${DEST}/${DIR}
+	mkdir -p ${DIR}
+	cp $i ${DIR}
+	echo -en "."
+	let COUNT=$COUNT+1
+done
+echo "$COUNT files copied"
+
+COUNT=0
+echo -en "Adding Kbuild files"
+for i in ${KBUILDS}; do
+	FILE=$(basename $i)
+	DIR=$(dirname $i)
+	DIR=${DEST}/${DIR}
+	mkdir -p ${DIR}
+	cp $i ${DIR}
+	echo -en "."
+	let COUNT=$COUNT+1
+done
+echo -e "$COUNT files copied\n"
+
+cp -af scripts/ ${DEST}
+cp -f Makefile ${DEST}
+
+TARBALL=${DEST}.tar.bz2
+
+tar -jcf ${TARBALL} ${DEST}
+rm -rf ${DEST}
+
+echo -e "Finished ${TARBALL} ($(du -h $TARBALL | cut -f 1))"
+echo -e "Now scp ${TARBALL} to target and run:\n"
+echo -e "cp /boot/your-config .config"
+echo -e "make menuconfig"
+echo -e "make localmodconfig"
-- 
1.6.5.2.155.gbb47

