Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbXI0Nbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbXI0Nbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 09:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754991AbXI0Nbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 09:31:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38693 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221AbXI0Nbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 09:31:44 -0400
Date: Thu, 27 Sep 2007 15:31:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: David Schwartz <davids@webmaster.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Martin Michlmayr <tbm@cyrius.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: Network slowdown due to CFS
Message-ID: <20070927133123.GA6901@elte.hu>
References: <20070926133138.GA23187@elte.hu> <20070927093002.GA2431@ff.dom.local> <20070927094603.GA32469@elte.hu> <20070927122746.GB2431@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927122746.GB2431@ff.dom.local>
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

> On Thu, Sep 27, 2007 at 11:46:03AM +0200, Ingo Molnar wrote:
[...]
> > What you missed is that there is no such thing as "predictable yield 
> > behavior" for anything but SCHED_FIFO/RR tasks (for which tasks CFS does 
> > keep the behavior). Please read this thread on lkml for a more detailed 
> > background:
> > 
> >    CFS: some bad numbers with Java/database threading [FIXED]
> > 
> >    http://lkml.org/lkml/2007/9/19/357
> >    http://lkml.org/lkml/2007/9/19/328
> > 
> > in short: the yield implementation was tied to the O(1) scheduler, so 
> > the only way to have the exact same behavior would be to have the exact 
> > same core scheduler again. If what you said was true we would not be 
> > able to change the scheduler, ever. For something as vaguely defined of 
> > an API as yield, there's just no way to have a different core scheduler 
> > and still behave the same way.
> > 
> > So _generally_ i'd agree with you that normally we want to be bug for 
> > bug compatible, but in this specific (iperf) case there's just no point 
> > in preserving behavior that papers over this _clearly_ broken user-space 
> > app/thread locking (for which now two fixes exist already, plus a third 
> > fix is the twiddling of that sysctl).
> > 
> 
> OK, but let's forget about fixing iperf. Probably I got this wrong, 
> but I've thought this "bad" iperf patch was tested on a few nixes and 
> linux was the most different one. The main point is: even if there is 
> no standard here, it should be a common interest to try to not differ 
> too much at least. So, it's not about exactness, but 50% (63 -> 95) 
> change in linux own 'definition' after upgrading seems to be a lot. 
> So, IMHO, maybe some 'compatibility' test could be prepared to compare 
> a few different ideas on this yield and some average value could be a 
> kind of at least linux' own standard, which should be emulated within 
> some limits by next kernels?

you repeat your point of "emulating yield", and i can only repeat my 
point that you should please read this:

    http://lkml.org/lkml/2007/9/19/357

because, once you read that, i think you'll agree with me that what you 
say is simply not possible in a sane way at this stage. We went through 
a number of yield implementations already and each will change behavior 
for _some_ category of apps. So right now we offer two implementations, 
and the default was chosen empirically to minimize the amount of 
complaints. (but it's not possible to eliminate them altogether, for the 
reasons outlined above - hence the switch.)

	Ingo
