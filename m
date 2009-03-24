Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbZCXHPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbZCXHPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 03:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756479AbZCXHOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 03:14:48 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:6962 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504AbZCXHOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 03:14:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Kf+Q0UxO0fbx2SQo2xxVP/RM2xCfdT3QwH/w8jznAibVtrKmJ81CChk3sJ73/qtEv3
         gfAA5wxrk7nslyqzuDyrfBLJnAHT9S1L3c/1PU2bgLQR76iFNwJDziOQqXVITWn42zl1
         kcyhVSV//dODZJWb6mN1O1KMdi3SnxT8Gna88=
Subject: [PATCH] tracing/filters: disallow integer values for string
	filters and vice versa
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain
Date: Tue, 24 Mar 2009 02:14:42 -0500
Message-Id: <1237878882.8339.61.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure filters for string fields don't use integer values and vice
versa.  Getting it wrong can crash the system or produce bogus
results.  

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

---
 kernel/trace/trace_events_filter.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 9fca8bb..026be41 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -237,9 +237,14 @@ int filter_add_pred(struct ftrace_event_call *call, struct filter_pred *pred)
 	pred->offset = field->offset;
 
 	if (is_string_field(field->type)) {
+		if (!pred->str_val)
+			return -EINVAL;
 		pred->fn = filter_pred_string;
 		pred->str_len = field->size;
 		return __filter_add_pred(call, pred);
+	} else {
+		if (pred->str_val)
+			return -EINVAL;
 	}
 
 	switch (field->size) {
-- 
1.5.6.3



