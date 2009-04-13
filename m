Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbZDMCiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbZDMCiL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 22:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753666AbZDMChz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 22:37:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55341 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753469AbZDMChz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 22:37:55 -0400
Message-ID: <49E2A5B0.1080802@cn.fujitsu.com>
Date: Mon, 13 Apr 2009 10:38:40 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] tracing/filters: disallow newline as delimeter
References: <49E2A594.4060306@cn.fujitsu.com>
In-Reply-To: <49E2A594.4060306@cn.fujitsu.com>
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
index a63f965..9ef35c1 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -362,7 +362,9 @@ int filter_parse(char **pbuf, struct filter_pred *pred)
 	char *tok, *val_str = NULL;
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

