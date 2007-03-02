Return-Path: <linux-kernel-owner+w=401wt.eu-S1030471AbXCBVsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030471AbXCBVsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 16:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030473AbXCBVsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 16:48:45 -0500
Received: from rwcrmhc14.comcast.net ([216.148.227.154]:38358 "EHLO
	rwcrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030471AbXCBVso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 16:48:44 -0500
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Mar 2007 16:48:44 EST
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
From: Nicholas Miell <nmiell@comcast.net>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703021246380.2381@alien.or.mcafeemobile.com>
References: <20070301133018.GB30177@2ka.mipt.ru>
	 <200703011519.20001.dada1@cosmosbay.com> <20070301141637.GA20006@elte.hu>
	 <20070301145454.GB12684@2ka.mipt.ru> <20070301150942.GA26025@elte.hu>
	 <20070301153655.GB8217@2ka.mipt.ru> <20070302105713.GB15576@elte.hu>
	 <Pine.LNX.4.64.0703020928580.1977@alien.or.mcafeemobile.com>
	 <20070302193941.GB8450@elte.hu>
	 <Pine.LNX.4.64.0703021212140.2381@alien.or.mcafeemobile.com>
	 <20070302202931.GA5101@elte.hu>
	 <Pine.LNX.4.64.0703021246380.2381@alien.or.mcafeemobile.com>
Content-Type: text/plain
Date: Fri, 02 Mar 2007 13:43:40 -0800
Message-Id: <1172871820.2999.22.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-02 at 12:53 -0800, Davide Libenzi wrote:
> On Fri, 2 Mar 2007, Ingo Molnar wrote:
> 
> > 
> > * Davide Libenzi <davidel@xmailserver.org> wrote:
> > 
> > > I think that the "dirty" FPU context must, at least, follow the new 
> > > head. That's what the userspace sees, and you don't want an async_exec 
> > > to re-emerge with a different FPU context.
> > 
> > well. I think there's some confusion about terminology, so please let me 
> > describe everything in detail. This is how execution goes:
> > 
> >   outer loop() {
> >       call_threadlet();
> >   }
> > 
> > this all runs in the 'head' context. call_threadlet() always switches to 
> > the 'threadlet stack'. The 'outer context' runs in the 'head stack'. If, 
> > while executing the threadlet function, we block, then the 
> > threadlet-thread gets to keep the task (the threadlet stack and also the 
> > FPU), and blocks - and we pick a 'new head' from the thread pool and 
> > continue executing in that context - right after the call_threadlet() 
> > function, in the 'old' head's stack. I.e. it's as if we returned 
> > immediately from call_threadlet(), with a return code that signals that 
> > the 'threadlet went async'.
> > 
> > now, the FPU state that was when the threadlet blocked is totally 
> > meaningless to the 'new head' - that FPU state is from the middle of the 
> > threadlet execution.
> 
> For threadlets, it might be. Now think about a task wanting to dispatch N 
> parallel AIO requests as N independent syslets.
> Think about this task having USEDFPU set, so the FPU context is dirty.
> When it returns from async_exec, with one of the requests being become 
> sleepy, it needs to have the same FPU context it had when it entered, 
> otherwise it won't prolly be happy.
> For the same reason a schedule() must preserve/sync the "prev" FPU 
> context, to be reloaded at the next FPU fault.

The point Ingo was making is that the x86 ABI already requires the FPU
context to be saved before *all* function calls.

Unfortunately, this isn't true of other ABIs -- looking over the psABIs
specs I have laying around, AMD64, PPC64, and MIPS require at least part
of the FPU state to be preserved across function calls, and I'm sure
this is also true of others.

Then there's the other nasty details of new thread creation --
thankfully, the contents of the TLS isn't inherited from the parent
thread, but it still needs to be initialized; not to mention all the
other details involved in pthread creation and destruction.

I don't see any way around the pthread issues other than making a libc
upcall on return from the first system call that blocked.

-- 
Nicholas Miell <nmiell@comcast.net>

