Return-Path: <linux-kernel-owner+w=401wt.eu-S937610AbXGTWbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937610AbXGTWbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755905AbXGTWbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:31:12 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:43827 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311AbXGTWbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:31:09 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 1/4] kbuild: do not do section mismatch checks on vmlinux in 2nd pass
Date: Sat, 21 Jul 2007 00:30:41 +0200
Message-Id: <11849706443410-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <20070720222039.GA25443@uranus.ravnborg.org>
References: <20070720222039.GA25443@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We already check and warn about section mismatches from vmlinux
(build as vmlinux.o) during first pass so skip the checks
during the 2nd pass where we process modules.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/Makefile.modpost |   19 ++++++++++---------
 scripts/mod/modpost.c    |   13 ++++++++++---
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index c6fcc59..1818c50 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -56,23 +56,24 @@ _modpost: $(if $(KBUILD_MODPOST_NOFINAL), $(modules:.ko:.o),$(modules))
 
 # Step 2), invoke modpost
 #  Includes step 3,4
+modpost = scripts/mod/modpost                    \
+ $(if $(CONFIG_MODVERSIONS),-m)                  \
+ $(if $(CONFIG_MODULE_SRCVERSION_ALL),-a,)       \
+ $(if $(KBUILD_EXTMOD),-i,-o) $(kernelsymfile)   \
+ $(if $(KBUILD_EXTMOD),-I $(modulesymfile))      \
+ $(if $(KBUILD_EXTMOD),-o $(modulesymfile))      \
+ $(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w)
+
 quiet_cmd_modpost = MODPOST $(words $(filter-out vmlinux FORCE, $^)) modules
-      cmd_modpost = scripts/mod/modpost            \
-        $(if $(CONFIG_MODVERSIONS),-m)             \
-	$(if $(CONFIG_MODULE_SRCVERSION_ALL),-a,)  \
-	$(if $(KBUILD_EXTMOD),-i,-o) $(kernelsymfile) \
-	$(if $(KBUILD_EXTMOD),-I $(modulesymfile)) \
-	$(if $(KBUILD_EXTMOD),-o $(modulesymfile)) \
-	$(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w)
+      cmd_modpost = $(modpost) -s
 
 PHONY += __modpost
 __modpost: $(modules:.ko=.o) FORCE
 	$(call cmd,modpost) $(wildcard vmlinux) $(filter-out FORCE,$^)
 
 quiet_cmd_kernel-mod = MODPOST $@
-      cmd_kernel-mod = $(cmd_modpost) $@
+      cmd_kernel-mod = $(modpost) $@
 
-PHONY += vmlinux
 vmlinux.o: FORCE
 	$(call cmd,kernel-mod)
 
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 5ab7914..87e3ee5 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -23,6 +23,8 @@ int have_vmlinux = 0;
 static int all_versions = 0;
 /* If we are modposting external module set to 1 */
 static int external_module = 0;
+/* Warn about section mismatch in vmlinux if set to 1 */
+static int vmlinux_section_warnings = 1;
 /* Only warn about unresolved symbols */
 static int warn_unresolved = 0;
 /* How a symbol is exported */
@@ -1257,8 +1259,10 @@ static void read_symbols(char *modname)
 		handle_modversions(mod, &info, sym, symname);
 		handle_moddevtable(mod, &info, sym, symname);
 	}
-	check_sec_ref(mod, modname, &info, init_section, init_section_ref_ok);
-	check_sec_ref(mod, modname, &info, exit_section, exit_section_ref_ok);
+	if (is_vmlinux(modname) && vmlinux_section_warnings) {
+		check_sec_ref(mod, modname, &info, init_section, init_section_ref_ok);
+		check_sec_ref(mod, modname, &info, exit_section, exit_section_ref_ok);
+	}
 
 	version = get_modinfo(info.modinfo, info.modinfo_len, "version");
 	if (version)
@@ -1626,7 +1630,7 @@ int main(int argc, char **argv)
 	int opt;
 	int err;
 
-	while ((opt = getopt(argc, argv, "i:I:mo:aw")) != -1) {
+	while ((opt = getopt(argc, argv, "i:I:mso:aw")) != -1) {
 		switch(opt) {
 			case 'i':
 				kernel_read = optarg;
@@ -1644,6 +1648,9 @@ int main(int argc, char **argv)
 			case 'a':
 				all_versions = 1;
 				break;
+			case 's':
+				vmlinux_section_warnings = 0;
+				break;
 			case 'w':
 				warn_unresolved = 1;
 				break;
-- 
1.5.0.6

