Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbZLMNLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbZLMNLw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 08:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbZLMNLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 08:11:45 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:51043 "HELO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752293AbZLMNI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 08:08:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MHfJHxBhY+MXl3GiixCjmggDYeYUFL2nNCNpqpsLfhHL3Rxb3QRy669y6mrn7TdZKu
         eqqVg3SdG2eNoz0UwnJ6LlwogwxSKJLdP7ODnAOKFQlC0hfi7TIDowJ7JE83LKPLjDyT
         MRsYCzZYJlGz3tFwOXZPc0Aj3t8HxaIY9jGQs=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 04/13] ftrace: Return EINVAL when writing invalid val to set_ftrace_filter
Date: Sun, 13 Dec 2009 14:08:05 +0100
Message-Id: <1260709694-5166-5-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1260709694-5166-1-git-send-regression-fweisbec@gmail.com>
References: <1260709694-5166-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

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
-- 
1.6.2.3

