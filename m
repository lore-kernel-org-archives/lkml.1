Return-Path: <linux-kernel-owner+w=401wt.eu-S1758828AbZLGHlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbZLGHlg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 02:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758712AbZLGHld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 02:41:33 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62734 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758701AbZLGHlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 02:41:31 -0500
Message-ID: <4B1CB197.2020207@cn.fujitsu.com>
Date: Mon, 07 Dec 2009 15:41:11 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/13] ftrace: Return EINVAL when writing invalid val to set_ftrace_filter
References: <4B1CB14A.4080402@cn.fujitsu.com>
In-Reply-To: <4B1CB14A.4080402@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently it doesn't warn user on invald value:

 # echo nonexist_symbol > set_ftrace_filter
or:
 # echo 'nonexist_symbol:mod:fuse' > set_ftrace_filter

Better make it return failure.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/ftrace.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index e51a1bc..08a3fb5 100644
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
@@ -1780,7 +1784,7 @@ ftrace_match_module_record(struct dyn_ftrace *rec, char *mod,
 		return 1;
 }
 
-static void ftrace_match_module_records(char *buff, char *mod, int enable)
+static int ftrace_match_module_records(char *buff, char *mod, int enable)
 {
 	unsigned search_len = 0;
 	struct ftrace_page *pg;
@@ -1789,6 +1793,7 @@ static void ftrace_match_module_records(char *buff, char *mod, int enable)
 	char *search = buff;
 	unsigned long flag;
 	int not = 0;
+	int found = 0;
 
 	flag = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
 
@@ -1819,12 +1824,15 @@ static void ftrace_match_module_records(char *buff, char *mod, int enable)
 				rec->flags &= ~flag;
 			else
 				rec->flags |= flag;
+			found = 1;
 		}
 		if (enable && (rec->flags & FTRACE_FL_FILTER))
 			ftrace_filtered = 1;
 
 	} while_for_each_ftrace_rec();
 	mutex_unlock(&ftrace_lock);
+
+	return found;
 }
 
 /*
@@ -1853,8 +1861,9 @@ ftrace_mod_callback(char *func, char *cmd, char *param, int enable)
 	if (!strlen(mod))
 		return -EINVAL;
 
-	ftrace_match_module_records(func, mod, enable);
-	return 0;
+	if (ftrace_match_module_records(func, mod, enable))
+		return 0;
+	return -EINVAL;
 }
 
 static struct ftrace_func_command ftrace_mod_cmd = {
@@ -2151,8 +2160,9 @@ static int ftrace_process_regex(char *buff, int len, int enable)
 	func = strsep(&next, ":");
 
 	if (!next) {
-		ftrace_match_records(func, len, enable);
-		return 0;
+		if (ftrace_match_records(func, len, enable))
+			return 0;
+		return ret;
 	}
 
 	/* command found */
-- 
1.6.3

