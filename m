Return-Path: <linux-kernel-owner+w=401wt.eu-S1757246AbYLDGkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246AbYLDGkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 01:40:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbYLDGko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 01:40:44 -0500
Received: from mail.windriver.com ([147.11.1.11]:43808 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643AbYLDGkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 01:40:43 -0500
From: Liming Wang <liming.wang@windriver.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Liming Wang <liming.wang@windriver.com>
Subject: [PATCH 1/1] ftrace: avoid duplicated function when writing set_graph_function
Date: Thu,  4 Dec 2008 14:24:49 +0800
Message-Id: <1228371889-11195-1-git-send-email-liming.wang@windriver.com>
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <20081203203828.920111079@goodmis.org>
References: <20081203203828.920111079@goodmis.org>
X-OriginalArrivalTime: 04 Dec 2008 06:40:32.0821 (UTC) FILETIME=[34C3B650:01C955DB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix a bug

when writing function to set_graph_function, we should check whether it
has existed in set_graph_function to avoid duplicating.

Signed-off-by: Liming Wang <liming.wang@windriver.com>
---
 kernel/trace/ftrace.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index eb57dc1..d2b1565 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1425,7 +1425,7 @@ ftrace_set_func(unsigned long *array, int idx, char *buffer)
 	struct dyn_ftrace *rec;
 	struct ftrace_page *pg;
 	int found = 0;
-	int i;
+	int i, j;
 
 	if (ftrace_disabled)
 		return -ENODEV;
@@ -1443,7 +1443,13 @@ ftrace_set_func(unsigned long *array, int idx, char *buffer)
 			kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
 			if (strcmp(str, buffer) == 0) {
 				found = 1;
-				array[idx] = rec->ip;
+				for (j = 0; j < idx; j++)
+					if (array[j] == rec->ip) {
+						found = 0;
+						break;
+					}
+				if (found)
+					array[idx] = rec->ip;
 				break;
 			}
 		}
-- 
1.6.0.3

