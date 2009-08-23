Return-Path: <linux-kernel-owner+w=401wt.eu-S933706AbZHWMA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933706AbZHWMA3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 08:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933512AbZHWMA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 08:00:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933546AbZHWL4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:50 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 38/46] KVM: limit lapic periodic timer frequency
Date: Sun, 23 Aug 2009 14:56:37 +0300
Message-Id: <1251028605-31977-39-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Otherwise its possible to starve the host by programming lapic timer
with a very high frequency.

Cc: stable@kernel.org
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/lapic.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index fdddf48..ce195f8 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -664,6 +664,15 @@ static void start_apic_timer(struct kvm_lapic *apic)
 
 	if (!apic->lapic_timer.period)
 		return;
+	/*
+	 * Do not allow the guest to program periodic timers with small
+	 * interval, since the hrtimers are not throttled by the host
+	 * scheduler.
+	 */
+	if (apic_lvtt_period(apic)) {
+		if (apic->lapic_timer.period < NSEC_PER_MSEC/2)
+			apic->lapic_timer.period = NSEC_PER_MSEC/2;
+	}
 
 	hrtimer_start(&apic->lapic_timer.timer,
 		      ktime_add_ns(now, apic->lapic_timer.period),
-- 
1.6.4.1

