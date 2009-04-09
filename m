Return-Path: <linux-kernel-owner+w=401wt.eu-S933967AbZDIM7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933967AbZDIM7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 08:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758974AbZDIM7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 08:59:00 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:36542 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933813AbZDIM64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 08:58:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=nJYM971LY1AzCFjx92SANTL+5g/O1gnzn9ZJfO8SVXbXXMXg2k25wgfwZSBKojRi04
         Y3LVhzqYVp46Z9gHesU7XKxD/Sem2r7A4xDyNtZ8kFQWi8P32dq738pDICXmPotINHD0
         x1gVHe/kjv9utKaaRZEwzHrNJmWHRa63Py1J8=
Date: Thu, 9 Apr 2009 14:58:51 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrey Borzenkov <arvidjaar@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net,
       linux-pm@lists.linux-foundation.org, Dave Jones <davej@redhat.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [REGRESSION] commit 66c1ca0: {fbmem: fix fb_info->lock and
	mm->mmap_sem ...} causes Xfbdev not working
Message-ID: <20090409125850.GA2727@linux>
Mail-Followup-To: Eric Miao <eric.y.miao@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Krzysztof Helt <krzysztof.h1@poczta.fm>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Andrey Borzenkov <arvidjaar@gmail.com>,
	"Antonino A. Daplas" <adaplas@gmail.com>,
	linux-fbdev-devel@lists.sourceforge.net,
	linux-pm@lists.linux-foundation.org, Dave Jones <davej@redhat.com>,
	Harvey Harrison <harvey.harrison@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>
References: <f17812d70904090436kd03744brca4a4bc4b85bba8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f17812d70904090436kd03744brca4a4bc4b85bba8@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 09, 2009 at 07:36:24PM +0800, Eric Miao wrote:
> This happens on my Marvell PXA310-based Littleton platform with
> Angstrom Distribution. The offending paths are many:
> 
> FBIOPUT_VSCREENINFO:
>   lock_fb_info()
>   --> fb_set_var()
>     --> fb_notifier_call_chain() [FBINFO_MISC_USEREVENT]
>       --> fbcon_event_notifier() [FB_EVENT_MODE_CHANGE]
>         --> lock_fb_info()
> 
> OK, now hang. I'd suggest a clean fix to the original assumption of
> circular locking
> issue and revert this commit first.
> 
> -- 
> Cheers
> - eric

I can agree to revert 66c1ca019078220dc1bf968f2bb18421100ef147, since I
don't have a clean fix for this. Pushing down fb_info->lock in
fb_set_var() excluding to call fb_notifier_call_chain with fb_info->lock
held doesn't seem to be so trivial...

However, reverting this will re-introduce the circular locking
dependency fb_info->lock => mm->mmap_sem => fb_info->lock.

-Andrea
