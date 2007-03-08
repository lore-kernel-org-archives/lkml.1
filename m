Return-Path: <linux-kernel-owner+w=401wt.eu-S933068AbXCHTVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068AbXCHTVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 14:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933114AbXCHTVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 14:21:34 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:57955 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933068AbXCHTVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 14:21:32 -0500
Date: Thu, 8 Mar 2007 20:22:08 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: kbuild fixes for section mismatch warnings
Message-ID: <20070308192208.GB9792@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following series of patches gets rid of some false positives
for the section mismatch warnings.
It also enables proper check of section mismatch warnings
when a module is built-in.
So expect a few new warnings to pop up..

The most controversial ones are the patch that ignores
the warning when a function marked __init is exported. Greg KH
says it is OK. And the one allowing the logo references.
Comments are welcome!


kbuild: silence section mismatch warnings for exported functions
kbuild: whitelist logo references from .text to .init.data
kbuild: fix segmentation fault in modpost
kbuild: fix warnings from .pci_fixup section
kbuild: whitelist section mismatch in init/main.c
kbuild: fix section mismatch check for vmlinux

During the last release a great number of section mismatch fixes
has been included and the plan is to make a section mismatch
an error on line with any normal linking errors when all the
non-drivers warnings are fixed.

The diffstat:

 b/Makefile                 |    1 
 b/init/main.c              |    6 +-
 b/scripts/Makefile.modpost |    8 +--
 b/scripts/mod/modpost.c    |   34 +++++++++------
 scripts/mod/modpost.c      |   98 ++++++++++++++++++++++++++++++++-------------
 5 files changed, 100 insertions(+), 47 deletions(-)

The changes to init/main.c is a simple function rename.
The full list of changes are included below.

The changes are present in kbuild.git at:
git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild.git

I do not plan to push these until next merge window since this
is not critical changes.

PS. I have a backlog of three months of kbuild mails that I
need to walk through. Andrew have applied quite a lot in main
absence period but I have a few remaining patches.
They will be pushed when I get to them.


	Sam

>From 5a1ed6a563f5a198d3d7164abf7a5708af20e7ce Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Mon, 26 Feb 2007 15:33:52 +0100
Subject: kbuild: fix section mismatch check for vmlinux

vmlinux does not contain relocation entries which is
used by the section mismatch checks.
Reported by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Use the individual objects as inputs to overcome
this limitation.
In modpost check the .o files and skip non-ELF files.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile                 |    1 +
 scripts/Makefile.modpost |    8 ++++----
 scripts/mod/modpost.c    |   33 +++++++++++++++++++++------------
 3 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/Makefile b/Makefile
index 30b66e2..fa32fde 100644
--- a/Makefile
+++ b/Makefile
@@ -603,6 +603,7 @@ vmlinux-init := $(head-y) $(init-y)
 vmlinux-main := $(core-y) $(libs-y) $(drivers-y) $(net-y)
 vmlinux-all  := $(vmlinux-init) $(vmlinux-main)
 vmlinux-lds  := arch/$(ARCH)/kernel/vmlinux.lds
+export KBUILD_VMLINUX_OBJS := $(vmlinux-all)
 
 # Rule to link vmlinux - also used during CONFIG_KALLSYMS
 # May be overridden by arch/$(ARCH)/Makefile
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 65e0a79..d5bbbcc 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -63,16 +63,16 @@ quiet_cmd_modpost = MODPOST $(words $(filter-out vmlinux FORCE, $^)) modules
 	$(if $(KBUILD_EXTMOD),-i,-o) $(kernelsymfile) \
 	$(if $(KBUILD_EXTMOD),-I $(modulesymfile)) \
 	$(if $(KBUILD_EXTMOD),-o $(modulesymfile)) \
-	$(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w) \
-	$(wildcard vmlinux) $(filter-out FORCE,$^)
+	$(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w)
 
 PHONY += __modpost
 __modpost: $(modules:.ko=.o) FORCE
-	$(call cmd,modpost)
+	$(call cmd,modpost) $(wildcard vmlinux) $(filter-out FORCE,$^)
 
 quiet_cmd_kernel-mod = MODPOST $@
-      cmd_kernel-mod = $(cmd_modpost)
+      cmd_kernel-mod = $(cmd_modpost) $(KBUILD_VMLINUX_OBJS)
 
+PHONY += vmlinux
 vmlinux: FORCE
 	$(call cmd,kernel-mod)
 
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index c4b5398..ecf5dff 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -333,10 +333,10 @@ void release_file(void *file, unsigned long size)
 	munmap(file, size);
 }
 
