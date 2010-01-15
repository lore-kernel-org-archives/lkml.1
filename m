Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab0AONsH (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 08:48:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255Ab0AONsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 08:48:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:54987 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab0AONsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 08:48:04 -0500
Subject: Re: [RFC] [PATCH 4/7] Uprobes Implementation
From: Peter Zijlstra <peterz@infradead.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Mark Wielaard <mjw@redhat.com>,
        utrace-devel <utrace-devel@redhat.com>
In-Reply-To: <20100115133825.GQ4822@redhat.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com>
	 <1263467394.4244.291.camel@laptop>
	 <1263509380.4875.35.camel@localhost.localdomain>
	 <1263546632.4244.352.camel@laptop> <y0mvdf3en1y.fsf@fche.csb>
	 <1263548124.4244.358.camel@laptop> <20100115131037.GP4822@redhat.com>
	 <1263561930.4244.417.camel@laptop>  <20100115133825.GQ4822@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jan 2010 14:47:56 +0100
Message-ID: <1263563276.4244.426.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-15 at 08:38 -0500, Frank Ch. Eigler wrote:
> Hi -
> 
> On Fri, Jan 15, 2010 at 02:25:30PM +0100, Peter Zijlstra wrote:
> > [...]
> > > utrace is not a form of punishment inflicted upon the undeserving.  It
> > > is a service layer that uprobes et alii are built upon.  You as a
> > > potential uprobes client need not also talk directly to it, if you
> > > wish to reimplement task-finder-like services some other way.
> > 
> > [...]
> > But yes, I think that for most purposes utrace is a punishment, its way
> > too heavy, I mean, trap, generate a signal, catch the signal, that's
> > like an insane amount of code to jump through in order to get that trap.
> 
> At the bottom, there will be an int3 in the userspace text page.
> There will be a trap taken, no matter what.  Code must figure out
> whether this trap came from an in-kernel client such as uprobes, or
> whether it is to be passed through to a userspace debugger via ptrace
> (or the gdbstub).  This part is unavoidable if you wish to be
> compatible.

Sure, a lookup against existing probe sites on trap is unavoidable, if
you find a match, you call a probe specific handler and deal with it
there, if you don't you'll eventually generate a SIGTRAP and fall back
to userspace.

Thing is, utrace doesn't do that (nor should it), its something the
uprobe interface should implement just like kprobes does.

> I'm not sure, but it sounds like the part you're complaining about is
> how utrace ultimately reports the trap to uprobes: i.e.,
> utrace_get_signal()?  Is that the "insane amount of code"?

Well when tracing/profiling every instruction is too much. Having to
needlessly raise a signal only to catch it again a short bit later
sounds like obvious waste to me.

> > Furthermore it requires stopping and resuming tasks and nonsense like
> > that, that's unwanted in many cases, just run stuff from the trap site
> > and you're done.
> 
> I don't know what you mean exactly.  A trap already stopped task.
> utrace merely allows various clients to inspect/manipulate the state
> of the task at that moment.  It does not add any context switches or
> spurious stop/resumue operations.

Srikar seemed to suggest it needed stop/resume.

