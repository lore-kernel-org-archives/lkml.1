Return-Path: <linux-kernel-owner+w=401wt.eu-S933953AbZJNOS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933953AbZJNOS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 10:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756579AbZJNOSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 10:18:25 -0400
Received: from relay2.sgi.com ([192.48.179.30]:60295 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754149AbZJNOSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 10:18:21 -0400
Date: Wed, 14 Oct 2009 09:16:30 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/4 v2] X86: UV RTC fix early expiry handling
Message-ID: <20091014141630.GB11048@sgi.com>
References: <20091009134727.GB3218@sgi.com> <20091012162317.GC1272@elte.hu> <20091012175233.GA8129@sgi.com> <20091012175920.GB17138@elte.hu> <20091014141438.GA11048@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014141438.GA11048@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tune/fix early timer expiry handling and return correct early timeout value
for set_next_event.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

 arch/x86/kernel/uv_time.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

Index: linux/arch/x86/kernel/uv_time.c
===================================================================
--- linux.orig/arch/x86/kernel/uv_time.c	2009-10-13 08:50:44.000000000 -0500
+++ linux/arch/x86/kernel/uv_time.c	2009-10-13 10:41:44.000000000 -0500
@@ -123,7 +123,10 @@ static int uv_setup_intr(int cpu, u64 ex
 	/* Initialize comparator value */
 	uv_write_global_mmr64(pnode, UVH_INT_CMPB, expires);
 
-	return (expires < uv_read_rtc(NULL) && !uv_intr_pending(pnode));
+	if (uv_read_rtc(NULL) <= expires)
+		return 0;
+
+	return !uv_intr_pending(pnode);
 }
 
 /*
@@ -223,6 +226,7 @@ static int uv_rtc_set_timer(int cpu, u64
 
 	next_cpu = head->next_cpu;
 	*t = expires;
+
 	/* Will this one be next to go off? */
 	if (next_cpu < 0 || bcpu == next_cpu ||
 			expires < head->cpu[next_cpu].expires) {
@@ -231,7 +235,7 @@ static int uv_rtc_set_timer(int cpu, u64
 			*t = ULLONG_MAX;
 			uv_rtc_find_next_timer(head, pnode);
 			spin_unlock_irqrestore(&head->lock, flags);
-			return 1;
+			return -ETIME;
 		}
 	}
 
@@ -244,7 +248,7 @@ static int uv_rtc_set_timer(int cpu, u64
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
 
@@ -310,20 +315,20 @@ static void uv_rtc_timer_setup(enum cloc
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
