Return-Path: <linux-kernel-owner+w=401wt.eu-S933421AbXG3LrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933421AbXG3LrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 07:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760783AbXG3LrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 07:47:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60501 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758994AbXG3LrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 07:47:11 -0400
Date: Mon, 30 Jul 2007 13:46:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: John <darknessenvelops@gmail.com>
Cc: Kasper Sandberg <lkml@metanurb.dk>, ck@vds.kolivas.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ck] Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
Message-ID: <20070730114649.GB19186@elte.hu>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <1185536610.502.8.camel@localhost> <20070729170641.GA26220@elte.hu> <930f95dc0707291154j102494d9m58f4cc452c7ff17c@mail.gmail.com> <20070729204716.GB1578@elte.hu> <930f95dc0707291431j4e50214di3c01cd44b5597502@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <930f95dc0707291431j4e50214di3c01cd44b5597502@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* John <darknessenvelops@gmail.com> wrote:

> On 7/29/07, Ingo Molnar <mingo@elte.hu> wrote:
> >
> >
> > * John <darknessenvelops@gmail.com> wrote:
> >
> > > Ingo-
> > >
> > > Why not perform the same test using the native linux Q3 client to
> > > compare numbers to wine? [...]
> >
> > I regularly test native Linux games on CFS, and they all behave well.
> > While waiting for more detailed data from Kasper i was looking for
> > atypical stuff in Kasper's description about what his workload involves,
> > and what looked a bit atypical was that Kasper's workload also involved
> > gaming under Wine:
>
> I understand that, I was just wondering if the FPS scales the same 
> natively vs. Wine as I typically only run native games.  [...]

people are regularly testing 3D smoothness, and they find CFS good 
enough:

   http://bhhdoa.org.au/pipermail/ck/2007-June/007816.html

and that matches my experience as well (as limited as it may be). In 
general my impression is that CFS and SD are roughly on par when it 
comes to 3D smoothness.

The Wine+Quake3 numbers i posted yesterday are so bad under SD that they 
must be some artifact in SD (possibly related to yield - i've strace-ed 
the tasks under SD today and they are blocking in yield), so they are 
not really representative of the general quality of SD (unless you are 
being hit by that particular regression). Still it is kind of ironic 
that when i tried to find a 3D regression in CFS i found a 3D regression 
in SD.

What is more interesting (to me) is not the positive CFS feedback but 
negative CFS feedback (although positive feedback certain _feels_ good 
so dont hold it back intentionally ;-), and i cannot possibly give you 
any definitive answer: at this point CFS could still have artifacts and 
bugs, so "check and see yourself" is the best answer. All i can tell you 
is that there are no open 3D related regressions for CFS at the moment.

> [...] I have been hesitant to move over to CFS due to reports of 3D 
> issues and wanted to see if you had numbers in regards to CFS vs. SD.

i have no numbers now, other than the trivial native 'ppracer' game 
where SD and CFS have roughly the same framerate under load:

     SD           CFS
   0: 38.1      0: 38.1
   1: 24.0      1: 24.2
   2: 16.6      2: 16.1
   3: 11.9      3: 12.3
   4:  9.9      4:  9.7
   5:  8.2      5:  8.1

which i'd have expected, ppracer is quite CPU-intense on my test-system, 
and the fairness model of SD and CFS is similar for CPU-bound tasks.

But ... numbers from _me_ are suspect by definition, i wrote a good 
chunk of the CFS code :-) So it would be much more interesting if others 
provided more numbers.

Would you be interested in trying CFS and doing some numers perhaps? It 
requires some work: you have to start up your favorite game in a way 
that gives a reliable framerate number. (many games allow the display of 
FPS in-game) In Quake3 i simply started the game and did not move the 
player - that is something easy to reproduce.

then create load the following way, by entering this into a shell:

  while :; do :; done &

that will cause a shell to just loop infinitely, hogging the CPU. This 
is the "1 loop" case in the numbers i posted. Start several of them to 
get more. (Type 'killall bash' in the same terminal to get rid of them.) 
Monitor how the FPS of your game changes when you start more and more 
CPU hogs, and note the numbers. Repeat it under SD and CFS as well, and 
please post the results into this thread.

and note that CPU hogs are just one type of 'load' that a system can 
experience - IO load or networking load could impact your in-game 
experience just as much.

If you see any artifact or FPS reduction under CFS i'll give you further 
info about how to debug it (were you interested in debugging it).

	Ingo
