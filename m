Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab0CCU2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 15:28:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:46776 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342Ab0CCU2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 15:28:05 -0500
Date: Wed, 3 Mar 2010 20:27:39 GMT
From: tip-bot for Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, jacob.jun.pan@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, jacob.jun.pan@linux.intel.com
In-Reply-To: <1267592494-7723-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1267592494-7723-1-git-send-email-jacob.jun.pan@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86, mrst: Fix APB timer per cpu clockevent
Message-ID: <tip-3010673ef5f7bef4b4685566a0713de1b4306c93@git.kernel.org>
Git-Commit-ID: 3010673ef5f7bef4b4685566a0713de1b4306c93
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 03 Mar 2010 20:27:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3010673ef5f7bef4b4685566a0713de1b4306c93
Gitweb:     http://git.kernel.org/tip/3010673ef5f7bef4b4685566a0713de1b4306c93
Author:     Jacob Pan <jacob.jun.pan@linux.intel.com>
AuthorDate: Tue, 2 Mar 2010 21:01:34 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 3 Mar 2010 12:04:59 -0800

x86, mrst: Fix APB timer per cpu clockevent

The current APB timer code incorrectly registers a static copy of the
clockevent device for the boot CPU. The per cpu clockevent should be
used instead.

This bug was hidden by zero-initialized data; as such it did not get
exposed in testing, but was discovered by code review.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
LKML-Reference: <1267592494-7723-1-git-send-email-jacob.jun.pan@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/apb_timer.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index 83a345b..6f27f8b 100644
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
 
