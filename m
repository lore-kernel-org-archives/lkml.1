Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbXEaNd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbXEaNd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 09:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbXEaNdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 09:33:50 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50221 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbXEaNdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 09:33:49 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>, Zwane Mwaikambo <zwane@linuxpower.ca>
Subject: [PATCH] x86: Document the hotplug code is incompatible with x86 irq handling
Date: Thu, 31 May 2007 07:32:05 -0600
Message-ID: <m1tztt3yqy.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I just realized that except for doing the code review and noticing
that the current cpu hotplug code is fundamentally incompatible
with x86 I haven't done anything about it.  So here is my patch
to document what is wrong.

The current cpu hotplug code requires irqs to be migrated from a cpu
outside of irq context.  On x86 ioapics simply do not support this,
making the code unfixable without major redesign of the generic cpu
hotplug code.

So this patch makes CPU_HOTPLUG on x86 depend on CONFIG_BROKEN
and adds a WARN_ON so people that do enable it are not in doubt about
which part of the code is broken, even if it does work for them.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/i386/Kconfig        |    2 +-
 arch/i386/kernel/irq.c   |   13 +++++++++++++
 arch/x86_64/Kconfig      |    2 +-
 arch/x86_64/kernel/irq.c |   13 +++++++++++++
 4 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
index 8770a5d..74444c1 100644
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -892,7 +892,7 @@ config PHYSICAL_ALIGN
 
 config HOTPLUG_CPU
 	bool "Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL)"
-	depends on SMP && HOTPLUG && EXPERIMENTAL && !X86_VOYAGER
+	depends on SMP && HOTPLUG && EXPERIMENTAL && !X86_VOYAGER && BROKEN
 	---help---
 	  Say Y here to experiment with turning CPUs off and on, and to
 	  enable suspend on SMP systems. CPUs can be controlled through
diff --git a/arch/i386/kernel/irq.c b/arch/i386/kernel/irq.c
index d2daf67..42aeccb 100644
--- a/arch/i386/kernel/irq.c
+++ b/arch/i386/kernel/irq.c
@@ -312,6 +312,19 @@ void fixup_irqs(cpumask_t map)
 	unsigned int irq;
 	static int warned;
 
+	/* 
+	 * Function is so wrong at so many levels.
+	 * - We migrate irqs that are directed at the cpu we are
+	 *   removing.
+	 * - We cannot safely migrate ioapic irqs on x86 except in
+	 *   side of irq context.
+	 * - We are enabling irqs when the interface requires irqs to
+	 *   be disabled.
+	 * Since someone probably finds this useful just warn very
+	 * loudly until cpu hotplug is redesigned.
+	 */
+	WARN_ON(1);
+
 	for (irq = 0; irq < NR_IRQS; irq++) {
 		cpumask_t mask;
 		if (irq == 2)
diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
index 5ce9443..a61c4f2 100644
--- a/arch/x86_64/Kconfig
+++ b/arch/x86_64/Kconfig
@@ -429,7 +429,7 @@ config NR_CPUS
 
 config HOTPLUG_CPU
 	bool "Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL)"
-	depends on SMP && HOTPLUG && EXPERIMENTAL
+	depends on SMP && HOTPLUG && EXPERIMENTAL && BROKEN
 	help
 		Say Y here to experiment with turning CPUs off and on.  CPUs
 		can be controlled through /sys/devices/system/cpu/cpu#.
diff --git a/arch/x86_64/kernel/irq.c b/arch/x86_64/kernel/irq.c
index 3eaceac..da6f282 100644
--- a/arch/x86_64/kernel/irq.c
+++ b/arch/x86_64/kernel/irq.c
@@ -142,6 +142,19 @@ void fixup_irqs(cpumask_t map)
 	unsigned int irq;
 	static int warned;
 
+	/* 
+	 * Function is so wrong at so many levels.
+	 * - We migrate irqs that are directed at the cpu we are
+	 *   removing.
+	 * - We cannot safely migrate ioapic irqs on x86 except in
+	 *   side of irq context.
+	 * - We are enabling irqs when the interface requires irqs to
+	 *   be disabled.
+	 * Since someone probably finds this useful just warn very
+	 * loudly until cpu hotplug is redesigned.
+	 */
+	WARN_ON(1);
+
 	for (irq = 0; irq < NR_IRQS; irq++) {
 		cpumask_t mask;
 		if (irq == 2)
-- 
1.5.1.1.181.g2de0

