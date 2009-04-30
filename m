Return-Path: <linux-kernel-owner+w=401wt.eu-S934191AbZD3Rzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934191AbZD3Rzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933063AbZD3Rb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:31:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49312 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933049AbZD3RbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:31:25 -0400
Date: Thu, 30 Apr 2009 13:29:36 -0400
Message-Id: <d80706b6797e277924d2f3ec9af176c6b2951f88.1241107197.git.jbaron@redhat.com>
In-Reply-To: <cover.1241107197.git.jbaron@redhat.com>
References: <cover.1241107197.git.jbaron@redhat.com>
From: Jason Baron <jbaron@redhat.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rostedt@goodmis.org, fweisbec@gmail.com, mathieu.desnoyers@polymtl.ca,
       randy.dunlap@oracle.com, wcohen@redhat.com
Subject: [PATCH 1/3] make kernel-doc understand TRACE_EVENT() macro (take #2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to kernel-doc for tracepoint comments above TRACE_EVENT()
macro definitions. Paves the way for tracepoint docbook.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

---
 scripts/kernel-doc |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 0f11870..2b53a55 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1827,6 +1827,25 @@ sub reset_state {
     $state = 0;
 }
 
+sub tracepoint_munge($) {
+	my $file = shift;
+	my $tracepointname = 0;
+	my $tracepointargs = 0;
+
+	if($prototype =~ m/TRACE_EVENT\((.*?),/) {
+		$tracepointname = $1;
+	}
+	if($prototype =~ m/TP_PROTO\((.*?)\)/) {
+		$tracepointargs = $1;
+	}
+	if (($tracepointname eq 0) || ($tracepointargs eq 0)) {
+		print STDERR "Warning(${file}:$.): Unrecognized tracepoint format: \n".
+			     "$prototype\n";
+	} else {
+		$prototype = "static inline void trace_$tracepointname($tracepointargs)";
+	}
+}
+
 sub syscall_munge() {
 	my $void = 0;
 
@@ -1881,6 +1900,9 @@ sub process_state3_function($$) {
 	if ($prototype =~ /SYSCALL_DEFINE/) {
 		syscall_munge();
 	}
+	if ($prototype =~ /TRACE_EVENT/) {
+		tracepoint_munge($file);
+	}
 	dump_function($prototype, $file);
 	reset_state();
     }
-- 
1.6.0.6

