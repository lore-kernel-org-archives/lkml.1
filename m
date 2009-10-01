Return-Path: <linux-kernel-owner+w=401wt.eu-S1756742AbZJAXmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbZJAXmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756004AbZJAXmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:42:31 -0400
Received: from kroah.org ([198.145.64.141]:42039 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535AbZJAXiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:38:11 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 16:33:20 2009
Message-Id: <20091001233320.677886993@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 16:31:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcelo Tosatti <mtosatti@redhat.com>, avi@redhat.com
Subject: [patch 13/30] KVM: limit lapic periodic timer frequency
References: <20091001233116.947658905@mini.kroah.org>
Content-Disposition: inline; filename=kvm-limit-lapic-periodic-timer-frequency.patch
In-Reply-To: <20091001233504.GA17709@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Marcelo Tosatti <mtosatti@redhat.com>

(cherry picked from commit 1444885a045fe3b1905a14ea1b52540bf556578b)

Otherwise its possible to starve the host by programming lapic timer
with a very high frequency.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/lapic.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -635,6 +635,15 @@ static void start_apic_timer(struct kvm_
 
 	if (!apic->timer.period)
 		return;
+	/*
+	 * Do not allow the guest to program periodic timers with small
+	 * interval, since the hrtimers are not throttled by the host
+	 * scheduler.
+	 */
+	if (apic_lvtt_period(apic)) {
+		if (apic->timer.period < NSEC_PER_MSEC/2)
+			apic->timer.period = NSEC_PER_MSEC/2;
+	}
 
 	hrtimer_start(&apic->timer.dev,
 		      ktime_add_ns(now, apic->timer.period),


