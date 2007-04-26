Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbXDZNzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbXDZNzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 09:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808AbXDZNzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 09:55:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48950 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806AbXDZNzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 09:55:33 -0400
Date: Thu, 26 Apr 2007 15:55:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michael Gerdau <mgd@technosis.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Gene Heskett <gene.heskett@gmail.com>,
       Juliusz Chroboczek <jch@pps.jussieu.fr>, Mike Galbraith <efault@gmx.de>,
       Peter Williams <pwil3058@bigpond.net.au>, ck list <ck@vds.kolivas.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [REPORT] cfs-v6-rc2 vs sd-0.46 vs 2.6.21-rc7
Message-ID: <20070426135509.GA29832@elte.hu>
References: <200704261312.25571.mgd@technosis.de> <20070426120723.GA4092@elte.hu> <200704261522.43347.mgd@technosis.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704261522.43347.mgd@technosis.de>
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


* Michael Gerdau <mgd@technosis.de> wrote:

> In general sd tends to finish all three such jobs at roughly the same 
> time while cfs clearly "favors" the LTMM-type jobs (which admittedly 
> involve the least computations). I don't really know why that is so.

for the reason of this, look at the raw user runtimes the 3 jobs have:

  5498.128  secs            # LTMM
  7559.777  secs
  7600.179  secs

the "perfect scheduler" would run each of the jobs at 33.33% of capacity 
for ~5500 CPU-seconds, and would then run the remaining two jobs at 
50.0% capacity for about ~2075 CPU-seconds.

Why? Because the scheduler how no idea how much each job takes! So a 
fair scheduler would run: 3 jobs at 33.33% capacity for as long as the 
shortest job ends, then the remaining 2 jobs at 50% capacity for as the 
shorter one of the remaining 2 finishes, and the remaining one at 100%.

in your case that means that the best scheduling would be roughly the 
following ideal timeline:

   5500*3 / 2 ==  8250 seconds for the LTMM to finish
   2075*2 / 2 == +2075 more seconds for the other two jobs to finish.

the various runs showed the following wallclock-time timeline for the 
LTMM phase:

   CFS #1:  real    142m56.806s
   CFS #2:  real    125m58.235s
   SD:      real    140m16.127s
   vanilla: real    133m50.274s

the "ideal" is ~137 minutes (8250 seconds) for the LTMM phase. The 
closest was indeed SD, but vanilla and cfs #1 wasnt too far away from it 
either. [ and the variance between CFS #1 and #2 seems to suggest that 
the noise of this particular metric is significant. The average does 
come in at 134.5, which is quite close to the ideal number. ]

	Ingo
