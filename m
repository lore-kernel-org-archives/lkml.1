Return-Path: <linux-kernel-owner+w=401wt.eu-S1754471Ab0A0Qc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab0A0Qc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 11:32:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188Ab0A0Qc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 11:32:28 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:33759 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab0A0Qc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 11:32:27 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org
Subject: [PATCH 1/1] X86: use helpers for rlimits
Date: Wed, 27 Jan 2010 17:32:22 +0100
Message-Id: <1264609942-24621-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.6.1
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
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
---
 arch/x86/ia32/ia32_aout.c |    2 +-
 arch/x86/mm/mmap.c        |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index 652e80f..3eb0974 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -297,7 +297,7 @@ static int load_aout_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	 * size limits imposed on them by creating programs with large
 	 * arrays in the data or bss.
 	 */
-	rlim = current->signal->rlim[RLIMIT_DATA].rlim_cur;
+	rlim = rlimit(RLIMIT_DATA);
 	if (rlim >= RLIM_INFINITY)
 		rlim = ~0;
 	if (ex.a_data + ex.a_bss > rlim)
diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index c8191de..1dab519 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -71,7 +71,7 @@ static int mmap_is_legacy(void)
 	if (current->personality & ADDR_COMPAT_LAYOUT)
 		return 1;
 
-	if (current->signal->rlim[RLIMIT_STACK].rlim_cur == RLIM_INFINITY)
+	if (rlimit(RLIMIT_STACK) == RLIM_INFINITY)
 		return 1;
 
 	return sysctl_legacy_va_layout;
@@ -96,7 +96,7 @@ static unsigned long mmap_rnd(void)
 
 static unsigned long mmap_base(void)
 {
-	unsigned long gap = current->signal->rlim[RLIMIT_STACK].rlim_cur;
+	unsigned long gap = rlimit(RLIMIT_STACK);
 
 	if (gap < MIN_GAP)
 		gap = MIN_GAP;
-- 
1.6.6.1

