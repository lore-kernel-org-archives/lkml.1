Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab0AOEAw (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 23:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755598Ab0AOEAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 23:00:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59952 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab0AOD6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 22:58:55 -0500
X-Authority-Analysis: v=1.0 c=1 a=MJMND8H6I6IA:10 a=omOdbC7AAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=06-mqBQmBueZ7_EYJnAA:9 a=phiTccZ7FZbGo1er8i3cow9-I-IA:4 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=hqQdktL9eqh6mlTC:21 a=SBc-EebMsjHPKUmh:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100115035853.910723642@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 Jan 2010 22:57:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 7/8] tracing/filters: Fix MATCH_FULL filter matching for PTR_STRING
References: <20100115035726.462940848@goodmis.org>
Content-Disposition: inline; filename=0007-tracing-filters-Fix-MATCH_FULL-filter-matching-for-P.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

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
LKML-Reference: <4B4E8763.5070707@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index f364b08..60c2a4e 100644
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
1.6.5


