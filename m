Return-Path: <linux-kernel-owner+w=401wt.eu-S1760484AbZIPWnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760484AbZIPWnN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933626AbZIPWnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:43:10 -0400
Received: from kroah.org ([198.145.64.141]:55438 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933613AbZIPWkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:40:23 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:37:19 2009
Message-Id: <20090916223719.346977542@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:36:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [patch 41/45] KVM: limit lapic periodic timer frequency
References: <20090916223613.597295240@mini.kroah.org>
Content-Disposition: inline; filename=kvm-limit-lapic-periodic-timer-frequency.patch
In-Reply-To: <20090916223739.GA4789@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Marcelo Tosatti <mtosatti@redhat.com>

commit 1444885a045fe3b1905a14ea1b52540bf556578b upstream.

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
@@ -573,6 +573,15 @@ static void start_apic_timer(struct kvm_
 
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


