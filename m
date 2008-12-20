Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbYLTOgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbYLTOgq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 09:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbYLTOap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 09:30:45 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:56412 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbYLTOaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 09:30:11 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 22/26] kernel-doc: check for extra kernel-doc notations
Date: Sat, 20 Dec 2008 15:31:33 +0100
Message-Id: <1229783497-19550-22-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20081220142518.GA19390@uranus.ravnborg.org>
References: <20081220142518.GA19390@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add functionality to check for function parameters or structure (or
union/typedef/enum) field members that are described in kernel-doc but
are not part of the expected (declared) parameters or structure.
These generate warnings that are called "Excess" descriptions.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kernel-doc |   67 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 66 insertions(+), 1 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index d27aad7..8bb83a1 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -289,6 +289,8 @@ my %parameterdescs;
 my @parameterlist;
 my %sections;
 my @sectionlist;
+my $sectcheck;
+my $struct_actual;
 
 my $contents = "";
 my $section_default = "Description";	# default section
@@ -378,10 +380,12 @@ sub dump_section {
 #	print STDERR "parameter def '$1' = '$contents'\n";
 	$name = $1;
 	$parameterdescs{$name} = $contents;
+	$sectcheck = $sectcheck . $name . " ";
     } elsif ($name eq "@\.\.\.") {
 #	print STDERR "parameter def '...' = '$contents'\n";
 	$name = "...";
 	$parameterdescs{$name} = $contents;
+	$sectcheck = $sectcheck . $name . " ";
     } else {
 #	print STDERR "other section '$name' = '$contents'\n";
 	if (defined($sections{$name}) && ($sections{$name} ne "")) {
@@ -1405,21 +1409,25 @@ sub dump_union($$) {
 sub dump_struct($$) {
     my $x = shift;
     my $file = shift;
+    my $nested;
 
     if ($x =~/(struct|union)\s+(\w+)\s*{(.*)}/) {
 	$declaration_name = $2;
 	my $members = $3;
 
 	# ignore embedded structs or unions
-	$members =~ s/{.*}//g;
+	$members =~ s/({.*})//g;
+	$nested = $1;
 
 	# ignore members marked private:
 	$members =~ s/\/\*.*?private:.*?public:.*?\*\///gos;
 	$members =~ s/\/\*.*?private:.*//gos;
 	# strip comments:
 	$members =~ s/\/\*.*?\*\///gos;
+	$nested =~ s/\/\*.*?\*\///gos;
 
 	create_parameterlist($members, ';', $file);
+	check_sections($file, $declaration_name, "struct", $sectcheck, $struct_actual, $nested);
 
 	output_declaration($declaration_name,
 			   'struct',
@@ -1505,6 +1513,14 @@ sub dump_typedef($$) {
     }
 }
 
+sub save_struct_actual($) {
+    my $actual = shift;
+
+    # strip all spaces from the actual param so that it looks like one string item
+    $actual =~ s/\s*//g;
+    $struct_actual = $struct_actual . $actual . " ";
+}
+
 sub create_parameterlist($$$) {
     my $args = shift;
     my $splitter = shift;
@@ -1537,6 +1553,7 @@ sub create_parameterlist($$$) {
 	    $param = $1;
 	    $type = $arg;
 	    $type =~ s/([^\(]+\(\*?)\s*$param/$1/;
+	    save_struct_actual($param);
 	    push_parameter($param, $type, $file);
 	} elsif ($arg) {
 	    $arg =~ s/\s*:\s*/:/g;
@@ -1561,14 +1578,17 @@ sub create_parameterlist($$$) {
 
 	    foreach $param (@args) {
 		if ($param =~ m/^(\*+)\s*(.*)/) {
+		    save_struct_actual($2);
 		    push_parameter($2, "$type $1", $file);
 		}
 		elsif ($param =~ m/(.*?):(\d+)/) {
 		    if ($type ne "") { # skip unnamed bit-fields
+			save_struct_actual($1);
 			push_parameter($1, "$type:$2", $file)
 		    }
 		}
 		else {
+		    save_struct_actual($param);
 		    push_parameter($param, $type, $file);
 		}
 	    }
@@ -1634,6 +1654,46 @@ sub push_parameter($$$) {
 	$parametertypes{$param} = $type;
 }
 
+sub check_sections($$$$$$) {
+	my ($file, $decl_name, $decl_type, $sectcheck, $prmscheck, $nested) = @_;
+	my @sects = split ' ', $sectcheck;
+	my @prms = split ' ', $prmscheck;
+	my $err;
+	my ($px, $sx);
+	my $prm_clean;		# strip trailing "[array size]" and/or beginning "*"
+
+	foreach $sx (0 .. $#sects) {
+		$err = 1;
+		foreach $px (0 .. $#prms) {
+			$prm_clean = $prms[$px];
+			$prm_clean =~ s/\[.*\]//;
+			$prm_clean =~ s/__attribute__\s*\(\([a-z,_\*\s\(\)]*\)\)//;
+			##$prm_clean =~ s/^\**//;
+			if ($prm_clean eq $sects[$sx]) {
+				$err = 0;
+				last;
+			}
+		}
+		if ($err) {
+			if ($decl_type eq "function") {
+				print STDERR "Warning(${file}:$.): " .
+					"Excess function parameter " .
+					"'$sects[$sx]' " .
+					"description in '$decl_name'\n";
+				++$warnings;
+			} else {
+				if ($nested !~ m/\Q$sects[$sx]\E/) {
+				    print STDERR "Warning(${file}:$.): " .
+					"Excess struct/union/enum/typedef member " .
+					"'$sects[$sx]' " .
+					"description in '$decl_name'\n";
+				    ++$warnings;
+				}
+			}
+		}
+	}
+}
+
 ##
 # takes a function prototype and the name of the current file being
 # processed and spits out all the details stored in the global
@@ -1699,6 +1759,9 @@ sub dump_function($$) {
 	return;
     }
 
+	my $prms = join " ", @parameterlist;
+	check_sections($file, $declaration_name, "function", $sectcheck, $prms, "");
+
     output_declaration($declaration_name,
 		       'function',
 		       {'function' => $declaration_name,
@@ -1757,6 +1820,8 @@ sub reset_state {
     @parameterlist = ();
     %sections = ();
     @sectionlist = ();
+    $sectcheck = "";
+    $struct_actual = "";
     $prototype = "";
 
     $state = 0;
-- 
1.6.0.2.GIT

