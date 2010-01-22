Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839Ab0AVMe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab0AVMe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 07:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106Ab0AVMe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 07:34:56 -0500
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:33081 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab0AVMez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 07:34:55 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsoEAH8qWUuuWOiG/2dsb2JhbACBRdc9hDwE
Date: Fri, 22 Jan 2010 07:34:51 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [RFC PATCH 03/10] ftrace: Drop the ftrace_profile_enabled
	checks in tracing hot path
Message-ID: <20100122123450.GA19348@Krystal>
References: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com> <1264122982-1553-4-git-send-regression-fweisbec@gmail.com> <1264125917.31321.312.camel@gandalf.stny.rr.com> <20100122022858.GA2604@Krystal> <1264129978.31321.333.camel@gandalf.stny.rr.com> <20100122040959.GA11827@Krystal> <1264135966.31321.375.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1264135966.31321.375.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 07:32:10 up 36 days, 20:50,  4 users,  load average: 0.26, 0.19,
	0.12
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Thu, 2010-01-21 at 23:09 -0500, Mathieu Desnoyers wrote:
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> > > Hmm, interesting. Maybe something like that might work. But what if
> > > CONFIG_PREEMPT is enabled but CONFIG_FREEZER is not?
> > 
> > Then you may want to make the function tracer depend on CONFIG_FREEZER,
> > but maybe Masami has other ideas ?
> 
> egad no! This is just to help add guarantees to those that use the
> function tracer that when the tracing is disabled, it is guaranteed that
> no more tracing will be called by the function tracer. Currently,
> nothing relies on this. But we may add cases that might need this.

Yep, identifying tracer quiescent state can become handy.

> 
> In fact, only those that need this requirement would need to do this
> trick. Anyway, we could make those depend on CONFIG_FREEZER, but that
> just seems to be a strange dependency.

This makes me wonder (question for Masami)...

static int __kprobes check_safety(void)
{
        int ret = 0;
#if defined(CONFIG_PREEMPT) && defined(CONFIG_FREEZER)
        ret = freeze_processes();
        if (ret == 0) {
                struct task_struct *p, *q;
                do_each_thread(p, q) {
                        if (p != current && p->state == TASK_RUNNING &&
                            p->pid != 0) {
                                printk("Check failed: %s is running\n",p->comm);
                                ret = -1;
                                goto loop_end;
                        }
                } while_each_thread(p, q);
        }
loop_end:
        thaw_processes();
#else
        synchronize_sched();
#endif
        return ret;
}

How does that deal with CONFIG_PREEMPT && !CONFIG_FREEZER exactly ?

Thanks,

Mathieu

> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
