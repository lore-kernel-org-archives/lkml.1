Return-Path: <linux-kernel-owner+w=401wt.eu-S1751815Ab0AKV22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815Ab0AKV22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542Ab0AKV2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:28:25 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:60356 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab0AKV1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:27:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=wZRMsqgOSo+JLwreukD4V02YzU2ZLLva4mVP1nmLSBYvUH73eSzMUSJSZcyBatQnKz
         zZyRNLUKZH9PDerBrO5A3nz/2hwbxUFHUlNxZ4n0+K4mlDGvaanVEEm8/oEgloCyNHlJ
         zjHkUOXLHM7i8rrGebKwVbbZg5Jp9m+AM9fXQ=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 26/26] softlockup: Convert to raw_spinlocks
Date: Mon, 11 Jan 2010 22:26:56 +0100
Message-Id: <1263245216-14754-27-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263245216-14754-26-git-send-email-jkacur@redhat.com>
References: <1263245216-14754-1-git-send-email-jkacur@redhat.com>
 <1263245216-14754-2-git-send-email-jkacur@redhat.com>
 <1263245216-14754-3-git-send-email-jkacur@redhat.com>
 <1263245216-14754-4-git-send-email-jkacur@redhat.com>
 <1263245216-14754-5-git-send-email-jkacur@redhat.com>
 <1263245216-14754-6-git-send-email-jkacur@redhat.com>
 <1263245216-14754-7-git-send-email-jkacur@redhat.com>
 <1263245216-14754-8-git-send-email-jkacur@redhat.com>
 <1263245216-14754-9-git-send-email-jkacur@redhat.com>
 <1263245216-14754-10-git-send-email-jkacur@redhat.com>
 <1263245216-14754-11-git-send-email-jkacur@redhat.com>
 <1263245216-14754-12-git-send-email-jkacur@redhat.com>
 <1263245216-14754-13-git-send-email-jkacur@redhat.com>
 <1263245216-14754-14-git-send-email-jkacur@redhat.com>
 <1263245216-14754-15-git-send-email-jkacur@redhat.com>
 <1263245216-14754-16-git-send-email-jkacur@redhat.com>
 <1263245216-14754-17-git-send-email-jkacur@redhat.com>
 <1263245216-14754-18-git-send-email-jkacur@redhat.com>
 <1263245216-14754-19-git-send-email-jkacur@redhat.com>
 <1263245216-14754-20-git-send-email-jkacur@redhat.com>
 <1263245216-14754-21-git-send-email-jkacur@redhat.com>
 <1263245216-14754-22-git-send-email-jkacur@redhat.com>
 <1263245216-14754-23-git-send-email-jkacur@redhat.com>
 <1263245216-14754-24-git-send-email-jkacur@redhat.com>
 <1263245216-14754-25-git-send-email-jkacur@redhat.com>
 <1263245216-14754-26-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert locks which cannot be sleeping locks in preempt-rt to raw_spinlocks

See also b20de918527a9c1558b3e8a02f935cf4cb53e3ba

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 kernel/softlockup.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index d225790..8e63d20 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -20,7 +20,7 @@
 
 #include <asm/irq_regs.h>
 
-static DEFINE_SPINLOCK(print_lock);
+static DEFINE_RAW_SPINLOCK(print_lock);
 
 static DEFINE_PER_CPU(unsigned long, softlockup_touch_ts); /* touch timestamp */
 static DEFINE_PER_CPU(unsigned long, softlockup_print_ts); /* print timestamp */
@@ -149,7 +149,7 @@ void softlockup_tick(void)
 
 	per_cpu(softlockup_print_ts, this_cpu) = touch_ts;
 
-	spin_lock(&print_lock);
+	raw_spin_lock(&print_lock);
 	printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %lus! [%s:%d]\n",
 			this_cpu, now - touch_ts,
 			current->comm, task_pid_nr(current));
@@ -159,7 +159,7 @@ void softlockup_tick(void)
 		show_regs(regs);
 	else
 		dump_stack();
-	spin_unlock(&print_lock);
+	raw_spin_unlock(&print_lock);
 
 	if (softlockup_panic)
 		panic("softlockup: hung tasks");
-- 
1.6.5.2

