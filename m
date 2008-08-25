Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbYHYSwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbYHYSwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 14:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbYHYSwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 14:52:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58183 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbYHYSwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 14:52:14 -0400
X-Greylist: delayed 7789 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Aug 2008 14:52:14 EDT
Date: Mon, 25 Aug 2008 14:52:11 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftrace: objcopy version test for local symbols
In-Reply-To: <20080825060934.GB14993@elte.hu>
Message-ID: <alpine.DEB.1.10.0808251434000.23923@gandalf.stny.rr.com>
References: <20080825130117.33fe34bc.sfr@canb.auug.org.au> <20080825060934.GB14993@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>
Subject: ftrace: objcopy version test for local symbols

The --globalize-symbols option came out in objcopy version 2.17.
If the kernel is being compiled on a system with a lower version of
objcopy, then we can not use the globalize / localize trick to
link to symbols pointing to local functions.

This patch tests the version of objcopy and will only use the trick
if the version is greater than or equal to 2.17. Otherwise, if an
object has only local functions within a section, it will give a
nice warning and recommend the user to upgrade their objcopy.

Leaving the symbols unrecorded is not that big of a deal, since the
mcount record method changes the actual mcount code to be a simple
"ret" without recording registers or anything.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 scripts/recordmcount.pl |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

Index: linux-tip.git/scripts/recordmcount.pl
===================================================================
--- linux-tip.git.orig/scripts/recordmcount.pl	2008-08-25 14:02:03.000000000 -0400
+++ linux-tip.git/scripts/recordmcount.pl	2008-08-25 14:38:36.000000000 -0400
@@ -187,6 +187,36 @@ my $mcount_s = $dirname . "/.tmp_mc_" . 
 my $mcount_o = $dirname . "/.tmp_mc_" . $prefix . ".o";
 
 #
+# --globalize-symbols came out in 2.17, we must test the version
+# of objcopy, and if it is less than 2.17, then we can not
+# record local functions.
+my $use_locals = 01;
+my $local_warn_once = 0;
+my $found_version = 0;
+
+open (IN, "$objcopy --version |") || die "error running $objcopy";
+while (<IN>) {
+    if (/objcopy.*\s(\d+)\.(\d+)/) {
+	my $major = $1;
+	my $minor = $2;
+
+	$found_version = 1;
+	if ($major < 2 ||
+	    ($major == 2 && $minor < 17)) {
+	    $use_locals = 0;
+	}
+	last;
+    }
+}
+close (IN);
+
+if (!$found_version) {
+    print STDERR "WARNING: could not find objcopy version.\n" .
+	"\tDisabling local function references.\n";
+}
+
+
+#
 # Step 1: find all the local (static functions) and weak symbols.
 #        't' is local, 'w/W' is weak (we never use a weak function)
 #
@@ -229,6 +259,17 @@ sub update_funcs
 
     # is this function static? If so, note this fact.
     if (defined $locals{$ref_func}) {
+
+	# only use locals if objcopy supports globalize-symbols
+	if (!$use_locals) {
+	    print STDERR
+		"$inputfile: WARNING: referencing local function " .
+		"$ref_func for mcount\n" .
+		"\tConsider upgrading objcopy to support the globalize-" .
+		"symbols option.\n"
+		if (!$local_warn_once++);
+	    return;
+	}
 	$convert{$ref_func} = 1;
     }
 
