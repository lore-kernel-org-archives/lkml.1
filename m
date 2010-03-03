Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab0CCLJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 06:09:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:23327 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab0CCLJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 06:09:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,573,1262592000"; 
   d="scan'208";a="600879499"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH] x86/mrst: Fix APB timer per cpu clockevent
Date: Tue,  2 Mar 2010 21:01:34 -0800
Message-Id: <1267592494-7723-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current APB timer code incorrectly registers the static copy of the
clockevent device for boot CPU. The per cpu clockevent should be used
instead.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/kernel/apb_timer.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index 1232fe7..6f20c6c 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -84,9 +84,10 @@ struct apbt_dev {
 
 int disable_apbt_percpu __cpuinitdata;
 
+static DEFINE_PER_CPU(struct apbt_dev, cpu_apbt_dev);
+
 #ifdef CONFIG_SMP
 static unsigned int apbt_num_timers_used;
-static DEFINE_PER_CPU(struct apbt_dev, cpu_apbt_dev);
 static struct apbt_dev *apbt_devs;
 #endif
 
@@ -302,6 +303,7 @@ static void apbt_disable_int(int n)
 static int __init apbt_clockevent_register(void)
 {
        struct sfi_timer_table_entry *mtmr;
+       struct apbt_dev *adev = &__get_cpu_var(cpu_apbt_dev);
 
        mtmr = sfi_get_mtmr(APBT_CLOCKEVENT0_NUM);
        if (mtmr == NULL) {
@@ -329,22 +331,24 @@ static int __init apbt_clockevent_register(void)
         * global if not used for per cpu timer.
         */
        apbt_clockevent.cpumask = cpumask_of(smp_processor_id());
+       adev->num = smp_processor_id();
+       memcpy(&adev->evt, &apbt_clockevent, sizeof(struct clock_event_device));
 
        if (disable_apbt_percpu) {
                apbt_clockevent.rating = APBT_CLOCKEVENT_RATING - 100;
-               global_clock_event = &apbt_clockevent;
+		global_clock_event = &adev->evt;
                printk(KERN_DEBUG "%s clockevent registered as global\n",
                        global_clock_event->name);
        }
 
        if (request_irq(apbt_clockevent.irq, apbt_interrupt_handler,
                IRQF_TIMER | IRQF_DISABLED | IRQF_NOBALANCING,
-               apbt_clockevent.name, &apbt_clockevent)) {
+		apbt_clockevent.name, adev)) {
                printk(KERN_ERR "Failed request IRQ for APBT%d\n",
                        apbt_clockevent.irq);
        }
 
-       clockevents_register_device(&apbt_clockevent);
+       clockevents_register_device(&adev->evt);
        /* Start APBT 0 interrupts */
        apbt_enable_int(APBT_CLOCKEVENT0_NUM);
 
-- 
1.5.6.5

