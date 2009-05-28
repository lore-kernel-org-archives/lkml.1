Return-Path: <linux-kernel-owner+w=401wt.eu-S1761419AbZE1ICd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761419AbZE1ICd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 04:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756667AbZE1ICK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 04:02:10 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:34446 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbZE1ICH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 04:02:07 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: mingo@elte.hu
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 3/3] trace: events_filter, fix lock imbalances
Date: Thu, 28 May 2009 09:54:49 +0200
Message-Id: <1243497289-18591-3-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <1243497289-18591-1-git-send-email-jirislaby@gmail.com>
References: <1243497289-18591-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

apply_event_filter and apply_subsystem_event_filter omits an unlock
on one fail path each. Fix that.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
---
 kernel/trace/trace_events_filter.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 85ad6a8..e35094a 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1080,8 +1080,10 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 	}
 
 	ps = kzalloc(sizeof(*ps), GFP_KERNEL);
-	if (!ps)
-		return -ENOMEM;
+	if (!ps) {
+		err = -ENOMEM;
+		goto unlock;
+	}
 
 	filter_disable_preds(call);
 	replace_filter_string(call->filter, filter_string);
@@ -1101,7 +1103,7 @@ out:
 	filter_opstack_clear(ps);
 	postfix_clear(ps);
 	kfree(ps);
-
+unlock:
 	mutex_unlock(&filter_mutex);
 
 	return err;
@@ -1124,8 +1126,10 @@ int apply_subsystem_event_filter(struct event_subsystem *system,
 	}
 
 	ps = kzalloc(sizeof(*ps), GFP_KERNEL);
-	if (!ps)
-		return -ENOMEM;
+	if (!ps) {
+		err = -ENOMEM;
+		goto unlock;
+	}
 
 	filter_free_subsystem_preds(system);
 	replace_filter_string(system->filter, filter_string);
@@ -1145,7 +1149,7 @@ out:
 	filter_opstack_clear(ps);
 	postfix_clear(ps);
 	kfree(ps);
-
+unlock:
 	mutex_unlock(&filter_mutex);
 
 	return err;
-- 
1.6.3

