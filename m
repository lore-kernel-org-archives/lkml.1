Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbZDGXrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbZDGXrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 19:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbZDGXrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 19:47:06 -0400
Received: from THUNK.ORG ([69.25.196.29]:34185 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025AbZDGXrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 19:47:05 -0400
Date: Tue, 7 Apr 2009 19:46:55 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, jack@suse.cz
Subject: Re: [PATCH] block_write_full_page: switch synchronous writes to
	use WRITE_SYNC_PLUG
Message-ID: <20090407234655.GC7031@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>, jens.axboe@oracle.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz
References: <20090406232141.ebdb426a.akpm@linux-foundation.org> <20090406235052.1ea47513.akpm@linux-foundation.org> <20090407070835.GM5178@kernel.dk> <20090407002313.fcdd1da0.akpm@linux-foundation.org> <20090407075732.GO5178@kernel.dk> <20090407190913.GA31723@mit.edu> <20090407193239.GE5178@kernel.dk> <20090407214421.GA7031@mit.edu> <20090407221933.GB7031@mit.edu> <20090407160944.de3c5139.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090407160944.de3c5139.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 04:09:44PM -0700, Andrew Morton wrote:
> > 
> > The upstream callers of block_write_full_page() which wait for the
> > writes to finish call wait_on_buffer(), wait_on_writeback_range()
> > (which ultimately calls sync_page(), which calls
> > blk_run_backing_dev(), which will unplug the device queue), and so on.
> 
> <sob>

No question, this stuff needs to be better documented; the codepaths
involved is scattered between files in block/, fs/, and mm/
directories, and it's not well documented as *all* what a filesystem
developer is supposed to do.

> >  	const unsigned blocksize = 1 << inode->i_blkbits;
> >  	int nr_underway = 0;
> > -	int write_op = (wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE);
> > +	int write_op = (wbc->sync_mode == WB_SYNC_ALL ?
> > +			WRITE_SYNC_PLUG : WRITE);
> >  
> >  	BUG_ON(!PageLocked(page));
> 
> So how does WRITE_SYNC_PLUG differ from WRITE, and what effect does
> this change have upon kernel behaviour?

The difference between WRITE_SYNC_PLUG and WRITE is that from the
perspective of the I/O scheduler, they are prioritized as
"synchronous" operations.  Some I/O schedulers, such as AS and CFQ,
prioritize synchronous writes and put them in the same bucket as
synchronous reads, and above asynchronous writes.

Currently, we are using WRITE_SYNC, which has the implicit unplug if
wbc->sync_mode is WB_SYNC_ALL.  WRITE_SYNC_PLUG removes the implicit
unplug, which was the issue that you had expressed concern.

	      	      	    	     	 - Ted
