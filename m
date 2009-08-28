Return-Path: <linux-kernel-owner+w=401wt.eu-S1752045AbZH1KIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbZH1KIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 06:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbZH1KIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 06:08:17 -0400
Received: from www.tglx.de ([62.245.132.106]:41852 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbZH1KIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 06:08:16 -0400
Date: Fri, 28 Aug 2009 12:05:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: raz ben yehuda <raziebe@gmail.com>
cc: Chris Friesen <cfriesen@nortel.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       peterz@infradead.org, maximlevitsky@gmail.com, efault@gmx.de,
       riel@redhat.com, wiseman@macs.biu.ac.il, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
In-Reply-To: <1251448697.3872.15.camel@raz>
Message-ID: <alpine.LFD.2.00.0908281057070.2888@localhost.localdomain>
References: <1251282598.3514.20.camel@raz>  <alpine.DEB.1.10.0908260943090.9924@gentwo.org>  <1251297910.1791.22.camel@maxim-laptop> <1251298443.4791.7.camel@raz>  <1251300625.18584.18.camel@twins>  <alpine.DEB.1.10.0908261136590.9933@gentwo.org> 
 <1251302598.18584.31.camel@twins>  <alpine.DEB.1.10.0908261211340.9933@gentwo.org>  <20090826180407.GA13632@elte.hu>  <alpine.DEB.1.10.0908261509580.9933@gentwo.org>  <20090826193252.GA14721@elte.hu>  <alpine.DEB.1.10.0908261627110.5554@gentwo.org> 
 <20090826135041.e6169d18.akpm@linux-foundation.org>  <4A95A5EE.90400@nortel.com> <1251322663.3882.48.camel@raz>  <4A96B997.1070001@nortel.com> <1251408785.3700.22.camel@raz>  <alpine.LFD.2.00.0908272348370.2888@localhost.localdomain>
 <1251448697.3872.15.camel@raz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Aug 2009, raz ben yehuda wrote:
> On Fri, 2009-08-28 at 00:05 +0200, Thomas Gleixner wrote:
> > This is totally irrelevant and we all know how communication channels
> > between Linux and whatever hackery (RT-Linux, RTAI, ... OFFLINE)
> > works.
>
> Why are you referring to the above projects as hacks ? What is a hack ?

Everything which works around the real problem instead of solving it.

> > > 2. know **exactly*** how much each single packet transmission costs. for
> > > example, in this case in processor 3 a single packet average
> > > transmission is 1974tscs, which is ~700ns.
> > > 
> > > 3. know how many packets fails to transmit right **on time** ( the Lates
> > > counter) . and on time in this case means within the 122us jitter. 
> > 
> > Are those statistics a crucial property of your OFFLINE thing ?

> yes. latency is a crucial property. 

You are not answering my quesiton.

Also reducing latencies is something we want to do in the kernel
proper in the first place. We all know that you can reduce the
latencies by taking control away from the kernel and running a side
show. But that's nothing new. It has been done for decades already and
none of these projects has ever improved the kernel itself.

> > > 4. There are 8 cores in this machine. The rest 4 OS cores are ~95% idle.
> > > The only resource these cores share is the bus. 
> > 
> > That does not change the problem that you cannot run ordinary user
> > space tasks on your offlined CPUs and you are simply hacking round the
> > real problem which I outlined in my previous mail.
>
> OFFSCHED is not just about RT. it is about assigning assignments to
> another resource outside the operating system. very much like GPUs,
> network processors, and so on, but just with software that is
> accessible to the OS.

I was not talking about RT. I was talking about the problem that you
cannot run an ordinary user space task on your offlined CPU. That's
the main point where the design sucks. Having specialized programming
environments which impose tight restrictions on the application
programmer for no good reason are horrible.

Also how are GPUs, network processors related to my statements ?
Running specialized software on dedicated hardware which is an addon
to the base system controlled by the kernel is not new. There are
enough real world applications running Linux on the main CPU and some
extra code on an add on DSP or whatever. Cell/SPU or the TI ARM/DSP
combos are just the most obvious examples which come to my mind. Where
is the point of OFFSCHED here ?

In your earlier mails you talked about isolating cores of the base
system by taking the control away from the kernel and what a wonderful
solution this is because it allows you full control over that core.

We can dedicate a core to special computations today and we can assign
resources of any kind to it under the full control of the OS. The only
disturbing factor is the scheduler tick.

So you work around the scheduler tick problem by taking the core away
from the OS. That does not solve the problem, it simply introduces a
complete set of new problems:

 - accounting of CPU utilization excludes the offlined core

 - resource assignment is restricted to startup of the application

 - standard admin tools (top, ps ....) are not working

 - unnecessary restrictions for the application programmer:
    - no syscalls
    - no standard IPC
    - ....

 - debugging of the code which runs on the offlined core needs
   separate tools

 - performance analysis e.g. with profiling/performance counters
   cannot use the existing mechanisms

 - ....

Thanks,

	tglx
