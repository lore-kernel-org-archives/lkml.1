Return-Path: <linux-kernel-owner+w=401wt.eu-S1759371AbZCZQb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759371AbZCZQb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 12:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754977AbZCZQbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 12:31:19 -0400
Received: from THUNK.ORG ([69.25.196.29]:42142 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbZCZQbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 12:31:18 -0400
Date: Thu, 26 Mar 2009 12:30:26 -0400
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Frans Pop <elendil@planet.nl>,
       mingo@elte.hu, jack@suse.cz, alan@lxorguk.ukuu.org.uk,
       arjan@infradead.org, a.p.zijlstra@chello.nl, npiggin@suse.de,
       jens.axboe@oracle.com, drees76@gmail.com, jesper@krogh.cc,
       linux-kernel@vger.kernel.org, oleg@redhat.com, roland@redhat.com
Subject: Re: relatime: update once per day patches (was: ext3 IO latency
	measurements)
Message-ID: <20090326163026.GD6239@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Frans Pop <elendil@planet.nl>, mingo@elte.hu, jack@suse.cz,
	alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
	a.p.zijlstra@chello.nl, npiggin@suse.de, jens.axboe@oracle.com,
	drees76@gmail.com, jesper@krogh.cc, linux-kernel@vger.kernel.org,
	oleg@redhat.com, roland@redhat.com
References: <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu> <20090326140312.GB14822@elte.hu> <20090326073013.2fa83178.akpm@linux-foundation.org> <200903261632.42439.elendil@planet.nl> <20090326084733.156c4910.akpm@linux-foundation.org> <alpine.LFD.2.00.0903260912270.3032@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903260912270.3032@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 09:14:28AM -0700, Linus Torvalds wrote:
> I generally agree witht he "leave policy to user space" people, but this 
> is an area where (a) user space has shown itself to not get it right (ie 
> people don't do even the existing relatime because distros don't) and (b) 
> what's the alternative?

I thought at least some distro's were adding relatime by default; I
could be wrong, but I thought Ubuntu was doing this.  Personally, I
actually think that if we're going to give up on POSIX, I'll go all
the way to noatime since it helps even more.

I've always thought the right approach would be to have a "atime
dirty" flag, and update atime, but never flush it out to disk unless
(a) we're about to unmount the disk, or (b) we need to update some
other inode in the same inode table block, or (c) we have memory
pressure and we're trying to evict the inode from the inode cache.
That way we get full POSIX compliance, without taking the I/O hit of
atime updates.  The atime updates get lost if we crash, but that's
allowed by POSIX, and most people don't care about losing atime
updates after a crash.

Since it's fully backwards (and POSIX) compatible, there would no
question about enabling it by default.

						- Ted
