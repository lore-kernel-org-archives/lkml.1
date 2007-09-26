Return-Path: <linux-kernel-owner+w=401wt.eu-S1763300AbXIZWnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763300AbXIZWnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 18:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757925AbXIZWmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 18:42:54 -0400
Received: from mga07.intel.com ([143.182.124.22]:36399 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751938AbXIZWmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 18:42:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,199,1188802800"; 
   d="scan'208";a="287400558"
Date: Wed, 26 Sep 2007 15:42:30 -0700
From: Mark Gross <mgross@linux.intel.com>
To: linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] QoS power Management enabling patch set
Message-ID: <20070926224230.GB23218@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20070926223712.GA22029@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926223712.GA22029@linux.intel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch replaces latency.c with qos_params.c and fixes up
users of latency to use qos_params


Signed-off-by: Mark Gross <mgross@linux.intel.com>

diff -urN -X linux-2.6.23-rc8/Documentation/dontdiff linux-2.6.23-rc8-qos/drivers/acpi/processor_idle.c linux-2.6.23-rc8-qos-nolatency.c/drivers/acpi/processor_idle.c
--- linux-2.6.23-rc8-qos/drivers/acpi/processor_idle.c	2007-09-26 13:54:28.000000000 -0700
+++ linux-2.6.23-rc8-qos-nolatency.c/drivers/acpi/processor_idle.c	2007-09-26 14:09:27.000000000 -0700
@@ -38,7 +38,7 @@
 #include <linux/dmi.h>
 #include <linux/moduleparam.h>
 #include <linux/sched.h>	/* need_resched() */
-#include <linux/latency.h>
+#include <linux/qos_params.h>
 #include <linux/clockchips.h>
 
 /*
@@ -605,7 +605,7 @@
 	if (cx->promotion.state &&
 	    ((cx->promotion.state - pr->power.states) <= max_cstate)) {
 		if (sleep_ticks > cx->promotion.threshold.ticks &&
-		  cx->promotion.state->latency <= system_latency_constraint()) {
+		  cx->promotion.state->latency <= qos_requirement(QOS_CPU_DMA_LATENCY)) {
 			cx->promotion.count++;
 			cx->demotion.count = 0;
 			if (cx->promotion.count >=
@@ -649,7 +649,7 @@
 	 * or if the latency of the current state is unacceptable
 	 */
 	if ((pr->power.state - pr->power.states) > max_cstate ||
-		pr->power.state->latency > system_latency_constraint()) {
+		pr->power.state->latency > qos_requirement(QOS_CPU_DMA_LATENCY)) {
 		if (cx->demotion.state)
 			next_state = cx->demotion.state;
 	}
@@ -1173,7 +1173,7 @@
 		   "maximum allowed latency: %d usec\n",
 		   pr->power.state ? pr->power.state - pr->power.states : 0,
 		   max_cstate, (unsigned)pr->power.bm_activity,
-		   system_latency_constraint());
+		   qos_requirement(QOS_CPU_DMA_LATENCY));
 
 	seq_puts(seq, "states:\n");
 
@@ -1280,7 +1280,7 @@
 			       max_cstate);
 		first_run++;
 #ifdef CONFIG_SMP
-		register_latency_notifier(&acpi_processor_latency_notifier);
+		qos_add_notifier(QOS_CPU_DMA_LATENCY, &acpi_processor_latency_notifier);
 #endif
 	}
 
@@ -1354,7 +1354,7 @@
 		 */
 		cpu_idle_wait();
 #ifdef CONFIG_SMP
-		unregister_latency_notifier(&acpi_processor_latency_notifier);
+		qos_remove_notifier(QOS_CPU_DMA_LATENCY, &acpi_processor_latency_notifier);
 #endif
 	}
 
