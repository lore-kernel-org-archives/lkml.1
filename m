Return-Path: <linux-kernel-owner+w=401wt.eu-S1756276Ab0AFUZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab0AFUZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 15:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932554Ab0AFUZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 15:25:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:53670 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932518Ab0AFUZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 15:25:44 -0500
Date: Wed, 6 Jan 2010 20:24:39 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       garyhade@us.ibm.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       ebiederm@xmission.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       garyhade@us.ibm.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       ebiederm@xmission.com
In-Reply-To: <1262804191.2732.7.camel@sbs-t61.sc.intel.com>
References: <1262804191.2732.7.camel@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, irq: Check move_in_progress before freeing the vector mapping
Message-ID: <tip-7f41c2e1523f628cc248e34192162aec5728bed7@git.kernel.org>
Git-Commit-ID: 7f41c2e1523f628cc248e34192162aec5728bed7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7f41c2e1523f628cc248e34192162aec5728bed7
Gitweb:     http://git.kernel.org/tip/7f41c2e1523f628cc248e34192162aec5728bed7
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Wed, 6 Jan 2010 10:56:31 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 6 Jan 2010 12:08:43 -0800

x86, irq: Check move_in_progress before freeing the vector mapping

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
LKML-Reference: <1262804191.2732.7.camel@sbs-t61.sc.intel.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/apic/io_apic.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

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
 
