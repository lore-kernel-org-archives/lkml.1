Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953AbZIGXyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbZIGXyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 19:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbZIGXy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 19:54:29 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:39669 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbZIGXy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 19:54:27 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=phJPt9DcmPgA:10 a=w4iE+TBsmj5y1WloLYF40w==:17
 a=IwJlCoS2mc6YGdWxz7MA:9 a=xGxXqXc1OLlbv3GnFokA:7
 a=B15lxrzx5Igok6wp1dr7FZJsI00A:4
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
To: linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Date: Mon, 7 Sep 2009 17:54:28 -0600
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc8; KDE/4.3.1; x86_64; ; )
References: <20090906205952.GA6516@elte.hu> <h81v7t$p6e$1@ger.gmane.org>
In-Reply-To: <h81v7t$p6e$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909071754.28675.tfjellstrom@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun September 6 2009, Nikos Chantziaras wrote:
> On 09/06/2009 11:59 PM, Ingo Molnar wrote:
> >[...]
> > Also, i'd like to outline that i agree with the general goals
> > described by you in the BFS announcement - small desktop systems
> > matter more than large systems. We find it critically important
> > that the mainline Linux scheduler performs well on those systems
> > too - and if you (or anyone else) can reproduce suboptimal behavior
> > please let the scheduler folks know so that we can fix/improve it.
> 
> BFS improved behavior of many applications on my Intel Core 2 box in a
> way that can't be benchmarked.  Examples:
> 
> mplayer using OpenGL renderer doesn't drop frames anymore when dragging
> and dropping the video window around in an OpenGL composited desktop
> (KDE 4.3.1).  (Start moving the mplayer window around; then drop it. At
> the moment the move starts and at the moment you drop the window back to
> the desktop, there's a big frame skip as if mplayer was frozen for a
> bit; around 200 or 300ms.)
> 
> Composite desktop effects like zoom and fade out don't stall for
> sub-second periods of time while there's CPU load in the background.  In
> other words, the desktop is more fluid and less skippy even during heavy
> CPU load.  Moving windows around with CPU load in the background doesn't
> result in short skips.
> 
> LMMS (a tool utilizing real-time sound synthesis) does not produce
> "pops", "crackles" and drops in the sound during real-time playback due
> to buffer under-runs.  Those problems amplify when there's heavy CPU
> load in the background, while with BFS heavy load doesn't produce those
> artifacts (though LMMS makes itself run SCHED_ISO with BFS)  Also,
> hitting a key on the keyboard needs less time for the note to become
> audible when using BFS.  Same should hold true for other tools who
> traditionally benefit from the "-rt" kernel sources.
> 
> Games like Doom 3 and such don't "freeze" periodically for small amounts
> of time (again for sub-second amounts) when something in the background
> grabs CPU time (be it my mailer checking for new mail or a cron job, or
> whatever.)
> 
> And, the most drastic improvement here, with BFS I can do a "make -j2"
> in the kernel tree and the GUI stays fluid.  Without BFS, things start
> to lag, even with in-RAM builds (like having the whole kernel tree
> inside a tmpfs) and gcc running with nice 19 and ionice -c 3.
> 
> Unfortunately, I can't come up with any way to somehow benchmark all of
> this.  There's no benchmark for "fluidity" and "responsiveness".
> Running the Doom 3 benchmark, or any other benchmark, doesn't say
> anything about responsiveness, it only measures how many frames were
> calculated in a specific period of time.  How "stable" (with no stalls)
> those frames were making it to the screen is not measurable.
> 
> If BFS would imply small drops in pure performance counted in
> instructions per seconds, that would be a totally acceptable regression
> for desktop/multimedia/gaming PCs.  Not for server machines, of course.
>   However, on my machine, BFS is faster in classic workloads.  When I
> run "make -j2" with BFS and the standard scheduler, BFS always finishes
> a bit faster.  Not by much, but still.  One thing I'm noticing here is
> that BFS produces 100% CPU load on each core with "make -j2" while the
> normal scheduler stays at about 90-95% with -j2 or higher in at least
> one of the cores.  There seems to be under-utilization of CPU time.
> 
> Also, by searching around the net but also through discussions on
> various mailing lists, there seems to be a trend: the problems for some
> reason seem to occur more often with Intel CPUs (Core 2 chips and lower;
> I can't say anything about Core I7) while people on AMD CPUs mostly not
> being affected by most or even all of the above.  (And due to this flame
> wars often break out, with one party accusing the other of imagining
> things).  Can the integrated memory controller on AMD chips have
> something to do with this?  Do AMD chips generally offer better
> "multithrading" behavior?  Unfortunately, you didn't mention on what CPU
> you ran your tests.  If it was AMD, it might be a good idea to run tests
> on Pentium and Core 2 CPUs.
> 
> For reference, my system is:
> 
> CPU: Intel Core 2 Duo E6600 (2.4GHz)
> Mainboard: Asus P5E (Intel X38 chipset)
> RAM: 6GB (2+2+1+1) dual channel DDR2 800
> GPU: RV770 (Radeon HD4870).
> 

My Phenom 9550 (2.2Ghz) whips the pants off my Intel Q6600 (2.6Ghz). I and a 
friend of mine both get large amounts of stalling when doing a lot of IO. I 
haven't seen such horrible desktop interactivity since before the new 
schedulers and the -ck patchset came out for 2.4.x. Its a heck of a lot better 
on my AMD Phenom's, but some lag is noticeable these days, even when it wasn't 
a few kernel releases ago.

Intel Specs:
CPU: Intel Core 2 Quad Q6600 (2.6Ghz)
Mainboard: ASUS P5K-SE (Intel p35 iirc)
RAM: 4G 800Mhz DDR2 dual channel (4x1G)
GPU: NVidia 8800GTS 320M

AMD Specs:
CPU: AMD Phenom I 9550 (2.2Ghz)
Mainboard: Gigabyte MA78GM-S2H
RAM: 4G 800Mhz DDR2 dual channel (2x2G)
GPU: Onboard Radeon 3200HD

AMD Specs x2:
CPU: AMD Phenom II 810 (2.6Ghz)
Mainboard: Gigabyte MA790FXT-UD5P
RAM: 4G 1066Mhz DDR3 dual channel (2x2G)
GPU: NVidia 8800GTS 320M (or currently a 8400GS)

Of course I get better performance out of the Phenom II vs either other box, 
but it surprises me that I'd get more out of the budget AMD box over the not 
so budget Intel box.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
