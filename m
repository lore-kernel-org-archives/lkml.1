Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab0BOP6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 10:58:25 -0500
Received: from cantor.suse.de ([195.135.220.2]:36296 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755990Ab0BOP6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 10:58:24 -0500
Date: Mon, 15 Feb 2010 16:58:33 +0100
From: Jan Kara <jack@suse.cz>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
       gregkh@suse.de
Subject: Re: [PATCH] writeback: Fix broken sync writeback
Message-ID: <20100215155833.GH3434@quack.suse.cz>
References: <20100212091609.GB1025@kernel.dk>
 <alpine.LFD.2.00.1002120722270.7792@localhost.localdomain>
 <alpine.LSU.2.01.1002131356250.20838@obet.zrqbmnf.qr>
 <20100215144938.GD3434@quack.suse.cz>
 <alpine.LSU.2.01.1002151629380.27775@obet.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.01.1002151629380.27775@obet.zrqbmnf.qr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 15-02-10 16:41:17, Jan Engelhardt wrote:
> 
> On Monday 2010-02-15 15:49, Jan Kara wrote:
> >On Sat 13-02-10 13:58:19, Jan Engelhardt wrote:
> >> >> 
> >> >> This fixes it by using the passed in page writeback count, instead of
> >> >> doing MAX_WRITEBACK_PAGES batches, which gets us much better performance
> >> >> (Jan reports it's up from ~400KB/sec to 10MB/sec) and makes sync(1)
> >> >> finish properly even when new pages are being dirted.
>
> >> It seems so. Jens, Jan Kara, your patch does not entirely fix this.
> >> While there is no sync/fsync to be seen in these traces, I can
> >> tell there's a livelock, without Dirty decreasing at all.
> >
> >  I don't think this is directly connected with my / Jens' patch.
> 
> I start to think so too.
> 
> >Similar traces happen even without the patch (see e.g.
> >http://bugzilla.kernel.org/show_bug.cgi?id=14830). But maybe the patch
> >makes it worse... So are you able to reproduce these warnings and
> >without the patch they did not happen?
> 
> Your patch speeds up the slow sync; without the patch, there was
> no real chance to observ the hard lockup, as the slow sync would
> take up all time.
> 
> So far, no reproduction. It seems to be just as you say.
> 
> >  Where in the code is jbd2_journal_commit_transaction+0x218/0x15e0?
> 
> 0000000000569554 <jbd2_journal_commit_transaction>:
>   56976c:       40 04 ee 62     call  6a50f4 <schedule>
> 
> Since there is an obvious schedule() call in jbd2_journal_commit_transaction's
> C code, I think that's where it is.
  OK. Thanks. It seems some process is spending excessive time with a
transaction open (jbd2_journal_commit_transaction waits for all handles of
a transaction to be dropped). If you see the traces again, try to obtain
stack traces of all the other processes and maybe we can catch the process
and see whether it's doing something unexpected.
  The patch can have an influence on this because we now pass larger
nr_to_write to ext4_writepages so maybe that makes some corner case more
likely.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
