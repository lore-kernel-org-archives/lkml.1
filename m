Return-Path: <linux-kernel-owner+w=401wt.eu-S1758430AbZEZUrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430AbZEZUrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 16:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756959AbZEZUrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 16:47:05 -0400
Received: from brick.kernel.dk ([93.163.65.50]:40503 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757528AbZEZUrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 16:47:03 -0400
Date: Tue, 26 May 2009 22:47:04 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Damien Wyart <damien.wyart@free.fr>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk
Subject: Re: [PATCH 0/12] Per-bdi writeback flusher threads v7
Message-ID: <20090526204703.GM11363@kernel.dk>
References: <1243330430-9964-1-git-send-email-jens.axboe@oracle.com> <20090526152501.GA20968@localhost.localdomain> <20090526164117.GJ11363@kernel.dk> <20090526170845.GA3226@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526170845.GA3226@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26 2009, Damien Wyart wrote:
> > > I have been playing with v7 since your sending and after a while
> > > (short on laptop, longer on desktop, a few hours), writeback doesn't
> > > seem to work anymore. Manual call to sync hangs (process in D state)
> > > and Dirty value in meminfo gets growing. As previous versions had
> > > been heavily tested, I guess there is some regression in v7.
> 
> > Not good, the prime suspect is the sync notification stuff. I'll take
> > a look and get that fixed. You didn't happen to catch any sysrq-t back
> > traces or anything like that? Would be interesting to see where
> > bdi-default and the bdi-* threads are stuck.
> 
> No, as I was doing many things at the same time and not exclusively
> debugging, I just rebooted hard and went back to an upatched kernel when
> the problems occured. But I noticed only bdi-default was alive, the
> other bdi-* threads had disappeared and the sync commands I had tried
> were all in D state. Also I tried to reinstall a kernel .deb (these
> systems are Debian) and this got stuck guring installation, when probing
> grub config (do not know if there is some sync syscall inthere).
> 
> Can try to go further tomorrow but will not have a lot of time...

OK, I spotted the problem. If we fallback to the on-stack allocation in
bdi_writeback_all(), then we do the wait for the work completion with
the bdi_lock mutex held. This can deadlock with bdi_forker_task(), so if
we require that to be invoked to make progress (happens if a thread
needs to be restarted), then we have a deadlock on that mutex.

I'll cook up a fix for this, but probably not before the morning.

-- 
Jens Axboe

