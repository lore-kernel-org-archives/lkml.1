Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbZGUPuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbZGUPuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 11:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbZGUPuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 11:50:05 -0400
Received: from main.gmane.org ([80.91.229.2]:59658 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398AbZGUPuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 11:50:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Reinhard Tartler <siretart@tauware.de>
Subject: is scripts/checkkconfigsymbols.sh actually used?
Date: Tue, 21 Jul 2009 17:45:21 +0200
Message-ID: <87eisaujji.fsf@faui44a.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
Cc: linux-kbuild@vger.kernel.org
X-Gmane-NNTP-Posting-Host: faui44a.informatik.uni-erlangen.de
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.94 (gnu/linux)
Cancel-Lock: sha1:uP6y81yuMgP7Dyf2Rd+u4vyOAN8=
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(CC'ing Paolo Giarrusso, the author of scripts/checkkconfigsymbols.sh)

I'm currently looking at the output of scripts/checkkconfigsymbols.sh to
find out that on 2.6.30, it reports about 760 unreferenced symbols
used. I have the impression that the variability implemented in the Linux
source base is diverging heavily from the variability described in Linux
Kconfig.

Just with looking over the list, I think I've identified 2 obvious typos
where the configuration option was misspelled:

The first one is CONFIG_CPUMASK_OFFSTACK:

diff --git a/include/linux/irq.h b/include/linux/irq.h
index b7cbeed..6983591 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -471,14 +471,14 @@ static inline bool init_alloc_desc_masks(struct irq_desc *desc, int cpu,
  * @new_desc:	pointer to new irq_desc struct
  *
  * Insures affinity and pending_masks are copied to new irq_desc.
- * If !CONFIG_CPUMASKS_OFFSTACK the cpumasks are embedded in the
+ * If !CONFIG_CPUMASK_OFFSTACK the cpumasks are embedded in the
  * irq_desc struct so the copy is redundant.
  */
 
 static inline void init_copy_desc_masks(struct irq_desc *old_desc,
 					struct irq_desc *new_desc)
 {
-#ifdef CONFIG_CPUMASKS_OFFSTACK
+#ifdef CONFIG_CPUMASK_OFFSTACK
 	cpumask_copy(new_desc->affinity, old_desc->affinity);
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ


The next one is CONFIG_CPU_HOTPLUG:

diff --git a/kernel/smp.c b/kernel/smp.c
index ad63d85..94188b8 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -57,7 +57,7 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
 			return NOTIFY_BAD;
 		break;
 
-#ifdef CONFIG_CPU_HOTPLUG
+#ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
 
I'm sure that there are quite some false positives in that list, e.g. it
seems that it does not ignore comments, or that it assumes that all
CONFIG_ definitions come from kconfig (this is not true,
e.g. include/linux/memory.h defines CONFIG_MEM_BLOCK_SIZE, but there are
also other kconfig configuration overrides in some drivers). Still, the
list is still impressively long. Now I wonder if there are other, more
obvious problems with scripts/checkkconfigsymbols.sh. Or is the problem
just that this tool is underadvertised and not well-known?

-- 
Gruesse/greetings,
Reinhard Tartler, KeyID 945348A4

