Return-Path: <linux-kernel-owner+w=401wt.eu-S1755792AbXD0NDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792AbXD0NDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 09:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755794AbXD0NDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 09:03:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43746 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755789AbXD0NDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 09:03:44 -0400
Date: Fri, 27 Apr 2007 15:02:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Mark Lord <lkml@rtr.ca>,
       Zach Carter <linux@zachcarter.com>, buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070427130234.GA16558@elte.hu>
References: <20070425214704.GA32572@elte.hu> <1177596399.14496.1.camel@localhost> <200704261041.04838.gene.heskett@gmail.com> <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427115344.GA30706@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > > Compared to mainline?  I still think this is a 100% keeper for 
> > > desktop users like me.
> > 
> > Here its alot worse, just playing an ogg with ogg123 even without 
> > anything reniced (X is 0), just pressing a link in konqueror can 
> > make audio skip (ogg123 fails to fill the alsa buffer, and thus it 
> > skips).
> 
> update for lkml readers: this is some really 'catastrophic' condition 
> triggering on your box. Here ogg123 just never skips on an older 750 
> MHz box, which is 4-5 times slower than your 2GHz box - while i have 
> _fourty nice-0 infinite loops_ running. I.e. at this clearly 
> ridiculous load, at just 2.5% of CPU time ogg123 is just chugging 
> along nicely and never leaves out a beat.

i've done some ogg123 testing on another box, which should be very 
similar to yours (2GHz, 1 core used), running your .config on 
2.6.21-cfs-v6.

I started an ogg123 instance and i also started up 10 infinite loops (at 
nice-0) to create some competition for ogg123:

  Audio Device:   Advanced Linux Sound Architecture (ALSA) output

  Playing: ./music.ogg
  Ogg Vorbis stream: 2 channel, 44100 Hz
  Title: Track 01

system utilization:

 top - 13:24:24 up 1 min,  3 users,  load average: 2.79, 0.10, 0.21
 Tasks: 184 total,  12 running, 172 sleeping,   0 stopped,   0 zombie
 Cpu(s):100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Mem:   1017616k total,   211548k used,   806068k free,    12936k buffers

ogg123 never skips. Then i cranked up the load to 50 infinite loops (!). 
No problems whatsoever. No problems at 100 tasks either. No problems 
with 250 (!) nice-0 infinite loops running either:

 top - 13:11:54 up 3 min,  3 users,  load average: 215.64, 82.67, 30.38
 Tasks: 424 total, 254 running, 170 sleeping,   0 stopped,   0 zombie
 Cpu(s): 99.8%us,  0.2%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Mem:   1017616k total,   237868k used,   779748k free,    12916k buffers
 Swap:        0k total,        0k used,        0k free,   155472k cached

ogg123 just never leaves out a beat, output buffer never goes below 90%:

 Time: 03:14.10 [01:23.84] of 04:37.93  (133.0 kbps)  Output Buffer  90.6%

then i increased the load to 350 tasks competing with ogg123 for the CPU 
and ogg123 is still going strong:

 Time: 04:27.66 [00:10.28] of 04:37.93  (107.1 kbps)  Output Buffer  87.5%

at 500 tasks it's still borderline (output buffer sometimes dipping as 
low as 50%) and i thought 550 tasks would be it - but it needed 600 (!) 
nice-0 (!) infinite loops to compete for one poor CPU for me to hear the 
very first skip. And even at 600 tasks:

 top - 13:17:17 up 8 min,  3 users,  load average: 567.82, 338.00, 151.65
 Tasks: 774 total, 604 running, 170 sleeping,   0 stopped,   0 zombie
 Cpu(s): 99.9%us,  0.1%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st

the music is still enjoyable. It needed 650 tasks for the skipping to 
become frequent and unbearable.

so ogg123 under CFS is _ridiculously_ robust in all my testing and all 
systems i've tried.

so i think it has to be some other variable that causes that 
catastrophic skipping on your system. Could you try a few things to help 
me debug this problem:

 - make sure ogg123 is the only task accessing the sound hardware. E.g. 
   check via 'top' that no other task (such as esd) is trying to access
   it at the same time.

 - please start the ogg123 instance in a plain VGA text console, not
   under X. This would take X and the xterm out of the picture. (ogg123 
   updates the terminal frequently)

 - To exclude the possibility of FS and IO interaction, could you copy 
   your ogg file to /dev/shm and play it from there? Is it still 
   skipping?

if after these two tests ogg123 is still skipping badly for you then it 
would be nice to run ogg123 the following way:

   strace -f -ttt -TTT -o ogg123-trace.txt ogg123 ./your-music.ogg

and send me ogg123-trace.txt privately (compressed). Based on that 
output i'll try to come up with some more active debugging method. 
Thanks!

	Ingo
