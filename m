Return-Path: <linux-kernel-owner+w=401wt.eu-S932228AbZIBHdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228AbZIBHdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 03:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932214AbZIBHdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 03:33:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:36881 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932213AbZIBHdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 03:33:35 -0400
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_pages
From: Peter Zijlstra <peterz@infradead.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, akpm@linux-foundation.org,
       jack@suse.cz
In-Reply-To: <20090901202747.GC6996@mit.edu>
References: <1251803946-9243-1-git-send-email-jens.axboe@oracle.com>
	 <1251803946-9243-9-git-send-email-jens.axboe@oracle.com>
	 <1251830335.8502.17.camel@laptop> <20090901184455.GA27294@infradead.org>
	 <20090901202747.GC6996@mit.edu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 02 Sep 2009 09:32:56 +0200
Message-Id: <1251876776.7547.52.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-01 at 16:27 -0400, Theodore Tso wrote:
> On Tue, Sep 01, 2009 at 02:44:55PM -0400, Christoph Hellwig wrote:
> > On Tue, Sep 01, 2009 at 08:38:55PM +0200, Peter Zijlstra wrote:
> > > Do we really need a tunable for this?
> > 
> > It will make increasing it in the field a lot easier.  And having deal
> > with really large systems I have the fear that there are I/O topologies
> > outhere for which every "reasonable" value is too low.
> > 
> > > I guess we need a limit to avoid it writing out everything, but can't we
> > > have something automagic?
> > 
> > Some automatic adjustment would be nice.  But finding the right auto
> > tuning will be an interesting exercise.
> 
> The fact that limit is on a per-inode basis is part of the problem.

I would think that it would be a BDI based property, since it basically
depends on the speed of the backing dev you're writing to.

> Right now, we are only writing out X pages per inode, so depending on
> whether we have one really gargantuan inode that needs writout, or ten
> big inodes which are dirty, or million small inodes, the fact that we
> are imposing a limit based the number of pages in a single inode that
> we will write out seems like the wrong design choice.

Agreed, number of chunks, where a chunk is some optimum write size for
the device in question, and number of seeks, seem a more suitable
criteria.

Basically limiting the time spend on writeout and not much else.

> So perhaps the best argument for not making this be a tunable is that
> in the long run, we will need to put in a better algorithm for
> controlling how much writeback we want to do before we start
> saturating RAID arrays, and in that new algorithm this tunable may no
> longer make sense.  Fine; at that point, we can make it go away.  For
> now, though, it seems to be the best way to tweak what is going on,
> since I doubt we'll be able to come up with one magic number that will
> satisfy everyone.

Thing is, will this single tunable be sufficient for people who have
both a RAID array and an USB stick on the same machine?
