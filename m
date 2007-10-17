Return-Path: <linux-kernel-owner+w=401wt.eu-S1761907AbXJQV2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761907AbXJQV2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 17:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbXJQV2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 17:28:42 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:40851 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864AbXJQV2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 17:28:42 -0400
Date: Wed, 17 Oct 2007 23:30:14 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       kbuild devel <kbuild-devel@lists.sourceforge.net>
Subject: [RFT] kbuild: check asm symlink when building a kernel
Message-ID: <20071017213014.GA13174@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We often hit the situation where the asm symlink
in include/ points to the wrong architecture.
In 9 out of 10 cases thats because we forgot to set
ARCH but sometimes we just reused the same tree
for another ARCH. For the merged x86 tree we need
to create a new symlink but this is not obvious.
So with the following patch we check if the symlink
points to the correct architecture and error
out if this is not the case.

For x86 a "rm include/asm" is enough but we
recommend make mrproper for the general case.

The patch survives my testing but before pushing
it to -mm or -linus I would like a few more to
test it in their environment.
I am a bit unsafe with the use of readlink and cut since
they are not widely used by the kernel
build today.

Any feedback good/bad appreciated!

PS - I know that the lines are too long in the patch but
     breaking them would hurt readability.

	Sam

diff --git a/Makefile b/Makefile
index ed65de7..136d7c2 100644
--- a/Makefile
+++ b/Makefile
@@ -903,14 +903,24 @@ prepare: prepare0
 
 export CPPFLAGS_vmlinux.lds += -P -C -U$(ARCH)
 
-# FIXME: The asm symlink changes when $(ARCH) changes. That's
-# hard to detect, but I suppose "make mrproper" is a good idea
-# before switching between archs anyway.
-
-include/asm:
-	@echo '  SYMLINK $@ -> include/asm-$(SRCARCH)'
-	$(Q)if [ ! -d include ]; then mkdir -p include; fi;
-	@ln -fsn asm-$(SRCARCH) $@
+# The asm symlink changes when $(ARCH) changes.
+# Detect this and ask user to run make mrproper
+
+include/asm: FORCE
+	$(Q)set -e; asmlink=`readlink include/asm | cut -d '-' -f 2`;   \
+	if [ -L include/asm ]; then                                     \
+		if [ "$$asmlink" != "$(SRCARCH)" ]; then                \
+			echo "ERROR: the symlink $@ points to asm-$$asmlink but asm-$(SRCARCH) was expected"; \
+			echo "       save .config and run 'make mrproper' to fix it";                         \
+			exit 1;                                         \
+		fi;                                                     \
+	else                                                            \
+		echo '  SYMLINK $@ -> include/asm-$(SRCARCH)';          \
+		if [ ! -d include ]; then                               \
+			mkdir -p include;                               \
+		fi;                                                     \
+		ln -fsn asm-$(SRCARCH) $@;                              \
+	fi
 
 # Generate some files
 # ---------------------------------------------------------------------------
