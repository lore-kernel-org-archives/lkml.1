Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbYJVKhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbYJVKhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 06:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbYJVKhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 06:37:47 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:8822 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbYJVKhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 06:37:46 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Neil Horman <nhorman@tuxdriver.com>, Ingo Molnar <mingo@elte.hu>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, hbabu@us.ibm.com, hpa@zytor.com,
       akpm@linux-foundation.org,
       Alexander van Heukelum <heukelum@fastmail.fm>, ebiederm@xmission.com,
       tglx@linutronix.de
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 5/7] i386, dumpstack: use x86_64's method to account die_nest_count
Date: Wed, 22 Oct 2008 12:00:12 +0200
Message-Id: <1224669614-25863-6-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1224669614-25863-5-git-send-email-heukelum@fastmail.fm>
References: <1224669614-25863-1-git-send-email-heukelum@fastmail.fm>
 <1224669614-25863-2-git-send-email-heukelum@fastmail.fm>
 <1224669614-25863-3-git-send-email-heukelum@fastmail.fm>
 <1224669614-25863-4-git-send-email-heukelum@fastmail.fm>
 <1224669614-25863-5-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Wed, 22 Oct 2008 12:36:43 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.9.0.5; VDF: 7.0.7.72; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oops_begin/oops_end should always be used in pairs. On x86_64
oops_begin increments die_nest_count, and oops_end decrements
die_nest_count. Doing this makes oops_begin and oops_end equal
to the x86_64 versions.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/dumpstack_32.c |   29 +++++++++++++++++------------
 1 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index a29b88f..7c7d691 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -289,21 +289,24 @@ static unsigned int die_nest_count;
 
 unsigned __kprobes long oops_begin(void)
 {
+	int cpu;
 	unsigned long flags;
 
 	oops_enter();
 
-	if (die_owner != raw_smp_processor_id()) {
-		console_verbose();
-		raw_local_irq_save(flags);
-		__raw_spin_lock(&die_lock);
-		die_owner = smp_processor_id();
-		die_nest_count = 0;
-		bust_spinlocks(1);
-	} else {
-		raw_local_irq_save(flags);
+	/* racy, but better than risking deadlock. */
+	raw_local_irq_save(flags);
+	cpu = smp_processor_id();
+	if (!__raw_spin_trylock(&die_lock)) {
+		if (cpu == die_owner)
+			/* nested oops. should stop eventually */;
+		else
+			__raw_spin_lock(&die_lock);
 	}
 	die_nest_count++;
+	die_owner = cpu;
+	console_verbose();
+	bust_spinlocks(1);
 	return flags;
 }
 
@@ -315,13 +318,15 @@ void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 	bust_spinlocks(0);
 	die_owner = -1;
 	add_taint(TAINT_DIE);
-	__raw_spin_unlock(&die_lock);
+	die_nest_count--;
+	if (!die_nest_count)
+		/* Nest count reaches zero, release the lock. */
+		__raw_spin_unlock(&die_lock);
 	raw_local_irq_restore(flags);
-
 	oops_exit();
+
 	if (!signr)
 		return;
-
 	if (in_interrupt())
 		panic("Fatal exception in interrupt");
 	if (panic_on_oops)
-- 
1.5.4.3

