Return-Path: <linux-kernel-owner+w=401wt.eu-S1754426AbYFRSEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbYFRSEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 14:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbYFRSEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 14:04:39 -0400
Received: from adelie.canonical.com ([91.189.90.139]:43740 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbYFRSEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 14:04:39 -0400
Subject: [PATCH] Config option to disable info from decompression of the
	kernel
From: Ben Collins <ben.collins@canonical.com>
To: kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Canonical
Date: Wed, 18 Jun 2008 14:04:35 -0400
Message-Id: <1213812275.6575.25.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I submitted a similar patch some time ago, but rightfully it didn't get
accepted, as it just disabled all output from the decompress stage
(without a boot time option to enable it).

This patch just disables the information output from this stage, but not
the error output.

Signed-off-by: Ben Collins <ben.collins@canonical.com>

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 1836337..94c818f 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -20,6 +20,14 @@ config NONPROMISC_DEVMEM
 
 	  If in doubt, say Y.
 
+config NO_BZ_CHATTER
+	bool "Disable decompress info messages"
+	default n
+	help
+	  Disables just the informational output from the decompression stage
+	  (e.g. bzImage) of the boot. You will still see errors. Do this if you
+	  want to cleanup the bootup process.
+
 config EARLY_PRINTK
 	bool "Early printk" if EMBEDDED
 	default y
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 90456ce..67cf205 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -206,7 +206,8 @@ static void free(void *where);
 static void *memset(void *s, int c, unsigned n);
 static void *memcpy(void *dest, const void *src, unsigned n);
 
-static void putstr(const char *);
+static void __putstr(int, const char *);
+#define putstr(__x)  __putstr(0, __x)
 
 #ifdef CONFIG_X86_64
 #define memptr long
@@ -270,11 +271,16 @@ static void scroll(void)
 		vidmem[i] = ' ';
 }
 
-static void putstr(const char *s)
+static void __putstr(int error, const char *s)
 {
 	int x, y, pos;
 	char c;
 
+#ifdef CONFIG_NO_BZ_CHATTER
+	if (!error)
+		return;
+#endif
+
 #ifdef CONFIG_X86_32
 	if (RM_SCREEN_INFO.orig_video_mode == 0 && lines == 0 && cols == 0)
 		return;
@@ -366,9 +372,9 @@ static void flush_window(void)
 
 static void error(char *x)
 {
-	putstr("\n\n");
-	putstr(x);
-	putstr("\n\n -- System halted");
+	__putstr(1, "\n\n");
+	__putstr(1, x);
+	__putstr(1, "\n\n -- System halted");
 
 	while (1)
 		asm("hlt");


