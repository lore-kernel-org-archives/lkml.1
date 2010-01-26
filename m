Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799Ab0AZBiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab0AZBiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 20:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638Ab0AZBiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 20:38:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576Ab0AZBiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 20:38:18 -0500
Message-ID: <4B5E476C.9030303@redhat.com>
Date: Mon, 25 Jan 2010 20:37:48 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [RFC PATCH 03/10] ftrace: Drop the ftrace_profile_enabled	checks
 in tracing hot path
References: <1264122982-1553-4-git-send-regression-fweisbec@gmail.com> <1264125917.31321.312.camel@gandalf.stny.rr.com> <20100122022858.GA2604@Krystal> <1264129978.31321.333.camel@gandalf.stny.rr.com> <20100122040959.GA11827@Krystal> <1264135966.31321.375.camel@gandalf.stny.rr.com> <20100122123450.GA19348@Krystal> <20100125205814.GD5087@nowhere> <4B5E17B8.4090002@redhat.com> <20100126004153.GJ5087@nowhere> <20100126011303.GA29148@Krystal>
In-Reply-To: <20100126011303.GA29148@Krystal>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Frederic Weisbecker (fweisbec@gmail.com) wrote:
>> On Mon, Jan 25, 2010 at 05:14:16PM -0500, Masami Hiramatsu wrote:
>>> Frederic Weisbecker wrote:
>>>> On Fri, Jan 22, 2010 at 07:34:51AM -0500, Mathieu Desnoyers wrote:
>>>>> * Steven Rostedt (rostedt@goodmis.org) wrote:
>>>>>> On Thu, 2010-01-21 at 23:09 -0500, Mathieu Desnoyers wrote:
>>>>>>> * Steven Rostedt (rostedt@goodmis.org) wrote:
>>>>>>
>>>>>>>> Hmm, interesting. Maybe something like that might work. But what if
>>>>>>>> CONFIG_PREEMPT is enabled but CONFIG_FREEZER is not?
>>>>>>>
>>>>>>> Then you may want to make the function tracer depend on CONFIG_FREEZER,
>>>>>>> but maybe Masami has other ideas ?
>>>>>>
>>>>>> egad no! This is just to help add guarantees to those that use the
>>>>>> function tracer that when the tracing is disabled, it is guaranteed that
>>>>>> no more tracing will be called by the function tracer. Currently,
>>>>>> nothing relies on this. But we may add cases that might need this.
>>>>>
>>>>> Yep, identifying tracer quiescent state can become handy.
>>>>>
>>>>>>
>>>>>> In fact, only those that need this requirement would need to do this
>>>>>> trick. Anyway, we could make those depend on CONFIG_FREEZER, but that
>>>>>> just seems to be a strange dependency.
>>>>>
>>>>> This makes me wonder (question for Masami)...
>>>>>
>>>>> static int __kprobes check_safety(void)
>>>>> {
>>>>>         int ret = 0;
>>>>> #if defined(CONFIG_PREEMPT) && defined(CONFIG_FREEZER)
>>>>>         ret = freeze_processes();
>>>>>         if (ret == 0) {
>>>>>                 struct task_struct *p, *q;
>>>>>                 do_each_thread(p, q) {
>>>>>                         if (p != current && p->state == TASK_RUNNING &&
>>>>>                             p->pid != 0) {
>>>>>                                 printk("Check failed: %s is running\n",p->comm);
>>>>>                                 ret = -1;
>>>>>                                 goto loop_end;
>>>>>                         }
>>>>>                 } while_each_thread(p, q);
>>>>
>>>>
>>>>
>>>> How does that deal with kernel threads that don't freeze?
>>>
>>> Hmm, right. It can't handle non-freezable kernel threads.
>>>
>>>> Also freezing every processes seems a bit of a heavy thing for that.
>>>> Looks like a synchronize_tasks() would be really useful.
>>>
>>> Sure :-)
>>> Maybe, I'd better remove booster support on preemptive kernel until then.
>>
>>
>> I don't know as I haven't looked deeper into check_safety(), but does the
>> fact we have non-freezable tasks break the assumptions that make
>> kprobes booster safe? If so then yeah, may be deactivate it for now.
>>
> 
> In the case of check_safety, it's not a bug per se if a task happens to
> be non freezable. freeze_processes() will likely return a non-zero
> value, and the whole check_safety will therefore return that value, so
> standard breakpoints will be used instead.

Hmm, unfortunately no, because freeze_processes() doesn't count
non-freezable threads...

---
                todo = 0;
                read_lock(&tasklist_lock);
                do_each_thread(g, p) {
                        if (frozen(p) || !freezeable(p))
                                continue;

                        if (!freeze_task(p, sig_only))
                                continue;

                        /*
                         * Now that we've done set_freeze_flag, don't
                         * perturb a task in TASK_STOPPED or TASK_TRACED.
                         * It is "frozen enough".  If the task does wake
                         * up, it will immediately call try_to_freeze.
                         */
                        if (!task_is_stopped_or_traced(p) &&
                            !freezer_should_skip(p))
                                todo++;
                } while_each_thread(g, p);
                read_unlock(&tasklist_lock);
                if (!todo || time_after(jiffies, end_time))
                        break;
---

So, it can return 0 if there is non-freezable threads running.

Thank you,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