-static void parse_elf(struct elf_info *info, const char *filename)
+static int parse_elf(struct elf_info *info, const char *filename)
 {
 	unsigned int i;
-	Elf_Ehdr *hdr = info->hdr;
+	Elf_Ehdr *hdr;
 	Elf_Shdr *sechdrs;
 	Elf_Sym  *sym;
 
@@ -346,9 +346,18 @@ static void parse_elf(struct elf_info *info, const char *filename)
 		exit(1);
 	}
 	info->hdr = hdr;
-	if (info->size < sizeof(*hdr))
-		goto truncated;
-
+	if (info->size < sizeof(*hdr)) {
+		/* file too small, assume this is an empty .o file */
+		return 0;
+	}
+	/* Is this a valid ELF file? */
+	if ((hdr->e_ident[EI_MAG0] != ELFMAG0) ||
+	    (hdr->e_ident[EI_MAG1] != ELFMAG1) ||
+	    (hdr->e_ident[EI_MAG2] != ELFMAG2) ||
+	    (hdr->e_ident[EI_MAG3] != ELFMAG3)) {
+		/* Not an ELF file - silently ignore it */
+		return 0;
+	}
 	/* Fix endianness in ELF header */
 	hdr->e_shoff    = TO_NATIVE(hdr->e_shoff);
 	hdr->e_shstrndx = TO_NATIVE(hdr->e_shstrndx);
@@ -371,8 +380,10 @@ static void parse_elf(struct elf_info *info, const char *filename)
 			= (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
 		const char *secname;
 
-		if (sechdrs[i].sh_offset > info->size)
-			goto truncated;
+		if (sechdrs[i].sh_offset > info->size) {
+			fatal("%s is truncated. sechdrs[i].sh_offset=%u > sizeof(*hrd)=%ul\n", filename, (unsigned int)sechdrs[i].sh_offset, sizeof(*hdr));
+			return 0;
+		}
 		secname = secstrings + sechdrs[i].sh_name;
 		if (strcmp(secname, ".modinfo") == 0) {
 			info->modinfo = (void *)hdr + sechdrs[i].sh_offset;
@@ -407,10 +418,7 @@ static void parse_elf(struct elf_info *info, const char *filename)
 		sym->st_value = TO_NATIVE(sym->st_value);
 		sym->st_size  = TO_NATIVE(sym->st_size);
 	}
-	return;
-
- truncated:
-	fatal("%s is truncated.\n", filename);
+	return 1;
 }
 
 static void parse_elf_finish(struct elf_info *info)
@@ -1088,7 +1096,8 @@ static void read_symbols(char *modname)
 	struct elf_info info = { };
 	Elf_Sym *sym;
 
-	parse_elf(&info, modname);
+	if (!parse_elf(&info, modname))
+		return;
 
 	mod = new_module(modname);
 
-- 
1.4.4.2


>From e7ac21ad1e50a1ab3a73a3869649cea952acc101 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Mon, 26 Feb 2007 16:45:41 +0100
Subject: kbuild: whitelist section mismatch in init/main.c

In init/main.c we have a reference from rest_init() to .init.text
which is intentional.
Rename the function 'init' to 'kernel_init' to make it a
kernel wide unique symbol and whitelist the reference.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 init/main.c           |    6 +++---
 scripts/mod/modpost.c |   15 ++++++++++++++-
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/init/main.c b/init/main.c
index a92989e..7a92b4c 100644
--- a/init/main.c
+++ b/init/main.c
@@ -82,7 +82,7 @@
 #warning gcc-4.1.0 is known to miscompile the kernel.  A different compiler version is recommended.
 #endif
 
-static int init(void *);
+static int kernel_init(void *);
 
 extern void init_IRQ(void);
 extern void fork_init(unsigned long);
@@ -435,7 +435,7 @@ static void __init setup_command_line(char *command_line)
 static void noinline rest_init(void)
 	__releases(kernel_lock)
 {
-	kernel_thread(init, NULL, CLONE_FS | CLONE_SIGHAND);
+	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
 	numa_default_policy();
 	unlock_kernel();
 
@@ -772,7 +772,7 @@ static int noinline init_post(void)
 	panic("No init found.  Try passing init= option to kernel.");
 }
 
