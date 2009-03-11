Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbZCKTWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbZCKTWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 15:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbZCKTWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 15:22:08 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:57133 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbZCKTWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 15:22:07 -0400
Date: Wed, 11 Mar 2009 20:24:02 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Kyle McMartin <kyle@infradead.org>,
       Gilles Espinasse <g.esp@free.fr>, Josh Hunt <josh@scalex86.org>,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [GIT] kbuild
Message-ID: <20090311192402.GA3148@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

A few late kbuild related fixes.

1) Fix unidef to build on latest RAWHIDE. They have doen some changes that
   casued unifdef to fail.

2) Remove unused option to depmod. This is not fixing a real bug but
   gives us better busybox compatibility.

3) Two fixes for make rpm - it should be working again after long time
   suffering.

Please pull,

	Thanks - Sam


The following changes since commit 559595a985e106d2fa9f0c79b7f5805453fed593:
  Linus Torvalds (1):
        Merge branch 'merge' of git://git.kernel.org/.../benh/powerpc

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fixes.git master

Gilles Espinasse (1):
      kbuild: remove unused -r option for module-init-tool depmod

Josh Hunt (2):
      kbuild: fix mkspec to cleanup RPM_BUILD_ROOT
      kbuild: fix 'make rpm' when CONFIG_LOCALVERSION_AUTO=y and using SCM tree

Justin P. Mattock (1):
      kbuild: fix C libary confusion in unifdef.c due to getline()

 Makefile                 |   18 ++++++++++++------
 scripts/package/Makefile |    3 ++-
 scripts/package/mkspec   |    2 +-
 scripts/unifdef.c        |    6 +++---
 4 files changed, 18 insertions(+), 11 deletions(-)

Full diff for reference.

diff --git a/Makefile b/Makefile
index d04ee0a..5a5b82e 100644
--- a/Makefile
+++ b/Makefile
@@ -904,12 +904,18 @@ localver = $(subst $(space),, $(string) \
 # and if the SCM is know a tag from the SCM is appended.
 # The appended tag is determined by the SCM used.
 #
-# Currently, only git is supported.
-# Other SCMs can edit scripts/setlocalversion and add the appropriate
-# checks as needed.
+# .scmversion is used when generating rpm packages so we do not loose
+# the version information from the SCM when we do the build of the kernel
+# from the copied source
 ifdef CONFIG_LOCALVERSION_AUTO
-	_localver-auto = $(shell $(CONFIG_SHELL) \
-	                  $(srctree)/scripts/setlocalversion $(srctree))
+
+ifeq ($(wildcard .scmversion),)
+        _localver-auto = $(shell $(CONFIG_SHELL) \
+                         $(srctree)/scripts/setlocalversion $(srctree))
+else
+        _localver-auto = $(shell cat .scmversion 2> /dev/null)
+endif
+
 	localver-auto  = $(LOCALVERSION)$(_localver-auto)
 endif
 
@@ -1537,7 +1543,7 @@ quiet_cmd_depmod = DEPMOD  $(KERNELRELEASE)
       cmd_depmod = \
 	if [ -r System.map -a -x $(DEPMOD) ]; then                              \
 		$(DEPMOD) -ae -F System.map                                     \
-		$(if $(strip $(INSTALL_MOD_PATH)), -b $(INSTALL_MOD_PATH) -r)   \
+		$(if $(strip $(INSTALL_MOD_PATH)), -b $(INSTALL_MOD_PATH) )     \
 		$(KERNELRELEASE);                                               \
 	fi
 
diff --git a/scripts/package/Makefile b/scripts/package/Makefile
index 8c6b7b0..fa4a0a1 100644
--- a/scripts/package/Makefile
+++ b/scripts/package/Makefile
@@ -35,9 +35,10 @@ $(objtree)/kernel.spec: $(MKSPEC) $(srctree)/Makefile
 rpm-pkg rpm: $(objtree)/kernel.spec FORCE
 	$(MAKE) clean
 	$(PREV) ln -sf $(srctree) $(KERNELPATH)
+	$(CONFIG_SHELL) $(srctree)/scripts/setlocalversion > $(objtree)/.scmversion
 	$(PREV) tar -cz $(RCS_TAR_IGNORE) -f $(KERNELPATH).tar.gz $(KERNELPATH)/.
 	$(PREV) rm $(KERNELPATH)
-
+	rm -f $(objtree)/.scmversion
 	set -e; \
 	$(CONFIG_SHELL) $(srctree)/scripts/mkversion > $(objtree)/.tmp_version
 	set -e; \
diff --git a/scripts/package/mkspec b/scripts/package/mkspec
index ee448cd..3d93f8c 100755
--- a/scripts/package/mkspec
+++ b/scripts/package/mkspec
@@ -96,7 +96,7 @@ echo "%endif"
 
 echo ""
 echo "%clean"
-echo '#echo -rf $RPM_BUILD_ROOT'
+echo 'rm -rf $RPM_BUILD_ROOT'
 echo ""
 echo "%files"
 echo '%defattr (-, root, root)'
diff --git a/scripts/unifdef.c b/scripts/unifdef.c
index 552025e..05a31a6 100644
--- a/scripts/unifdef.c
+++ b/scripts/unifdef.c
@@ -206,7 +206,7 @@ static void             done(void);
 static void             error(const char *);
 static int              findsym(const char *);
 static void             flushline(bool);
-static Linetype         getline(void);
+static Linetype         get_line(void);
 static Linetype         ifeval(const char **);
 static void             ignoreoff(void);
 static void             ignoreon(void);
@@ -512,7 +512,7 @@ process(void)
 
 	for (;;) {
 		linenum++;
-		lineval = getline();
+		lineval = get_line();
 		trans_table[ifstate[depth]][lineval]();
 		debug("process %s -> %s depth %d",
 		    linetype_name[lineval],
@@ -526,7 +526,7 @@ process(void)
  * help from skipcomment().
  */
 static Linetype
-getline(void)
+get_line(void)
 {
 	const char *cp;
 	int cursym;
