Return-Path: <linux-kernel-owner+w=401wt.eu-S1756449AbYE2Wbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbYE2Wbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 18:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756167AbYE2WbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 18:31:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756072AbYE2WbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 18:31:21 -0400
From: =?utf-8?q?Kristian=20H=C3=B8gsberg?= <krh@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?q?Kristian=20H=C3=B8gsberg?= <krh@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/2 v4] Honor 'quiet' command line option in real mode boot decompressor.
Date: Thu, 29 May 2008 18:31:15 -0400
Message-Id: <1212100275-5512-2-git-send-email-krh@redhat.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1212100275-5512-1-git-send-email-krh@redhat.com>
References: <1212100275-5512-1-git-send-email-krh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch lets the early real mode code look for the 'quiet' option
on the kernel command line and pass a loadflag to the decompressor.
When this flag is set, we suppress the "Decompressing Linux... Parsing
ELF... done." messages.

Signed-off-by: Kristian Høgsberg <krh@redhat.com>
---

Changed to use the bootflags approach suggested by hpa.  Less code and
yet it does a better job of parsing the command line (doesn't get
confused by eg fooquiet etc).

 arch/x86/boot/compressed/misc.c |   13 ++++++++++---
 arch/x86/boot/main.c            |    4 ++++
 include/asm-x86/bootparam.h     |    1 +
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 74ed3c0..d10e727 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -189,6 +189,7 @@ static void gzip_release(void **);
  * This is set up by the setup-routine at boot-time
  */
 static struct boot_params *real_mode;		/* Pointer to real-mode data */
+static int quiet;
 
 extern unsigned char input_data[];
 extern int input_len;
@@ -391,7 +392,8 @@ static void parse_elf(void *output)
 		return;
 	}
 
-	putstr("Parsing ELF... ");
+	if (!quiet)
+		putstr("Parsing ELF... ");
 
 	phdrs = malloc(sizeof(*phdrs) * ehdr.e_phnum);
 	if (!phdrs)
@@ -426,6 +428,9 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 {
 	real_mode = rmode;
 
+	if (real_mode->hdr.loadflags & QUIET_FLAG)
+		quiet = 1;
+
 	if (real_mode->screen_info.orig_video_mode == 7) {
 		vidmem = (char *) 0xb0000;
 		vidport = 0x3b4;
@@ -461,9 +466,11 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 #endif
 
 	makecrc();
-	putstr("\nDecompressing Linux... ");
+	if (!quiet)
+		putstr("\nDecompressing Linux... ");
 	gunzip();
 	parse_elf(output);
-	putstr("done.\nBooting the kernel.\n");
+	if (!quiet)
+		putstr("done.\nBooting the kernel.\n");
 	return;
 }
diff --git a/arch/x86/boot/main.c b/arch/x86/boot/main.c
index 77569a4..2296164 100644
--- a/arch/x86/boot/main.c
+++ b/arch/x86/boot/main.c
@@ -165,6 +165,10 @@ void main(void)
 	/* Set the video mode */
 	set_video();
 
+	/* Parse command line for 'quiet' and pass it to decompressor. */
+	if (cmdline_find_option_bool("quiet"))
+		boot_params.hdr.loadflags |= QUIET_FLAG;
+
 	/* Do the last things and invoke protected mode */
 	go_to_protected_mode();
 }
diff --git a/include/asm-x86/bootparam.h b/include/asm-x86/bootparam.h
index f62f473..3e36ba8 100644
--- a/include/asm-x86/bootparam.h
+++ b/include/asm-x86/bootparam.h
@@ -40,6 +40,7 @@ struct setup_header {
 	__u8	type_of_loader;
 	__u8	loadflags;
 #define LOADED_HIGH	(1<<0)
+#define QUIET_FLAG	(1<<5)
 #define KEEP_SEGMENTS	(1<<6)
 #define CAN_USE_HEAP	(1<<7)
 	__u16	setup_move_size;
-- 
1.5.4.5

