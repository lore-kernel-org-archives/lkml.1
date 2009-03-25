Return-Path: <linux-kernel-owner+w=401wt.eu-S1760684AbZCYLzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684AbZCYLzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 07:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757111AbZCYLzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 07:55:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:36737 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759615AbZCYLzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 07:55:09 -0400
Date: Wed, 25 Mar 2009 11:54:26 GMT
From: Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, jens.axboe@oracle.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
       jens.axboe@oracle.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49C9F700.9070609@cn.fujitsu.com>
References: <49C9F700.9070609@cn.fujitsu.com>
Subject: [tip:tracing/blktrace] blktrace: fix timestamp in binary output
Message-ID: <tip-d8708d61b1d4e70f2dd2ff0896bded28a7ca0ea4@git.kernel.org>
Git-Commit-ID: d8708d61b1d4e70f2dd2ff0896bded28a7ca0ea4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 11:54:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8708d61b1d4e70f2dd2ff0896bded28a7ca0ea4
Gitweb:     http://git.kernel.org/tip/d8708d61b1d4e70f2dd2ff0896bded28a7ca0ea4
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 25 Mar 2009 17:18:56 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Mar 2009 12:05:38 +0100

blktrace: fix timestamp in binary output

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
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <49C9F700.9070609@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
