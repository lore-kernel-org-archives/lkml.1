Return-Path: <linux-kernel-owner+w=401wt.eu-S1030968AbXDWCo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030968AbXDWCo0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 22:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030975AbXDWCo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 22:44:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52665 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030968AbXDWCoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 22:44:15 -0400
Date: Mon, 23 Apr 2007 04:42:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Juliusz Chroboczek <jch@pps.jussieu.fr>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>, Bill Davidsen <davidsen@tmr.com>,
       Willy Tarreau <w@1wt.eu>, William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: [report] renicing X, cfs-v5 vs sd-0.46
Message-ID: <20070423024245.GA8378@elte.hu>
References: <20070420140457.GA14017@elte.hu> <200704220155.20856.kernel@kolivas.org> <20070421160008.GA28783@elte.hu> <200704220959.34978.kernel@kolivas.org> <87647oblx5.fsf@pps.jussieu.fr> <alpine.LFD.0.98.0704221620310.9964@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704221620310.9964@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> The X server should not be re-niced. It was done in the past, and it 
> was wrogn then (and caused problems - we had to tell people to undo 
> it, because some distros had started doing it by default).
> 
> If you have a single client, the X server is *not* more important than 
> the client, and indeed, renicing the X server causes bad patterns: 
> just because the client sends a request does not mean that the X 
> server should immediately be given the CPU as being "more important".

You are completely right in the case of traditional schedulers.

Note that this is not the case for CFS though. CFS has natural, built-in 
buffering against high-rate preemptions from lower nice-level 
SCHED_OTHER tasks. So while X will indeed get more CPU time (and that i 
think is fully justified), it wont get nearly as high of a 
context-switch rate as under priority/runqueue-based schedulers.

To demonstrate this i have done the following simple experiment: i 
started 4 xterms on a single-CPU box, then i started the 'yes' utility 
in each xterm and resized all of the xterms to just 2 lines vertical. 
This generates a _lot_ of screen refresh events. Naturally, such a 
workload utilizes the whole CPU.

Using CFS-v5, with Xorg at nice 0, the context-switch rate is low:

procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 2  0      0 472132  13712 178604    0    0     0    32  113  170 83 17  0  0  0
 2  0      0 472172  13712 178604    0    0     0     0  112  184 85 15  0  0  0
 2  0      0 472196  13712 178604    0    0     0     0  108  162 83 17  0  0  0
 1  0      0 472076  13712 178604    0    0     0     0  115  189 86 14  0  0  0

X's CPU utilization is 49%, xterm's go to 12% each. Userspace 
utilization is 85%, system utilization is 15%.

Renicing X to -10 increases context-switching, but not dramatically so, 
because it is throttled by CFS:

procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 4  0      0 475752  13492 176320    0    0     0    64  116 1498 85 15  0  0  0
 4  0      0 475752  13492 176320    0    0     0     0  107 1488 84 16  0  0  0
 4  0      0 475752  13492 176320    0    0     0     0  140 1514 86 14  0  0  0
 4  0      0 475752  13492 176320    0    0     0     0  107 1477 85 15  0  0  0
 4  0      0 475752  13492 176320    0    0     0     0  122 1498 84 16  0  0  0

The system is still usable, Xorg is 44% busy, each xterm is 14% busy. 
User utilization 85%, system utilization is 15% - just like in the first 
case.

"Performance of scrolling" is exactly the same in both cases (i have 
tested this by inserting periodic beeps after every 10,000 lines of text 
scrolled) - but the screen refresh rate is alot more eye-pleasing in the 
nice -10 case. (screen refresh it happens at ~500 Hz, while in the nice 
0 case it happens at ~40 Hz and visibly flickers. This is especially 
noticeable if the xterms have full size.)

I have tested the same workload on vanilla v2.6.21-rc7 and on SD-0.46
too, and they give roughly the same xterm scheduling behavior when Xorg 
is at nice 0:

procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 4  0      0 450564  14844 194976    0    0     0     0  287  594 58 10 32  0  0
 4  0      0 450704  14844 194976    0    0     0     0  108  370 89 11  0  0  0
 0  0      0 449588  14844 194976    0    0     0     0  175  434 85 13  2  0  0
 3  0      0 450688  14852 194976    0    0     0    32  242  315 62  9 29  0  0

but when Xorg is reniced to -10 on the vanilla or SD schedulers, it 
indeed gives the markedly higher context-switching behavior you 
predicted:

procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 5  0      0 452272  13936 194896    0    0     0     0  126 14147 78 22  0  0  0
 4  0      0 452252  13944 194896    0    0     0    64  155 14143 80 20  0  0  0
 5  0      0 452612  13944 194896    0    0     0     0  187 14031 79 21  0  0  0
 4  0      0 452624  13944 194896    0    0     0     0  121 14300 82 18  0  0  0

User time drops to 78%, system time increases to 22%. "Scrolling 
performance" clearly decreases.

so i agree that renicing X can be a very bad idea, but it very much 
depends on the scheduler implementation too.

	Ingo
