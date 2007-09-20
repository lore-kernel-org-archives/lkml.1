Return-Path: <linux-kernel-owner+w=401wt.eu-S1752815AbXITWpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbXITWpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 18:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750699AbXITWpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 18:45:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbXITWpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 18:45:08 -0400
Message-ID: <46F2F7CB.70001@redhat.com>
Date: Thu, 20 Sep 2007 18:44:27 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Matthias Hensler <matthias@wspse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       richard kennedy <richard@rsk.demon.co.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Processes spinning forever, apparently in lock_timer_base()?
References: <46B10BB7.60900@redhat.com>	<20070803113407.0b04d44e.akpm@linux-foundation.org>	<20070804084426.GA20464@kobayashi-maru.wspse.de>	<20070809095943.GA7763@kobayashi-maru.wspse.de>	<20070809095534.25ae1c42.akpm@linux-foundation.org>	<46F2E103.8000907@redhat.com>	<20070920142927.d87ab5af.akpm@linux-foundation.org>	<46F2EE76.4000203@redhat.com> <20070920153654.b9e90616.akpm@linux-foundation.org>
In-Reply-To: <20070920153654.b9e90616.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2007 06:36 PM, Andrew Morton wrote:
> 
> So the question is, why do we have large amounts of dirty pages for one
> disk which appear to be sitting there not getting written?
> 
> Do we know if there's any writeout at all happening when the system is in
> this state?
> 
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

Yikes! Simple fixes would be better.

Patch that is confirmed to fix the problem for this user is below, but
that one could cause other problems. I was looking for some band-aid
could be shown to be harmless...

http://lkml.org/lkml/2007/8/2/89:

------
--- linux-2.6.22.1/mm/page-writeback.c.orig	2007-07-30 16:36:09.000000000 +0100
+++ linux-2.6.22.1/mm/page-writeback.c	2007-07-31 16:26:43.000000000 +0100
@@ -250,6 +250,8 @@ static void balance_dirty_pages(struct a
 			pages_written += write_chunk - wbc.nr_to_write;
 			if (pages_written >= write_chunk)
 				break;		/* We've done our duty */
+			if (!wbc.encountered_congestion && wbc.nr_to_write > 0)
+				break;	/* didn't find enough to do */
 		}
 		congestion_wait(WRITE, HZ/10);
 	}

 
> 
> Did anyone try running /bin/sync when the system is in this state?
> 

Reporter is in the CC: list.
