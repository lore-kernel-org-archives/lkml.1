Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460Ab0ANCxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab0ANCxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 21:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198Ab0ANCxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 21:53:40 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60449 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751243Ab0ANCxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 21:53:39 -0500
Message-ID: <4B4E8735.6070604@cn.fujitsu.com>
Date: Thu, 14 Jan 2010 10:53:41 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/7] tracing/filters: Fix MATCH_END_ONLY filter matching
References: <4B4E86FB.40208@cn.fujitsu.com>
In-Reply-To: <4B4E86FB.40208@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'foo', but tracing filter incorrectly disallows strings
matching regex expression ".*foo.*foo".

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_events_filter.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 6d7b8f5..c6a0f8d 100644
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
1.6.3

