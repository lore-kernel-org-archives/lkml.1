Return-Path: <linux-kernel-owner+w=401wt.eu-S1759454AbYDKJiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454AbYDKJiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 05:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758119AbYDKJiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 05:38:09 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:12302 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548AbYDKJiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 05:38:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QMuo32nOqLGIK4SiEQvGLIwv3hG2Fwg7hv/kRaTxeWrYFemYeSjGJKUhgLB5a86fPFqhQLAnppRSUbrPJvHzRHb31xtvZOZzFwIVX6yKJR3RvuXFJIeHhK+QcJezKXLVA9FopcvqX6F1a4+E5v/3E8WxUC6eq9o0zJ1wvRaOvVI=
Message-ID: <cfd18e0f0804110238l66fb60c8pa8ac934a2a43baa7@mail.gmail.com>
Date: Fri, 11 Apr 2008 11:38:05 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] proc: Add RLIMIT_RTTIME to /proc/<pid>/limits
Cc: "Michael Kerrisk" <mtk.manpages@gmail.com>,
       "Eugene Teo" <eugeneteo@kernel.sg>, linux-kernel@vger.kernel.org,
       "Neil Horman" <nhorman@tuxdriver.com>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1207906325.7153.2.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080208145950.GA3910@kernel.sg> <1202483445.6292.1.camel@lappy>
	 <517f3f820802280712o3d756b4fq46461b226515e1f2@mail.gmail.com>
	 <1204212100.12120.9.camel@twins>
	 <cfd18e0f0804110156l658107e5x1f2695cacfc3ac75@mail.gmail.com>
	 <1207904485.7074.28.camel@twins>
	 <cfd18e0f0804110216l3c679bb6ned83f5d58d1c9d66@mail.gmail.com>
	 <1207905668.7074.32.camel@twins>
	 <cfd18e0f0804110227w37915734r8ca31271a3dfc8ab@mail.gmail.com>
	 <1207906325.7153.2.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 11:32 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> On Fri, 2008-04-11 at 11:27 +0200, Michael Kerrisk wrote:
> > On Fri, Apr 11, 2008 at 11:21 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > >
> > > On Fri, 2008-04-11 at 11:16 +0200, Michael Kerrisk wrote:
> > > > On Fri, Apr 11, 2008 at 11:01 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > > > On Fri, 2008-04-11 at 10:56 +0200, Michael Kerrisk wrote:
> > > > > > On Thu, Feb 28, 2008 at 5:21 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > > > > >
> > > > > > > On Thu, 2008-02-28 at 16:12 +0100, Michael Kerrisk wrote:
> > > > > > > > Peter,
> > > > > > > >
> > > > > > > > Could you please provide some text describing RLIMIT_RTTIMEfor the
> > > > > > > > getrlimit.2 man page.
> > > > > > >
> > > > > > > The rlimit sets a timeout in [us] for SCHED_RR and SCHED_FIFO tasks.
> > > > > > > This time is measured between sleeps, so a schedule in RR or a
> > > > > > > preemption in either is not a sleep - the task needs to be dequeued and
> > > > > > > enqueued for the timer to reset.
> > > > > > >
> > > > > > > Upon reaching the cur limit we start giving SIGXCPU every second, upon
> > > > > > > reaching the hard limit we give SIGKILL - matching RLIMIT_CPU.
> > > > > > >
> > > > > > > Time is measured in tick granularity (for now).
> > > > > >
> > > > > > So I have another question: why is the granularity of this rlimit
> > > > > > microseconds?  On the one hand, specifying limits down at the
> > > > > > microsecond level seems (to my naive eye) unlikely to be useful.  (But
> > > > > > perhaps I have missed a thread where this was explained.)  On the
> > > > > > other hand, it means that on 32-bit the largest time limit we can set
> > > > > > is ~4000 seconds, and I wonder if there are scenarios where it might
> > > > > > be useful to have larger limits than that.
> > > > > >
> > > > > > Why not, for example, have a granularity of milliseconds?
> > > > >
> > > > > The us scale seemed the best fit in that it allows sub-ms granularity
> > > > > while still allowing for quite long periods too. I'd preferred ns scale
> > > > > as that is what we use throughout the scheduler where possible - but
> > > > > that seemed too restrictive at the high end.
> > > > >
> > > > > No real hard arguments either way.
> > > >
> > > > I'm curious: what scenarios require sub-millisecond timeouts?
> > >
> > > I'm not sure, nor will they actually work atm since its tick based.
> >
> > Just to make sure me and the man page are clear: by tick-based, you
> > mean the granularity is in jiffies, right?
>
> Yes, they are currently jiffy based - but I could do hrtimer if someone
> shows need.
>
> > > But
> > > I'm not wanting to exclude too many things, and 4k second upper limit is
> > > plenty large.
> >
> > Okay.
> >
> > And following on from my other conversation in this thread...  What
> > should/will be the specified behavior w.r.t. resetting or not
> > resetting the timer on a sched_yield()?
>
> I think I'll keep it as is; so sched_yield() will _not_ reset the
> counter. The rationale is that the process didn't actually stop running
> - it just got scheduled away.

Okay -- thanks.  I will make that clear in the man page.

Cheers,

Michael

-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug? Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html
