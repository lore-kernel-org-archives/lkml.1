Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbZBFEYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbZBFEYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 23:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbZBFEYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 23:24:32 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:24305 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbZBFEYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 23:24:31 -0500
Date: Thu, 5 Feb 2009 20:24:25 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, samr <sam@ravnborg.org>
Subject: [PATCH] kernel-doc: fix syscall wrapper processing
Message-Id: <20090205202425.e3babd96.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.498BBB70.0114:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc processing of SYSCALL wrappers.

The SYSCALL wrapper patches played havoc with kernel-doc for
syscalls.  Syscalls that were scanned for DocBook processing
reported warnings like this one, for sys_tgkill:

Warning(kernel/signal.c:2285): No description found for parameter 'tgkill'
Warning(kernel/signal.c:2285): No description found for parameter 'pid_t'
Warning(kernel/signal.c:2285): No description found for parameter 'int'

because the macro parameters all "look like" function parameters,
although they are not:

/**
 *  sys_tgkill - send signal to one specific thread
 *  @tgid: the thread group ID of the thread
 *  @pid: the PID of the thread
 *  @sig: signal to be sent
 *
 *  This syscall also checks the @tgid and returns -ESRCH even if the PID
 *  exists but it's not belonging to the target process anymore. This
 *  method solves the problem of threads exiting and PIDs getting reused.
 */
SYSCALL_DEFINE3(tgkill, pid_t, tgid, pid_t, pid, int, sig)
{
...


This patch special-cases the handling SYSCALL_DEFINE* function
prototypes by expanding them to
	long sys_foobar(type1 arg1, type1 arg2, ...)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |   40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

--- linux-2.6.29-rc3-git7.orig/scripts/kernel-doc
+++ linux-2.6.29-rc3-git7/scripts/kernel-doc
@@ -1827,6 +1827,40 @@ sub reset_state {
     $state = 0;
 }
 
+sub syscall_munge() {
+	my $void = 0;
+
+	$prototype =~ s@[\r\n\t]+@ @gos; # strip newlines/CR's/tabs
+##	if ($prototype =~ m/SYSCALL_DEFINE0\s*\(\s*(a-zA-Z0-9_)*\s*\)/) {
+	if ($prototype =~ m/SYSCALL_DEFINE0/) {
+		$void = 1;
+##		$prototype = "long sys_$1(void)";
+	}
+
+	$prototype =~ s/SYSCALL_DEFINE.*\(/long sys_/; # fix return type & func name
+	if ($prototype =~ m/long (sys_.*?),/) {
+		$prototype =~ s/,/\(/;
+	} elsif ($void) {
+		$prototype =~ s/\)/\(void\)/;
+	}
+
+	# now delete all of the odd-number commas in $prototype
+	# so that arg types & arg names don't have a comma between them
+	my $count = 0;
+	my $len = length($prototype);
+	if ($void) {
+		$len = 0;	# skip the for-loop
+	}
+	for (my $ix = 0; $ix < $len; $ix++) {
+		if (substr($prototype, $ix, 1) eq ',') {
+			$count++;
+			if ($count % 2 == 1) {
+				substr($prototype, $ix, 1) = ' ';
+			}
+		}
+	}
+}
+
 sub process_state3_function($$) {
     my $x = shift;
     my $file = shift;
@@ -1839,11 +1873,15 @@ sub process_state3_function($$) {
     elsif ($x =~ /([^\{]*)/) {
 	$prototype .= $1;
     }
+
     if (($x =~ /\{/) || ($x =~ /\#\s*define/) || ($x =~ /;/)) {
 	$prototype =~ s@/\*.*?\*/@@gos;	# strip comments.
 	$prototype =~ s@[\r\n]+@ @gos; # strip newlines/cr's.
 	$prototype =~ s@^\s+@@gos; # strip leading spaces
-	dump_function($prototype,$file);
+	if ($prototype =~ /SYSCALL_DEFINE/) {
+		syscall_munge();
+	}
+	dump_function($prototype, $file);
 	reset_state();
     }
 }
