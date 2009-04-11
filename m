Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbZDKHyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbZDKHyn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 03:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756910AbZDKHyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 03:54:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59382 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756297AbZDKHyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 03:54:31 -0400
Message-ID: <49E04CDF.90004@cn.fujitsu.com>
Date: Sat, 11 Apr 2009 15:55:11 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/7] tracing/filters: disallow newline as delimeter
References: <49E04C22.4040608@cn.fujitsu.com>
In-Reply-To: <49E04C22.4040608@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I guess because user input is often ended with '\n' (like "echo xxx"),
thus '\n' is used as a delimeter besides ' ' ? But we can just strip
tailing spaces.

One of the effects of this patch, is fixing this inconsistency:

 # echo -n 'parent_comm ==' > filter
 bash: echo: write error: Invalid argument

 # echo 'parent_comm ==' > filter
 # cat filter
 parent_comm ==

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_events_filter.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 2bf4481..8e3a095 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -364,7 +364,9 @@ int filter_parse(char **pbuf, struct filter_pred *pred)
 	char *tmp, *tok, *val_str = NULL;
 	int tok_n = 0;
 
-	while ((tok = strsep(pbuf, " \n"))) {
+	strstrip(*pbuf);
+
+	while ((tok = strsep(pbuf, " "))) {
 		if (tok_n == 0) {
 			if (!strcmp(tok, "0")) {
 				pred->clear = 1;
-- 
1.5.4.rc3

