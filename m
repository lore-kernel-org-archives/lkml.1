Return-Path: <linux-kernel-owner+w=401wt.eu-S1756986AbZCXH3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986AbZCXH3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 03:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756786AbZCXH2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 03:28:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:37702 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756290AbZCXH2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 03:28:40 -0400
Date: Tue, 24 Mar 2009 07:28:04 GMT
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, tzanussi@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1237878882.8339.61.camel@charm-linux>
References: <1237878882.8339.61.camel@charm-linux>
Subject: [tip:tracing/filters] tracing/filters: disallow integer values for string filters and vice versa
Message-ID: <tip-9f58a159d022c8f2533a27708aa267adf4f0e3ce@git.kernel.org>
Git-Commit-ID: 9f58a159d022c8f2533a27708aa267adf4f0e3ce
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 07:28:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9f58a159d022c8f2533a27708aa267adf4f0e3ce
Gitweb:     http://git.kernel.org/tip/9f58a159d022c8f2533a27708aa267adf4f0e3ce
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Tue, 24 Mar 2009 02:14:42 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Mar 2009 08:26:52 +0100

tracing/filters: disallow integer values for string filters and vice versa

Impact: fix filter use boundary condition / crash

Make sure filters for string fields don't use integer values and vice
versa.  Getting it wrong can crash the system or produce bogus
results.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1237878882.8339.61.camel@charm-linux>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
