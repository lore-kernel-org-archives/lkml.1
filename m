Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbYDJDHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbYDJDHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 23:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbYDJDHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 23:07:32 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:37354 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbYDJDHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 23:07:31 -0400
Date: Thu, 10 Apr 2008 05:07:30 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Bill Davidsen <davidsen@tmr.com>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>, agk@redhat.com,
       mingo@redhat.com, neilb@suse.de
Subject: Re: Data corruption on software RAID
In-Reply-To: <47FD0BE8.4070105@tmr.com>
Message-ID: <Pine.LNX.4.64.0804100503160.26713@artax.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0804080033430.13352@artax.karlin.mff.cuni.cz>
 <47FD0BE8.4070105@tmr.com>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Possibilities how to fix it:
> >
> > 1. lock the buffers and pages while they are being written --- this would
> > cause performance degradation (the most severe degradation would be in case
> > when one process does repeatedly sync() and other unrelated process
> > repeatedly writes to some file).
> >
> > Lock the buffers and pages only for RAID --- would create many special cases
> > and possible bugs.
> >
> > 2. never turn the region dirty bit off until the filesystem is unmounted.
> > --- this is the simplest fix. If the computer crashes after a long time, it
> > resynchronizes the whole device. But there won't cause application-visible
> > or filesystem-visible data corruption.
> >
> > 3. turn off the region bit if the region wasn't written in one pdflush
> > period --- requires an interaction with pdflush, rather complex. The problem
> > here is that pdflush makes its best effort to write data in
> > dirty_writeback_centisecs interval, but it is not guaranteed to do it.
> >
> > 4. make more region states: Region has in-memory states CLEAN, DIRTY,
> > MAYBE_DIRTY, CLEAN_CANDIDATE.
> >
> > When you start writing to the region, it is always moved to DIRTY state (and
> > on-disk bit is turned on).
> >
> > When you finish all writes to the region, move it to MAYBE_DIRTY state, but
> > leave bit on disk on. We now don't know if the region is dirty or no.
> >
> > Run a helper thread that does periodically:
> > Change MAYBE_DIRTY regions to CLEAN_CANDIDATE
> > Issue sync()
> > Change CLEAN_CANDIDATE regions to CLEAN state and clear their on-disk bit.
> >
> > The rationale is that if the above write-while-modify scenario happens, the
> > page is always dirty. Thus, sync() will write the page, kick the region back
> > from CLEAN_CANDIDATE to MAYBE_DIRTY state and we won't mark the region as
> > clean on disk.
> >
> >
> > I'd like to know you ideas on this, before we start coding a solution.
> >   
> 
> I looked at just this problem a while ago, and came to the conclusion that
> what was needed was a COW bit, to show that there was i/o in flight, and that
> before modification it needed to be copied. Since you don't want to let that
> recurse, you don't start writing the copy until the original is written and
> freed. Ideally you wouldn't bother to finish writing the original, but that
> doesn't seem possible. That allows at most two copies of a chunk to take up
> memory space at once, although it's still ugly and can be a bottleneck.

Copying the data would be performance overkill. You can really write 
different data to different disks, you just must not forget to resync them 
after a crash. The filesystem/application will recover with either old or 
new data --- it just won't recover when it's reading old and new data from 
the same location.

>From my point of view that trick with thread doing sync() and turning off 
region bits looks best. I'd like to know if that solution doesn't have any 
other flaw.

> For reliable operation I would want all copies (and/or CRCs) to be written on
> an fsync, by the time I bother to fsync I really, really, want the data on the
> disk.

fsync already works this way.

Mikulas
