Return-Path: <linux-kernel-owner+w=401wt.eu-S1754371AbZECBvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbZECBvZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 21:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbZECBuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 21:50:40 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:61025 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbZECBui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 21:50:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=AoyT0S+sxrUdPykH6oa+jkxl2TIpV4R8qgVU+hN27QZCtyYRIDf2Gj7Omykf05tKoj
         kWfm1BZJq70iGqltsnhskH5ZHOC/iz/BPnNwObamqOuLuJRccuJn5r4riBLuiT5Ut20f
         5vS0UgsGn5hAWdPv3xkSKlChkYQwjUznFGOb4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 2/2] tracing/filters: support for operator reserved characters in strings
Date: Sun,  3 May 2009 03:50:33 +0200
Message-Id: <1241315433-7225-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1241315433-7225-1-git-send-email-fweisbec@gmail.com>
References: <1241315433-7225-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we set a filter for an event, such as:

echo "name == my_lock_name" > \
	/debug/tracing/events/lockdep/lock_acquired/filter

then the following order of token type is parsed:

- space
- operator
- parentheses
- operand

Because the operators and parentheses have a higher precedence
than the operand characters, which is normal, then we can't
use any string containing such special characters:

()=<>!&|

To get this support and also avoid ambiguous intepretation from
the parser or the human, we can do it using double quotes so that
we keep the usual languages habits.

Then after this patch you can still declare string condition like
before:

echo name == myname

But if you want to compare against a string containing an operator
character, you can use double quotes:

echo 'name == "&myname"'

Don't forget to include the whole expression into single quotes or
the double ones will be eaten by echo.

[ Impact: support strings with special characters for tracing filters ]

Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_events_filter.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 4f0a128..ac30de3 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -839,10 +839,19 @@ static void postfix_clear(struct filter_parse_state *ps)
 
 static int filter_parse(struct filter_parse_state *ps)
 {
+	int in_string = 0;
 	int op, top_op;
 	char ch;
 
 	while ((ch = infix_next(ps))) {
+		if (ch == '"') {
+			in_string ^= 1;
+			continue;
+		}
+
+		if (in_string)
+			goto parse_operand;
+
 		if (isspace(ch))
 			continue;
 
@@ -896,6 +905,7 @@ static int filter_parse(struct filter_parse_state *ps)
 			}
 			continue;
 		}
+parse_operand:
 		if (append_operand_char(ps, ch)) {
 			parse_error(ps, FILT_ERR_OPERAND_TOO_LONG, 0);
 			return -EINVAL;
-- 
1.6.2.3

