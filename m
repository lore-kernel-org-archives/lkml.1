Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbYIAXQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbYIAXQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 19:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbYIAXPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 19:15:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:40558 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbYIAXP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 19:15:29 -0400
Date: Mon, 1 Sep 2008 16:05:48 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, torvalds@linux-foundation.org,
       dwmw2@infradead.org, drepper@redhat.com, mingo@elte.hu, tglx@tglx.de
Subject: [PATCH 2/13] hrtimer: convert kvm to the new hrtimer apis
Message-ID: <20080901160548.05986488@infradead.org>
In-Reply-To: <20080901160343.75a89ec9@infradead.org>
References: <20080901160343.75a89ec9@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] hrtimer: convert kvm to the new hrtimer apis

In order to be able to do range hrtimers we need to use accessor functions
to the "expire" member of the hrtimer struct.
This patch converts KVM to these accessors.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/kvm/i8254.c |    6 +++---
 arch/x86/kvm/lapic.c |    6 ++----
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index c0f7872..1bf8f57 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -205,8 +205,8 @@ static int __pit_timer_fn(struct kvm_kpit_state *ps)
 		wake_up_interruptible(&vcpu0->wq);
 	}
 
-	pt->timer.expires = ktime_add_ns(pt->timer.expires, pt->period);
-	pt->scheduled = ktime_to_ns(pt->timer.expires);
+	hrtimer_add_expires_ns(&pt->timer, pt->period);
+	pt->scheduled = ktime_to_ns(hrtimer_get_expires(&pt->timer));
 
 	return (pt->period == 0 ? 0 : 1);
 }
@@ -246,7 +246,7 @@ void __kvm_migrate_pit_timer(struct kvm_vcpu *vcpu)
 
 	timer = &pit->pit_state.pit_timer.timer;
 	if (hrtimer_cancel(timer))
-		hrtimer_start(timer, timer->expires, HRTIMER_MODE_ABS);
+		hrtimer_start_expires(timer, HRTIMER_MODE_ABS);
 }
 
 static void destroy_pit_timer(struct kvm_kpit_timer *pt)
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 73f43de..a5b61de 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -953,9 +953,7 @@ static int __apic_timer_fn(struct kvm_lapic *apic)
 	}
 	if (apic_lvtt_period(apic)) {
 		result = 1;
-		apic->timer.dev.expires = ktime_add_ns(
-					apic->timer.dev.expires,
-					apic->timer.period);
+		hrtimer_add_expires_ns(&apic->timer.dev, apic->timer.period);
 	}
 	return result;
 }
@@ -1124,7 +1122,7 @@ void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
 
 	timer = &apic->timer.dev;
 	if (hrtimer_cancel(timer))
-		hrtimer_start(timer, timer->expires, HRTIMER_MODE_ABS);
+		hrtimer_start_expires(timer, HRTIMER_MODE_ABS);
 }
 
 void kvm_lapic_sync_from_vapic(struct kvm_vcpu *vcpu)
-- 
1.5.5.1

