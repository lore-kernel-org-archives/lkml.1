Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585Ab0ANCy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab0ANCy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 21:54:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754226Ab0ANCy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 21:54:27 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51815 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751993Ab0ANCy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 21:54:26 -0500
Message-ID: <4B4E8763.5070707@cn.fujitsu.com>
Date: Thu, 14 Jan 2010 10:54:27 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/7] tracing/filters: Fix MATCH_END_ONLY filter matching for
 PTR_STRING
References: <4B4E86FB.40208@cn.fujitsu.com>
In-Reply-To: <4B4E86FB.40208@cn.fujitsu.com>
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
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_events_filter.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index c43ebb3..14e83de 100644
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
 
@@ -782,10 +783,8 @@ static int filter_add_pred(struct filter_parse_state *ps,
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

