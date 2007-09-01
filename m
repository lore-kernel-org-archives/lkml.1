Return-Path: <linux-kernel-owner+w=401wt.eu-S1752421AbXIAECe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbXIAECe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 00:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750835AbXIAECY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 00:02:24 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:17052 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbXIAECX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 00:02:23 -0400
Date: Fri, 31 Aug 2007 20:58:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: johannes@sipsolutions.net, akpm <akpm@linux-foundation.org>
Subject: [PATCH/RFC] kernel-doc: fix doc blocks and html
Message-Id: <20070831205845.0a935dc5.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Cc: johannes@sipsolutions.net

Johannes Berg reports (Thanks!) that &struct names are not highlighted in
html output format when they are inside a DOC: block.

DOC: blocks were not escaped thru xml_escape() like other kernel-doc
comments were.  Fixed that.

However, that left a problem with <p> ($blankline_html) being processed
thru xml_escape(), converting it to &lt;p&gt;, which isn't good for the
generated html output (the <p> should remain unchanged), so this patch
also introduces the notion of "local" kernel-doc meta-characters
('\\\\mnemonic:'), which are converted to html just before writing the
stream to its output file.


Please report any problems that you (anyone) see in "highlighting"
in any output mode (text, man, html, xml).

Also update copyright to include me.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |   41 ++++++++++++++++++++++++++++++++---------
 1 file changed, 32 insertions(+), 9 deletions(-)

--- linux-2.6.23-rc4.orig/scripts/kernel-doc
+++ linux-2.6.23-rc4/scripts/kernel-doc
@@ -5,6 +5,7 @@ use strict;
 ## Copyright (c) 1998 Michael Zucchi, All Rights Reserved        ##
 ## Copyright (C) 2000, 1  Tim Waugh <twaugh@redhat.com>          ##
 ## Copyright (C) 2001  Simon Huggins                             ##
+## Copyright (C) 2005-2007  Randy Dunlap                         ##
 ## 								 ##
 ## #define enhancements by Armin Kuster <akuster@mvista.com>	 ##
 ## Copyright (c) 2000 MontaVista Software, Inc.			 ##
@@ -161,7 +162,7 @@ my $type_constant = '\%([-_\w]+)';
 my $type_func = '(\w+)\(\)';
 my $type_param = '\@(\w+)';
 my $type_struct = '\&((struct\s*)*[_\w]+)';
-my $type_struct_xml = '\\\amp;((struct\s*)*[_\w]+)';
+my $type_struct_xml = '\\&amp;((struct\s*)*[_\w]+)';
 my $type_env = '(\$\w+)';
 
 # Output conversion substitutions.
@@ -173,7 +174,9 @@ my %highlights_html = ( $type_constant, 
 			$type_struct_xml, "<i>\$1</i>",
 			$type_env, "<b><i>\$1</i></b>",
 			$type_param, "<tt><b>\$1</b></tt>" );
-my $blankline_html = "<p>";
+my $local_lt = "\\\\\\\\lt:";
+my $local_gt = "\\\\\\\\gt:";
+my $blankline_html = $local_lt . "p" . $local_gt;	# was "<p>"
 
 # XML, docbook format
 my %highlights_xml = ( "([^=])\\\"([^\\\"<]+)\\\"", "\$1<quote>\$2</quote>",
@@ -391,17 +394,19 @@ sub output_highlight {
 #	confess "output_highlight got called with no args?\n";
 #   }
 
+    if ($output_mode eq "html") {
+	$contents = local_unescape($contents);
+	# convert data read & converted thru xml_escape() into &xyz; format:
+	$contents =~ s/\\\\\\/&/g;
+    }
 #   print STDERR "contents b4:$contents\n";
     eval $dohighlight;
     die $@ if $@;
-    if ($output_mode eq "html") {
-	$contents =~ s/\\\\//;
-    }
 #   print STDERR "contents af:$contents\n";
 
     foreach $line (split "\n", $contents) {
 	if ($line eq ""){
-	    print $lineprefix, $blankline;
+	    print $lineprefix, local_unescape($blankline);
 	} else {
 	    $line =~ s/\\\\\\/\&/g;
 	    if ($output_mode eq "man" && substr($line, 0, 1) eq ".") {
@@ -1752,7 +1757,13 @@ sub process_state3_type($$) {
     }
 }
 
-# replace <, >, and &
+# xml_escape: replace <, >, and & in the text stream;
+#
+# however, formatting controls that are generated internally/locally in the
+# kernel-doc script are not escaped here; instead, they begin life like
+# $blankline_html (4 of '\' followed by a mnemonic + ':'), then these strings
+# are converted to their mnemonic-expected output, without the 4 * '\' & ':',
+# just before actual output; (this is done by local_unescape())
 sub xml_escape($) {
 	my $text = shift;
 	if (($output_mode eq "text") || ($output_mode eq "man")) {
@@ -1764,6 +1775,18 @@ sub xml_escape($) {
 	return $text;
 }
 
+# convert local escape strings to html
+# local escape strings look like:  '\\\\menmonic:' (that's 4 backslashes)
+sub local_unescape($) {
+	my $text = shift;
+	if (($output_mode eq "text") || ($output_mode eq "man")) {
+		return $text;
+	}
+	$text =~ s/\\\\\\\\lt:/</g;
+	$text =~ s/\\\\\\\\gt:/>/g;
+	return $text;
+}
+
 sub process_file($) {
     my $file;
     my $identifier;
@@ -1903,7 +1926,7 @@ sub process_file($) {
 	} elsif ($state == 4) {
 		# Documentation block
 		if (/$doc_block/) {
-			dump_section($section, $contents);
+			dump_section($section, xml_escape($contents));
 			output_intro({'sectionlist' => \@sectionlist,
 				      'sections' => \%sections });
 			$contents = "";
@@ -1923,7 +1946,7 @@ sub process_file($) {
 		}
 		elsif (/$doc_end/)
 		{
-			dump_section($section, $contents);
+			dump_section($section, xml_escape($contents));
 			output_intro({'sectionlist' => \@sectionlist,
 				      'sections' => \%sections });
 			$contents = "";
