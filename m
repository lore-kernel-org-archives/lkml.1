Return-Path: <linux-kernel-owner+w=401wt.eu-S933177AbXCAJPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177AbXCAJPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 04:15:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933181AbXCAJPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 04:15:41 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33909 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933177AbXCAJPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 04:15:40 -0500
Date: Thu, 1 Mar 2007 10:15:21 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Oleg Nesterov <oleg@tv-sign.ru>,
       vatsa@in.ibm.com, Gautham R Shenoy <ego@in.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>, David Chinner <dgc@sgi.com>,
       Nigel Cunningham <ncunningham@linuxmail.org>
Subject: Re: [PATCH] Make XFS workqueues nonfreezable
Message-ID: <20070301091521.GA20171@elf.ucw.cz>
References: <200702272251.28844.rjw@sisk.pl> <200702282339.31234.rjw@sisk.pl> <20070228224443.GC19542@elf.ucw.cz> <200703010054.33536.rjw@sisk.pl> <20070301000351.ad3f641c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301000351.ad3f641c.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Since freezable workqueues are broken in 2.6.21-rc
> > (cf. http://marc.theaimsgroup.com/?l=linux-kernel&m=116855740612755,
> > http://marc.theaimsgroup.com/?l=linux-kernel&m=117261312523921&w=2)
> > it's better to change the only user of them, which is XFS, to use "normal"
> > nonfreezable workqueues.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  fs/xfs/linux-2.6/xfs_buf.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > Index: linux-2.6.21-rc2/fs/xfs/linux-2.6/xfs_buf.c
> > ===================================================================
> > --- linux-2.6.21-rc2.orig/fs/xfs/linux-2.6/xfs_buf.c
> > +++ linux-2.6.21-rc2/fs/xfs/linux-2.6/xfs_buf.c
> > @@ -1829,11 +1829,11 @@ xfs_buf_init(void)
> >  	if (!xfs_buf_zone)
> >  		goto out_free_trace_buf;
> >  
> > -	xfslogd_workqueue = create_freezeable_workqueue("xfslogd");
> > +	xfslogd_workqueue = create_workqueue("xfslogd");
> >  	if (!xfslogd_workqueue)
> >  		goto out_free_buf_zone;
> >  
> > -	xfsdatad_workqueue = create_freezeable_workqueue("xfsdatad");
> > +	xfsdatad_workqueue = create_workqueue("xfsdatad");
> >  	if (!xfsdatad_workqueue)
> >  		goto out_destroy_xfslogd_workqueue;
> >  
> 
> Won't this break suspend+XFS?
> 
> If so, and given that nobody seems to be reporting this deadlock, perhaps
> we'd be better off leaving things as-is for the while?

Worst case is not breaking suspend+XFS, worst case is XFS writing to
disk after freeze(), leading to subtle fs corruption.

(But noone could reproduce corruption before, and I was told XFS will
not do those writes these days).
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