diff -urN -X linux-2.6.23-rc8/Documentation/dontdiff linux-2.6.23-rc8-qos/drivers/net/wireless/ipw2100.c linux-2.6.23-rc8-qos-nolatency.c/drivers/net/wireless/ipw2100.c
--- linux-2.6.23-rc8-qos/drivers/net/wireless/ipw2100.c	2007-09-26 13:54:34.000000000 -0700
+++ linux-2.6.23-rc8-qos-nolatency.c/drivers/net/wireless/ipw2100.c	2007-09-26 14:09:27.000000000 -0700
@@ -162,7 +162,7 @@
 #include <linux/firmware.h>
 #include <linux/acpi.h>
 #include <linux/ctype.h>
-#include <linux/latency.h>
+#include <linux/qos_params.h>
 
 #include "ipw2100.h"
 
@@ -1701,7 +1701,7 @@
 	/* the ipw2100 hardware really doesn't want power management delays
 	 * longer than 175usec
 	 */
-	modify_acceptable_latency("ipw2100", 175);
+	qos_update_requirement(QOS_CPU_DMA_LATENCY, "ipw2100", 175);
 
 	/* If the interrupt is enabled, turn it off... */
 	spin_lock_irqsave(&priv->low_lock, flags);
@@ -1856,7 +1856,7 @@
 	ipw2100_disable_interrupts(priv);
 	spin_unlock_irqrestore(&priv->low_lock, flags);
 
-	modify_acceptable_latency("ipw2100", INFINITE_LATENCY);
+	qos_update_requirement(QOS_CPU_DMA_LATENCY, "ipw2100", QOS_DEFAULT_VALUE);
 
 #ifdef ACPI_CSTATE_LIMIT_DEFINED
 	if (priv->config & CFG_C3_DISABLED) {
@@ -6544,7 +6544,7 @@
 	if (ret)
 		goto out;
 
-	set_acceptable_latency("ipw2100", INFINITE_LATENCY);
+	qos_add_requirement(QOS_CPU_DMA_LATENCY, "ipw2100", QOS_DEFAULT_VALUE);
 #ifdef CONFIG_IPW2100_DEBUG
 	ipw2100_debug_level = debug;
 	ret = driver_create_file(&ipw2100_pci_driver.driver,
@@ -6566,7 +6566,7 @@
 			   &driver_attr_debug_level);
 #endif
 	pci_unregister_driver(&ipw2100_pci_driver);
-	remove_acceptable_latency("ipw2100");
+	qos_remove_requirement(QOS_CPU_DMA_LATENCY, "ipw2100");
 }
 
 module_init(ipw2100_init);
