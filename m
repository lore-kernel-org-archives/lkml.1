Return-Path: <linux-kernel-owner+w=401wt.eu-S1761685AbZDCIQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761685AbZDCIQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 04:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762060AbZDCIPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 04:15:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43200 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762046AbZDCIPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 04:15:39 -0400
Date: Fri, 3 Apr 2009 10:15:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>, Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Andrew Morton <akpm@linux-foundation.org>, tytso@mit.edu,
       drees76@gmail.com, jesper@krogh.cc,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Linux 2.6.29
Message-ID: <20090403081514.GA21325@elte.hu>
References: <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090401143622.b1885643.akpm@linux-foundation.org> <20090402010044.GA16092@elte.hu> <20090403040649.GF3795@csclub.uwaterloo.ca> <alpine.LFD.2.00.0904022112260.4130@localhost.localdomain> <20090403072507.GO5178@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403072507.GO5178@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Thu, Apr 02 2009, Linus Torvalds wrote:

> > On Fri, 3 Apr 2009, Lennart Sorensen wrote:

> > > So so far I would rank anticipatory at about 1000x better than 
> > > cfq for my work load.  It sure acts a lot more like it used to 
> > > back in 2.6.18 times.
[...]

> > Jens - remind us what the problem with AS was wrt CFQ?
> 
> CFQ was just faster, plus it supported things like io priorities 
> that AS does not.

btw., while pluggable IO schedulers have their upsides:

 - They are easier to test during development and deployment.

 - The uptick of a new, experimental IO scheduler is faster due to 
   easier availability.

 - Regressions in the primary IO scheduler are easier to prove.

And the technical case for pluggable IO schedulers is much stronger 
than the case for pluggable process schedulers:

 - Persistent media has persistent workloads - and each workload has
   different access patterns.

 - The inefficiencies of mixed workloads on the same rotating media
   have forced a clear separation of the 'one disk, one workload'
   usage model, and has hammered this down people's minds. (Nobody 
   in their right mind is going to put a big Oracle and SAP
   installation on the same [rotating] disk.)

 - the 'NOP' scheduler makes sense on media with RAM-like
   properties. 90% of CFQ's overhead is useless fluff on such media.

 - [ These properties are not there for CPU schedulers: CPUs are 
     data processors not persistent data storage so they are 
     fundamentally shared by all workloads and have a lot less
     persistent state - so mixing workloads on CPUs is common and
     having one good scheduler is paramount. ]

At the risk of restarting the "to plug or not to plug" scheduler 
flamewars ;-), the pluggable IO scheduler design has its very clear 
downsides as well:

 - 99% of users use CFQ, so any bugs in it will hit 99% of the Linux 
   community and we have not actually won much in terms of helping 
   real people out in the field.

 - We are many years down the road of having replaced AS with the
   supposedly better CFQ - and AS is still (or again?) markedly
   better for some common tests.

 - The 1% of testers/users who find that CFQ sucks and track it down
   to CFQ can easily switch back to another IO scheduler: NOP or AS. 

   This dillutes the quality of _CFQ_, our crown jewel IO scheduler: 
   as it removes critical participiants from the pool of testers. 
   They might be only 1% of all Linux users, but they are the 1% who 
   make things happen upstream.

   The result: even if CFQ sucks for some important workloads, the
   combined social pressure is IMO never strong enough on upstream
   to get our act together. While we might fix the bugs reported 
   here, the time to realize and address these bugs was way too 
   long. Power-users configure they way out and go the path of least 
   resistance and the rest suffers in silence.

 - There's not even any feedback in the common case: people think
   "hey, what I'm doing must be some oddball thing" and leave it at 
   that. Even if that oddball thing is not odd at all. Furthermore, 
   getting feedback _after_ someone has solved their problems by 
   switching to AS is a lot harder than getting feedback while they 
   are still hurting and cursing. Yesterday's solved problem is 
   boring and a lot less worthy to report than today's high-prio 
   ticket.

 - It is _too easy_ to switch to AS, and shops with critical data 
   will not be as eager to report CFQ problems, and will not be as 
   eager to test experimental kernel patches that fix CFQ problems, 
   if they can switch to AS at the flip of a switch.

Ergo, i think pluggable designs for something as critical and as 
central as IO scheduling has its clear downsides as it created two 
mediocre schedulers:

 - CFQ with all the modern features but performance problems on 
   certain workloads

 - Anticipatory with legacy features only but works (much!) better 
   on some workloads.

... instead of giving us just a single well-working CFQ scheduler.

This, IMHO, in its current form, seems to trump the upsides of IO 
schedulers.

So i do think that late during development (i.e. now), _years_ down 
the line, we should make it gradually harder for people to use AS.

I'd not remove the AS code per se (it _is_ convenient to test it 
without having to patch the kernel - especially now that we _know_ 
that there is a common problem, and there _are_ genuinely oddball 
workloads where it might work better due to luck or design), but 
still we should:

 - Make it harder to configure in.

 - Change the /sys switch-to-AS method to break any existing scripts
   that switched CFQ to AS. Add a warning to the syslog if an old 
   script uses the old method and document the change prominetly but 
   do _not_ switch the IO scheduler to AS.

 - If the user still switched to AS, emit some scary warning about 
   this being an obsolete IO scheduler, that it is not being tested 
   as widely as CFQ and hence might have bugs, and that if the user
   still feels absolutely compelled to use it, to report his problem 
   to the appropriate mailing lists so that upstream can fix CFQ 
   instead.

By splintering the pool of testers and by removing testers from that 
pool who are the most important in getting our default IO scheduler 
tested we are not doing ourselves any favors.

Btw., my personal opinion is that even such extreme measures dont 
work fully right due to social factors, so _my_ preferred choice for 
doing such things is well known: to implement one good default 
scheduler and to fix all bugs in it ;-)

For IO schedulers i think there's just two sane technical choices 
for plugins: one good default scheduler (CFQ) or no IO scheduler at 
all (NOP).

The rest is development fuzz or migration fuzz - and such fuzz needs 
to be forced to zero after years of stabilization.

What do you think?

	Ingo
