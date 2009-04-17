Return-Path: <linux-kernel-owner+w=401wt.eu-S1759939AbZDQWMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939AbZDQWMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 18:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbZDQWMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 18:12:35 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1335 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbZDQWMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 18:12:35 -0400
Subject: Re: [PATCH 0/10] MAINTAINERS - add script, patterns and misc
 updates
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: randy.dunlap@oracle.com, torvalds@linux-foundation.org, akpm@kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090417144117.4ac8828f.akpm@linux-foundation.org>
References: <1239167872-8179-1-git-send-email-joe@perches.com>
	 <20090417134711.ba0f03e7.randy.dunlap@oracle.com>
	 <1240003652.31116.44.camel@localhost>
	 <20090417144117.4ac8828f.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 15:09:28 -0700
Message-Id: <1240006168.31116.62.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-17 at 14:41 -0700, Andrew Morton wrote:
> Lots of people's scripts/get_maintainer.pl files won't have the `x' bit
> set because patch(1) is dumb.  So for reliability it's best to always do

git at least persisted the "x" bit.
checkpatch doesn't say to use perl.

> 	perl ./scripts/get_maintainer.pl

OK by me.

> : akpm:/usr/src/25> perl scripts/get_maintainer.pl -f fs/ext3/inode.c 
> : grep: The -P option is not supported
>     that's odd.  `man grep' on this machine says

I changed the script grep to use "-E", which is older.

> : fatal: Not a git repository
> 
>     it whines about not being run in a git directory, but does a decent
>     job anyway.  

Oh, I see, you've git installed, but not in your
/usr/src/25 directory.

I changed the script to verify that a .git directory
exists before running git.

How about with these 2 patches applied?

1: Update scripts/get_maintainer.pl
   better subscriber-only mailing list checks
   use grep -E not grep -P, works with earlier version of grep
   check path for .git before using git
   Output maintainers before mailing lists
   Don't auto-add linux-kernel@vger.kernel.org
2: Update MAINTAINERS
   Add file patterns to "THE REST"
   Add L: linux-kernel@vger.kernel.org to "THE REST"

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 60dc0c4..8ba7b3b 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
 
 my $P = $0;
-my $V = '0.15';
+my $V = '0.16';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -169,6 +169,7 @@ foreach my $file (@ARGV) {
 }
 
 my @email_to = ();
+my @list_to = ();
 my @scm = ();
 my @web = ();
 my @subsystem = ();
