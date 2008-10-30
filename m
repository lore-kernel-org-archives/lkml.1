Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbYJ3HE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbYJ3HE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 03:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbYJ3HEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 03:04:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60280 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752878AbYJ3HEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 03:04:50 -0400
Date: Thu, 30 Oct 2008 00:04:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ray Lee" <ray-lk@madrabbit.org>
Cc: "Arjan van de Ven" <arjan@infradead.org>,
       "Marcin Slusarz" <marcin.slusarz@gmail.com>,
       "Carlos R. Mafra" <crmafra2@gmail.com>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.28-rc1 regression] wmifinfo dockapp takes 100% of cpu
 (bisected)
Message-Id: <20081030000442.fdc831c1.akpm@linux-foundation.org>
In-Reply-To: <2c0942db0810251238u7eae212ct76af5c6d05126260@mail.gmail.com>
References: <20081025094043.GA4438@localhost.aei.mpg.de>
	<490327B6.2090903@linux.intel.com>
	<20081025071348.63c426d9@infradead.org>
	<20081025162503.GA4001@localhost.aei.mpg.de>
	<20081025180322.GA10932@joi>
	<20081025121244.07cdd6d7@infradead.org>
	<2c0942db0810251238u7eae212ct76af5c6d05126260@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Oct 2008 12:38:22 -0700 "Ray Lee" <ray-lk@madrabbit.org> wrote:

> On Sat, Oct 25, 2008 at 12:12 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> > On Sat, 25 Oct 2008 20:03:27 +0200
> > Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> >> > >           if (copy_from_user(&tv, tvp, sizeof(tv)))
> >> > >                   return -EFAULT;
> >> > >
> >> > > +         while (tv.tv_usec > USEC_PER_SEC && i < 1000) {
> >>                                   ^
> >> should be >=
> >
> > yeah thanks for catching that. Note to self: don't code before coffee
> >
> > I'm not very happy with a while loop; but at least it solves the problem
> >
> > I'll try to make it nicer than this ...
> 
> Regardless, you may wish to make a set_normalized_timeval and place it
> in kernel/time.c right after the current set_nromalized_timespec.

Yes, this comes up fairly regularly and we would benefit from having a
normalize-a-timeval library function.

I don't think it should be implemented via a while loop though.  That's
acceptable with timespecs, which can only loop four or so times.  But
timevals use microseconds and can loop thousands of times and hence a
normalization function should use division.

