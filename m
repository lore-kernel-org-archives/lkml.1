Return-Path: <linux-kernel-owner+w=401wt.eu-S1751970Ab0AHHQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab0AHHQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 02:16:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848Ab0AHHQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 02:16:10 -0500
Received: from mail.perches.com ([173.55.12.10]:1657 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab0AHHQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 02:16:10 -0500
Subject: [PATCH] scripts/get_maintainer.pl: Add --file-emails, find
 embedded email addresses
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jan 2010 23:16:06 -0800
Message-ID: <1262934966.10429.105.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an imperfect option to search a source file for email addresses.

New option:  --file-emails or --fe (default is disabled)

email addresses in files are freeform text and are nearly
impossible to parse.  Still, might as well try to do a
somewhat acceptable job of finding them.

This code will find all addresses that are in the form
(addr@domain.tld) and <addr@domain.tld>.  Addresses
without parentheses or angle brackets are ignored.

Some variants that are shown correctly:
	John Smith <jksmith@domain.org>
	Random J. Developer <rjd@tld.com>
	Random J. Developer (rjd@tld.com)

A variant that is shown correctly:
	Written by First Last (funny-addr@somecompany.com)
is shown as:
	First Last <funny-addr@somecompany.com>

Variants that are shown incorrectly:
	J. Random Developer <jrd@domain.tld>
	Some Really Long Name <srln@foo.bar>
are returned as:
	Random Developer <jrd@domain.tld>
	Long Name <srln@foo.bar>

Some variants that are ignored:
	Some Really Long Name srrln@foo.bar
	name@domain.tld (Developer Name)

The code assumes that the 2 words preceeding a found
email address are names.  If the 1st of the 2 words is
a single letter and period, then another word is used,
assuming (First, Initial, Last).

--roles and --rolestats show "(in file)" for matches.

For instance:

Without -file-emails:

$ ./scripts/get_maintainer.pl -f -nogit -roles net/core/netpoll.c
David S. Miller <davem@davemloft.net> (maintainer:NETWORKING [GENERAL])
linux-kernel@vger.kernel.org (open list)

With -fe:

$ ./scripts/get_maintainer.pl -f -fe -nogit -roles net/core/netpoll.c
David S. Miller <davem@davemloft.net> (maintainer:NETWORKING [GENERAL])
Matt Mackall <mpm@selenic.com> (in file)
Ingo Molnar <mingo@redhat.com> (in file)
linux-kernel@vger.kernel.org (open list)
netdev@vger.kernel.org (open list:NETWORKING [GENERAL])

The number of email addresses in the file in not limited.
Neither is the number of returned email addresses.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |   62 +++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 55 insertions(+), 7 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 445e884..8ebfe1b 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -41,6 +41,7 @@ my $web = 0;
 my $subsystem = 0;
 my $status = 0;
 my $keywords = 1;
+my $file_emails = 0;
 my $from_filename = 0;
 my $pattern_depth = 0;
 my $version = 0;
@@ -120,6 +121,7 @@ if (!GetOptions(
 		'web!' => \$web,
 		'pattern-depth=i' => \$pattern_depth,
 		'k|keywords!' => \$keywords,
+		'fe|file-emails!' => \$file_emails,
 		'f|file' => \$from_filename,
 		'v|version' => \$version,
 		'h|help' => \$help,
@@ -232,6 +234,7 @@ if ($email_remove_duplicates) {
 my @files = ();
 my @range = ();
 my @keyword_tvi = ();
+my @file_emails = ();
 
 foreach my $file (@ARGV) {
     ##if $file is a directory and it lacks a trailing slash, add one
@@ -242,15 +245,21 @@ foreach my $file (@ARGV) {
     }
     if ($from_filename) {
 	push(@files, $file);
-	if (-f $file && $keywords) {
+	if (-f $file && ($keywords || $file_emails)) {
 	    open(FILE, "<$file") or die "$P: Can't open ${file}\n";
 	    my $text = do { local($/) ; <FILE> };
-	    foreach my $line (keys %keyword_hash) {
-		if ($text =~ m/$keyword_hash{$line}/x) {
-		    push(@keyword_tvi, $line);
+	    close(FILE);
+	    if ($keywords) {
+		foreach my $line (keys %keyword_hash) {
+		    if ($text =~ m/$keyword_hash{$line}/x) {
+			push(@keyword_tvi, $line);
+		    }
 		}
 	    }
-	    close(FILE);
+	    if ($file_emails) {
+		my @poss_addr = $text =~ m$[A-Za-zÀ-ÿ\"\' \,\.\+-]*\s*[\(\<][A-Za-z0-9_\.\+-]+\@[A-Za-z0-9\.-]+[\)\>]$g;
+		push(@file_emails, clean_file_emails(@poss_addr));
+	    }
 	}
     } else {
 	my $file_cnt = @files;
@@ -285,6 +294,8 @@ foreach my $file (@ARGV) {
     }
 }
 
+@file_emails = uniq(@file_emails);
+
 my @email_to = ();
 my @list_to = ();
 my @scm = ();
@@ -367,6 +378,14 @@ if ($email) {
 	    }
 	}
     }
+
+    foreach my $email (@file_emails) {
+	my ($name, $address) = parse_email($email);
+
+	my $tmp_email = format_email($name, $address, $email_usename);
+	push_email_address($tmp_email, '');
+	add_role($tmp_email, 'in file');
+    }
 }
 
 if ($email || $email_list) {
@@ -443,6 +462,7 @@ MAINTAINER field selection options:
     --remove-duplicates => minimize duplicate email names/addresses
     --roles => show roles (status:subsystem, git-signer, list, etc...)
     --rolestats => show roles and statistics (commits/total_commits, %)
+    --file-emails => add email addresses found in -f file (default: 0 (off))
   --scm => print SCM tree(s) if any
   --status => print status if any
   --subsystem => print subsystem name if any
@@ -787,7 +807,9 @@ sub add_role {
     foreach my $entry (@email_to) {
 	if ($email_remove_duplicates) {
 	    my ($entry_name, $entry_address) = parse_email($entry->[0]);
-	    if ($name eq $entry_name || $address eq $entry_address) {
+	    if (($name eq $entry_name || $address eq $entry_address)
+		&& ($role eq "" || !($entry->[1] =~ m/$role/))
+	    ) {
 		if ($entry->[1] eq "") {
 		    $entry->[1] = "$role";
 		} else {
@@ -795,7 +817,9 @@ sub add_role {
 		}
 	    }
 	} else {
-	    if ($email eq $entry->[0]) {
+	    if ($email eq $entry->[0]
+		&& ($role eq "" || !($entry->[1] =~ m/$role/))
+	    ) {
 		if ($entry->[1] eq "") {
 		    $entry->[1] = "$role";
 		} else {
@@ -1075,6 +1099,30 @@ sub sort_and_uniq {
     return @parms;
 }
 
+sub clean_file_emails {
+    my (@file_emails) = @_;
+    my @fmt_emails = ();
+
+    foreach my $email (@file_emails) {
+	$email =~ s/\(/\</g;
+	$email =~ s/\)/\>/g;
+	my ($name, $address) = parse_email($email);
+	my @nw = split(/[^A-Za-zÀ-ÿ\"\'\,\.\+-]/, $name);
+	if (@nw > 2) {
+	    if ((length($nw[@nw - 2]) == 2) &&
+		 substr($nw[@nw - 2], 1) eq ".") {
+		$name = "$nw[@nw - 3] $nw[@nw - 2] $nw[@nw - 1]";
+	    } else {
+		$name = "$nw[@nw - 2] $nw[@nw - 1]";
+	    }
+	}
+	my $fmt_email = format_email($name, $address, $email_usename);
+	push(@fmt_emails, $fmt_email);
+    }
+    return @fmt_emails;
+}
+
+
 sub merge_email {
     my @lines;
     my %saw;
-- 
1.6.6.rc0.57.gad7a



