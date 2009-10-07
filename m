Return-Path: <linux-kernel-owner+w=401wt.eu-S1759427AbZJGOdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbZJGOdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759416AbZJGOc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:32:59 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:45640
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759415AbZJGOc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:32:56 -0400
X-SpamScore: 8
X-BigFish: VPS8(zza4b1ozz1202hzzz32i6bh63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-WSS-ID: 0KR5F0S-01-FE9-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexander Graf <agraf@suse.de>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/10] KVM: SVM: Notify nested hypervisor of lost event injections
Date: Wed, 7 Oct 2009 16:31:19 +0200
Message-ID: <1254925888-13743-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1254925888-13743-1-git-send-email-joerg.roedel@amd.com>
References: <1254925888-13743-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Oct 2009 14:31:35.0061 (UTC) FILETIME=[DF308C50:01CA475A]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

If event_inj is valid on a #vmexit the host CPU would write
the contents to exit_int_info, so the hypervisor knows that
the event wasn't injected.

We don't do this in nested SVM by now which is a bug and
fixed by this patch.

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 279a2ae..b6ce1a9 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1615,6 +1615,22 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 	nested_vmcb->control.exit_info_2       = vmcb->control.exit_info_2;
 	nested_vmcb->control.exit_int_info     = vmcb->control.exit_int_info;
 	nested_vmcb->control.exit_int_info_err = vmcb->control.exit_int_info_err;
+
+	/*
+	 * If we emulate a VMRUN/#VMEXIT in the same host #vmexit cycle we have
+	 * to make sure that we do not lose injected events. So check event_inj
+	 * here and copy it to exit_int_info if it is valid.
+	 * Exit_int_info and event_inj can't be both valid because the case
+	 * below case only happens on a VMRUN instruction intercept which has
+	 * no valid exit_int_info set.
+	 */
+	if (vmcb->control.event_inj & SVM_EVTINJ_VALID) {
+		struct vmcb_control_area *nc = &nested_vmcb->control;
+
+		nc->exit_int_info     = vmcb->control.event_inj;
+		nc->exit_int_info_err = vmcb->control.event_inj_err;
+	}
+
 	nested_vmcb->control.tlb_ctl           = 0;
 	nested_vmcb->control.event_inj         = 0;
 	nested_vmcb->control.event_inj_err     = 0;
-- 
1.6.4.3


