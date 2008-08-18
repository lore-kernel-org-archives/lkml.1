Return-Path: <linux-kernel-owner+w=401wt.eu-S1752933AbYHRLYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbYHRLYk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 07:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbYHRLYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 07:24:32 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:25213 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751434AbYHRLYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 07:24:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=eIi9ExysllpahHsdssb8+7JaJ+jKvIgQwgUkjO6tOa2+xtnLKmWjQZ20ZF8RjWNKECMrj/dtEhG8igsg+arEZD0mFQ8zZ91JaMxPzJmGh9fQ1upA8fPekVFK35oWL/I0eau2WHKtBATRMX5xKbe9anY8V1yiQj4hfnxXjBF2lx0=  ;
X-YMail-OSG: neR9gRoVM1nW2TWLodn48ArafmBl9nqwDeF8xaIgbVT1wcJTeqFLQWZ3636wyMHB36xIuU_pEaTQr0IsLsMVkHlOa_T8PMot2sScs9wKLQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: SCHED_FIFO and SCHED_RR broken by cfs
Date: Mon, 18 Aug 2008 21:24:17 +1000
User-Agent: KMail/1.9.5
Cc: "Torvalds, Linus" <torvalds@linux-foundation.org>,
       Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
References: <1218880552.11912.9.camel@matrix> <200808182058.07346.nickpiggin@yahoo.com.au> <1219057765.10800.315.camel@twins>
In-Reply-To: <1219057765.10800.315.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808182124.17359.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 August 2008 21:09, Peter Zijlstra wrote:
> On Mon, 2008-08-18 at 20:58 +1000, Nick Piggin wrote:
> > On Monday 18 August 2008 20:50, Peter Zijlstra wrote:
> > > On Sun, 2008-08-17 at 23:04 +1000, Nick Piggin wrote:
> > > > On Sunday 17 August 2008 00:53, Peter Zijlstra wrote:
> > > > > Has nothing to do with CFS, but everything to do with the fact that
> > > > > we now have a 95% bandwidth control by default.
> > > > >
> > > > > Does doing:
> > > > >
> > > > > echo -1 > /proc/sys/kernel/sched_rt_runtime_us
> > > > >
> > > > > fix it?
> > > > >
> > > > > So, up to 95% cpu usage (per sched_rt_period_us) FIFO and RR behave
> > > > > like they always did, once they cross that line, they'll be
> > > > > throttled.
> > > > >
> > > > > 95% seemed like a sane default in that it leaves a little room to
> > > > > recover from a run-away rt process (esp handy now that !root users
> > > > > can also use RT scheduling classes), and should be enough for most
> > > > > applications as they usually don't consume all that much time.
> > > >
> > > > Did it seem sane to break POSIX and backwards compatiblity by
> > > > default?
> > >
> > > Up to a point, yes.
> > >
> > > There were quite a few complaints that runaway RT tasks could render a
> > > machine unusable - which made 'desktop' usage of the RT class unsafe.
> >
> > Right, but it is restricted to root, and if the task is run as root
> > then it can equally break the system in any number of ways. So the
> > complaints are just wrong.
>
> Not so, we have RLIMIT_RTPRIO and quite a few people using it.

OK, but it's the same as any privilige granted. You have to be careful
with it.

TBH, it's pretty trivial to write a watchdog process in your RT app.
Actually, many *real* RT applications use one in order to help with
failover/failstop/etc. and I expect _all_ non trivial ones should be
using a watchdog when under development or running in a debugging
mode.


> > I have no problems with having some non-default mode to throttle by
> > default. And we already have the sysrq which can downgrade RT tasks.
>
> Yeah - except that most distros disable sysrq and not a single desktop
> user knows about it.

What are they doing writing RT apps then?


> > > This 95%/1s default allows most RT tasks to run without having to
> > > tinker with the settings, and for those who do need something else,
> > > they can get it too, but will have to turn a knob.
> >
> > And that could also easily cause huge problems for code that does the
> > *right* thing.
> >
> > > But I guess we could change the default back to unlimited and default
> > > to unsafe if people feel strongly about this.
> >
> > Yes, you can't just break the API like this. Please do fix.
>
> Sigh - I guess that means all distros will just set a limit in their
> init scripts - leaving those above in the same situation.

Really, you think the enterprise distros will willingly break POSIX
and their own backwards compatiblity by default? I wouldn't have
thought so, but anyway I guess they are free to make that choice, so
where's the problem?
