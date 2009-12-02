Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555AbZLBKnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbZLBKnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 05:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbZLBKnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 05:43:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:44867 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431AbZLBKni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 05:43:38 -0500
Date: Wed, 2 Dec 2009 10:42:48 GMT
From: tip-bot for Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       mingo@redhat.com, randy.dunlap@oracle.com, wcohen@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       jbaron@redhat.com, mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       wcohen@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, jbaron@redhat.com, mhiramat@redhat.com,
       mingo@elte.hu
In-Reply-To: <200912011718.nB1HIn7t011371@int-mx04.intmail.prod.int.phx2.redhat.com>
References: <200912011718.nB1HIn7t011371@int-mx04.intmail.prod.int.phx2.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Add DEFINE_EVENT(), DEFINE_SINGLE_EVENT() support to docbook
Message-ID: <tip-3a9089fd78367e2c6c815129030b790a0f5c2715@git.kernel.org>
Git-Commit-ID: 3a9089fd78367e2c6c815129030b790a0f5c2715
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3a9089fd78367e2c6c815129030b790a0f5c2715
Gitweb:     http://git.kernel.org/tip/3a9089fd78367e2c6c815129030b790a0f5c2715
Author:     Jason Baron <jbaron@redhat.com>
AuthorDate: Tue, 1 Dec 2009 12:18:49 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 2 Dec 2009 09:57:37 +0100

tracing: Add DEFINE_EVENT(), DEFINE_SINGLE_EVENT() support to docbook

The introduction of the new 'DECLARE_EVENT_CLASS()' obviates the
need for the 'TRACE_EVENT()' macro in some cases. Thus, docbook
style comments that used to live with 'TRACE_EVENT()' are now
moved to 'DEFINE_EVENT()'. Thus, we need to make the docbook
system understand the new 'DEFINE_EVENT()' macro. In addition
I've tried to futureproof the patch, by also adding support for
'DEFINE_SINGLE_EVENT()', since there has been discussion about
renaming: TRACE_EVENT() -> DEFINE_SINGLE_EVENT().

Without this patch the tracepoint docbook fails to build.

I've verified that this patch correctly builds the tracepoint
docbook which currently covers signals, and irqs.

Changes in v2:
 - properly indent perl 'if' statements

Signed-off-by: Jason Baron <jbaron@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: William Cohen <wcohen@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
LKML-Reference: <200912011718.nB1HIn7t011371@int-mx04.intmail.prod.int.phx2.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
