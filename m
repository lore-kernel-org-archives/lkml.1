Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbZHGISx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbZHGISx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 04:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757207AbZHGISw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 04:18:52 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:43191 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757070AbZHGISu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 04:18:50 -0400
Date: Fri, 7 Aug 2009 10:18:47 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] timers fixes for 2.6.31
Message-ID: <20090807101847.2ee08c76@skybase>
In-Reply-To: <1f1b08da0908061536o57cebeb6r2f522cb3c5419e1@mail.gmail.com>
References: <alpine.LFD.2.00.0907302158180.2936@localhost.localdomain>
	<alpine.LFD.2.01.0907301648540.3161@localhost.localdomain>
	<20090731123711.GA5421@elte.hu>
	<1f1b08da0908061536o57cebeb6r2f522cb3c5419e1@mail.gmail.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Aug 2009 15:36:36 -0700
john stultz <johnstul@us.ibm.com> wrote:

> On Fri, Jul 31, 2009 at 5:37 AM, Ingo Molnar<mingo@elte.hu> wrote:
> > [ Markus, John: the fix looks right for .31 but i think there's two
> >  small structural problems with this code, which might have
> >  contributed to the bug to happen to begin with:
> >
> >  Firstly, ->mult_orig is a slight misnomer - if it was named
> >  properly we wouldnt even need the comments to explain how to use
> >  and update it. It's the unadjusted multiplicator while _orig
> >  patterns in the kernel generally suggest some sort of save/restore
> >  pattern (which this is not).
> >
> >  I'd suggest to rename it to ->mult_unadjusted, ->mult_raw or
> >  ->mult_static instead. This field has not gotten into many
> >  clocksource drivers yet so it's easy to do. For .32 obviously.
> >
> >  Secondly, the broader design question is: why are clocksource
> >  drivers mucking around with NTP details? Whether NTP is running
> >  should be a transparent detail to drivers and if such details are
> >  visible in low level driver (which they are in
> >  arch/arm/plat-omap/common.c et al) that's sign of uncleanliness.
> >  Mind improving that? (for .32 too)
> 
> Well, the clocksources aren't really mucking with NTP details, but NTP
> mucks with the clocksource.  And so this was a way to try to preserve
> the original mult value,  and I'll admit was a bit stapled on.  This
> mostly comes from how the clocksource structure has swelled over time
> to include quite a bit of timekeeping specific information.
> 
> Splitting this up has been on my list for awhile, but I've never
> gotten to it. However, Martin Schwidefsky has been doing a great job
> with his latest patches cleaning up some of uglier parts of the
> timekeeping/clocksource interactions. There is still lots of  changes
> I'd like to see, but they will take time as we still haven't gotten
> all the arches over to GENERIC_TIME, so some cruft has to stick
> around.   But Martin's patches are a great big step towards it and
> hopefully his patches will be ready for .32.

The question what we do with the mult_orig on clocksource
enable/disable is one of the remaining open issues with my patch set.
With the NTP adjusted multiplicator in the struct timekeeper we don't
have a convenient place to keep the NTP adjusted multiplier while a
clocksource is disabled. My initial thought was: why do we store the
old multiplier at all? Its not that the clocksource changes all the
time and NTP will catch up again if it is changed. Just start from
scratch with the initial multiplicator.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

