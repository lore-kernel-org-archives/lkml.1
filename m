Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbXIUK0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbXIUK0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 06:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755086AbXIUKZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 06:25:56 -0400
Received: from anchor-post-34.mail.demon.net ([194.217.242.92]:4003 "EHLO
	anchor-post-34.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755050AbXIUKZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 06:25:56 -0400
Subject: Re: Processes spinning forever, apparently in lock_timer_base()?
From: richard kennedy <richard@rsk.demon.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, Matthias Hensler <matthias@wspse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20070920153654.b9e90616.akpm@linux-foundation.org>
References: <46B10BB7.60900@redhat.com>
	 <20070803113407.0b04d44e.akpm@linux-foundation.org>
	 <20070804084426.GA20464@kobayashi-maru.wspse.de>
	 <20070809095943.GA7763@kobayashi-maru.wspse.de>
	 <20070809095534.25ae1c42.akpm@linux-foundation.org>
	 <46F2E103.8000907@redhat.com>
	 <20070920142927.d87ab5af.akpm@linux-foundation.org>
	 <46F2EE76.4000203@redhat.com>
	 <20070920153654.b9e90616.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 21 Sep 2007 11:25:41 +0100
Message-Id: <1190370341.3121.35.camel@castor.rsk.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-20 at 15:36 -0700, Andrew Morton wrote:
> On Thu, 20 Sep 2007 18:04:38 -0400
> Chuck Ebbert <cebbert@redhat.com> wrote:
> 
> > > 
> > >> Can we get some kind of band-aid, like making the endless 'for' loop in
> > >> balance_dirty_pages() terminate after some number of iterations? Clearly
> > >> if we haven't written "write_chunk" pages after a few tries, *and* we
> > >> haven't encountered congestion, there's no point in trying forever...
> > > 
> > > Did my above questions get looked at?
> > > 
> > > Is anyone able to reproduce this?
> > > 
> > > Do we have a clue what's happening?
> > 
> > There are a ton of dirty pages for one disk, and zero or close to zero dirty
> > for a different one. Kernel spins forever trying to write some arbitrary
> > minimum amount of data ("write_chunk" pages) to the second disk...
> 
> That should be OK.  The caller will sit in that loop, sleeping in
> congestion_wait(), polling the correct backing-dev occasionally and waiting
> until the dirty limits subside to an acceptable limit, at which stage this:
> 
> 			if (nr_reclaimable +
> 				global_page_state(NR_WRITEBACK)
> 					<= dirty_thresh)
> 						break;
> 
> 
> will happen and we leave balance_dirty_pages().
> 
> That's all a bit crappy if the wrong races happen and some other task is
> somehow exceeding the dirty limits each time this task polls them.  Seems
> unlikely that such a condition would persist forever.
> 
> So the question is, why do we have large amounts of dirty pages for one
> disk which appear to be sitting there not getting written?

The lockup I'm seeing intermittently occurs when I have 2+ tasks copying
large files (1Gb+) on sda & a small read-mainly mysql db app running on
sdb. The lockup seems to happen just after the copies finish -- there
are lots of dirty pages but nothing left to write them until kupdate
gets round to it. 
BTW kupdate can loop for long periods of time when a disk is under this
kind of load -- I regularly see it take over 20 seconds. and often it's
unable to start as there are no pdflush threads available.

> Do we know if there's any writeout at all happening when the system is in
> this state?
> 
No there doesn't seem to be any activity at all -- my machine is
completely unresponsive only sysrq works.


> I guess it's possible that the dirty inodes on the "other" disk got
> themselves onto the wrong per-sb inode list, or are on the correct list,
> but in the correct place.  If so, these:
> 
> writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
> writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
> writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
> writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
> writeback-fix-comment-use-helper-function.patch
> writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
> writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
> writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
> writeback-fix-periodic-superblock-dirty-inode-flushing.patch
> 
> from 2.6.23-rc6-mm1 should help.
 

> Did anyone try running /bin/sync when the system is in this state?
I'm not able to run anything in this state, but sysrq-s doesn't make any
difference.

Richard 

