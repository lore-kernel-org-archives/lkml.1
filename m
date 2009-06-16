Return-Path: <linux-kernel-owner+w=401wt.eu-S1763871AbZFPXFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763871AbZFPXFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 19:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763515AbZFPXFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 19:05:32 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:59046 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763549AbZFPXFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 19:05:31 -0400
Date: Wed, 17 Jun 2009 04:35:27 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: =?iso-8859-1?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [Patch 2/2] ksym_tracer:Handle machine stall when cat trace_pipe
	for ksym tracer
Message-ID: <20090616230527.GC14753@in.ibm.com>
References: <20090616225257.041883212@prasadkr_t60p.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=fix_machine_stall_issue_02
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'trace_pipe' does not handle a TRACE_TYPE_PARTIAL_LINE well and causes the
machine to stall. While a TRACE_TYPE_UNHANDLED return causes the tracer to
output unrelated data, a TRACE_TYPE_HANDLED return presents a clean output
(minus all partial traces).

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 kernel/trace/trace_ksym.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6-tip.hbkpt/kernel/trace/trace_ksym.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/kernel/trace/trace_ksym.c
+++ linux-2.6-tip.hbkpt/kernel/trace/trace_ksym.c
@@ -389,6 +389,12 @@ static enum print_line_t ksym_trace_outp
 
 	trace_assign_type(field, entry);
 
+	/*
+	 * Return early without any output if we don't have sufficient
+	 * information
+	 */
+	if ((!field->ksym_hbp->info.type) || (!field->ip))
+		return TRACE_TYPE_HANDLED;
 	ret = trace_seq_printf(s, "%-15s %-5d %-3d %-20s ", field->p_name,
 				entry->pid, iter->cpu, field->ksym_name);
 	if (!ret) {

