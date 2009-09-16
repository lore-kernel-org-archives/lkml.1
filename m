Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbZIPNZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbZIPNZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbZIPNZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:25:12 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:22906
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752493AbZIPNYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:24:50 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KQ2FX9-01-3NQ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexander Graf <agraf@suse.de>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/5] KVM: SVM: Fix tsc offset adjustment when running nested
Date: Wed, 16 Sep 2009 15:24:17 +0200
Message-ID: <1253107459-8967-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253107459-8967-1-git-send-email-joerg.roedel@amd.com>
References: <1253107459-8967-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 16 Sep 2009 13:24:23.0156 (UTC) FILETIME=[014FEB40:01CA36D1]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When svm_vcpu_load is called while the vcpu is running in
guest mode the tsc adjustment made there is lost on the next
emulated #vmexit. This causes the tsc running backwards in
the guest. This patch fixes the issue by also adjusting the
tsc_offset in the emulated hsave area so that it will not
get lost.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 80f5309..84c2c78 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -767,6 +767,8 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		rdtscll(tsc_this);
 		delta = vcpu->arch.host_tsc - tsc_this;
 		svm->vmcb->control.tsc_offset += delta;
+		if (is_nested(svm))
+			svm->nested.hsave->control.tsc_offset += delta;
 		vcpu->cpu = cpu;
 		kvm_migrate_timers(vcpu);
 		svm->asid_generation = 0;
-- 
1.6.3.3


