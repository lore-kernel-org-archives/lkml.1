Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab0BXO4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 09:56:37 -0500
Received: from cantor.suse.de ([195.135.220.2]:45849 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755649Ab0BXO4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 09:56:36 -0500
Date: Wed, 24 Feb 2010 15:56:43 +0100
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: tytso@mit.edu, Jan Kara <jack@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, jengelh@medozas.de,
       stable@kernel.org, gregkh@suse.de
Subject: Re: [PATCH] writeback: Fix broken sync writeback
Message-ID: <20100224145642.GJ3687@quack.suse.cz>
References: <alpine.LFD.2.00.1002161524210.4141@localhost.localdomain>
 <20100217013336.GK3153@quack.suse.cz>
 <alpine.LFD.2.00.1002161848370.4141@localhost.localdomain>
 <20100217043009.GZ5337@thunk.org>
 <alpine.LFD.2.00.1002162052230.4141@localhost.localdomain>
 <20100222172938.GA2601@quack.suse.cz>
 <20100222210112.GE23832@thunk.org>
 <20100223025350.GC22370@discord.disaster>
 <20100223032317.GG23832@thunk.org>
 <20100223055335.GE22370@discord.disaster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100223055335.GE22370@discord.disaster>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 23-02-10 16:53:35, Dave Chinner wrote:
> > > > This is done to avoid a lock inversion, and so this is an
> > > > ext4-specific thing (at least I don't think XFS's delayed allocation
> > > > has this misfeature).
> > > 
> > > Not that I know of, but then again I don't know what inversion ext4
> > > is trying to avoid. Can you describe the inversion, Ted?
> > 
> > The locking order is journal_start_handle (starting a micro
> > transaction in jbd) -> lock_page.  A more detailed description of why
> > this locking order is non-trivial for us to fix in ext4 can be found
> > in the description of commit f0e6c985.
> 
> Nasty - you need to start a transaction before you lock pages for
> writeback and allocation, but ->writepage hands you a locked page.
> And you can't use an existing transaction handle open because you
> can't guarantee that you have journal credits reserved for the
> allocation?
  Exactly.

> IIUC, ext3/4 has this problem due to the ordered data writeback
> constraints, right?
  Not quite. I don't know how XFS solves this but in ext3/4 starting
a transaction can block (waiting for journal space) until all users of
a previous transaction are done with it and we can commit it. Thus
the transaction start / stop behave just as an ordinary lock. Because
you need a transaction started when writing a page (for metadata updates)
there is some lock ordering forced between a page lock and a trasaction
start / stop. Ext4 chose it to be transaction -> page lock (which makes
writepages more efficient and writepage hard), ext3 has page lock ->
transaction (so it has working ->writepage).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
