Return-Path: <linux-kernel-owner+w=401wt.eu-S1759942AbYEWWAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759942AbYEWWAf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 18:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758555AbYEWWA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 18:00:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757712AbYEWWA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 18:00:26 -0400
From: =?utf-8?q?Kristian=20H=C3=B8gsberg?= <krh@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?q?Kristian=20H=C3=B8gsberg?= <krh@redhat.com>
Subject: [PATCH 1/2] Use structs instead of hardcoded offsets in x86 boot decompressor.
Date: Fri, 23 May 2008 17:59:27 -0400
Message-Id: <1211579968-15227-1-git-send-email-krh@redhat.com>
X-Mailer: git-send-email 1.5.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kristian Høgsberg <krh@redhat.com>
---
 arch/x86/boot/compressed/misc.c |   26 +++++++++++---------------
 1 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 90456ce..0d03579 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -30,6 +30,7 @@
 #include <asm/io.h>
 #include <asm/page.h>
 #include <asm/boot.h>
+#include <asm/bootparam.h>
 
 /* WARNING!!
  * This code is compiled with -fPIC and it is relocated dynamically
@@ -187,13 +188,8 @@ static void gzip_release(void **);
 /*
  * This is set up by the setup-routine at boot-time
  */
-static unsigned char *real_mode; /* Pointer to real-mode data */
-
-#define RM_EXT_MEM_K   (*(unsigned short *)(real_mode + 0x2))
-#ifndef STANDARD_MEMORY_BIOS_CALL
-#define RM_ALT_MEM_K   (*(unsigned long *)(real_mode + 0x1e0))
-#endif
-#define RM_SCREEN_INFO (*(struct screen_info *)(real_mode+0))
+static struct boot_params *real_mode;		/* Pointer to real-mode data */
+static struct screen_info *rm_screen_info;	/* Pointer to real-mode data */
 
 extern unsigned char input_data[];
 extern int input_len;
@@ -276,12 +272,12 @@ static void putstr(const char *s)
 	char c;
 
 #ifdef CONFIG_X86_32
-	if (RM_SCREEN_INFO.orig_video_mode == 0 && lines == 0 && cols == 0)
+	if (rm_screen_info->orig_video_mode == 0 && lines == 0 && cols == 0)
 		return;
 #endif
 
-	x = RM_SCREEN_INFO.orig_x;
-	y = RM_SCREEN_INFO.orig_y;
+	x = rm_screen_info->orig_x;
+	y = rm_screen_info->orig_y;
 
 	while ((c = *s++) != '\0') {
 		if (c == '\n') {
@@ -302,8 +298,8 @@ static void putstr(const char *s)
 		}
 	}
 
-	RM_SCREEN_INFO.orig_x = x;
-	RM_SCREEN_INFO.orig_y = y;
+	rm_screen_info->orig_x = x;
+	rm_screen_info->orig_y = y;
 
 	pos = (x + cols * y) * 2;	/* Update cursor position */
 	outb(14, vidport);
@@ -430,7 +426,7 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 {
 	real_mode = rmode;
 
-	if (RM_SCREEN_INFO.orig_video_mode == 7) {
+	if (rm_screen_info->orig_video_mode == 7) {
 		vidmem = (char *) 0xb0000;
 		vidport = 0x3b4;
 	} else {
@@ -438,8 +434,8 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 		vidport = 0x3d4;
 	}
 
-	lines = RM_SCREEN_INFO.orig_video_lines;
-	cols = RM_SCREEN_INFO.orig_video_cols;
+	lines = rm_screen_info->orig_video_lines;
+	cols = rm_screen_info->orig_video_cols;
 
 	window = output;		/* Output buffer (Normally at 1M) */
 	free_mem_ptr     = heap;	/* Heap */
-- 
1.5.5.1

