Return-Path: <linux-kernel-owner+w=401wt.eu-S1758171AbYE2R1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbYE2R1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 13:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbYE2R1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 13:27:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbYE2R1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 13:27:23 -0400
From: =?utf-8?q?Kristian=20H=C3=B8gsberg?= <krh@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?q?Kristian=20H=C3=B8gsberg?= <krh@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/2] Honor 'quiet' command line option in real mode boot decompressor.
Date: Thu, 29 May 2008 13:27:12 -0400
Message-Id: <1212082032-6167-2-git-send-email-krh@redhat.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1212082032-6167-1-git-send-email-krh@redhat.com>
References: <1212082032-6167-1-git-send-email-krh@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch lets the early real mode decompressor parse the kernel
command line and look for the 'quiet' option.  When 'quiet' is passed
we suppress the "Decompressing Linux... Parsing ELF... done." messages.

This is in line with how the rest of the kernel suppresses informational
debug spew when quiet is given.

Signed-off-by: Kristian Høgsberg <krh@redhat.com>

---

Ok, I flipped the default on this patch since turning off those
important messages by default is apparently quite controversial.
With this patch we still print the decompression status messages, but
if quiet is seen on the kernel command we suppress them.

 arch/x86/boot/compressed/misc.c |   31 ++++++++++++++++++++++++++++---
 1 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 102b68e..b548379 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -190,6 +190,7 @@ static void gzip_release(void **);
  */
 static struct boot_params *real_mode;		/* Pointer to real-mode data */
 #define RM_SCREEN_INFO (real_mode->screen_info)
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
@@ -419,11 +421,28 @@ static void parse_elf(void *output)
 	}
 }
 
+static const char *strnstr(const char *string, int len, const char *s)
+{
+	int i, j;
+
+	for (i = 0; i < len; i++) {
+		for (j = 0; i + j < len && s[j]; j++)
+			if (string[i + j] != s[j])
+				break;
+		if (s[j] == '\0')
+			return string + i;
+	}
+
+	return NULL;
+}
+
 asmlinkage void decompress_kernel(void *rmode, memptr heap,
 				  unsigned char *input_data,
 				  unsigned long input_len,
 				  unsigned char *output)
 {
+	const char * cmdline;  
+
 	real_mode = rmode;
 
 	if (RM_SCREEN_INFO.orig_video_mode == 7) {
@@ -437,6 +456,10 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 	lines = RM_SCREEN_INFO.orig_video_lines;
 	cols = RM_SCREEN_INFO.orig_video_cols;
 
+	cmdline = (char *) real_mode->hdr.cmd_line_ptr;
+	if (strnstr(cmdline, real_mode->hdr.cmdline_size, "quiet"))
+		quiet = 1;
+
 	window = output;		/* Output buffer (Normally at 1M) */
 	free_mem_ptr     = heap;	/* Heap */
 	free_mem_end_ptr = heap + BOOT_HEAP_SIZE;
@@ -461,9 +484,11 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
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
-- 
1.5.4.5

