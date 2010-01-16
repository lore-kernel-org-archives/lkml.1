Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab0APJop (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 04:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686Ab0APJol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 04:44:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:54239 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754268Ab0APJoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 04:44:39 -0500
Date: Sat, 16 Jan 2010 09:44:11 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <4B4E8763.5070707@cn.fujitsu.com>
References: <4B4E8763.5070707@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing/filters: Fix MATCH_FULL filter matching for PTR_STRING
Message-ID: <tip-16da27a8bc7a0d050686d1b2e9efb53fab9ed226@git.kernel.org>
Git-Commit-ID: 16da27a8bc7a0d050686d1b2e9efb53fab9ed226
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 16 Jan 2010 09:44:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  16da27a8bc7a0d050686d1b2e9efb53fab9ed226
Gitweb:     http://git.kernel.org/tip/16da27a8bc7a0d050686d1b2e9efb53fab9ed226
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 14 Jan 2010 10:54:27 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 14 Jan 2010 22:38:12 -0500

tracing/filters: Fix MATCH_FULL filter matching for PTR_STRING

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
