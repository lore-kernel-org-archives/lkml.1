Return-Path: <linux-kernel-owner+w=401wt.eu-S1758333AbZBYPQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333AbZBYPQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 10:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756824AbZBYPJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 10:09:15 -0500
Received: from wa4ehsobe003.messaging.microsoft.com ([216.32.181.13]:16520
	"EHLO WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756974AbZBYPIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 10:08:43 -0500
X-BigFish: VPS1(zzzzzzz32i65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KFMNE6-04-9OH-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Gerd Hoffmann <kraxel@redhat.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] kvm x86: release time_page on vcpu destruction
Date: Wed, 25 Feb 2009 16:08:31 +0100
Message-ID: <1235574511-4571-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
X-OriginalArrivalTime: 25 Feb 2009 15:08:31.0823 (UTC) FILETIME=[EBF395F0:01C9975A]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not releasing the time_page causes a leak of that page or the compound
page it is situated in.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/x86.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8ca100a..a1ecec5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4159,6 +4159,11 @@ EXPORT_SYMBOL_GPL(kvm_put_guest_fpu);
 
 void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 {
+	if (vcpu->arch.time_page) {
+		kvm_release_page_dirty(vcpu->arch.time_page);
+		vcpu->arch.time_page = NULL;
+	}
+
 	kvm_x86_ops->vcpu_free(vcpu);
 }
 
-- 
1.5.6.4


