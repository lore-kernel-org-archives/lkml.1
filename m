Return-Path: <linux-kernel-owner+w=401wt.eu-S1753564AbZE1WsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbZE1WsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 18:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbZE1WsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 18:48:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41143 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbZE1WsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 18:48:05 -0400
Date: Fri, 29 May 2009 00:47:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       fengguang.wu@intel.com, nigel@tuxonice.net, mm-commits@vger.kernel.org
Subject: Re: breaking drivers with low probability Re: [merged]
	pm-suspend-do-not-shrink-memory-before-suspend.patch removed from
	-mm tree
Message-ID: <20090528224756.GJ11477@elf.ucw.cz>
References: <200905261935.n4QJZtpP006624@imap1.linux-foundation.org> <200905282314.42528.rjw@sisk.pl> <20090528212422.GI11477@elf.ucw.cz> <200905290032.08516.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905290032.08516.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri 2009-05-29 00:32:07, Rafael J. Wysocki wrote:
> On Thursday 28 May 2009, Pavel Machek wrote:
> > 
> > On Thu 2009-05-28 23:14:41, Rafael J. Wysocki wrote:
> > > On Thursday 28 May 2009, Pavel Machek wrote:
> > > > 
> > > > > > > > ...i.e. 0 pages free. OTOH... I don't think you audited all the
> > > > > > > > drivers to verify they can handle it, nor you attempted to contact all
> > > > > > > > the driver authors to warn them they suspend/resume routines can now
> > > > > > > > be called with 0 free pages.
> > > > > > > 
> > > > > > > Are you sure we can actually get to this point with 0 free pages?
> > > > > > 
> > > > > > If I recall how mm works; yes I believe it is possible to hit this
> > > > > > with 0 free pages if you are unlucky. (Heavy memory pressure with some
> > > > > > network packet storm just before suspend...).
> > > > > > 
> > > > > > Do you think 0 pages free here is impossible?
> > > > > 
> > > > > I think it's just extremely unlikely, which is why I'm asking for a test case.
> > > > > If you have one, we can see what it takes to trigger and put a safeguard
> > > > > against _that_.
> > > > 
> > > > No, I do not have a test case, and I agree that it is quite
> > > > unlikely. But I dislike adding bugs in unlikely cases.
> > > > 
> > > > > > If so, what do you think minimum number of free pages here is and why?
> > > > > 
> > > > > Seriously, I don't know.  Only the drivers know how much memory they are
> > > > > going to need and _they_ should allocate it in advance.  When we get to
> > > > > their suspend callbacks it's already too late.
> > > > 
> > > > Tell that to the driver authors. At least one driver does allocate in
> > > > _suspend(), and probably more.
> > > > 
> > > > > Still, even if I knew, I think it would be better to just allocate that memory
> > > > > before we freeze tasks and then free it instead of using the current approach.
> > > > 
> > > > Agreed, it would be better. 
> > > > 
> > > > OTOH providing 4MB as a safety area for the drivers that don't do that
> > > > seems quite reasonable. Deleting the safety area would be fine, but I
> > > > believe we need to fix the drivers, first, or at least ask driver
> > > > writes to get them fixed.
> > > 
> > > Or perhaps we can see if it's really necessary.
> > 
> > How? We already know this bug is pretty unlikely to be caught by testing.
> > 
> > > > IOW I believe the patch should be reverted.
> > > 
> > > Linus is supporting this change and it's going to be easy enough to revert if
> > > it's confirmed to cause any problems.  Which I seriously doubt.
> > 
> > I already found one bug you introduced... by code inspection. (Will
> > you at least fix that?).
> 
> No, you didn't.  You only pointed out that there may be a problem in certain
> circumstances, but the probablility of these circumstances happening in
> practice is close to zero.

IOW you added bug that is hard to trigger.

> > I'm pretty sure there are more. You tell me
> > that "it can be reverted if it proves problematic". 
> > 
> > I already proved it problematic by code inspection.
> 
> No, you didn't prove anything.  Sorry.

Would you explain how much memory is guaranteed to be free for
drivers?  We know video/s1d13xxxfb.c needs some memory.

> > Please revert it.
> 
> If I know the exact mechanism by which we can exhaust memory before suspend
> so that casual allocations with kmalloc() from drviers' suspend callbacks will fail.
> Possible failure scenario, perhaps?

Just

0) create memory pressure from userland so that free memory goes down
to min_free_kbytes (GFP_KERNEL allocations)

1) hit network driver over fast enough network to eat remaining memory
with GFP_ATOMIC allocations

2) suspend with video/s1d13xxxfb.c loaded and your patch.

> > Testing _can not_ prove problematic. From analysis, we already know
> > suspend with 0 free pages is pretty unlikely.
> 
> So what's the point, really?

The point is that you can't assume GFP_ATOMIC allocations
work (suspend allocations run under similar rules, because swapping is
unavailable). And you added that assumption. Bad.

> In fact, the existing code doesn't solve any problem, because we don't know how
> much memory is going to be necessary anyway.  So, it doesn't eiliminate the
> issue if there is any, it only makes it a bit more difficult to trigger.

4MB is certainly enough for the video/s1d13xxxfb.c driver, so you
added at least one bug.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
