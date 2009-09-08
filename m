Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbZIHJB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbZIHJB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 05:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbZIHJB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 05:01:56 -0400
Received: from nat.scz.novell.com ([213.151.88.252]:59258 "EHLO dhcp35"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753887AbZIHJBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 05:01:55 -0400
From: Michal Hocko <mhocko@suse.cz>
To: Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Jiri Kosina <jkosina@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v4] x86: increase MIN_GAP to include randomized stack
Date: Tue,  8 Sep 2009 11:01:55 +0200
Message-Id: <1252400515-6866-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090908085328.GD22397@tiehlicka.suse.cz>
References: <20090908085328.GD22397@tiehlicka.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we are not including randomized stack size when calculating
mmap_base address in arch_pick_mmap_layout for topdown case. This might
cause that mmap_base starts in the stack reserved area because stack is
randomized by 1GB for 64b (8MB for 32b) and the minimum gap is 128MB.

If the stack really grows down to mmap_base then we can get silent mmap
region overwrite by the stack values.

Let's include maximum stack randomization size into MIN_GAP which is
used as the low bound for the gap in mmap.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 arch/x86/include/asm/elf.h |    2 ++
 arch/x86/mm/mmap.c         |   17 +++++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

Maybe we should split the patch into 2 parts, one for STACK_RND_MASK
definition cleanup for X86_32 and the other one for the MIN_GAP issue.
What do you think?

Changes from v3:
Remove STACK_RND_MASK from mmap.c completely and rather include asm/elf.h
instead. Also define STACK_RND_MASK for CONFIG_X86_32 case.

Changes from v2:
STACK_RND_MASK has to be defined for CONFIG_X86_32 as well.

Changes from v1:
Fixed unsigned int overflow in MIN_GAP calculation.

diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 83c1bc8..456a304 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -299,6 +299,8 @@ do {									\
 
 #ifdef CONFIG_X86_32
 
+#define STACK_RND_MASK (0x7ff)
+
 #define VDSO_HIGH_BASE		(__fix_to_virt(FIX_VDSO))
 
 #define ARCH_DLINFO		ARCH_DLINFO_IA32(vdso_enabled)
diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index 1658296..c8191de 100644
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
-- 
1.6.3.3

