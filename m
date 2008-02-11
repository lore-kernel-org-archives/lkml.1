Return-Path: <linux-kernel-owner+w=401wt.eu-S1751383AbYBKFXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383AbYBKFXD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 00:23:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbYBKFWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 00:22:50 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51533 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751829AbYBKFWt (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 00:22:49 -0500
Date: Mon, 11 Feb 2008 16:22:11 +1100
From: David Chinner <dgc@sgi.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       Alan.Brunelle@hp.com, arjan@linux.intel.com, dgc@sgi.com
Subject: Re: IO queuing and complete affinity with threads (was Re: [PATCH 0/8] IO queuing and complete affinity)
Message-ID: <20080211052211.GS155407@sgi.com>
References: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com> <20080207182544.GM15220@kernel.dk> <20080208073859.GE9730@wotan.suse.de> <20080208074747.GY15220@kernel.dk> <20080208075324.GG9730@wotan.suse.de> <20080208075954.GA15220@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208075954.GA15220@kernel.dk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 08:59:55AM +0100, Jens Axboe wrote:
> > > > At least they reported it to be the most efficient scheme in their
> > > > testing, and Dave thought that migrating completions out to submitters
> > > > might be a bottleneck in some cases.
> > > 
> > > More so than migrating submitters to completers? The advantage of only
> > > movign submitters is that you get rid of the completion locking. Apart
> > > from that, the cost should be the same, especially for the thread based
> > > solution.
> > 
> > Not specifically for the block layer, but higher layers like xfs.
> 
> True, but that's parallel to the initial statement - that migrating
> completers is most costly than migrating submitters. So I'd like Dave to
> expand on why he thinks that migrating completers it more costly than
> submitters, APART from the locking associated with adding the request to
> a remote CPU list.

What I think Nick is referring to is the comments I made that at a
higher layer (e.g. filesystems) migrating completions to the
submitter CPU may be exactly the wrong thing to do. I don't recall
making any comments on migrating submitters - I think others have
already commented on that so I'll ignore that for the moment and
try to explain why completion on submitter CPU /may/ be bad.

For example, in the case of XFS it is fine for data I/O but it is
wrong for transaction I/O completion. We want to direct all
transaction completions to as few CPUs as possible (one, ideally) so
that all the completion processing happens on the same CPU, rather
than bouncing global cachelines and locks between all the CPUs
taking completion interrupts.

In more detail, the XFS transaction subsystem is asynchronous.
We submit the transaction I/O on the CPU that creates the
transaction so the I/O can come from any CPU in the system.  If we
then farm the completion processing out to the submission CPU, that
will push it all over the machine and guarantee that we bounce all
of the XFS transaction log structures and locks all over the machine
on completion as well as submission (right now it's lots of
submission CPUs, few completion CPUs).

An example how bad this can get - this patch:

http://oss.sgi.com/archives/xfs/2007-11/msg00217.html

which prevents simultaneous access to the items tracked in the log
during transaction reservation. Having several hundred CPUs trying
to hit this list at once is really bad for performance - the test
app on the 2048p machine that saw this problem went from ~5500s
runtime down to 9s with the above patch.

I use this example because the transaction I/O completion touches
exactly the same list, locks and structures but is limited in
distribution (and therefore contention) by the number of
simultaneous I/O completion CPUs. Doing completion on the submitter
CPU will cause much wider distribution of completion processing and
introduce exactly the same issues as the transaction reservation
side had.

As it goes, with large, multi-device volumes (e.g. big stripe) we
already see issues with simultaneous completion processing (e.g. the
8p machine mentioned in the above link), so I'd really like to avoid
making these problems worse....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
