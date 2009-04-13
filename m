Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbZDMV7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbZDMV7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 17:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbZDMV72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 17:59:28 -0400
Received: from thunk.org ([69.25.196.29]:56089 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbZDMV71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 17:59:27 -0400
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>
Subject: blktrace: event traces displayed wrong while ftrace blktrace is active
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1LtUBT-0007kq-HU@closure.thunk.org>
Date: Mon, 13 Apr 2009 17:59:19 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Li,

Thanks for working on the ftrace blktrace code; I was wondering if you
could take a look at something.   While the nop or syscall tracer is
selected ("echo nop > /sys/kernel/debug/tracing/current_tracer"), the
event traces display like this:

           <...>-4491  [001]  9556.305696: jbd2_start_commit: dev dm-0:8 transaction 335442
           <...>-4491  [001]  9556.305700: jbd2_commit_locking: dev dm-0:8 transaction 335442
           <...>-4491  [001]  9556.305713: jbd2_commit_flushing: dev dm-0:8 transaction 335442
           <...>-4491  [001]  9556.305720: jbd2_submit_inode_data: dev dm-0 transaction ino 3807454
           <...>-4491  [001]  9556.305833: jbd2_commit_logging: dev dm-0:8 transaction 335442
           <...>-4491  [000]  9556.307241: jbd2_end_commit: dev dm-0:8 transaction 335442 head 334303

That is, the timestamp information what CPU, what pid, etc., is present.

However, if the blk tracer is active, this information is missing:

jbd2_start_commit: dev dm-0:8 transaction 333227
jbd2_commit_locking: dev dm-0:8 transaction 333227
jbd2_commit_flushing: dev dm-0:8 transaction 333227
jbd2_submit_inode_data: dev dm-0 transaction ino 1466869
jbd2_submit_inode_data: dev dm-0 transaction ino 1310793
jbd2_commit_logging: dev dm-0:8 transaction 333227
jbd2_end_commit: dev dm-0:8 transaction 333227 head 332814

The context information for the blktrace is present:

              rm-25433 [001]  9578.307485:   8,18   m   N cfq25433 slice expired t=0
              rm-25433 [001]  9578.307486:   8,18   m   N cfq25433 put_queue
      kjournald2-14059 [001]  9579.032457:   8,18   A   W 5631242 + 8 <- (8,18) 3671312
      kjournald2-14059 [001]  9579.032462:   8,18   Q   W 5631242 + 8 [kjournald2]
      kjournald2-14059 [001]  9579.032470:   8,18   G   W 5631242 + 8 [kjournald2]

It's just the context information for the event traces which are
missing.

Anyway, if you could take a look at this, it would be much appreciated.
Usually I can interpolate the the timestamps from the surrounding
blktrace lines, but it would be nice if I didn't have to do that.

Regards,

	 	       	     	     	- Ted
