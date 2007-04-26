Return-Path: <linux-kernel-owner+w=401wt.eu-S1031072AbXDZKbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031072AbXDZKbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 06:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031159AbXDZKbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 06:31:11 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41969 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031072AbXDZKbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 06:31:09 -0400
Date: Thu, 26 Apr 2007 12:30:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070426103051.GP17387@elf.ucw.cz>
References: <200704182245.24156.mail@earthworm.de> <20070418211632.GA7610@elte.hu> <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu> <1176947576.5906.21.camel@nigel.suspend2.net> <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424212408.GD16457@elf.ucw.cz> <1177582633.6814.29.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177582633.6814.29.camel@johannes.berg>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2007-04-26 12:17:12, Johannes Berg wrote:
> On Tue, 2007-04-24 at 23:24 +0200, Pavel Machek wrote:
> 
> > I believe uswsusp user/kernel separation is clean enough. Kernel
> > provides "snapshot image" and "resume image". (Thanks go to Rafael for
> > very clean interface).
> 
> The interface isn't even 64/32-bit compatible...

Which parts?

read/write on /dev/snapshot looks ok.

ioctl(SNAPSHOT_FREEZE, UNFREEZE, ATOMIC_RESTORE, FREE, FREE_SWAP_PAGE,
	SNAPSHOT_S2RAM,
	is okay, because it does not pass any data.

ioctl(ATOMIC_SNAPSHOT,
	returns 0/1 through pointer. Should be ok. (Maybe we should do 

		if (!error)
			error = put_user(in_suspend, (u32 __user *)arg);

	...instead, to make it very explicit?

ioctl(SET_IMAGE_SIZE,
	is okay, because it just uses arg directly.

ioctl(PMOPS,
	is okay, because it just uses arg directly... and it is in
	range 0-3 or something.

ioctl(AVAIL_SWAP,
	...hmm, is this the one you are complaining about? It returns
	loff_t through a pointer.  Maybe there's another interface
	that can return available swap, and we should use that, instead?

ioctl(GET_SWAP_PAGE,
	returns sector_t through a pointer. NOt sure if that's good
	idea, either.

ioctl(SET_SWAP_FILE,
	does old_decode_dev(arg). Is that ok?

ioctl(SET_SWAP_AREA,
	shares struct resume_swap_area between user and kernel. I
	guess that's bad..?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
