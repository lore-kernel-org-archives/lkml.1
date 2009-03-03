Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbZCCIIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbZCCIIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 03:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbZCCIIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 03:08:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:54445 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbZCCIII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 03:08:08 -0500
Date: Tue, 3 Mar 2009 08:06:31 GMT
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, h-shimamoto@ct.jp.nec.com, hpa@zytor.com,
       mingo@redhat.com, efault@gmx.de, jaswinder@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, h-shimamoto@ct.jp.nec.com,
       linux-kernel@vger.kernel.org, jaswinder@kernel.org, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49AC85C1.7060600@ct.jp.nec.com>
References: <49AC85C1.7060600@ct.jp.nec.com>
Subject: [tip:x86/signal] x86, signals: fix xine & firefox bustage
Message-ID: <tip-2505170211f7630361a852e25b60f4df4c878daa@git.kernel.org>
Git-Commit-ID: 2505170211f7630361a852e25b60f4df4c878daa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 03 Mar 2009 08:06:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2505170211f7630361a852e25b60f4df4c878daa
Gitweb:     http://git.kernel.org/tip/2505170211f7630361a852e25b60f4df4c878daa
Author:     "Hiroshi Shimamoto" <h-shimamoto@ct.jp.nec.com>
AuthorDate: Mon, 2 Mar 2009 17:20:01 -0800
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 3 Mar 2009 09:03:12 +0100

x86, signals: fix xine & firefox bustage

Impact: fix bad frame in rt_sigreturn on 64-bit

After commit 97286a2b64725aac2d584ddd1f94871f9991d5a1 some applications
fail to return from signal handler:

[  145.150133] firefox[3250] bad frame in rt_sigreturn frame:00007f902b44eb28 ip:352e80b307 sp:7f902b44ef70 orax:ffffffffffffffff in libpthread-2.9.so[352e800000+17000]
[  665.519017] firefox[5420] bad frame in rt_sigreturn frame:00007faa8deaeb28 ip:352e80b307 sp:7faa8deaef70 orax:ffffffffffffffff in libpthread-2.9.so[352e800000+17000]

The root cause is forgetting to keep 64 byte aligned value of
fpstate for next stack pointer calculation.

Reported-by: Jaswinder Singh Rajput <jaswinder@kernel.org>
Reported-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
LKML-Reference: <49AC85C1.7060600@ct.jp.nec.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/signal.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index dde3f2a..d2cc642 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -240,11 +240,10 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
 
 	if (used_math()) {
 		sp -= sig_xstate_size;
-#ifdef CONFIG_X86_32
-		*fpstate = (void __user *) sp;
-#else /* !CONFIG_X86_32 */
-		*fpstate = (void __user *)round_down(sp, 64);
-#endif /* CONFIG_X86_32 */
+#ifdef CONFIG_X86_64
+		sp = round_down(sp, 64);
+#endif /* CONFIG_X86_64 */
+		*fpstate = (void __user *)sp;
 
 		if (save_i387_xstate(*fpstate) < 0)
 			return (void __user *)-1L;
