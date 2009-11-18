Return-Path: <linux-kernel-owner+w=401wt.eu-S1757600AbZKROwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600AbZKROwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:52:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbZKROwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:52:06 -0500
Received: from server1.wserver.cz ([82.113.45.157]:51260 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbZKROv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:51:59 -0500
From: Jiri Slaby <jslaby@novell.com>
To: jirislaby@gmail.com
Cc: mingo@elte.hu, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org,
       Jiri Slaby <jslaby@novell.com>, James Morris <jmorris@namei.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, x86@kernel.org
Subject: [PATCH 07/16] X86: use ACCESS_ONCE for rlimits
Date: Wed, 18 Nov 2009 15:51:53 +0100
Message-Id: <1258555922-2064-7-git-send-email-jslaby@novell.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <4B040A03.2020508@gmail.com>
References: <4B040A03.2020508@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure compiler won't do weird things with limits. E.g. fetching
them twice may return 2 different values after writable limits are
implemented.

Signed-off-by: Jiri Slaby <jslaby@novell.com>
Cc: James Morris <jmorris@namei.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
---
 arch/x86/ia32/ia32_aout.c |    2 +-
 arch/x86/mm/mmap.c        |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index 2a4d073..239071b 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -297,7 +297,7 @@ static int load_aout_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	 * size limits imposed on them by creating programs with large
 	 * arrays in the data or bss.
 	 */
-	rlim = current->signal->rlim[RLIMIT_DATA].rlim_cur;
+	rlim = ACCESS_ONCE(current->signal->rlim[RLIMIT_DATA].rlim_cur);
 	if (rlim >= RLIM_INFINITY)
 		rlim = ~0;
 	if (ex.a_data + ex.a_bss > rlim)
diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index c8191de..5578c84 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -71,7 +71,8 @@ static int mmap_is_legacy(void)
 	if (current->personality & ADDR_COMPAT_LAYOUT)
 		return 1;
 
-	if (current->signal->rlim[RLIMIT_STACK].rlim_cur == RLIM_INFINITY)
+	if (ACCESS_ONCE(current->signal->rlim[RLIMIT_STACK].rlim_cur)
+			== RLIM_INFINITY)
 		return 1;
 
 	return sysctl_legacy_va_layout;
@@ -96,7 +97,8 @@ static unsigned long mmap_rnd(void)
 
 static unsigned long mmap_base(void)
 {
-	unsigned long gap = current->signal->rlim[RLIMIT_STACK].rlim_cur;
+	unsigned long gap =
+		ACCESS_ONCE(current->signal->rlim[RLIMIT_STACK].rlim_cur);
 
 	if (gap < MIN_GAP)
 		gap = MIN_GAP;
-- 
1.6.4.2

