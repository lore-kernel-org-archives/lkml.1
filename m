Return-Path: <linux-kernel-owner+w=401wt.eu-S1755043AbZLKJ66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbZLKJ66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 04:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbZLKJ6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 04:58:53 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54332 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753229AbZLKJ6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 04:58:52 -0500
Message-ID: <4B2217D0.5000308@cn.fujitsu.com>
Date: Fri, 11 Dec 2009 17:58:40 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Wenji Huang <wenji.huang@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] ftrace: Fix MATCH_END_ONLY filter matching
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For '*foo' pattern, we should allow any string ending with
'foo', but ftrace filter incorrectly disallows strings
like bar_foo_foo:

  # echo '*io' > set_ftrace_filter
  # cat set_ftrace_filter | grep 'req_bio_endio'
  # cat available_filter_functions | grep 'req_bio_endio'
  req_bio_endio

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/ftrace.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index e51a1bc..613dfb1 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1690,7 +1690,7 @@ ftrace_regex_lseek(struct file *file, loff_t offset, int origin)
 static int ftrace_match(char *str, char *regex, int len, int type)
 {
 	int matched = 0;
-	char *ptr;
+	int slen;
 
 	switch (type) {
 	case MATCH_FULL:
@@ -1706,8 +1706,8 @@ static int ftrace_match(char *str, char *regex, int len, int type)
 			matched = 1;
 		break;
 	case MATCH_END_ONLY:
-		ptr = strstr(str, regex);
-		if (ptr && (ptr[len] == 0))
+		slen = strlen(str);
+		if (slen >= len && memcpy(str + slen - len, regex, len))
 			matched = 1;
 		break;
 	}
-- 
1.6.3

