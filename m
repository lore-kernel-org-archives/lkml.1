Return-Path: <linux-kernel-owner+w=401wt.eu-S1763052AbZCXUYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763052AbZCXUYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 16:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757958AbZCXUYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 16:24:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:44383 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756916AbZCXUYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 16:24:05 -0400
Message-ID: <49C94134.4000408@kernel.org>
Date: Tue, 24 Mar 2009 13:23:16 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: x86@kernel.org, Ingo Molnar <mingo@elte.hu>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: fix set_extra_move_desc calling
References: <200903241619.03517.rusty@rustcorp.com.au> <m1k56frt6e.fsf@fess.ebiederm.org>
In-Reply-To: <m1k56frt6e.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix bug with desc moving when logical flat

Eric pointed out that we should compare with old affinity.
acctually this bug is introduced by:
| commit 22f65d31b25a320a5246592160bcb102d2791c45
|
| Author: Mike Travis <travis@sgi.com>
| Date:   Tue Dec 16 17:33:56 2008 -0800
|
|    x86: Update io_apic.c to use new cpumask API
|
|    Impact: cleanup, consolidate patches, use new API

so need to move that before...

---
 arch/x86/kernel/apic/io_apic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -592,8 +592,9 @@ set_desc_affinity(struct irq_desc *desc,
 	if (assign_irq_vector(irq, cfg, mask))
 		return BAD_APICID;
 
-	cpumask_and(desc->affinity, cfg->domain, mask);
+	/* check that before desc->addinity get updated */
 	set_extra_move_desc(desc, mask);
+	cpumask_and(desc->affinity, cfg->domain, mask);
 
 	return apic->cpu_mask_to_apicid_and(desc->affinity, cpu_online_mask);
 }
