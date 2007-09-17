Return-Path: <linux-kernel-owner+w=401wt.eu-S1757031AbXIQTdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031AbXIQTdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 15:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757451AbXIQTcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 15:32:55 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:38791 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757323AbXIQTcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 15:32:54 -0400
Date: Mon, 17 Sep 2007 15:32:49 -0400
From: Mike Day <ncmike@ncultra.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] emacs compile window support for checkpatch version .10
Message-ID: <20070917193249.GA9738@silverwood.ncultra.org>
Reply-To: ncmike@ncultra.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
X-PGP-Key: http://www.ncultra.org/ncmike/pubkey.asc
X-PGP-Fingerprint: A2EE D0E6 21B7 0DEC 29B5  D5FD 3B27 3154 452B 7C21
x-gpg-key: http://www.ncultra.org/ncmike/pubkey.asc
x-gpg-fingerprint: A2EE D0E6 21B7 0DEC 29B5  D5FD 3B27 3154 452B 7C21
Organization: Ultra Adventures http://www.ncultra.org
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support to checkpatch.pl for running in the emacs compile window.
This allows emacs users to jump from the error in the compile window
directly to the offending line in the patch.

Use a script like the following to run in emacs:

(defun checkpatch()
  (interactive)
  (compile (concat "checkpatch.pl --emacs " (buffer-file-name))))

Signed-off-by: Mike D. Day <ncmike@ncultra.org>

--- checkpatch.pl-0.10	2007-09-17 15:24:21.000000000 -0400
+++ checkpatch.emacs.pl	2007-09-17 14:48:38.000000000 -0400
@@ -18,12 +18,16 @@
 my $chk_signoff = 1;
 my $chk_patch = 1;
 my $tst_type = 0;
+my $emacs = 0;
+my $linenr = 0;
+
 GetOptions(
 	'q|quiet'	=> \$quiet,
 	'tree!'		=> \$tree,
 	'signoff!'	=> \$chk_signoff,
 	'patch!'	=> \$chk_patch,
 	'test-type!'	=> \$tst_type,
+    'emacs!'    => \$emacs,
 ) or exit;
 
 my $exit = 0;
@@ -33,6 +37,7 @@
 	print "version: $V\n";
 	print "options: -q           => quiet\n";
 	print "         --no-tree    => run without a kernel tree\n";
+	print "         --emacs      => emacs compile window format\n";
 	exit(1);
 }
 
@@ -306,15 +311,27 @@
 	@report;
 }
 sub ERROR {
+  if ($emacs) {
+	report("$ARGV:$linenr: ERROR: $_[0]\n");
+  } else {
 	report("ERROR: $_[0]\n");
-	our $clean = 0;
+  }
+  our $clean = 0;
 }
 sub WARN {
+  if ($emacs) {
+	report("$ARGV:$linenr: WARNING: $_[0]\n");
+  } else {
 	report("WARNING: $_[0]\n");
+  }
 	our $clean = 0;
 }
 sub CHK {
+  if ($emacs) {
+  	report("$ARGV:$linenr: CHECK: $_[0]\n");
+  } else {
 	report("CHECK: $_[0]\n");
+  }
 	our $clean = 0;
 }
 
@@ -322,7 +339,6 @@
 	my $filename = shift;
 	my @lines = @_;
 
-	my $linenr=0;
 	my $prevline="";
 	my $stashline="";
 

-- 
Mike Day
http://www.ncultra.org
AIM: ncmikeday |  Yahoo IM: ultra.runner
PGP key: http://www.ncultra.org/ncmike/pubkey.asc
