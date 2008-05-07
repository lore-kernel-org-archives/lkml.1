Return-Path: <linux-kernel-owner+w=401wt.eu-S1763120AbYEGRYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763120AbYEGRYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 13:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753602AbYEGRYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 13:24:21 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57560 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753355AbYEGRYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 13:24:19 -0400
Date: Wed, 7 May 2008 10:24:18 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Spinlocks waiting with interrupts disabled / preempt disabled.
In-Reply-To: <Pine.LNX.4.64.0805071002330.3110@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0805071022230.3173@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com>
 <20080507073017.GJ32195@elte.hu> <Pine.LNX.4.64.0805071002330.3110@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like an issue with old code in SLES10. Upstream has:

/*
 * If lockdep is enabled then we use the non-preemption spin-ops
 * even on CONFIG_PREEMPT, because lockdep assumes that interrupts are
 * not re-enabled during lock-acquire (which the preempt-spin-ops do):
 */
#if !defined(CONFIG_GENERIC_LOCKBREAK) || defined(CONFIG_DEBUG_LOCK_ALLOC)

.. followed by function definitions that disable interrupts before 
spinning.

#else

...

unsigned long __lockfunc _##op##_lock_irqsave(locktype##_t *lock)       \
{                                                                       \
        unsigned long flags;                                            \
                                                                        \
        for (;;) {                                                      \
                preempt_disable();                                      \
                local_irq_save(flags);                                  \
                if (likely(_raw_##op##_trylock(lock)))                  \
                        break;                                          \
                local_irq_restore(flags);                               \
                preempt_enable();                                       \
                                                                        \
                if (!(lock)->break_lock)                                \
                        (lock)->break_lock = 1;                         \
                while (!op##_can_lock(lock) && (lock)->break_lock)      \
                        _raw_##op##_relax(&lock->raw_lock);             \
        }                                                               \
        (lock)->break_lock = 0;                                         \
        return flags;                                                   \
}                                                                       \
                                       
So this is only an issue if certain debug options are enabled.

