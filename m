Return-Path: <linux-kernel-owner+w=401wt.eu-S1753819AbXITWiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbXITWiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 18:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750797AbXITWh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 18:37:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48755 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750958AbXITWhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 18:37:55 -0400
Date: Thu, 20 Sep 2007 15:36:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Matthias Hensler <matthias@wspse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       richard kennedy <richard@rsk.demon.co.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Processes spinning forever, apparently in lock_timer_base()?
Message-Id: <20070920153654.b9e90616.akpm@linux-foundation.org>
In-Reply-To: <46F2EE76.4000203@redhat.com>
References: <46B10BB7.60900@redhat.com>
	<20070803113407.0b04d44e.akpm@linux-foundation.org>
	<20070804084426.GA20464@kobayashi-maru.wspse.de>
	<20070809095943.GA7763@kobayashi-maru.wspse.de>
	<20070809095534.25ae1c42.akpm@linux-foundation.org>
	<46F2E103.8000907@redhat.com>
	<20070920142927.d87ab5af.akpm@linux-foundation.org>
	<46F2EE76.4000203@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007 18:04:38 -0400
Chuck Ebbert <cebbert@redhat.com> wrote:

> > 
> >> Can we get some kind of band-aid, like making the endless 'for' loop in
> >> balance_dirty_pages() terminate after some number of iterations? Clearly
> >> if we haven't written "write_chunk" pages after a few tries, *and* we
> >> haven't encountered congestion, there's no point in trying forever...
> > 
> > Did my above questions get looked at?
> > 
> > Is anyone able to reproduce this?
> > 
> > Do we have a clue what's happening?
> 
> There are a ton of dirty pages for one disk, and zero or close to zero dirty
> for a different one. Kernel spins forever trying to write some arbitrary
> minimum amount of data ("write_chunk" pages) to the second disk...

That should be OK.  The caller will sit in that loop, sleeping in
congestion_wait(), polling the correct backing-dev occasionally and waiting
until the dirty limits subside to an acceptable limit, at which stage this:

			if (nr_reclaimable +
				global_page_state(NR_WRITEBACK)
					<= dirty_thresh)
						break;


will happen and we leave balance_dirty_pages().

That's all a bit crappy if the wrong races happen and some other task is
somehow exceeding the dirty limits each time this task polls them.  Seems
unlikely that such a condition would persist forever.

So the question is, why do we have large amounts of dirty pages for one
disk which appear to be sitting there not getting written?

Do we know if there's any writeout at all happening when the system is in
this state?

I guess it's possible that the dirty inodes on the "other" disk got
themselves onto the wrong per-sb inode list, or are on the correct list,
but in the correct place.  If so, these:

writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
writeback-fix-periodic-superblock-dirty-inode-flushing.patch

from 2.6.23-rc6-mm1 should help.


Did anyone try running /bin/sync when the system is in this state?
