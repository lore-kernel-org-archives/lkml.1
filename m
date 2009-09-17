Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbZIQIfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbZIQIfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 04:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbZIQIfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 04:35:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59984 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbZIQIfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 04:35:39 -0400
Message-ID: <4AB1F48F.4070807@cn.fujitsu.com>
Date: Thu, 17 Sep 2009 16:34:23 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] perf tools: Fix memory leak in read_ftrace_printk()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_tracing_file() should be paired with put_tracing_file().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 tools/perf/util/trace-event-info.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 6c9302a..1fd824c 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -458,7 +458,7 @@ static void read_proc_kallsyms(void)
 static void read_ftrace_printk(void)
 {
 	unsigned int size, check_size;
-	const char *path;
+	char *path;
 	struct stat st;
 	int ret;
 
@@ -468,14 +468,15 @@ static void read_ftrace_printk(void)
 		/* not found */
 		size = 0;
 		write_or_die(&size, 4);
-		return;
+		goto out;
 	}
 	size = get_size(path);
 	write_or_die(&size, 4);
 	check_size = copy_file(path);
 	if (size != check_size)
 		die("error in size of file '%s'", path);
-
+out:
+	put_tracing_file(path);
 }
 
 static struct tracepoint_path *
-- 
1.6.3

