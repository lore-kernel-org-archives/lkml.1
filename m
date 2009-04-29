Return-Path: <linux-kernel-owner+w=401wt.eu-S1760164AbZD2Rsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164AbZD2Rsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 13:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758226AbZD2RsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 13:48:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35593 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090AbZD2RsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 13:48:14 -0400
Date: Wed, 29 Apr 2009 13:45:25 -0400
Message-Id: <200904291745.n3THjPhO019531@ns3.rdu.redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, rostedt@goodmis.org,
       fweisbec@gmail.com, mathieu.desnoyers@polymtl.ca,
       randy.dunlap@oracle.com, wcohen@redhat.com
From: Jason Baron <jbaron@redhat.com>
Subject: [PATCH 1/3] make kernel-doc understand TRACE_EVENT() macro
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add support to kernel-doc for tracepoint comments above TRACE_EVENT()
macro definitions. Paves the way for tracepoint docbook.


Signed-off-by: Jason Baron <jbaron@redhat.com>

---
 scripts/kernel-doc |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 0f11870..9d9ab4b 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1827,6 +1827,24 @@ sub reset_state {
     $state = 0;
 }
 
+sub tracepoint_munge() {
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
+		print STDERR "Warning: Unrecognized tracepoint format: \n" .
+			     "$prototype\n"
+	} else {
+		$prototype = "static inline void trace_$tracepointname($tracepointargs)";
+	}
+}
+
 sub syscall_munge() {
 	my $void = 0;
 
@@ -1881,6 +1899,9 @@ sub process_state3_function($$) {
 	if ($prototype =~ /SYSCALL_DEFINE/) {
 		syscall_munge();
 	}
+	if ($prototype =~ /TRACE_EVENT/) {
+		tracepoint_munge();
+	}
 	dump_function($prototype, $file);
 	reset_state();
     }
-- 
1.5.4.5

