Return-Path: <linux-kernel-owner+w=401wt.eu-S1752370AbYLTOa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbYLTOa4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 09:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbYLTOaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 09:30:09 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:41288 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbYLTOaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 09:30:05 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Mike Frysinger <vapier@gentoo.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 04/26] kbuild: introduce $(kecho) convenience echo
Date: Sat, 20 Dec 2008 15:31:15 +0100
Message-Id: <1229783497-19550-4-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20081220142518.GA19390@uranus.ravnborg.org>
References: <20081220142518.GA19390@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>

There is a bunch of places in the build system where we do 'echo' to show
some nice status lines.  This means we still get output when running in
silent mode.  So declare a new KECHO variable that only does 'echo' when we
are in a suitable verbose build mode.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
[sam: added Documentation]
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Documentation/kbuild/makefiles.txt |   14 ++++++++++++++
 scripts/Kbuild.include             |    7 +++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index 7a77533..51104f9 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -383,6 +383,20 @@ more details, with real examples.
 	to prerequisites are referenced with $(src) (because they are not
 	generated files).
 
+    $(kecho)
+	echoing information to user in a rule is often a good practice
+	but when execution "make -s" one does not expect to see any output
+	except for warnings/errors.
+	To support this kbuild define $(kecho) which will echo out the
+	text following $(kecho) to stdout except if "make -s" is used.
+
+	Example:
+		#arch/blackfin/boot/Makefile
+		$(obj)/vmImage: $(obj)/vmlinux.gz
+			$(call if_changed,uimage)
+			@$(kecho) 'Kernel: $@ is ready'
+
+
 --- 3.11 $(CC) support functions
 
 	The kernel may be built with several different versions of
diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 936940b..8cf87e8 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -25,6 +25,13 @@ basetarget = $(basename $(notdir $@))
 escsq = $(subst $(squote),'\$(squote)',$1)
 
 ###
+# Easy method for doing a status message
+       kecho := :
+ quiet_kecho := echo
+silent_kecho := :
+kecho := $($(quiet)kecho)
+
+###
 # filechk is used to check if the content of a generated file is updated.
 # Sample usage:
 # define filechk_sample
-- 
1.6.0.2.GIT

