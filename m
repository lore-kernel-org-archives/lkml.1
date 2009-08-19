Return-Path: <linux-kernel-owner+w=401wt.eu-S1752671AbZHSNLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbZHSNLn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZHSNJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:09:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50568 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751965AbZHSNCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:48 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 18/47] KVM: VMX: Only reload guest cr2 if different from host cr2
Date: Wed, 19 Aug 2009 16:02:14 +0300
Message-Id: <1250686963-8357-19-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cr2 changes only rarely, and writing it is expensive.  Avoid the costly cr2
writes by checking if it does not already hold the desired value.

Shaves 70 cycles off the vmexit latency.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index fc8d49c..1a84ca1 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3651,11 +3651,16 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		"mov %%"R"sp, %c[host_rsp](%0) \n\t"
 		__ex(ASM_VMX_VMWRITE_RSP_RDX) "\n\t"
 		"1: \n\t"
+		/* Reload cr2 if changed */
+		"mov %c[cr2](%0), %%"R"ax \n\t"
+		"mov %%cr2, %%"R"dx \n\t"
+		"cmp %%"R"ax, %%"R"dx \n\t"
+		"je 2f \n\t"
+		"mov %%"R"ax, %%cr2 \n\t"
+		"2: \n\t"
 		/* Check if vmlaunch of vmresume is needed */
 		"cmpl $0, %c[launched](%0) \n\t"
 		/* Load guest registers.  Don't clobber flags. */
-		"mov %c[cr2](%0), %%"R"ax \n\t"
-		"mov %%"R"ax, %%cr2 \n\t"
 		"mov %c[rax](%0), %%"R"ax \n\t"
 		"mov %c[rbx](%0), %%"R"bx \n\t"
 		"mov %c[rdx](%0), %%"R"dx \n\t"
-- 
1.6.3.3

