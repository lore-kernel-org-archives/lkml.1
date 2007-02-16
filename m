Return-Path: <linux-kernel-owner+w=401wt.eu-S964773AbXBPMcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964773AbXBPMcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 07:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964781AbXBPMcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 07:32:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55456 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964773AbXBPMcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 07:32:31 -0500
Date: Fri, 16 Feb 2007 13:28:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/11] syslets: core code
Message-ID: <20070216122806.GA27455@elte.hu>
References: <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org> <20070215133550.GA29274@2ka.mipt.ru> <Pine.LNX.4.64.0702150757520.20368@woody.linux-foundation.org> <20070215163704.GA32609@2ka.mipt.ru> <Pine.LNX.4.64.0702150920130.20368@woody.linux-foundation.org> <20070215181059.GC20997@2ka.mipt.ru> <Pine.LNX.4.64.0702151019210.20368@woody.linux-foundation.org> <20070215190413.GA23953@2ka.mipt.ru> <Pine.LNX.4.64.0702151120260.20368@woody.linux-foundation.org> <Pine.LNX.4.64.0702151159410.20368@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702151159410.20368@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 15 Feb 2007, Linus Torvalds wrote:
> > 
> > So I think that a good implementation just does everything up-front, 
> > and doesn't _need_ a user buffer that is live over longer periods, 
> > except for the actual results. Exactly because the whole 
> > alloc/teardown is nasty.
> 
> Btw, this doesn't necessarily mean "not supporting multiple atoms at 
> all".
> 
> I think the batching of async things is potentially a great idea. I 
> think it's quite workable for "open+fstat" kind of things, and I agree 
> that it can solve other things too (the 
> "socket+bind+connect+sendmsg+rcv" kind of complex setup things).
> 
> But I suspect that if we just said:
>  - we limit these atom sequences to just linear sequences of max "n" ops
>  - we read them all in in a single go at startup
>
> we actually avoid several nasty issues. Not just the memory allocation 
> issue in user space (now it's perfectly ok to build up a sequence of 
> ops in temporary memory and throw it away once it's been submitted), 
> but also issues like the 32-bit vs 64-bit compatibility stuff (the 
> compat handlers would just convert it when they do the initial 
> copying, and then the actual run-time wouldn't care about user-level 
> pointers having different sizes etc).
> 
> Would it make the interface less cool? Yeah. Would it limit it to just 
> a few linked system calls (to avoid memory allocation issues in the 
> kernel)? Yes again. But it would simplify a lot of the interface 
> issues.
> 
> It would _also_ allow the "sys_aio_read()" function to build up its 
> *own* set of atoms in kernel space to actually do the read, and there 
> would be no impact of the actual run-time wanting to read stuff from 
> user space. Again - it's actually the same issue as with the compat 
> system call: by making the interfaces do things up-front rather than 
> dynamically, it becomes more static, but also easier to do interface 
> translations. You can translate into any arbitrary internal format 
> _once_, and be done with it.
> 
> I dunno.

[ hm. I again wrote a pretty long email for you to read. Darn! ]

regarding the API - i share most of your concerns, and it's all a 
function of how widely we want to push this into user-space.

My initial thought was for syslets to be used by glibc as small, secure 
kernel-side 'syscall plugins' mainly - so that it can do things like 
'POSIX AIO signal notifications' (which are madness in terms of 
performance, but which applications rely on) /without/ having to burden 
the kernel-side AIO with such requirements: glibc just adds an enclosing 
sys_kill() to the syslet and it will do the proper signal notification, 
asynchronously. (and of course syslets can be used for the Tux type of 
performance sillinesses as well ;-)

So a sane user API (all used at the glibc level, not at application 
level) would use simple syslets, while more broken ones would have to 
use longer ones - but nobody would have the burden of having to 
synchronize back to the issuer context. Natural selection will gravitate 
application use towards the APIs with the shorter syslets. (at least so 
i hope)

In this model syslets arent really user-programmable entities but rather 
small plugins available to glibc to build up more complex, more 
innovative (or just more broken) APIs than what the kernel wants to 
provide - without putting any true new ABI dependency on the kernel, 
other than the already existing syscall ABIs.

But if we'd like glibc to provide this to applications in some sort of 
standardized /programmable/ manner, with a wide range of atom selections 
(not directly coded syscall numbers, but rather as function pointers to 
actual glibc functions, which glibc could translate to syscall numbers, 
argument encodings, etc.), then i agree that doing the compat things and 
making it 32/64-bit agnostic (and much more) is pretty much a must. If 
90% of this current job is finished then sorting those out will at least 
be another 90% of the work ;-)

