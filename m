Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbZLKJ7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbZLKJ7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 04:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754374AbZLKJ7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 04:59:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55950 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753958AbZLKJ7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 04:59:17 -0500
Message-ID: <4B2217EA.4010902@cn.fujitsu.com>
Date: Fri, 11 Dec 2009 17:59:06 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Wenji Huang <wenji.huang@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] tracing/filters: Fix MATCH_FULL filter matching for PTR_STRING
References: <4B2217D0.5000308@cn.fujitsu.com>
In-Reply-To: <4B2217D0.5000308@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MATCH_FULL matching for PTR_STRING is not working correctly:

  # echo 'func == vt' > events/bkl/lock_kernel/filter
  # echo 1 > events/bkl/lock_kernel/enable
  ...
  # cat trace
   Xorg-1484  [000]  1973.392586: lock_kernel: ... func=vt_ioctl()
    gpm-1402  [001]  1974.027740: lock_kernel: ... func=vt_ioctl()

We should pass to regex.match(..., len) the length (including '\0')
of the source string instead of the length of the pattern string.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_events_filter.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 50504cb..c8eb1c0 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -211,8 +211,9 @@ static int filter_pred_pchar(struct filter_pred *pred, void *event,
 {
 	char **addr = (char **)(event + pred->offset);
 	int cmp, match;
+	int len = strlen(*addr) + 1;	/* including tailing '\0' */
 
-	cmp = pred->regex.match(*addr, &pred->regex, pred->regex.field_len);
+	cmp = pred->regex.match(*addr, &pred->regex, len);
 
 	match = cmp ^ pred->not;
 
@@ -781,10 +782,8 @@ static int filter_add_pred(struct filter_parse_state *ps,
 			pred->regex.field_len = field->size;
 		} else if (field->filter_type == FILTER_DYN_STRING)
 			fn = filter_pred_strloc;
-		else {
+		else
 			fn = filter_pred_pchar;
-			pred->regex.field_len = strlen(pred->regex.pattern);
-		}
 	} else {
 		if (field->is_signed)
 			ret = strict_strtoll(pred->regex.pattern, 0, &val);
-- 
1.6.3

