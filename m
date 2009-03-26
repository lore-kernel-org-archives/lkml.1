Return-Path: <linux-kernel-owner+w=401wt.eu-S1758128AbZCZPai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128AbZCZPai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 11:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750931AbZCZPa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 11:30:29 -0400
Received: from THUNK.ORG ([69.25.196.29]:51573 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127AbZCZPa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 11:30:28 -0400
Date: Thu, 26 Mar 2009 11:28:15 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
Message-ID: <20090326152815.GB6239@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Arjan van de Ven <arjan@infradead.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
References: <20090325150041.GM32307@mit.edu> <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <20090325185824.GO32307@mit.edu> <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain> <20090325215137.GQ32307@mit.edu> <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326140312.GB14822@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 03:03:12PM +0100, Ingo Molnar wrote:
> 
> I still see similarly bad latencies in Vim:
> 

When you say "similarly bad", how many seconds were you seeing?  I
understand that from the user's perspective, the 120 seconds you saw
with ext3 isn't going to be that different from 15 seconds (which
seems to be the maximum commit time in the jbd2 history file you sent
me), but I'm curious if what you saw was just as bad with ext4, or was
it somewhat better (i.e., 120 seconds vs 15 or so).  Or were you also
seeing a net time to save the file using vim of around 120 seconds
with ext4?

Ext4 in nodelalloc mode is mostly similar to ext3, but it does have
some improvements, such as a slightly elevated I/O priority for
kjournald, and the ext4's writepage doesn't take the journal handle as
it does in ext3.  (That's why I was confused about Linus's assertion
about ext3 waiting on the journal; ext4 doesn't any more, and I had
ext4 on the brain.)  Unfortunately, we don't have the
/proc/fs/jbd/<dev>/history for ext3, so it would be interesting to
compare whether the vim save latencies were improved or not with ext4.
If they are, then it might be worth Jan's time to fix up ext3's
writepage to not try request journal access if it's not needed.  It
might also be worth backporting ext4's slightly raised I/O priority
patch.

Another thing that's worth trying.  Suppose you use ionice to raise
the priority of kjournald to a real-time I/O priority (which is what
Arjan's patch does).  How much does that help?  Is it more or less
compared to what we're seeing with ext4's slightly reaised I/O
priority.

And if we mount the filesystem noatime, does that change the results
significantly as far as Vim write latencies and the jbd2 history file?

> The read-test is somewhat better. There are occasional blips of 4-5 
> seconds:

Presumably these go away once we mount the filesystem noatime, right?

	   	   	    	      	       - Ted
