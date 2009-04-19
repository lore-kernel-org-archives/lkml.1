Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823AbZDSD7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbZDSD7y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 23:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbZDSD7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 23:59:45 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:43492 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751404AbZDSD7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 23:59:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ai8FAOo66klMQW1W/2dsb2JhbACBTssQg30G
Date: Sat, 18 Apr 2009 23:59:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Christoph Hellwig <hch@lst.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] tracing: move __DO_TRACE out of line
Message-ID: <20090419035938.GA26365@Krystal>
References: <1239950139-1119-1-git-send-email-jeremy@goop.org> <1239950139-1119-2-git-send-email-jeremy@goop.org> <20090417154640.GB8253@elte.hu> <20090417161005.GA16361@Krystal> <20090417162326.GG8253@elte.hu> <49E8D91F.1060005@goop.org> <20090418065331.GA1942@Krystal> <alpine.DEB.2.00.0904181013450.1016@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904181013450.1016@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:43:45 up 50 days, 9 min,  2 users,  load average: 0.32, 0.55,
	0.57
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Sat, 18 Apr 2009, Mathieu Desnoyers wrote:
> > 
> > tbench test
> > 
> > kernel : 2.6.30-rc1
> > 
> > running on a 8-cores x86_64, localhost server
> > 
> > tracepoints inactive :
> > 
> > 2051.20 MB/sec
> 
> Is this with or without inlined trace points?
> 
> It would be interesting to see:
> 
> time with tracepoints not configured at all
> 
> time with inline tracepoints (inactive)
> 
> time with out-of-line tracepoints (inactive)
> 
> Because if inline trace points affect the use of normal operations when 
> inactive, that would be a cause against trace points all together.
> 

I've done a few performance measurements which lead to interesting
conclusions.

Here is the conclusions I gather from the following tbench tests on the LTTng
tree :

- Dormant tracepoints, when sprinkled all over the place, have a very small, but
  measurable, footprint on kernel stress-test workloads (3 % for the
  whole 2.6.30-rc1 LTTng tree).

- "Immediate values" help lessening this impact significantly (3 % -> 2.5 %).

- Static jump patching would diminish impact even more, but would require gcc
  modifications to be acceptable. I did some prototypes using instruction
  pattern matching in the past which was judged too complex.

- I strongly recommend adding per-subsystem config-out option for heavy
  users like kmemtrace or pvops. Compiling-out kmemtrace instrumentation
  brings the performance impact from 2.5 % down to 1.9 % slowdown.

- Putting the tracepoint out-of-line is a no-go, as it slows down *both* the
  dormant (3 % -> 4.7 %) and the active (+20% to tracer overhead) tracepoints
  compared to inline tracepoints.

I also think someone should have a closer look at how GCC handles unlikely()
branches in static inline functions. For some reason, it does not seem to put
code in cache-cold cacheline in some cases. Improving the compiler optimisations
could help in those cases, not only for tracepoints, but for all other affected
facilities (e.g. BUG_ON()).

In conclusion, adding tracepoints should come at least with performance impact
measurements. For instance, the scheduler tracepoints have shown to have been
tested to have no significant performance impact, but it is not the case for
kmemtrace as my tests show. It makes sense, in this case, to put such invasive
tracepoints (kmemtrace, pvops) under a per-subsystem config option.
I would also recommend merging immediate values as a short-term
performance improvement and putting some resources on adding static jump
patching support to gcc.

Tracepoints are cheap, but not completely free.

Disclaimer : using tbench is probably the worse-case scenario we can
think of in terms of using the tracepoint code paths very frequently.
I dont expect more "balanced" workloads to exhibit such measurable
performance impact. Anyone willing to talk about the general performance
impact of tracepoints should _really_ run tests on a wider variety of
workloads.

Linux 2.6.30-rc1, LTTng tree
(includes both mainline tracepoints and LTTng tracepoints)

(tbench 8, in MB/sec)

Tracepoints all compiled-out :

run 1 :                2091.50
run 2 (after reboot) : 2089.50 (baseline)
run 3 (after reboot) : 2083.61

Dormant tracepoints :

inline, no immediate value optimization

run 1 :                1990.63
run 2 (after reboot) : 2025.38 (3 %)
run 3 (after reboot) : 2028.81

out-of-line, no immediate value optimization

run 1 :                1990.66
run 2 (after reboot) : 1990.19 (4.7 %)
run 3 (after reboot) : 1977.79

inline, immediate value optimization

run 1 :                2035.99 (2.5 %)
run 2 (after reboot) : 2036.11
run 3 (after reboot) : 2035.75

inline, immediate value optimization, configuring out kmemtrace tracepoints

run 1 :                2048.08 (1.9 %)
run 2 (after reboot) : 2055.53
run 3 (after reboot) : 2046.49

Mathieu


> -- Steve
> 
> > 
> > "google" tracepoints activated, flight recorder mode (overwrite) tracing
> > 
> > inline tracepoints
> > 
> > 1704.70 MB/sec (16.9 % slower than baseline)
> > 
> > out-of-line tracepoints
> > 
> > 1635.14 MB/sec (20.3 % slower than baseline)
> > 
> > So the overall tracer impact is 20 % bigger just by making the
> > tracepoints out-of-line. This is going to add up quickly if we add as
> > much function calls as we currently find in the event tracer fast path,
> > but LTTng, OTOH, has been designed to minimize the number of such
> > function calls, and you see a good example of why it's been such an
> > important design goal above.
> > 
> > About cache-line usage, I agree that in some cases gcc does not seem
> > intelligent enough to move those code paths away from the fast path.
> > What we would really whant there is -freorder-blocks-and-partition, but
> > I doubt we want this for the whole kernel, as it makes some jumps
> > slightly larger. One thing we should maybe look into is to add some kind
> > of "very unlikely" builtin expect to gcc that would teach it to really
> > put the branch in a cache-cold location, no matter what.
> > 
> > Mathieu
> > 
> > -- 
> > Mathieu Desnoyers
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> > 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
