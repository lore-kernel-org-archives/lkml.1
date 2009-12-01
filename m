Return-Path: <linux-kernel-owner+w=401wt.eu-S1753789AbZLARTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbZLARTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 12:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbZLARTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 12:19:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbZLARTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 12:19:18 -0500
Date: Tue, 1 Dec 2009 12:18:49 -0500
From: Jason Baron <jbaron@redhat.com>
Message-Id: <200912011718.nB1HIn7t011371@int-mx04.intmail.prod.int.phx2.redhat.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, mhiramat@redhat.com,
       wcohen@redhat.com, rostedt@goodmis.org, fweisbec@gmail.com,
       mathieu.desnoyers@polymtl.ca
Subject: [PATCH v2] tracing: add DEFINE_EVENT(), DEFINE_SINGLE_EVENT() support to docbook
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The introduction of the new 'DECLARE_EVENT_CLASS()' obviates the need for the
'TRACE_EVENT()' macro in some cases. Thus, docbook style comments that used
to live with 'TRACE_EVENT()' are now moved to 'DEFINE_EVENT()'. Thus, we need
to make the docbook system understand the new 'DEFINE_EVENT()' macro. In
addition I've tried to futureproof the patch, by also adding support for
'DEFINE_SINGLE_EVENT()', since there has been discussion about renaming:
TRACE_EVENT() -> DEFINE_SINGLE_EVENT().

Without this patch the tracepoint docbook fails to build.

I've verified that this patch correctly builds the tracepoint docbook which
currently covers signals, and irqs.

Changes in v2:
 - properly indent perl 'if' statements


Signed-off-by: Jason Baron <jbaron@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: William Cohen <wcohen@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
---
 scripts/kernel-doc |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index ea9f8a5..241310e 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1852,10 +1852,17 @@ sub tracepoint_munge($) {
 	my $tracepointname = 0;
 	my $tracepointargs = 0;
 
-	if($prototype =~ m/TRACE_EVENT\((.*?),/) {
+	if ($prototype =~ m/TRACE_EVENT\((.*?),/) {
 		$tracepointname = $1;
 	}
-	if($prototype =~ m/TP_PROTO\((.*?)\)/) {
+	if ($prototype =~ m/DEFINE_SINGLE_EVENT\((.*?),/) {
+		$tracepointname = $1;
+	}
+	if ($prototype =~ m/DEFINE_EVENT\((.*?),(.*?),/) {
+		$tracepointname = $2;
+	}
+	$tracepointname =~ s/^\s+//; #strip leading whitespace
+	if ($prototype =~ m/TP_PROTO\((.*?)\)/) {
 		$tracepointargs = $1;
 	}
 	if (($tracepointname eq 0) || ($tracepointargs eq 0)) {
@@ -1920,7 +1927,9 @@ sub process_state3_function($$) {
 	if ($prototype =~ /SYSCALL_DEFINE/) {
 		syscall_munge();
 	}
-	if ($prototype =~ /TRACE_EVENT/) {
+	if ($prototype =~ /TRACE_EVENT/ || $prototype =~ /DEFINE_EVENT/ ||
+	    $prototype =~ /DEFINE_SINGLE_EVENT/)
+	{
 		tracepoint_munge($file);
 	}
 	dump_function($prototype, $file);
-- 
1.6.5.1

