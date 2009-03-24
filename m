Return-Path: <linux-kernel-owner+w=401wt.eu-S1759563AbZCXSqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563AbZCXSqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 14:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759244AbZCXSqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 14:46:23 -0400
Received: from THUNK.ORG ([69.25.196.29]:39229 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758686AbZCXSqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 14:46:20 -0400
Date: Tue, 24 Mar 2009 14:45:49 -0400
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090324184549.GE32307@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Arjan van de Ven <arjan@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <20090324091545.758d00f5@lxorguk.ukuu.org.uk> <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu> <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 10:55:40AM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 24 Mar 2009, Theodore Tso wrote:
> > 
> > Try ext4, I think you'll like it.  :-)
> > 
> > Failing that, data=writeback for single-user machines is probably your
> > best bet.
> 
> Isn't that the same fix? ext4 just defaults to the crappy "writeback" 
> behavior, which is insane.

Technically, it's not data=writeback.  It's more like XFS's delayed
allocation; I've added workarounds so that files that which are
replaced via truncate or rename get pushed out right away, which
should solve most of the problems involved with files becoming
zero-length after a system crash.

> Sure, it makes things _much_ smoother, since now the actual data is no 
> longer in the critical path for any journal writes, but anybody who thinks 
> that's a solution is just incompetent. 
> 
> We might as well go back to ext2 then. If your data gets written out long 
> after the metadata hit the disk, you are going to hit all kinds of bad 
> issues if the machine ever goes down.

With ext2 after a system crash you need to run fsck.  With ext4, fsck
isn't an issue, but if the application doesn't use fsync(), yes,
there's no guarantee (other than the workarounds for
replace-via-truncate and replace-via-rename), but there's plenty of
prior history that says that applications that care about data hitting
the disk should use fsync().  Otherwise, it will get spread out over a
few minutes; and for some files, that really won't make a difference.

For precious files, applications that use fsync() will be safe ---
otherwise, even with ext3, you can end up losing the contents of the
file if you crash right before 5 second commit window.  At least back
in the days when people were proud of their Linux systems having 2-3
year uptimes, and where jiffies could actually wrap from time to time,
the difference between 5 seconds and 3 minutes really wasn't that big
of a deal.  People who really care about this can turn off delayed
allocation with the nodelalloc mount option.  Of course then they will
have the ext3 slower fsync() problem.

You are right that data=writeback and delayed allocation do both mean
that data can get pushed out much later than the metadata.  But that's
allowed by POSIX, and it does give some very nice performance
benefits.

With either data=writeback or delayed allocation, we can also adjust
the default commit interval and the writeback timer settings; if we
say, change the default commit interval to be 30 seconds, and change
the writeback expire interval to be 15 seconds, it will also smooth
out the writes significantly.  So that's yet another solution, with a
different set of tradeoffs.  

Depending on the set of applications someone is running on their
system, running and the reliability of their hardware/power/system in
general, different tradeoffs will be more or less appropriate for the
system administrator in question.

							- Ted


