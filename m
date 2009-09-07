Return-Path: <linux-kernel-owner+w=401wt.eu-S1758890AbZIGDjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbZIGDjA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 23:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758734AbZIGDi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 23:38:59 -0400
Received: from lo.gmane.org ([80.91.229.12]:48914 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758722AbZIGDi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 23:38:58 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Nikos Chantziaras <realnc@arcor.de>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Date: Mon, 07 Sep 2009 06:38:36 +0300
Organization: Lucas Barks
Message-ID: <h81v7t$p6e$1@ger.gmane.org>
References: <20090906205952.GA6516@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: athedsl-374927.home.otenet.gr
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090826 Thunderbird/3.0b3
In-Reply-To: <20090906205952.GA6516@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2009 11:59 PM, Ingo Molnar wrote:
>[...]
> Also, i'd like to outline that i agree with the general goals
> described by you in the BFS announcement - small desktop systems
> matter more than large systems. We find it critically important
> that the mainline Linux scheduler performs well on those systems
> too - and if you (or anyone else) can reproduce suboptimal behavior
> please let the scheduler folks know so that we can fix/improve it.

BFS improved behavior of many applications on my Intel Core 2 box in a 
way that can't be benchmarked.  Examples:

mplayer using OpenGL renderer doesn't drop frames anymore when dragging 
and dropping the video window around in an OpenGL composited desktop 
(KDE 4.3.1).  (Start moving the mplayer window around; then drop it. At 
the moment the move starts and at the moment you drop the window back to 
the desktop, there's a big frame skip as if mplayer was frozen for a 
bit; around 200 or 300ms.)

Composite desktop effects like zoom and fade out don't stall for 
sub-second periods of time while there's CPU load in the background.  In 
other words, the desktop is more fluid and less skippy even during heavy 
CPU load.  Moving windows around with CPU load in the background doesn't 
result in short skips.

LMMS (a tool utilizing real-time sound synthesis) does not produce 
"pops", "crackles" and drops in the sound during real-time playback due 
to buffer under-runs.  Those problems amplify when there's heavy CPU 
load in the background, while with BFS heavy load doesn't produce those 
artifacts (though LMMS makes itself run SCHED_ISO with BFS)  Also, 
hitting a key on the keyboard needs less time for the note to become 
audible when using BFS.  Same should hold true for other tools who 
traditionally benefit from the "-rt" kernel sources.

Games like Doom 3 and such don't "freeze" periodically for small amounts 
of time (again for sub-second amounts) when something in the background 
grabs CPU time (be it my mailer checking for new mail or a cron job, or 
whatever.)

And, the most drastic improvement here, with BFS I can do a "make -j2" 
in the kernel tree and the GUI stays fluid.  Without BFS, things start 
to lag, even with in-RAM builds (like having the whole kernel tree 
inside a tmpfs) and gcc running with nice 19 and ionice -c 3.

Unfortunately, I can't come up with any way to somehow benchmark all of 
this.  There's no benchmark for "fluidity" and "responsiveness". 
Running the Doom 3 benchmark, or any other benchmark, doesn't say 
anything about responsiveness, it only measures how many frames were 
calculated in a specific period of time.  How "stable" (with no stalls) 
those frames were making it to the screen is not measurable.

If BFS would imply small drops in pure performance counted in 
instructions per seconds, that would be a totally acceptable regression 
for desktop/multimedia/gaming PCs.  Not for server machines, of course. 
  However, on my machine, BFS is faster in classic workloads.  When I 
run "make -j2" with BFS and the standard scheduler, BFS always finishes 
a bit faster.  Not by much, but still.  One thing I'm noticing here is 
that BFS produces 100% CPU load on each core with "make -j2" while the 
normal scheduler stays at about 90-95% with -j2 or higher in at least 
one of the cores.  There seems to be under-utilization of CPU time.

Also, by searching around the net but also through discussions on 
various mailing lists, there seems to be a trend: the problems for some 
reason seem to occur more often with Intel CPUs (Core 2 chips and lower; 
I can't say anything about Core I7) while people on AMD CPUs mostly not 
being affected by most or even all of the above.  (And due to this flame 
wars often break out, with one party accusing the other of imagining 
things).  Can the integrated memory controller on AMD chips have 
something to do with this?  Do AMD chips generally offer better 
"multithrading" behavior?  Unfortunately, you didn't mention on what CPU 
you ran your tests.  If it was AMD, it might be a good idea to run tests 
on Pentium and Core 2 CPUs.

For reference, my system is:

CPU: Intel Core 2 Duo E6600 (2.4GHz)
Mainboard: Asus P5E (Intel X38 chipset)
RAM: 6GB (2+2+1+1) dual channel DDR2 800
GPU: RV770 (Radeon HD4870).

