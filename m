Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbZJBRL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbZJBRL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 13:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbZJBRL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 13:11:27 -0400
Received: from brick.kernel.dk ([93.163.65.50]:58836 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbZJBRL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 13:11:26 -0400
Date: Fri, 2 Oct 2009 19:11:29 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Vivek Goyal <vgoyal@redhat.com>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       riel@redhat.com
Subject: Re: IO scheduler based IO controller V10
Message-ID: <20091002171129.GG31616@kernel.dk>
References: <20090930202447.GA28236@redhat.com> <1254382405.7595.9.camel@marge.simson.net> <20091001185816.GU14918@kernel.dk> <1254464628.7158.101.camel@marge.simson.net> <20091002080417.GG14918@kernel.dk> <20091002092409.GA19529@elte.hu> <20091002092839.GA26962@kernel.dk> <alpine.LFD.2.01.0910020715160.6996@localhost.localdomain> <20091002145610.GD31616@kernel.dk> <alpine.LFD.2.01.0910020811490.6996@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910020811490.6996@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02 2009, Linus Torvalds wrote:
> 
> 
> On Fri, 2 Oct 2009, Jens Axboe wrote:
> > 
> > Mostly they care about throughput, and when they come running because
> > some their favorite app/benchmark/etc is now 2% slower, I get to hear
> > about it all the time. So yes, latency is not ignored, but mostly they
> > yack about throughput.
> 
> The reason they yack about it is that they can measure it.
> 
> Give them the benchmark where it goes the other way, and tell them why 
> they see a 2% deprovement. Give them some button they can tweak, because 
> they will.

To some extent that's true, and I didn't want to generalize. If they are
adament that the benchmark models their real life, then no amount of
pointing in the other direction will change that.

Your point about tuning is definitely true, these people are used to
tuning things. For the desktop we care a lot more about working out of
the box.

> But make the default be low-latency. Because everybody cares about low 
> latency, and the people who do so are _not_ the people who you give 
> buttons to tweak things with.

Totally agree.

> > I agree, we can easily make CFQ be very about about latency. If you
> > think that is fine, then lets just do that. Then we'll get to fix the
> > server side up when the next RHEL/SLES/whatever cycle is honing in on a
> > kernel, hopefully we wont have to start over when that happens.
> 
> I really think we should do latency first, and throughput second.
> 
> It's _easy_ to get throughput. The people who care just about throughput 
> can always just disable all the work we do for latency. If they really 
> care about just throughput, they won't want fairness either - none of that 
> complex stuff.

It's not _that_ easy, it depends a lot on the access patterns. A good
example of that is actually the idling that we already do. Say you have
two applications, each starting up. If you start them both at the same
time and just care for the dumb low latency, then you'll do one IO from
each of them in turn. Latency will be good, but throughput will be
aweful. And this means that in 20s they are both started, while with the
slice idling and priority disk access that CFQ does, you'd hopefully
have both up and running in 2s.

So latency is good, definitely, but sometimes you have to worry about
the bigger picture too. Latency is more than single IOs, it's often for
complete operation which may involve lots of IOs. Single IO latency is
a benchmark thing, it's not a real life issue. And that's where it
becomes complex and not so black and white. Mike's test is a really good
example of that.

-- 
Jens Axboe

