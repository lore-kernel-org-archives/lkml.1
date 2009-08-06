Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbZHFCon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbZHFCon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 22:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbZHFCom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 22:44:42 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3244 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662AbZHFCnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 22:43:53 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Julia Lawall <julia@diku.dk>,
       Greg KH <greg@kroah.com>
Subject: [PATCH 7/7] scripts/get_maintainer.pl: Add --remove-duplicates
Date: Wed,  5 Aug 2009 19:43:48 -0700
Message-Id: <69586591a85a204f51197da6335d5bb58e54d414.1249525834.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1249525834.git.joe@perches.com>
References: <cover.1249525834.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow control over the elimination of duplicate email names and addresses

--remove-duplicates will use the first email name or address presented
--noremove-duplicates will emit all names and addresses

--remove-duplicates is enabled by default

For instance:

$ ./scripts/get_maintainer.pl -f drivers/char/tty_ioctl.c
Greg Kroah-Hartman <gregkh@suse.de>
Alan Cox <alan@linux.intel.com>
Mike Frysinger <vapier@gentoo.org>
Alexey Dobriyan <adobriyan@gmail.com>
linux-kernel@vger.kernel.org

$ ./scripts/get_maintainer.pl -f --noremove-duplicates drivers/char/tty_ioctl.c
Greg Kroah-Hartman <gregkh@suse.de>
Alan Cox <alan@redhat.com>
Alan Cox <alan@linux.intel.com>
Alan Cox <alan@lxorguk.ukuu.org.uk>
Mike Frysinger <vapier@gentoo.org>
Alexey Dobriyan <adobriyan@gmail.com>
linux-kernel@vger.kernel.org

Using --remove-duplicates could eliminate multiple maintainers that
share the same name but not the same email address.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |  110 +++++++++++++++++++++++----------------------
 1 files changed, 56 insertions(+), 54 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index a0ccc72..b8d1223 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -30,6 +30,7 @@ my $email_git_max_maintainers = 5;
 my $email_git_min_percent = 5;
 my $email_git_since = "1-year-ago";
 my $email_git_blame = 0;
+my $email_remove_duplicates = 1;
 my $output_multiline = 1;
 my $output_separator = ", ";
 my $scm = 0;
