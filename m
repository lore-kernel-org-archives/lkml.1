Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbZKBQRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbZKBQRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:17:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755797AbZKBQRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:17:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:53638 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755845AbZKBQRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:17:35 -0500
Date: Mon, 2 Nov 2009 16:16:56 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu,
       ebiederm@xmission.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de, ebiederm@xmission.com,
       mingo@elte.hu
In-Reply-To: <20091026230001.661423939@sbs-t61.sc.intel.com>
References: <20091026230001.661423939@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, intr-remap: Avoid irq_chip mask/unmask in fixup_irqs() for intr-remapping
Message-ID: <tip-84e21493a3b28c9fefe99fe827fc0c0c101a813d@git.kernel.org>
Git-Commit-ID: 84e21493a3b28c9fefe99fe827fc0c0c101a813d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  84e21493a3b28c9fefe99fe827fc0c0c101a813d
Gitweb:     http://git.kernel.org/tip/84e21493a3b28c9fefe99fe827fc0c0c101a813d
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 26 Oct 2009 14:24:32 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 2 Nov 2009 15:56:35 +0100

x86, intr-remap: Avoid irq_chip mask/unmask in fixup_irqs() for intr-remapping

In the presence of interrupt-remapping, irqs will be migrated in
the process context and we don't do (and there is no need to)
irq_chip mask/unmask while migrating the interrupt.

Similarly fix the fixup_irqs() that get called during cpu
offline and avoid calling irq_chip mask/unmask for irqs that are
ok to be migrated in the process context.

While we didn't observe any race condition with the existing
code, this change takes complete advantage of
interrupt-remapping in the newer generation platforms and avoids
any potential HW lockup's (that often worry Eric :)

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: garyhade@us.ibm.com
LKML-Reference: <20091026230001.661423939@sbs-t61.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/irq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 3ea6655..342bcbc 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -310,7 +310,7 @@ void fixup_irqs(void)
 			affinity = cpu_all_mask;
 		}
 
-		if (desc->chip->mask)
+		if (!(desc->status & IRQ_MOVE_PCNTXT) && desc->chip->mask)
 			desc->chip->mask(irq);
 
 		if (desc->chip->set_affinity)
@@ -318,7 +318,7 @@ void fixup_irqs(void)
 		else if (!(warned++))
 			set_affinity = 0;
 
-		if (desc->chip->unmask)
+		if (!(desc->status & IRQ_MOVE_PCNTXT) && desc->chip->unmask)
 			desc->chip->unmask(irq);
 
 		spin_unlock(&desc->lock);
