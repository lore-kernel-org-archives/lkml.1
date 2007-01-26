Return-Path: <linux-kernel-owner+w=401wt.eu-S1030791AbXAZGaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030791AbXAZGaE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 01:30:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030792AbXAZGaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 01:30:04 -0500
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:60845 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030791AbXAZGaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 01:30:00 -0500
Message-ID: <45B99FDA.7050404@kernel.org>
Date: Thu, 25 Jan 2007 22:29:46 -0800
From: Josh Triplett <josh@kernel.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linuxtronix.de,
       dipankar@in.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       oleg@tv-sign.ru, twoerner.k@gmail.com, billh@gnuppy.monkey.org,
       nielsen.esben@googlemail.com, corbet@lwn.net
Subject: Re: [RFC PATCH -rt 2/2] RCU priority boosting additions to rcutorture
References: <20070125021101.GA23428@linux.vnet.ibm.com> <20070125021444.GA22540@linux.vnet.ibm.com> <20070125022338.GB22540@linux.vnet.ibm.com> <45B86E88.6020209@kernel.org> <20070125180158.GC1705@linux.vnet.ibm.com> <45B8FFBB.4090307@kernel.org> <20070126015212.GI1705@linux.vnet.ibm.com>
In-Reply-To: <20070126015212.GI1705@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Thu, Jan 25, 2007 at 11:06:35AM -0800, Josh Triplett wrote:
>> Paul E. McKenney wrote:
>>> On Thu, Jan 25, 2007 at 12:47:04AM -0800, Josh Triplett wrote:
>>>> One major item: this new test feature really needs a new module parameter to
>>>> enable or disable it.
>>> CONFIG_PREEMPT_RCU_BOOST is the parameter -- if not set, then no test.
>>> This parameter is provided by the accompanying RCU-boost patch.
>> It seems useful for rcutorture to use or not use the preempting thread
>> independently of CONFIG_PREEMPT_RCU_BOOST.  That would bring you from two
>> cases to four, and the two new cases both make sense:
>>
>> * CONFIG_PREEMPT_RCU_BOOST=n, but run rcutorture with the preempting thread.
>>   This configuration allows you to demonstrate the need for
>>   CONFIG_PREEMPT_RCU_BOOST, by showing what happens when you need it and don't
>>   have it.
>>
>> * CONFIG_PREEMPT_RCU_BOOST=y, but run rcutorture without the preempting
>>   thread.  This configuration allows you to test with rcutorture while running
>>   a *real* real-time workload rather than the simple preempting thread, or
>>   just test basic RCU functionality.
>>
>> A simple boolean module_param would work here.
> 
> OK, sold!  I will add this.  Perhaps CONFIG_PREEMPT_RCU_TORTURE.

Why a config option?  Why not a module parameter, settable at module load time?

static int enable_preempter;
...
module_param(enable_preempter, bool, 0);
MODULE_PARM_DESC(enable_preempter, "Enable preempting thread, to test RCU priority boosting");
...
rcu_torture_cleanup(void)
{
...
	if (enable_preempter && cur_ops->preemptend)
		cur_ops->preemptend();
...
	if (enable_preempter && cur_ops->preemptstart)
		cur_ops->preemptstart();

Then just remove the #ifdef CONFIG_PREEMPT_RCU_BOOST from rcutorture entirely,
and always supply the preempter functions.  rcutorture then doesn't depend on
CONFIG_PREEMPT_RCU_BOOST at all, and the module parameter determines whether
to run the preempter thread.

>>>> Paul E. McKenney wrote:
>>>>> diff -urpNa -X dontdiff linux-2.6.20-rc4-rt1/kernel/rcutorture.c linux-2.6.20-rc4-rt1-rcubtorture/kernel/rcutorture.c
>>>>> --- linux-2.6.20-rc4-rt1/kernel/rcutorture.c	2007-01-09 10:59:54.000000000 -0800
>>>>> +++ linux-2.6.20-rc4-rt1-rcubtorture/kernel/rcutorture.c	2007-01-23 11:27:49.000000000 -0800
>>>>> +static int rcu_torture_preempt(void *arg)
>>>>> +{
>>>>> +	int completedstart;
>>>>> +	time_t gcstart;
>>>>> +	struct sched_param sp;
>>>>> +
>>>>> +	sp.sched_priority = MAX_RT_PRIO - 1;
>>>>> +	sched_setscheduler(current, SCHED_RR, &sp);
>>>>> +	current->flags |= PF_NOFREEZE;
>>>>> +
>>>>> +	do {
>>>>> +		completedstart = rcu_torture_completed();
>>>>> +		gcstart = xtime.tv_sec;
>>>>> +		while ((xtime.tv_sec - gcstart < 10) &&
>>>>> +		       (rcu_torture_completed() == completedstart))
>>>>> +			cond_resched();
>>>>> +		if (rcu_torture_completed() == completedstart)
>>>>> +			rcu_torture_preempt_errors++;
>>>>> +		schedule_timeout_interruptible(shuffle_interval * HZ);
>>>> Why call schedule_timeout_interruptible here without actually handling
>>>> interruptions?  So that you can send it a signal to cause the shuffle early?
>>> It allows you to kill the process in order to get the module unload to
>>> happen more quickly in case someone specified an overly long interval.
>> I didn't actually know that you could kill a kthread from userspace. :)
>>
>> That rationale makes sense.
> 
> It won't actually die, but if I understand correctly (a big "if") the
> signal would cause schedule_timeout_interruptible() to return, allowing
> the kthread_should_stop() check to happen.

Ah, that makes much more sense; thanks.

- Josh Triplett

