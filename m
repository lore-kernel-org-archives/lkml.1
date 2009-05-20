Return-Path: <linux-kernel-owner+w=401wt.eu-S1758867AbZETL2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867AbZETL2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756836AbZETLUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:20:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55275 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755564AbZETLSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:49 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 19/46] KVM: PIT: fix count read and mode 0 handling
Date: Wed, 20 May 2009 14:18:16 +0300
Message-Id: <1242818323-10413-20-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Commit 46ee278652f4cbd51013471b64c7897ba9bcd1b1 causes Solaris 10
to hang on boot.

Assuming that PIT counter reads should return 0 for an expired timer
is wrong: when it is active, the counter never stops (see comment on
__kpit_elapsed).

Also arm a one shot timer for mode 0.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/i8254.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index cf09bb6..4d6f0d2 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -104,13 +104,18 @@ static s64 __kpit_elapsed(struct kvm *kvm)
 	ktime_t remaining;
 	struct kvm_kpit_state *ps = &kvm->arch.vpit->pit_state;
 
+	/*
+	 * The Counter does not stop when it reaches zero. In
+	 * Modes 0, 1, 4, and 5 the Counter ``wraps around'' to
+	 * the highest count, either FFFF hex for binary counting
+	 * or 9999 for BCD counting, and continues counting.
+	 * Modes 2 and 3 are periodic; the Counter reloads
+	 * itself with the initial count and continues counting
+	 * from there.
+	 */
 	remaining = hrtimer_expires_remaining(&ps->pit_timer.timer);
-	if (ktime_to_ns(remaining) < 0)
-		remaining = ktime_set(0, 0);
-
-	elapsed = ps->pit_timer.period;
-	if (ktime_to_ns(remaining) <= ps->pit_timer.period)
-		elapsed = ps->pit_timer.period - ktime_to_ns(remaining);
+	elapsed = ps->pit_timer.period - ktime_to_ns(remaining);
+	elapsed = mod_64(elapsed, ps->pit_timer.period);
 
 	return elapsed;
 }
@@ -280,7 +285,7 @@ static void create_pit_timer(struct kvm_kpit_state *ps, u32 val, int is_period)
 
 	/* TODO The new value only affected after the retriggered */
 	hrtimer_cancel(&pt->timer);
-	pt->period = (is_period == 0) ? 0 : interval;
+	pt->period = interval;
 	ps->is_periodic = is_period;
 
 	pt->timer.function = kvm_timer_fn;
@@ -304,10 +309,8 @@ static void pit_load_count(struct kvm *kvm, int channel, u32 val)
 	pr_debug("pit: load_count val is %d, channel is %d\n", val, channel);
 
 	/*
-	 * Though spec said the state of 8254 is undefined after power-up,
-	 * seems some tricky OS like Windows XP depends on IRQ0 interrupt
-	 * when booting up.
-	 * So here setting initialize rate for it, and not a specific number
+	 * The largest possible initial count is 0; this is equivalent
+	 * to 216 for binary counting and 104 for BCD counting.
 	 */
 	if (val == 0)
 		val = 0x10000;
@@ -322,6 +325,7 @@ static void pit_load_count(struct kvm *kvm, int channel, u32 val)
 	/* Two types of timer
 	 * mode 1 is one shot, mode 2 is period, otherwise del timer */
 	switch (ps->channels[0].mode) {
+	case 0:
 	case 1:
         /* FIXME: enhance mode 4 precision */
 	case 4:
-- 
1.6.0.6

