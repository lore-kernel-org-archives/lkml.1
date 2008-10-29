Return-Path: <linux-kernel-owner+w=401wt.eu-S1755560AbYJ2V4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbYJ2V4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 17:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754303AbYJ2Vz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 17:55:59 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:33756 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbYJ2Vz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 17:55:58 -0400
Date: Wed, 29 Oct 2008 22:51:37 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Huntwork <jhuntwork@lightcubesolutions.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ian Campbell <ijc@hellion.org.uk>, Trent Piepho <tpiepho@freescale.com>,
       Ashutosh Naik <ashutosh.naik@gmail.com>, Peter Volkov <pva@gentoo.org>,
       Jan Beulich <jbeulich@novell.com>, Thomas Volpini <tvolpini@gmx.net>,
       Jeremy Kerr <jk@ozlabs.org>, Mike Frysinger <vapier@gentoo.org>,
       Evgeniy Manachkin <sfstudio@mail.ru>
Subject: [PULL] kbuild fixes
Message-ID: <20081029215137.GA25023@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

A greater batch of kbuild fixes than usual due to my absense for
a few months.

I included the change to include/init.h as it allows
people to start suing these without getting into
merge order troubles and they are simple additions.

The rest is trivial fixes and incompatibility with
older perl version. The full diff does not look scary.

I expect at least one more pull as I have not been through
all patches yet - and need to visit bugzilla too.

Details follows.

Please pull - thanks!

	Sam


The following changes since commit e946217e4fdaa67681bbabfa8e6b18641921f750:
  Linus Torvalds (1):
        Merge branch 'tracing-fixes-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fixes.git master

Ashutosh Naik (1):
      kbuild: prevent modpost from looking for a .cmd file for a static library linked into a module

Evgeniy Manachkin (1):
      kbuild: mkspec - fix build rpm

Ian Campbell (1):
      kbuild: do not include arch/<ARCH>/include/asm in find-sources twice.

Jan Beulich (1):
      adjust init section definitions

Jeremy Huntwork (1):
      Fix incompatibility with versions of Perl less than 5.6.0

Jeremy Kerr (1):
      scripts/package: don't break if %{_smp_mflags} isn't set

Mike Frysinger (1):
      kbuild: setlocalversion: dont include svn change count

Peter Volkov (1):
      kbuild: fix KBUILD_EXTRA_SYMBOLS

Sam Ravnborg (1):
      kbuild: improve check-symlink

Thomas Volpini (1):
      scripts/checksyscalls.sh: fix for non-gnu sed

Trent Piepho (1):
      kbuild: tag with git revision when git describe is missing

 Makefile                   |    8 +++++++-
 include/linux/init.h       |    6 +++++-
 scripts/Makefile.modpost   |    2 +-
 scripts/checksyscalls.sh   |    4 ++--
 scripts/headers_check.pl   |   10 +++++-----
 scripts/headers_install.pl |   17 +++++++++--------
 scripts/mod/sumversion.c   |   12 +++++++++++-
 scripts/package/mkspec     |    5 ++++-
 scripts/setlocalversion    |    6 ++++--
 9 files changed, 48 insertions(+), 22 deletions(-)

diff --git a/Makefile b/Makefile
index a7f2068..d500817 100644
--- a/Makefile
+++ b/Makefile
@@ -961,6 +961,7 @@ export CPPFLAGS_vmlinux.lds += -P -C -U$(ARCH)
 
 # The asm symlink changes when $(ARCH) changes.
 # Detect this and ask user to run make mrproper
+# If asm is a stale symlink (point to dir that does not exist) remove it
 define check-symlink
 	set -e;                                                            \
 	if [ -L include/asm ]; then                                        \
@@ -970,6 +971,10 @@ define check-symlink
 			echo "       set ARCH or save .config and run 'make mrproper' to fix it";             \
 			exit 1;                                            \
 		fi;                                                        \
+		test -e $$asmlink || rm include/asm;                       \
+	elif [ -d include/asm ]; then                                      \
+		echo "ERROR: $@ is a directory but a symlink was expected";\
+		exit 1;                                                    \
 	fi
 endef
 
