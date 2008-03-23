Return-Path: <linux-kernel-owner+w=401wt.eu-S1756917AbYCWUuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbYCWUuN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 16:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbYCWUuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 16:50:01 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:34298 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978AbYCWUt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 16:49:59 -0400
Date: Sun, 23 Mar 2008 21:50:21 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Gordon Farquharson <gordonfarquharson@gmail.com>,
       Michael Buesch <mb@bu3sch.de>, stable@kernel.org
Subject: [GIT PULL] one kbuild fix
Message-ID: <20080323205021.GA5087@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Please pull following fix for kbuild.

It can be pulled from:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-linus.git

Full patch below.

	Sam

>From 4ce6efed48d736e3384c39ff87bda723e1f8e041 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@uranus.ravnborg.org>
Date: Sun, 23 Mar 2008 21:38:54 +0100
Subject: [PATCH] kbuild: soften modpost checks when doing cross builds

The module alias support in the kernel have a consistency
check where it is checked that the size of a structure
in the kernel and on the build host are the same.
For cross builds this check does not make sense so detect
when we do cross builds and silently skip the check in these
situations.
This fixes a build bug for a wireless driver when cross building
for arm.

Acked-by: Michael Buesch <mb@bu3sch.de>
Tested-by: Gordon Farquharson <gordonfarquharson@gmail.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: stable@kernel.org
---
 Makefile                 |    2 +-
 scripts/Makefile.modpost |    6 +++++-
 scripts/mod/file2alias.c |    4 ++++
 scripts/mod/modpost.c    |    5 ++++-
 scripts/mod/modpost.h    |    1 +
 5 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 7a4d34b..1c4c8f8 100644
--- a/Makefile
+++ b/Makefile
@@ -189,7 +189,7 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
 # Alternatively CROSS_COMPILE can be set in the environment.
 # Default value for CROSS_COMPILE is not to prefix executables
 # Note: Some architectures assign CROSS_COMPILE in their arch/*/Makefile
-
+export KBUILD_BUILDHOST := $(SUBARCH)
 ARCH		?= $(SUBARCH)
 CROSS_COMPILE	?=
 
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index cfc004e..2d20640 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -58,6 +58,9 @@ modules   := $(patsubst %.o,%.ko, $(wildcard $(__modules:.ko=.o)))
 # Stop after building .o files if NOFINAL is set. Makes compile tests quicker
 _modpost: $(if $(KBUILD_MODPOST_NOFINAL), $(modules:.ko:.o),$(modules))
 
+ifneq ($(KBUILD_BUILDHOST),$(ARCH))
+        cross_build := 1
+endif
 
 # Step 2), invoke modpost
 #  Includes step 3,4
@@ -70,7 +73,8 @@ modpost = scripts/mod/modpost                    \
  $(if $(CONFIG_DEBUG_SECTION_MISMATCH),,-S)      \
  $(if $(CONFIG_MARKERS),-K $(kernelmarkersfile)) \
  $(if $(CONFIG_MARKERS),-M $(markersfile))	 \
- $(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w)
+ $(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w) \
+ $(if $(cross_build),-c)
 
 quiet_cmd_modpost = MODPOST $(words $(filter-out vmlinux FORCE, $^)) modules
       cmd_modpost = $(modpost) -s
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 9ddf944..348d868 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -51,11 +51,13 @@ do {                                                            \
                 sprintf(str + strlen(str), "*");                \
 } while(0)
 
+unsigned int cross_build = 0;
 /**
  * Check that sizeof(device_id type) are consistent with size of section
  * in .o file. If in-consistent then userspace and kernel does not agree
  * on actual size which is a bug.
  * Also verify that the final entry in the table is all zeros.
+ * Ignore both checks if build host differ from target host and size differs.
  **/
 static void device_id_check(const char *modname, const char *device_id,
 			    unsigned long size, unsigned long id_size,
@@ -64,6 +66,8 @@ static void device_id_check(const char *modname, const char *device_id,
 	int i;
 
 	if (size % id_size || size < id_size) {
+		if (cross_build != 0)
+			return;
 		fatal("%s: sizeof(struct %s_device_id)=%lu is not a modulo "
 		      "of the size of section __mod_%s_device_table=%lu.\n"
 		      "Fix definition of struct %s_device_id "
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 695b5d6..110cf24 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -2026,7 +2026,7 @@ int main(int argc, char **argv)
 	int opt;
 	int err;
 
-	while ((opt = getopt(argc, argv, "i:I:msSo:awM:K:")) != -1) {
+	while ((opt = getopt(argc, argv, "i:I:cmsSo:awM:K:")) != -1) {
 		switch (opt) {
 		case 'i':
 			kernel_read = optarg;
@@ -2035,6 +2035,9 @@ int main(int argc, char **argv)
 			module_read = optarg;
 			external_module = 1;
 			break;
+		case 'c':
+			cross_build = 1;
+			break;
 		case 'm':
 			modversions = 1;
 			break;
diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
index 565c587..09f58e3 100644
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
@@ -135,6 +135,7 @@ struct elf_info {
 };
 
 /* file2alias.c */
+extern unsigned int cross_build;
 void handle_moddevtable(struct module *mod, struct elf_info *info,
 			Elf_Sym *sym, const char *symname);
 void add_moddevtable(struct buffer *buf, struct module *mod);
-- 
1.5.4.1.143.ge7e51

