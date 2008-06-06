Return-Path: <linux-kernel-owner+w=401wt.eu-S1760887AbYFFW23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760887AbYFFW23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 18:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbYFFW2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 18:28:19 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40863 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbYFFW2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 18:28:17 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5312"; a="3575190"
Message-ID: <4849B9FA.3090403@qualcomm.com>
Date: Fri, 06 Jun 2008 15:28:10 -0700
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mark Hounschell <dmarkh@cfl.rr.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Oeser <ioe-lkml@rameria.de>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, "Derek L. Fults" <dfults@sgi.com>,
       devik <devik@cdi.cz>, Dimitri Sivanich <sivanich@sgi.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Emmanuel Pacaud <emmanuel.pacaud@univ-poitiers.fr>,
       Frederik Deweerdt <deweerdt@free.fr>, Ingo Molnar <mingo@elte.hu>,
       Matthew Dobson <colpatch@us.ibm.com>, rostedt@goodmis.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Paul Menage <menage@google.com>, "Randy.Dunlap" <rddunlap@osdl.org>,
       suresh.b.siddha@intel.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may
 have realtime uses)
References: <20080601213019.14ea8ef8.pj@sgi.com>	 <200806030035.58387.ioe-lkml@rameria.de>	 <1212446707.6269.26.camel@lappy.programming.kicks-ass.net>	 <200806031603.40731.nickpiggin@yahoo.com.au> <48466745.5050802@cfl.rr.com>	 <4846EC77.1020900@qualcomm.com> <1212611148.19205.22.camel@lappy.programming.kicks-ass.net> <4847D1B9.3080609@cfl.rr.com>
In-Reply-To: <4847D1B9.3080609@cfl.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Hounschell wrote:
> 
> Thanks for the detailed tutorial Max. I'm personally still very 
> skeptical. I really don't believe you'll ever be able to run multiple
> _demanding_ RT environments on the same machine. Now matter how many 
> processors you've got. But even though I might be wrong there, thats 
> actually OK with me. I, and I'm sure most, don't have a problem with 
> dedicating a machine to a single RT env.
> 
> You've got to hold your tongue just right, look at the right spot on the 
> wall, and be running the RT patched kernel, all at the same time, to run 
> just one successfully. I just want to stop using my tongue and staring 
> at the wall. 

I understand your scepticism but it's quite easy to do these days. Yes there 
are certain restrictions on how RT applications have to be designed, but 
definitely not a rocket science. It can be summed up in a few words:
   "cpu isolation, lock-free communication and memory management,
    and direct HW access"
In other words you want to talk using lock-free queues and mempools between 
soft- and hard- RT components and use something like libe1000.sf.net to talk 
to the outside world.
There are other approaches of course, those involve RT kernels, Xenomai, etc.

As I mentioned awhile ago we (here at Qualcomm) actually implemented full 
blown UMB (one of the 4G broadband technologies) basestation that runs entire 
MAC and part of PHY layers in the user-space using CPU isolation techniques. 
Vanilla 2.6.17 to .24 kernel + cpuisol and off-the-shelf dual-Opteron and 
Core2Duo based machines. We have very very tight deadlines and yet everything 
works just fine. And no we don't have to do any special tong holding or other 
rituals :) for it to work. In fact quite the opposite. I can do full SW 
(kernel, etc) builds and do just about anything else while our basestation 
application is running. Worst case latencies in the RT thread running on the 
isolated CPU is about ~1.5usec.

Now I switched to 8way Core2Quad machines. I can run 7 RT engines on 7 
isolated CPUs and load cpu0. Latencies are a bit higher 5-6 usec (I guessing 
due to shared caches and stuff) but otherwise it works fine.  This is with the 
2.6.25.4-cpuisol2 and syspart (syspart is a set of scripts for setting up 
system partitions). I'll release both either later today or early next week.

So I think you're underestimating the power of Linux and CPU isolation ;-).

> I personally feel that a single easy method of completely 
> isolating a single processor from the rest of the machine _might_ 
> benefit the RT community more than all this fancy stuff coming down the 
> pipe. Something like your original proposed isolcpus or even a simple 
> SCHED_ISOLATE arg to the setschedular call.

Yes it may seem that way. But as I explained in the previous email. In order 
to actually implement something like that we'd need to do reimplement parts of 
the cpusets and cpu hotplug. I'm not sure if you noticed or not but my 
original patch actually relied on the cpu hotplug anyway. Just because it 
makes no sense not to awesome powers of hotplug that can migrate _everything_ 
running on one cpu to an other cpu.
And cpuset.sched_load_balance flag provides equivalent functionality for 
controlling scheduler domains and load balancer.
Other stuff like workqueue have to be dealt with in either case. So what I'm 
getting at is that you get equivalent functionality.

Max





