Return-Path: <linux-kernel-owner+w=401wt.eu-S1753414Ab0A3RvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab0A3RvG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 12:51:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082Ab0A3RvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 12:51:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60377 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab0A3RvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 12:51:03 -0500
X-Authority-Analysis: v=1.0 c=1 a=VnNF1IyMAAAA:8 a=YaU6B9CEbnekWpMqVacA:9 a=oDO5V7FcrJZsU8IvJtIA:7 a=FUYnOcaKHY1XgjlAwjRseVHfc8EA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: linux-next: add utrace tree
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kyle Moffett <kyle@moffetthome.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Tom Tromey <tromey@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       linux-next@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       utrace-devel@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20100129074241.GG14636@elte.hu>
References: <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain>
	 <m33a1tnbd9.fsf@fleche.redhat.com>
	 <alpine.LFD.2.00.1001251332370.3574@localhost.localdomain>
	 <m3636oh2rt.fsf@fleche.redhat.com>
	 <alpine.LFD.2.00.1001261535510.17519@localhost.localdomain>
	 <1264575134.4283.1983.camel@laptop> <20100127085442.GA28422@elte.hu>
	 <1264643539.5068.62.camel@localhost.localdomain>
	 <20100128085502.GA7713@elte.hu> <20100129045546.GA16920@in.ibm.com>
	 <20100129074241.GG14636@elte.hu>
Content-Type: text/plain
Date: Sat, 30 Jan 2010 12:49:10 -0500
Message-Id: <1264873751.4561.9155.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-29 at 08:42 +0100, Ingo Molnar wrote:
> * Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:
> 
> > On Thu, Jan 28, 2010 at 09:55:02AM +0100, Ingo Molnar wrote:
> > 
> > ...
> > 
> > > Lets compare the two cases via a drawing. Your current uprobes submission 
> > > does:
> > > 
> > >  [kernel]      do probe thing     single-step trap
> > >                ^            |     ^              |
> > >                |            v     |              v
> > >  [user]     INT3            XOL-ins              next ins-stream
> > > 
> > >  ( add the need for serialization to make sure the whole single-step thing 
> > >    does not get out of sync with reality. )
> > > 
> > > And emulator approach would do:
> > > 
> > >  [kernel]      emul-demux-fastpath, do probe thing
> > >                ^                                 |
> > >                |                                 v
> > >  [user]     INT3                                 next ins-stream
> > > 
> > > far simpler conceptually, and faster as well, because it's one kernel entry.
> > 
> > Ingo,
> > 
> > Yes, conceptually, emulation is simpler. In fact, it may even be the
> > right thing to do from a housekeeping POV if gdb were enabled to use
> > breakpoint assistance in the kernel. However... emulation is not
> > easy. Just quoting Peter Anvin:
> > 
> > > On the more general rule of interpretation: I'm really concerned about
> > > having a bunch of partially-capable x86 interpreters all over the
> > > kernel.  x86 is *hard* to emulate, and it will only get harder as the
> > > architecture evolves.
> > >
> > >       -hpa
> 
> This is obviously true for a full emulator. Except for the fact that:
> 
> > Yes, I know you suggested we start with a small subset.
> 
> and for the fact that we already have emulators in the kernel.

But this would be emulating userspace instructions, correct?

The kernel is limited to what instructions it can perform, no floating
point for example (of course there are some exceptions). But generally,
the instructions in the kernel should be easier to emulate than in
userspace. Userspace is free to do any wacky thing it wants. Will this
limit the ability to probe apps that take advantage of some strange op
code that the user knows is available on their platform?

-- Steve

> 
> Plus we _already_ need to decode instructions for safe kprobing and have the 
> code for that upstream. So it's not like we can avoid decoding the 
> instructions. (and emulating certain instruction patterns is really just a 
> natural next step of a good decoder.)


