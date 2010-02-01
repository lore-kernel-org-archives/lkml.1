Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab0BAQLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 11:11:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61586 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab0BAQLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 11:11:16 -0500
X-Authority-Analysis: v=1.0 c=1 a=db5xdBbprZYA:10 a=7U3hwN5JcxgA:10 a=pqIW2NmFQo7CwtVP8qEA:9 a=91nSzJVcyDCEN9GyaakA:7 a=LRWyCQvA1xQhBxc1A-zk2fwusfsA:4
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
In-Reply-To: <alpine.LFD.2.00.1002010722350.4206@localhost.localdomain>
References: <20100131205254.407214951@polymtl.ca>
	 <20100131210013.446503342@polymtl.ca>
	 <alpine.LFD.2.00.1002010722350.4206@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 01 Feb 2010 11:11:09 -0500
Message-ID: <1265040669.29013.42.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 07:27 -0800, Linus Torvalds wrote:

> So what are these magical memory barriers all about?

Mathieu is implementing userspace RCU. In order to make the
rcu_read_locks() fast, they can not be calling memory barriers. What is
needed is on the synchronize_rcu() the writer has to force a mb() on all
CPUs running one of the readers.

The first simple approach that Mathieu made, was to simply send an IPI
to all CPUs and force the mb() to be made. But this lets one process
interfere with other processes needlessly. And us Real-Time folks balked
at the idea since it would allow any process to mess with the running of
a real-time thread.

The next approach was to use the mm_cpumask of the thread and only send
IPIs to the CPUs that are running the thread. But there's a race between
the update of the mm_cpumask and the scheduling of the task. If we send
an IPI to a CPU that is not running the process's thread, it may cause a
little interference with the other thread but nothing to worry about.

The issue is if we miss sending to a process's thread. Then the reader
could be accessing a stale pointer that the writer is modifying after
the userspace synchronize_rcu() call.

The taking of the rq locks was a way to make sure that the update of the
mm_cpumask and the scheduling is in sync. And we know that we are
sending an IPI that is running the process's thread and not missing any
other ones.

But all this got a bit ugly when we tried to avoid grabbing the run
queue locks in the loop to send out IPIs. 

Note, I believe that x86 is not affected, since the act of doing the
schedule is in itself a mb(). But this may not be the case on all archs.


-- Steve


