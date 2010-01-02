Return-Path: <linux-kernel-owner+w=401wt.eu-S1752830Ab0ABQgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab0ABQgw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 11:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764Ab0ABQgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 11:36:51 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:44967 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab0ABQgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 11:36:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SgJ0qJ9p2iznP09/C+uWKFGEnJ+3BAVHB00IiNiLrPnlWilM2qQcQq7N9JDGmgsE3n
         pJq6yIBXXIZtILGHLFT3LSK/YNJeg4WbytKG8B5Db5RCldDSr2I0TFQoDqqfMY1U+MnY
         ewGQz+r8nf757TDEIoSNAk/K962hhaEHip6qk=
Date: Sat, 2 Jan 2010 17:36:46 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christian Kujau <lists@nerdbynature.de>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PULL] reiserfs fixes
Message-ID: <20100102163644.GA5076@nowhere>
References: <1262395636-8647-1-git-send-regression-fweisbec@gmail.com> <87bphc7heo.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bphc7heo.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 02, 2010 at 02:41:51PM +0100, Andi Kleen wrote:
> Frederic Weisbecker <fweisbec@gmail.com> writes:
> >
> > That's why you'll mostly find dependency inversion fixes based on
> > such pattern:
> >
> > reiserfs_write_unlock()
> > mutex_lock(random_lock)
> > reiserfs_write_lock()
> 
> These `workarounds' look rather ugly and are likely much slower
> than the BKL that was there before.


This is ugly, I can't argue against that. But while this is
apparently uglier than the bkl, it is actually better than it.

The bkl does its dirty workarounds internally. We don't see
it as it's done on schedule time and so. So indeed, placing
a simple lock_kernel() in each outer most caller in reiserfs
looks much proper and pretty than all these workarounds that
try to catch up with its locking-based scheme.

Now try to look at the new reiserfs lock not from a visual
point of view but from its impact. The bkl relax the lock, it is
acquired recursively etc... This usually implies a lot of hard
investigation. The new lock has identified all of
these dirty implicit places, knows when it is required to
relax, knows when it is acquired recursively, knows where
are the lock inversions once converted into a normal lock.

All of this hard work of investigation has been done already.
If someone wants to, one day, refine the locking to make
something smarter (which I doubt), starting from the current
codebase is _way_ much easier than starting from the 2.6.32
bkl based scheme. Actually someone who is going to try that
from the bkl point will undoubtly need an intermediate state
like the current one.

The ugliness is here. But finding it more ugly than the bkl
is a _pure_ illusion.

Concerning the slowness. The xattr operation that have been
patched here don't appear to me beeing in a fast path.
Moreover some lookup areas (apart from relax on random lock) have
been relaxed from the reiserfs lock in this new set.


> Perhaps it's better to simply
> go back to the BKL until this can be all fixed properly
> (or a more faithful emulation for the BKL can be devised)?


There are 99% of chances that nobody will ever fix it. Especially
if one needs to start from the bkl base.
Few people are familiar with the reiserfs code. Among these
people, I doubt someone is motivated to do it.

And for those who aren't familiar with it, reiserfs code is
so messy that I doubt many people will try something
for more than few minutes.

This is especially true now that it is an old and legacy
filesystem. Nobody cares anymore.

I only have reiserfs partitions in my laptop and my testbox,
nothing else. And that because I'm now maintaining it de facto.
Otherwise I wouldn't encumber with that and would immediately
set up btrfs everywhere.

Concerning a more faithful emulation of the bkl. That would
require to divide the bkl in several sub-bkl. This is
pointless and even worst than the bkl.

- that would require a notifier in schedule(), one notifier
  per sub-bkl. That's horrible for performances. And for
  the scheduler. I will be the first to NAK.

- that doesn't solve the problem as this sub-bkl won't ever
  be removed. We just isolate a giant lock in reiserfs. That
  doesn't change anything, nor make the things simpler
  especially since we already know that reiserfs use of the bkl
  is not related to other users of bkl.

- the reiserfs lock is per superblock. It scales better.


> >
> > This is not beautiful but at least that's better than the bkl.
> >
> > Oh and I expect other lock inversions will get reported in
> > the future due to rare and then yet untested paths.
> 
> ... and given that was the conversion really a good idea?


Despite the _apparent_ ugliness compared to the bkl, I'm
still sure this was, and is still, a good idea.

The fact we are going to experience other locking inversions
is a necessary pain. It's impossible to bypass these states,
you can't remove that easily such giant lock from a complex
code base.

Thanks.

