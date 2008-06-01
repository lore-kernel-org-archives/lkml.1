Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbYFAWVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbYFAWVY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 18:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbYFAWVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 18:21:17 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48655 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbYFAWVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 18:21:17 -0400
Date: Mon, 2 Jun 2008 00:22:02 +0200
From: Pavel Machek <pavel@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mtk.manpages@gmail.com, Hugh Dickins <hugh@veritas.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: sync_file_range(SYNC_FILE_RANGE_WRITE) blocks?
Message-ID: <20080601222202.GA2255@elf.ucw.cz>
References: <20080530102619.GA2468@elf.ucw.cz> <Pine.LNX.4.64.0805301451020.19914@blonde.site> <20080530204307.GA4978@ucw.cz> <Pine.LNX.4.64.0805311925190.27293@blonde.site> <20080531173950.c4f04028.akpm@linux-foundation.org> <Pine.LNX.4.64.0806010752510.24919@blonde.site> <20080601011501.199af80c.akpm@linux-foundation.org> <20080601114008.GC16843@elf.ucw.cz> <20080601133727.4e62ae55.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080601133727.4e62ae55.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > I expect major users of this system call will be applications which do
> > > small-sized overwrites into large files, mainly databases.  That is,
> > > once the application developers discover its existence.  I'm still
> > > getting expressions of wonder from people who I tell about the
> > > five-year-old fadvise().
> > 
> > Hey, you have one user now, its called s2disk. But for this call to be
> > useful, we'd need asynchronous variant... is there such thing?
> 
> Well if you're asking the syscall to shove more data into the block
> layer than it can concurrently handle, sure, the block layer will
> block.  It's tunable...

No, no, I don't want to overload block layer. All I want is ...

> > Okay, I can fork and do the call from another process, but...
> 
> I sense a strangeness.  What are you actually trying to do with all of this?

Okay, so I have around 400MB of data, I want it compressed, optionally
encrypted and written to partition.

Now, if I do it "naturally", I do writes, followed by fsync.

That's bad, because kernel does not start write out immediately, and
we waste time with idle disk. (If data compress really well, or
encryption is off, this is significant).

So we improve on this, by doing sync_file_range(SYNC_FILE_RANGE_WRITE)
periodically. That keeps the disk busy, but occassionaly blocks the
cpu... wasting time (which mostly hurts in compression+encryption
case).

So... how can I keep _both_ cpu and disk busy?

> Bear in mind that sync_file_range() doesn't sync metadata (ie: indirect
> blocks).  So if they weren't already known to have been written, the
> data isn't safe.

I'm not trying to use this for correctness; I'm optimizing for
speed. At the end, I do fsync() anyway.  

> > - * range which are not presently under writeback.
> > + * range which are not presently under writeback. Notice that even this this
> > + *  may and will block if you attempt to write more than request queue size.
> 
> um, OK. I'll fix the grammar a bit there.

Thanks.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
