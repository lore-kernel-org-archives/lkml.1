Return-Path: <linux-kernel-owner+w=401wt.eu-S935206AbZDBG3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935206AbZDBG3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 02:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756757AbZDBG3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 02:29:35 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:59967 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296AbZDBG3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 02:29:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=h1t1RYInIS1S9cUYuh5N002wwLHy+63e9s60cBRfyP7tL5JWbmoxL8/2TqOfcaU857
         nyWmpgpJ6/sSfPH5Y5WxnZoTTckPWHOPrJsRxkUheKzrVlvSu1Derx5ON9LU023bj+GL
         d0otnUiLU/lYcXFsVev6nK5NjUNC4mtBLN5mw=
Subject: [PATCH] tracing/filters: disallow concurrent/multiple
 setting/enabling of filters
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       fweisbec@gmail.com
Content-Type: text/plain
Date: Thu, 02 Apr 2009 01:29:30 -0500
Message-Id: <1238653770.6655.62.camel@bookworm>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch disallows setting/enabling or multiple concurrent setting
and/or reading of event filters. 

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

---
 kernel/trace/trace_events.c |   30 ++++++++++++++++++++++++++----
 1 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index be9299a..eb7ee65 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -481,7 +481,10 @@ event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 
 	trace_seq_init(s);
 
+	mutex_lock(&event_mutex);
 	filter_print_preds(call->preds, s);
+	mutex_unlock(&event_mutex);
+
 	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
 
 	kfree(s);
@@ -514,20 +517,28 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		return err;
 	}
 
+	mutex_lock(&event_mutex);
 	if (pred->clear) {
 		filter_free_preds(call);
 		filter_free_pred(pred);
-		return cnt;
+		err = cnt;
+		goto out;
 	}
 
 	if (filter_add_pred(call, pred)) {
 		filter_free_pred(pred);
-		return -EINVAL;
+		err = -EINVAL;
+		goto out;
 	}
+	mutex_unlock(&event_mutex);
 
 	*ppos += cnt;
 
 	return cnt;
+
+out:
+	mutex_unlock(&event_mutex);
+	return err;
 }
 
 static ssize_t
@@ -547,7 +558,10 @@ subsystem_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 
 	trace_seq_init(s);
 
+	mutex_lock(&event_mutex);
 	filter_print_preds(system->preds, s);
+	mutex_unlock(&event_mutex);
+
 	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
 
 	kfree(s);
@@ -580,21 +594,29 @@ subsystem_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		return err;
 	}
 
+	mutex_lock(&event_mutex);
 	if (pred->clear) {
 		filter_free_subsystem_preds(system);
 		filter_free_pred(pred);
-		return cnt;
+		err = cnt;
+		goto out;
 	}
 
 	if (filter_add_subsystem_pred(system, pred)) {
 		filter_free_subsystem_preds(system);
 		filter_free_pred(pred);
-		return -EINVAL;
+		err = -EINVAL;
+		goto out;
 	}
+	mutex_unlock(&event_mutex);
 
 	*ppos += cnt;
 
 	return cnt;
+
+out:
+	mutex_unlock(&event_mutex);
+	return err;
 }
 
 static const struct seq_operations show_event_seq_ops = {
-- 
1.5.6.3



