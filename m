Return-Path: <linux-kernel-owner+w=401wt.eu-S1753115AbZH0VMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbZH0VMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 17:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbZH0VM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 17:12:29 -0400
Received: from www.tglx.de ([62.245.132.106]:50808 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbZH0VM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 17:12:28 -0400
Date: Thu, 27 Aug 2009 23:09:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Lameter <cl@linux-foundation.org>
cc: Chris Friesen <cfriesen@nortel.com>, raz ben yehuda <raziebe@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       peterz@infradead.org, maximlevitsky@gmail.com, efault@gmx.de,
       riel@redhat.com, wiseman@macs.biu.ac.il, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
In-Reply-To: <alpine.DEB.1.10.0908271257270.17470@gentwo.org>
Message-ID: <alpine.LFD.2.00.0908272242500.2888@localhost.localdomain>
References: <1251282598.3514.20.camel@raz>  <alpine.DEB.1.10.0908260943090.9924@gentwo.org>  <1251297910.1791.22.camel@maxim-laptop> <1251298443.4791.7.camel@raz>  <1251300625.18584.18.camel@twins>  <alpine.DEB.1.10.0908261136590.9933@gentwo.org> 
 <1251302598.18584.31.camel@twins>  <alpine.DEB.1.10.0908261211340.9933@gentwo.org>  <20090826180407.GA13632@elte.hu>  <alpine.DEB.1.10.0908261509580.9933@gentwo.org>  <20090826193252.GA14721@elte.hu>  <alpine.DEB.1.10.0908261627110.5554@gentwo.org> 
 <20090826135041.e6169d18.akpm@linux-foundation.org>  <4A95A5EE.90400@nortel.com> <1251322663.3882.48.camel@raz> <4A96B997.1070001@nortel.com> <alpine.DEB.1.10.0908271257270.17470@gentwo.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Aug 2009, Christoph Lameter wrote:
> On Thu, 27 Aug 2009, Chris Friesen wrote:
> 
> > I just went and read the docs.  One of the things I noticed is that it
> > says that the offlined cpu cannot run userspace tasks.  For our
> > situation that's a showstopper, unfortunately.
> 
> It needs to be implemented the right way. Essentially this is a variation
> on the isolcpu kernel boot option. We probably need some syscall to move
> a user space process to a bare metal cpu since the cpu cannot be
> considered online in the regular sense.

It can. It needs to be flagged as reserved for special tasks and you
need a separate mechanism to move and pin a task to such a CPU.

> An isolated cpu can then only execute one process at a time. A process
> would do all initialization and lock itsresources in memory before going
> to the isolated processor. Any attempt to use OS facilities need to cause
> the process to be moved back to a cpu with OS services.

You are creating a "one special case" operation mode which is not
justified in my opinion. Let's look at the problem you want to solve:

  Run exactly one thread on a dedicated CPU w/o any disturbance by the
  scheduler tick.

You can move away anything else than the scheduler tick from a CPU
today already w/o a single line of code change.

But you want to impose restrictions like resource locking and moving
back to another CPU in case of a syscall. What's the purpose of this ?
It does not buy anything except additional complexity.

That's just the wrong approach. All you need is a way to tell the
kernel that CPUx can switch off the scheduler tick when only one
thread is running and that very thread is running in user space. Once
another thread arrives on that CPU or the single thread enters the
kernel for a blocking syscall the scheduler tick has to be
restarted.

It's not rocket science to fix the well known issues of stopping and
eventually restarting the scheduler tick, the CPU time accounting and
some other small details. Such a modification would be of general use
contrary to your proposed solution which is just a hack to solve your
particular special case of operation.

Thanks,

	tglx
