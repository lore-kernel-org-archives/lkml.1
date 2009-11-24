Return-Path: <linux-kernel-owner+w=401wt.eu-S932282AbZKXIke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbZKXIke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 03:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932266AbZKXIkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 03:40:33 -0500
Received: from mail.gmx.net ([213.165.64.20]:46037 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932264AbZKXIkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 03:40:33 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18+k5JlaCM+665Tp7I6FKEizHl6XMX3qA23SjhBzi
	0nkRSsfsCsfnoY
Subject: Re: newidle balancing in NUMA domain?
From: Mike Galbraith <efault@gmx.de>
To: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20091124065322.GC20981@wotan.suse.de>
References: <20091123112228.GA2287@wotan.suse.de>
	 <1258987059.6193.73.camel@marge.simson.net>
	 <20091123151152.GA19175@wotan.suse.de> <1258989704.4531.574.camel@laptop>
	 <20091123152931.GD19175@wotan.suse.de>
	 <1258991617.6182.21.camel@marge.simson.net>
	 <20091124065322.GC20981@wotan.suse.de>
Content-Type: text/plain
Date: Tue, 24 Nov 2009 09:40:35 +0100
Message-Id: <1259052035.8843.106.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 07:53 +0100, Nick Piggin wrote:
> On Mon, Nov 23, 2009 at 04:53:37PM +0100, Mike Galbraith wrote:
> > On Mon, 2009-11-23 at 16:29 +0100, Nick Piggin wrote:
> > 
> > > So basically about the least well performing or scalable possible
> > > software architecture. This is exactly the wrong thing to optimise
> > > for, guys.
> > 
> > Hm.  Isn't fork/exec our daily bread?
> 
> No. Not for handing out tiny chunks of work and attempting to do
> them in parallel. There is this thing called Amdahl's law, and if
> you write a parallel program that wantonly uses the heaviest
> possible primitives in its serial sections, then it doesn't deserve
> to go fast.

OK by me.  A bit if idle time for kbuild is easily cured with telling
make to emit more jobs, so there's enough little jobs to go around.

If x264 is declared dainbramaged, that's fine with me too.

> That is what IPC or shared memory is for. Vastly faster, vastly more
> scalable, vastly easier for scheduler balancing (both via manual or
> automatic placement).

All well and good for apps that use them.  Again, _I_ don't care either
way.  As stated, I wouldn't cry if newidle died a gruesome death, it has
irritated me more than you would ever like to hear about ;-)

> > > The fact that you have to coax the scheduler into touching heaps
> > > more remote cachelines and vastly increasing the amount of inter
> > > node task migration should have been kind of a hint.
> > > 
> > > 
> > > > Fork balancing only works until all cpus are active. But once a core
> > > > goes idle it's left idle until we hit a general load-balance cycle.
> > > > Newidle helps because it picks up these threads from other cpus,
> > > > completing the current batch sooner, allowing the program to continue
> > > > with the next.
> > > > 
> > > > There's just not much you can do from the fork() side of things once
> > > > you've got them all running.
> > > 
> > > It sounds like allowing fork balancing to be more aggressive could
> > > definitely help.
> > 
> > It doesn't. Task which is _already_ forked, placed and waiting over
> > yonder can't do spit for getting this cpu active again without running
> > so he can phone home.  This isn't only observable with x264, it just
> > rubs our noses in it.  It is also quite observable in a kbuild.  What if
> > the waiter is your next fork?
> 
> I'm not saying that vastly increasing task movement between NUMA
> nodes won't *help* some workloads. Indeed they tend to be ones that
> aren't very well parallelised (then it becomes critical to wake up
> any waiter if a CPU becomes free because it might be holding a
> heavily contended resource).

It absolutely will.  Your counter arguments are also fully valid.

> But can you apprciate that these are at one side of the spectrum of
> workloads, and that others will much prefer to keep good affinity?

Yup.  Anything with cache footprint.  That's why I thumped newidle on
it's pointy head.  Trouble is, there's no way to make it perfect for
both.  As is, there's some pain for both.  Maybe TOO much for big iron.

> No matter how "nice" your workload is, you can't keep traffic off
> the interconnect if the kernel screws up your numa placement.

Don't matter if it's NUMA pain.  Pain is pain.

> And also, I'm not saying that we were at _exactly_ the right place
> before and there was no room for improvement, but considering that
> we didn't have a lot of active _regressions_ in the balancer, we
> can really use that to our favour and concentrate changes in code
> that does have regressions. And be really conservative and careful
> with changes to the balancer.

No argument against caution.

	-Mike



