Return-Path: <linux-kernel-owner+w=401wt.eu-S1752334AbZDSXjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbZDSXjB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 19:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbZDSXiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 19:38:52 -0400
Received: from gw.goop.org ([64.81.55.164]:40419 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbZDSXiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 19:38:51 -0400
Message-ID: <49EBB609.9030407@goop.org>
Date: Sun, 19 Apr 2009 16:38:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Christoph Hellwig <hch@lst.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] tracing: move __DO_TRACE out of line
References: <1239950139-1119-1-git-send-email-jeremy@goop.org> <1239950139-1119-2-git-send-email-jeremy@goop.org> <20090417154640.GB8253@elte.hu> <20090417161005.GA16361@Krystal> <20090417162326.GG8253@elte.hu> <49E8D91F.1060005@goop.org> <20090418065331.GA1942@Krystal> <alpine.DEB.2.00.0904181013450.1016@gandalf.stny.rr.com> <20090419035938.GA26365@Krystal>
In-Reply-To: <20090419035938.GA26365@Krystal>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Here is the conclusions I gather from the following tbench tests on the LTTng
> tree :
>
> - Dormant tracepoints, when sprinkled all over the place, have a very small, but
>   measurable, footprint on kernel stress-test workloads (3 % for the
>   whole 2.6.30-rc1 LTTng tree).
>
> - "Immediate values" help lessening this impact significantly (3 % -> 2.5 %).
>
> - Static jump patching would diminish impact even more, but would require gcc
>   modifications to be acceptable. I did some prototypes using instruction
>   pattern matching in the past which was judged too complex.
>
> - I strongly recommend adding per-subsystem config-out option for heavy
>   users like kmemtrace or pvops. Compiling-out kmemtrace instrumentation
>   brings the performance impact from 2.5 % down to 1.9 % slowdown.
>
> - Putting the tracepoint out-of-line is a no-go, as it slows down *both* the
>   dormant (3 % -> 4.7 %) and the active (+20% to tracer overhead) tracepoints
>   compared to inline tracepoints.
>   

That's an interestingly counter-intuitive result.  Do you have any 
theories how this might happen?  The only mechanism I can think of is 
that, because the inline code sections are smaller, gcc is less inclined 
to put the if(unlikely) code out of line, so the amount of hot-patch 
code is higher.  But still, 1.7% is a massive increase in overhead, 
especially compared to the relative differences of the other changes.

> Tracepoints all compiled-out :
>
> run 1 :                2091.50
> run 2 (after reboot) : 2089.50 (baseline)
> run 3 (after reboot) : 2083.61
>
> Dormant tracepoints :
>
> inline, no immediate value optimization
>
> run 1 :                1990.63
> run 2 (after reboot) : 2025.38 (3 %)
> run 3 (after reboot) : 2028.81
>
> out-of-line, no immediate value optimization
>
> run 1 :                1990.66
> run 2 (after reboot) : 1990.19 (4.7 %)
> run 3 (after reboot) : 1977.79
>
> inline, immediate value optimization
>
> run 1 :                2035.99 (2.5 %)
> run 2 (after reboot) : 2036.11
> run 3 (after reboot) : 2035.75
>
> inline, immediate value optimization, configuring out kmemtrace tracepoints
>
> run 1 :                2048.08 (1.9 %)
> run 2 (after reboot) : 2055.53
> run 3 (after reboot) : 2046.49
>   

So what are you doing here?  Are you doing 3 runs, then comparing he 
median measurement in each case?

The trouble is that your run to run variations are at least as large as 
the difference you're trying to detect.  For example in run 1 of 
"inline, no immediate value optimization" you got 1990.6MB/s throughput, 
and then runs 2 & 3 both went up to ~2025.  Why?  That's a huge jump.

The "out-of-line, no immediate value optimization" runs 1&2 has the same 
throughput as run 1 of the previous test, 1990MB/s, while run 3 is a bit 
worse.  OK, so perhaps its slower.  But why are runs 1&2 more or less 
identical to inline/run1?

What would happen if you happened to do 10 iterations of these tests?  
There just seems like too much run to run variation to make 3 runs 
statistically meaningful.

I'm not picking on you personally, because I had exactly the same 
problems when trying to benchmark the overhead of pvops.  The 
reboot/rerun variations were at least as large as the effects I'm trying 
to measure, and I'm just feeling suspicious of all the results.

I think there's something fundimentally off about about this kind of 
kernel benchmark methodology.  The results are not stable and are not - 
I think - reliable.  Unfortunately I don't have enough of a background 
in statistics to really analyze what's going on here, or how we should 
change the test/measurement methodology to get results that we can 
really stand by.

I don't even have a good explanation for why there are such large 
boot-to-boot variations anyway.  The normal explanation is "cache 
effects", but what is actually changing here?  The kernel image is 
identical, loaded into the same physical pages each time, and mapped 
into the same virtual address.  So the I&D caches and tlb should get 
exactly the same access patterns for the kernel code itself.  The 
dynamically allocated memory is going to vary, and have different cache 
interactions, but is that enough to explain these kinds of variations?  
If so, we're going to need to do a lot more iterations to see any signal 
from our actual changes over the noise that "cache effects" are throwing 
our way...

    J
