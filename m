Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505Ab0A1E6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab0A1E6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 23:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077Ab0A1E6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 23:58:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:40514 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab0A1E6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 23:58:32 -0500
Date: Thu, 28 Jan 2010 04:57:43 GMT
From: tip-bot for Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, jslaby@suse.cz, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, jslaby@suse.cz, mingo@elte.hu
In-Reply-To: <1264609942-24621-1-git-send-email-jslaby@suse.cz>
References: <1264609942-24621-1-git-send-email-jslaby@suse.cz>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/rlimit] x86: Use helpers for rlimits
Message-ID: <tip-2854e72b58dad82f5248b30a45dda0df49e5fe05@git.kernel.org>
Git-Commit-ID: 2854e72b58dad82f5248b30a45dda0df49e5fe05
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 28 Jan 2010 04:57:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2854e72b58dad82f5248b30a45dda0df49e5fe05
Gitweb:     http://git.kernel.org/tip/2854e72b58dad82f5248b30a45dda0df49e5fe05
Author:     Jiri Slaby <jslaby@suse.cz>
AuthorDate: Wed, 27 Jan 2010 17:32:22 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 27 Jan 2010 15:17:31 -0800

x86: Use helpers for rlimits

Make sure compiler won't do weird things with limits.  Fetching them
twice may return 2 different values after writable limits are
implemented.

We can either use rlimit helpers added in
3e10e716abf3c71bdb5d86b8f507f9e72236c9cd or ACCESS_ONCE if not
applicable; this patch uses the helpers.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
LKML-Reference: <1264609942-24621-1-git-send-email-jslaby@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/ia32/ia32_aout.c |    2 +-
 arch/x86/mm/mmap.c        |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index 2a4d073..0647478 100644
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
