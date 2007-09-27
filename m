Return-Path: <linux-kernel-owner+w=401wt.eu-S1751226AbXI0MZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751226AbXI0MZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 08:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756394AbXI0MZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 08:25:28 -0400
Received: from mx10.go2.pl ([193.17.41.74]:41869 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750986AbXI0MZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 08:25:27 -0400
Date: Thu, 27 Sep 2007 14:27:46 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Schwartz <davids@webmaster.com>,
       "Linux-Kernel\@Vger\. Kernel\. Org" <linux-kernel@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Martin Michlmayr <tbm@cyrius.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: Network slowdown due to CFS
Message-ID: <20070927122746.GB2431@ff.dom.local>
References: <20070926133138.GA23187@elte.hu> <20070927093002.GA2431@ff.dom.local> <20070927094603.GA32469@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927094603.GA32469@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 11:46:03AM +0200, Ingo Molnar wrote:
> 
> * Jarek Poplawski <jarkao2@o2.pl> wrote:
> 
> > > the (small) patch below fixes the iperf locking bug and removes the 
> > > yield() use. There are numerous immediate benefits of this patch:
> > ...
> > > 
> > > sched_yield() is almost always the symptom of broken locking or other 
> > > bug. In that sense CFS does the right thing by exposing such bugs =B-)
> > 
> > ...Only if it were under some DEBUG option. [...]
> 
> note that i qualified my sentence both via "In that sense" and via a 
> smiley! So i was not suggesting that this is a general rule at all and i 
> was also joking :-)

Actually, I've analyzed this smiley for some time but these scheduler
jokes are really hard, and I definitely need more time...

> 
> > [...] Even if iperf is doing the wrong thing there is no explanation 
> > for such big difference in the behavior between sched_compat_yield 1 
> > vs. 0. It seems common interfaces should work similarly and 
> > predictably on various systems, and here, if I didn't miss something, 
> > linux looks like a different kind?
> 
> What you missed is that there is no such thing as "predictable yield 
> behavior" for anything but SCHED_FIFO/RR tasks (for which tasks CFS does 
> keep the behavior). Please read this thread on lkml for a more detailed 
> background:
> 
>    CFS: some bad numbers with Java/database threading [FIXED]
> 
>    http://lkml.org/lkml/2007/9/19/357
>    http://lkml.org/lkml/2007/9/19/328
> 
> in short: the yield implementation was tied to the O(1) scheduler, so 
> the only way to have the exact same behavior would be to have the exact 
> same core scheduler again. If what you said was true we would not be 
> able to change the scheduler, ever. For something as vaguely defined of 
> an API as yield, there's just no way to have a different core scheduler 
> and still behave the same way.
> 
> So _generally_ i'd agree with you that normally we want to be bug for 
> bug compatible, but in this specific (iperf) case there's just no point 
> in preserving behavior that papers over this _clearly_ broken user-space 
> app/thread locking (for which now two fixes exist already, plus a third 
> fix is the twiddling of that sysctl).
> 

OK, but let's forget about fixing iperf. Probably I got this wrong,
but I've thought this "bad" iperf patch was tested on a few nixes and
linux was the most different one. The main point is: even if there is
no standard here, it should be a common interest to try to not differ
too much at least. So, it's not about exactness, but 50% (63 -> 95)
change in linux own 'definition' after upgrading seems to be a lot.
So, IMHO, maybe some 'compatibility' test could be prepared to
compare a few different ideas on this yield and some average value
could be a kind of at least linux' own standard, which should be
emulated within some limits by next kernels?

Thanks,
Jarek P.
