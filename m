Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbZEDJeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbZEDJeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 05:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbZEDJeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 05:34:13 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38546 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbZEDJeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 05:34:12 -0400
Date: Mon, 4 May 2009 11:36:28 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 3/4] PM/Hibernate: Use memory allocations to free
	memory (rev. 2)
Message-ID: <20090504093628.GD30306@elf.ucw.cz>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <alpine.LFD.2.01.0905021958480.4983@localhost.localdomain> <20090503093659.GA10278@elf.ucw.cz> <200905031835.06928.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905031835.06928.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-05-03 18:35:06, Rafael J. Wysocki wrote:
> On Sunday 03 May 2009, Pavel Machek wrote:
> > Hi!
> 
> Hi,
> 
> > > > Remove the shrinking of memory from the suspend-to-RAM code, where it is 
> > > > not really necessary.
> > > 
> > > Hmm. Shouldn't we do this _regardless_?
> > > 
> > > IOW, shouldn't this be a totally separate patch? It seems to be left-over 
> > > from when we shared the same code-paths, and before the split of the STR 
> > > and hibernate code?
> > > 
> > > IOW, shouldn't the very _first_ patch just be this part? That code doesn't 
> > > make any sense anyway (that FREE_PAGE_NUMBER really _is_ totally 
> > > arbitrary).
> > > 
> > > This part seems to be totally independent of all the other parts in your 
> > > patch-series. No?
> > 
> > I'm not sure this one is a good idea: drivers will need to allocate
> > memory during suspend/resume, and when processes are frozen/disk
> > driver is suspended, normal memory management will no longer work.
> > 
> > So, freeing 4M of memory before starting suspend seems like a good
> > idea. That way those small alocations will not fail.
> 
> I don't think we've ever had problems with the drivers having too little
> memory to suspend.

Well, we had the 4MB buffer there, so it is hardly surprising.

> I'm opting for removing this code and seeing if that leads to any regressions.
> If it does, we can still get some free memory by allocating and releasing it.

I believe we should. If we don't... we will not get any regression
reports, because it will probably just hang with black screen :-(, and
"being out of memory during suspend" is probably going to be hard to
reproduce.

Perhaps we should try to _eat_ all memory available during suspend to
test driver behaviour with 0 pages free?

	while (kmalloc(100, GFP_ATOMIC))
		;

in suspend path should just do it for testing.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
