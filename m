Return-Path: <linux-kernel-owner+w=401wt.eu-S932185AbXBWLr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbXBWLr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 06:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932197AbXBWLr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 06:47:27 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39785 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185AbXBWLr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 06:47:26 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Zwane Mwaikambo <zwane@infradead.org>,
       Ashok Raj <ashok.raj@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "Lu, Yinghai" <yinghai.lu@amd.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 14/14] genirq: Mask irqs when migrating them.
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<Pine.LNX.4.64.0702102146380.8245@montezuma.fsmlabs.com>
	<m13b5d0zdp.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702110753390.8245@montezuma.fsmlabs.com>
	<m17iuoz74f.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702111416220.24829@montezuma.fsmlabs.com>
	<m1r6swx9l2.fsf@ebiederm.dsl.xmission.com>
	<m1irdtw3jb.fsf_-_@ebiederm.dsl.xmission.com>
	<m1bqjlw2mr.fsf_-_@ebiederm.dsl.xmission.com>
	<m17iu9w2kj.fsf_-_@ebiederm.dsl.xmission.com>
	<m13b4xw2h8.fsf_-_@ebiederm.dsl.xmission.com>
	<m1y7mpunuk.fsf_-_@ebiederm.dsl.xmission.com>
	<m1tzxdunsg.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ps81uno3.fsf_-_@ebiederm.dsl.xmission.com>
	<m1lkipunl0.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ejohung7.fsf_-_@ebiederm.dsl.xmission.com>
	<m17iu9unb6.fsf_-_@ebiederm.dsl.xmission.com>
	<m13b4xun1c.fsf_-_@ebiederm.dsl.xmission.com>
	<m1y7mpt8d2.fsf_-_@ebiederm.dsl.xmission.com>
	<m1tzxdt8au.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ps81t87h.fsf_-_@ebiederm.dsl.xmission.com>
Date: Fri, 23 Feb 2007 04:46:20 -0700
In-Reply-To: <m1ps81t87h.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Fri, 23 Feb 2007 04:38:26 -0700")
Message-ID: <m1hctdt7ub.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


move_native_irqs tries to do the right thing when migrating irqs
by disabling them.  However disabling them is a software logical
thing, not a hardware thing.  This has always been a little flaky
and after Ingo's latest round of changes it is guaranteed to not
mask the apic.

So this patch fixes move_native_irq to directly call the mask and
unmask chip methods to guarantee that we mask the irq when we
are migrating it.  We must do this as it is required by
all code that call into the path.

Since we don't know the masked status when IRQ_DISABLED is
set so we will not be able to restore it.   The patch makes the code
just give up and trying again the next time this routing is called.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/irq/migration.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
index 4baa3bb..77b7acc 100644
--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -65,12 +65,11 @@ void move_native_irq(int irq)
 	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
 		return;
 
-	if (likely(!(desc->status & IRQ_DISABLED)))
-		desc->chip->disable(irq);
+	if (unlikely(desc->status & IRQ_DISABLED))
+		return;
 
+	desc->chip->mask(irq);
 	move_masked_irq(irq);
-
-	if (likely(!(desc->status & IRQ_DISABLED)))
-		desc->chip->enable(irq);
+	desc->chip->unmask(irq);
 }
 
-- 
1.5.0.g53756

