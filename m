Return-Path: <linux-kernel-owner+w=401wt.eu-S933168AbYF3Vgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168AbYF3Vgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932788AbYF3Vej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:34:39 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51655 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762983AbYF3Vec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:34:32 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 09/24] kbuild: install all headers when arch is changed
Date: Mon, 30 Jun 2008 23:35:03 +0200
Message-Id: <1214861718-32626-9-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.6.1.93.gef98
In-Reply-To: <20080630213155.GA32479@uranus.ravnborg.org>
References: <20080630213155.GA32479@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We see some header files that are selected dependent on
the actual architecture so force a reinstallation
of all header files when the arch changes.
This slows down "make headers_check_all" but then
we better reflect reality.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/Makefile.headersinst |    7 ++++---
 scripts/headers_install.pl   |   13 ++++++++-----
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index be2b70c..612dc13 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -43,9 +43,10 @@ printdir = $(patsubst $(INSTALL_HDR_PATH)/%/,%,$(dir $@))
 
 quiet_cmd_install = INSTALL $(printdir) ($(words $(all-files))\
                             file$(if $(word 2, $(all-files)),s))
-      cmd_install = $(PERL) $< $(srctree)/$(obj) $(install) $(header-y); \
-                    $(PERL) $< $(objtree)/$(obj) $(install) $(objhdr-y); \
-	            touch $@
+      cmd_install = \
+        $(PERL) $< $(srctree)/$(obj) $(install) $(SRCARCH) $(header-y); \
+        $(PERL) $< $(objtree)/$(obj) $(install) $(SRCARCH) $(objhdr-y); \
+        touch $@
 
 quiet_cmd_remove = REMOVE  $(unwanted)
       cmd_remove = rm -f $(unwanted-file)
diff --git a/scripts/headers_install.pl b/scripts/headers_install.pl
index f0ff9a3..68591cd 100644
--- a/scripts/headers_install.pl
+++ b/scripts/headers_install.pl
@@ -3,10 +3,13 @@
 # headers_install prepare the listed header files for use in
 # user space and copy the files to their destination.
 #
-# Usage: headers_install.pl odir installdir [files...]
-# odir:    dir to open files
-# install: dir to install the files
-# files:   list of files to check
+# Usage: headers_install.pl readdir installdir arch [files...]
+# readdir:    dir to open files
+# installdir: dir to install the files
+# arch:       current architecture
+#             arch is used to force a reinstallation when the arch
+#             changes because kbuild then detect a command line change.
+# files:      list of files to check
 #
 # Step in preparation for users space:
 # 1) Drop all use of compiler.h definitions
@@ -16,7 +19,7 @@
 use strict;
 use warnings;
 
-my ($readdir, $installdir, @files) = @ARGV;
+my ($readdir, $installdir, $arch, @files) = @ARGV;
 
 my $unifdef = "scripts/unifdef -U__KERNEL__";
 
-- 
1.5.6.1.93.gef98

