Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbYDROiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbYDROiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 10:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbYDROiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 10:38:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbYDROiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 10:38:04 -0400
Date: Fri, 18 Apr 2008 10:29:52 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: prasad@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, mathieu.desnoyers@polymtl.ca
Subject: Re: [RFC PATCH 1/2] Marker probes in futex.c
Message-ID: <20080418142949.GB3922@redhat.com>
References: <20080415115058.GA6788@in.ibm.com> <20080415115314.GA6975@in.ibm.com> <1208260942.6395.6.camel@twins> <20080415155223.GA6935@in.ibm.com> <1208361092.6395.81.camel@twins> <y0m1w54cf82.fsf@ton.toronto.redhat.com> <1208501204.7115.60.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208501204.7115.60.camel@twins>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Fri, Apr 18, 2008 at 08:46:44AM +0200, Peter Zijlstra wrote:
> [...]
> > > except worse by encoding local variable names and exposing kernel
> > > pointers.
> > 
> > The pointers are probably excessive, the and the names don't really
> > matter.
>
> Then what do we do when someone comes along and changes one of those
> names; do we go around changing the markers and then requiring all
> tools to change as well? (And no this isn't far fetched; I'm
> thinking of changing fshared in the near future).

At least two answers apply.  The markers being put in should be chosen
with the concurrence of the subsystem maintainer, who should help
identify those key quantities that are likely to be both long-lived
and good diagnostic value.  So that's the discussion we're having
right now: which values should be passed.  If they're long-lived, then
they can be given a long-lived name - and it doesn't have to be a
low-level C variable name.  (There's no reason why we can't also have
a slew of short-lived pure-debugging sorts of markers compiled in.  A
marker naming convention like "__futex..." can be adopted for such
purposes - where nothing is promised for version n+1, just hoping to
help diagnose problems in this version.)

The other answer is that we should ensure that tools do not assume
that the set of markers is fixed.  Let's never set such an
expectation.  (In systemtap, we have several abstraction and
version-adaptation facilities that aim to hide such changes.)
The kernel guy can choose at least two methods to help tools
without contraining himself too much.  He can change

        trace_mark(futex_foo, "p1 %d p2 %d", p1, p2);

to a pair:

        trace_mark(futex_foo, "p1 %d p2 %d", 0, p2); // backward compat.
        trace_mark(futex_foo2, "p2 %d p3 %d", p2, p3); // new marker

or even just drop the backward compatibility one altogether.

It will need judicious choices by the kernel and willingness by the
tools to keep up.  Those that don't will simply notice fewer events
coming in, but nothing important *breaking*.

The current crop of tools (lttng, systemtap) are both from friendly
groups who recognize that they have more of an expendable diagnostic
rather than operational role, and thus are willing to carry that
burden.  By the time new tools will show up, we will have more
experience with the degree and type of marker changes over time, and
they won't be in a position to place new constraints on the
establishment.


> Sounds like people will complain and generate back pressure against
> such changes - something we should avoid. As soon as these markers
> place a significant burden on code maintenance I'm against it.

Indeed.  This is why it's important for the subsystem maintainer to
wisely influence the markers as they go in.


> > That, plus the new hand-written function (trace_futex_wait) would
> > still need to manage the packaging of the arguments for consumption by
> > separately compiled pieces.  It is desirable not to require such
> > hand-written functions to *also* be declared in headers for these
> > event consumers to compile against.

> *blink* so all this is so you don't have to put a declarion in a
> header file? How about we put these premanent markers in a header -
> Mathieu says there are <200. Surely that's not too much trouble.
> [...]

It's not just that - it's a whole package including easy creation of
new markers, the code that manages their activation and deactivation,
the tool code that connects up to receive new events *and parameters*.
The current approach does not require tight compilation-level
coupling.  Indeed, for a new marker, the current approach requires
*no* code changes to anywhere other than the one-line inserted marker,
for tools like systemtap to connect and use them.  Cool eh?


- FChE
