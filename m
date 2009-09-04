Return-Path: <linux-kernel-owner+w=401wt.eu-S934084AbZIDUUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934084AbZIDUUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934056AbZIDUUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:20:15 -0400
Received: from kroah.org ([198.145.64.141]:36178 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934019AbZIDUOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:25 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:53 2009
Message-Id: <20090904200853.134480901@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [patch 19/48] KVM: set debug registers after "schedulable" section
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=kvm-set-debug-registers-after-schedulable-section.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Marcelo Tosatti <mtosatti@redhat.com>

(cherry picked from commit 29415c37f043d1d54dcf356601d738ff6633b72b)

The vcpu thread can be preempted after the guest_debug_pre() callback,
resulting in invalid debug registers on the new vcpu.

Move it inside the non-preemptable section.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/x86.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2839,10 +2839,6 @@ static int __vcpu_run(struct kvm_vcpu *v
 	down_read(&vcpu->kvm->slots_lock);
 	vapic_enter(vcpu);
 
-preempted:
-	if (vcpu->guest_debug.enabled)
-		kvm_x86_ops->guest_debug_pre(vcpu);
-
 again:
 	if (vcpu->requests)
 		if (test_and_clear_bit(KVM_REQ_MMU_RELOAD, &vcpu->requests))
@@ -2896,6 +2892,9 @@ again:
 		goto out;
 	}
 
+	if (vcpu->guest_debug.enabled)
+		kvm_x86_ops->guest_debug_pre(vcpu);
+
 	vcpu->guest_mode = 1;
 	/*
 	 * Make sure that guest_mode assignment won't happen after
@@ -2970,7 +2969,7 @@ out:
 	if (r > 0) {
 		kvm_resched(vcpu);
 		down_read(&vcpu->kvm->slots_lock);
-		goto preempted;
+		goto again;
 	}
 
 	post_kvm_run_save(vcpu, kvm_run);


