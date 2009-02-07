Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbZBGWvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbZBGWvb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 17:51:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbZBGWvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 17:51:23 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52553 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489AbZBGWvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 17:51:22 -0500
Date: Sat, 7 Feb 2009 18:52:59 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip 1/1] tracing: handle unregistering the current tracer
Message-ID: <20090207205259.GB11892@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: simplification

Instead of requiring that plugins have the sequence:

  my_tracer_stop(my_trace_array);
  unregister_tracer(my_tracer);

it should be possible just do a:

  unregister_tracer(my_tracer);

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 kernel/trace/trace.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ef4dbac..d247555 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -559,6 +559,15 @@ void unregister_tracer(struct tracer *type)
 
  found:
 	*t = (*t)->next;
+
+	if (type == current_trace && tracer_enabled) {
+		tracer_enabled = 0;
+		tracing_stop();
+		if (current_trace->stop)
+			current_trace->stop(&global_trace);
+		current_trace = &nop_trace;
+	}
+
 	if (strlen(type->name) != max_tracer_type_len)
 		goto out;
 
-- 
1.6.0.6

