Return-Path: <linux-kernel-owner+w=401wt.eu-S1755387AbXI0Jq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbXI0Jq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 05:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbXI0Jqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 05:46:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57418 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029AbXI0Jqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 05:46:48 -0400
Date: Thu, 27 Sep 2007 11:46:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: David Schwartz <davids@webmaster.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Martin Michlmayr <tbm@cyrius.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: Network slowdown due to CFS
Message-ID: <20070927094603.GA32469@elte.hu>
References: <20070926133138.GA23187@elte.hu> <20070927093002.GA2431@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927093002.GA2431@ff.dom.local>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jarek Poplawski <jarkao2@o2.pl> wrote:

> > the (small) patch below fixes the iperf locking bug and removes the 
> > yield() use. There are numerous immediate benefits of this patch:
> ...
> > 
> > sched_yield() is almost always the symptom of broken locking or other 
> > bug. In that sense CFS does the right thing by exposing such bugs =B-)
> 
> ...Only if it were under some DEBUG option. [...]

note that i qualified my sentence both via "In that sense" and via a 
smiley! So i was not suggesting that this is a general rule at all and i 
was also joking :-)

> [...] Even if iperf is doing the wrong thing there is no explanation 
> for such big difference in the behavior between sched_compat_yield 1 
> vs. 0. It seems common interfaces should work similarly and 
> predictably on various systems, and here, if I didn't miss something, 
> linux looks like a different kind?

What you missed is that there is no such thing as "predictable yield 
behavior" for anything but SCHED_FIFO/RR tasks (for which tasks CFS does 
keep the behavior). Please read this thread on lkml for a more detailed 
background:

   CFS: some bad numbers with Java/database threading [FIXED]

   http://lkml.org/lkml/2007/9/19/357
   http://lkml.org/lkml/2007/9/19/328

in short: the yield implementation was tied to the O(1) scheduler, so 
the only way to have the exact same behavior would be to have the exact 
same core scheduler again. If what you said was true we would not be 
able to change the scheduler, ever. For something as vaguely defined of 
an API as yield, there's just no way to have a different core scheduler 
and still behave the same way.

So _generally_ i'd agree with you that normally we want to be bug for 
bug compatible, but in this specific (iperf) case there's just no point 
in preserving behavior that papers over this _clearly_ broken user-space 
app/thread locking (for which now two fixes exist already, plus a third 
fix is the twiddling of that sysctl).

	Ingo
