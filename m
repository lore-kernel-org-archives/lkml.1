Return-Path: <linux-kernel-owner+w=401wt.eu-S1761248AbYEASHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761248AbYEASHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 14:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbYEASHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 14:07:05 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:41732 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924AbYEASHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 14:07:03 -0400
Date: Thu, 1 May 2008 20:07:37 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] kbuild stuff
Message-ID: <20080501180737.GA4195@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Please pull from:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-linus.git

Both patches has been on lkml - buried in some other threads.
So review level is low - but risk is low too.

	Sam

Sam Ravnborg (2):
      kconfig: made check-lxdialog more portable
      kbuild: fix vmlinux.o link


 Makefile                                   |    6 ++++--
 scripts/kconfig/lxdialog/check-lxdialog.sh |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)


diff --git a/Makefile b/Makefile
index d3634cd..5cf8258 100644
--- a/Makefile
+++ b/Makefile
@@ -794,7 +794,7 @@ endif # ifdef CONFIG_KALLSYMS
 quiet_cmd_vmlinux-modpost = LD      $@
       cmd_vmlinux-modpost = $(LD) $(LDFLAGS) -r -o $@                          \
 	 $(vmlinux-init) --start-group $(vmlinux-main) --end-group             \
-	 $(filter-out $(vmlinux-init) $(vmlinux-main) $(vmlinux-lds) FORCE ,$^)
+	 $(filter-out $(vmlinux-init) $(vmlinux-main) FORCE ,$^)
 define rule_vmlinux-modpost
 	:
 	+$(call cmd,vmlinux-modpost)
@@ -818,7 +818,9 @@ endif
 ifdef CONFIG_KALLSYMS
 .tmp_vmlinux1: vmlinux.o
 endif
-vmlinux.o: $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) FORCE
+
+modpost-init := $(filter-out init/built-in.o, $(vmlinux-init))
+vmlinux.o: $(modpost-init) $(vmlinux-main) FORCE
 	$(call if_changed_rule,vmlinux-modpost)
 
 # The actual objects are generated when descending, 
diff --git a/scripts/kconfig/lxdialog/check-lxdialog.sh b/scripts/kconfig/lxdialog/check-lxdialog.sh
index 62e1e02..5552154 100644
--- a/scripts/kconfig/lxdialog/check-lxdialog.sh
+++ b/scripts/kconfig/lxdialog/check-lxdialog.sh
@@ -36,8 +36,10 @@ trap "rm -f $tmp" 0 1 2 3 15
 
 # Check if we can link to ncurses
 check() {
-	echo -e " #include CURSES_LOC \n main() {}" |
-	    $cc -xc - -o $tmp 2> /dev/null
+        $cc -xc - -o $tmp 2>/dev/null <<'EOF'
+#include CURSES_LOC
+main() {}
+EOF
 	if [ $? != 0 ]; then
 	    echo " *** Unable to find the ncurses libraries or the"       1>&2
 	    echo " *** required header files."                            1>&2
