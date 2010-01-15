Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab0AOD64 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 22:58:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892Ab0AOD6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 22:58:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36023 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab0AOD6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 22:58:54 -0500
X-Authority-Analysis: v=1.0 c=1 a=Qu02r7rrDToA:10 a=omOdbC7AAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=WQOQTVSMW8mrUyfN6BQA:9 a=Bu_LVm-gg5_a5g6OlDPfujPwSp4A:4 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100115035852.463842164@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 Jan 2010 22:57:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/8] ftrace: Fix MATCH_END_ONLY function filter
References: <20100115035726.462940848@goodmis.org>
Content-Disposition: inline; filename=0002-ftrace-Fix-MATCH_END_ONLY-function-filter.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

For '*foo' pattern, we should allow any string ending with
'foo', but ftrace filter incorrectly disallows strings
like bar_foo_foo:

  # echo '*io' > set_ftrace_filter
  # cat set_ftrace_filter | grep 'req_bio_endio'
  # cat available_filter_functions | grep 'req_bio_endio'
  req_bio_endio

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4B4E870E.6060607@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 7968762..1e6640f 100644
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
+		if (slen >= len && memcmp(str + slen - len, regex, len) == 0)
 			matched = 1;
 		break;
 	}
-- 
1.6.5


