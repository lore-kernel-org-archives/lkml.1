Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbYFAXAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbYFAXAI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 19:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbYFAW75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 18:59:57 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48462 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbYFAW75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 18:59:57 -0400
Date: Mon, 2 Jun 2008 01:00:40 +0200
From: Pavel Machek <pavel@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mtk.manpages@gmail.com, Hugh Dickins <hugh@veritas.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: sync_file_range(SYNC_FILE_RANGE_WRITE) blocks?
Message-ID: <20080601230040.GC2255@elf.ucw.cz>
References: <Pine.LNX.4.64.0805301451020.19914@blonde.site> <20080530204307.GA4978@ucw.cz> <Pine.LNX.4.64.0805311925190.27293@blonde.site> <20080531173950.c4f04028.akpm@linux-foundation.org> <Pine.LNX.4.64.0806010752510.24919@blonde.site> <20080601011501.199af80c.akpm@linux-foundation.org> <20080601114008.GC16843@elf.ucw.cz> <20080601133727.4e62ae55.akpm@linux-foundation.org> <20080601222202.GA2255@elf.ucw.cz> <20080601154736.2e9f5905.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080601154736.2e9f5905.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-06-01 15:47:36, Andrew Morton wrote:
> On Mon, 2 Jun 2008 00:22:02 +0200 Pavel Machek <pavel@suse.cz> wrote:

Hi!

> > > I sense a strangeness.  What are you actually trying to do with all of this?
> > 
> > Okay, so I have around 400MB of data, I want it compressed, optionally
> > encrypted and written to partition.
> > 
> > Now, if I do it "naturally", I do writes, followed by fsync.
> > 
> > That's bad, because kernel does not start write out immediately, and
> > we waste time with idle disk. (If data compress really well, or
> > encryption is off, this is significant).
> > 
> > So we improve on this, by doing sync_file_range(SYNC_FILE_RANGE_WRITE)
> > periodically. That keeps the disk busy, but occassionaly blocks the
> > cpu... wasting time (which mostly hurts in compression+encryption
> > case).
> 
> yep.  That's another use of sync_file_range(): to allow smart userspace
> to optimise the kernel's IO scheduling decisions.
> 
> > So... how can I keep _both_ cpu and disk busy?
> 
> pthread_create() ;)

Actually it is easy enough to do with fork(), but...

> How about this:
> 
> - Add a new SYNC_FILE_RANGE_NON_BLOCKING
> 
> - If userspace set that flag, turn on writeback_control.nonblocking
>   in __filemap_fdatawrite_range().
> 
> - test it a lot.

Works for me. Is the expectation that I code this? I can certainly
provide testing ;-).

> It will be userspace's responsibility to avoid burning huge amounts of
> CPU repeatedly calling sync_file_range() and having it not actually write
> anything.

Ok... I guess doing 10x sync_file_range() when writing 400MB of data
is not excessive?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
