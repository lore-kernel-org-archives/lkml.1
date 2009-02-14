Return-Path: <linux-kernel-owner+w=401wt.eu-S1765342AbZBNBbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765342AbZBNBbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:31:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760009AbZBNBQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:16:14 -0500
Received: from kroah.org ([198.145.64.141]:50232 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763315AbZBNBQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:16:07 -0500
Date: Fri, 13 Feb 2009 17:12:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Randy Dunlap <randy.dunlap@oracle.com>
Subject: [patch 09/48] kernel-doc: fix syscall wrapper processing
Message-ID: <20090214011237.GJ17706@kroah.com>
References: <20090214010805.419403436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kernel-doc-fix-syscall-wrapper-processing.patch"
In-Reply-To: <20090214011208.GA17706@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Randy Dunlap <randy.dunlap@oracle.com>

commit b4870bc5ee8c7a37541a3eb1208b5c76c13a078a upstream.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 scripts/kernel-doc |   40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1762,6 +1762,40 @@ sub reset_state {
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
@@ -1774,11 +1808,15 @@ sub process_state3_function($$) {
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

