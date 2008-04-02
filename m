Return-Path: <linux-kernel-owner+w=401wt.eu-S932375AbYDBV4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375AbYDBV4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757434AbYDBVzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:55:43 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:37302 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762826AbYDBVzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:55:42 -0400
Date: Wed, 2 Apr 2008 14:55:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] kernel-doc: detect/prevent duplicate doc section names
Message-Id: <20080402145512.c2fea887.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

I saw this problem recently.  With this kernel-doc:

 * Note: some important info
 *
 * Note: other important info

kernel-doc uses the "section name" (preceding the ':', like "Note") as a hash
key for storing the descriptive text ("blah important info").  It is (was)
possible to have duplicate (colliding) section names, without any kind of
warning or error.

kernel-doc happily used the latter descriptive text for all instances of
printing the <section-name> descriptive text and the former important info
was lost.

One way to "fix" this is to modify the kernel-doc comments, e.g.:

 * Note1: foo bar
 *
 * Note.2: blah zay

For now, kernel-doc will signal an error when it sees colliding section names
like this.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- lin2625-rc8-kdoc.orig/scripts/kernel-doc
+++ lin2625-rc8-kdoc/scripts/kernel-doc
@@ -5,7 +5,7 @@ use strict;
 ## Copyright (c) 1998 Michael Zucchi, All Rights Reserved        ##
 ## Copyright (C) 2000, 1  Tim Waugh <twaugh@redhat.com>          ##
 ## Copyright (C) 2001  Simon Huggins                             ##
-## Copyright (C) 2005-2007  Randy Dunlap                         ##
+## Copyright (C) 2005-2008  Randy Dunlap                         ##
 ## 								 ##
 ## #define enhancements by Armin Kuster <akuster@mvista.com>	 ##
 ## Copyright (c) 2000 MontaVista Software, Inc.			 ##
@@ -366,6 +366,7 @@ foreach my $pattern (keys %highlights) {
 # dumps section contents to arrays/hashes intended for that purpose.
 #
 sub dump_section {
+    my $file = shift;
     my $name = shift;
     my $contents = join "\n", @_;
 
@@ -379,6 +380,10 @@ sub dump_section {
 	$parameterdescs{$name} = $contents;
     } else {
 #	print STDERR "other section '$name' = '$contents'\n";
+	if (defined($sections{$name}) && ($sections{$name} ne "")) {
+		print STDERR "Error(${file}:$.): duplicate section name '$name'\n";
+		++$errors;
+	}
 	$sections{$name} = $contents;
 	push @sectionlist, $name;
     }
@@ -388,6 +393,7 @@ sub dump_section {
 # dump DOC: section after checking that it should go out
 #
 sub dump_doc_section {
+    my $file = shift;
     my $name = shift;
     my $contents = join "\n", @_;
 
@@ -399,7 +405,7 @@ sub dump_doc_section {
 	( $function_only == 1 && defined($function_table{$name})) ||
 	( $function_only == 2 && !defined($function_table{$name})))
     {
-	dump_section $name, $contents;
+	dump_section($file, $name, $contents);
 	output_blockhead({'sectionlist' => \@sectionlist,
 			  'sections' => \%sections,
 			  'module' => $modulename,
@@ -1923,7 +1929,7 @@ sub process_file($) {
 			print STDERR "Warning(${file}:$.): contents before sections\n";
 			++$warnings;
 		    }
-		    dump_section($section, xml_escape($contents));
+		    dump_section($file, $section, xml_escape($contents));
 		    $section = $section_default;
 		}
 
@@ -1940,7 +1946,7 @@ sub process_file($) {
 	    } elsif (/$doc_end/) {
 
 		if ($contents ne "") {
-		    dump_section($section, xml_escape($contents));
+		    dump_section($file, $section, xml_escape($contents));
 		    $section = $section_default;
 		    $contents = "";
 		}
@@ -1954,7 +1960,7 @@ sub process_file($) {
 		# @parameter line to signify start of description
 		if ($1 eq "" &&
 			($section =~ m/^@/ || $section eq $section_context)) {
-		    dump_section($section, xml_escape($contents));
+		    dump_section($file, $section, xml_escape($contents));
 		    $section = $section_default;
 		    $contents = "";
 		} else {
@@ -1974,7 +1980,7 @@ sub process_file($) {
 	} elsif ($state == 4) {
 		# Documentation block
 		if (/$doc_block/) {
-			dump_doc_section($section, xml_escape($contents));
+			dump_doc_section($file, $section, xml_escape($contents));
 			$contents = "";
 			$function = "";
 			%constants = ();
@@ -1992,7 +1998,7 @@ sub process_file($) {
 		}
 		elsif (/$doc_end/)
 		{
-			dump_doc_section($section, xml_escape($contents));
+			dump_doc_section($file, $section, xml_escape($contents));
 			$contents = "";
 			$function = "";
 			%constants = ();
