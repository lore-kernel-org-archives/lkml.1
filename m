Return-Path: <linux-kernel-owner+w=401wt.eu-S1752634AbYJaSRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbYJaSRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 14:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750822AbYJaSRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 14:17:39 -0400
Received: from picard.linux.it ([213.254.12.146]:51751 "EHLO picard.linux.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbYJaSRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 14:17:39 -0400
Message-ID: <45033.148.202.77.161.1225475350.squirrel@picard.linux.it>
In-Reply-To: <1225387034.7803.182.camel@twins>
References: <200810281634.11285.henrik@austad.us>
    <1225212627.15763.16.camel@lappy.programming.kicks-ass.net>
    <20081030174925.36023f19jy3o832t@feanor.sssup.it>
    <1225387034.7803.182.camel@twins>
Date: Fri, 31 Oct 2008 18:49:10 +0100 (CET)
Subject: Re: Deadline scheduling (was: Re: Rearranging layout of code in 
     the scheduler)
From: "Dario Faggioli" <raistlin@linux.it>
To: "Peter Zijlstra" <peterz@infradead.org>
Cc: faggioli@gandalf.sssup.it, henrik@austad.us, "Ingo Molnar" <mingo@elte.hu>,
       "linux-kernel" <linux-kernel@vger.kernel.org>, fabio@gandalf.sssup.it,
       "Michael Trimarchi" <trimarchimichael@yahoo.it>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "gregory.haskins" <gregory.haskins@gmail.com>
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Gio, 30 Ottobre 2008 6:17 pm, Peter Zijlstra wrote:
> Right, ideally I'd like to see 2 EDF classes on top of FIFO, so that we
> end up with the following classes
>
>   hedf     - hard EDF
>   sedf     - soft EDF (bounded tardiness)
>   fifo/rr  - the current static priority scheduler
>   fair     - the current proportional fair scheduler
>   idle     - the idle scheduler
>
Oh, so two classes? Well, yes, could be nice.

> The two edf classes must share some state, so that the sedf class knows
> about the utilisation consumed by hedf, and the main difference between
> these two classes is the schedulability test.
>
Yep. Actually I think that schedulability test could be an issue as well,
especially if we like group/hierarchical approach, since the known
hierarchical admission tests are quite complex to implement and, probably,
time consuming if performed on-line in an highly dynamic (with respec to
to task arrival and leaving) system.

> The few problems this gives are things like kstopmachine and the
> migration threads, which should run at the max priority available on the
> system.
>
Yeah, that's exactly what we was thinking too.

Actually, I was also thinking that having fixed priority scheduling
_before_ EDF could be of some benefit if you have to be sure that a task
is going to be executed at a very precise instant in time, but have not a
precise about that yet.

> Perhaps we can introduce another class on top of hedf which will run
> just these two tasks and is not exposed to userspace (yes, I understand
> it will ruin just about any schedulability analysis).
Well, could be a solution... And if this is only used for such kind of
special tasks, maybe it is not impossible to bound or account for their
scheduling contribution... But I'm just shooting inthe dark here, sorry
about that! :-P

> We can do deadline inheritance and bandwidth inheritance by changing
> plist to a rb-tree/binary heap and mapping the static priority levels
> somewhere at the back and also propagating the actual task responsible
> for the boost down the chain (so as to be able to do bandwidth
> inheritance).
>
> From what I gather the sssup folks are doing that, although they
> reported that DI between disjoint schedule domains (partitions) posed an
> interesting problem.
>
Yes, that's right, this is what we are investigating and trying to do in
these days (... Or weeks... Or months!).

> Personally I'd like to see the full priority inversion issue solved by
> something like the proxy execution protocol, however the SMP extension
> thereof seems to be a tad expensive - found a book on graph theory, all
> that remains is finding time to read it :-)
>
Wow... So, good luck for that! :-)

Maybe it's my fault, but I see some issues with proxy execution and
similar protocols.
That is, if you have, let's say, task A blocked on task B, blocked on task
C, and you are using proxy execution, that means that you have not
dequeued A and B when they blocked, but that you, for example, filled a
pointer that reminds you, when you schedule them, that you have to
actually run C, am I right?

Now, what happens if C blocks on a non-rt mutex lock, or if it simply go
to sleep? Is that acceptable to track the blocking chain in order to
actually dequeue also A and B, and to requeue them again when C will wake
up as well?

Forgive if that's a stupid point... :-(

> The advantage of proxy execution is that its fully invariant to the
> schedule function and thus even works for proportional fair schedulers
> and any kind of scheduler hierarchy.
>
Yes, I agree and I like it very much too. If you go for it, you could also
add bandwidth inheritance (e.g., for group scheduling) and things like
that almost for free (if wanted! :-))

Regards,
Dario Faggioli


