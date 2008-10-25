Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543AbYJYVMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbYJYVMu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 17:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbYJYVMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 17:12:42 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:49623 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbYJYVMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 17:12:42 -0400
Date: Sat, 25 Oct 2008 23:11:07 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Evgeniy Manachkin <sfstudio@mail.ru>, Alan Cox <alan@redhat.com>,
       Stable <stable@kernel.org>
Subject: [PULL] kbuild fixes for -rc1
Message-ID: <20081025211107.GA20417@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Please pull the following two fixes for kbuild.
One fix for make rpm (which is also stable material)
And one fix so we are more robust for wrong asm symlinks

None of these has been in -next but they are trivial and
I would like to see them applied soon.

Thanks,

	Sam

The following changes since commit e013e13bf605b9e6b702adffbe2853cfc60e7806:
  Jens Axboe (1):
        libata: fix bug with non-ncq devices

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fixes.git master

Evgeniy Manachkin (1):
      kbuild: mkspec - fix build rpm

Sam Ravnborg (1):
      kbuild: improve check-symlink

 Makefile               |    5 +++++
 scripts/package/mkspec |    3 +++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index 8e54051..cacb624 100644
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
 
diff --git a/scripts/package/mkspec b/scripts/package/mkspec
index ffd61fe..113d373 100755
--- a/scripts/package/mkspec
+++ b/scripts/package/mkspec
@@ -64,8 +64,10 @@ fi
 echo "%install"
 echo "%ifarch ia64"
 echo 'mkdir -p $RPM_BUILD_ROOT/boot/efi $RPM_BUILD_ROOT/lib/modules'
+echo 'mkdir -p $RPM_BUILD_ROOT/boot/efi $RPM_BUILD_ROOT/lib/firmware'
 echo "%else"
 echo 'mkdir -p $RPM_BUILD_ROOT/boot $RPM_BUILD_ROOT/lib/modules'
+echo 'mkdir -p $RPM_BUILD_ROOT/boot $RPM_BUILD_ROOT/lib/firmware'
 echo "%endif"
 
 echo 'INSTALL_MOD_PATH=$RPM_BUILD_ROOT make %{_smp_mflags} modules_install'
@@ -92,5 +94,6 @@ echo "%files"
 echo '%defattr (-, root, root)'
 echo "%dir /lib/modules"
 echo "/lib/modules/$KERNELRELEASE"
+echo "/lib/firmware"
 echo "/boot/*"
 echo ""
