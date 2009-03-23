Return-Path: <linux-kernel-owner+w=401wt.eu-S1757523AbZCWI1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbZCWI1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757187AbZCWI0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:26:47 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:25360 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143AbZCWI0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:26:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=lruVhWN0od3enTvnV8SqoqUZT+EvxeEYatacGsZrPZo7rQ111D2gPZ1JXawyvqCube
         sqgmGws37JS/fRuYFO2UpPz6OUdB3dnxXoe89qaSzy1dCUEOhmCggzH2bxtLiqh44zuz
         Jd7tTo1aU342Bx06EyOSjQsNf6upDS1V2vF2E=
Subject: [PATCH] tracing/filters: fix bug in copy_pred()
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 03:26:42 -0500
Message-Id: <1237796802.7527.39.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When making a copy of the predicate, pred->field_name needs to be
duplicated in the copy as well, otherwise bad things can happen due to
later multiple frees of the same string.

This affects only per-subsystem event filtering.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

---
 kernel/trace/trace_events_filter.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index c4a413b..fd01d80 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -276,11 +276,19 @@ static struct filter_pred *copy_pred(struct filter_pred *pred)
 		return NULL;
 
 	memcpy(new_pred, pred, sizeof(*pred));
+
+	if (pred->field_name) {
+		new_pred->field_name = kstrdup(pred->field_name, GFP_KERNEL);
+		if (!new_pred->field_name) {
+			kfree(new_pred);
+			return NULL;
+		}
+	}
+
 	if (pred->str_val) {
 		new_pred->str_val = kstrdup(pred->str_val, GFP_KERNEL);
-		new_pred->field_name = kstrdup(pred->field_name, GFP_KERNEL);
 		if (!new_pred->str_val) {
-			kfree(new_pred);
+			filter_free_pred(new_pred);
 			return NULL;
 		}
 	}
-- 
1.5.6.3



