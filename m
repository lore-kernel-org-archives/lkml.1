Return-Path: <linux-kernel-owner+w=401wt.eu-S1762087AbZAQEux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762087AbZAQEux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 23:50:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755790AbZAQEun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 23:50:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33756 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672AbZAQEum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 23:50:42 -0500
Date: Fri, 16 Jan 2009 23:50:39 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Eric Sesterhenn <snakebyte@gmx.de>,
       Eric Paris <eparis@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ftrace: test for running of recordmcount.pl twice on an
 object
Message-ID: <alpine.DEB.1.10.0901162347440.17050@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

The following patch is in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (1):
      ftrace: test for running of recordmcount.pl twice on an object

----
 scripts/recordmcount.pl |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)
---------------------------
commit 82ca9971f21accc30180f18c500f0615092adc7b
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Fri Jan 16 23:18:31 2009 -0500

    ftrace: test for running of recordmcount.pl twice on an object
    
    Impact: fix failure of dynamic function tracer selftest
    
    In a course of development, a developer does several makes on their
    kernel. Sometimes, the make might do something abnormal. In the
    case of running the recordmcount.pl script on an object twice,
    the script will duplicate all the calls to mcount in the __mcount_loc
    section.
    
    On boot up, the dynamic function tracer is careful when it modifies
    code, and performs several consistency checks. One is to not modify
    the call site if it is not what it expects it to be. If a function
    call site is listed twice, the first entry will convert the site
    to a nop, and the second will fail because it expected to see a
    call to mcount, but instead it sees a nop. Thus, the function tracer
    is disabled.
    
    Eric Sesterhenn reported seeing:
    
    [    1.055440] ftrace: converting mcount calls to 0f 1f 44 00 00
    [    1.055568] ftrace: allocating 29418 entries in 116 pages
    [    1.061000] ------------[ cut here ]------------
    [    1.061000] WARNING: at kernel/trace/ftrace.c:441
    
     [...]
    
    [    1.060000] ---[ end trace 4eaa2a86a8e2da23 ]---
    [    1.060000] ftrace failed to modify [<c0118072>] check_corruption+0x3/0x2d
    [    1.060000]  actual: 0f:1f:44:00:00
    
    This warning shows that check_corruption+0x3 already had a nop in
    its place (0x0f1f440000). After compiling another kernel the problem
    went away.
    
    Later Eric Paris notice the same type of issue. Luckily, he saved
    the vmlinux file that caused it. In the file we found a bunch of
    duplicate mcount call site records, which lead us to the script.
    
    Perhaps this problem only happens to people named Eric.
    
    This patch changes the script to test if the __mcount_loc already
    exists in the object file, and if it does, it will print out
    an error message and kill the compile.
    
    Reported-by: Eric Sesterhenn <snakebyte@gmx.de>
    Reported-by: Eric Paris <eparis@redhat.com>
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 2ded5c8..409596e 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -101,7 +101,7 @@ $P =~ s@.*/@@g;
 my $V = '0.1';
 
 if ($#ARGV < 7) {
-	print "usage: $P arch objdump objcopy cc ld nm rm mv is_module inputfile\n";
+	print "usage: $P arch bits objdump objcopy cc ld nm rm mv is_module inputfile\n";
 	print "version: $V\n";
 	exit(1);
 }
@@ -275,7 +275,6 @@ if (!$found_version) {
 	"\tDisabling local function references.\n";
 }
 
-
 #
 # Step 1: find all the local (static functions) and weak symbols.
 #        't' is local, 'w/W' is weak (we never use a weak function)
@@ -343,13 +342,16 @@ sub update_funcs
 #
 # Step 2: find the sections and mcount call sites
 #
-open(IN, "$objdump -dr $inputfile|") || die "error running $objdump";
+open(IN, "$objdump -hdr $inputfile|") || die "error running $objdump";
 
 my $text;
 
+my $read_headers = 1;
+
 while (<IN>) {
     # is it a section?
     if (/$section_regex/) {
+	$read_headers = 0;
 
 	# Only record text sections that we know are safe
 	if (defined($text_sections{$1})) {
@@ -383,6 +385,19 @@ while (<IN>) {
 		$ref_func = $text;
 	    }
 	}
+    } elsif ($read_headers && /$mcount_section/) {
+	#
+	# Somehow the make process can execute this script on an
+	# object twice. If it does, we would duplicate the mcount
+	# section and it will cause the function tracer self test
+	# to fail. Check if the mcount section exists, and if it does,
+	# warn and exit.
+	#
+	print STDERR "ERROR: $mcount_section already in $inputfile\n" .
+	    "\tThis may be an indication that your build is corrupted.\n" .
+	    "\tDelete $inputfile and try again. If the same object file\n" .
+	    "\tstill causes an issue, then disable CONFIG_DYNAMIC_FTRACE.\n";
+	exit(-1);
     }
 
     # is this a call site to mcount? If so, record it to print later

