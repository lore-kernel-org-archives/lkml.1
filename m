Return-Path: <linux-kernel-owner+w=401wt.eu-S1759942AbYBLMjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759942AbYBLMjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 07:39:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbYBLMjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 07:39:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59639 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbYBLMjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 07:39:39 -0500
Date: Tue, 12 Feb 2008 13:38:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v10
Message-ID: <20080212123839.GA15360@elte.hu>
References: <20080211015321.GA27376@one.firstfloor.org> <y0mhcgf4ig1.fsf@ton.toronto.redhat.com> <20080211162141.GA31434@elte.hu> <20080211171039.GA20446@one.firstfloor.org> <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu> <20080212121903.GA419@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212121903.GA419@one.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


i'm glad that there are no other valid-looking (to me) objections left 
against kgdb-light -v10, other than "it would be nice to have more kgdb 
functionality" and "it would be nice to rewrite the parser", right?
:-)

(It seems we do have a fundamental disagreement about how kgdb should 
act: in my opinion it should never break a correct system, while in your 
opinion apparently it's OK to compromise on that to make debugging 
easier. (find below more detailed arguments about this.) If you do not 
change your position about that issue we'll have to agree to disagree 
about that point.)

So unless i forgot about something (please yell if so), it seems to me 
kgdb is now pretty ready for an upstream merge.

here are my replies to the most recent points you brought up [in order 
of how i perceive the topic's importance]:

* Andi Kleen <andi@firstfloor.org> wrote:

> > i went for correctness and simplicity first. If a system is hung, 
> > the debugging CPU might hang too at any time. A timeout on the other 
> > hand introduces the possibility of a 'dead' CPU just coming back to 
> > life after the 'timeout', corrupting debugger data. So for now the 
> > rule is very simple.
> 
> If all code is correct, it likely won't need a debugger. But if you 
> write a debugger you can't assume that.

i gave you very specific technological reasons for why we dont want to 
do spinning for now: we dont _ever_ want to break a correctly working 
system with kgdb.

A valid counter-argument is _not_ to argue "but it would be nice to have 
if the system is broken in X, Y and Z ways" (like you did), but to point 
it out why the behavior we chose is wrong on a correctly working system.

Yes, a buggy system might misbehave in various ways but my primary 
interest is in keeping correctly working systems correct.

And note that kgdb is not just a "debugger", it's a system inspection 
tool. An intelligent, human-controlled printk. A kernel internals 
learning tool. An extension to the kernel console concept. Yes, people 
frequently use it for debugging too, but the other uses are actually 
more important in the big picture than the debugging aspect.

> > i disagree that a kernel debugger should necessarily be a kernel 
> > module. It might be nice at a future stage, but right now it would 
> > just introduce unnecessary complexity.
> 
> The question is less about actually having it as a module, but just if 
> the interfaces are clean enough to allow it as a module. If not you 
> should probably clean them up.

but your contention is simply wrong. Most of our debugging 
infrastructure is non-modular for a good reason. Modularization 
increases complexity and that's exactly the wrong direction for 
debugging code. (especially for a first-level merge like this one)

> > > Whatever that shadowpid is. [...]
> > 
> > GDB wants to track threads, but on the Linux side each idle task has 
> > PID 0, so GDB cannot track them. The shadow PID is this remapped 
> > space.
> 
> Ok, please write that as a comment into the source.

it's already commented in -v10 at several places.

> > no, not all architectures have it. This is a weak alias that is 
> > otherwise not linked into the kernel.
> 
> Can't be very many because oprofile needs it and it works on most 
> archs now. Anyways, the right thing is to just add it to the 
> architectures that still miss it, not reimplement it in kgdb.

it's not reimplemented - kgdb_arch_pc() does not directly map to 
instruction_pointer().

> > The currently submitted code does not try to support user mode 
> > debugging. It might be a nice add-on later, if done cleanly and 
> > correctly enough. If you are interested we welcome patches from you!
> 
> Hmm, I'm pretty sure I saw some code that was only useful for the user 
> case. Perhaps you should take all that out then if it doesn't work 
> anyways?
> 
> a good example is all the code trying to handle user mode mappings.

that's already all taken out in -v10. (if you find any leftovers then 
please cite the code where it isnt - thanks!)

> [...] If kgdb is active it should have priority over crash dumps.

that's the approach we are taking: be as unintrusive as possible. This 
means that the notifier here is registered at the lowest priority. You 
might disagree with it but it's a completely sensible and consistent 
approach.

	Ingo
