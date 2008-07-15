Return-Path: <linux-kernel-owner+w=401wt.eu-S1758228AbYGOVOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228AbYGOVOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755254AbYGOVOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:14:31 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38239 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755091AbYGOVOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:14:30 -0400
Message-Id: <20080715211429.769867000@polaris-admin.engr.sgi.com>
References: <20080715211429.454823000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jul 2008 14:14:31 -0700
From: Mike Travis <travis@sgi.com>
To: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 2/8] cpumask: Optimize cpumask_of_cpu in arch/x86/kernel/io_apic_64.c
Content-Disposition: inline; filename=optimize-cpu_mask_of_cpu-in-arch_x86_kernel_io_apic_64_c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Optimize various places where a pointer to the cpumask_of_cpu value
    will result in reducing stack pressure.

Based on linux-2.6.tip/master at the following commit:

    commit 0a91813e16ebd5c2d9b5c2acd5b7c91742112c4f
    Merge: 9a635fa... 724dce0...
    Author: Ingo Molnar <mingo@elte.hu>
    Date:   Tue Jul 15 14:55:17 2008 +0200


Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86/kernel/io_apic_64.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- linux-2.6.tip.orig/arch/x86/kernel/io_apic_64.c
+++ linux-2.6.tip/arch/x86/kernel/io_apic_64.c
@@ -1372,12 +1372,10 @@ static unsigned int startup_ioapic_irq(u
 static int ioapic_retrigger_irq(unsigned int irq)
 {
 	struct irq_cfg *cfg = &irq_cfg[irq];
-	cpumask_t mask;
 	unsigned long flags;
 
 	spin_lock_irqsave(&vector_lock, flags);
-	mask = cpumask_of_cpu(first_cpu(cfg->domain));
-	send_IPI_mask(mask, cfg->vector);
+	send_IPI_mask(cpumask_of_cpu(first_cpu(cfg->domain)), cfg->vector);
 	spin_unlock_irqrestore(&vector_lock, flags);
 
 	return 1;

-- 
