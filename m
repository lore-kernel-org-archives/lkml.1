Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbZFVN4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbZFVN4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 09:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbZFVN4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 09:56:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54242 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbZFVN4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 09:56:44 -0400
Date: Mon, 22 Jun 2009 15:56:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: eranian@gmail.com, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: I.1 - System calls - ioctl
Message-ID: <20090622135611.GA5329@elte.hu>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com> <20090622114931.GB24366@elte.hu> <20090622125837.GA9429@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622125837.GA9429@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Jun 22, 2009 at 01:49:31PM +0200, Ingo Molnar wrote:
> > > How do you justify your usage of ioctl() in this context?
> > 
> > We can certainly do a separate sys_perf_counter_ctrl() syscall - 
> > and we will do that if people think the extra syscall slot is 
> > worth it in this case.
> > 
> > The (mild) counter-argument so far was that the current ioctls 
> > are very simple over "IO" attributes of counters:
> > 
> >  - enable
> >  - disable
> >  - reset
> >  - refresh
> >  - set-period
> > 
> > So they could be considered 'IO controls' in the classic sense 
> > and act as a (mild) exception to the 'dont use ioctls' rule.
> > 
> > They are not some weird tacked-on syscall functionality - they 
> > modify the IO properties of counters: on/off, value and rate. If 
> > they go beyond that we'll put it all into a separate syscall and 
> > deprecate the ioctl (which will have a relatively short 
> > half-time due to the tools being hosted in the kernel repo).
> > 
> > This could happen right now in fact, if people think it's worth it.
> 
> Yet another multiplexer doesn't buy as anything over ioctls unless 
> it adds more structure.  
> PERF_COUNTER_IOC_ENABLE/PERF_COUNTER_IOC_DISABLE/ 
> PERF_COUNTER_IOC_RESET are calls without any argument, so it's 
> kinda impossible to add more structure.  perf_counter_refresh has 
> an integer argument, and perf_counter_period aswell (with a 
> slightly more complicated calling convention due to passing a 
> pointer to the 64bit integer).  I don't see how moving this to 
> syscalls would improve things.

Yes - this is what kept us from moving it until now. But we are 
ready and willing to add a sys_perf_counter_chattr() syscall to 
change attributes. We are in the 'avoid ioctls' camp, but we are
not dogmatic about that. As you seem to agree this seems to be one 
of the narrow special cases where ioctls still make sense.

There _is_ another, more theoretical argument in favor of 
sys_perf_counter_chattr(): it is quite conceivable that as usage of 
perfcounters expands we want to change more and more attributes. So 
even though right now the ioctl just about manages to serve this 
role, it would be more future-proof to use sys_perf_counter_chattr() 
and deprecate the ioctl() straight away - to not even leave a 
_chance_ for some ioctl crap to seep into the API.

So ... we are on two minds about this, and if people dont mind a 
second syscall entry, we are glad to add it.

> But talking about syscalls the sys_perf_counter_open prototype is 
> really ugly - it uses either the pid or cpu argument which is a 
> pretty clear indicator it should actually be two sys calls.
> 
> Incomplete patch without touching the actuall wire-up below to 
> demonstrate it:

Dunno, not sure i agree here. 'CPU ID' is a pretty natural expansion 
of the usage of 'scope of counter'. The scope can be:

  - task-self
  - specific PID
  - specific PID with inheritance
  - specific CPU

It is not really 'multiplexing' completely unrelated things: a CPU 
is 'all PIDs running on a specific CPU' specifier. It is providing 
an expanded definition of 'target context to be monitored'. Just 
like signals have PID, group-PID and controlling-terminal type of 
extensions. We dont really have syscalls for each of those either.

Also note that the syscall does not have different meanings 
depending on whether it's a CPU counter or a specific-task counter 
or a task-and-all-child-tasks counter. So it is not the ugly kind of 
multiplexing that makes most ioctls such a jumbled mess.

If we were to unroll and expand _all_ such things in our current 
300+ syscalls in the kernel we'd have thousands of syscalls. Do we 
want that? Dunno. No strong feelings - but i dont think our current 
syscalls are unclean, and i dont think we should insist on a model 
that would have resulted in so many syscalls, were this enforced 
from the get go.

Furthermore, having a 'target ID' concept does make it harder to 
expand the range of targets that we might want to monitor. Do we 
want to expand the PID one with a PID-group notion perhaps? Or do we 
want to add IDs for specific VMs perhaps? It does not change the 
semantics, it only changes the (pretty orthogonal and isolated) 
'target context' field's meaning.

Hope this helps,

	Ingo
