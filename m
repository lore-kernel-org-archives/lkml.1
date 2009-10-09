Return-Path: <linux-kernel-owner+w=401wt.eu-S934589AbZJIX0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934589AbZJIX0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934521AbZJIX0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:26:49 -0400
Received: from kroah.org ([198.145.64.141]:56321 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934517AbZJIX0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:26:48 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:22:34 2009
Message-Id: <20091009232234.069019937@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:21:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michal Hocko <mhocko@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
       "H. Peter Anvin" <hpa@zytor.com>, Chuck Ebbert <cebbert@redhat.com>
Subject: [5/8] x86: Increase MIN_GAP to include randomized stack
From: gregkh@mini.kroah.org
References: <20091009232123.464253035@mini.kroah.org>
Content-Disposition: inline; filename=x86-increase-min_gap-to-include-randomized-stack.patch
In-Reply-To: <20091009232300.GA403@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Hocko <mhocko@suse.cz>

[ trivial backport to 2.6.27: Chuck Ebbert <cebbert@redhat.com> ]

commit 80938332d8cf652f6b16e0788cf0ca136befe0b5 upstream.

Currently we are not including randomized stack size when calculating
mmap_base address in arch_pick_mmap_layout for topdown case. This might
cause that mmap_base starts in the stack reserved area because stack is
randomized by 1GB for 64b (8MB for 32b) and the minimum gap is 128MB.

If the stack really grows down to mmap_base then we can get silent mmap
region overwrite by the stack values.

Let's include maximum stack randomization size into MIN_GAP which is
used as the low bound for the gap in mmap.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
LKML-Reference: <1252400515-6866-1-git-send-email-mhocko@suse.cz>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 arch/x86/mm/mmap.c    |   17 +++++++++++++++--
 include/asm-x86/elf.h |    2 ++
 2 files changed, 17 insertions(+), 2 deletions(-)

--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -29,13 +29,26 @@
 #include <linux/random.h>
 #include <linux/limits.h>
 #include <linux/sched.h>
+#include <asm/elf.h>
+
+static unsigned int stack_maxrandom_size(void)
+{
+	unsigned int max = 0;
+	if ((current->flags & PF_RANDOMIZE) &&
+		!(current->personality & ADDR_NO_RANDOMIZE)) {
+		max = ((-1U) & STACK_RND_MASK) << PAGE_SHIFT;
+	}
+
+	return max;
+}
+
 
 /*
  * Top of mmap area (just below the process stack).
  *
- * Leave an at least ~128 MB hole.
+ * Leave an at least ~128 MB hole with possible stack randomization.
  */
-#define MIN_GAP (128*1024*1024)
+#define MIN_GAP (128*1024*1024UL + stack_maxrandom_size())
 #define MAX_GAP (TASK_SIZE/6*5)
 
 /*
--- a/include/asm-x86/elf.h
+++ b/include/asm-x86/elf.h
@@ -287,6 +287,8 @@ do {									\
 
 #ifdef CONFIG_X86_32
 
+#define STACK_RND_MASK (0x7ff)
+
 #define VDSO_HIGH_BASE		(__fix_to_virt(FIX_VDSO))
 
 #define ARCH_DLINFO		ARCH_DLINFO_IA32(vdso_enabled)


