Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab0APJn4 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 04:43:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509Ab0APJnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 04:43:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:54208 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503Ab0APJnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 04:43:52 -0500
Date: Sat, 16 Jan 2010 09:43:25 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <4B4E8735.6070604@cn.fujitsu.com>
References: <4B4E8735.6070604@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing/filters: Fix MATCH_END_ONLY filter matching
Message-ID: <tip-a3291c14ecf0a995e30d993b7f2cae031de98727@git.kernel.org>
Git-Commit-ID: a3291c14ecf0a995e30d993b7f2cae031de98727
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 16 Jan 2010 09:43:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a3291c14ecf0a995e30d993b7f2cae031de98727
Gitweb:     http://git.kernel.org/tip/a3291c14ecf0a995e30d993b7f2cae031de98727
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 14 Jan 2010 10:53:41 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 14 Jan 2010 22:38:07 -0500

tracing/filters: Fix MATCH_END_ONLY filter matching

For '*foo' pattern, we should allow any string ending with
'foo', but event filtering incorrectly disallows strings
like bar_foo_foo:

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4B4E8735.6070604@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 11c3973..49e44dd 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -275,9 +275,10 @@ static int regex_match_middle(char *str, struct regex *r, int len)
 
 static int regex_match_end(char *str, struct regex *r, int len)
 {
-	char *ptr = strstr(str, r->pattern);
+	int strlen = len - 1;
 
-	if (ptr && (ptr[r->len] == 0))
+	if (strlen >= r->len &&
+	    memcmp(str + strlen - r->len, r->pattern, r->len) == 0)
 		return 1;
 	return 0;
 }
