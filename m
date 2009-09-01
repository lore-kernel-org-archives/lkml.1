Return-Path: <linux-kernel-owner+w=401wt.eu-S1755120AbZIAU1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbZIAU1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 16:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbZIAU1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 16:27:53 -0400
Received: from THUNK.ORG ([69.25.196.29]:59103 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053AbZIAU1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 16:27:52 -0400
Date: Tue, 1 Sep 2009 16:27:47 -0400
From: Theodore Tso <tytso@mit.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, akpm@linux-foundation.org,
       jack@suse.cz
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_pages
Message-ID: <20090901202747.GC6996@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Christoph Hellwig <hch@infradead.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
	david@fromorbit.com, akpm@linux-foundation.org, jack@suse.cz
References: <1251803946-9243-1-git-send-email-jens.axboe@oracle.com> <1251803946-9243-9-git-send-email-jens.axboe@oracle.com> <1251830335.8502.17.camel@laptop> <20090901184455.GA27294@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090901184455.GA27294@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 02:44:55PM -0400, Christoph Hellwig wrote:
> On Tue, Sep 01, 2009 at 08:38:55PM +0200, Peter Zijlstra wrote:
> > Do we really need a tunable for this?
> 
> It will make increasing it in the field a lot easier.  And having deal
> with really large systems I have the fear that there are I/O topologies
> outhere for which every "reasonable" value is too low.
> 
> > I guess we need a limit to avoid it writing out everything, but can't we
> > have something automagic?
> 
> Some automatic adjustment would be nice.  But finding the right auto
> tuning will be an interesting exercise.

The fact that limit is on a per-inode basis is part of the problem.
Right now, we are only writing out X pages per inode, so depending on
whether we have one really gargantuan inode that needs writout, or ten
big inodes which are dirty, or million small inodes, the fact that we
are imposing a limit based the number of pages in a single inode that
we will write out seems like the wrong design choice.

So perhaps the best argument for not making this be a tunable is that
in the long run, we will need to put in a better algorithm for
controlling how much writeback we want to do before we start
saturating RAID arrays, and in that new algorithm this tunable may no
longer make sense.  Fine; at that point, we can make it go away.  For
now, though, it seems to be the best way to tweak what is going on,
since I doubt we'll be able to come up with one magic number that will
satisfy everyone.

						- Ted
