Return-Path: <linux-kernel-owner+w=401wt.eu-S1751999AbZEZECu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbZEZECu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 00:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750822AbZEZECm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 00:02:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58752 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbZEZECl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 00:02:41 -0400
Message-ID: <4A1B6A2F.2040703@cn.fujitsu.com>
Date: Tue, 26 May 2009 12:03:59 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Steven Whitehouse <swhiteho@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/2] tracing/events: convert block trace points to TRACE_EVENT()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the v2 patchset to convert block trace points to TRACE_EVENT().

The biggest change is to use __string() instead of __array() to store
hex dump of rq->cmd, so we minimize the memory occupied by rq->cmd from
48 bytes to 3 bytes for fs events. Also some fixes and cleanups.

I haven't had time to benchmark the ioctl blktrace versus the splice
based TRACE_EVENT tracing, but will do in these 2 days.

This patchset should be applied on top of:

"[PATCH] tracing/events: change the type of __str_loc_item to unsigned short"
(http://lkml.org/lkml/2009/5/21/17)

which hasn't been applied to tip tree.


[PATCH v2 1/2] tracing/events: make __string() more general
[PATCH v2 2/2] tracing/events: convert block trace points to TRACE_EVENT()
---
 block/blk-core.c               |   16 +-
 block/elevator.c               |    8 +-
 drivers/md/dm.c                |    5 +-
 fs/bio.c                       |    3 +-
 include/linux/blktrace_api.h   |   13 +
 include/trace/block.h          |   76 -------
 include/trace/events/block.h   |  483 ++++++++++++++++++++++++++++++++++++++++
 include/trace/events/irq.h     |   12 +-
 include/trace/events/lockdep.h |    8 +-
 include/trace/ftrace.h         |   21 +-
 kernel/trace/Makefile          |    5 +-
 kernel/trace/blktrace.c        |   78 +++++++-
 mm/bounce.c                    |    5 +-
 13 files changed, 611 insertions(+), 122 deletions(-)

A sample output:

         konsole-2057  [001]   870.751689: block_unplug_io: [konsole] 2
          <idle>-0     [001]   870.759674: block_rq_complete: 8,0 R () 115104312 + 24 [0]
          <idle>-0     [001]   870.760744: block_rq_complete: 8,0 R () 115104344 + 120 [0]
         konsole-2057  [001]   870.761233: block_remap: 8,0 R 115132584 + 256 <- (8,8) 12428976
         konsole-2057  [001]   870.761234: block_bio_queue: 8,0 R 115132584 + 256 [konsole]
         konsole-2057  [001]   870.761239: block_getrq: 8,0 R 115132584 + 256 [konsole]
         konsole-2057  [001]   870.761243: block_plug: [konsole]
         konsole-2057  [001]   870.761244: block_rq_insert: 8,0 R 0 () 115132584 + 256 [konsole]
         konsole-2057  [001]   870.761248: block_rq_issue: 8,0 R 0 () 115132584 + 256 [konsole]
         konsole-2057  [001]   870.761311: block_unplug_io: [konsole] 1
          <idle>-0     [001]   870.770299: block_rq_complete: 8,0 R () 115132584 + 256 [0]
         konsole-2057  [001]   870.770603: block_remap: 8,0 R 115143352 + 8 <- (8,8) 12439744
         konsole-2057  [001]   870.770604: block_bio_queue: 8,0 R 115143352 + 8 [konsole]
         konsole-2057  [001]   870.770609: block_getrq: 8,0 R 115143352 + 8 [konsole]
         konsole-2057  [001]   870.770612: block_plug: [konsole]
         konsole-2057  [001]   870.770614: block_rq_insert: 8,0 R 0 () 115143352 + 8 [konsole]
         konsole-2057  [001]   870.770666: block_remap: 8,0 R 115143376 + 104 <- (8,8) 12439768
         konsole-2057  [001]   870.770667: block_bio_queue: 8,0 R 115143376 + 104 [konsole]
         konsole-2057  [001]   870.770672: block_getrq: 8,0 R 115143376 + 104 [konsole]
         konsole-2057  [001]   870.770674: block_rq_insert: 8,0 R 0 () 115143376 + 104 [konsole]
         konsole-2057  [001]   870.770678: block_rq_issue: 8,0 R 0 () 115143352 + 8 [konsole]
         konsole-2057  [001]   870.770736: block_rq_issue: 8,0 R 0 () 115143376 + 104 [konsole]
         konsole-2057  [001]   870.770744: block_unplug_io: [konsole] 2
          <idle>-0     [001]   870.780006: block_rq_complete: 8,0 R () 115143352 + 8 [0]
         konsole-2057  [001]   870.780423: block_remap: 8,0 R 115184728 + 168 <- (8,8) 12481120
         konsole-2057  [001]   870.780424: block_bio_queue: 8,0 R 115184728 + 168 [konsole]
         konsole-2057  [001]   870.780429: block_getrq: 8,0 R 115184728 + 168 [konsole]
         konsole-2057  [001]   870.780432: block_plug: [konsole]
         konsole-2057  [001]   870.780433: block_rq_insert: 8,0 R 0 () 115184728 + 168 [konsole]
         konsole-2057  [001]   870.780437: block_rq_issue: 8,0 R 0 () 115184728 + 168 [konsole]
         konsole-2057  [001]   870.780483: block_remap: 8,0 R 115187448 + 88 <- (8,8) 12483840
         konsole-2057  [001]   870.780484: block_bio_queue: 8,0 R 115187448 + 88 [konsole]
         konsole-2057  [001]   870.780488: block_getrq: 8,0 R 115187448 + 88 [konsole]
         konsole-2057  [001]   870.780490: block_rq_insert: 8,0 R 0 () 115187448 + 88 [konsole]
         konsole-2057  [001]   870.780496: block_unplug_io: [konsole] 3
          <idle>-0     [001]   870.781010: block_rq_complete: 8,0 R () 115143376 + 104 [0]
          <idle>-0     [001]   870.781076: block_rq_issue: 8,0 R 0 () 115187448 + 88 [swapper]
          <idle>-0     [001]   870.792032: block_rq_complete: 8,0 R () 115184728 + 168 [0]
               X-1702  [001]   870.801456: block_rq_complete: 8,0 R () 115187448 + 88 [0]


