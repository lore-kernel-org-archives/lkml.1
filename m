Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316AbZLKKAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbZLKKAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 05:00:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754374AbZLKJ7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 04:59:55 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50720 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753958AbZLKJ7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 04:59:53 -0500
Message-ID: <4B22180E.6090907@cn.fujitsu.com>
Date: Fri, 11 Dec 2009 17:59:42 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Wenji Huang <wenji.huang@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] tracing/filters: Fix MATCH_EBD_ONLY filter matching
References: <4B2217D0.5000308@cn.fujitsu.com>
In-Reply-To: <4B2217D0.5000308@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For '*foo' pattern, we should allow any string ending with
'foo', but tracing filter incorrectly disallows strings
matching regex expression ".*foo.*foo".

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_events_filter.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index bd492ce..9f96339 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -276,9 +276,10 @@ static int regex_match_middle(char *str, struct regex *r, int len)
 
 static int regex_match_end(char *str, struct regex *r, int len)
 {
-	char *ptr = strstr(str, r->pattern);
+	int strlen = len - 1;
 
-	if (ptr && (ptr[r->len] == 0))
+	if (strlen >= r->len &&
+	    !memcmp(str + strlen - r->len, r->pattern, r->len))
 		return 1;
 	return 0;
 }
-- 
1.6.3

