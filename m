Return-Path: <linux-kernel-owner+w=401wt.eu-S1758698AbZCYJSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbZCYJSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758402AbZCYJSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:18:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52879 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758565AbZCYJSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:18:33 -0400
Message-ID: <49C9F700.9070609@cn.fujitsu.com>
Date: Wed, 25 Mar 2009 17:18:56 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] blktrace: fix timestamp in binary output
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found the timestamp is wrong:

 # echo bin > trace_option
 # echo blk > current_tracer
 # cat trace_pipe | blkparse -i -
 8,0    0        0     0.000000000   504  A   W ...
 ...
 8,7    1        0     0.008534097     0  C   R ...
            (should be 8.534097xxx)

user-space blkparse expects the timestamp to be nanosecond.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/blktrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 6fb274f..ee7a8bb 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1168,7 +1168,7 @@ static int blk_trace_synthesize_old_trace(struct trace_iterator *iter)
 	const int offset = offsetof(struct blk_io_trace, sector);
 	struct blk_io_trace old = {
 		.magic	  = BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION,
-		.time     = ns2usecs(iter->ts),
+		.time     = iter->ts,
 	};
 
 	if (!trace_seq_putmem(s, &old, offset))
-- 
1.5.4.rc3


