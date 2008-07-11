Return-Path: <linux-kernel-owner+w=401wt.eu-S1758286AbYGKTn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758286AbYGKTn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbYGKTnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:43:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:19392 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbYGKTnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:43:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=geVOJW8gpDCM0a3sfq8nf0U0qr6BGjIZFlEHOn2sqsAV+V0s9cxpBOKP92hXvuI0OW
         LNRZSsvdyRl9S62LYCqR6CMyCRXycjrC1MepGz3XHivJWoK1zPzNSmPGN4ai+LzMh+bw
         FLLm2KiP7rsARBlPxIampfaYDAAY8SWU2pcH4=
Message-ID: <19f34abd0807111243s549b0facvbd0a650358463231@mail.gmail.com>
Date: Fri, 11 Jul 2008 21:43:18 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Paul Menage" <menage@google.com>, "Max Krasnyansky" <maxk@qualcomm.com>
Subject: Re: current linux-2.6.git: cpusets completely broken
Cc: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       "Paul Jackson" <pj@sgi.com>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       miaox@cn.fujitsu.com, rostedt@goodmis.org,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <6599ad830807111236t2bc9aa02ned59dcc58f14b1bf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807111207q2ad2011csdb46c6f451fe0f6d@mail.gmail.com>
	 <6599ad830807111236t2bc9aa02ned59dcc58f14b1bf@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 9:36 PM, Paul Menage <menage@google.com> wrote:
> On Fri, Jul 11, 2008 at 12:07 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>>
>> The result of having CPUSETS enabled as above is a 100% reproducible
>> BUG on the very first cpu hot-unplug:
>>
>> ------------[ cut here ]------------
>> kernel BUG at xxx/linux-2.6/kernel/sched.c:5859!
>
> That doesn't quite match up with any BUG in 2.6.26-rc9 - what tree is
> this last crash based on?

latest mainline. Commit e5a5816f7875207cb0a0a7032e39a4686c5e10a4.

Is this one:

/* called under rq->lock with disabled interrupts */
static void migrate_dead(unsigned int dead_cpu, struct task_struct *p)
{
        struct rq *rq = cpu_rq(dead_cpu);

        /* Must be exiting, otherwise would be on tasklist. */
        BUG_ON(!p->exit_state);

>> Also, this is on the latest linux-2.6.git! Since we're so close to
>> release, maybe cpusets should simply be marked BROKEN for now? (Unless
>> we can fix it, of course. The alternative is to apply Miao Xie's
>> workaround patch temporarily.)
>
> If we were going to mark anything as broken, wouldn't cpu-hotplug be
> the more appropriate victim? I suspect that there are more systems
> using cpusets in production environments than using cpu hotplug. But
> as you say, fixing it sounds better.

I'm sorry for the harsh characterization and suggestion; please accept
my apology. It was purely a result of my excitement at having made
some progress in this case.

But I have more good news; reverting this:

commit f18f982abf183e91f435990d337164c7a43d1e6d
Author: Max Krasnyansky <maxk@qualcomm.com>
Date:   Thu May 29 11:17:01 2008 -0700

    sched: CPU hotplug events must not destroy scheduler domains created by the
cpusets

    First issue is not related to the cpusets. We're simply leaking doms_cur.
    It's allocated in arch_init_sched_domains() which is called for every
    hotplug event. So we just keep reallocation doms_cur without freeing it.
    I introduced free_sched_domains() function that cleans things up.

    Second issue is that sched domains created by the cpusets are
    completely destroyed by the CPU hotplug events. For all CPU hotplug
    events scheduler attaches all CPUs to the NULL domain and then puts
    them all into the single domain thereby destroying domains created
    by the cpusets (partition_sched_domains).
    The solution is simple, when cpusets are enabled scheduler should not
    create default domain and instead let cpusets do that. Which is
    exactly what the patch does.

    Signed-off-by: Max Krasnyansky <maxk@qualcomm.com>
    Cc: pj@sgi.com
    Cc: menage@google.com
    Cc: rostedt@goodmis.org
    Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

gets rid of the BUG! (Added people to Ccs.)

Might I instead suggest a revert of this? (Again, unless somebody else
can spot the real error and fix it before 2.6.26 is out :-))


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
