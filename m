Return-Path: <linux-kernel-owner+w=401wt.eu-S1758912AbXGCIbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912AbXGCIbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 04:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbXGCIbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 04:31:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41868 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753683AbXGCIbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 04:31:42 -0400
Date: Tue, 3 Jul 2007 10:31:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Keith Packard <keith.packard@intel.com>
Cc: Mike Galbraith <efault@gmx.de>, Vegard Nossum <vegard.nossum@gmail.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v18
Message-ID: <20070703083133.GC13149@elte.hu>
References: <20070622220202.GA16872@elte.hu> <19f34abd0707020444r47221944tf7f33b2a0d17c367@mail.gmail.com> <b647ffbd0707020601r774a38d4gb62b6c07f1b5db32@mail.gmail.com> <19f34abd0707020643g6a274db5q1d25cabd85b9a25f@mail.gmail.com> <20070702155029.GA13241@elte.hu> <19f34abd0707020940r517cbe42sa443d191439e5f54@mail.gmail.com> <1183446743.7070.14.camel@Homer.simpson.net> <20070703072252.GB29984@elte.hu> <1183450089.29867.36.camel@neko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183450089.29867.36.camel@neko.keithp.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Keith Packard <keith.packard@intel.com> wrote:

> On Tue, 2007-07-03 at 09:22 +0200, Ingo Molnar wrote:
> 
> > which allows xterm-spam (attached) to easily flood the xterm 
> > (without any scrolling that would act as a throttle) and the xterm 
> > to flood Xorg.
> 
> It's just an Xterm bug.
> 
> Xterm will look for X input if it ever manages to fill the input 
> buffer past 32768 bytes. If it manages to get more than 4096 bytes in 
> one read, it will invoke sched_yield. and then check for input. Gotta 
> love that sched_yield call.
> 
> As it always processes all of the incoming data before trying to read 
> again, there doesn't appear to be any way it can ever have more than 
> 32768 characters in the buffer.
> 
> And, as the kernel will not buffer more than 4095 bytes from a pty, 
> there isn't any way it will ever read 4096 bytes.
> 
> So, it sits there carefully reading every byte from the pty and 
> painting them on the screen.

ah. Thanks for the explanation!

> You can 'fix' xterm with:
> 
> $ xterm -xrm '*minBufSize: 4095'

indeed, that solves the xterm-spam Ctrl-C/Ctrl-Z problem here!

> I hesitate to even suggest a patch to xterm that would solve this 
> problem correctly. Note that xterm has kludges in several of the 
> output processing steps which explicitly look for input (most vertical 
> cursor motion, it seems), which is why any application which scrolls 
> doesn't cause this problem.
> 
> Do you need more reasons to switch to another terminal emulator? 
> gnome-terminal has finally gotten reasonable; I expect rxvt or konsole 
> would work just as well.

yeah, i use gnome-terminal exclusively. But testers looking for CFS 
regressions do run every shell on the planet :-)

gnome-terminal is also faster all around (at least on my box):

 $ (echo '#!/bin/bash' ; echo 'for ((i=0; i<100000; i++)); do echo $i; done') > 1.sh; chmod +x 1.sh; time xterm $HOME/1.sh; time gnome-terminal  -x ./1.sh

 real    0m3.193s
 user    0m2.840s
 sys     0m0.460s

 real    0m2.495s
 user    0m2.430s
 sys     0m1.520s

	Ingo
