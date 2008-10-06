Return-Path: <linux-kernel-owner+w=401wt.eu-S1753251AbYJFTQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbYJFTQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 15:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbYJFTP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 15:15:58 -0400
Received: from mail.windriver.com ([147.11.1.11]:58979 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbYJFTP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 15:15:57 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 1/2] kgdb, x86: Avoid invoking kgdb_nmicallback twice per NMI
Date: Mon,  6 Oct 2008 14:14:14 -0500
Message-Id: <1223320455-9266-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1223320455-9266-1-git-send-email-jason.wessel@windriver.com>
References: <1223320455-9266-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 06 Oct 2008 19:14:15.0542 (UTC) FILETIME=[B93C1160:01C927E7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Stress-testing KVM's latest NMI support with kgdbts inside an SMP guest,
I came across spurious unhandled NMIs while running the singlestep test.
Looking closer at the code path each NMI takes when KGDB is enabled, I
noticed that kgdb_nmicallback is called twice per event: One time via
DIE_NMI_IPI notification, the second time on DIE_NMI. Removing the first
invocation cures the unhandled NMIs here.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/kgdb.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 8282a21..10435a1 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -455,12 +455,7 @@ static int __kgdb_notify(struct die_args *args, unsigned long cmd)
 		return NOTIFY_DONE;
 
 	case DIE_NMI_IPI:
-		if (atomic_read(&kgdb_active) != -1) {
-			/* KGDB CPU roundup */
-			kgdb_nmicallback(raw_smp_processor_id(), regs);
-			was_in_debug_nmi[raw_smp_processor_id()] = 1;
-			touch_nmi_watchdog();
-		}
+		/* Just ignore, we will handle the roundup on DIE_NMI. */
 		return NOTIFY_DONE;
 
 	case DIE_NMIUNKNOWN:
-- 
1.6.0.2

