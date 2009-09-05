Return-Path: <linux-kernel-owner+w=401wt.eu-S964989AbZIEAac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964989AbZIEAac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964921AbZIEAa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:30:27 -0400
Received: from mx1-old.redhat.com ([66.187.233.31]:40810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934626AbZIEAaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:30:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] kconfig CROSS_COMPILE option
Emacs: because one operating system isn't enough.
Message-Id: <20090905002947.A4C678BEB1@magilla.sf.frob.com>
Date: Fri,  4 Sep 2009 17:29:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds CROSS_COMPILE as a kconfig string so you can store it in .config.
Then you can use plain "make" in the configured kernel build directory to
do the right cross compilation without setting the command-line or
environment variable every time.

With this, you can set up different build directories for different kernel
configurations, whether native or cross-builds, and then use the simple:
	make -C /build/dir M=module-source-dir
idiom to build modules for any given target kernel, indicating which one
by nothing but the build directory chosen.

I tried a version that defaults the string with env="CROSS_COMPILE" so that
in a "make oldconfig" with CROSS_COMPILE in the environment you can just
hit return to store the way you're building it.  But the kconfig prompt for
strings doesn't give you any way to say you want an empty string instead of
the default, so I punted that.

Signed-off-by: Roland McGrath <roland@redhat.com>
CC: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile     |    4 +++-
 init/Kconfig |    8 ++++++++
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 25c615e..8f02b6e 100644
--- a/Makefile
+++ b/Makefile
@@ -177,11 +177,13 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
 # CROSS_COMPILE can be set on the command line
 # make CROSS_COMPILE=ia64-linux-
 # Alternatively CROSS_COMPILE can be set in the environment.
+# A third alternative is to store a setting in .config so that plain
+# "make" in the configured kernel build directory always uses that.
 # Default value for CROSS_COMPILE is not to prefix executables
 # Note: Some architectures assign CROSS_COMPILE in their arch/*/Makefile
 export KBUILD_BUILDHOST := $(SUBARCH)
 ARCH		?= $(SUBARCH)
-CROSS_COMPILE	?=
+CROSS_COMPILE	?= $(CONFIG_CROSS_COMPILE:"%"=%)
 
 # Architecture as present in compile.h
 UTS_MACHINE 	:= $(ARCH)
diff --git a/init/Kconfig b/init/Kconfig
index 3f7e609..452080d 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -76,6 +76,14 @@ config INIT_ENV_ARG_LIMIT
 	  variables passed to init from the kernel command line.
 
 
+config CROSS_COMPILE
+	string "Cross-compiler tool prefix"
+	help
+	  Same as running 'make CROSS_COMPILE=prefix-' but stored for
+	  default make runs in this kernel build directory.  You don't
+	  need to set this unless you want the configured kernel build
+	  directory to select the cross-compiler automatically.
+
 config LOCALVERSION
 	string "Local version - append to kernel release"
 	help