diff -urN -X linux-2.6.23-rc8/Documentation/dontdiff linux-2.6.23-rc8-qos/include/linux/latency.h linux-2.6.23-rc8-qos-nolatency.c/include/linux/latency.h
--- linux-2.6.23-rc8-qos/include/linux/latency.h	2007-07-08 16:32:17.000000000 -0700
+++ linux-2.6.23-rc8-qos-nolatency.c/include/linux/latency.h	1969-12-31 16:00:00.000000000 -0800
@@ -1,25 +0,0 @@
-/*
- * latency.h: Explicit system-wide latency-expectation infrastructure
- *
- * (C) Copyright 2006 Intel Corporation
- * Author: Arjan van de Ven <arjan@linux.intel.com>
- *
- */
-
-#ifndef _INCLUDE_GUARD_LATENCY_H_
-#define _INCLUDE_GUARD_LATENCY_H_
-
-#include <linux/notifier.h>
-
-void set_acceptable_latency(char *identifier, int usecs);
-void modify_acceptable_latency(char *identifier, int usecs);
-void remove_acceptable_latency(char *identifier);
-void synchronize_acceptable_latency(void);
-int system_latency_constraint(void);
-
-int register_latency_notifier(struct notifier_block * nb);
-int unregister_latency_notifier(struct notifier_block * nb);
-
-#define INFINITE_LATENCY 1000000
-
-#endif
diff -urN -X linux-2.6.23-rc8/Documentation/dontdiff linux-2.6.23-rc8-qos/kernel/latency.c linux-2.6.23-rc8-qos-nolatency.c/kernel/latency.c
--- linux-2.6.23-rc8-qos/kernel/latency.c	2007-07-08 16:32:17.000000000 -0700
+++ linux-2.6.23-rc8-qos-nolatency.c/kernel/latency.c	1969-12-31 16:00:00.000000000 -0800
@@ -1,280 +0,0 @@
-/*
- * latency.c: Explicit system-wide latency-expectation infrastructure
- *
- * The purpose of this infrastructure is to allow device drivers to set
- * latency constraint they have and to collect and summarize these
- * expectations globally. The cummulated result can then be used by
- * power management and similar users to make decisions that have
- * tradoffs with a latency component.
- *
- * An example user of this are the x86 C-states; each higher C state saves
- * more power, but has a higher exit latency. For the idle loop power
- * code to make a good decision which C-state to use, information about
- * acceptable latencies is required.
- *
- * An example announcer of latency is an audio driver that knowns it
- * will get an interrupt when the hardware has 200 usec of samples
- * left in the DMA buffer; in that case the driver can set a latency
- * constraint of, say, 150 usec.
- *
- * Multiple drivers can each announce their maximum accepted latency,
- * to keep these appart, a string based identifier is used.
- *
- *
- * (C) Copyright 2006 Intel Corporation
- * Author: Arjan van de Ven <arjan@linux.intel.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; version 2
- * of the License.
- */
-
-#include <linux/latency.h>
-#include <linux/list.h>
-#include <linux/spinlock.h>
-#include <linux/slab.h>
-#include <linux/module.h>
-#include <linux/notifier.h>
-#include <linux/jiffies.h>
-#include <asm/atomic.h>
-
-struct latency_info {
-	struct list_head list;
-	int usecs;
-	char *identifier;
-};
-
-/*
- * locking rule: all modifications to current_max_latency and
- * latency_list need to be done while holding the latency_lock.
- * latency_lock needs to be taken _irqsave.
- */
-static atomic_t current_max_latency;
-static DEFINE_SPINLOCK(latency_lock);
-
-static LIST_HEAD(latency_list);
-static BLOCKING_NOTIFIER_HEAD(latency_notifier);
-
-/*
- * This function returns the maximum latency allowed, which
- * happens to be the minimum of all maximum latencies on the
- * list.
- */
-static int __find_max_latency(void)
-{
-	int min = INFINITE_LATENCY;
-	struct latency_info *info;
-
-	list_for_each_entry(info, &latency_list, list) {
-		if (info->usecs < min)
-			min = info->usecs;
-	}
-	return min;
-}
-
-/**
- * set_acceptable_latency - sets the maximum latency acceptable
- * @identifier: string that identifies this driver
- * @usecs: maximum acceptable latency for this driver
- *
- * This function informs the kernel that this device(driver)
- * can accept at most usecs latency. This setting is used for
- * power management and similar tradeoffs.
- *
- * This function sleeps and can only be called from process
- * context.
- * Calling this function with an existing identifier is valid
- * and will cause the existing latency setting to be changed.
- */
-void set_acceptable_latency(char *identifier, int usecs)
-{
-	struct latency_info *info, *iter;
-	unsigned long flags;
-	int found_old = 0;
-
-	info = kzalloc(sizeof(struct latency_info), GFP_KERNEL);
-	if (!info)
-		return;
-	info->usecs = usecs;
-	info->identifier = kstrdup(identifier, GFP_KERNEL);
-	if (!info->identifier)
-		goto free_info;
-
-	spin_lock_irqsave(&latency_lock, flags);
-	list_for_each_entry(iter, &latency_list, list) {
-		if (strcmp(iter->identifier, identifier)==0) {
-			found_old = 1;
-			iter->usecs = usecs;
-			break;
-		}
-	}
-	if (!found_old)
-		list_add(&info->list, &latency_list);
-
-	if (usecs < atomic_read(&current_max_latency))
-		atomic_set(&current_max_latency, usecs);
-
-	spin_unlock_irqrestore(&latency_lock, flags);
-
-	blocking_notifier_call_chain(&latency_notifier,
-		atomic_read(&current_max_latency), NULL);
-
-	/*
-	 * if we inserted the new one, we're done; otherwise there was
-	 * an existing one so we need to free the redundant data
-	 */
-	if (!found_old)
-		return;
-
-	kfree(info->identifier);
-free_info:
-	kfree(info);
-}
-EXPORT_SYMBOL_GPL(set_acceptable_latency);
-
-/**
- * modify_acceptable_latency - changes the maximum latency acceptable
- * @identifier: string that identifies this driver
- * @usecs: maximum acceptable latency for this driver
- *
- * This function informs the kernel that this device(driver)
- * can accept at most usecs latency. This setting is used for
- * power management and similar tradeoffs.
- *
- * This function does not sleep and can be called in any context.
- * Trying to use a non-existing identifier silently gets ignored.
- *
- * Due to the atomic nature of this function, the modified latency
- * value will only be used for future decisions; past decisions
- * can still lead to longer latencies in the near future.
- */
-void modify_acceptable_latency(char *identifier, int usecs)
-{
-	struct latency_info *iter;
-	unsigned long flags;
-
-	spin_lock_irqsave(&latency_lock, flags);
-	list_for_each_entry(iter, &latency_list, list) {
-		if (strcmp(iter->identifier, identifier) == 0) {
-			iter->usecs = usecs;
-			break;
-		}
-	}
-	if (usecs < atomic_read(&current_max_latency))
-		atomic_set(&current_max_latency, usecs);
-	spin_unlock_irqrestore(&latency_lock, flags);
-}
-EXPORT_SYMBOL_GPL(modify_acceptable_latency);
-
-/**
- * remove_acceptable_latency - removes the maximum latency acceptable
- * @identifier: string that identifies this driver
- *
- * This function removes a previously set maximum latency setting
- * for the driver and frees up any resources associated with the
- * bookkeeping needed for this.
- *
- * This function does not sleep and can be called in any context.
- * Trying to use a non-existing identifier silently gets ignored.
- */
-void remove_acceptable_latency(char *identifier)
-{
-	unsigned long flags;
-	int newmax = 0;
-	struct latency_info *iter, *temp;
-
-	spin_lock_irqsave(&latency_lock, flags);
-
-	list_for_each_entry_safe(iter,  temp, &latency_list, list) {
-		if (strcmp(iter->identifier, identifier) == 0) {
-			list_del(&iter->list);
-			newmax = iter->usecs;
-			kfree(iter->identifier);
-			kfree(iter);
-			break;
-		}
-	}
-
-	/* If we just deleted the system wide value, we need to
-	 * recalculate with a full search
-	 */
-	if (newmax == atomic_read(&current_max_latency)) {
-		newmax = __find_max_latency();
-		atomic_set(&current_max_latency, newmax);
-	}
-	spin_unlock_irqrestore(&latency_lock, flags);
-}
-EXPORT_SYMBOL_GPL(remove_acceptable_latency);
-
-/**
- * system_latency_constraint - queries the system wide latency maximum
- *
- * This function returns the system wide maximum latency in
- * microseconds.
- *
- * This function does not sleep and can be called in any context.
- */
-int system_latency_constraint(void)
-{
-	return atomic_read(&current_max_latency);
-}
-EXPORT_SYMBOL_GPL(system_latency_constraint);
-
-/**
- * synchronize_acceptable_latency - recalculates all latency decisions
- *
- * This function will cause a callback to various kernel pieces that
- * will make those pieces rethink their latency decisions. This implies
- * that if there are overlong latencies in hardware state already, those
- * latencies get taken right now. When this call completes no overlong
- * latency decisions should be active anymore.
- *
- * Typical usecase of this is after a modify_acceptable_latency() call,
- * which in itself is non-blocking and non-synchronizing.
- *
- * This function blocks and should not be called with locks held.
- */
-
-void synchronize_acceptable_latency(void)
-{
-	blocking_notifier_call_chain(&latency_notifier,
-		atomic_read(&current_max_latency), NULL);
-}
-EXPORT_SYMBOL_GPL(synchronize_acceptable_latency);
-
-/*
- * Latency notifier: this notifier gets called when a non-atomic new
- * latency value gets set. The expectation nof the caller of the
- * non-atomic set is that when the call returns, future latencies
- * are within bounds, so the functions on the notifier list are
- * expected to take the overlong latencies immediately, inside the
- * callback, and not make a overlong latency decision anymore.
- *
- * The callback gets called when the new latency value is made
- * active so system_latency_constraint() returns the new latency.
- */
-int register_latency_notifier(struct notifier_block * nb)
-{
-	return blocking_notifier_chain_register(&latency_notifier, nb);
-}
-EXPORT_SYMBOL_GPL(register_latency_notifier);
-
-int unregister_latency_notifier(struct notifier_block * nb)
-{
-	return blocking_notifier_chain_unregister(&latency_notifier, nb);
-}
-EXPORT_SYMBOL_GPL(unregister_latency_notifier);
-
-static __init int latency_init(void)
-{
-	atomic_set(&current_max_latency, INFINITE_LATENCY);
-	/*
-	 * we don't want by default to have longer latencies than 2 ticks,
-	 * since that would cause lost ticks
-	 */
-	set_acceptable_latency("kernel", 2*1000000/HZ);
-	return 0;
-}
-
-module_init(latency_init);
diff -urN -X linux-2.6.23-rc8/Documentation/dontdiff linux-2.6.23-rc8-qos/kernel/Makefile linux-2.6.23-rc8-qos-nolatency.c/kernel/Makefile
--- linux-2.6.23-rc8-qos/kernel/Makefile	2007-09-26 14:06:38.000000000 -0700
+++ linux-2.6.23-rc8-qos-nolatency.c/kernel/Makefile	2007-09-26 14:10:15.000000000 -0700
@@ -8,7 +8,7 @@
 	    signal.o sys.o kmod.o workqueue.o pid.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
