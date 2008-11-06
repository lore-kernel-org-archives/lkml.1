Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbYKFEXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbYKFEXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 23:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbYKFEXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 23:23:34 -0500
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:20218 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752943AbYKFEXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 23:23:33 -0500
Date: Thu, 6 Nov 2008 15:20:54 +1100
From: Dave Chinner <david@fromorbit.com>
To: Chad Talbott <ctalbott@google.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@google.com>,
       Michael Rubin <mrubin@google.com>
Subject: Re: Metadata in sys_sync_file_range and fadvise(DONTNEED)
Message-ID: <20081106042054.GB2373@disturbed>
Mail-Followup-To: Chad Talbott <ctalbott@google.com>,
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@google.com>,
	Michael Rubin <mrubin@google.com>
References: <1786ab030810311354h1a7c8fb0q1267969d432f521c@mail.gmail.com> <20081102224513.GH19509@disturbed> <1786ab030811051719w63ada9c8ldf75f15367adbb8b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1786ab030811051719w63ada9c8ldf75f15367adbb8b@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2008 at 05:19:20PM -0800, Chad Talbott wrote:
> On Sun, Nov 2, 2008 at 2:45 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Fri, Oct 31, 2008 at 01:54:14PM -0700, Chad Talbott wrote:
> >> Andrew suggests a new SYNC_FILE_RANGE_METADATA flag for
> >> sys_sync_file_range(), and leaving posix_fadvise() alone.
> >
> > What is the interface that a filesystem will see? No filesystem has
> > a "metadata sync" method - is this going to fall through to some new
> > convoluted combination of writeback flags to an inode/mapping
> > that more filesystems than not can get wrong?
> 
> Good point, coupled with metadata/data ordering and your argument
> below, a decent argument against exposing this interface.
> 
> > FWIW, sys_sync_file_range() is fundamentally broken for data
> > integrity writeback - at no time does it call a filesystem method
> > that can result in a barrier I/O being issued to disk after
> > writeback is complete. So, unlike fsync() or fdatasync(), the data
> > can still be lost after completion due to power failure on drives
> > with volatile write caches....
> 
> Seems to be true.  I'm not currently concerned with sync_file_range
> for data integrity, so I'm going to punt on this issue.

;)

> If the consensus is against exposing a "sync metadata" interface, I'm
> fine with ext2 silently updating metadata alongside neighboring data
> in *either* posix_fadvise() or sync_file_range.

I think that sync_file_range is the better choice for "correct"
behaviour. There is the assumption with syncing data explicitly
that the metadata needs to reference that data is written to disk
as well.

> Either way, does it
> seem reasonable for posix_fadvise(DONTNEED) to call
> __filemap_fdatawrite_range to do its work?

>From a kernel perspective, I don't think it really matters.  To an
application, it could. e.g. If you're calling posix_fadvise on a
large range, then the I/O patterns will be the same either way. If
you're calling posix_fadvise() on small, sparse ranges of the file,
then you'll turn one large, fast writeout into lots of small random
writes. i.e. upgrade the kernel and the application goes much
slower....

I guess this all depends on whether this would be considered a
regression or a stupid application ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
