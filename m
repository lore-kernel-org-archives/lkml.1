Return-Path: <linux-kernel-owner+w=401wt.eu-S1751742AbZKDGPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742AbZKDGPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 01:15:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbZKDGPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 01:15:35 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:41204 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbZKDGPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 01:15:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=LVaevQT5Dlv8/ATeM2AFb1KNol/3CESOy1+Oc0WtkOJlE5KL1Ls9qQ++1g7uERH10A
         5nKhmBvJ1//wdhTmH3k4FpMlVN8rFv1o/n4cfsVREA2P8zT79y4AyTi5jlfRtDAkqh27
         ObVCSTgS+w6uJSBB6mm7RCMGT1Cv3d0bVXIv8=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Frans Pop <elendil@planet.nl>
Subject: [PATCH] kbuild: let make O=dir rpm-pkg fail
Date: Wed,  4 Nov 2009 15:14:45 +0900
Message-Id: <1257315285-6782-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make rpm-pkg with setting KBUILD_OUTPUT is not possible and
it will print the good message since the commit
db9038c89d129383a9db2afcb72b504fe54f6edf

$ KBUILD_OUTPUT=dir make rpm-pkg
...
Building source + binary RPM is not possible outside the
kernel source tree. Don't set KBUILD_OUTPUT, or use the
binrpm-pkg target instead.
...

make O=dir should have the same effect of KBUILD_OUTPUT, but
it won't print that message.

This fixes it by exporting KBUILD_OUTPUT if O= is set so that
the rpm-pkg target in scripts/package/Makefile can find it.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Frans Pop <elendil@planet.nl>
---
 Makefile                 |    2 +-
 scripts/package/Makefile |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index b4c04f7..cfee468 100644
--- a/Makefile
+++ b/Makefile
@@ -93,7 +93,7 @@ ifeq ($(KBUILD_SRC),)
 # OK, Make called in directory where kernel src resides
 # Do we want to locate output files in a separate directory?
 ifeq ("$(origin O)", "command line")
-  KBUILD_OUTPUT := $(O)
+  export KBUILD_OUTPUT := $(O)
 endif
 
 # That's our default target when none is given on the command line
diff --git a/scripts/package/Makefile b/scripts/package/Makefile
index f67cc88..5db03d7 100644
--- a/scripts/package/Makefile
+++ b/scripts/package/Makefile
@@ -19,7 +19,7 @@
 # - Use /. to avoid tar packing just the symlink
 
 # Note that the rpm-pkg target cannot be used with KBUILD_OUTPUT,
-# but the binrpm-pkg target can; for some reason O= gets ignored.
+# but the binrpm-pkg target can.
 
 # Do we have rpmbuild, otherwise fall back to the older rpm
 RPM := $(shell if [ -x "/usr/bin/rpmbuild" ]; then echo rpmbuild; \
-- 
1.6.5.1

