Return-Path: <linux-kernel-owner+w=401wt.eu-S1753028AbZA3HRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbZA3HRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 02:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbZA3HRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 02:17:42 -0500
Received: from smtpauth.net4india.com ([202.71.129.139]:52563 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751069AbZA3HRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 02:17:41 -0500
X-Greylist: delayed 3505 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Jan 2009 02:17:40 EST
Subject: Re: scheduler nice 19 versus 'idle' behavior / static low-priority
	scheduling
From: "V.Radhakrishnan" <rk@atr-labs.com>
To: Nathanael Hoyle <nhoyle@hoyletech.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1233294584.28741.2.camel@localhost>
References: <1233294584.28741.2.camel@localhost>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 11:47:59 +0530
Message-Id: <1233296279.3395.13.camel@atlas>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clear description of a "problem" which may not be directly "solvable"
unless one becomes philosophical.

The linux scheduler by default is a "FAIR" scheduler which means that
every runnable process ready to occupy CPU time will at some point RUN
and never be denied cpu time. This is possible by boosting the dynamic
priority of runnable processes so that one day they rule the roost.

However, the kernel also supports SCHED_FIFO and SCHED_RR which supports
Real Time capabilities, albeit as root.

The DVD player is a soft real time application where the display gets
jittery whenever the frame display rate is not achievable.

If you wish 100% smooth display, you could make it run as SCHED_FIFO
which means that your foldingathome would wait quietly for the movie to
get completed fully. What's "wrong" with that aproach, which is
essentially what you want ?

The key question is whether YOU want the foldingathome application to
run in parallel with the dvd player or not. 

Lets wait for more light from the gurus...!!

V. Radhakrishnan


On Fri, 2009-01-30 at 00:49 -0500, Nathanael Hoyle wrote:
> All (though perhaps of special interest to a few such as Ingo, Peter,
> and David),
> 
> I am posting regarding an issue I have been dealing with recently,
> though this post is not really a request for troubleshooting.  Instead
> I'd like to ramble for just a moment about my understanding of the
> current 2.6 scheduler, describe the behavior I'm seeing, and discuss a
> couple of the architectural solutions I've considered, as well as pose
> the question whether anyone else views this as a general-case problem
> worthy of being addressed, or whether this is something that gets
> ignored by and large. It is my hope that this is not too off-topic for
> this group.
> 
> First, let me explain the issue I encountered. I am running a relatively
> powerful system for a home desktop, an Intel Core 2 Quad Q9450 with 4 GB
> of RAM. If it matters for the discussion, it also has 4 drives in an
> mdraid raid-5 array, and decent I/O throughput.  In normal circumstances
> it is quite responsive as a desktop (kde 3.5.4 atm).  It is further a
> very carefully configured kernel build, including only those things
> which I truly need, and excluding everything else. I often use it to
> watch DVD movies, and have had no trouble with performance in general.
> 
> Recently I installed the Folding@Home client, which many of you may be
> familiar with, intended to utilize spare CPU cycles to perform protein
> folding simulations in order to further medical research.  It is not a
> multi-threaded client at this point, so it simply runs four instances on
> my system, since it has four cores.  It is configured to run at
> nice-level 19.
> 
> Because it is heavily optimized, and needs little external data to
> perform its work, it spends almost all of its time cpu-bound, with
> little to no io-wait or blocking on network calls, etc.  I had been
> using it for about a week with no real difficulty until I went to watch
> another DVD and found that the video was slightly stuttery/jerky so long
> as foldingathome was running in the background.  Once I shut it down,
> the video playback resumed its normal smooth form.
> 
> There are a couple simple solutions to this:
> 
> Substantially boosting the process priority of the mplayer process also
> returns the video to smooth playback, but this is undesirable in that it
> requires manual intervention each time, and root privileges. It fails to
> achieve what I want, which is for the foldingathome computation to not
> interfere with anything else I may try to do. I want my compiles to be
> as *exactly* as fast as they were without it as possible, etc.
> 
> Stopping foldingathome before I do something performance sensitive is
> also possible, but again smacks of workaround rather than solution. The
> scheduler should be able to resolve the goal without me stopping the
> other work.
> 
> I have done a bit of research on how the kernel scheduler works, and why
> I am seeing this behavior.  I had previously, apparently ignorantly,
> equated 'nice 19' with being akin to Microsoft Windows' 'idle' thread
> priority, and assumed it would never steal CPU cycles from a process
> with a higher(lower, depending on nomenclature) priority.
> 
> It is my current understanding that when mplayer is running (also
> typically CPU bound, occassionally it becomes I/O bound briefly), one of
> the instances of foldingathome, which is sharing the CPU (core) with
> mplayer starts getting starved, and the scheduler dynamically rewards it
> with up to four additional priority levels based on the time remaining
> in its quantum which it was not allowed to execute for.
> 
> At this point, when mplayer blocks for just a moment, say to page in the
> data for the next video frame, foldingathome gets scheduled again, and
> gets to run for at least MIN_TIMESLICE (plus, due to the lack of kernel
> pre-emptibility, possibly longer).  It appears that it takes too long to
> switch back to mplayer and the result is the stuttering picture I
> observe.
> 
> I have tried adjusting CONFIG_HZ_xxx from 300 (where I had it) to 1000,
> and noted some improvement, but not complete remedy.
> 
> In my prior searching on this, I found only one poster with the same
> essential problem (from 2004, and regarding distributed.net in the
> background, which is essentially the same problem).  The only technical
> answer given him was to perhaps try tuning the MIN_TIMESLICE value
> downward.  It is my understanding that this parameter is relatively
> important in order to avoid cache thrashing, and I do not wish to alter
> it and have not so far.
> 
> Given all of the above, I am unconvinced that I see a good overall
> solution.  However, one thing that seems to me a glaring weakness of the
> scheduler is that only realtime priority threads can be given static
> priorities.  What I really want for foldingathome, and similar tasks, is
> static, low priority. Something that would not boost up, no matter how
> well behaved it was or how much it had been starved, or how close to the
> same memory segments the needed code was.
> 
> I think that there are probably (at least) three approaches here. One I
> consider unnacceptable at the outset, which is to alter the semantics of
> nice 19 such that it does not boost. Since this would break existing
> assumptions and code, I do not think it is feasible.
> 
> Secondly, one could add additional nice levels which would correspond to
> new static priorities below the bottom of the current user ones.  This
> should not interfere with the O(1) scheduler implementation as I
> understand it, because current I believe 5 32-bit words are used to flag
> the queue usage, and 140 priorities leaves 20 more bits available for
> new priorities. This has its own problems however, in that existing
> tools which examine process priorities could break on priorities outside
> the known 'nice' range of -20 to 19.
> 
> Finally, new scheduling classes could be introduced, together with new
> system calls so that applications could select a different scheduling
> class at startup. In this way, applications could volunteer to use a
> scheduling class which never received dynamic 'reward' boosts that would
> raise their priorities.  I believe Solaris has done this since Solaris
> 9, with the 'FX' scheduling class.
> 
> Stepping back:
> 
> 1) Is my problem 'expected' based on others' understanding of the
> current design of the scheduler, or do I have a one-off problem to
> troubleshoot here?
> 
> 2) Am I overlooking obvious alternative (but clean) fixes?
> 
> 3) Does anyone else see the need for static, but low process priorities?
> 
> 4) What is the view of introducing a new scheduler class to handle this?
> 
> I welcome any further feedback on this.  I will try to follow replies
> on-list, but would appreciate being CC'd off-list as well.  Please make
> the obvious substitution to my email address in order to bypass the
> spam-killer.
> 
> Thanks,
> Nathanael Hoyle
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

