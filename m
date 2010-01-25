Return-Path: <linux-kernel-owner+w=401wt.eu-S1753682Ab0AYWOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab0AYWOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 17:14:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281Ab0AYWOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 17:14:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628Ab0AYWOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 17:14:32 -0500
Message-ID: <4B5E17B8.4090002@redhat.com>
Date: Mon, 25 Jan 2010 17:14:16 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [RFC PATCH 03/10] ftrace: Drop the ftrace_profile_enabled	checks
 in tracing hot path
References: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com> <1264122982-1553-4-git-send-regression-fweisbec@gmail.com> <1264125917.31321.312.camel@gandalf.stny.rr.com> <20100122022858.GA2604@Krystal> <1264129978.31321.333.camel@gandalf.stny.rr.com> <20100122040959.GA11827@Krystal> <1264135966.31321.375.camel@gandalf.stny.rr.com> <20100122123450.GA19348@Krystal> <20100125205814.GD5087@nowhere>
In-Reply-To: <20100125205814.GD5087@nowhere>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Fri, Jan 22, 2010 at 07:34:51AM -0500, Mathieu Desnoyers wrote:
>> * Steven Rostedt (rostedt@goodmis.org) wrote:
>>> On Thu, 2010-01-21 at 23:09 -0500, Mathieu Desnoyers wrote:
>>>> * Steven Rostedt (rostedt@goodmis.org) wrote:
>>>
>>>>> Hmm, interesting. Maybe something like that might work. But what if
>>>>> CONFIG_PREEMPT is enabled but CONFIG_FREEZER is not?
>>>>
>>>> Then you may want to make the function tracer depend on CONFIG_FREEZER,
>>>> but maybe Masami has other ideas ?
>>>
>>> egad no! This is just to help add guarantees to those that use the
>>> function tracer that when the tracing is disabled, it is guaranteed that
>>> no more tracing will be called by the function tracer. Currently,
>>> nothing relies on this. But we may add cases that might need this.
>>
>> Yep, identifying tracer quiescent state can become handy.
>>
>>>
>>> In fact, only those that need this requirement would need to do this
>>> trick. Anyway, we could make those depend on CONFIG_FREEZER, but that
>>> just seems to be a strange dependency.
>>
>> This makes me wonder (question for Masami)...
>>
>> static int __kprobes check_safety(void)
>> {
>>         int ret = 0;
>> #if defined(CONFIG_PREEMPT) && defined(CONFIG_FREEZER)
>>         ret = freeze_processes();
>>         if (ret == 0) {
>>                 struct task_struct *p, *q;
>>                 do_each_thread(p, q) {
>>                         if (p != current && p->state == TASK_RUNNING &&
>>                             p->pid != 0) {
>>                                 printk("Check failed: %s is running\n",p->comm);
>>                                 ret = -1;
>>                                 goto loop_end;
>>                         }
>>                 } while_each_thread(p, q);
> 
> 
> 
> How does that deal with kernel threads that don't freeze?

Hmm, right. It can't handle non-freezable kernel threads.

> Also freezing every processes seems a bit of a heavy thing for that.
> Looks like a synchronize_tasks() would be really useful.

Sure :-)
Maybe, I'd better remove booster support on preemptive kernel until then.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

