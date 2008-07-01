Return-Path: <linux-kernel-owner+w=401wt.eu-S1758654AbYGAO0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbYGAO0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 10:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755599AbYGAO0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 10:26:37 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:55333 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161AbYGAO0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 10:26:36 -0400
X-Auth-Info: knL37CQ1yjNYrE3MmTHgFa16FUHOntwjjY0fVglz/9U=
X-Auth-Info: knL37CQ1yjNYrE3MmTHgFa16FUHOntwjjY0fVglz/9U=
X-Auth-Info: knL37CQ1yjNYrE3MmTHgFa16FUHOntwjjY0fVglz/9U=
X-Auth-Info: knL37CQ1yjNYrE3MmTHgFa16FUHOntwjjY0fVglz/9U=
X-Auth-Info: knL37CQ1yjNYrE3MmTHgFa16FUHOntwjjY0fVglz/9U=
X-Auth-Info: knL37CQ1yjNYrE3MmTHgFa16FUHOntwjjY0fVglz/9U=
X-Auth-Info: knL37CQ1yjNYrE3MmTHgFa16FUHOntwjjY0fVglz/9U=
X-Auth-Info: knL37CQ1yjNYrE3MmTHgFa16FUHOntwjjY0fVglz/9U=
Message-ID: <486A3EBB.6030905@grandegger.com>
Date: Tue, 01 Jul 2008 16:27:07 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Wolfgang Grandegger <wg@grandegger.com>,
       Luotao Fu <l.fu@pengutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-rt1: Strange latencies on mpc5200 powerpc - RCU	issue?
References: <47976D06.1010900@grandegger.com> <479DF0A1.3000906@pengutronix.de> <479DF711.5090406@grandegger.com> <479F186A.4020004@pengutronix.de> <479F2C3C.1020203@grandegger.com> <20080130010716.GB16069@linux.vnet.ibm.com> <47A032E9.4080105@grandegger.com> <20080130102255.GA24890@linux.vnet.ibm.com> <47A0552D.20605@grandegger.com> <20080130105715.GE24890@linux.vnet.ibm.com> <20080130111559.GC20089@pengutronix.de>
In-Reply-To: <20080130111559.GC20089@pengutronix.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I continue this thread because it's still not understood why enabling
CONFIG_RCU_TRACE is necessary to get reasonable latencies on the
MPC5200. It might also explain, why I get much worse latencies with
2.6.25.8-rt7.

Luotao Fu wrote:
> Hi,
> 
> On Wed, Jan 30, 2008 at 02:57:16AM -0800, Paul E. McKenney wrote:
> ......
>>> Yes, I used "$ cyclictest -n -t1 -p80 -i1000" to measure the latency. So
>>> far, I have not done other tests. Any recommendation?
>>> As no-rt load I used "while ls; do ls /bin; done" in one telnet window
>>> and "while ./hackbench 10; do ./calibrator 400 32M cali; sleep 30; done"
>>> in another. But already "while ls; do ls /bin; done" is enough to
>>> trigger the high latencies quickly. Note also, that I work on a root
>>> files-ystem mounted via NFS resulting in a lot of network traffic and
>>> utilization.
>> I have to ask...
>>
>> Did you see large latencies when -not- running on NFS?
>>
> 
> I cannot speak for Wolfgang but I myself did not get extraordinary high
> latencies running tests on system booted from flash. Neither I could produce
> high latencies on nfs booted system. If my non-rt workload doesn't do heavy
> filesystem/network accesses. i.E. running only hackbench. Hence we were
> wondering if the problem is caused by rcu's in network layer or nfs
> implementation.

To recapitulate, with CONFIG_RCU_TRACE enabled, cyclictest reports max.
latencies of approx. 130 us with 2.6.24.4-rt4 on my MPC5200 PowerPC
board. If I disable it, the latency goes up to 600 us. Obviously, the
trace_mark() calls in rcupreempt*.c have some positive impact on the
latency. I narrowed down, that the 2 calls in __rcu_preempt_boost() in
rcupreempt-boost.c are the important one:

void __rcu_preempt_unboost(void)
{
	struct task_struct *curr = current;
	struct rcu_boost_dat *rbd;
	int prio;
	unsigned long flags;

	trace_mark(unboost_called, "NULL");

	/* if not boosted, then ignore */
	if (likely(!rcu_is_boosted(curr)))
		return;

	/*
	 * Need to be very careful with NMIs.
	 * If we take the lock and an NMI comes in
	 * and it may try to unboost us if curr->rcub_rbdp
	 * is still set. So we zero it before grabbing the lock.
	 * But this also means that we might be boosted again
	 * so the boosting code needs to be aware of this.
	 */
	rbd = curr->rcub_rbdp;
	curr->rcub_rbdp = NULL;

	/*
	 * Now an NMI might have came in after we grab
	 * the below lock. This check makes sure that
	 * the NMI doesn't try grabbing the lock
	 * while we already have it.
	 */
	if (unlikely(!rbd))
		return;

	spin_lock_irqsave(&rbd->rbs_lock, flags);
	/*
	 * It is still possible that an NMI came in
	 * between the "is_boosted" check and setting
	 * the rcu_rbdp to NULL. This would mean that
	 * the NMI already dequeued us.
	 */
	if (unlikely(!rcu_is_boosted(curr)))
		goto out;

	list_del_init(&curr->rcub_entry);

	trace_mark(unboosted, "NULL");

	curr->rcu_prio = MAX_PRIO;

	spin_lock(&curr->pi_lock);
	prio = rt_mutex_getprio(curr);
	task_setprio(curr, prio);

	curr->rcub_rbdp = NULL;

	spin_unlock(&curr->pi_lock);
  out:
	spin_unlock_irqrestore(&rbd->rbs_lock, flags);
}

With them and all other trace_mark() calls commented out, the latency is
still OK. The first one has a bigger impact.

In 2.6.25.8-rt7, trace_mark() is not used any more but a function
incrementing the corresponding counter directly and I suspect that's the
reason why I'm seeing high latencies with both, CONFIG_RCU_TRACE enabled
and disabled.

I hope this observation sheds some light on the issue.

Wolfgang.



