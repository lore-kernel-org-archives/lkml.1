Return-Path: <linux-kernel-owner+w=401wt.eu-S1752165AbZIKAGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbZIKAGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 20:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbZIKAGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 20:06:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:55012 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbZIKAGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 20:06:22 -0400
Date: Fri, 11 Sep 2009 00:06:03 GMT
From: tip-bot for Michal Hocko <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       stable@kernel.org, jkosina@suse.cz, tglx@linutronix.de, mhocko@suse.cz
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stable@kernel.org, tglx@linutronix.de, jkosina@suse.cz, mhocko@suse.cz
In-Reply-To: <1252400515-6866-1-git-send-email-mhocko@suse.cz>
References: <1252400515-6866-1-git-send-email-mhocko@suse.cz>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Increase MIN_GAP to include randomized stack
Message-ID: <tip-80938332d8cf652f6b16e0788cf0ca136befe0b5@git.kernel.org>
Git-Commit-ID: 80938332d8cf652f6b16e0788cf0ca136befe0b5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 11 Sep 2009 00:06:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  80938332d8cf652f6b16e0788cf0ca136befe0b5
Gitweb:     http://git.kernel.org/tip/80938332d8cf652f6b16e0788cf0ca136befe0b5
Author:     Michal Hocko <mhocko@suse.cz>
AuthorDate: Tue, 8 Sep 2009 11:01:55 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 10 Sep 2009 17:00:12 -0700

x86: Increase MIN_GAP to include randomized stack

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
Cc: Stable Team <stable@kernel.org>


---
 arch/x86/include/asm/elf.h |    2 ++
 arch/x86/mm/mmap.c         |   17 +++++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

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
