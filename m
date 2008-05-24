Return-Path: <linux-kernel-owner+w=401wt.eu-S1761279AbYEXT2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761279AbYEXT2d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 15:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbYEXT20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 15:28:26 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:56178 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbYEXT2Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 15:28:25 -0400
Date: Sat, 24 May 2008 21:28:21 +0200
Message-Id: <290568367@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: krh@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: =?iso-8859-15?Q?Re:_[PATCH_2/2]_Only_print_"Decompressing_Linux"_etc_w?=
 =?iso-8859-15?Q?hen_'noisy'_is_passed.?=
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+ASQeMm8tL/dzMPSigrAmePTRimk5JeSVo4+YZ2Ldue5b0o
 gQxZCGzrAwOJOx/1VxpSxT6BYLor3s2tGoXk/w7eYM3uxNg7Os=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

what about using "quiet" here instead ?

quiet is already the parameter to suppress boot messages, so introducing another one doesn`t make sense, imho.

the early boot commandline parser was extended some time ago to support boolean options, see:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=32d0b9898029b7b3c7f161d31f57c4831d9049eb

this may shrink your patch , see example in arch/x86/boot/edd.c 


be_quiet = cmdline_find_option_bool("quiet");
....
if (!be_quiet)
    printf("Probing EDD (edd=off to disable)... ");


roland



List:       linux-kernel
Subject:    [PATCH 2/2] Only print "Decompressing Linux" etc when 'noisy' is passed.
From:       Kristian HÃ&#382;gsberg <krh () redhat ! com>
Date:       2008-05-23 21:59:28
Message-ID: 1211579968-15227-2-git-send-email-krh () redhat ! com
[Download message RAW]

Signed-off-by: Kristian HÃ&#382;gsberg <krh@redhat.com>
---
 arch/x86/boot/compressed/misc.c |   30 +++++++++++++++++++++++++++---
 1 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 0d03579..b7b5c1f 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -190,6 +190,7 @@ static void gzip_release(void **);
  */
 static struct boot_params *real_mode;          /* Pointer to real-mode data */
 static struct screen_info *rm_screen_info;     /* Pointer to real-mode data */
+static int noisy;
 
 extern unsigned char input_data[];
 extern int input_len;
@@ -391,7 +392,8 @@ static void parse_elf(void *output)
                return;
        }
 
-       putstr("Parsing ELF... ");
+       if (noisy)
+               putstr("Parsing ELF... ");
 
        phdrs = malloc(sizeof(*phdrs) * ehdr.e_phnum);
        if (!phdrs)
@@ -419,11 +421,27 @@ static void parse_elf(void *output)
        }
 }
 
+static const char *strnstr(const char *string, int len, const char *s)
+{
+       int i, j;
+
+       for (i = 0; i < len; i++) {
+               for (j = 0; i + j < len && s[j]; j++)
+                       if (string[i + j] != s[j])
+                               break;
+               if (s[j] == '\0')
+                       return string + i;
+       }
+
+       return NULL;
+}
 asmlinkage void decompress_kernel(void *rmode, memptr heap,
                                  unsigned char *input_data,
                                  unsigned long input_len,
                                  unsigned char *output)
 {
+       char *cmdline;
+
        real_mode = rmode;
 
        if (rm_screen_info->orig_video_mode == 7) {
@@ -437,6 +455,10 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
        lines = rm_screen_info->orig_video_lines;
        cols = rm_screen_info->orig_video_cols;
 
+       cmdline = (char *) real_mode->hdr.cmd_line_ptr;
+       if (strnstr(cmdline, real_mode->hdr.cmdline_size, "noisy"))
+               noisy = 1;
+
        window = output;                /* Output buffer (Normally at 1M) */
        free_mem_ptr     = heap;        /* Heap */
        free_mem_end_ptr = heap + BOOT_HEAP_SIZE;
@@ -461,9 +483,11 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 #endif
 
        makecrc();
-       putstr("\nDecompressing Linux... ");
+       if (noisy)
+               putstr("\nDecompressing Linux... ");
        gunzip();
        parse_elf(output);
-       putstr("done.\nBooting the kernel.\n");
+       if (noisy)
+               putstr("done.\nBooting the kernel.\n");
        return;
 }
-- 
1.5.5.1
_______________________________________________________________________
EINE FÜR ALLE: die kostenlose WEB.DE-Plattform für Freunde und Deine
Homepage mit eigenem Namen. Jetzt starten! http://unddu.de/?kid=kid@mf2

