Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbZKCA4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbZKCA4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 19:56:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757514AbZKCA4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 19:56:38 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51028 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757434AbZKCA4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 19:56:36 -0500
Message-ID: <4AEF7F8A.3080300@cn.fujitsu.com>
Date: Tue, 03 Nov 2009 08:55:38 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] ftrace: Fix unmatching locking in ftrace_regex_write()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 # echo 'do_open : foo' > set_ftrace_filter
 (still holding ftrace_regex_lock when returning to user space!)

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

This patch is for .32

---
 kernel/trace/ftrace.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1ed514f..7cb6f19 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2199,15 +2199,15 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 		ret = ftrace_process_regex(parser->buffer,
 					   parser->idx, enable);
 		if (ret)
-			goto out;
+			goto out_unlock;
 
 		trace_parser_clear(parser);
 	}
 
 	ret = read;
-
+out_unlock:
 	mutex_unlock(&ftrace_regex_lock);
-out:
+
 	return ret;
 }
 
-- 
1.6.3
