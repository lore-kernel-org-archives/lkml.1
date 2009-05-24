Return-Path: <linux-kernel-owner+w=401wt.eu-S1758149AbZEXCj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbZEXCj2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 22:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbZEXCiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 22:38:07 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1429 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479AbZEXCiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 22:38:01 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 05/18] scripts/get_maintainer.pl - support M: lines with names and multiple entries per M: line
Date: Sat, 23 May 2009 19:37:36 -0700
Message-Id: <cbe106371235da0c92e3982ab6fb2cf175648f14.1243131992.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1243131992.git.joe@perches.com>
References: <cover.1243131992.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |  145 ++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 129 insertions(+), 16 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index fe49122..e62e72f 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -55,6 +55,10 @@ foreach my $chief (@penguin_chief) {
 }
 my $penguin_chiefs = "\(" . join("|",@penguin_chief_names) . "\)";
 
+# rfc822 - preloaded methods go here.
+my $rfc822_lwsp = "(?:(?:\\r\\n)?[ \\t])";
+my $rfc822_char = '[\\000-\\177]';
+
 if (!GetOptions(
 		'email!' => \$email,
 		'git!' => \$email_git,
@@ -392,18 +396,7 @@ sub add_categories {
 		}
 	    } elsif ($ptype eq "M") {
 		if ($email_maintainer) {
-		    if ($index >= 0) {
-			my $tv = $typevalue[$index - 1];
-			if ($tv =~ m/^(\C):\s*(.*)/) {
-			    if ($1 eq "P" && $email_usename) {
-				push(@email_to, format_email($2, $pvalue));
-			    } else {
-				push(@email_to, $pvalue);
-			    }
-			}
-		    } else {
-			push(@email_to, $pvalue);
-		    }
+		    push_email_addresses($pvalue);
 		}
 	    } elsif ($ptype eq "T") {
 		push(@scm, $pvalue);
@@ -421,6 +414,36 @@ sub add_categories {
     }
 }
 
+sub push_email_address {
+    my ($email_address) = @_;
+
+    my $email_name = "";
+    if ($email_address =~ m/([^<]+)<(.*\@.*)>$/) {
+	$email_name = $1;
+	$email_address = $2;
+    }
+
+    if ($email_usename && $email_name) {
+	push(@email_to,	format_email($email_name, $email_address));
+    } else {
+	push(@email_to, $email_address);
+    }
+}
+
+sub push_email_addresses {
+    my ($address) = @_;
+
+    my @address_list = ();
+
+    if (@address_list = rfc822_validlist($address)) {
+	my $array_count = shift(@address_list);
+	while (my $entry = shift(@address_list)) {
+	    push_email_address($entry);
+	}
+    }
+
+}
+
 sub which {
     my ($bin) = @_;
 
@@ -480,10 +503,6 @@ sub recent_git_signoffs {
 	if ($line =~ m/(.+)<(.+)>/) {
 	    my $git_name = $1;
 	    my $git_addr = $2;
-	    $git_name =~ tr/^\"//;
-	    $git_name =~ tr/^\\s*//;
-	    $git_name =~ tr/\"$//;
-	    $git_name =~ tr/\\s*$//;
 	    if ($email_usename) {
 		push(@email_to, format_email($git_name, $git_addr));
 	    } else {
@@ -527,3 +546,97 @@ sub output {
 	print("\n");
     }
 }
+
+my $rfc822re;
+
+sub make_rfc822re {
+#   Basic lexical tokens are specials, domain_literal, quoted_string, atom, and
+#   comment.  We must allow for rfc822_lwsp (or comments) after each of these.
+#   This regexp will only work on addresses which have had comments stripped 
+#   and replaced with rfc822_lwsp.
+
+    my $specials = '()<>@,;:\\\\".\\[\\]';
+    my $controls = '\\000-\\037\\177';
+
+    my $dtext = "[^\\[\\]\\r\\\\]";
+    my $domain_literal = "\\[(?:$dtext|\\\\.)*\\]$rfc822_lwsp*";
+
+    my $quoted_string = "\"(?:[^\\\"\\r\\\\]|\\\\.|$rfc822_lwsp)*\"$rfc822_lwsp*";
+
+#   Use zero-width assertion to spot the limit of an atom.  A simple 
+#   $rfc822_lwsp* causes the regexp engine to hang occasionally.
+    my $atom = "[^$specials $controls]+(?:$rfc822_lwsp+|\\Z|(?=[\\[\"$specials]))";
+    my $word = "(?:$atom|$quoted_string)";
+    my $localpart = "$word(?:\\.$rfc822_lwsp*$word)*";
+
+    my $sub_domain = "(?:$atom|$domain_literal)";
+    my $domain = "$sub_domain(?:\\.$rfc822_lwsp*$sub_domain)*";
+
+    my $addr_spec = "$localpart\@$rfc822_lwsp*$domain";
+
+    my $phrase = "$word*";
+    my $route = "(?:\@$domain(?:,\@$rfc822_lwsp*$domain)*:$rfc822_lwsp*)";
+    my $route_addr = "\\<$rfc822_lwsp*$route?$addr_spec\\>$rfc822_lwsp*";
+    my $mailbox = "(?:$addr_spec|$phrase$route_addr)";
+
+    my $group = "$phrase:$rfc822_lwsp*(?:$mailbox(?:,\\s*$mailbox)*)?;\\s*";
+    my $address = "(?:$mailbox|$group)";
+
+    return "$rfc822_lwsp*$address";
+}
+
+sub rfc822_strip_comments {
+    my $s = shift;
+#   Recursively remove comments, and replace with a single space.  The simpler
+#   regexps in the Email Addressing FAQ are imperfect - they will miss escaped
+#   chars in atoms, for example.
+
+    while ($s =~ s/^((?:[^"\\]|\\.)*
+                    (?:"(?:[^"\\]|\\.)*"(?:[^"\\]|\\.)*)*)
+                    \((?:[^()\\]|\\.)*\)/$1 /osx) {}
+    return $s;
+}
+
+#   valid: returns true if the parameter is an RFC822 valid address
+#
+sub rfc822_valid ($) {
+    my $s = rfc822_strip_comments(shift);
+
+    if (!$rfc822re) {
+        $rfc822re = make_rfc822re();
+    }
+
+    return $s =~ m/^$rfc822re$/so && $s =~ m/^$rfc822_char*$/;
+}
+
+#   validlist: In scalar context, returns true if the parameter is an RFC822 
+#              valid list of addresses.
+#
+#              In list context, returns an empty list on failure (an invalid
+#              address was found); otherwise a list whose first element is the
+#              number of addresses found and whose remaining elements are the
+#              addresses.  This is needed to disambiguate failure (invalid)
+#              from success with no addresses found, because an empty string is
+#              a valid list.
+
+sub rfc822_validlist ($) {
+    my $s = rfc822_strip_comments(shift);
+
+    if (!$rfc822re) {
+        $rfc822re = make_rfc822re();
+    }
+    # * null list items are valid according to the RFC
+    # * the '1' business is to aid in distinguishing failure from no results
+
+    my @r;
+    if ($s =~ m/^(?:$rfc822re)?(?:,(?:$rfc822re)?)*$/so &&
+	$s =~ m/^$rfc822_char*$/) {
+        while($s =~ m/(?:^|,$rfc822_lwsp*)($rfc822re)/gos) {
+            push @r, $1;
+        }
+        return wantarray ? (scalar(@r), @r) : 1;
+    }
+    else {
+        return wantarray ? () : 0;
+    }
+}
-- 
1.6.3.1.10.g659a0.dirty

