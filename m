Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbZAaWvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbZAaWvX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 17:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbZAaWvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 17:51:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:58994 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbZAaWvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 17:51:14 -0500
Message-ID: <4984D59F.4030700@kernel.org>
Date: Sat, 31 Jan 2009 14:50:07 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com
Subject: Re: irq_desc_lock_class is held when it is freed
References: <1233437601.11984.41.camel@localhost.localdomain>
In-Reply-To: <1233437601.11984.41.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote:
> I have an hp dl785g5 which is unable to successfully run
> 2.6.29-0.66.rc3.fc11.x86_64 or 2.6.29-rc2-next-20090126.  During bootup
> (early in userspace daemons starting) I get the below BUG, which quickly
> renders the machine dead.  I assume it is because sparse_irq_lock never
> gets released when the BUG kills that task.  But maybe it dies for some
> other reason, but the machine is dead, gotta hit the vitual power
> button.
> 
> setting CONFIG_NUMA_MIGRATE_IRQ_DESC=n allowed me to successfully boot
> the linux-next kernel.  2.6.28 booted and worked fine (although it
> doesn't have this config option, so that isn't surprising.)
> 
> attached you will find the linux-next config and dmesg output from the
> machine in question when booted using linux-next WITHOUT the
> MIGRATE_IRQ_DESC.  The only difference between the working and broken
> config is if CONFIG_NUMA_MIGRATE_IRQ_DESC is set or not.
> 
> Please if there is anything I can collect, test, or do, don't hesitate
> to let me know.
> 
it seems there is some merge problem... also there could be another problem...

please check

diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 6c02c25..610ce0a 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -2511,14 +2511,15 @@ static void irq_complete_move(struct irq_desc **descp)
 
 	vector = ~get_irq_regs()->orig_ax;
 	me = smp_processor_id();
+
+	if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain)) {
 #ifdef CONFIG_NUMA_MIGRATE_IRQ_DESC
 		*descp = desc = move_irq_desc(desc, me);
 		/* get the new one */
 		cfg = desc->chip_data;
 #endif
-
-	if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain))
 		send_cleanup_vector(cfg);
+	}
 }
 #else
 static inline void irq_complete_move(struct irq_desc **descp) {}
