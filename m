Return-Path: <linux-kernel-owner+w=401wt.eu-S932277Ab0AFP0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab0AFP0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 10:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292Ab0AFP0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 10:26:35 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:40195 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897Ab0AFPYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 10:24:52 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       sparclinux@vger.kernel.org
Subject: [PATCH] SPARC: use helpers for rlimits
Date: Wed,  6 Jan 2010 16:24:33 +0100
Message-Id: <1262791479-26594-5-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.7
In-Reply-To: <1262791479-26594-1-git-send-email-jslaby@suse.cz>
References: <1262791479-26594-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure compiler won't do weird things with limits. E.g. fetching
them twice may return 2 different values after writable limits are
implemented.

I.e. either use rlimit helpers added in
3e10e716abf3c71bdb5d86b8f507f9e72236c9cd
or ACCESS_ONCE if not applicable.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
---
 arch/sparc/kernel/sys_sparc_64.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
index cfa0e19..d77f543 100644
--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -365,6 +365,7 @@ EXPORT_SYMBOL(get_fb_unmapped_area);
 void arch_pick_mmap_layout(struct mm_struct *mm)
 {
 	unsigned long random_factor = 0UL;
+	unsigned long gap;
 
 	if (current->flags & PF_RANDOMIZE) {
 		random_factor = get_random_int();
@@ -379,9 +380,10 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
 	 * Fall back to the standard layout if the personality
 	 * bit is set, or if the expected stack growth is unlimited:
 	 */
+	gap = rlimit(RLIMIT_STACK);
 	if (!test_thread_flag(TIF_32BIT) ||
 	    (current->personality & ADDR_COMPAT_LAYOUT) ||
-	    current->signal->rlim[RLIMIT_STACK].rlim_cur == RLIM_INFINITY ||
+	    gap == RLIM_INFINITY ||
 	    sysctl_legacy_va_layout) {
 		mm->mmap_base = TASK_UNMAPPED_BASE + random_factor;
 		mm->get_unmapped_area = arch_get_unmapped_area;
@@ -389,9 +391,7 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
 	} else {
 		/* We know it's 32-bit */
 		unsigned long task_size = STACK_TOP32;
-		unsigned long gap;
 
-		gap = current->signal->rlim[RLIMIT_STACK].rlim_cur;
 		if (gap < 128 * 1024 * 1024)
 			gap = 128 * 1024 * 1024;
 		if (gap > (task_size / 6 * 5))
-- 
1.6.5.7