@@ -1431,7 +1436,8 @@ ALLSOURCE_ARCHS := $(SRCARCH)
 define find-sources
         ( for arch in $(ALLSOURCE_ARCHS) ; do \
 	       find $(__srctree)arch/$${arch} $(RCS_FIND_IGNORE) \
-	            -name $1 -print; \
+		    -wholename $(__srctree)arch/$${arch}/include/asm -type d -prune \
+	            -o -name $1 -print; \
 	  done ; \
 	  find $(__srctree)security/selinux/include $(RCS_FIND_IGNORE) \
 	       -name $1 -print; \
diff --git a/include/linux/init.h b/include/linux/init.h
index 0c12646..68cb026 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -112,21 +112,25 @@
 #define __FINIT		.previous
 
 #define __INITDATA	.section	".init.data","aw"
+#define __INITRODATA	.section	".init.rodata","a"
 #define __FINITDATA	.previous
 
 #define __DEVINIT        .section	".devinit.text", "ax"
 #define __DEVINITDATA    .section	".devinit.data", "aw"
+#define __DEVINITRODATA  .section	".devinit.rodata", "a"
 
 #define __CPUINIT        .section	".cpuinit.text", "ax"
 #define __CPUINITDATA    .section	".cpuinit.data", "aw"
+#define __CPUINITRODATA  .section	".cpuinit.rodata", "a"
 
 #define __MEMINIT        .section	".meminit.text", "ax"
 #define __MEMINITDATA    .section	".meminit.data", "aw"
+#define __MEMINITRODATA  .section	".meminit.rodata", "a"
 
 /* silence warnings when references are OK */
 #define __REF            .section       ".ref.text", "ax"
 #define __REFDATA        .section       ".ref.data", "aw"
-#define __REFCONST       .section       ".ref.rodata", "aw"
+#define __REFCONST       .section       ".ref.rodata", "a"
 
 #ifndef __ASSEMBLY__
 /*
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 9ee9783..f4053dc 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -82,7 +82,7 @@ modpost = scripts/mod/modpost                    \
  $(if $(CONFIG_MODULE_SRCVERSION_ALL),-a,)       \
  $(if $(KBUILD_EXTMOD),-i,-o) $(kernelsymfile)   \
  $(if $(KBUILD_EXTMOD),-I $(modulesymfile))      \
- $(if $(KBUILD_EXTRA_SYMBOLS), $(patsubst %, -e %,$(EXTRA_SYMBOLS))) \
+ $(if $(KBUILD_EXTRA_SYMBOLS), $(patsubst %, -e %,$(KBUILD_EXTRA_SYMBOLS))) \
  $(if $(KBUILD_EXTMOD),-o $(modulesymfile))      \
  $(if $(CONFIG_DEBUG_SECTION_MISMATCH),,-S)      \
  $(if $(CONFIG_MARKERS),-K $(kernelmarkersfile)) \
diff --git a/scripts/checksyscalls.sh b/scripts/checksyscalls.sh
index 41564b1..60d00d1 100755
--- a/scripts/checksyscalls.sh
+++ b/scripts/checksyscalls.sh
@@ -113,10 +113,10 @@ EOF
 }
 
 syscall_list() {
-sed -n -e '/^\#define/ { s/[^_]*__NR_\([^[:space:]]*\).*/\
+sed -n -e '/^\#define/ s/[^_]*__NR_\([^[:space:]]*\).*/\
 \#if !defined \(__NR_\1\) \&\& !defined \(__IGNORE_\1\)\
 \#warning syscall \1 not implemented\
-\#endif/p }' $1
+\#endif/p' $1
 }
 
 (ignore_list && syscall_list ${srctree}/arch/x86/include/asm/unistd_32.h) | \
diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
index 15d53a6..488a3b1 100644
--- a/scripts/headers_check.pl
+++ b/scripts/headers_check.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/perl -w
 #
 # headers_check.pl execute a number of trivial consistency checks
 #
@@ -17,7 +17,6 @@
 # 2) TODO: check for leaked CONFIG_ symbols
 
 use strict;
-use warnings;
 
 my ($dir, $arch, @files) = @ARGV;
 
