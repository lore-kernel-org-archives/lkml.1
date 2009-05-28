Return-Path: <linux-kernel-owner+w=401wt.eu-S1762924AbZE1J21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762924AbZE1J21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 05:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762779AbZE1J2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 05:28:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48826 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762192AbZE1J2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 05:28:03 -0400
Date: Thu, 28 May 2009 11:28:04 +0200
From: Jan Kara <jack@suse.cz>
To: Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr
Cc: Alex Chiang <achiang@hp.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v8
Message-ID: <20090528092803.GE29199@duck.suse.cz>
References: <1243417312-7444-1-git-send-email-jens.axboe@oracle.com> <20090527144754.GD10842@mit.edu> <20090527175353.GE10842@mit.edu> <20090527175830.GF10842@mit.edu> <20090527181402.GP11363@kernel.dk> <20090527191524.GS11363@kernel.dk> <20090527194543.GT11363@kernel.dk> <20090528004959.GH26625@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528004959.GH26625@mit.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 27-05-09 20:49:59, Theodore Tso wrote:
> On Wed, May 27, 2009 at 09:45:43PM +0200, Jens Axboe wrote:
> > 
> > This one has been tested good, where good means that it boots and
> > functions normally at least. Whether it fixes your issue, that would be
> > interesting to know :-)
> > 
> 
> Unfortunately, it doesn't seem to have.  Here's a dmesg with the
> softlockup report and the sysrq-t output.  Unfortunately the dmesg
> file is too big for LKML, so I've compressed it so you can get the
> whole thing.
  Everybody waits for sys_sync() to complete and they never seem to be
woken up. Jens, wb_work_complete() seems a bit fishy - who does
wb_clear_work() in sync_mode == WB_SYNC_ALL which is on stack?

> There's also a lockdep warning which fsx triggered.
  The lockdep warning is definitely unrelated. It's really a possible
deadlock, although not quite probable. IMHO the problem is that
sysfs_mutex gets above mmap_sem due to code in sysfs_readdir which calls
filldir() which may cause page fault. At the same time it gets quite low
on the lock stack because filesystems call sysfs functions from their
internal functions (in this case ext4_put_super) holding quite some locks.
Adding a few CC's for this.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
