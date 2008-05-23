Return-Path: <linux-kernel-owner+w=401wt.eu-S1760147AbYEWWAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147AbYEWWAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 18:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758610AbYEWWA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 18:00:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758387AbYEWWA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 18:00:26 -0400
From: =?utf-8?q?Kristian=20H=C3=B8gsberg?= <krh@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?q?Kristian=20H=C3=B8gsberg?= <krh@redhat.com>
Subject: [PATCH 2/2] Only print "Decompressing Linux" etc when 'noisy' is passed.
Date: Fri, 23 May 2008 17:59:28 -0400
Message-Id: <1211579968-15227-2-git-send-email-krh@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1211579968-15227-1-git-send-email-krh@redhat.com>
References: <1211579968-15227-1-git-send-email-krh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kristian Høgsberg <krh@redhat.com>
---
 arch/x86/boot/compressed/misc.c |   30 +++++++++++++++++++++++++++---
 1 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 0d03579..b7b5c1f 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -190,6 +190,7 @@ static void gzip_release(void **);
  */
 static struct boot_params *real_mode;		/* Pointer to real-mode data */
 static struct screen_info *rm_screen_info;	/* Pointer to real-mode data */
+static int noisy;
 
 extern unsigned char input_data[];
 extern int input_len;
@@ -391,7 +392,8 @@ static void parse_elf(void *output)
 		return;
 	}
 
-	putstr("Parsing ELF... ");
+	if (noisy)
+		putstr("Parsing ELF... ");
 
 	phdrs = malloc(sizeof(*phdrs) * ehdr.e_phnum);
 	if (!phdrs)
@@ -419,11 +421,27 @@ static void parse_elf(void *output)
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
 asmlinkage void decompress_kernel(void *rmode, memptr heap,
 				  unsigned char *input_data,
 				  unsigned long input_len,
 				  unsigned char *output)
 {
+	char *cmdline;
+
 	real_mode = rmode;
 
 	if (rm_screen_info->orig_video_mode == 7) {
@@ -437,6 +455,10 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 	lines = rm_screen_info->orig_video_lines;
 	cols = rm_screen_info->orig_video_cols;
 
+	cmdline = (char *) real_mode->hdr.cmd_line_ptr;
+	if (strnstr(cmdline, real_mode->hdr.cmdline_size, "noisy"))
+		noisy = 1;
+
 	window = output;		/* Output buffer (Normally at 1M) */
 	free_mem_ptr     = heap;	/* Heap */
 	free_mem_end_ptr = heap + BOOT_HEAP_SIZE;
@@ -461,9 +483,11 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 #endif
 
 	makecrc();
-	putstr("\nDecompressing Linux... ");
+	if (noisy)
+		putstr("\nDecompressing Linux... ");
 	gunzip();
 	parse_elf(output);
-	putstr("done.\nBooting the kernel.\n");
+	if (noisy)
+		putstr("done.\nBooting the kernel.\n");
 	return;
 }
-- 
1.5.5.1

