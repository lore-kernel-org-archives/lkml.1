Return-Path: <linux-kernel-owner+w=401wt.eu-S1762403AbYESSZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762403AbYESSZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 14:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbYESSZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 14:25:17 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:42955 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbYESSZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 14:25:15 -0400
Date: Mon, 19 May 2008 20:25:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Jan Blunck <jblunck@suse.de>,
       Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Paulo Marques <pmarques@grupopie.com>,
       =?utf-8?B?Uy4gw4dhxJ9sYXI=?= Onur <caglar@pardus.org.tr>,
       Andi Kleen <ak@linux.intel.com>, Masatake YAMATO <yamato@redhat.com>
Subject: [GIT PATCH] kbuild fixes
Message-ID: <20080519182552.GB24285@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Please pull from:

    ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fixes.git

Following fixes has been collected:

Andi Kleen (1):
      kbuild: disable modpost warnings for linkonce sections

Christophe Jaillet (1):
      kconfig: incorrect 'len' field initialisation ?

Jan Blunck (1):
      Don't clean bounds.h and asm-offsets.h

Masatake YAMATO (1):
      kbuild: escape meta characters in regular expression in make TAGS

Randy Dunlap (1):
      kernel-doc: allow unnamed bit-fields

S.Çağlar Onur (1):
      Remove *.rej pattern from .gitignore

Sam Ravnborg (2):
      MAINTAINERS: document names of new kbuild trees
      kbuild: filter away debug symbols from kernel symbols


The kernel-doc patch is not a real 'fix' as such.
But as the patch most likely does not prevent your systems from
booting I took it here too.

	Sam


 .gitignore             |    1 -
 Kbuild                 |    3 +--
 MAINTAINERS            |    3 ++-
 Makefile               |    3 ++-
 scripts/kallsyms.c     |    3 +++
 scripts/kconfig/util.c |    2 +-
 scripts/kernel-doc     |    4 +++-
 scripts/mksysmap       |    3 ++-
 scripts/mod/modpost.c  |    2 +-
 9 files changed, 15 insertions(+), 9 deletions(-)


diff --git a/.gitignore b/.gitignore
index 090b293..9c0d650 100644
--- a/.gitignore
+++ b/.gitignore
@@ -54,6 +54,5 @@ series
 cscope.*
 
 *.orig
-*.rej
 *~
 \#*#
diff --git a/Kbuild b/Kbuild
index 32f19c5..e750e9c 100644
--- a/Kbuild
+++ b/Kbuild
@@ -96,5 +96,4 @@ missing-syscalls: scripts/checksyscalls.sh FORCE
 	$(call cmd,syscalls)
 
 # Delete all targets during make clean
-clean-files := $(addprefix $(objtree)/,$(targets))
-
+clean-files := $(addprefix $(objtree)/,$(filter-out $(bounds-file) $(offsets-file),$(targets)))
diff --git a/MAINTAINERS b/MAINTAINERS
index f5583dc..74b1c55 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2318,7 +2318,8 @@ S:	Maintained
 KERNEL BUILD (kbuild: Makefile, scripts/Makefile.*)
 P:	Sam Ravnborg
 M:	sam@ravnborg.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/sam/kbuild.git
+T:	git kernel.org:/pub/scm/linux/kernel/git/sam/kbuild-next.git
+T:	git kernel.org:/pub/scm/linux/kernel/git/sam/kbuild-fixes.git
 L:	linux-kbuild@vger.kernel.org
 S:	Maintained
 
diff --git a/Makefile b/Makefile
index 4492984..f18631f 100644
--- a/Makefile
+++ b/Makefile
@@ -1114,6 +1114,7 @@ MRPROPER_DIRS  += include/config include2 usr/include
 MRPROPER_FILES += .config .config.old include/asm .version .old_version \
                   include/linux/autoconf.h include/linux/version.h      \
                   include/linux/utsrelease.h                            \
+                  include/linux/bounds.h include/asm*/asm-offsets.h     \
 		  Module.symvers tags TAGS cscope*
 
 # clean - Delete most, but leave enough to build external modules
@@ -1431,7 +1432,7 @@ define xtags
 	elif $1 --version 2>&1 | grep -iq emacs; then \
 	    $(all-sources) | xargs $1 -a; \
 	    $(all-kconfigs) | xargs $1 -a \
-		--regex='/^[ \t]*(menu|)config[ \t]+\([a-zA-Z0-9_]+\)/\2/'; \
+		--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/\3/'; \
 	    $(all-defconfigs) | xargs -r $1 -a \
 		--regex='/^#?[ \t]?\(CONFIG_[a-zA-Z0-9_]+\)/\1/'; \
 	else \
diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 5d20a2e..ad2434b 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -108,6 +108,9 @@ static int read_symbol(FILE *in, struct sym_entry *s)
 	/* exclude also MIPS ELF local symbols ($L123 instead of .L123) */
 	else if (str[0] == '$')
 		return -1;
+	/* exclude debugging symbols */
+	else if (stype == 'N')
+		return -1;
 
 	/* include the type field in the symbol name, so that it gets
 	 * compressed together */
diff --git a/scripts/kconfig/util.c b/scripts/kconfig/util.c
index f8e73c0..3cc9f93 100644
--- a/scripts/kconfig/util.c
+++ b/scripts/kconfig/util.c
@@ -77,7 +77,7 @@ struct gstr str_new(void)
 {
 	struct gstr gs;
 	gs.s = malloc(sizeof(char) * 64);
-	gs.len = 16;
+	gs.len = 64;
 	strcpy(gs.s, "\0");
 	return gs;
 }
diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 83cee18..88e3934 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1556,7 +1556,9 @@ sub create_parameterlist($$$) {
 		    push_parameter($2, "$type $1", $file);
 		}
 		elsif ($param =~ m/(.*?):(\d+)/) {
-		    push_parameter($1, "$type:$2", $file)
+		    if ($type ne "") { # skip unnamed bit-fields
+			push_parameter($1, "$type:$2", $file)
+		    }
 		}
 		else {
 		    push_parameter($param, $type, $file);
diff --git a/scripts/mksysmap b/scripts/mksysmap
index 4390fab..6e133a0 100644
--- a/scripts/mksysmap
+++ b/scripts/mksysmap
@@ -32,6 +32,7 @@
 # For System.map filter away:
 #   a - local absolute symbols
 #   U - undefined global symbols
+#   N - debugging symbols
 #   w - local weak symbols
 
 # readprofile starts reading symbols when _stext is found, and
@@ -40,5 +41,5 @@
 # so we just ignore them to let readprofile continue to work.
 # (At least sparc64 has __crc_ in the middle).
 
-$NM -n $1 | grep -v '\( [aUw] \)\|\(__crc_\)\|\( \$[adt]\)' > $2
+$NM -n $1 | grep -v '\( [aNUw] \)\|\(__crc_\)\|\( \$[adt]\)' > $2
 
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 757294b..508c589 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -721,7 +721,7 @@ static int check_section(const char *modname, const char *sec)
 		/* consume all digits */
 		while (*e && e != sec && isdigit(*e))
 			e--;
-		if (*e == '.') {
+		if (*e == '.' && !strstr(sec, ".linkonce")) {
 			warn("%s (%s): unexpected section name.\n"
 			     "The (.[number]+) following section name are "
 			     "ld generated and not expected.\n"
