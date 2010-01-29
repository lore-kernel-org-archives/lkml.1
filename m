Return-Path: <linux-kernel-owner+w=401wt.eu-S932187Ab0A2HnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab0A2HnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 02:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009Ab0A2HnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 02:43:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46702 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572Ab0A2HnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 02:43:20 -0500
Date: Fri, 29 Jan 2010 08:42:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kyle Moffett <kyle@moffetthome.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Tom Tromey <tromey@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100129074241.GG14636@elte.hu>
References: <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain>
 <m33a1tnbd9.fsf@fleche.redhat.com>
 <alpine.LFD.2.00.1001251332370.3574@localhost.localdomain>
 <m3636oh2rt.fsf@fleche.redhat.com>
 <alpine.LFD.2.00.1001261535510.17519@localhost.localdomain>
 <1264575134.4283.1983.camel@laptop>
 <20100127085442.GA28422@elte.hu>
 <1264643539.5068.62.camel@localhost.localdomain>
 <20100128085502.GA7713@elte.hu>
 <20100129045546.GA16920@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100129045546.GA16920@in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:

> On Thu, Jan 28, 2010 at 09:55:02AM +0100, Ingo Molnar wrote:
> 
> ...
> 
> > Lets compare the two cases via a drawing. Your current uprobes submission 
> > does:
> > 
> >  [kernel]      do probe thing     single-step trap
> >                ^            |     ^              |
> >                |            v     |              v
> >  [user]     INT3            XOL-ins              next ins-stream
> > 
> >  ( add the need for serialization to make sure the whole single-step thing 
> >    does not get out of sync with reality. )
> > 
> > And emulator approach would do:
> > 
> >  [kernel]      emul-demux-fastpath, do probe thing
> >                ^                                 |
> >                |                                 v
> >  [user]     INT3                                 next ins-stream
> > 
> > far simpler conceptually, and faster as well, because it's one kernel entry.
> 
> Ingo,
> 
> Yes, conceptually, emulation is simpler. In fact, it may even be the
> right thing to do from a housekeeping POV if gdb were enabled to use
> breakpoint assistance in the kernel. However... emulation is not
> easy. Just quoting Peter Anvin:
> 
> > On the more general rule of interpretation: I'm really concerned about
> > having a bunch of partially-capable x86 interpreters all over the
> > kernel.  x86 is *hard* to emulate, and it will only get harder as the
> > architecture evolves.
> >
> >       -hpa

This is obviously true for a full emulator. Except for the fact that:

> Yes, I know you suggested we start with a small subset.

and for the fact that we already have emulators in the kernel.

Plus we _already_ need to decode instructions for safe kprobing and have the 
code for that upstream. So it's not like we can avoid decoding the 
instructions. (and emulating certain instruction patterns is really just a 
natural next step of a good decoder.)

> We already have an implementation of instruction emulation in kernel for x86 
> and powerpc, but its too KVM centric. If there is a generic emulation layer, 
> we would use it.

So this approach, beyond being simpler, more robust and faster than the 
current XOL code, would also trigger (much needed) cleanups in other parts of 
the kernel and would share code with other kernel subsystems.

Dont you see the obvious advantages of that?

	Ingo
