Return-Path: <linux-kernel-owner+w=401wt.eu-S1760307AbYJMXES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760307AbYJMXES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 19:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756419AbYJMXEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 19:04:07 -0400
Received: from smtp.cs.aau.dk ([130.225.194.6]:47922 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756282AbYJMXEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 19:04:06 -0400
Subject: [PATCH] x86/paravirt: fix compile warning for !SMP builds
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 14 Oct 2008 00:59:26 +0200
Message-Id: <1223938766.21717.17.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following compile warning for !SMP builds:

arch/x86/kernel/paravirt-spinlocks.c:11: warning: 'default_spin_lock_flags' defined but not used

that was introduced by 63d3a75d (x86/paravirt: add spin_lock_flags lock op).

Signed-off-by: Simon Holm Thøgersen <odie@cs.aau.dk>
---
 arch/x86/kernel/paravirt-spinlocks.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/paravirt-spinlocks.c b/arch/x86/kernel/paravirt-spinlocks.c
index 0e9f198..ebcb33d 100644
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -7,13 +7,13 @@
 
 #include <asm/paravirt.h>
 
+#ifdef CONFIG_SMP
 static void default_spin_lock_flags(struct raw_spinlock *lock, unsigned long flags)
 {
 	__raw_spin_lock(lock);
 }
 
 struct pv_lock_ops pv_lock_ops = {
-#ifdef CONFIG_SMP
 	.spin_is_locked = __ticket_spin_is_locked,
 	.spin_is_contended = __ticket_spin_is_contended,
 
@@ -21,8 +21,10 @@ struct pv_lock_ops pv_lock_ops = {
 	.spin_lock_flags = default_spin_lock_flags,
 	.spin_trylock = __ticket_spin_trylock,
 	.spin_unlock = __ticket_spin_unlock,
-#endif
 };
+#else
+struct pv_lock_ops pv_lock_ops;
+#endif
 EXPORT_SYMBOL(pv_lock_ops);
 
 void __init paravirt_use_bytelocks(void)
-- 
1.5.6.2.255.gbed62