-static int __init init(void * unused)
+static int __init kernel_init(void * unused)
 {
 	lock_kernel();
 	/*
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index ecf5dff..1c076bf 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -589,7 +589,7 @@ static int strrcmp(const char *s, const char *sub)
  *   the pattern is identified by:
  *   tosec   = .init.text | .exit.text | .init.data
  *   fromsec = .data
- *   atsym = *driver, *_template, *_sht, *_ops, *_probe, *probe_one
+ *   atsym = *driver, *_template, *_sht, *_ops, *_probe, *probe_one, *_console
  *
  * Pattern 3:
  *   Some symbols belong to init section but still it is ok to reference
@@ -599,6 +599,14 @@ static int strrcmp(const char *s, const char *sub)
  *   For ex. symbols marking the init section boundaries.
  *   This pattern is identified by
  *   refsymname = __init_begin, _sinittext, _einittext
+ * Pattern 4:
+ *   During the early init phase we have references from .init.text to
+ *   .text we have an intended section mismatch - do not warn about it.
+ *   See kernel_init() in init/main.c
+ *   tosec   = .init.text
+ *   fromsec = .text
+ *   atsym = kernel_init
+ *   Some symbols belong to init section but still it is ok to reference
  **/
 static int secref_whitelist(const char *modname, const char *tosec,
 			    const char *fromsec, const char *atsym,
@@ -668,6 +676,11 @@ static int secref_whitelist(const char *modname, const char *tosec,
 			if (strcmp(refsymname, *s) == 0)
 				return 1;
 	}
+	/* Check for pattern 4 */
+	if ((strcmp(tosec, ".init.text") == 0) &&
+	    (strcmp(fromsec, ".text") == 0) &&
+	    (strcmp(refsymname, "kernel_init") == 0))
+		return 1;
 	return 0;
 }
 
-- 
1.4.4.2


>From 297eb8e1e0df56efd25ab32647d6f43715a06f6c Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Mon, 26 Feb 2007 17:49:06 +0100
Subject: kbuild: fix warnings from .pci_fixup section

Now where we do not pass vmlinux to modpost we started
to see section mismatch warnings from .pci_fixup.
Refactored code a little to include these in the
whitelist again.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |   44 +++++++++++++++++++++++++-------------------
 1 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 1c076bf..2b3b066 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -592,6 +592,14 @@ static int strrcmp(const char *s, const char *sub)
  *   atsym = *driver, *_template, *_sht, *_ops, *_probe, *probe_one, *_console
  *
  * Pattern 3:
+ *   Whitelist all references from .pci_fixup* section to .init.text
+ *   This is part of the PCI init when built-in
+ *
+ * Pattern 4:
+ *   Whitelist all refereces from .text.head to .init.data
+ *   Whitelist all refereces from .text.head to .init.text
+ *
+ * Pattern 5:
  *   Some symbols belong to init section but still it is ok to reference
  *   these from non-init sections as these symbols don't have any memory
  *   allocated for them and symbol address and value are same. So even
@@ -599,7 +607,8 @@ static int strrcmp(const char *s, const char *sub)
  *   For ex. symbols marking the init section boundaries.
  *   This pattern is identified by
  *   refsymname = __init_begin, _sinittext, _einittext
- * Pattern 4:
+ *
+ * Pattern 6:
  *   During the early init phase we have references from .init.text to
  *   .text we have an intended section mismatch - do not warn about it.
  *   See kernel_init() in init/main.c
@@ -657,26 +666,23 @@ static int secref_whitelist(const char *modname, const char *tosec,
 	if (f1 && f2)
 		return 1;
 
-	/* Whitelist all references from .pci_fixup section if vmlinux
-	 * Whitelist all refereces from .text.head to .init.data if vmlinux
-	 * Whitelist all refereces from .text.head to .init.text if vmlinux
-	 */
-	if (is_vmlinux(modname)) {
-		if ((strcmp(fromsec, ".pci_fixup") == 0) &&
-		    (strcmp(tosec, ".init.text") == 0))
-		return 1;
-
-		if ((strcmp(fromsec, ".text.head") == 0) &&
-			((strcmp(tosec, ".init.data") == 0) ||
-			(strcmp(tosec, ".init.text") == 0)))
-		return 1;
+	/* Check for pattern 3 */
+	if ((strncmp(fromsec, ".pci_fixup", strlen(".pci_fixup")) == 0) &&
+	    (strcmp(tosec, ".init.text") == 0))
+	return 1;
 
-		/* Check for pattern 3 */
-		for (s = pat3refsym; *s; s++)
-			if (strcmp(refsymname, *s) == 0)
-				return 1;
-	}
 	/* Check for pattern 4 */
+	if ((strcmp(fromsec, ".text.head") == 0) &&
+		((strcmp(tosec, ".init.data") == 0) ||
+		(strcmp(tosec, ".init.text") == 0)))
+	return 1;
+
+	/* Check for pattern 5 */
+	for (s = pat3refsym; *s; s++)
+		if (strcmp(refsymname, *s) == 0)
+			return 1;
+
+	/* Check for pattern 6 */
 	if ((strcmp(tosec, ".init.text") == 0) &&
 	    (strcmp(fromsec, ".text") == 0) &&
 	    (strcmp(refsymname, "kernel_init") == 0))
-- 
1.4.4.2


>From 3201d6a1c1336ee37b701c6117a4694a4bbbc88c Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Mon, 26 Feb 2007 19:46:52 +0100
Subject: kbuild: fix segmentation fault in modpost

If modpost was called manually with filenames without '/'
then modpost would segfault.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 2b3b066..15d69c4 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1344,6 +1344,7 @@ static void add_depends(struct buffer *b, struct module *mod,
 	buf_printf(b, "__attribute__((section(\".modinfo\"))) =\n");
 	buf_printf(b, "\"depends=");
 	for (s = mod->unres; s; s = s->next) {
+		const char *p;
 		if (!s->module)
 			continue;
 
@@ -1351,8 +1352,11 @@ static void add_depends(struct buffer *b, struct module *mod,
 			continue;
 
 		s->module->seen = 1;
-		buf_printf(b, "%s%s", first ? "" : ",",
-			   strrchr(s->module->name, '/') + 1);
+		if ((p = strrchr(s->module->name, '/')) != NULL)
+			p++;
+		else
+			p = s->module->name;
+		buf_printf(b, "%s%s", first ? "" : ",", p);
 		first = 0;
 	}
 	buf_printf(b, "\";\n");
-- 
1.4.4.2


>From b8c477af29397acf3b9f1458d4df79d267a1d3d7 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Tue, 27 Feb 2007 09:14:58 +0100
Subject: kbuild: whitelist logo references from .text to .init.data

drivers/video/logo has references from .text to .init.data
but function is only used during early init.
So reference is OK and we do not want to warn about them =>
whitelist the reference.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 15d69c4..9042039 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -616,6 +616,15 @@ static int strrcmp(const char *s, const char *sub)
  *   fromsec = .text
  *   atsym = kernel_init
  *   Some symbols belong to init section but still it is ok to reference
+ *
+ * Pattern 7:
+ *  Logos used in drivers/video/logo reside in __initdata but the
+ *  funtion that references them are EXPORT_SYMBOL() so cannot be
+ *  marker __init. So we whitelist them here.
+ *  The pattern is:
+ *  tosec      = .init.data
+ *  fromsec    = .text*
+ *  refsymname = logo_
  **/
 static int secref_whitelist(const char *modname, const char *tosec,
 			    const char *fromsec, const char *atsym,
@@ -687,6 +696,12 @@ static int secref_whitelist(const char *modname, const char *tosec,
 	    (strcmp(fromsec, ".text") == 0) &&
 	    (strcmp(refsymname, "kernel_init") == 0))
 		return 1;
+
+	/* Check for pattern 7 */
+	if ((strcmp(tosec, ".init.data") == 0) &&
+	    (strncmp(fromsec, ".text", strlen(".text")) == 0) &&
+	    (strncmp(refsymname, "logo_", strlen("logo_")) == 0))
+		return 1;
 	return 0;
 }
 
-- 
1.4.4.2


>From 79eb05acd2864302b359bd3e690f0a72643bba0d Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sat, 3 Mar 2007 19:34:23 +0100
Subject: kbuild: silence section mismatch warnings for exported functions

There are legitime cases of exported functions which
is marked __init. Some examples are in drivers/pci/
where the pci subsystem export symbols to be used by other
__init functions.
So ignore references from ksymtab* to .init.text

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 9042039..9e80dc5 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -625,6 +625,13 @@ static int strrcmp(const char *s, const char *sub)
  *  tosec      = .init.data
  *  fromsec    = .text*
  *  refsymname = logo_
+ *
+ * Pattern 8:
+ *  Symbols exported may be marked __init because we need to
+ *  export functions that are only used by init function.
+ *  The pattern is:
+ *  tosec    = .init.text
+ *  fromsec  = __ksymtab*
  **/
 static int secref_whitelist(const char *modname, const char *tosec,
 			    const char *fromsec, const char *atsym,
@@ -702,6 +709,10 @@ static int secref_whitelist(const char *modname, const char *tosec,
 	    (strncmp(fromsec, ".text", strlen(".text")) == 0) &&
 	    (strncmp(refsymname, "logo_", strlen("logo_")) == 0))
 		return 1;
+	/* Check for pattern 8 */
+	if ((strcmp(tosec, ".init.text") == 0) &&
+	    (strncmp(fromsec, "__ksymtab", strlen("__ksymtab")) == 0))
+		return 1;
 	return 0;
 }
 
-- 
1.4.4.2

