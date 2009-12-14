Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbZLNJqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbZLNJqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 04:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755140AbZLNJqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 04:46:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:48190 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755129AbZLNJqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 04:46:47 -0500
Date: Mon, 14 Dec 2009 09:46:19 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de
In-Reply-To: <4B1DC4BF.2070003@cn.fujitsu.com>
References: <4B1DC4BF.2070003@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] ftrace: Return EINVAL when writing invalid val to set_ftrace_filter
Message-ID: <tip-311d16da575f53c3367099579736c1d233efe0dc@git.kernel.org>
Git-Commit-ID: 311d16da575f53c3367099579736c1d233efe0dc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  311d16da575f53c3367099579736c1d233efe0dc
Gitweb:     http://git.kernel.org/tip/311d16da575f53c3367099579736c1d233efe0dc
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 8 Dec 2009 11:15:11 +0800
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Sun, 13 Dec 2009 18:37:25 +0100

ftrace: Return EINVAL when writing invalid val to set_ftrace_filter

Currently it doesn't warn user on invald value:

 # echo nonexist_symbol > set_ftrace_filter
or:
 # echo 'nonexist_symbol:mod:fuse' > set_ftrace_filter

Better make it return failure.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4B1DC4BF.2070003@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
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