@@ -27,14 +26,15 @@ my $lineno = 0;
 my $filename;
 
 foreach my $file (@files) {
+	local *FH;
 	$filename = $file;
-	open(my $fh, '<', "$filename") or die "$filename: $!\n";
+	open(FH, "<$filename") or die "$filename: $!\n";
 	$lineno = 0;
-	while ($line = <$fh>) {
+	while ($line = <FH>) {
 		$lineno++;
 		check_include();
 	}
-	close $fh;
+	close FH;
 }
 exit $ret;
 
diff --git a/scripts/headers_install.pl b/scripts/headers_install.pl
index 68591cd..7d2b414 100644
--- a/scripts/headers_install.pl
+++ b/scripts/headers_install.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/perl -w
 #
 # headers_install prepare the listed header files for use in
 # user space and copy the files to their destination.
@@ -17,28 +17,29 @@
 # 3) Drop all sections defined out by __KERNEL__ (using unifdef)
 
 use strict;
-use warnings;
 
 my ($readdir, $installdir, $arch, @files) = @ARGV;
 
 my $unifdef = "scripts/unifdef -U__KERNEL__";
 
 foreach my $file (@files) {
+	local *INFILE;
+	local *OUTFILE;
 	my $tmpfile = "$installdir/$file.tmp";
-	open(my $infile, '<', "$readdir/$file")
+	open(INFILE, "<$readdir/$file")
 		or die "$readdir/$file: $!\n";
-	open(my $outfile, '>', "$tmpfile") or die "$tmpfile: $!\n";
-	while (my $line = <$infile>) {
+	open(OUTFILE, ">$tmpfile") or die "$tmpfile: $!\n";
+	while (my $line = <INFILE>) {
 		$line =~ s/([\s(])__user\s/$1/g;
 		$line =~ s/([\s(])__force\s/$1/g;
 		$line =~ s/([\s(])__iomem\s/$1/g;
 		$line =~ s/\s__attribute_const__\s/ /g;
 		$line =~ s/\s__attribute_const__$//g;
 		$line =~ s/^#include <linux\/compiler.h>//;
-		printf $outfile "%s", $line;
+		printf OUTFILE "%s", $line;
 	}
-	close $outfile;
-	close $infile;
+	close OUTFILE;
+	close INFILE;
 	system $unifdef . " $tmpfile > $installdir/$file";
 	unlink $tmpfile;
 }
diff --git a/scripts/mod/sumversion.c b/scripts/mod/sumversion.c
index d9cc690..aadc522 100644
--- a/scripts/mod/sumversion.c
+++ b/scripts/mod/sumversion.c
@@ -290,6 +290,15 @@ static int parse_file(const char *fname, struct md4_ctx *md)
 	release_file(file, len);
 	return 1;
 }
+/* Check whether the file is a static library or not */
+static int is_static_library(const char *objfile)
+{
+	int len = strlen(objfile);
+	if (objfile[len - 2] == '.' && objfile[len - 1] == 'a')
+		return 1;
+	else
+		return 0;
+}
 
 /* We have dir/file.o.  Open dir/.file.o.cmd, look for deps_ line to
  * figure out source file. */
@@ -420,7 +429,8 @@ void get_src_version(const char *modname, char sum[], unsigned sumlen)
 	while ((fname = strsep(&sources, " ")) != NULL) {
 		if (!*fname)
 			continue;
-		if (!parse_source_files(fname, &md))
+		if (!(is_static_library(fname)) &&
+				!parse_source_files(fname, &md))
 			goto release;
 	}
 
diff --git a/scripts/package/mkspec b/scripts/package/mkspec
index ffd61fe..2500886 100755
--- a/scripts/package/mkspec
+++ b/scripts/package/mkspec
@@ -57,15 +57,17 @@ fi
 echo "%build"
 
 if ! $PREBUILT; then
-echo "make clean && make %{_smp_mflags}"
+echo "make clean && make %{?_smp_mflags}"
 echo ""
 fi
 
 echo "%install"
 echo "%ifarch ia64"
 echo 'mkdir -p $RPM_BUILD_ROOT/boot/efi $RPM_BUILD_ROOT/lib/modules'
+echo 'mkdir -p $RPM_BUILD_ROOT/lib/firmware'
 echo "%else"
 echo 'mkdir -p $RPM_BUILD_ROOT/boot $RPM_BUILD_ROOT/lib/modules'
+echo 'mkdir -p $RPM_BUILD_ROOT/lib/firmware'
 echo "%endif"
 
 echo 'INSTALL_MOD_PATH=$RPM_BUILD_ROOT make %{_smp_mflags} modules_install'
@@ -92,5 +94,6 @@ echo "%files"
 echo '%defattr (-, root, root)'
 echo "%dir /lib/modules"
 echo "/lib/modules/$KERNELRELEASE"
+echo "/lib/firmware"
 echo "/boot/*"
 echo ""
diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index 83b7512..72d2335 100755
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -9,11 +9,13 @@ usage() {
 cd "${1:-.}" || usage
 
 # Check for git and a git repo.
-if head=`git rev-parse --verify HEAD 2>/dev/null`; then
+if head=`git rev-parse --verify --short HEAD 2>/dev/null`; then
 	# Do we have an untagged version?
 	if git name-rev --tags HEAD | grep -E '^HEAD[[:space:]]+(.*~[0-9]*|undefined)$' > /dev/null; then
 		if tag=`git describe 2>/dev/null`; then
 			echo $tag | awk -F- '{printf("-%05d-%s", $(NF-1),$(NF))}'
+		else
+			printf '%s%s' -g $head
 		fi
 	fi
 
@@ -55,7 +57,7 @@ if rev=`svn info 2>/dev/null | grep '^Revision'`; then
 
 	# Are there uncommitted changes?
 	if [ $changes != 0 ]; then
-		printf -- '-svn%s%s%s' "$rev" -dirty "$changes"
+		printf -- '-svn%s%s' "$rev" -dirty
 	else
 		printf -- '-svn%s' "$rev"
 	fi
