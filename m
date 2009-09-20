Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbZITUOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbZITUOm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 16:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbZITUOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 16:14:40 -0400
Received: from THUNK.ORG ([69.25.196.29]:37391 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755420AbZITUOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 16:14:40 -0400
To: linux-kernel@vger.kernel.org
Subject: What should pgpgin and pgpgout actually measure?
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1MpS2x-0002SR-KT@closure.thunk.org>
Date: Sun, 20 Sep 2009 15:26:07 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While creating some slides for a Linux Performance Tuning class, I was
seized with a curiosity about what exactly the pgpgin/s and pgpgout/s
columns reported by sar actually means.  According to the sar man page:

              pgpgin/s
                     Total number of kilobytes the system paged in  from  disk
                     per second.  Note: With old kernels (2.2.x) this value is
                     a number of blocks per second (and not kilobytes).

              pgpgout/s
                     Total number of kilobytes the system paged  out  to  disk
                     per second.  Note: With old kernels (2.2.x) this value is
                     a number of blocks per second (and not kilobytes).

However, from what I can tell, this is coming from the pgpgin and
pgpgout from /proc/vmstats, and that in turn seems to be accounted for
from submit_bio() in blk/blk-core.c:

	if (bio_has_data(bio)) {
		if (rw & WRITE) {
			count_vm_events(PGPGOUT, count);
		} else {
			task_io_account_read(bio->bi_size);
			count_vm_events(PGPGIN, count);
		}

What this seems to imply is that curently *any* I/O, from ext3 journal
activity, or reading an inode table block, is considered "page in" and
"page out" activity.  This seems.... counter-intuitive at best.  Maybe
someone will tell that this is what sar has always done, but I'm
guessing this is something new, that was introduced in Linux 2.6 when
the buffer cache was implemented in terms of the page cache.

I'm not sure what would be a better definitions of these counters.  We
already have "pgmajfault" and "pgfault", so it's not clear what would be
a better thing to measure for "pgpgin".  However, we don't seem to have
a counter which measures number of pages cleaned; it seems though it
might be better to define a new "pgclean" field for /proc/vmstats rather
than redefining "pgpgout".

What do people think?

						- Ted
