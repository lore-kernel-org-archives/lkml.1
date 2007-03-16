Return-Path: <linux-kernel-owner+w=401wt.eu-S965805AbXCPR5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965805AbXCPR5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 13:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965810AbXCPR5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 13:57:25 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:58036 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965805AbXCPR5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 13:57:24 -0400
Subject: [PATCH] fix process crash caused by randomisation and 64k pages
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain
Date: Fri, 16 Mar 2007 12:57:18 -0500
Message-Id: <1174067838.3519.26.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This bug was seen on ppc64, but it could have occurred on any
architecture with a page size of 64k or above.  The problem is that
fs/binfmt_elf.c:randomize_stack_top() randomizes the stack to within
0x7ff pages.  On 4k page machines, this is 8MB; on 64k page boxes, this
is 128MB.  The problem is that the new binary layout (selected in
arch_pick_mmap_layout) places the mapping segment 128MB or the stack
rlimit away from the top of the process memory, whichever is larger.  If
you chose an rlimit of less than 128MB (most defaults are in the 8Mb
range) then you can end up having your entire stack randomized away.

The fix is to make randomize_stack_top() only steal at most 8MB, which
this patch does.  However, I have to point out that even with this, your
stack rlimit might not be exactly what you get if it's > 128MB, because
you're still losing the random offset of up to 8MB.

The true fix should be to leave an explicit gap for the randomization
plus a buffer when determining mmap_base, but that would involve fixing
all the architectures.

James

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 51db118..187f151 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -507,7 +507,7 @@ out:
 #define INTERPRETER_ELF 2
 
 #ifndef STACK_RND_MASK
-#define STACK_RND_MASK 0x7ff		/* with 4K pages 8MB of VA */
+#define STACK_RND_MASK 0x7ff0000	/* 8MB of VA */
 #endif
 
 static unsigned long randomize_stack_top(unsigned long stack_top)
@@ -515,14 +515,12 @@ static unsigned long randomize_stack_top(unsigned long stack_top)
 	unsigned int random_variable = 0;
 
 	if ((current->flags & PF_RANDOMIZE) &&
-		!(current->personality & ADDR_NO_RANDOMIZE)) {
+		!(current->personality & ADDR_NO_RANDOMIZE))
 		random_variable = get_random_int() & STACK_RND_MASK;
-		random_variable <<= PAGE_SHIFT;
-	}
 #ifdef CONFIG_STACK_GROWSUP
-	return PAGE_ALIGN(stack_top) + random_variable;
+	return PAGE_ALIGN(stack_top + random_variable);
 #else
-	return PAGE_ALIGN(stack_top) - random_variable;
+	return PAGE_ALIGN(stack_top - random_variable);
 #endif
 }
 


