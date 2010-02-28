Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031458Ab0B1HHH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 02:07:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36469 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031421Ab0B1HHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 02:07:04 -0500
Date: Sun, 28 Feb 2010 08:06:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, roland@redhat.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, hjl.tools@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next requirements
Message-ID: <20100228070626.GA30750@elte.hu>
References: <20100211195614.886724710@sbs-t61.sc.intel.com>
 <201002271323.14402.rjw@sisk.pl>
 <20100227124710.GA21164@elte.hu>
 <201002272007.43042.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002272007.43042.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Saturday 27 February 2010, Ingo Molnar wrote:
> > 
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > 
> > > > > Lets see.  Over the last 60 days, I have reported 37 build errors.  Of 
> > > > > these, 16 were reported against x86, 14 against ppc, 7 against other 
> > > > > archs.
> > > > 
> > > > So only 43% of them were even relevant on the platform that 95+% of the 
> > > > Linux testers use? Seems to support the points i made.
> > > 
> > > Well, I hope you don't mean that because the majority of bug reporters (vs 
> > > testers, the number of whom is unknown to me at least) use x86, we are free 
> > > to break the other architectures. ;-)
> > 
> > It means exactly that: just like we 'can' break compilation with gcc296, 
> > ancient versions of binutils, odd bootloaders, can break the boot via odd 
> > hardware, etc. When someone uses that architectures then the 'easy' 
> > bugfixes will actually flow in very quickly and without much fuss
> 
> Then I don't understand what the problem with getting them in at the 
> linux-next stage is.  They are necessary anyway, so we'll need to add them 
> sooner or later and IMO the sooner the better.

The problem is the dynamics and resulting (non-)cleanliness of code. We have 
architectures that have been conceptually broken for 5 years or more, but 
still those problems get blamed on the last change that 'causes' the breakage: 
the core kernel and the developers who try to make a difference.

I think your perspective and your opinion is correct, while my perspective is 
real and correct as well - there's no contradiction really. Let me try to 
explain how i see it:

You are working in a relatively well-designed piece of code which interfaces 
to the kernel in sane ways - kernel/power/* et al. You might break the 
cross-builds sometimes, but it's not very common, and in those cases it's 
usually your own fault and you are grateful for linux-next to have caught that 
stupidity. (i hope this a fair summary!)

I am not criticising that aspect of linux-next _at all_ - it's useful and 
beneficial - and i'd like to thank Stephen for all his hard work. Other 
aspects of linux-next useful as well: such as the patch conflict mediation 
role.

But as it happens so often, people tend to talk more about the things that are 
not so rosy, not about the things that work well.

The area i am worried about are new core kernel facilities and their 
development and extension of existing facilities. _Those_ facilities are 
affected by 'many architectures' in a different way from how you experience 
it: often we can do very correct changes to them, which still 'break' on some 
architecture due to _that architecture's conceptual fault_.

Let me give you an example that happened just yesterday. My cross-testing 
found that a change in the tracing infrastructure code broke m32r and parisc.

The breakage:

 /home/mingo/tip/kernel/trace/trace_clock.c:86: error: implicit declaration of function 'raw_local_irq_save'
 /home/mingo/tip/kernel/trace/trace_clock.c:112: error: implicit declaration of function 'raw_local_irq_restore'
 make[3]: *** [kernel/trace/trace_clock.o] Error 1
 make[3]: *** Waiting for unfinished jobs....

Is was 'caused by':

 18b4a4d: oprofile: remove tracing build dependency

In linux-next this would be pinned to commit 18b4a4d, which would have to be 
reverted/fixed.

Where does the _real_ blame lie? Clearly in the M32R and HP/PARISC code: why 
dont they, four years after it has been introduced as a core kernel facility 
in 2006, _still_ not support raw_local_irq_save()?

( A similar situation occured in this very thread a well - before the subject 
  of the thread - so it's a real and present problem. We didnt even get _any_ 
  reaction about that particular breakage from the affected architecture ... )

These situations are magnified by how certain linux-next bugs are reported: 
the 'blame' is put on the new commit that exposes that laggy nature of certain 
architectures. Often the developers even believe this false notion and feel 
guilty for 'having broken' an architecture - often an architecture that has 
not contributed a single core kernel facility _in its whole existence_.

The usual end result is that the path of least resistance is taken: the commit 
is reverted or worked around, while the 'laggy' architecture can continue 
business as usual and cause more similar bugs and hickups in the future ...

I.e. there is extra overhead put on clearly 'good' efforts, while 'bad' 
behavior (parasitic hanging-on, passivity, indifference) is rewarded. 
Rewarding bad behavior is very clearly harmful to Linux in many regards, and i 
speak up when i see it.

So i wish linux-next balanced these things more fairly towards those areas of 
code that are actually useful: if it ignored build breakages that are due to 
architectures being lazy - in fact if it required architectures to _help out_ 
with the development of the kernel.

The majority of build-bugs i see trigger in cross-builds (90% of which i catch 
before they get into linux-next) are of this nature, that's why i raised it in 
such a pointed way. Your (and many other people's) experience will differ - so 
you might see this as an unjustified criticism.

Thanks,

	Ingo
