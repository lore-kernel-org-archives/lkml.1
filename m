Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036Ab0AZXoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab0AZXoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949Ab0AZXoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:44:25 -0500
Received: from kroah.org ([198.145.64.141]:35532 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754951Ab0AZXoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:44:20 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:32 2010
Message-Id: <20100126233932.416222630@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [88/98] KVM: Fix race between APIC TMR and IRR
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Avi Kivity <avi@redhat.com>

commit a5d36f82c4f3e852b61fdf1fee13463c8aa91b90 upstream.

When we queue an interrupt to the local apic, we set the IRR before the TMR.
The vcpu can pick up the IRR and inject the interrupt before setting the TMR,
and perhaps even EOI it, causing incorrect behaviour.

The race is really insignificant since it can only occur on the first
interrupt (usually following interrupts will not change TMR), but it's better
closed than open.

Fixed by reordering setting the TMR vs IRR.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/lapic.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -374,6 +374,12 @@ static int __apic_accept_irq(struct kvm_
 		if (unlikely(!apic_enabled(apic)))
 			break;
 
+		if (trig_mode) {
+			apic_debug("level trig mode for vector %d", vector);
+			apic_set_vector(vector, apic->regs + APIC_TMR);
+		} else
+			apic_clear_vector(vector, apic->regs + APIC_TMR);
+
 		result = !apic_test_and_set_irr(vector, apic);
 		trace_kvm_apic_accept_irq(vcpu->vcpu_id, delivery_mode,
 					  trig_mode, vector, !result);
@@ -384,11 +390,6 @@ static int __apic_accept_irq(struct kvm_
 			break;
 		}
 
-		if (trig_mode) {
-			apic_debug("level trig mode for vector %d", vector);
-			apic_set_vector(vector, apic->regs + APIC_TMR);
-		} else
-			apic_clear_vector(vector, apic->regs + APIC_TMR);
 		kvm_vcpu_kick(vcpu);
 		break;
 


