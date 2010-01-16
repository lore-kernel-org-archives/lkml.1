Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab0APJnX (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 04:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077Ab0APJnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 04:43:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:54154 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab0APJnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 04:43:10 -0500
Date: Sat, 16 Jan 2010 09:42:54 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <4B4E870E.6060607@cn.fujitsu.com>
References: <4B4E870E.6060607@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] ftrace: Fix MATCH_END_ONLY function filter
Message-ID: <tip-751e9983ee276cb150e8812b1d995f6035a63878@git.kernel.org>
Git-Commit-ID: 751e9983ee276cb150e8812b1d995f6035a63878
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 16 Jan 2010 09:42:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  751e9983ee276cb150e8812b1d995f6035a63878
Gitweb:     http://git.kernel.org/tip/751e9983ee276cb150e8812b1d995f6035a63878
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 14 Jan 2010 10:53:02 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 14 Jan 2010 22:38:03 -0500

ftrace: Fix MATCH_END_ONLY function filter

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
