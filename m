Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbZFEXqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbZFEXqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755534AbZFEXlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:41:45 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:36412 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633AbZFEXlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:41:13 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Sergei Poselenov <sposelenov@emcraft.com>, Wolfgang Denk <wd@denx.de>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 39/39] kbuild: fix "Argument list too long" error for "make headers_check",
Date: Sat,  6 Jun 2009 01:42:57 +0200
Message-Id: <1244245377-17441-39-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.3.rc3.40.g75b44
In-Reply-To: <20090605233720.GA13588@uranus.ravnborg.org>
References: <20090605233720.GA13588@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Poselenov <sposelenov@emcraft.com>

I'm trying to install kernel headers to build a cross-toolchain, but got
the following:

make ARCH=arm
INSTALL_HDR_PATH=/work/psl/eldk-builds/arm-2009-04-21/work/var/tmp/crosstool-0.43-3-root/usr/crosstool/gcc-4.2.2-glibc-20070515T2025-eldk/
+arm-linux-gnueabi/arm-linux-gnueabi/
headers_check
...
  CHECK   include/linux/raid (2 files)
  CHECK   include/linux/spi (1 files)
  CHECK   include/linux/sunrpc (1 files)
  CHECK   include/linux/tc_act (6 files)
  CHECK   include/linux/tc_ematch (4 files)
  CHECK   include/linux/usb (8 files)
make[2]: execvp: /bin/sh: Argument list too long
make[2]: ***
[/work/psl/eldk-builds/arm-2009-04-21/work/var/tmp/crosstool-0.43-3-root/usr/crosstool/gcc-4.2.2-glibc-20070515T2025-eldk/arm-linux-gnueab
+i/arm-linux-gnueabi//include/linux/.check]
Error 127
make[1]: *** [linux] Error 2
make: *** [headers_check] Error 2
->

Introduce use of xargs to fix this.

Signed-off-by: Sergei Poselenov <sposelenov@emcraft.com>
Cc: Wolfgang Denk <wd@denx.de>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/Makefile.headersinst |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index 095cfc8..0fcd838 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -54,8 +54,12 @@ quiet_cmd_remove = REMOVE  $(unwanted)
       cmd_remove = rm -f $(unwanted-file)
 
 quiet_cmd_check = CHECK   $(printdir) ($(words $(all-files)) files)
-      cmd_check = $(PERL) $< $(INSTALL_HDR_PATH)/include $(SRCARCH) \
-                  $(addprefix $(install)/, $(all-files));           \
+# Headers list can be pretty long, xargs helps to avoid
+# the "Argument list too long" error.
+      cmd_check = for f in $(all-files); do                          \
+                  echo "$(install)/$${f}"; done                      \
+                  | xargs                                            \
+                  $(PERL) $< $(INSTALL_HDR_PATH)/include $(SRCARCH); \
 	          touch $@
 
 PHONY += __headersinst __headerscheck
-- 
1.6.3.rc3.40.g75b44

