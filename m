Return-Path: <linux-kernel-owner+w=401wt.eu-S1757502AbZLWWSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502AbZLWWSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 17:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757383AbZLWWST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 17:18:19 -0500
Received: from mail.perches.com ([173.55.12.10]:1395 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757379AbZLWWSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 17:18:18 -0500
Subject: [PATCH] scripts/get_maintainer.pl: Fix file exclusion X: logic
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <error27@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kalle.valo@nokia.com,
       johannes@sipsolutions.net
In-Reply-To: <20091223132833.GF17923@bicker>
References: <20091223132833.GF17923@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Dec 2009 14:18:16 -0800
Message-ID: <1261606696.1923.48.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-23 at 15:28 +0200, Dan Carpenter wrote:
> The following command doesn't generate any output.
> `./scripts/get_maintainer.pl --no-git -f drivers/net/wireless/wl12xx/wl1271_acx.c`

An excluded "X:" pattern match in any section
would cause a file not to match any other section.

Signed-off-by: Joe Perches <joe@perches.com>

 scripts/get_maintainer.pl |   86 ++++++++++++++++++++++++++++----------------
 1 files changed, 55 insertions(+), 31 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 445e884..090f248 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -296,46 +296,56 @@ my @status = ();
 
 foreach my $file (@files) {
 
-#Do not match excluded file patterns
-
-    my $exclude = 0;
-    foreach my $line (@typevalue) {
-	if ($line =~ m/^(\C):\s*(.*)/) {
-	    my $type = $1;
-	    my $value = $2;
-	    if ($type eq 'X') {
-		if (file_match_pattern($file, $value)) {
-		    $exclude = 1;
-		    last;
-		}
-	    }
-	}
-    }
+    my %hash;
+    my $tvi = find_first_section();
+    while ($tvi < @typevalue) {
+	my $start = find_starting_index($tvi);
+	my $end = find_ending_index($tvi);
+	my $exclude = 0;
+	my $i;
+
+	#Do not match excluded file patterns
 
-    if (!$exclude) {
-	my $tvi = 0;
-	my %hash;
-	foreach my $line (@typevalue) {
+	for ($i = $start; $i < $end; $i++) {
+	    my $line = $typevalue[$i];
 	    if ($line =~ m/^(\C):\s*(.*)/) {
 		my $type = $1;
 		my $value = $2;
-		if ($type eq 'F') {
+		if ($type eq 'X') {
 		    if (file_match_pattern($file, $value)) {
-			my $value_pd = ($value =~ tr@/@@);
-			my $file_pd = ($file  =~ tr@/@@);
-			$value_pd++ if (substr($value,-1,1) ne "/");
-			if ($pattern_depth == 0 ||
-			    (($file_pd - $value_pd) < $pattern_depth)) {
-			    $hash{$tvi} = $value_pd;
-			}
+			$exclude = 1;
 		    }
 		}
 	    }
-	    $tvi++;
 	}
-	foreach my $line (sort {$hash{$b} <=> $hash{$a}} keys %hash) {
-	    add_categories($line);
+
+	if (!$exclude) {
+	    for ($i = $start; $i < $end; $i++) {
+		my $line = $typevalue[$i];
+		if ($line =~ m/^(\C):\s*(.*)/) {
+		    my $type = $1;
+		    my $value = $2;
+		    if ($type eq 'F') {
+			if (file_match_pattern($file, $value)) {
+			    my $value_pd = ($value =~ tr@/@@);
+			    my $file_pd = ($file  =~ tr@/@@);
+			    $value_pd++ if (substr($value,-1,1) ne "/");
+			    if ($pattern_depth == 0 ||
+				(($file_pd - $value_pd) < $pattern_depth)) {
+				$hash{$tvi} = $value_pd;
+			    }
+			}
+		    }
+		}
+	    }
 	}
+
+	$tvi += ($end - $start);
+
+    }
+
+    foreach my $line (sort {$hash{$b} <=> $hash{$a}} keys %hash) {
+	add_categories($line);
     }
 
     if ($email && $email_git) {
@@ -570,6 +580,20 @@ sub format_email {
     return $formatted_email;
 }
 
+sub find_first_section {
+    my $index = 0;
+
+    while ($index < @typevalue) {
+	my $tv = $typevalue[$index];
+	if (($tv =~ m/^(\C):\s*(.*)/)) {
+	    last;
+	}
+	$index++;
+    }
+
+    return $index;
+}
+
 sub find_starting_index {
     my ($index) = @_;
 


