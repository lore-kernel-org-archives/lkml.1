Return-Path: <linux-kernel-owner+w=401wt.eu-S1763150AbZD3Oub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763150AbZD3Oub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 10:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763309AbZD3OuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 10:50:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47737 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763541AbZD3OuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 10:50:01 -0400
Date: Thu, 30 Apr 2009 10:48:31 -0400
From: Jason Baron <jbaron@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       rostedt@goodmis.org, fweisbec@gmail.com, mathieu.desnoyers@polymtl.ca,
       wcohen@redhat.com
Subject: Re: [PATCH 1/3] make kernel-doc understand TRACE_EVENT() macro
Message-ID: <20090430144831.GA3225@redhat.com>
References: <200904291745.n3THjPhO019531@ns3.rdu.redhat.com> <49F8A7D1.6010307@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F8A7D1.6010307@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 12:17:37PM -0700, Randy Dunlap wrote:
> I'd prefer for this warning to use the usual kernel-doc warning format, with
> file:line information:
> 
> 		print STDERR "Warning(${file}:$.): Unrecognized ....
> 
> Otherwise, looks good.  Thanks.
> 
> 

ok, updated patch:


Add support to kernel-doc script for tracepoint comments above 
TRACE_EVENT() macro definitions. Paves the way for tracepoint docbook.


Signed-off-by: Jason Baron <jbaron@redhat.com>

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
