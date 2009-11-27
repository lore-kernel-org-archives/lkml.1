Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915AbZK0XGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbZK0XGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 18:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbZK0XGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 18:06:15 -0500
Received: from server1.wserver.cz ([82.113.45.157]:60481 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbZK0XGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 18:06:06 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: mingo@elte.hu, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org, oleg@redhat.com,
       James Morris <jmorris@namei.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH v3 18/27] SPARC: use helpers for rlimits
Date: Sat, 28 Nov 2009 00:05:58 +0100
Message-Id: <1259363167-9347-18-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
References: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure compiler won't do weird things with limits. E.g. fetching
them twice may return 2 different values after writable limits are
implemented.

I.e. either use newly added rlimit helpers or ACCESS_ONCE if not
applicable.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: James Morris <jmorris@namei.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
---
 arch/sparc/kernel/sys_sparc_64.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
index e2d1024..d53870c 100644
--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -361,6 +361,7 @@ EXPORT_SYMBOL(get_fb_unmapped_area);
 void arch_pick_mmap_layout(struct mm_struct *mm)
 {
 	unsigned long random_factor = 0UL;
+	unsigned long gap;
 
 	if (current->flags & PF_RANDOMIZE) {
 		random_factor = get_random_int();
@@ -375,9 +376,10 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
 	 * Fall back to the standard layout if the personality
 	 * bit is set, or if the expected stack growth is unlimited:
 	 */
+	gap = rlim_get_cur(RLIMIT_STACK);
 	if (!test_thread_flag(TIF_32BIT) ||
 	    (current->personality & ADDR_COMPAT_LAYOUT) ||
-	    current->signal->rlim[RLIMIT_STACK].rlim_cur == RLIM_INFINITY ||
+	    gap == RLIM_INFINITY ||
 	    sysctl_legacy_va_layout) {
 		mm->mmap_base = TASK_UNMAPPED_BASE + random_factor;
 		mm->get_unmapped_area = arch_get_unmapped_area;
@@ -385,9 +387,7 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
 	} else {
 		/* We know it's 32-bit */
 		unsigned long task_size = STACK_TOP32;
-		unsigned long gap;
 
-		gap = current->signal->rlim[RLIMIT_STACK].rlim_cur;
 		if (gap < 128 * 1024 * 1024)
 			gap = 128 * 1024 * 1024;
 		if (gap > (task_size / 6 * 5))
-- 
1.6.5.3

