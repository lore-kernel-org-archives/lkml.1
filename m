Return-Path: <linux-kernel-owner+w=401wt.eu-S1758271AbZERJiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbZERJiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756002AbZERJXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:23:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38409 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbZERJXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:09 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 15/43] KVM: PIT: remove usage of count_load_time for channel 0
Date: Mon, 18 May 2009 12:22:37 +0300
Message-Id: <1242638585-18470-16-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

We can infer elapsed time from hrtimer_expires_remaining.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/i8254.c |   37 +++++++++++++++++++++++++++++++------
 1 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 3eddae6..09ae841 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -98,6 +98,32 @@ static int pit_get_gate(struct kvm *kvm, int channel)
 	return kvm->arch.vpit->pit_state.channels[channel].gate;
 }
 
+static s64 __kpit_elapsed(struct kvm *kvm)
+{
+	s64 elapsed;
+	ktime_t remaining;
+	struct kvm_kpit_state *ps = &kvm->arch.vpit->pit_state;
+
+	remaining = hrtimer_expires_remaining(&ps->pit_timer.timer);
+	if (ktime_to_ns(remaining) < 0)
+		remaining = ktime_set(0, 0);
+
+	elapsed = ps->pit_timer.period;
+	if (ktime_to_ns(remaining) <= ps->pit_timer.period)
+		elapsed = ps->pit_timer.period - ktime_to_ns(remaining);
+
+	return elapsed;
+}
+
+static s64 kpit_elapsed(struct kvm *kvm, struct kvm_kpit_channel_state *c,
+			int channel)
+{
+	if (channel == 0)
+		return __kpit_elapsed(kvm);
+
+	return ktime_to_ns(ktime_sub(ktime_get(), c->count_load_time));
+}
+
 static int pit_get_count(struct kvm *kvm, int channel)
 {
 	struct kvm_kpit_channel_state *c =
@@ -107,7 +133,7 @@ static int pit_get_count(struct kvm *kvm, int channel)
 
 	WARN_ON(!mutex_is_locked(&kvm->arch.vpit->pit_state.lock));
 
-	t = ktime_to_ns(ktime_sub(ktime_get(), c->count_load_time));
+	t = kpit_elapsed(kvm, c, channel);
 	d = muldiv64(t, KVM_PIT_FREQ, NSEC_PER_SEC);
 
 	switch (c->mode) {
@@ -137,7 +163,7 @@ static int pit_get_out(struct kvm *kvm, int channel)
 
 	WARN_ON(!mutex_is_locked(&kvm->arch.vpit->pit_state.lock));
 
-	t = ktime_to_ns(ktime_sub(ktime_get(), c->count_load_time));
+	t = kpit_elapsed(kvm, c, channel);
 	d = muldiv64(t, KVM_PIT_FREQ, NSEC_PER_SEC);
 
 	switch (c->mode) {
@@ -208,8 +234,6 @@ static int __pit_timer_fn(struct kvm_kpit_state *ps)
 		wake_up_interruptible(&vcpu0->wq);
 
 	hrtimer_add_expires_ns(&pt->timer, pt->period);
-	if (pt->period)
-		ps->channels[0].count_load_time = ktime_get();
 
 	return (pt->period == 0 ? 0 : 1);
 }
@@ -305,11 +329,12 @@ static void pit_load_count(struct kvm *kvm, int channel, u32 val)
 	if (val == 0)
 		val = 0x10000;
 
-	ps->channels[channel].count_load_time = ktime_get();
 	ps->channels[channel].count = val;
 
-	if (channel != 0)
+	if (channel != 0) {
+		ps->channels[channel].count_load_time = ktime_get();
 		return;
+	}
 
 	/* Two types of timer
 	 * mode 1 is one shot, mode 2 is period, otherwise del timer */
-- 
1.6.0.6

