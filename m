Return-Path: <linux-kernel-owner+w=401wt.eu-S932137AbZIRWRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbZIRWRG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 18:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932079AbZIRWRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 18:17:00 -0400
Received: from THUNK.ORG ([69.25.196.29]:56425 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932112AbZIRWQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 18:16:59 -0400
Date: Fri, 18 Sep 2009 18:16:58 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jim Meyering <jim@meyering.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: efficient access to "rotational";  new fcntl?
Message-ID: <20090918221658.GB28781@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jim Meyering <jim@meyering.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <87vdjgqcbd.fsf@meyering.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vdjgqcbd.fsf@meyering.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 09:31:50PM +0200, Jim Meyering wrote:
>     chgrp, chmod, chown, chcon, du, rm: now all display linear performance,
>     even when operating on million-entry directories on ext3 and ext4 file
>     systems.  Before, they would exhibit O(N^2) performance, due to linear
>     per-entry seek time cost when operating on entries in readdir order.
>     Rm was improved directly, while the others inherit the improvement
>     from the newer version of fts in gnulib.

Excellent!  I didn't know that (since my userspace is still Ubuntu
9.04, which is still using coreutils 6.10).

> However, with e.g., an ext4 partition on non-rotational hardware like
> an SSD, that preprocessing is unnecessary and in fact wasted effort.
> I'd like to avoid the waste by querying the equivalent of
> /sys/.../rotational, via a syscall like fcntl or statvfs,
> given a file descriptor.

Have you benchmarked it both ways?  The preprocessing will cost some
extra CPU time, sure, but for a sufficiently large directory, or if
the user is deleting a very large directory hierarchy, such that "rm
-rf" spans multiple journal transactions, deleting the files in inode
order will still avoid some filesystem metadata blocks getting written
multiple times (which for SSD's, especially the crappier ones with
nasty write amplification factors) could show a performance impact.

> Is there an efficient way to get that single bit?

Not today; if it's really useful, we could add it, of course.  But how
much overhead are you trying to avoid by avoiding the pre-processing
before unlinking the files?

Regards,

						- Ted