-	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o die_notifier.o \
+	    hrtimer.o rwsem.o nsproxy.o srcu.o die_notifier.o \
 	    utsname.o qos_params.o
 
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
diff -urN -X linux-2.6.23-rc8/Documentation/dontdiff linux-2.6.23-rc8-qos/sound/core/pcm_native.c linux-2.6.23-rc8-qos-nolatency.c/sound/core/pcm_native.c
--- linux-2.6.23-rc8-qos/sound/core/pcm_native.c	2007-09-26 13:54:57.000000000 -0700
+++ linux-2.6.23-rc8-qos-nolatency.c/sound/core/pcm_native.c	2007-09-26 14:50:57.000000000 -0700
@@ -24,7 +24,7 @@
 #include <linux/file.h>
 #include <linux/slab.h>
 #include <linux/time.h>
-#include <linux/latency.h>
+#include <linux/qos_params.h>
 #include <linux/uio.h>
 #include <sound/core.h>
 #include <sound/control.h>
@@ -447,9 +447,9 @@
 	snd_pcm_timer_resolution_change(substream);
 	runtime->status->state = SNDRV_PCM_STATE_SETUP;
 
-	remove_acceptable_latency(substream->latency_id);
+	qos_remove_requirement(QOS_CPU_DMA_LATENCY, substream->latency_id);
 	if ((usecs = period_to_usecs(runtime)) >= 0)
-		set_acceptable_latency(substream->latency_id, usecs);
+		qos_add_requirement(QOS_CPU_DMA_LATENCY, substream->latency_id, usecs);
 	return 0;
  _error:
 	/* hardware might be unuseable from this time,
@@ -509,7 +509,7 @@
 	if (substream->ops->hw_free)
 		result = substream->ops->hw_free(substream);
 	runtime->status->state = SNDRV_PCM_STATE_OPEN;
-	remove_acceptable_latency(substream->latency_id);
+	qos_remove_requirement(QOS_CPU_DMA_LATENCY, substream->latency_id);
 	return result;
 }
 
