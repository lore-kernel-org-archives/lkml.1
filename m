Return-Path: <linux-kernel-owner+w=401wt.eu-S934909AbZJNQeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934909AbZJNQeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 12:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932207AbZJNQeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 12:34:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:42401 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756221AbZJNQeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 12:34:07 -0400
Date: Wed, 14 Oct 2009 16:32:57 GMT
From: tip-bot for Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, sivanich@sgi.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, sivanich@sgi.com, mingo@elte.hu
In-Reply-To: <20091014141630.GB11048@sgi.com>
References: <20091014141630.GB11048@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86: UV RTC: Fix early expiry handling
Message-ID: <tip-e47938b1faaf9e9041ae842a878901001ce20ea1@git.kernel.org>
Git-Commit-ID: e47938b1faaf9e9041ae842a878901001ce20ea1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 16:32:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e47938b1faaf9e9041ae842a878901001ce20ea1
Gitweb:     http://git.kernel.org/tip/e47938b1faaf9e9041ae842a878901001ce20ea1
Author:     Dimitri Sivanich <sivanich@sgi.com>
AuthorDate: Wed, 14 Oct 2009 09:16:30 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 14 Oct 2009 18:27:09 +0200

x86: UV RTC: Fix early expiry handling

Tune/fix early timer expiry handling and return correct early timeout value
for set_next_event.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
LKML-Reference: <20091014141630.GB11048@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/uv_time.c |   29 +++++++++++++++++------------
 1 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/uv_time.c b/arch/x86/kernel/uv_time.c
index 583f11d..ec14889 100644
--- a/arch/x86/kernel/uv_time.c
+++ b/arch/x86/kernel/uv_time.c
@@ -123,7 +123,10 @@ static int uv_setup_intr(int cpu, u64 expires)
 	/* Initialize comparator value */
 	uv_write_global_mmr64(pnode, UVH_INT_CMPB, expires);
 
-	return (expires < uv_read_rtc(NULL) && !uv_intr_pending(pnode));
+	if (uv_read_rtc(NULL) <= expires)
+		return 0;
+
+	return !uv_intr_pending(pnode);
 }
 
 /*
@@ -223,6 +226,7 @@ static int uv_rtc_set_timer(int cpu, u64 expires)
 
 	next_cpu = head->next_cpu;
 	*t = expires;
+
 	/* Will this one be next to go off? */
 	if (next_cpu < 0 || bcpu == next_cpu ||
 			expires < head->cpu[next_cpu].expires) {
@@ -231,7 +235,7 @@ static int uv_rtc_set_timer(int cpu, u64 expires)
 			*t = ULLONG_MAX;
 			uv_rtc_find_next_timer(head, pnode);
 			spin_unlock_irqrestore(&head->lock, flags);
-			return 1;
+			return -ETIME;
 		}
 	}
 
@@ -244,7 +248,7 @@ static int uv_rtc_set_timer(int cpu, u64 expires)
  *
  * Returns 1 if this timer was pending.
  */
-static int uv_rtc_unset_timer(int cpu)
+static int uv_rtc_unset_timer(int cpu, int force)
 {
 	int pnode = uv_cpu_to_pnode(cpu);
 	int bid = uv_cpu_to_blade_id(cpu);
@@ -256,14 +260,15 @@ static int uv_rtc_unset_timer(int cpu)
 
 	spin_lock_irqsave(&head->lock, flags);
 
-	if (head->next_cpu == bcpu && uv_read_rtc(NULL) >= *t)
+	if ((head->next_cpu == bcpu && uv_read_rtc(NULL) >= *t) || force)
 		rc = 1;
 
-	*t = ULLONG_MAX;
-
-	/* Was the hardware setup for this timer? */
-	if (head->next_cpu == bcpu)
-		uv_rtc_find_next_timer(head, pnode);
+	if (rc) {
+		*t = ULLONG_MAX;
+		/* Was the hardware setup for this timer? */
+		if (head->next_cpu == bcpu)
+			uv_rtc_find_next_timer(head, pnode);
+	}
 
 	spin_unlock_irqrestore(&head->lock, flags);
 
@@ -310,20 +315,20 @@ static void uv_rtc_timer_setup(enum clock_event_mode mode,
 		break;
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
-		uv_rtc_unset_timer(ced_cpu);
+		uv_rtc_unset_timer(ced_cpu, 1);
 		break;
 	}
 }
 
 static void uv_rtc_interrupt(void)
 {
-	struct clock_event_device *ced = &__get_cpu_var(cpu_ced);
 	int cpu = smp_processor_id();
+	struct clock_event_device *ced = &per_cpu(cpu_ced, cpu);
 
 	if (!ced || !ced->event_handler)
 		return;
 
-	if (uv_rtc_unset_timer(cpu) != 1)
+	if (uv_rtc_unset_timer(cpu, 0) != 1)
 		return;
 
 	ced->event_handler(ced);
