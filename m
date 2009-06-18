Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbZFREZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbZFREZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 00:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750861AbZFREZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 00:25:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:33010 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbZFREZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 00:25:15 -0400
Subject: Re: linux-next: kvm tree build failure
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Avi Kivity <avi@qumranet.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Alexander Graf <agraf@suse.de>
In-Reply-To: <20090618111120.9c226ab7.sfr@canb.auug.org.au>
References: <20090618111120.9c226ab7.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 09:55:57 +0530
Message-Id: <1245299157.2871.1.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stephen,

On Thu, 2009-06-18 at 11:11 +1000, Stephen Rothwell wrote:
> Hi Avi,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> arch/x86/kvm/svm.c: In function 'svm_set_msr':
> arch/x86/kvm/svm.c:2152: error: 'MSR_K8_HWCR' undeclared (first use in this function)
> 
> Caused by commit 6878bf85dfc107cea4660f1167693c15754c1660 ("KVM:
> Implement MSRs used by Hyper-V").  MSR_K8_HWCR was removed by commit
> bf8b9a63c18a1a7777571650de0c9f4fd4368ca0 ("x86: msr-index.h remove
> duplicate MSR C001_0015 declaration") which is now in Linus' tree (it
> entered Linus' tree on Jun 10 via commit
> 7dc3ca39cb1e22eedbf1207ff9ac7bf682fc0f6d "Merge branch
> 'x86-cleanups-for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip").
> 
> I have used the version of the kvm tree from 20090617.

Can you try this patch :

[PATCH] KVM: use MSR_K7_HWCR for MSRC001_0015 Hardware Configuration Register (HWCR)

MSR_K8_MSR is removed as it is duplicating MSRC001_0015 Hardware
Configuration Register (HWCR), which is already defined as MSR_K7_HWCR

Fix x86_64 allmodconfig :

arch/x86/kvm/svm.c: In function 'svm_set_msr':
arch/x86/kvm/svm.c:2152: error: 'MSR_K8_HWCR' undeclared (first use in this function)

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kvm/svm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index c283201..481010c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2149,7 +2149,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 		break;
 	case MSR_VM_CR:
 	case MSR_VM_IGNNE:
-	case MSR_K8_HWCR:
+	case MSR_K7_HWCR:
 		pr_unimpl(vcpu, "unimplemented wrmsr: 0x%x data 0x%llx\n", ecx, data);
 		break;
 	default:
-- 
1.6.0.6



