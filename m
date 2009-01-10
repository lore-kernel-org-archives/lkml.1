Return-Path: <linux-kernel-owner+w=401wt.eu-S1755749AbZAJV0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749AbZAJV0X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 16:26:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbZAJV0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 16:26:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:39748 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbZAJV0K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 16:26:10 -0500
Date: Sat, 10 Jan 2009 16:28:13 -0500
From: Arjan van de Ven <arjan@infradead.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] bootgraph: make the bootgraph script show async waiting
 time
Message-ID: <20090110162813.2e064420@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b7e24cef63a0bd89dc7aa964420f8fac7705c8d5 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 10 Jan 2009 10:03:05 -0800
Subject: [PATCH] bootgraph: make the bootgraph script show async waiting time

it's useful for diagnosing boot performance to see where async function calls
are waiting on serialization... this patch adds this functionality to the
bootgraph.pl script.
The waiting time is shown as a half transparent, gray bar through the
block that is waiting.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 scripts/bootgraph.pl |   46 ++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/scripts/bootgraph.pl b/scripts/bootgraph.pl
index 0a498e3..e3d6ca8 100644
--- a/scripts/bootgraph.pl
+++ b/scripts/bootgraph.pl
@@ -41,11 +41,13 @@ use strict;
 
 my %start;
 my %end;
+my %type;
 my $done = 0;
 my $maxtime = 0;
 my $firsttime = 100;
 my $count = 0;
 my %pids;
+my %pidctr;
 
 while (<>) {
 	my $line = $_;
@@ -53,6 +55,7 @@ while (<>) {
 		my $func = $2;
 		if ($done == 0) {
 			$start{$func} = $1;
+			$type{$func} = 0;
 			if ($1 < $firsttime) {
 				$firsttime = $1;
 			}
@@ -63,12 +66,40 @@ while (<>) {
 		$count = $count + 1;
 	}
 
+	if ($line =~ /([0-9\.]+)\] async_waiting @ ([0-9]+)/) {
+		my $pid = $2;
+		my $func;
+		if (!defined($pidctr{$pid})) {
+			$func = "wait_" . $pid . "_1";
+			$pidctr{$pid} = 1;
+		} else {
+			$pidctr{$pid} = $pidctr{$pid} + 1;
+			$func = "wait_" . $pid . "_" . $pidctr{$pid};
+		}
+		if ($done == 0) {
+			$start{$func} = $1;
+			$type{$func} = 1;
+			if ($1 < $firsttime) {
+				$firsttime = $1;
+			}
+		}
+		$pids{$func} = $pid;
+		$count = $count + 1;
+	}
+
 	if ($line =~ /([0-9\.]+)\] initcall ([a-zA-Z0-9\_]+)\+.*returned/) {
 		if ($done == 0) {
 			$end{$2} = $1;
 			$maxtime = $1;
 		}
 	}
+
+	if ($line =~ /([0-9\.]+)\] async_continuing @ ([0-9]+)/) {
+		my $pid = $2;
+		my $func =  "wait_" . $pid . "_" . $pidctr{$pid}; 
+		$end{$func} = $1;
+		$maxtime = $1;
+	}
 	if ($line =~ /Write protecting the/) {
 		$done = 1;
 	}
@@ -105,6 +136,8 @@ $styles[9] = "fill:rgb(255,255,128);fill-opacity:0.5;stroke-width:1;stroke:rgb(0
 $styles[10] = "fill:rgb(255,128,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
 $styles[11] = "fill:rgb(128,255,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
 
+my $style_wait = "fill:rgb(128,128,128);fill-opacity:0.5;stroke-width:0;stroke:rgb(0,0,0)";
+
 my $mult = 1950.0 / ($maxtime - $firsttime);
 my $threshold2 = ($maxtime - $firsttime) / 120.0;
 my $threshold = $threshold2/10;
@@ -139,11 +172,16 @@ foreach my $key (@initcalls) {
 			$stylecounter = 0;
 		};
 
-		print "<rect x=\"$s\" width=\"$w\" y=\"$y\" height=\"145\" style=\"$style\"/>\n";
-		if ($duration >= $threshold2) {
-			print "<text transform=\"translate($s2,$y2) rotate(90)\">$key</text>\n";
+		if ($type{$key} == 1) {
+			$y = $y + 15;
+			print "<rect x=\"$s\" width=\"$w\" y=\"$y\" height=\"115\" style=\"$style_wait\"/>\n";
 		} else {
-			print "<text transform=\"translate($s3,$y2) rotate(90)\" font-size=\"3pt\">$key</text>\n";
+			print "<rect x=\"$s\" width=\"$w\" y=\"$y\" height=\"145\" style=\"$style\"/>\n";
+			if ($duration >= $threshold2) {
+				print "<text transform=\"translate($s2,$y2) rotate(90)\">$key</text>\n";
+			} else {
+				print "<text transform=\"translate($s3,$y2) rotate(90)\" font-size=\"3pt\">$key</text>\n";
+			}
 		}
 	}
 }
-- 
1.6.0.6



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
