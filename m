Return-Path: <linux-kernel-owner+w=401wt.eu-S1762465AbZEAN3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762465AbZEAN3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 09:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761819AbZEAN3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 09:29:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:58525 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761888AbZEAN26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 09:28:58 -0400
Date: Fri, 1 May 2009 13:28:20 GMT
From: tip-bot for Jason Baron <jbaron@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbaron@redhat.com, tglx@linutronix.de, randy.dunlap@oracle.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, jbaron@redhat.com, randy.dunlap@oracle.com,
       mingo@elte.hu
In-Reply-To: <d80706b6797e277924d2f3ec9af176c6b2951f88.1241107197.git.jbaron@redhat.com>
References: <d80706b6797e277924d2f3ec9af176c6b2951f88.1241107197.git.jbaron@redhat.com>
Subject: [tip:tracing/core] kerneldoc, tracing: make kernel-doc understand TRACE_EVENT() macro (take #2)
Message-ID: <tip-56afb0f8823650f53a5f0e96d69a282e8892c61b@git.kernel.org>
Git-Commit-ID: 56afb0f8823650f53a5f0e96d69a282e8892c61b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 01 May 2009 13:28:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  56afb0f8823650f53a5f0e96d69a282e8892c61b
Gitweb:     http://git.kernel.org/tip/56afb0f8823650f53a5f0e96d69a282e8892c61b
Author:     Jason Baron <jbaron@redhat.com>
AuthorDate: Thu, 30 Apr 2009 13:29:36 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 1 May 2009 14:03:35 +0200

kerneldoc, tracing: make kernel-doc understand TRACE_EVENT() macro (take #2)

Add support to kernel-doc for tracepoint comments above TRACE_EVENT()
macro definitions. Paves the way for tracepoint docbook.

[ Impact: extend DocBook infrastructure ]

Signed-off-by: Jason Baron <jbaron@redhat.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org
Cc: rostedt@goodmis.org
Cc: fweisbec@gmail.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: wcohen@redhat.com
LKML-Reference: <d80706b6797e277924d2f3ec9af176c6b2951f88.1241107197.git.jbaron@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
