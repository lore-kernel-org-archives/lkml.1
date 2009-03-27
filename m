Return-Path: <linux-kernel-owner+w=401wt.eu-S1763265AbZC0FmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763265AbZC0FmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 01:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762424AbZC0Flj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 01:41:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62726 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760739AbZC0Fli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 01:41:38 -0400
Message-ID: <49CC672E.6050507@cn.fujitsu.com>
Date: Fri, 27 Mar 2009 13:42:06 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 7/7] blktrace: support filtering of BLK_TN_MESSAGE
References: <49CC6691.7050103@cn.fujitsu.com>
In-Reply-To: <49CC6691.7050103@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found large bunk of the output of blktrace are BLK_TN_MESSAGE events:

 % blktrace -d /dev/sda -o - | blkparse -i - -o ~/blk.log
 (after some seconds)
 % cat ~/blk.log | wc -l
 69041
 % cat ~/blk.log | grep "m   N" | wc -l
 38232

It will be useful to be able to filter those events.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/blktrace.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 947c5b3..dcabe59 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -131,6 +131,9 @@ void __trace_note_message(struct blk_trace *bt, const char *fmt, ...)
 		     !blk_tracer_enabled))
 		return;
 
+	if (!(bt->act_mask & BLK_TC_NOTIFY))
+		return;
+
 	local_irq_save(flags);
 	buf = per_cpu_ptr(bt->msg_data, smp_processor_id());
 	va_start(args, fmt);
@@ -1366,6 +1369,7 @@ static const struct {
 	{ BLK_TC_COMPLETE,	"complete"	},
 	{ BLK_TC_FS,		"fs"		},
 	{ BLK_TC_PC,		"pc"		},
+	{ BLK_TC_NOTIFY,	"notify"	},
 	{ BLK_TC_AHEAD,		"ahead"		},
 	{ BLK_TC_META,		"meta"		},
 	{ BLK_TC_DISCARD,	"discard"	},
-- 
1.5.4.rc3

