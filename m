Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbZIRC0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbZIRC0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 22:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbZIRC0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 22:26:04 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:56464 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbZIRC0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 22:26:02 -0400
Message-ID: <4AB2EFED.2050508@oracle.com>
Date: Thu, 17 Sep 2009 19:26:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 3/3] kernel-doc: allow multi-line declaration purpose descriptions
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt008.oracle.com [141.146.116.17]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4AB2EFB2.0014:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: kernel-doc: allow multi-line declaration purpose descriptions

Allow the short description after symbol name and dash in a kernel-doc
comment to span multiple lines, e.g. like this:

	/**
	 * unmap_mapping_range - unmap the portion of all mmaps in the
	 *	specified address_space corresponding to the specified
	 *	page range in the underlying file.
	 * @mapping: the address space containing mmaps to be unmapped.
	 * ...
	 */

The short description ends with a parameter description, an empty line
or the end of the comment block.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/kernel-doc-nano-HOWTO.txt |    4 +++-
 scripts/kernel-doc                      |   21 ++++++++++++++++-----
 2 files changed, 19 insertions(+), 6 deletions(-)

--- lnx-2631-rc7.orig/Documentation/kernel-doc-nano-HOWTO.txt
+++ lnx-2631-rc7/Documentation/kernel-doc-nano-HOWTO.txt
@@ -66,7 +66,9 @@ Example kernel-doc function comment:
  * The longer description can have multiple paragraphs.
  */
 
-The first line, with the short description, must be on a single line.
+The short description following the subject can span multiple lines
+and ends with an @argument description, an empty line or the end of
+the comment block.
 
 The @argument descriptions must begin on the very next line following
 this opening short function description line, with no intervening
--- lnx-2631-rc7.orig/scripts/kernel-doc
+++ lnx-2631-rc7/scripts/kernel-doc
@@ -1995,6 +1995,7 @@ sub process_file($) {
     my $identifier;
     my $func;
     my $descr;
+    my $in_purpose = 0;
     my $initial_section_counter = $section_counter;
 
     if (defined($ENV{'SRCTREE'})) {
@@ -2044,6 +2045,7 @@ sub process_file($) {
 		    $descr =~ s/\s*$//;
 		    $descr =~ s/\s+/ /;
 		    $declaration_purpose = xml_escape($descr);
+		    $in_purpose = 1;
 		} else {
 		    $declaration_purpose = "";
 		}
@@ -2090,6 +2092,7 @@ sub process_file($) {
 		}
 
 		$in_doc_sect = 1;
+		$in_purpose = 0;
 		$contents = $newcontents;
 		if ($contents ne "") {
 		    while ((substr($contents, 0, 1) eq " ") ||
@@ -2119,11 +2122,19 @@ sub process_file($) {
 	    } elsif (/$doc_content/) {
 		# miguel-style comment kludge, look for blank lines after
 		# @parameter line to signify start of description
-		if ($1 eq "" &&
-			($section =~ m/^@/ || $section eq $section_context)) {
-		    dump_section($file, $section, xml_escape($contents));
-		    $section = $section_default;
-		    $contents = "";
+		if ($1 eq "") {
+		    if ($section =~ m/^@/ || $section eq $section_context) {
+			dump_section($file, $section, xml_escape($contents));
+			$section = $section_default;
+			$contents = "";
+		    } else {
+			$contents .= "\n";
+		    }
+		    $in_purpose = 0;
+		} elsif ($in_purpose == 1) {
+		    # Continued declaration purpose
+		    chomp($declaration_purpose);
+		    $declaration_purpose .= " " . xml_escape($1);
 		} else {
 		    $contents .= $1 . "\n";
 		}
