Return-Path: <linux-kernel-owner+w=401wt.eu-S1763015AbYBLLnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763015AbYBLLnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 06:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761755AbYBLLnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 06:43:42 -0500
Received: from one.firstfloor.org ([213.235.205.2]:40223 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761556AbYBLLnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 06:43:41 -0500
Date: Tue, 12 Feb 2008 13:19:03 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [git pull] kgdb-light -v10
Message-ID: <20080212121903.GA419@one.firstfloor.org>
References: <20080211015321.GA27376@one.firstfloor.org> <y0mhcgf4ig1.fsf@ton.toronto.redhat.com> <20080211162141.GA31434@elte.hu> <20080211171039.GA20446@one.firstfloor.org> <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212112747.GA1569@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 12:27:47PM +0100, Ingo Molnar wrote:
> > > +	return pid_max + raw_smp_processor_id();
> > 
> > Whatever that shadowpid is. [...]
> 
> GDB wants to track threads, but on the Linux side each idle task has PID 
> 0, so GDB cannot track them. The shadow PID is this remapped space.

Ok, please write that as a comment into the source.

> 
> > That wrapper should not be needed; everybody can use 
> > instruction_pointer() directly, no?
> 
> no, not all architectures have it. This is a weak alias that is 
> otherwise not linked into the kernel.

Can't be very many because oprofile needs it and it works on most archs now.
Anyways, the right thing is to just add it to the architectures
that still miss it, not reimplement it in kgdb.
 
> > > +		if (user_mode(regs))
> > > +			return NOTIFY_DONE;
> > 
> > That seems weird. I think other parts try to support user mode 
> > debugging too. In theory there is no reason it shouldn't be able to do 
> > this (except that you have to make sure to not break regular gdb of 
> > course)
> 
> The currently submitted code does not try to support user mode 
> debugging. It might be a nice add-on later, if done cleanly and 
> correctly enough. If you are interested we welcome patches from you!

Hmm, I'm pretty sure I saw some code that was only useful for the
user case. Perhaps you should take all that out then if it doesn't
work anyways?

a good example is all the code trying to handle user mode mappings.

> 
> > > +	/*
> > > +	 * Lowest-prio notifier priority, we want to be notified last:
> > > +	 */
> > > +	.priority	= -INT_MAX,
> > 
> > This means kcrash will have priority won't it? Doesn't seem correct.
> 
> yes, this means if the user has configured kcrash as well then that will 
> have priority over kgdb. This is the intended behavior.

Seems wrong intended behaviour to me. If kgdb is active it should have priority
over crash dumps.

> 
> > First nobody answered the "kgdb clean enough for a module" high level 
> > question yet. Is it good enough for that?
> 
> i disagree that a kernel debugger should necessarily be a kernel module. 
> It might be nice at a future stage, but right now it would just 
> introduce unnecessary complexity.

The question is less about actually having it as a module, but 
just if the interfaces are clean enough to allow it as a module.
If not you should probably clean them up.


> > > more NR_CPUS spinlocks, there's now proper use of barriers, etc. No 
> > > more silly "timeouts" for locking either ... There's now a very 
> > > well-defined
> > 
> > A timeout for waiting for other CPUs is actually not a bad idea for a 
> > debugger. After all you still want to debug even if some other CPUs 
> > are dead.
> 
> i went for correctness and simplicity first. If a system is hung, the 

If all code is correct, it likely won't need a debugger.
But if you write a debugger you can't assume that.

> debugging CPU might hang too at any time. A timeout on the other hand 


> corrupting debugger data. So for now the rule is 
> very simple.
> 
> timeouts might be an optional "would be nice" feature for later on.

Ok it just makes kgdb useless for a wide range of kernel problems.
Hung CPUs are not that uncommon in my experience.


> 
> > > previously Mark indicated some sort of sprintf return value breakage 
> > > he observed, and kgdb would rely on sprintf return values so i'm 
> > > inclined to leave it as-is. We can fix that later, it's not 
> > > critical.
> > 
> > Pretty much all the proc output and sysfs show functions rely on these 
> > return values, so if there is a problem it is likely very obscure.
> 

> relies on it mostly for user-space "this many bytes were processed" 
> return values and those values are often wrong and user-space just 
> handles it gratiously.

If the return value of read() is wrong not even cat(1) will work
correctly, but lose bytes.

You're saying cat is not supposed to work on /proc? That's certainly
not my experience from many years of successfull cat /proc/... use.

> 
> Anyway, the presence of a few special parsers that impact nothing else 
> but kgdb is not even close to being a merge showstopper, it is something 
> that can be consolidated later on. We've already got 7 instances of KGDB 
> code in the upstream kernel:
> 
>   ./sparc/kernel/sparc-stub.c
>   ./cris/arch-v32/kernel/kgdb.c
>   ./cris/arch-v10/kernel/kgdb.c
>   ./mips/kernel/gdb-stub.c
>   ./frv/kernel/gdb-stub.c
>   ./mn10300/kernel/gdb-stub.c
>   ./ppc/kernel/ppc-stub.c
> 
> so obviously these parsers work in practice.

Sure a lot of ugly code works in practice. If it's clean and maintaintable 
code is another question of course.

-Andi

