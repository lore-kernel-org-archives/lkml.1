Return-Path: <linux-kernel-owner+w=401wt.eu-S1760083AbXGTLfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760083AbXGTLfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 07:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbXGTLfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 07:35:34 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:57751 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbXGTLfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 07:35:33 -0400
Date: Fri, 20 Jul 2007 13:36:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, jdike@addtoit.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fallout from kbuild changes
Message-ID: <20070720113646.GA21187@uranus.ravnborg.org>
References: <20070720010116.GB21668@ftp.linux.org.uk> <20070720064049.GA19653@uranus.ravnborg.org> <20070720092029.GE21668@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720092029.GE21668@ftp.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 10:20:29AM +0100, Al Viro wrote:
> BTW, the presense of vmlinux in the second modpost generates warnings
> in two cases - i386 with CONFIG_RELOCATABLE and sparc32 (always).
> The warnings tend to be bogus.  Do we really want them there now that
> we should (in theory) get all useful stuff from vmlinux.o?  Other
> targets get aways with that since they don't have relocs survive into
> vmlinux...

It was on my TODO list. For i386, x86_64 etc. we warn too much too in
the seconf modpost run.
Something like this is needed - I will push it during the weekend.

	Sam

diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index c6fcc59..cebfe03 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -57,20 +57,20 @@ _modpost: $(if $(KBUILD_MODPOST_NOFINAL), $(modules:.ko:.o),$(modules))
 # Step 2), invoke modpost
 #  Includes step 3,4
 quiet_cmd_modpost = MODPOST $(words $(filter-out vmlinux FORCE, $^)) modules
-      cmd_modpost = scripts/mod/modpost            \
-        $(if $(CONFIG_MODVERSIONS),-m)             \
-	$(if $(CONFIG_MODULE_SRCVERSION_ALL),-a,)  \
-	$(if $(KBUILD_EXTMOD),-i,-o) $(kernelsymfile) \
-	$(if $(KBUILD_EXTMOD),-I $(modulesymfile)) \
-	$(if $(KBUILD_EXTMOD),-o $(modulesymfile)) \
-	$(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w)
+      cmd_modpost = scripts/mod/modpost                 \
+        $(if $(CONFIG_MODVERSIONS),-m)                  \
+        $(if $(CONFIG_MODULE_SRCVERSION_ALL),-a,)       \
+        $(if $(KBUILD_EXTMOD),-i,-o) $(kernelsymfile)   \
+        $(if $(KBUILD_EXTMOD),-I $(modulesymfile))      \
+        $(if $(KBUILD_EXTMOD),-o $(modulesymfile))      \
+        $(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w)
 
 PHONY += __modpost
 __modpost: $(modules:.ko=.o) FORCE
 	$(call cmd,modpost) $(wildcard vmlinux) $(filter-out FORCE,$^)
 
 quiet_cmd_kernel-mod = MODPOST $@
-      cmd_kernel-mod = $(cmd_modpost) $@
+      cmd_kernel-mod = $(cmd_modpost) -s $@
 
 PHONY += vmlinux
 vmlinux.o: FORCE
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 04579a5..787e1d4 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -23,6 +23,8 @@ int have_vmlinux = 0;
 static int all_versions = 0;
 /* If we are modposting external module set to 1 */
 static int external_module = 0;
+/* Warn about section mismatch in vmlinux if set to 1 */
+static int vmlinux_section_warnings = 0;
 /* Only warn about unresolved symbols */
 static int warn_unresolved = 0;
 /* How a symbol is exported */
@@ -1256,8 +1258,10 @@ static void read_symbols(char *modname)
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
@@ -1625,7 +1629,7 @@ int main(int argc, char **argv)
 	int opt;
 	int err;
 
-	while ((opt = getopt(argc, argv, "i:I:mo:aw")) != -1) {
+	while ((opt = getopt(argc, argv, "i:I:mso:aw")) != -1) {
 		switch(opt) {
 			case 'i':
 				kernel_read = optarg;
@@ -1643,6 +1647,9 @@ int main(int argc, char **argv)
 			case 'a':
 				all_versions = 1;
 				break;
+			case 's':
+				vmlinux_section_warnings = 1;
+				break;
 			case 'w':
 				warn_unresolved = 1;
 				break;