and actually this latter model scares me, and i think that model scared 
the hell out of you as well.

But i really have no strong opinion about which one we want yet, without 
having walked the path. Somewhere inside me i'd of course like syslets 
to become a widely available interface - but my fear is that it might 
just not be 'human' enough to make sense - and we'd just not want to tie 
us down with an ABI that's not used. I dont want this to become another 
sys_sendfile - much talked about and _almost_ useful but in practice 
seldom used due to its programmability and utility limitations.

OTOH, the syslet concept right now already looks very ubiquitous, and 
the main problem with AIO use in applications wasnt just even its broken 
API or its broken performance, but the fundamental lack of all Linux IO 
disciplines supporting AIO, and the lack of significantly parallel 
hardware. We have kaio that is centered around block drivers - then we 
have epoll that works best with networking, and inotify that deals with 
some (but not all) VFS events - but neither supports every IO and event 
disciple well, at once. My feeling is that /this/ is the main 
fundamental problem with AIO in general, not just its programmability 
limitations.

Right now i'm concentrating on trying to build up something on the 
scheduling side that shows the issues in practice, shows the limitations 
and shows the possibilities. For example the easy ability to turn a 
cachemiss thread back into a user thread (and then back into a cachemiss 
thread) was a true surprise to me which increased utility quite a bit. I 
couldnt have designed it into the concept because it just didnt occur to 
me in the early stages. The notification ring related limitations you 
noticed is another important thing to fix - and these issues go to the 
core scheduling model of the concept and affect everything.

Thirdly, while Tux does not matter much to us, at least to me it is 
pretty clear what it takes to get performance up to the levels of Tux - 
and i dont see any big fundamental compromise possible on that front. 
Syslets are partly Tux repackaged into something generic - they are 
probably a bit slower than straight kernel code Tux, but not by much and 
it's also not behaving fundamentally differently. And if we dont offer 
at least something close to those possibilities then people will 
re-start trying to add those special-purpose state machine APIs again, 
and the whole "we need /true/ async IO" game starts again.

So if we accept "make parallelism easier to program" and "get somewhat 
close to Tux's performance and scalability" as a premise (which you 
might not agree with in that form), then i dont think there's much 
choice we have: either we use kernel threads, synchronous system calls 
and the scheduler intelligently (and the scheduling/threading bits of 
syslets are pretty much the most intelligent kernel thread based 
approach i can imagine at the moment =B-) or we use a special-purpose 
KAIO state machine subsystem, avoiding most of the existing synchronous 
infrastructure, painfully coding it into every IO discipline - and this 
will certainly haunt us until the end of times.

So that's why i'm not /that/ much worried about the final form of the 
API at the moment - even though i agree that it is /the/ most important 
decision factor in the end: i see various unavoidable externalities 
forcing us very much, and in the end we either like the result and make 
it available to programmers, or we dont, and limit it to system-glue 
glibc use - or we throw it away altogether. I'm curious about the end 
result even if it gets limited or gets thrown away (joining 4:4 on the 
way to the bit bucket ;) and while i'm cautiously optimistic that 
something useful can come out of this, i cannot know it for sure at the 
moment.

	Ingo
