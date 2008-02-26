Return-Path: <linux-kernel-owner+w=401wt.eu-S1763854AbYBZVAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763854AbYBZVAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYBZVA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:00:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995AbYBZVA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:00:26 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: Tomasz Grobelny <tomasz@grobelny.oswiecenia.net>
Subject: [PATCH] x86 tls prevent_tail_call
X-Fcc: ~/Mail/linus
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080226210018.A031B26F9A4@magilla.localdomain>
Date: Tue, 26 Feb 2008 13:00:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The x86 TLS cleanup in commit efd1ca52d04d2f6df337a3332cee56cd60e6d4c4
made the sys_set_thread_area and sys_get_thread_area functions ripe for
tail call optimization.  If the compiler chooses to use it for them, it
can clobber the user trap frame because these are asmlinkage functions.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/tls.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index 6dfd4e7..022bcaa 100644
--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -91,7 +91,9 @@ int do_set_thread_area(struct task_struct *p, int idx,
 
 asmlinkage int sys_set_thread_area(struct user_desc __user *u_info)
 {
-	return do_set_thread_area(current, -1, u_info, 1);
+	int ret = do_set_thread_area(current, -1, u_info, 1);
+	prevent_tail_call(ret);
+	return ret;
 }
 
 
@@ -139,7 +141,9 @@ int do_get_thread_area(struct task_struct *p, int idx,
 
 asmlinkage int sys_get_thread_area(struct user_desc __user *u_info)
 {
-	return do_get_thread_area(current, -1, u_info);
+	int ret = do_get_thread_area(current, -1, u_info);
+	prevent_tail_call(ret);
+	return ret;
 }
 
 int regset_tls_active(struct task_struct *target,
