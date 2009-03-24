Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbZCXIFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbZCXIFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 04:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756068AbZCXIEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 04:04:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52981 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755257AbZCXIEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 04:04:40 -0400
Message-ID: <49C89432.8010805@cn.fujitsu.com>
Date: Tue, 24 Mar 2009 16:05:06 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] blktrace: fix wrong calculation of RWBS
References: <49C893FC.9080905@cn.fujitsu.com>
In-Reply-To: <49C893FC.9080905@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trace categories are the upper 16 bits, not the lower 16 bits.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/blktrace.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 1ffcbd4..9af4143 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -922,23 +922,24 @@ static void blk_unregister_tracepoints(void)
 static void fill_rwbs(char *rwbs, const struct blk_io_trace *t)
 {
 	int i = 0;
+	int tc = t->action >> BLK_TC_SHIFT;
 
-	if (t->action & BLK_TC_DISCARD)
+	if (tc & BLK_TC_DISCARD)
 		rwbs[i++] = 'D';
-	else if (t->action & BLK_TC_WRITE)
+	else if (tc & BLK_TC_WRITE)
 		rwbs[i++] = 'W';
 	else if (t->bytes)
 		rwbs[i++] = 'R';
 	else
 		rwbs[i++] = 'N';
 
-	if (t->action & BLK_TC_AHEAD)
+	if (tc & BLK_TC_AHEAD)
 		rwbs[i++] = 'A';
-	if (t->action & BLK_TC_BARRIER)
+	if (tc & BLK_TC_BARRIER)
 		rwbs[i++] = 'B';
-	if (t->action & BLK_TC_SYNC)
+	if (tc & BLK_TC_SYNC)
 		rwbs[i++] = 'S';
-	if (t->action & BLK_TC_META)
+	if (tc & BLK_TC_META)
 		rwbs[i++] = 'M';
 
 	rwbs[i] = '\0';
-- 
1.5.4.rc3