@@ -71,6 +72,7 @@ if (!GetOptions(
 		'git-min-percent=i' => \$email_git_min_percent,
 		'git-since=s' => \$email_git_since,
 		'git-blame!' => \$email_git_blame,
+		'remove-duplicates!' => \$email_remove_duplicates,
 		'm!' => \$email_maintainer,
 		'n!' => \$email_usename,
 		'l!' => \$email_list,
@@ -158,32 +160,28 @@ close(MAINT);
 
 my %mailmap;
 
-open(MAILMAP, "<${lk_path}.mailmap") || warn "$P: Can't open .mailmap\n";
-while (<MAILMAP>) {
-    my $line = $_;
-
-    next if ($line =~ m/^\s*#/);
-    next if ($line =~ m/^\s*$/);
+if ($email_remove_duplicates) {
+    open(MAILMAP, "<${lk_path}.mailmap") || warn "$P: Can't open .mailmap\n";
+    while (<MAILMAP>) {
+	my $line = $_;
 
-    my ($name, $address) = parse_email($line);
-    $line = format_email($name, $address);
+	next if ($line =~ m/^\s*#/);
+	next if ($line =~ m/^\s*$/);
 
-    next if ($line =~ m/^\s*$/);
+	my ($name, $address) = parse_email($line);
+	$line = format_email($name, $address);
 
-    if (exists($mailmap{$name})) {
-	my $obj = $mailmap{$name};
-	push(@$obj, $address);
-    } else {
-	my @arr = ($address);
-	$mailmap{$name} = \@arr;
-    }
-}
-close(MAILMAP);
+	next if ($line =~ m/^\s*$/);
 
-foreach my $name (sort {$mailmap{$a} <=> $mailmap{$b}} keys %mailmap) {
-    my $obj = $mailmap{$name};
-    foreach my $address (@$obj) {
+	if (exists($mailmap{$name})) {
+	    my $obj = $mailmap{$name};
+	    push(@$obj, $address);
+	} else {
+	    my @arr = ($address);
+	    $mailmap{$name} = \@arr;
+	}
     }
+    close(MAILMAP);
 }
 
 ## use the filenames on the command line or find the filenames in the patchfiles
@@ -373,6 +371,7 @@ MAINTAINER field selection options:
     --n => include name 'Full Name <addr\@domain.tld>'
     --l => include list(s) if any
     --s => include subscriber only list(s) if any
+    --remove-duplicates => minimize duplicate email names/addresses
   --scm => print SCM tree(s) if any
   --status => print status if any
   --subsystem => print subsystem name if any
@@ -389,7 +388,7 @@ Other options:
   --help => show this help information
 
 Default options:
-  [--email --git --m --n --l --multiline --pattern-depth=0]
+  [--email --git --m --n --l --multiline --pattern-depth=0 --remove-duplicates]
 
 Notes:
   Using "-f directory" may give unexpected results:
@@ -438,12 +437,12 @@ sub parse_email {
     my $name = "";
     my $address = "";
 
-    if ($formatted_email =~ /^([^<]+)<(.*\@.*)>.*$/) {
+    if ($formatted_email =~ /^([^<]+)<(.+\@.*)>.*$/) {
 	$name = $1;
 	$address = $2;
-    } elsif ($formatted_email =~ /^\s*<(.*\@.*)>.*$/) {
+    } elsif ($formatted_email =~ /^\s*<(.+\@\S*)>.*$/) {
 	$address = $1;
-    } elsif ($formatted_email =~ /^\s*(.*\@.*)$/) {
+    } elsif ($formatted_email =~ /^(.+\@\S*)$/) {
 	$address = $1;
     }
 
@@ -542,14 +541,16 @@ sub add_categories {
     }
 }
 
-sub email_address_inuse {
-    my ($test_address) = @_;
- 
-    foreach my $line (@email_to) {
-	my ($name, $address) = parse_email($line);
+my %email_hash_name;
+my %email_hash_address;
+
+sub email_inuse {
+    my ($name, $address) = @_;
+
+    return 1 if (($name eq "") && ($address eq ""));
+    return 1 if (($name ne "") && exists($email_hash_name{$name}));
+    return 1 if (($address ne "") && exists($email_hash_address{$address}));
 
-	return 1 if ($address eq $test_address);
-    }
     return 0;
 }
 
@@ -558,8 +559,12 @@ sub push_email_address {
 
     my ($name, $address) = parse_email($line);
 
-    if (!email_address_inuse($address)) {
+    if (!$email_remove_duplicates) {
 	push(@email_to, format_email($name, $address));
+    } elsif (!email_inuse($name, $address)) {
+	push(@email_to, format_email($name, $address));
+	$email_hash_name{$name}++;
+	$email_hash_address{$address}++;
     }
 }
  
@@ -600,6 +605,9 @@ sub mailmap {
 	my ($name, $address) = parse_email($line);
 	if (!exists($hash{$name})) {
 	    $hash{$name} = $address;
+	} elsif ($address ne $hash{$name}) {
+	    $address = $hash{$name};
+	    $line = format_email($name, $address);
 	}
 	if (exists($mailmap{$name})) {
 	    my $obj = $mailmap{$name};
@@ -652,31 +660,23 @@ sub recent_git_signoffs {
 
     $total_sign_offs = @lines;
 
-    @lines = mailmap(@lines);
+    if ($email_remove_duplicates) {
+	@lines = mailmap(@lines);
+    }
 
     @lines = sort(@lines);
+
     # uniq -c
-    foreach my $line (@lines) {
-	$hash{$line}++;
-    }
+    $hash{$_}++ for @lines;
+
     # sort -rn
-    @lines = ();
     foreach my $line (sort {$hash{$b} <=> $hash{$a}} keys %hash) {
-	push(@lines,"$hash{$line}	$line");
-    }
-
-    foreach my $line (@lines) {
-	if ($line =~ m/([0-9]+)\s+(.*)/) {
-	    my $sign_offs = $1;
-	    $line = $2;
-	    $count++;
-	    if ($sign_offs < $email_git_min_signatures ||
-	        $count > $email_git_max_maintainers ||
-		$sign_offs * 100 / $total_sign_offs < $email_git_min_percent) {
-		last;
-	    }
-	    push_email_address($line);
-	}
+	my $sign_offs = $hash{$line};
+	$count++;
+	last if ($sign_offs < $email_git_min_signatures ||
+		 $count > $email_git_max_maintainers ||
+		 $sign_offs * 100 / $total_sign_offs < $email_git_min_percent);
+	push_email_address($line);
     }
 }
 
@@ -743,7 +743,9 @@ sub git_assign_blame {
 
 	$total_sign_offs += @lines;
 
-	@lines = mailmap(@lines);
+	if ($email_remove_duplicates) {
+	    @lines = mailmap(@lines);
+	}
 
 	$hash{$_}++ for @lines;
     }
-- 
1.6.3.1.10.g659a0.dirty

