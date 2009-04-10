Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbZDJV1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbZDJV1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 17:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbZDJV1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 17:27:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750909AbZDJV1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 17:27:02 -0400
Date: Fri, 10 Apr 2009 14:16:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: righi.andrea@gmail.com, eric.y.miao@gmail.com,
       linux-kernel@vger.kernel.org, geert@linux-m68k.org, rjw@sisk.pl,
       arvidjaar@gmail.com, adaplas@gmail.com,
       linux-fbdev-devel@lists.sourceforge.net,
       linux-pm@lists.linux-foundation.org, davej@redhat.com,
       harvey.harrison@gmail.com, hannes@cmpxchg.org,
       stefanr@s5r6.in-berlin.de
Subject: Re: [REGRESSION] commit 66c1ca0: {fbmem: fix fb_info->lock and
 mm->mmap_sem ...} causes Xfbdev not working
Message-Id: <20090410141655.832e287d.akpm@linux-foundation.org>
In-Reply-To: <20090410222122.87be60f6.krzysztof.h1@poczta.fm>
References: <f17812d70904090436kd03744brca4a4bc4b85bba8@mail.gmail.com>
	<20090409125850.GA2727@linux>
	<20090410222122.87be60f6.krzysztof.h1@poczta.fm>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Apr 2009 22:21:22 +0200
Krzysztof Helt <krzysztof.h1@poczta.fm> wrote:

> On Thu, 9 Apr 2009 14:58:51 +0200
> Andrea Righi <righi.andrea@gmail.com> wrote:
> 
> > On Thu, Apr 09, 2009 at 07:36:24PM +0800, Eric Miao wrote:
> > > This happens on my Marvell PXA310-based Littleton platform with
> > > Angstrom Distribution. The offending paths are many:
> > > 
> > > FBIOPUT_VSCREENINFO:
> > >   lock_fb_info()
> > >   --> fb_set_var()
> > >     --> fb_notifier_call_chain() [FBINFO_MISC_USEREVENT]
> > >       --> fbcon_event_notifier() [FB_EVENT_MODE_CHANGE]
> > >         --> lock_fb_info()
> > > 
> > > OK, now hang. I'd suggest a clean fix to the original assumption of
> > > circular locking
> > > issue and revert this commit first.
> > > 
> > > -- 
> > > Cheers
> > > - eric
> > 
> > I can agree to revert 66c1ca019078220dc1bf968f2bb18421100ef147, since I
> > don't have a clean fix for this. Pushing down fb_info->lock in
> > fb_set_var() excluding to call fb_notifier_call_chain with fb_info->lock
> > held doesn't seem to be so trivial...
> > 
> > However, reverting this will re-introduce the circular locking
> > dependency fb_info->lock => mm->mmap_sem => fb_info->lock.
> > 
> 
> If anybody is interested I have looked into the code of the fb_mmap()
> and have found that the problem Andrea tried to fix is caused
> only by drivers which implements their own fb_mmap().
> 
> The correct solution is to push the info->lock mutex into
> the fb_mmap() implemented inside the drivers. Some drivers
> may not need it (the ones which only calculate offsets
> and do not "real" iommaping).
> 
> I'll try to prepare a patch after the Easters.

Thanks.

> This will require a revert
>  of the 66c1ca commit.

yes, I'll be queueing a revert of that when I get that far through my
backlog.  Today or tomorrow.

