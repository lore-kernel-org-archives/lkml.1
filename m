Return-Path: <linux-kernel-owner+w=401wt.eu-S1758082AbZJMBaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082AbZJMBaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 21:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754907AbZJMBaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 21:30:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64521 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755493AbZJMBap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 21:30:45 -0400
Message-ID: <4AD3D7D9.4070400@cn.fujitsu.com>
Date: Tue, 13 Oct 2009 09:28:57 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing/filters: Fix memory leak when setting a filter
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every time we set a filter, we leak memory allocated by
postfix_append_operand() and postfix_append_op().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_events_filter.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 2324578..98a6cc5 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -933,8 +933,9 @@ static void postfix_clear(struct filter_parse_state *ps)
 
 	while (!list_empty(&ps->postfix)) {
 		elt = list_first_entry(&ps->postfix, struct postfix_elt, list);
-		kfree(elt->operand);
 		list_del(&elt->list);
+		kfree(elt->operand);
+		kfree(elt);
 	}
 }
 
-- 
1.6.3

