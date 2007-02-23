Return-Path: <linux-kernel-owner+w=401wt.eu-S1750819AbXBWDnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750819AbXBWDnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 22:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbXBWDnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 22:43:33 -0500
Received: from [204.127.200.81] ([204.127.200.81]:54906 "EHLO
	sccrmhc11.comcast.net" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbXBWDnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 22:43:32 -0500
Date: Thu, 22 Feb 2007 19:43:43 -0800
From: Deepak Saxena <dsaxena@plexity.net>
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Allow kernel to build on Cygwin
Message-ID: <20070223034343.GA3320@plexity.net>
Reply-To: dsaxena@plexity.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Plexity Networks
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch contains a set of small fixes to allow the kernel to build under
the Cygwin environment, which is unfortunately used by more people than
one would think in the embedded world. :(

Signed-off-by: Deepak Saxena <dsaxena@mvista.com>

---
 lib/gen_crc32table.c                       |    2 ++
 scripts/kconfig/Makefile                   |    6 ++++++
 scripts/kconfig/lxdialog/check-lxdialog.sh |    4 ++++
 scripts/mod/file2alias.c                   |    4 ++++
 scripts/mod/mk_elfconfig.c                 |    4 ++++
 scripts/mod/modpost.h                      |    4 ++++
 scripts/mod/sumversion.c                   |    6 +++++-
 7 files changed, 29 insertions(+), 1 deletion(-)


diff --git a/lib/gen_crc32table.c b/lib/gen_crc32table.c
index bea5d97..ce447ff 100644
--- a/lib/gen_crc32table.c
+++ b/lib/gen_crc32table.c
@@ -1,6 +1,8 @@
 #include <stdio.h>
 #include "crc32defs.h"
+#ifndef __CYGWIN__
 #include <inttypes.h>
+#endif
 
 #define ENTRIES_PER_LINE 4
 
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 7e7e147..ca57efe 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -161,6 +161,12 @@ HOSTLOADLIBES_gconf	= `pkg-config --libs
 HOSTCFLAGS_gconf.o	= `pkg-config --cflags gtk+-2.0 gmodule-2.0 libglade-2.0` \
                           -D LKC_DIRECT_LINK
 
+HOST_OS := $(shell uname -o)
+ifeq ($(HOST_OS),Cygwin)
+HOSTLOADLIBES_mconf	= -lintl
+HOSTLOADLIBES_conf	= -lintl
+endif
+
 $(obj)/qconf.o: $(obj)/.tmp_qtcheck
 
 ifeq ($(qconf-target),1)
diff --git a/scripts/kconfig/lxdialog/check-lxdialog.sh b/scripts/kconfig/lxdialog/check-lxdialog.sh
index 120d624..c44b559 100644
--- a/scripts/kconfig/lxdialog/check-lxdialog.sh
+++ b/scripts/kconfig/lxdialog/check-lxdialog.sh
@@ -4,6 +4,10 @@ # Check ncurses compatibility
 # What library to link
 ldflags()
 {
+	if [ "`uname -o`" == "Cygwin" ]; then
+		echo '-lintl -lncurses'
+		exit
+	fi
 	$cc -print-file-name=libncursesw.so | grep -q /
 	if [ $? -eq 0 ]; then
 		echo '-lncursesw'
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index f61c9cc..479293f 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -29,7 +29,11 @@ #endif
 
 #include <ctype.h>
 
+#if defined(__CYGWIN__)
+typedef __uint32_t	__u32;
+#else
 typedef uint32_t	__u32;
+#endif
 typedef uint16_t	__u16;
 typedef unsigned char	__u8;
 
diff --git a/scripts/mod/mk_elfconfig.c b/scripts/mod/mk_elfconfig.c
index 725d61c..4908f7a 100644
--- a/scripts/mod/mk_elfconfig.c
+++ b/scripts/mod/mk_elfconfig.c
@@ -1,7 +1,11 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#ifdef __CYGWIN__
+#include <libelf.h>
+#else
 #include <elf.h>
+#endif
 
 int
 main(int argc, char **argv)
diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
index d398c61..7cdf2c6 100644
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
@@ -7,7 +7,11 @@ #include <sys/stat.h>
 #include <sys/mman.h>
 #include <fcntl.h>
 #include <unistd.h>
+#ifdef __CYGWIN__
+#include <libelf.h>
+#else
 #include <elf.h>
+#endif
 
 #include "elfconfig.h"
 
diff --git a/scripts/mod/sumversion.c b/scripts/mod/sumversion.c
index 8a28756..4404f87 100644
--- a/scripts/mod/sumversion.c
+++ b/scripts/mod/sumversion.c
@@ -1,7 +1,11 @@
+#if defined(__sun__)
 #include <netinet/in.h>
-#ifdef __sun__
 #include <inttypes.h>
+#elif defined(__CYGWIN__)
+#include <asm/byteorder.h>	/* For ntohl/htonl */
+#include <limits.h>
 #else
+#include <netinet/in.h>
 #include <stdint.h>
 #endif
 #include <ctype.h>

-- 
Deepak Saxena - dsaxena@plexity.net - http://www.plexity.net

In the end, they will not say, "those were dark times,"  they will ask
"why were their poets silent?" - Bertolt Brecht
