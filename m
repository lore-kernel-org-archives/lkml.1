Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbYLEQkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbYLEQkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 11:40:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbYLEQkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 11:40:08 -0500
Received: from relay2.sgi.com ([192.48.179.30]:41446 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751845AbYLEQkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 11:40:07 -0500
From: John Keller <jpk@sgi.com>
Message-Id: <200812051640.mB5Ge2U1122172@fcbayern.americas.sgi.com>
Subject: genirq regression - CONFIG_AUTO_IRQ_AFFINITY
To: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org
Date: Fri, 5 Dec 2008 10:40:01 -0600 (CST)
Cc: akpm@linux-foundation.org, tglx@linutronix.de
X-Mailer: ELM [version 2.5 PL2]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The addition of the generic affinity autoselector has introduced
a regression in SN2 Altix.

In the past, request_irq()'s call to select_smp_affinity() was
essentially a noop. 

#ifdef CONFIG_AUTO_IRQ_AFFINITY
extern int select_smp_affinity(unsigned int irq);
#else
static inline int select_smp_affinity(unsigned int irq)
{
        return 1;
}


Now changes have created do_irq_select_affinity(), which is
executed by a call to request_irq().

  request_irq()
   __setup_irq()
    do_irq_select_affinity()

do_irq_select_affinity() will call the set_affinity() routine,
with a default mask. On SN2 (and possibly all ia64 platforms),
this will retarget all device interrupts to the same CPU, most
likely CPU0.


#ifndef CONFIG_AUTO_IRQ_AFFINITY
/*
 * Generic version of the affinity autoselector.
 */
int do_irq_select_affinity(unsigned int irq, struct irq_desc *desc)
{
        cpumask_t mask;

        if (!irq_can_set_affinity(irq))
                return 0;

        cpus_and(mask, cpu_online_map, irq_default_affinity);

        /*
         * Preserve an userspace affinity setup, but make sure that
         * one of the targets is online.
         */
        if (desc->status & (IRQ_AFFINITY_SET | IRQ_NO_BALANCING)) {
                if (cpus_intersects(desc->affinity, cpu_online_map))
                        mask = desc->affinity;
                else
                        desc->status &= ~IRQ_AFFINITY_SET;
        }

        desc->affinity = mask;
        desc->chip->set_affinity(irq, mask);

        return 0;
}

This set_affinity call undoes all the performance related interrupt
targetting that the SN2 PROM did at boot.

I'm looking at a patch that makes use of the new IRQ_AFFINITY_SET
flag in the irq_desc to get around this.

Is this an issue for all ia64 platforms? Or does irq balancing
factor in here? IRQ balancing is disabled on SN2.

John Keller

