Return-Path: <linux-kernel-owner+w=401wt.eu-S1751496AbZIQWf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496AbZIQWf5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 18:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbZIQWfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 18:35:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:46178 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbZIQWfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 18:35:53 -0400
Date: Thu, 17 Sep 2009 22:35:27 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4AB1F48F.4070807@cn.fujitsu.com>
References: <4AB1F48F.4070807@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf tools: Fix memory leak in read_ftrace_printk()
Message-ID: <tip-6706ccf8e776e51e38ffa89fe7dd20e80eb1e860@git.kernel.org>
Git-Commit-ID: 6706ccf8e776e51e38ffa89fe7dd20e80eb1e860
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 17 Sep 2009 22:35:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6706ccf8e776e51e38ffa89fe7dd20e80eb1e860
Gitweb:     http://git.kernel.org/tip/6706ccf8e776e51e38ffa89fe7dd20e80eb1e860
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 17 Sep 2009 16:34:23 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Sep 2009 00:30:24 +0200

perf tools: Fix memory leak in read_ftrace_printk()

get_tracing_file() should be paired with put_tracing_file().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <4AB1F48F.4070807@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
