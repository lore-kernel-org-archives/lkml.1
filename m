Return-Path: <linux-kernel-owner+w=401wt.eu-S1757435AbYILRUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbYILRUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 13:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbYILRT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 13:19:56 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:28308 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757281AbYILRTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 13:19:54 -0400
Date: Fri, 12 Sep 2008 10:18:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm <akpm@linux-foundation.org>, samr <sam@ravnborg.org>
Subject: [RFC/PATCH] dontdiff: generate from gitignore
Message-Id: <20080912101840.e0b6dd8c.randy.dunlap@oracle.com>
In-Reply-To: <20080901231419.GA5602@x200.localdomain>
References: <20080901150951.5cba4dc7@infradead.org>
	<20080901231419.GA5602@x200.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
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

Generate the "dontdiff" file from the .gitignore files.
Save it in scripts/dontdiff.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Makefile           |   10 +++++++++-
 scripts/.gitignore |    1 +
 scripts/mkdontdiff |   23 +++++++++++++++++++++++
 3 files changed, 33 insertions(+), 1 deletion(-)

--- linux-2.6.27-rc6-git2.orig/Makefile
+++ linux-2.6.27-rc6-git2/Makefile
@@ -398,7 +398,7 @@ endif
 no-dot-config-targets := clean mrproper distclean \
 			 cscope TAGS tags help %docs check% \
 			 include/linux/version.h headers_% \
-			 kernelrelease kernelversion
+			 kernelrelease kernelversion dontdiff
 
 config-targets := 0
 mixed-targets  := 0
@@ -1251,6 +1251,7 @@ help:
 	@echo  '  dir/            - Build all files in dir and below'
 	@echo  '  dir/file.[ois]  - Build specified target only'
 	@echo  '  dir/file.ko     - Build module including final link'
+	@echo  '  dontdiff        - Create a "dontdiff" file'
 	@echo  '  prepare         - Set up for building external modules'
 	@echo  '  tags/TAGS	  - Generate tags file for editors'
 	@echo  '  cscope	  - Generate cscope index'
@@ -1519,6 +1520,13 @@ endef
 tags: FORCE
 	$(call cmd,tags)
 
+quiet_cmd_dontdiff = MAKE    dontdiff
+      cmd_dontdiff = $(shell $(CONFIG_SHELL) \
+	                  $(srctree)/scripts/mkdontdiff $(srctree))
+
+dontdiff: FORCE
+	$(call cmd,dontdiff)
+
 
 # Scripts to check various things for consistency
 # ---------------------------------------------------------------------------
--- /dev/null
+++ linux-2.6.27-rc6-git2/scripts/mkdontdiff
@@ -0,0 +1,23 @@
+#! /bin/sh
+set -f
+
+TMPFILE=`mktemp ./.tmpdd.XXXXXX`
+srctree=$1
+DDFILE=$srctree/scripts/dontdiff
+
+find . -name .gitignore | xargs cat | grep -v '^[#!]' | grep -v '^[:space:]*$' | sort | uniq > $TMPFILE
+
+rm -f $DDFILE
+touch $DDFILE
+
+while read PATTERN ; do
+	if echo "$PATTERN" | grep -q '/' ; then
+		filename=`basename $PATTERN`
+	else
+		filename="$PATTERN"
+	fi
+
+	echo $filename >> $DDFILE
+done < $TMPFILE
+
+rm $TMPFILE
--- linux-2.6.27-rc6-git2.orig/scripts/.gitignore
+++ linux-2.6.27-rc6-git2/scripts/.gitignore
@@ -2,6 +2,7 @@
 # Generated files
 #
 conmakehash
+dontdiff
 kallsyms
 pnmtologo
 bin2c

