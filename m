Return-Path: <linux-kernel-owner+w=401wt.eu-S1030241AbXDKWDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030241AbXDKWDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 18:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030308AbXDKWDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:03:37 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:25458 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030241AbXDKWDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:03:36 -0400
Date: Wed, 11 Apr 2007 15:04:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, johannes@sipsolutions.net,
       bbpetkov@yahoo.de
Subject: [PATCH] kernel-doc: html mode struct highlights
Message-Id: <20070411150444.ad75c41a.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Johannes Berg reported that struct names are not highlighted
(bold, italic, etc.) in html kernel-doc output.  (Also not in
text-mode output, but I don't see that changing.)

This patch adds the following:
- highlight struct names in html output mode
- highlight environment var. names in html output mode
- indent struct fields in the original struct layout

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- linux-2621-rc6.orig/scripts/kernel-doc
+++ linux-2621-rc6/scripts/kernel-doc
@@ -159,7 +159,8 @@ my $warnings = 0;
 my $type_constant = '\%([-_\w]+)';
 my $type_func = '(\w+)\(\)';
 my $type_param = '\@(\w+)';
-my $type_struct = '\&((struct\s*)?[_\w]+)';
+my $type_struct = '\&((struct\s*)*[_\w]+)';
+my $type_struct_xml = '\\\amp;((struct\s*)*[_\w]+)';
 my $type_env = '(\$\w+)';
 
 # Output conversion substitutions.
@@ -168,7 +169,8 @@ my $type_env = '(\$\w+)';
 # these work fairly well
 my %highlights_html = ( $type_constant, "<i>\$1</i>",
 			$type_func, "<b>\$1</b>",
-			$type_struct, "<i>\$1</i>",
+			$type_struct_xml, "<i>\$1</i>",
+			$type_env, "<b><i>\$1</i></b>",
 			$type_param, "<tt><b>\$1</b></tt>" );
 my $blankline_html = "<p>";
 
@@ -331,7 +333,7 @@ while ($ARGV[0] =~ m/^-(.*)/) {
 # using the s// operator.
 my $dohighlight = "";
 foreach my $pattern (keys %highlights) {
-#    print "scanning pattern $pattern ($highlights{$pattern})\n";
+#   print STDERR "scanning pattern:$pattern, highlight:($highlights{$pattern})\n";
     $dohighlight .=  "\$contents =~ s:$pattern:$highlights{$pattern}:gs;\n";
 }
 
@@ -378,8 +380,14 @@ sub output_highlight {
 #	confess "output_highlight got called with no args?\n";
 #   }
 
+#   print STDERR "contents b4:$contents\n";
     eval $dohighlight;
     die $@ if $@;
+    if ($output_mode eq "html") {
+	$contents =~ s/\\\\//;
+    }
+#   print STDERR "contents af:$contents\n";
+
     foreach $line (split "\n", $contents) {
       if ($line eq ""){
 	    print $lineprefix, $blankline;
@@ -466,11 +474,12 @@ sub output_struct_html(%) {
 	$type = $args{'parametertypes'}{$parameter};
 	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
 	    # pointer-to-function
-	    print " <i>$1</i><b>$parameter</b>) <i>($2)</i>;<br>\n";
+	    print "&nbsp; &nbsp; <i>$1</i><b>$parameter</b>) <i>($2)</i>;<br>\n";
 	} elsif ($type =~ m/^(.*?)\s*(:.*)/) {
-	    print " <i>$1</i> <b>$parameter</b>$2;<br>\n";
+	    # bitfield
+	    print "&nbsp; &nbsp; <i>$1</i> <b>$parameter</b>$2;<br>\n";
 	} else {
-	    print " <i>$type</i> <b>$parameter</b>;<br>\n";
+	    print "&nbsp; &nbsp; <i>$type</i> <b>$parameter</b>;<br>\n";
 	}
     }
     print "};<br>\n";
