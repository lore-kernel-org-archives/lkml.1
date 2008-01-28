Return-Path: <linux-kernel-owner+w=401wt.eu-S1761596AbYA1Tal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761596AbYA1Tal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754796AbYA1TaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:30:22 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2670 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754045AbYA1TaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:30:20 -0500
Date: Mon, 28 Jan 2008 19:30:05 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Theodore Tso <tytso@mit.edu>, Valdis.Kletnieks@vt.edu,
       David Chinner <dgc@sgi.com>, Valerie Henson <val@vahconsulting.com>,
       linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>,
       Ric Wheeler <ric@emc.com>
Subject: Re: [RFC] Parallelize IO for e2fsck
Message-ID: <20080128193005.GC4032@ucw.cz>
References: <70b6f0bf0801161322k2740a8dch6a0d6e6e112cd2d0@mail.gmail.com> <70b6f0bf0801161330y46ec555m5d4994a1eea7d045@mail.gmail.com> <20080121230041.GL3180@webber.adilger.int> <20080122033830.GR155259@sgi.com> <3673.1200975438@turing-police.cc.vt.edu> <20080122070050.GM3180@webber.adilger.int> <20080122144052.GC17804@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080122144052.GC17804@mit.edu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> It's been discussed before, but I suspect the main reason why it was
> never done is no one submitted a patch.  Also, the problem is actually
> a pretty complex one.  There are a couple of different stages where
> you might want to send an alert to processes:
> 
>     * Data is starting to get ejected from page/buffer cache
>     * System is starting to swap
>     * System is starting to really struggle to find memory
>     * System is starting an out-of-memory killer
> 
> AIX's SIGDANGER really did the last two, where the OOM killer would
> tend to avoid processes that had a SIGDANGER handler in favor of
> processes that were SIGDANGER unaware.
> 
> Then there is the additional complexity in Linux that you have
> multiple zones of memory, which at least on the historically more
> popular x86 was highly, highly important.  You could say that whenever
> there is sufficient memory pressure in any zone that you start
> ejecting data from caches or start to swap that you start sending the
> signals --- but on x86 systems with lowmem, that could happen quite
> frequently, and since a user process has no idea whether its resources
> are in lowmem or highmem, there's not much you can do about this.

As user pages are always in highmem, this should be easy to decide:
only send SIGDANGER when highmem is full. (Yes, there are
inodes/dentries/file descriptors in lowmem, but I doubt apps will
respond to SIGDANGER by closing files).
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
