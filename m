Return-Path: <linux-kernel-owner+w=401wt.eu-S1760161AbYHHUlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760161AbYHHUlB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 16:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbYHHUkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 16:40:52 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:49707 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbYHHUkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 16:40:52 -0400
Date: Fri, 8 Aug 2008 13:40:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: recent -git: BUG in free_thread_xstate
Message-ID: <20080808204050.GJ6760@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <19f34abd0807231307y191c0ad7tfab4cda57ee88eb@mail.gmail.com> <20080723203109.GH14380@linux-os.sc.intel.com> <20080801211036.GU14851@linux.vnet.ibm.com> <19f34abd0808081146w22a3e5casd0d1fa15f2384000@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0808081146w22a3e5casd0d1fa15f2384000@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 08:46:21PM +0200, Vegard Nossum wrote:
> On Fri, Aug 1, 2008 at 11:10 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Wed, Jul 23, 2008 at 01:31:09PM -0700, Suresh Siddha wrote:
> >> On Wed, Jul 23, 2008 at 01:07:04PM -0700, Vegard Nossum wrote:
> >> > Hi,
> >> >
> >> > I just got this on c010b2f76c3032e48097a6eef291d8593d5d79a6 (-git from
> >> > yesterday):
> >>
> >> Do you see this in 2.6.26 aswell? I suspect it is coming from post 2.6.26
> >> changes.
> >>
> >> >
> >> > BUG: unable to handle kernel paging request at 00664381
> >> > IP: [<c010b274>] free_thread_xstate+0x4/0x30
> >> ...
> >>
> >> > EIP is at arch/x86/kernel/process.c:36:
> >> >
> >> >         if (tsk->thread.xstate) {
> >> >
> >>
> >> It looks like the kernel stack of that process got corrupted, corrupting the
> >> task pointer in thread_info. Can you send us your config file?
> >
> > I would also like to see the config file.
> 
> Hi,
> 
> I'm sorry for the late reply.
> 
> I copied you because I saw some RCU entry in the stack trace, but it
> is almost definitely not a problem with (core or "leaf") RCU code.
> Sometimes it also happens that people will say "oh, I recognize this
> problem, the patch has been posted here and here", etc.
> 
> It seems to be a problem with either netpoll, netconsole, or the
> 8139too driver. I find a UDP packet in the task_struct slab, and the
> stacktrace with RCU entries come from unrelated, unfortunate callbacks
> that stumbled upon the corruption.
> 
> My config, if you are still interested, can be found here:
> http://userweb.kernel.org/~vegard/bugs/20080724-fork/config
> 
> I don't know if the problem persists with the latest -git, it is now a
> while since I last tested, but I've checked kernels back to 2.6.20, so
> the problem has existed for a long time.

Well, the config shows preemptable RCU, which was my concern at the time,
but there was certainly no preemptable RCU in mainline in 2.6.20, so...

There -was- a bug in 2.6.26 release candidates that would cause RCU
to fail badly on !HOTPLUG_CPU builds due to a failure to initialize,
but that is fixed in 2.6.26 (thank you, Nick!!!).

							Thanx, Paul
