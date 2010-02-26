Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab0BZFhI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 00:37:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33110 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab0BZFhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 00:37:06 -0500
X-Authority-Analysis: v=1.0 c=1 a=r_nf4N-T2GkA:10 a=7U3hwN5JcxgA:10 a=pp3GDLX6lBhAKWYCbYoA:9 a=WJx6ROYrGfmbUC9MM9Cck62r65wA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC patch] introduce sys_membarrier(): process-wide memory
 barrier (v9)
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Nick Piggin <npiggin@suse.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Chris Friesen <cfriesen@nortel.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
In-Reply-To: <20100226050811.GF9738@laptop>
References: <20100212224606.GA30280@Krystal> <4B82CF1A.3010501@nortel.com>
	 <20100222212321.GA2573@Krystal> <20100224091052.GY9738@laptop>
	 <20100224152251.GA16295@Krystal> <20100225053310.GA9738@laptop>
	 <20100225165301.GF24052@Krystal>  <20100226050811.GF9738@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 26 Feb 2010 00:37:01 -0500
Message-ID: <1267162621.6328.108.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-26 at 16:08 +1100, Nick Piggin wrote:
> On Thu, Feb 25, 2010 at 11:53:01AM -0500, Mathieu Desnoyers wrote:

> > This is actually what I did in v1 of the patch, but this implementation met
> > resistance from the RT people, who were concerned about the impact on RT tasks
> > of a lower priority process doing lots of sys_membarrier() calls. So if we want
> > to do other-process-aware sys_membarrier(), we would have to iterate on all
> > cpus, for every running process shared memory maps and see if there is something
> > shared with all shm of the current process. This is clearly not as trivial as
> > just broadcasting the IPI to all cpus.
> 
> I don't see how this is fundamentally worse than your existing approach,
> because on some architectures with asids, the mm_cpumask isn't cleared
> when a process is scheduled off the CPU then you could effectively just
> cause IPIs to lots of CPUs anyway.

That's why checking the mm_cpumask isn't the only check. That just
limits what CPUs we check, but before a IPI is sent, that cpu has its rq
lock held and a check against cpu_curr(cpu)->mm vs the current->mm. If
that fails, then that CPU does not have an IPI sent to it.

-- Steve


