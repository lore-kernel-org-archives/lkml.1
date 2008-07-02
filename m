Return-Path: <linux-kernel-owner+w=401wt.eu-S1763454AbYGBLDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763454AbYGBLDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 07:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755406AbYGBLC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 07:02:57 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:38746 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135AbYGBLCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:02:55 -0400
X-Auth-Info: 6SoIyGclJnYO1geXO2S3SZzgPeRcUl5CM7zldvcHNKk=
X-Auth-Info: 6SoIyGclJnYO1geXO2S3SZzgPeRcUl5CM7zldvcHNKk=
X-Auth-Info: 6SoIyGclJnYO1geXO2S3SZzgPeRcUl5CM7zldvcHNKk=
X-Auth-Info: 6SoIyGclJnYO1geXO2S3SZzgPeRcUl5CM7zldvcHNKk=
X-Auth-Info: 6SoIyGclJnYO1geXO2S3SZzgPeRcUl5CM7zldvcHNKk=
X-Auth-Info: 6SoIyGclJnYO1geXO2S3SZzgPeRcUl5CM7zldvcHNKk=
X-Auth-Info: 6SoIyGclJnYO1geXO2S3SZzgPeRcUl5CM7zldvcHNKk=
Message-ID: <486B607F.9040903@grandegger.com>
Date: Wed, 02 Jul 2008 13:03:27 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Luotao Fu <l.fu@pengutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-rt1: Strange latencies on mpc5200 powerpc - RCU issue?
References: <47976D06.1010900@grandegger.com> <479DF0A1.3000906@pengutronix.de> <479DF711.5090406@grandegger.com> <479F186A.4020004@pengutronix.de> <479F2C3C.1020203@grandegger.com> <20080130010716.GB16069@linux.vnet.ibm.com> <47A032E9.4080105@grandegger.com> <20080130102255.GA24890@linux.vnet.ibm.com> <47A0552D.20605@grandegger.com> <20080130105715.GE24890@linux.vnet.ibm.com> <20080130111559.GC20089@pengutronix.de> <486A3EBB.6030905@grandegger.com> <Pine.LNX.4.58.0807011036510.26650@gandalf.stny.rr.com> <486A573E.60107@grandegger.com>
In-Reply-To: <486A573E.60107@grandegger.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfgang Grandegger wrote:
> Steven Rostedt wrote:
>> On Tue, 1 Jul 2008, Wolfgang Grandegger wrote:
>>> I continue this thread because it's still not understood why enabling
>>> CONFIG_RCU_TRACE is necessary to get reasonable latencies on the
>>> MPC5200. It might also explain, why I get much worse latencies with
>>> 2.6.25.8-rt7.
>>
>> Have you tried turning on ftrace?
> 
> Not yet.
> 
>>
>>> To recapitulate, with CONFIG_RCU_TRACE enabled, cyclictest reports max.
>>> latencies of approx. 130 us with 2.6.24.4-rt4 on my MPC5200 PowerPC
>>> board. If I disable it, the latency goes up to 600 us. Obviously, the
>>> trace_mark() calls in rcupreempt*.c have some positive impact on the
>>> latency. I narrowed down, that the 2 calls in __rcu_preempt_boost() in
>>> rcupreempt-boost.c are the important one:
>>>
>>> void __rcu_preempt_unboost(void)
>>> {
>>>     struct task_struct *curr = current;
>>>     struct rcu_boost_dat *rbd;
>>>     int prio;
>>>     unsigned long flags;
>>>
>>>     trace_mark(unboost_called, "NULL");
> 
> To make it clear: If I just comment out the line above and ...
> 
>>>
>>>     /* if not boosted, then ignore */
>>>     if (likely(!rcu_is_boosted(curr)))
>>>         return;
>>
>> I wonder if the "likely" is faulty on the PPC code generation. Have you
>> tried removing that "likely" statement.
>>
>>>     /*
>>>      * Need to be very careful with NMIs.
>>>      * If we take the lock and an NMI comes in
>>>      * and it may try to unboost us if curr->rcub_rbdp
>>>      * is still set. So we zero it before grabbing the lock.
>>>      * But this also means that we might be boosted again
>>>      * so the boosting code needs to be aware of this.
>>>      */
>>>     rbd = curr->rcub_rbdp;
>>>     curr->rcub_rbdp = NULL;
>>>
>>>     /*
>>>      * Now an NMI might have came in after we grab
>>>      * the below lock. This check makes sure that
>>>      * the NMI doesn't try grabbing the lock
>>>      * while we already have it.
>>>      */
>>>     if (unlikely(!rbd))
>>>         return;
>>
>> Actually, remove all "likely" and "unlikely". The marker code could be
>> making it work better. But still, this shouldn't cause 600us latencies.
>>
>>>     spin_lock_irqsave(&rbd->rbs_lock, flags);
>>>     /*
>>>      * It is still possible that an NMI came in
>>>      * between the "is_boosted" check and setting
>>>      * the rcu_rbdp to NULL. This would mean that
>>>      * the NMI already dequeued us.
>>>      */
>>>     if (unlikely(!rcu_is_boosted(curr)))
>>>         goto out;
>>>
>>>     list_del_init(&curr->rcub_entry);
>>>
>>>     trace_mark(unboosted, "NULL");
> 
> .. this one as well, then the latency goes *up* to 600us. The first one 
> has more influence, though.
> 
>>>
>>>     curr->rcu_prio = MAX_PRIO;
>>>
>>>     spin_lock(&curr->pi_lock);
>>>     prio = rt_mutex_getprio(curr);
>>>     task_setprio(curr, prio);
>>>
>>>     curr->rcub_rbdp = NULL;
>>>
>>>     spin_unlock(&curr->pi_lock);
>>>   out:
>>>     spin_unlock_irqrestore(&rbd->rbs_lock, flags);
>>> }
>>>
>>> With them and all other trace_mark() calls commented out, the latency is
>>> still OK. The first one has a bigger impact.
>>>
>>> In 2.6.25.8-rt7, trace_mark() is not used any more but a function
>>> incrementing the corresponding counter directly and I suspect that's the
>>> reason why I'm seeing high latencies with both, CONFIG_RCU_TRACE enabled
>>> and disabled.
>>>
>>> I hope this observation sheds some light on the issue.
>>
>> It is still a mystery to me. Maybe looking at the different assembly
>> outputs with the different configurations.
> 
> There seems to be something in trace_mark() keeping latency low:
> 
>   http://lxr.linux.no/linux+v2.6.24.4/include/linux/marker.h#L52
> 
> I will follow your suggestions.

I removed all "likely" and "unlikely" macros, but the latencies did not 
improve. Then I added

	preempt_disable();
	preempt_enable();

at the two locations mentioned above, like trace_mark() does,  and 
disabled CONFIG_RCU_TRACE. That helped to keep the latencies low, and it 
did for 2.6.25.8-rt7 as well. As I see it, adding preemption points seem 
to prevent high latencies.

Wolfgang.



