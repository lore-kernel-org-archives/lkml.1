Return-Path: <linux-kernel-owner+w=401wt.eu-S1763391AbZFPXFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763391AbZFPXFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 19:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757731AbZFPXFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 19:05:09 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:58921 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbZFPXFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 19:05:08 -0400
Date: Wed, 17 Jun 2009 04:35:04 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: =?iso-8859-1?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [Patch 1/2] ksym_tracer:Fix line-wrapping after removal of ksym
	tracer entry
Message-ID: <20090616230504.GB14753@in.ibm.com>
References: <20090616225257.041883212@prasadkr_t60p.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=ksym_tracer_upstream_01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removal of a ksym entry results in missing information and an early return with
TRACE_TYPE_PARTIAL_LINE code (minus the line return). This patch modifies the
output function to unconditionally add a line return irrespective of the
return code. 

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 kernel/trace/trace_ksym.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

Index: linux-2.6-tip.hbkpt/kernel/trace/trace_ksym.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/kernel/trace/trace_ksym.c
+++ linux-2.6-tip.hbkpt/kernel/trace/trace_ksym.c
@@ -391,29 +391,32 @@ static enum print_line_t ksym_trace_outp
 
 	ret = trace_seq_printf(s, "%-15s %-5d %-3d %-20s ", field->p_name,
 				entry->pid, iter->cpu, field->ksym_name);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	if (!ret) {
+		ret = TRACE_TYPE_PARTIAL_LINE;
+		goto err_ret;
+	}
 
+	ret = TRACE_TYPE_PARTIAL_LINE;
 	switch (field->ksym_hbp->info.type) {
 	case HW_BREAKPOINT_WRITE:
-		ret = trace_seq_printf(s, " W  ");
+		if (!trace_seq_printf(s, " W  "))
+			goto err_ret;
 		break;
 	case HW_BREAKPOINT_RW:
-		ret = trace_seq_printf(s, " RW ");
+		if (!trace_seq_printf(s, " RW  "))
+			goto err_ret;
 		break;
 	default:
-		return TRACE_TYPE_PARTIAL_LINE;
+		goto err_ret;
 	}
 
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
 	sprint_symbol(str, field->ip);
 	ret = trace_seq_printf(s, "%-20s\n", str);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	return TRACE_TYPE_HANDLED;
+	if (ret)
+		return TRACE_TYPE_HANDLED;
+err_ret:
+	trace_seq_printf(s, "\n");
+	return ret;
 }
 
 struct tracer ksym_tracer __read_mostly =

