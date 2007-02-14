Return-Path: <linux-kernel-owner+w=401wt.eu-S1750772AbXBNG0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750772AbXBNG0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 01:26:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbXBNG0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 01:26:11 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:45652 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbXBNG0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 01:26:11 -0500
Date: Tue, 13 Feb 2007 22:06:19 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: olecom@flower.upol.cz, sam@ravnborg.org, zippel@linux-m68k.org
Subject: kbuild feature/question: default ARCH
Message-Id: <20070213220619.ce964f58.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'd like for kbuild to default ARCH to the already-symlinked
arch in include/asm-$(ARCH) if ARCH is not specified on the
command line or in the environment.  I have a non-working patch,
complete with a circular dependency which is dropped:

make: Circular ' <- ' dependency dropped.

Any suggestions for how to complete this?

Thanks.
---

From: Randy Dunlap <randy.dunlap@oracle.com>

If ARCH is unspecified (command line or environment) and if
include/asm is already a symlink to include/asm-$ARCH,
use that ARCH as the default instead of the host ARCH.
Undo the effect of this by using 'make mrproper' or just 'rm include/asm'.

This allows us to drop 'ARCH=fobr' for subsequent builds of the same
ARCH, after using it in a build one time (not counting make *config).

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Makefile |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- linux-2.6.20-git9.orig/Makefile
+++ linux-2.6.20-git9/Makefile
@@ -172,6 +172,10 @@ SUBARCH := $(shell uname -m | sed -e s/i
 # make ARCH=ia64
 # Another way is to have ARCH set in the environment.
 # The default ARCH is the host where make is executed.
+#
+# However, if include/asm is already a symlink to include/asm-$ARCH,
+# use that ARCH as the default instead of the host ARCH.
+# Undo the effect of this by using 'make mrproper' or just 'rm include/asm'.
 
 # CROSS_COMPILE specify the prefix used for all executables used
 # during compilation. Only gcc and related bin-utils executables
@@ -182,6 +186,20 @@ SUBARCH := $(shell uname -m | sed -e s/i
 # Default value for CROSS_COMPILE is not to prefix executables
 # Note: Some architectures assign CROSS_COMPILE in their arch/*/Makefile
 
+# if ARCH is unspecified & symlink include/asm exists, set ARCH to
+# its symlink arch
+@echo '  CHK DEF ARCH -> include/asm:'
+$(Q)if [ "$(ARCH)" == "" -a -h $(srctree)/include/asm ]; then \
+	symlink=`readlink include/asm` \
+	len=`expr length $symlink` \
+	if [ len -le 4 ]; then \
+		@echo '    no symlink for include/asm' \
+	else \
+		ARCH=${symlink:4} \
+		@echo '    ARCH symlink to ${ARCH}' \
+	fi \
+fi
+
 ARCH		?= $(SUBARCH)
 CROSS_COMPILE	?=
 
