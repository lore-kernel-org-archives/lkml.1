Return-Path: <linux-kernel-owner+w=401wt.eu-S1756630AbYHSTST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbYHSTST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbYHSTSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:18:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535AbYHSTSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:18:03 -0400
Date: Tue, 19 Aug 2008 16:16:07 -0300
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@qumranet.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] KVM_GUEST: use the right parameter type on
	kvm_release_pt() (was Re: i386 allmodconfig in linux-next)
Message-ID: <20080819191607.GQ6342@blackpad>
References: <20080819024549.5f2c43cf.akpm@linux-foundation.org> <48AACD95.8050207@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AACD95.8050207@qumranet.com>
X-Fnord: you can see the fnord
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 04:41:41PM +0300, Avi Kivity wrote:
> Andrew Morton wrote:
>> arch/x86/kernel/kvm.c: In function 'paravirt_ops_setup':
>> arch/x86/kernel/kvm.c:233: warning: assignment from incompatible pointer type
>> arch/x86/kernel/kvm.c:234: warning: assignment from incompatible pointer type
>> arch/x86/kernel/kvm.c:235: warning: assignment from incompatible pointer type
>>   
>
> Eduardo, this is your
>
>> commit fa24f8e67c189b8b904c8a34f12e6dae9c14dbba
>> Author: Eduardo Habkost <ehabkost@redhat.com>
>> Date:   Wed Jul 30 18:32:27 2008 -0300
>>
>>     x86, paravirt_ops: use unsigned long instead of u32 for alloc_p*()  
>> pfn args
>
> Please compile-test (and run-test?) paravirt_ops changes with  
> CONFIG_KVM_GUEST and CONFIG_KVM_CLOCK enabled.  Thanks.
>

Oops, sorry. I've grepped for 'alloc_p*' and didn't notice KVM was using
release_p*. I've checked for binary code changes with all paravirt guest
options enabled, but missed the compiler warnings. Fix below.

---
From: Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH] KVM_GUEST: Use the right parameter type on kvm_release_pt()

This fixes the following compiler warnings, that were introduced by me
on commit fa24f8e67c189b8b904c8a34f12e6dae9c14dbba.

arch/x86/kernel/kvm.c: In function 'paravirt_ops_setup':
arch/x86/kernel/kvm.c:233: warning: assignment from incompatible pointer type
arch/x86/kernel/kvm.c:234: warning: assignment from incompatible pointer type
arch/x86/kernel/kvm.c:235: warning: assignment from incompatible pointer type

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/kernel/kvm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 8b7a3cf..478bca9 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -178,7 +178,7 @@ static void kvm_flush_tlb(void)
 	kvm_deferred_mmu_op(&ftlb, sizeof ftlb);
 }
 
-static void kvm_release_pt(u32 pfn)
+static void kvm_release_pt(unsigned long pfn)
 {
 	struct kvm_mmu_op_release_pt rpt = {
 		.header.op = KVM_MMU_OP_RELEASE_PT,
-- 
1.5.5.GIT

-- 
Eduardo
