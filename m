Return-Path: <linux-kernel-owner+w=401wt.eu-S1752998AbZDYFCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbZDYFCq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 01:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbZDYFCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 01:02:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:47619 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbZDYFCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 01:02:34 -0400
Date: Sat, 25 Apr 2009 07:02:32 +0200
From: Nick Piggin <npiggin@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/27] [rfc] vfs scalability patchset
Message-ID: <20090425050232.GA10088@wotan.suse.de>
References: <20090425012020.457460929@suse.de> <20090425041829.GX8633@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090425041829.GX8633@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for taking a look. I'll spend a bit of time to go over your
feedback.


On Sat, Apr 25, 2009 at 05:18:29AM +0100, Al Viro wrote:
> On Sat, Apr 25, 2009 at 11:20:20AM +1000, npiggin@suse.de wrote:
> > Here is my current patchset for improving vfs locking scalability. Since
> > last posting, I have fixed several bugs, solved several more problems, and
> > done an initial sweep of filesystems (autofs4 is probably the trickiest,
> > and unfortunately I don't have a good test setup here for that yet, but
> > at least I've looked through it).
> > 
> > Also started to tackle files_lock, vfsmount_lock, and inode_lock.
> > (I included my mnt_want_write patches before the vfsmount_lock scalability
> > stuff because that just made it a bit easier...). These appear to be the
> > problematic global locks in the vfs.
> > 
> > It's running stably here so far on basic stress testing here on several file
> > systems (xfs, tmpfs, ext?). But it still might eat your data of course.
> > 
> > Would be very interested in any feedback.
> 
> First of all, I happily admit that wrt locking I'm a barbarian, and proud
> of it.  I.e. simpler locking scheme beats theoretical improvement, unless
> we have really good evidence that there's a real-world problem.  All things
> equal, complexity loses.  All things not quite equal - ditto.  Amount of
> fuckups is at least quadratic by the number of lock types, with quite a big
> chunk on top added by each per-something kind of lock.

Yes definitely. What recently prompted me to finally look at this is
the nasty looking "batched dput/iput" stuff that came out of google.
Unfortunately I don't remember seeing a description of the workload
but I'll ping them.

I do know that SGI has had problems with these locks on NFS server
workloads too (and not on insanely sized systems). I should be able
to get a recipe for reproducing this.

And this is an open call for anyone else seeing scalability problems
here too.

 
> Said that, I like mnt_want_write part, vfsmount_lock splitup (modulo
> several questions) and _maybe_ doing something about files_lock.
> Like as in "would seriously consider merging next cycle".

OK that's a good start. I do admit I didn't take enough time to grok
the tty stuff :P But I'll try to get it in shape.

>  I'd keep
> dcache and icache parts separate for now.

Yes they need a lot more review and results.
 

> However, files_lock part 2 looks very dubious - if nothing else, I would
> expect that you'll get *more* cross-CPU traffic that way, since the CPU
> where final fput() runs will correlate only weakly (if at all) with one
> where open() had been done.  So you are getting more cachelines bouncing.

You think? Weakly? Well I guess it will depend on the workload. In some
cases it will be. Although the alternative is all CPUs bouncing a single
lock cacheline, so with multiple lock cachelines then at least we have
less contention at the cache coherency level (ie. we can have multiple
cacheline bounces in flight across the entire machine). But... enough
handwaving from me, I agree it needs results.


> I want to see the numbers for this one, and on different kinds of loads,
> but as it is I've very sceptical.  BTW, could you try to collect stats
> along the lines of "CPU #i has done N_{i,j} removals from sb list for
> files that had been in list #j"?
> 
> Splitting files_lock on per-sb basis might be an interesting variant, too.

Yes that could help, although I had been trying to keep in mind
single-sb scalability too.

 
> Another thing: could you pull outright bugfixes as early as possible in the
> queue?

Sure thing.

Thanks,
Nick
