Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbZKCA5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbZKCA5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 19:57:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757452AbZKCA5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 19:57:23 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51638 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757445AbZKCA5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 19:57:22 -0500
Message-ID: <4AEF7FBC.2050802@cn.fujitsu.com>
Date: Tue, 03 Nov 2009 08:56:28 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] ftrace: Return EINVAL when writing invalid val to set_ftrace_filter
References: <4AEF7F8A.3080300@cn.fujitsu.com>
In-Reply-To: <4AEF7F8A.3080300@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently it doesn't warn user on invald value:

 # echo nonexist_symbol > set_ftrace_filter

Better make it return failure.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/ftrace.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 7cb6f19..e0184b7 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1724,7 +1724,7 @@ ftrace_match_record(struct dyn_ftrace *rec, char *regex, int len, int type)
 	return ftrace_match(str, regex, len, type);
 }
 
-static void ftrace_match_records(char *buff, int len, int enable)
+static int ftrace_match_records(char *buff, int len, int enable)
 {
 	unsigned int search_len;
 	struct ftrace_page *pg;
@@ -1733,6 +1733,7 @@ static void ftrace_match_records(char *buff, int len, int enable)
 	char *search;
 	int type;
 	int not;
+	int found = 0;
 
 	flag = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
 	type = filter_parse_regex(buff, len, &search, &not);
@@ -1750,6 +1751,7 @@ static void ftrace_match_records(char *buff, int len, int enable)
 				rec->flags &= ~flag;
 			else
 				rec->flags |= flag;
+			found = 1;
 		}
 		/*
 		 * Only enable filtering if we have a function that
@@ -1759,6 +1761,8 @@ static void ftrace_match_records(char *buff, int len, int enable)
 			ftrace_filtered = 1;
 	} while_for_each_ftrace_rec();
 	mutex_unlock(&ftrace_lock);
+
+	return found;
 }
 
 static int
@@ -2151,8 +2155,10 @@ static int ftrace_process_regex(char *buff, int len, int enable)
 	func = strsep(&next, ":");
 
 	if (!next) {
-		ftrace_match_records(func, len, enable);
-		return 0;
+		if (ftrace_match_records(func, len, enable))
+			return 0;
+		else
+			return ret;
 	}
 
 	/* command found */
-- 
1.6.3

