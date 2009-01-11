Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbZAKDoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbZAKDoo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 22:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbZAKDog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 22:44:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55017 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbZAKDof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 22:44:35 -0500
Date: Sun, 11 Jan 2009 04:44:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH] ring_buffer: fix ring_buffer_event_length()
Message-ID: <20090111034425.GC13981@elte.hu>
References: <alpine.DEB.1.10.0901072356480.14345@gandalf.stny.rr.com> <20090107212912.e2903579.akpm@linux-foundation.org> <20090108115530.GA1539@elte.hu> <20090108112628.aa48a3f9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090108112628.aa48a3f9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 8 Jan 2009 12:55:30 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Wed, 7 Jan 2009 23:58:39 -0500 (EST) Steven Rostedt <rostedt@goodmis.org> wrote:
> > > 
> > > >  kernel/trace/ring_buffer.c |    8 +++++++-
> > > 
> > > <looks>
> > > 
> > > heavens, what a lot of inlining.  Looks like something from 1997 :)
> > > 
> > > Prove me wrong!
> > > 
> > > 
> > > From: Andrew Morton <akpm@linux-foundation.org>
> > > 
> > >           text    data     bss     dec     hex filename
> > > before:  11320     228       8   11556    2d24 kernel/trace/ring_buffer.o
> > > after:   10592     228       8   10828    2a4c kernel/trace/ring_buffer.o
> > 
> > You are wrong :-)
> 
> Not.
> 
> > With x86 defconfig and gcc 4.3.2 i get zero change in size:
> 
> With my config and my gcc I see a large change in size.  So those
> `inline' statements in that C file are *wrong*.
> 
> >   kernel/trace/ring_buffer.o:
> > 
> >      text	   data	    bss	    dec	    hex	filename
> >     11485	    228	      8	  11721	   2dc9	ring_buffer.o.before
> >     11485	    228	      8	  11721	   2dc9	ring_buffer.o.after
> > 
> >   md5:
> >      55447563cd459bbb02c6234b2544fcc2  ring_buffer.o.before.asm
> >      55447563cd459bbb02c6234b2544fcc2  ring_buffer.o.after.asm
> > 
> > (i took out the free_page() bit to only measure the inlining)
> > 
> > That is the same with and without CONFIG_OPTIMIZE_INLINING - i.e. recent 
> > GCC gets the inlining right.
> > 
> > Really, we should stop bothering about inlines on the source code level 
> > (the kernel has 20,000 inlines and around 100,000 functions - do we really 
> > want to maintain inlining information on a per function basis?) - and we 
> > should tell the GCC folks when the compiler messes up some detail.
> > 
> > Or if GCC messes up inlining so much in the future that we cannot live 
> > with it, we can go back to "always inline" and manual annotations 
> > again. Or write a new compiler. (the latter is probably less work ;-)
> 
> None of that makes the inline statements in ring_buffer.c less wrong. It 
> says that with some configs and some gcc versions, their damage is 
> lessened.

It's not 'some configs' - it's the "make the kernel smaller via inlining" 
config.

Here's the stats with gcc 4.3.2:

   text  filename
  11502  kernel/trace/ring_buffer.o [always-inline]
  .....
  11466  kernel/trace/ring_buffer.o +optimize-inlining
  11461  kernel/trace/ring_buffer.o +your-patch

i.e. the compiler was able to get within 0.043% of the manual tuning that 
you did - without the need of any patch.

Lets assume you needed 15 minutes to create, test and send that patch. 
ring_buffer.c is 1 file with 2500 lines of code.

In this cycle alone we changed this much kernel code:

   9046 files changed, 1214357 insertions(+), 461447 deletions(-)

Lets assume that you can spend 8 hours a day just to re-validate the 
inlining of that code. Only that - nothing else. It would need ~100 hours 
of your time per kernel cycle (about two weeks if sleep time is counted as 
well) - or two hours per day, just to keep the inlines maintained.

The numbers are probably far worse for non-akpm coders and if we count the 
inefficiency of distributing this amongst many coders who dont generally 
do this kind of activities.

And that's for something that can be done by a tool to within ~0.043% 
efficiency.

Is it really worth the trouble? Is the payoff proportional? Is it a wise 
use of development resources?

( And i've applied your patch of course - it's a good patch - i'm just
  asking whether we humans should be in the business of inline 
  annotations. )

	Ingo
