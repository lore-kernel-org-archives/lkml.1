Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbYBDRy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbYBDRy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 12:54:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYBDRyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 12:54:18 -0500
Received: from styx.suse.cz ([82.119.242.94]:43681 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751835AbYBDRyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 12:54:16 -0500
Date: Mon, 4 Feb 2008 18:54:15 +0100
From: Jan Kara <jack@suse.cz>
To: Al Boldi <a1426z@gawab.com>
Cc: Chris Mason <chris.mason@oracle.com>, Andreas Dilger <adilger@sun.com>,
       Chris Snook <csnook@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] ext3: per-process soft-syncing data=ordered mode
Message-ID: <20080204175415.GH3426@duck.suse.cz>
References: <200801242336.00340.a1426z@gawab.com> <20080131171040.GL1461@duck.suse.cz> <200801311214.55287.chris.mason@oracle.com> <200802020026.00998.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802020026.00998.a1426z@gawab.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 02-02-08 00:26:00, Al Boldi wrote:
> Chris Mason wrote:
> > On Thursday 31 January 2008, Jan Kara wrote:
> > > On Thu 31-01-08 11:56:01, Chris Mason wrote:
> > > > On Thursday 31 January 2008, Al Boldi wrote:
> > > > > The big difference between ordered and writeback is that once the
> > > > > slowdown starts, ordered goes into ~100% iowait, whereas writeback
> > > > > continues 100% user.
> > > >
> > > > Does data=ordered write buffers in the order they were dirtied?  This
> > > > might explain the extreme problems in transactional workloads.
> > >
> > >   Well, it does but we submit them to block layer all at once so
> > > elevator should sort the requests for us...
> >
> > nr_requests is fairly small, so a long stream of random requests should
> > still end up being random IO.
> >
> > Al, could you please compare the write throughput from vmstat for the
> > data=ordered vs data=writeback runs?  I would guess the data=ordered one
> > has a lower overall write throughput.
> 
> That's what I would have guessed, but it's actually going up 4x fold for 
> mysql from 559mb to 2135mb, while the db-size ends up at 549mb.
  So you say we write 4-times as much data in ordered mode as in writeback
mode. Hmm, probably possible because we force all the dirty data to disk
when committing a transation in ordered mode (and don't do this in
writeback mode). So if the workload repeatedly dirties the whole DB, we are
going to write the whole DB several times in ordered mode but in writeback
mode we just keep the data in memory all the time. But this is what you
ask for if you mount in ordered mode so I wouldn't consider it a bug.
  I still don't like your hack with per-process journal mode setting but we
could easily do per-file journal mode setting (we already have a flag to do
data journaling for a file) and that would help at least your DB
workload...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
