Return-Path: <linux-kernel-owner+w=401wt.eu-S932631Ab0AFS5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631Ab0AFS5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 13:57:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932416Ab0AFS5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 13:57:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:31671 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932243Ab0AFS5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 13:57:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,230,1262592000"; 
   d="scan'208";a="761899559"
Subject: [patch] x86, irq: check move_in_progress before freeing the vector
 mapping
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Gary Hade <garyhade@us.ibm.com>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 06 Jan 2010 10:56:31 -0800
Message-Id: <1262804191.2732.7.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 folks, please queue this fix for 2.6.33.

thanks,
suresh
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch] x86, irq: check move_in_progress before freeing the vector mapping

With the recent irq migration fixes (post 2.6.32), Gary Hade has noticed
"No IRQ handler for vector" messages during the 2.6.33-rc1 kernel boot on IBM
AMD platforms and root caused the issue to this commit:

> commit 23359a88e7eca3c4f402562b102f23014db3c2aa
> Author: Suresh Siddha <suresh.b.siddha@intel.com>
> Date:   Mon Oct 26 14:24:33 2009 -0800
>
>    x86: Remove move_cleanup_count from irq_cfg

As part of this patch, we have removed the move_cleanup_count check
in smp_irq_move_cleanup_interrupt(). With this change, we can run into a
situation where an irq cleanup interrupt on a cpu can cleanup the vector
mappings associated with multiple irqs, of which one of the irq's migration
might be still in progress. As such when that irq hits the old cpu, we get
the "No IRQ handler" messages.

Fix this by checking for the irq_cfg's move_in_progress and if the move
is still in progress delay the vector cleanup to another irq cleanup
interrupt request (which will happen when the irq starts arriving at the
new cpu destination).

Reported-and-tested-by: Gary Hade <garyhade@us.ibm.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index de00c46..53243ca 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2434,6 +2434,13 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 		cfg = irq_cfg(irq);
 		raw_spin_lock(&desc->lock);
 
+		/*
+		 * Check if the irq migration is in progress. If so, we
+		 * haven't received the cleanup request yet for this irq.
+		 */
+		if (cfg->move_in_progress)
+			goto unlock;
+
 		if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain))
 			goto unlock;
 