@@ -182,7 +183,7 @@ foreach my $file (@files) {
 
     my $exclude = 0;
     foreach my $line (@typevalue) {
-	if ($line =~ m/^(\C):(.*)/) {
+	if ($line =~ m/^(\C):\s*(.*)/) {
 	    my $type = $1;
 	    my $value = $2;
 	    if ($type eq 'X') {
@@ -196,7 +197,7 @@ foreach my $file (@files) {
     if (!$exclude) {
 	my $tvi = 0;
 	foreach my $line (@typevalue) {
-	    if ($line =~ m/^(\C):(.*)/) {
+	    if ($line =~ m/^(\C):\s*(.*)/) {
 		my $type = $1;
 		my $value = $2;
 		if ($type eq 'F') {
@@ -215,29 +216,33 @@ foreach my $file (@files) {
 
 }
 
-if ($email_git_penguin_chiefs) {
+if ($email) {
     foreach my $chief (@penguin_chief) {
 	if ($chief =~ m/^(.*):(.*)/) {
-	    my $chief_name = $1;
-	    my $chief_addr = $2;
+	    my $email_address;
 	    if ($email_usename) {
-		push(@email_to, format_email($chief_name, $chief_addr));
+		$email_address = format_email($1, $2);
 	    } else {
-		push(@email_to, $chief_addr);
+		$email_address = $2;
 	    }
+	    if ($email_git_penguin_chiefs) {
+		push(@email_to, $email_address);
+	    } else {
+		@email_to = grep(!/${email_address}/, @email_to);
+	    }		
 	}
     }
 }
 
-if ($email) {
-    my $address_cnt = @email_to;
-    if ($address_cnt == 0 && $email_list) {
-	push(@email_to, "linux-kernel\@vger.kernel.org");
+if ($email || $email_list) {
+    my @to = ();
+    if ($email) {
+	@to = (@to, @email_to);
     }
-
-#Don't sort email address list, but do remove duplicates
-    @email_to = uniq(@email_to);
-    output(@email_to);
+    if ($email_list) {
+	@to = (@to, @list_to);
+    }
+    output(uniq(@to));
 }
 
 if ($scm) {
@@ -307,10 +312,10 @@ Output type options:
   --multiline => print 1 entry per line
 
 Default options:
-  [--email --git --m --l --multiline]
+  [--email --git --m --n --l --multiline]
 
 Other options:
-  --version -> show version
+  --version => show version
   --help => show this help information
 
 EOT
@@ -366,26 +371,30 @@ sub add_categories {
     $index = $index - 1;
     while ($index >= 0) {
 	my $tv = $typevalue[$index];
-	if ($tv =~ m/^(\C):(.*)/) {
+	if ($tv =~ m/^(\C):\s*(.*)/) {
 	    my $ptype = $1;
 	    my $pvalue = $2;
 	    if ($ptype eq "L") {
-		my $subscr = $pvalue;
-		if ($subscr =~ m/\s*\(subscribers-only\)/) {
+		my $list_address = $pvalue;
+		my $list_additional = "";
+		if ($list_address =~ m/([^\s]+)\s+(.*)$/) {
+		    $list_address = $1;
+		    $list_additional = $2;
+		}
+		if ($list_additional =~ m/subscribers-only/) {
 		    if ($email_subscriber_list) {
-			$subscr =~ s/\s*\(subscribers-only\)//g;
-			push(@email_to, $subscr);
+			push(@list_to, $list_address);
 		    }
 		} else {
 		    if ($email_list) {
-			push(@email_to, $pvalue);
+			push(@list_to, $list_address);
 		    }
 		}
 	    } elsif ($ptype eq "M") {
 		if ($email_maintainer) {
 		    if ($index >= 0) {
 			my $tv = $typevalue[$index - 1];
-			if ($tv =~ m/^(\C):(.*)/) {
+			if ($tv =~ m/^(\C):\s*(.*)/) {
 			    if ($1 eq "P" && $email_usename) {
 				push(@email_to, format_email($2, $pvalue));
 			    } else {
@@ -415,7 +424,7 @@ sub add_categories {
 sub which {
     my ($bin) = @_;
 
-    foreach my $path (split /:/, $ENV{PATH}) {
+    foreach my $path (split(/:/, $ENV{PATH})) {
 	if (-e "$path/$bin") {
 	    return "$path/$bin";
 	}
@@ -433,17 +442,16 @@ sub recent_git_signoffs {
     my $count = 0;
     my @lines = ();
 
+    if (!(-d ".git")) {
+	return;
+    }
     if (which("git") eq "") {
 	die("$P: git not found.  Add --nogit to options?\n");
     }
 
     $cmd = "git log --since=${email_git_since} -- ${file}";
-    $cmd .= " | grep -Pi \"^[-_ 	a-z]+by:.*\\\@\"";
-    if (!$email_git_penguin_chiefs) {
-	$cmd .= " | grep -Pv \"${penguin_chiefs}\"";
-    }
+    $cmd .= " | grep -Ei \"^[-_ 	a-z]+by:.*\\\@.*\$\"";
     $cmd .= " | cut -f2- -d\":\"";
-    $cmd .= " | sed -e \"s/^\\s+//g\"";
     $cmd .= " | sort | uniq -c | sort -rn";
 
     $output = `${cmd}`;
@@ -481,7 +489,6 @@ sub recent_git_signoffs {
 	    push(@email_to, $line);
 	}
     }
-    return $output;
 }
 
 sub uniq {
diff --git a/MAINTAINERS b/MAINTAINERS
index abbedb6..e35f589 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6275,5 +6329,10 @@ F:	drivers/serial/zs.*
 
 THE REST
 P:	Linus Torvalds
+M:	torvalds@linux-foundation.org
+L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
 S:	Buried alive in reporters
+F:	*
+F:	*/
+



