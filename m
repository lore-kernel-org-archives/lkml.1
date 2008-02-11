Return-Path: <linux-kernel-owner+w=401wt.eu-S1760907AbYBKXbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760907AbYBKXbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 18:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757018AbYBKXbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 18:31:24 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:25426 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676AbYBKXbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 18:31:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=C4ZTsbJa6oxu8iYUBKlKvy7cuo9a7PIfveBbJeA14fX5nW+WRdER+NWBCK83e8XUAoCEnfn77Tm5cz5uAb1g6wtJLQSZHWC9P7ZzLzlUWiuG5uK8jv2qPSylq0eN0x2GROpTao6lPgf8PyaNQ7PcjjsfDYM3RdlHyZQ8PUUpAGw=
Message-ID: <5a4c581d0802111531qf6fe2d0tf4878caefef958d3@mail.gmail.com>
Date: Tue, 12 Feb 2008 00:31:21 +0100
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.24-git2: Oracle 11g VKTM process enters R state on startup and is unkillable [still broken in 2.6.25-rc1]
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <200802120012.35314.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5a4c581d0802110820l1fcbb1ffib874f268b4ab7eae@mail.gmail.com>
	 <20080211204921.GA24806@elte.hu> <20080211221034.GA2587@elte.hu>
	 <200802120012.35314.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 12, 2008 12:12 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, 11 of February 2008, Ingo Molnar wrote:
> >
> > * Ingo Molnar <mingo@elte.hu> wrote:
> >
> > > no, they were not lost, they just didnt pass QA here (they crashed on
> > > a particularly hard to debug 8-way box i have) and Peter worked on
> > > that queue of fixes up until today to get it really correct. Could you
> > > check:
> > >
> > >    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git
> > >
> > > combo patch below as well - whichever you prefer. The shortlog can be
> > > found below as well - but i dont yet consider this pullable, i'd like
> > > it to see pass a full night of randconfig tests on my test-systems.
> >
> > ok, we just found the reason for the 8-way crash, the delta fix from
> > Peter is below if any of you have tried the previous combo patch.
> > Updated sched.git as well, new HEAD is
> > fec13e45305d69fd0bd23b30bd05a0a42cf341f8.
>
> With the previous patch and this patch applied, the issue is not reproducible
> here.
>
> Thanks,
> Rafael

The problem is fixed for me as well with the previous patch + the patch
 below, VKTM now enters S state and Oracle shuts down properly again.

Thanks !

> > Index: linux-2.6/kernel/sched.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/sched.c
> > +++ linux-2.6/kernel/sched.c
> > @@ -219,6 +219,10 @@ static void start_rt_bandwidth(struct rt
> >       if (rt_b->rt_runtime == RUNTIME_INF)
> >               return;
> >
> > +     if (hrtimer_active(&rt_b->rt_period_timer))
> > +             return;
> > +
> > +     spin_lock(&rt_b->rt_runtime_lock);
> >       for (;;) {
> >               if (hrtimer_active(&rt_b->rt_period_timer))
> >                       break;
> > @@ -229,6 +233,7 @@ static void start_rt_bandwidth(struct rt
> >                             rt_b->rt_period_timer.expires,
> >                             HRTIMER_MODE_ABS);
> >       }
> > +     spin_unlock(&rt_b->rt_runtime_lock);
> >  }
> >
> >  #ifdef CONFIG_RT_GROUP_SCHED

--alessandro

 "We act as though comfort and luxury were the chief requirements
   of life, when all that we need to make us really happy is
   something to be enthusiastic about."

   (Charles Kingsley)
