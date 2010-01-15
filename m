Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab0AOD65 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 22:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892Ab0AOD64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 22:58:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36023 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab0AOD6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 22:58:54 -0500
X-Authority-Analysis: v=1.0 c=1 a=NEDTl4KTtAgA:10 a=omOdbC7AAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=cHBqzMnZThuvjdwb_Q0A:9 a=G8aSA9XEQ7ZgVkQBonsUAY9MugUA:4 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100115035852.995805157@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 Jan 2010 22:57:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/8] tracing/filters: Fix MATCH_END_ONLY filter matching
References: <20100115035726.462940848@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-filters-Fix-MATCH_END_ONLY-filter-matching.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

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
-- 
1.6.5


