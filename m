Return-Path: <linux-kernel-owner+w=401wt.eu-S1754359AbZIGTJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbZIGTJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 15:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754218AbZIGTJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 15:09:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:40752 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141AbZIGTJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 15:09:16 -0400
Date: Mon, 7 Sep 2009 21:09:17 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       tytso@mit.edu, akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
Message-ID: <20090907190917.GC29103@duck.suse.cz>
References: <1252050406-22467-1-git-send-email-jens.axboe@oracle.com> <1252050406-22467-9-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252050406-22467-9-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 04-09-09 09:46:46, Jens Axboe wrote:
> From: Theodore Ts'o <tytso@mit.edu>
> 
> Originally, MAX_WRITEBACK_PAGES was hard-coded to 1024 because of a
> concern of not holding I_SYNC for too long.  (At least, that was the
> comment previously.)  This doesn't make sense now because the only
> time we wait for I_SYNC is if we are calling sync or fsync, and in
> that case we need to write out all of the data anyway.  Previously
> there may have been other code paths that waited on I_SYNC, but not
> any more.
  Well, I've always though that MAX_WRITEBACK_PAGES is there because
of a situation when a thread is forced to throttle on a BDI and
we'd like pdflush to yield to this thread so that it can do its duty
(otherwise it may be basically forced to wait until pdflush writes
enough for a system to drop below dirty_limit instead of writing
just sync_writeback_pages()).
  What also seemed suboptimal to me (on a simple SATA drive) is that
this writeout from a throttled thread is interleaved with a writeout
from pdflush when there are more dirty inodes. So what we might
want to do once we have more threads per-bdi and thus won't hit CPU
bottleneck on high-end storage is that we'd leave writeout completely
to per-BDI threads and just make throttled thread wait until enough
IO is done on the BDI....

> According to Christoph, the current writeback size is way too small,
> and XFS had a hack that bumped out nr_to_write to four times the value
> sent by the VM to be able to saturate medium-sized RAID arrays.  This
> value was also problematic for ext4 as well, as it caused large files
> to be come interleaved on disk by in 8 megabyte chunks (we bumped up
> the nr_to_write by a factor of two).
> 
> So, in this patch, we make the MAX_WRITEBACK_PAGES a tunable,
> max_writeback_mb, and set it to a default value of 128 megabytes.
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=13930
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
