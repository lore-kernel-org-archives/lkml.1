Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbZFCJFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbZFCJFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 05:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbZFCJFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 05:05:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42359 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbZFCJFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 05:05:30 -0400
Subject: trace: fix multiple use of __print_flags and __print_symbolic
From: Steven Whitehouse <swhiteho@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Wed, 03 Jun 2009 10:05:00 +0100
Message-Id: <1244019900.29604.588.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When using multiple calls to __print_symbolic and __print_flags in
the same tracer, I noticed that the output was incorrect. I think
the following patch is the correct fix (it works for me) but please
check it carefully since I'm not that familiar with this code,
and I may well have made a mistake somewhere.

The patch is vs. the latest -tip tree which doesn't yet seem to
contain the EXPORT_SYMBOL() fix that I sent earlier.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>


diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index c12d95d..ac6ced1 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -222,10 +222,9 @@ ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
 {
 	unsigned long mask;
 	const char *str;
+	const char *ret = p->buffer + p->len;
 	int i;
 
-	trace_seq_init(p);
-
 	for (i = 0;  flag_array[i].name && flags; i++) {
 
 		mask = flag_array[i].mask;
@@ -248,7 +247,7 @@ ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
 
 	trace_seq_putc(p, 0);
 
-	return p->buffer;
+	return ret;
 }
 
 const char *
@@ -256,8 +255,7 @@ ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
 			 const struct trace_print_flags *symbol_array)
 {
 	int i;
-
-	trace_seq_init(p);
+	const char *ret = p->buffer + p->len;
 
 	for (i = 0;  symbol_array[i].name; i++) {
 
@@ -273,7 +271,7 @@ ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
 		
 	trace_seq_putc(p, 0);
 
-	return p->buffer;
+	return ret;
 }
 
 #ifdef CONFIG_KRETPROBES


