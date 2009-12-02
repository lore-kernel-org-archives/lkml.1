Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbZLBQv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbZLBQv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 11:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065AbZLBQv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 11:51:57 -0500
Received: from mail.gmx.net ([213.165.64.20]:37822 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755047AbZLBQvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 11:51:55 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19ncocwzyBnHvfoSWHN7ZtLYgSMESldyLUSVxsaj9
	8SC9ChcWmOUnlT
Subject: Re: [patch]  f83f9ac causes tasks running at MAX_PRIO
From: Mike Galbraith <efault@gmx.de>
To: rostedt@goodmis.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Williams <pwil3058@bigpond.net.au>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1259762606.12870.16.camel@gandalf.stny.rr.com>
References: <1259501027.6268.9.camel@marge.simson.net>
	 <1259754383.4003.610.camel@laptop>
	 <1259762606.12870.16.camel@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Wed, 02 Dec 2009 17:51:55 +0100
Message-Id: <1259772715.7052.39.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-02 at 09:03 -0500, Steven Rostedt wrote:
> On Wed, 2009-12-02 at 12:46 +0100, Peter Zijlstra wrote:

> > Funny thing though, INIT_TASK() sets everything at MAX_PRIO-20.
> 
> Right, because the init task will fork. But once a task becomes idle, it
> should never do anything (but service interrupts).


Seems it forks _as_ the idle thread..

        /*
         * Make us the idle thread. Technically, schedule() should not be
         * called from this thread, however somewhere below it might be,
         * but because we are the idle thread, we just pick up running again
         * when this runqueue becomes "idle".
         */
        init_idle(current, smp_processor_id());

        calc_load_update = jiffies + LOAD_FREQ;

        /*
         * During early bootup we pretend to be a normal task:
         */
        current->sched_class = &fair_sched_class;

..init task becomes the idle thread in sched_init().. gets to
rest_init(), forks with prio and normal_prio now at MAX_PRIO, but
static_prio still at NICE_0.

Peter's change looks OK unless I'm missing something.  Though...

static void pull_task(struct rq *src_rq, struct task_struct *p,
                      struct rq *this_rq, int this_cpu)
{
        deactivate_task(src_rq, p, 0);
        set_task_cpu(p, this_cpu);
        activate_task(this_rq, p, 0);
        /*
         * Note that idle threads have a prio of MAX_PRIO, for this test
         * to be always true for them.
         */
        check_preempt_curr(this_rq, p, 0);
}

..we have some O(1) comments for future generations to ponder.

	-Mike

