Return-Path: <linux-kernel-owner+w=401wt.eu-S1764264AbXEWAVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764264AbXEWAVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 20:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762334AbXEWAVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 20:21:18 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:37764 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762190AbXEWAVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 20:21:16 -0400
Date: Tue, 22 May 2007 17:26:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH 2/3] kernel-doc: fix unnamed struct/union warning
Message-Id: <20070522172624.e62b35be.randy.dunlap@oracle.com>
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

Fix kernel-doc warning:
Warning(linux-2.6.22-rc2-git2/include/linux/skbuff.h:316): No description found for parameter '}'

which is caused by nested anonymous structs/unions ending with:
  };
};

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- linux-2.6.22-rc2-git2.orig/scripts/kernel-doc
+++ linux-2.6.22-rc2-git2/scripts/kernel-doc
@@ -154,6 +154,7 @@ use strict;
 
 my $errors = 0;
 my $warnings = 0;
+my $anon_struct_union = 0;
 
 # match expressions used to find embedded type information
 my $type_constant = '\%([-_\w]+)';
@@ -1510,8 +1511,13 @@ sub push_parameter($$$) {
 	my $param = shift;
 	my $type = shift;
 	my $file = shift;
-	my $anon = 0;
 
+	if (($anon_struct_union == 1) && ($type eq "") &&
+	    ($param eq "}")) {
+		return;		# ignore the ending }; from anon. struct/union
+	}
+
+	$anon_struct_union = 0;
 	my $param_name = $param;
 	$param_name =~ s/\[.*//;
 
@@ -1530,16 +1536,16 @@ sub push_parameter($$$) {
 	# handle unnamed (anonymous) union or struct:
 	{
 		$type = $param;
-		$param = "{unnamed_" . $param. "}";
+		$param = "{unnamed_" . $param . "}";
 		$parameterdescs{$param} = "anonymous\n";
-		$anon = 1;
+		$anon_struct_union = 1;
 	}
 
 	# warn if parameter has no description
 	# (but ignore ones starting with # as these are not parameters
 	# but inline preprocessor statements);
 	# also ignore unnamed structs/unions;
-	if (!$anon) {
+	if (!$anon_struct_union) {
 	if (!defined $parameterdescs{$param_name} && $param_name !~ /^#/) {
 
 	    $parameterdescs{$param_name} = $undescribed;
