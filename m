Return-Path: <linux-kernel-owner+w=401wt.eu-S1755740AbYHZDZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbYHZDZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 23:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbYHZDZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 23:25:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40387 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbYHZDZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 23:25:27 -0400
Date: Mon, 25 Aug 2008 23:25:25 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftrace: only warn once on old objcopy and local functions
In-Reply-To: <20080826115113.806cfe23.sfr@canb.auug.org.au>
Message-ID: <alpine.DEB.1.10.0808252324050.966@gandalf.stny.rr.com>
References: <20080825130117.33fe34bc.sfr@canb.auug.org.au> <20080825060934.GB14993@elte.hu> <alpine.DEB.1.10.0808251434000.23923@gandalf.stny.rr.com> <20080825190103.GA24029@elte.hu> <20080826094627.5d627b5b.sfr@canb.auug.org.au>
 <20080826115113.806cfe23.sfr@canb.auug.org.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[
  Stephen, can you try to see if this works for you, with the
  issue of spamming warnings?

  Thanks,

  -- Steve
]

Older versions of objcopy do not support the --globalize-symbols
option, which prevent mcount calls in local functions within
their own sections from being reference by the mcount_loc table.

We want to warn the user about this out of date objcopy without spamming
them with warning messages. To do this, we create a .tmp_mcversion and
compare it with the .version to see if we have already warned the
user for that build.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 Makefile                |    3 +-
 scripts/recordmcount.pl |   69 +++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 65 insertions(+), 7 deletions(-)

Index: linux-tip.git/Makefile
===================================================================
--- linux-tip.git.orig/Makefile	2008-08-25 14:01:57.000000000 -0400
+++ linux-tip.git/Makefile	2008-08-25 23:17:57.000000000 -0400
@@ -1155,7 +1155,8 @@ endif # CONFIG_MODULES
 # Directories & files removed with 'make clean'
 CLEAN_DIRS  += $(MODVERDIR)
 CLEAN_FILES +=	vmlinux System.map \
-                .tmp_kallsyms* .tmp_version .tmp_vmlinux* .tmp_System.map
+                .tmp_kallsyms* .tmp_version .tmp_vmlinux* .tmp_System.map \
+		.tmp_mcversion
 
 # Directories & files removed with 'make mrproper'
 MRPROPER_DIRS  += include/config include2 usr/include
Index: linux-tip.git/scripts/recordmcount.pl
===================================================================
--- linux-tip.git.orig/scripts/recordmcount.pl	2008-08-25 16:23:29.000000000 -0400
+++ linux-tip.git/scripts/recordmcount.pl	2008-08-25 23:19:52.000000000 -0400
@@ -96,6 +96,8 @@
 use strict;
 
 my $P = $0;
+my $D = $P;
+$D =~ s@(.*)/.*@$1@;
 $P =~ s@.*/@@g;
 
 my $V = '0.1';
@@ -235,6 +237,66 @@ my $ref_func;		# reference function to u
 my $offset = 0;		# offset of ref_func to section beginning
 
 ##
+# warn_on_local - check to see if this make already had a warning
+#
+# We want to warn to the user if the objcopy is out of date
+# for referencing local functions, but we do not want to
+# spam the build with errors. We create a file ".tmp_mcversion"
+# and compare it to the .version file to see if we have already
+# warned the user in this compile or not.
+sub warn_on_local
+{
+    if ($local_warn_once) {
+	return;
+    }
+
+    $local_warn_once++;
+
+    # Check to see if we already warned on this build.
+    my $topdir = $D . "/..";
+    open(VER, "$topdir/.version") || return;
+    my $ver_num = -1;
+    while (<VER>) {
+	if (/(\d+)/) {
+	    $ver_num = $1;
+	    last;
+	}
+    }
+    close (VER);
+
+    my $last_ver = $topdir . "/.tmp_mcversion";
+    if (open(VER, $last_ver)) {
+	my $this_num = -2;
+	# see if the versions match
+	while (<VER>) {
+	    if (/(\d+)/) {
+		$this_num = $1;
+	    }
+	}
+	close (VER);
+
+	if ($ver_num == $this_num) {
+	    return;
+	}
+    }
+
+    # Either the file does not exist, or the versions do
+    # not match. Write the version we read, and warn about
+    # the message.
+
+    open (VER, ">$last_ver") || return;
+    print VER $ver_num . "\n";
+    close (VER);
+
+    print STDERR
+	"$inputfile: WARNING: referencing local function " .
+	"$ref_func for mcount\n" .
+	"\tConsider upgrading objcopy to support the globalize-" .
+	"symbols option.\n" .
+	"\tDisabling local function references.\n";
+}
+
+##
 # update_funcs - print out the current mcount callers
 #
 #  Go through the list of offsets to callers and write them to
@@ -262,12 +324,7 @@ sub update_funcs
 
 	# only use locals if objcopy supports globalize-symbols
 	if (!$use_locals) {
-	    print STDERR
-		"$inputfile: WARNING: referencing local function " .
-		"$ref_func for mcount\n" .
-		"\tConsider upgrading objcopy to support the globalize-" .
-		"symbols option.\n"
-		if (!$local_warn_once++);
+	    warn_on_local();
 	    return;
 	}
 	$convert{$ref_func} = 1;


