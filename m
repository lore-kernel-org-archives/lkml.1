Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbYAVOlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbYAVOlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 09:41:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbYAVOlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 09:41:06 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:64851 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751134AbYAVOlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:41:04 -0500
Date: Tue, 22 Jan 2008 09:40:52 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Valdis.Kletnieks@vt.edu, David Chinner <dgc@sgi.com>,
       Valerie Henson <val@vahconsulting.com>, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andreas Dilger <adilger@clusterfs.com>, Ric Wheeler <ric@emc.com>
Subject: Re: [RFC] Parallelize IO for e2fsck
Message-ID: <20080122144052.GC17804@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Valdis.Kletnieks@vt.edu,
	David Chinner <dgc@sgi.com>, Valerie Henson <val@vahconsulting.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger@clusterfs.com>, Ric Wheeler <ric@emc.com>
References: <70b6f0bf0801161322k2740a8dch6a0d6e6e112cd2d0@mail.gmail.com> <70b6f0bf0801161330y46ec555m5d4994a1eea7d045@mail.gmail.com> <20080121230041.GL3180@webber.adilger.int> <20080122033830.GR155259@sgi.com> <3673.1200975438@turing-police.cc.vt.edu> <20080122070050.GM3180@webber.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080122070050.GM3180@webber.adilger.int>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 12:00:50AM -0700, Andreas Dilger wrote:
> > AIX had SIGDANGER some 15 years ago.  Admittedly, that was sent when
> > the system was about to hit OOM, not when it was about to start swapping.
> 
> I'd tried to advocate SIGDANGER some years ago as well, but none of
> the kernel maintainers were interested.  It definitely makes sense
> to have some sort of mechanism like this.  At the time I first brought
> it up it was in conjunction with Netscape using too much cache on some
> system, but it would be just as useful for all kinds of other memory-
> hungry applications.

It's been discussed before, but I suspect the main reason why it was
never done is no one submitted a patch.  Also, the problem is actually
a pretty complex one.  There are a couple of different stages where
you might want to send an alert to processes:

    * Data is starting to get ejected from page/buffer cache
    * System is starting to swap
    * System is starting to really struggle to find memory
    * System is starting an out-of-memory killer

AIX's SIGDANGER really did the last two, where the OOM killer would
tend to avoid processes that had a SIGDANGER handler in favor of
processes that were SIGDANGER unaware.

Then there is the additional complexity in Linux that you have
multiple zones of memory, which at least on the historically more
popular x86 was highly, highly important.  You could say that whenever
there is sufficient memory pressure in any zone that you start
ejecting data from caches or start to swap that you start sending the
signals --- but on x86 systems with lowmem, that could happen quite
frequently, and since a user process has no idea whether its resources
are in lowmem or highmem, there's not much you can do about this.

Hopefully this is less of an issue today, since the 2.6 VM is much
more better behaved, and people are gradually moving over to x86_64
anyway.  (Sorry SGI and Intel, unfortunately they're not moving over
to the Itanic :-).   So maybe this would be better received now.

Bringing us back to the main topic at hand, one of the tradeoffs in
Val's current approach is that by relying on the kernel's buffer
cache, we don't have to worry about locking and coherency at the
userspace level.  OTOH, we give up low-level control about when memory
gets thrown out, and it also means that simply getting notified when
the system starts to swap isn't good enough.  We need to know much
earlier, when the system starts ejecting data from the buffer and page
caches.

Does this matter?  Well, there are a couple of use cases:

     * The restricted boot environment
     * The background "once a month" take a snapshot and check
     * The oh-my-gosh we-lost-a-filesystem -- repair it while the 
       IMAP server is still on-line serving data from the other 
       mounted filesystems.

It's the last case where things get really tricky....

     	      	   	 	    - Ted
