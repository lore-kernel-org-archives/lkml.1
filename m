Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab0BAWjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 17:39:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62010 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab0BAWjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 17:39:37 -0500
X-Authority-Analysis: v=1.0 c=1 a=db5xdBbprZYA:10 a=7U3hwN5JcxgA:10 a=YkSDifU1gXK-aRBgPeUA:9 a=H04GxZ2O2qJ7LUxZY9wA:7 a=Tssdwk12KuY6KjcuGjgYL25RUu8A:4 a=QEwfpn6c3qog5Yvc:21 a=CPFjeTQyZE6CtRFQ:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [patch 2/3] scheduler: add full memory barriers upon task
 switch at runqueue lock/unlock
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
In-Reply-To: <alpine.LFD.2.00.1002011244020.4206@localhost.localdomain>
References: <20100131205254.407214951@polymtl.ca>
	 <20100131210013.446503342@polymtl.ca>
	 <alpine.LFD.2.00.1002010722350.4206@localhost.localdomain>
	 <20100201160929.GA3032@Krystal>
	 <alpine.LFD.2.00.1002010816030.4206@localhost.localdomain>
	 <20100201164856.GA3486@Krystal>
	 <alpine.LFD.2.00.1002010854110.4206@localhost.localdomain>
	 <20100201174500.GA13744@Krystal>
	 <alpine.LFD.2.00.1002011028190.4206@localhost.localdomain>
	 <1265056389.29013.126.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.1002011244020.4206@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 01 Feb 2010 17:39:33 -0500
Message-ID: <1265063973.29013.336.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 12:52 -0800, Linus Torvalds wrote:
> 
> On Mon, 1 Feb 2010, Steven Rostedt wrote:
> > 
> > But a race exists between the reading of the mm_cpumask and sending the
> > IPI. There is in fact two different problems with this race. One is that
> > a thread scheduled away, but never issued an mb(), the other is that a
> > running task just came in and we never saw it.
> 
> I get it. But the thing I object to here is that Mathieu claims that we 
> need _two_ memory barriers in the switch_mm() code.

Note, on x86, we don't need two memory barriers, because the cr3 load
acts as one, and the set_bit() acts as the other.

> 
> And I'm still not seeing it.
> 
> You claim that the rule is that "you have to do a mb on all threads", and 
> that there is a race if a threads switches away just as we're about to do 
> that.
> 
> Fine. But why _two_? And what's so magical about the mm_cpumask that it 
> needs to be around it?
> 
> If the rule is that we do a memory barrier as we switch an mm, then why 
> does that single one not just handle it? Either the CPU kept running that 
> mm (and the IPI will do the memory barrier), or the CPU didn't (and the 
> switch_mm had a memory barrier).

The one before the mm_cpumask actually does the mb() that we want to
send, in case we miss it. We use mm_cpumask just to limit our sending of
mb()s to CPUs. The unlikely case that we miss a thread, this mb() will
perform the work mb() for us.

	   CPU 0		   CPU 1
	-----------		-----------
				< same thread >
				clear_bit(mm_cpumask)

	sys_membarrier();
	<miss sending CPU 1 mb()>
	return back to user-space

	modify data

				< CPU 0 data is read > <<- corruption

				schedule()



Earlier you asked what is the three things the two mb()'s are
protecting. Actually, it is really just two things that can be accessed
in:
	 A
	mb();
	 B
	mb();
	 A

Where, we access A then B and then A again, and need to worry about that
ordering. The two things are, the mm_cpumask and the second thing is the
user-space data that the sys_membarrier() is guaranteeing will be
flushed when it returns.


If we add a mb() before the clearing of the cpu bit in the mm_cpumask(),
we don't care if we get an old value that does not contain a missing cpu
that is running one of the process's threads. Because the mb() would
have made all the necessary data of the thread visible, and no other
mb() is needed.


The mb() after the set bit makes sure the mask is visible for this:

	   CPU 0		   CPU 1
	-----------		-----------
				set_bit();
				schedule();
				return to userspace and access
				 critical data

	sys_membarrier();
	miss sending IPI.
	return;

	update critical data



I guess the simple answer is that the first mb() is doing the mb() we
missed. The second mb() makes sure that a thread does not get back to
userspace without the sys_membarrier() seeing it.

> 
> Without locking, I don't see how you can really have any stronger 
> guarantees, and as per my previous email, I don't see what the smp_mb() 
> around mm_cpumask accesses help - because the other CPU is still not going 
> to atomically "see the mask and IPI". It's going to see one value or the 
> other, and the smp_mb() around the access doesn't seem to have anything to 
> do with which value it sees.

I guess you can say we are cheating here. If we miss the mm_cpumask
update, the only time it is an issue for us is if one of our threads
scheduled out. We use the mb() there to perform the mb() that we missed.
We really don't care about the mm_cpumask, but we do care that a mb() is
performed.


> 
> So I can kind of understand the "We want to guarantee that switching MM's 
> around wants to be a memory barrier". Quite frankly, I haven't though even 
> that through entirely, so who knows... But the "we need to have memory 
> barriers on both sides of the bit setting/clearing" I don't get. 
> 
> IOW, show me why that cpumask is _so_ important that the placement of the 
> memory barriers around it matters, to the point where you want to have it 
> on both sides.

Actually the cpumask is not as important as the mb(). We use the cpumask
to find out what CPUs we need to make do a mb(), and the mb() before the
cpumask is in the case we miss one that is caused by the race.

> 
> Maybe you've really thought about this very deeply, but the explanations 
> aren't getting through to me. Educate me.

The issues is that sys_membarrier() is guaranteeing that all the other
threads of the process will have a mb() performed before the
sys_membarrier() returns. We only care about the user-space data of the
threads, thus the mb() here is quite unique. We are using the mm_cpumask
as a short cut to sending a mb() to only the CPUs that are running our
threads.

The mb() before the mm_cpumask() is to make sure that the thread does a
mb() in case we miss it when reading the mm_cpumask().

The mb() after the mm_cpumask() is to make sure that the cpumask is
visible before the thread reads any data in user-space, so that the
sys_membarrier() will send out the IPI() to that thread.

For x86 these are a not an issues because clear_bit() is an mb() and so
is the load_cr3().

Now if other arch maintainers do not want to add two mb()s in
switch_mm(), then perhaps if they just guarantee that one exists after
the clear/set bits, the following code may work:

(posted in a previous email)

sys_membarrier(void) {

	again:
		tmp_mask = mm_cpumask(current->mm);
		smp_mb();
		rcu_read_lock(); /* ensures validity of cpu_curr(cpu) tasks */
		for_each_cpu(cpu, tmp_mask) {
			spin_lock_irq(&cpu_rq(cpu)->lock);
			ret = current->mm == cpu_curr(cpu)->mm;
			spin_unlock_irq(&cpu_rq(cpu)->lock);
			if (ret)
			smp_call_function_single(cpu, membarrier_ipi, NULL, 1);
		}
		rcu_read_unlock();
		smp_mb();
		if (tmp_mask != mm_cpumask(current->mm)) {
			/* do check for signals here */
			goto again;
		}

Maybe even the locks are not needed.

-- Steve


