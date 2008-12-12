Return-Path: <linux-kernel-owner+w=401wt.eu-S1758207AbYLLJZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207AbYLLJZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 04:25:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756204AbYLLJYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 04:24:46 -0500
Received: from viefep13-int.chello.at ([62.179.121.33]:37846 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755894AbYLLJYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 04:24:44 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [patch] Performance Counters for Linux, v3
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: eranian@gmail.com
Cc: Vince Weaver <vince@deater.net>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <7c86c4470812120059s7f8e64a6h91ebeadbf938858d@mail.gmail.com>
References: <20081211155230.GA4230@elte.hu>
	 <Pine.LNX.4.64.0812111247510.22556@pianoman.cluster.toy>
	 <1229070345.12883.12.camel@twins>
	 <7c86c4470812120059s7f8e64a6h91ebeadbf938858d@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 12 Dec 2008 10:23:54 +0100
Message-Id: <1229073834.12883.41.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-12 at 09:59 +0100, stephane eranian wrote:
> Peter,
> 
> On Fri, Dec 12, 2008 at 9:25 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Thu, 2008-12-11 at 13:02 -0500, Vince Weaver wrote:
> >
> 
> >> Perfmon3 works for all of those 60 machines.  This new proposal works on a
> >> 2 out of the 60.
> >
> > s/works/is implemented/
> >
> >> Who is going to add support for all of those machines?  I've spent a lot
> >> of developer time getting prefmon going for all of those configurations.
> >> But why should I help out with this new inferior proposal?  It could all
> >> be another waste of time.
> >
> > So much for constructive critisism.. have you tried taking the design to
> > its limits, if so, where do you see problems?
> >
> People have pointed out problems, but you keep forgetting to answer them.

I thought some of that (and surely more to follow) has been
incorporated.

> For instance, people have pointed out that your design necessarily implies
> pulling into the kernel the event table for all PMU models out there. This
> is not just data, this is also complex algorithms to assign events to counters.
> The constraints between events can be very tricky to solve. If you get this
> wrong, this leads to silent errors, and that is really bad.

(well, its not my design - I'm just trying to see how far we can push it
out of sheer curiosity)

This has to be done anyway, and getting it wrong in userspace is just as
bad no? 

The _ONLY_ technical argument I've seen to do this in userspace is that
these tables and text segments are unswappable in-kernel - which doesn't
count too heavily in my book.

> Looking at Intel Core, Nehalem, or AMD64 does not reflect the reality of
> the complexity of this. Paul pointed out earlier the complexity on Power.
> I can relate to the complexity on Itanium (I implemented all the code in
> the user level libpfm for them).  Read the Itanium PMU description and I
> hope you'll understand.

Again, I appreciate the fact that multi-dimensional constraint solving
isn't easy. But any which way we turn this thing, it still needs to be
done.

> Events constraints are not going away anytime soon, quite the contrary.
> 
> Furthermore, event tables are not always correct. In fact, they are
> always bogus.
> Event semantics varies between steppings. New events shows up, others
> get removed.
> Constraints are discovered later on.
> 
> If you have all of that in the kernel, it means you'll have to
> generate a kernel patch each
> time. Even if that can be encapsulated into a kernel module, you will
> still have problems.

How is updating a kernel module (esp one that only contains constraint
tables) more difficult than upgrading a user-space library? That just
doesn't make sense.

> Furthermore, Linux commercial distribution release cycles do not
> align well with new processor
> releases. I can boot my RHEL5 kernel on a Nehalem system and it would
> be  nice not to have to
> wait for a new kernel update to get the full Nehalem PMU event table,
> so I can program more than
> the basic 6 architected events of Intel X86.

Talking with my community hat on, that is an artificial problem created
by distributions, tell them to fix it.

All it requires is a new kernel module that describes the new chip,
surely that can be shipped as easily as a new library.

> I know the argument about the fact that you'll have a patch with 24h
> on kernel.org. The problem
> is that no end-user runs a kernel.org kernel, nobody. Changing the
> kernel is not an option for
> many end-users, it may even require re-certifications for many customers.
> 
> I believe many people would like to see how you plan on addressing those issues.

You're talking to LKML here - we don't care about stuff older than -git
(well, only a little, but not much more beyond n-1).

What we do care about is technical arguments, and last time I checked,
hardware resource scheduling was an OS level job.

But if the PMU control is critical to the enterprise deployment of
$customer, then he would have to re-certify on the library update too.

If its only development phase stuff, then the deployment machines won't
even load the module so there'd be no problem anyway.

