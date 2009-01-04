Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbZADPO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbZADPO5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 10:14:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbZADPOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 10:14:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:53488 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbZADPOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 10:14:47 -0500
Date: Sun, 4 Jan 2009 07:16:38 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, davej@redhat.com, fweisbec@gmail.com
Subject: [PATCH] bootchart: improve output based on Dave Jones' feedback
Message-ID: <20090104071638.64be922a@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: bootchart: improve output based on Dave Jones' feedback
From: Arjan van de Ven <arjan@linux.intel.com>

Dave Jones, in his blog, had some feedback about the bootchart script:
Primarily his complaint was that shorter delays weren't visualized.

The reason for that was that too small delays will have their labels
mixed up in the graph in an unreadable mess.

This patch has a fix for this; for one, it makes the output wider,
so more will fit.
The second part is that smaller delays are now shown with a
much smaller font for the label; while this isn't per se 
readable at a 1:1 zoom, at least you can zoom in with most SVG
viewing applications and see what it is you are looking at.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>


diff --git a/scripts/bootgraph.pl b/scripts/bootgraph.pl
index f0af9aa..c6a01d8 100644
--- a/scripts/bootgraph.pl
+++ b/scripts/bootgraph.pl
@@ -88,7 +89,7 @@ END
 }
 
 print "<?xml version=\"1.0\" standalone=\"no\"?> \n";
-print "<svg width=\"1000\" height=\"100%\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\">\n";
+print "<svg width=\"2000\" height=\"100%\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\">\n";
 
 my @styles;
 
@@ -105,8 +106,9 @@ $styles[9] = "fill:rgb(255,255,128);fill-opacity:0.5;stroke-width:1;stroke:rgb(0
 $styles[10] = "fill:rgb(255,128,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
 $styles[11] = "fill:rgb(128,255,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
 
-my $mult = 950.0 / ($maxtime - $firsttime);
-my $threshold = ($maxtime - $firsttime) / 60.0;
+my $mult = 1950.0 / ($maxtime - $firsttime);
+my $threshold2 = ($maxtime - $firsttime) / 120.0;
+my $threshold = $threshold2/10;
 my $stylecounter = 0;
 my %rows;
 my $rowscount = 1;
@@ -116,7 +118,7 @@ foreach my $key (@initcalls) {
 	my $duration = $end{$key} - $start{$key};
 
 	if ($duration >= $threshold) {
-		my ($s, $s2, $e, $w, $y, $y2, $style);
+		my ($s, $s2, $s3, $e, $w, $y, $y2, $style);
 		my $pid = $pids{$key};
 
 		if (!defined($rows{$pid})) {
@@ -125,6 +127,7 @@ foreach my $key (@initcalls) {
 		}
 		$s = ($start{$key} - $firsttime) * $mult;
 		$s2 = $s + 6;
+		$s3 = $s + 1;
 		$e = ($end{$key} - $firsttime) * $mult;
 		$w = $e - $s;
 
@@ -138,7 +141,11 @@ foreach my $key (@initcalls) {
 		};
 
 		print "<rect x=\"$s\" width=\"$w\" y=\"$y\" height=\"145\" style=\"$style\"/>\n";
-		print "<text transform=\"translate($s2,$y2) rotate(90)\">$key</text>\n";
+		if ($duration >= $threshold2) {
+			print "<text transform=\"translate($s2,$y2) rotate(90)\">$key</text>\n";
+		} else {
+			print "<text transform=\"translate($s3,$y2) rotate(90)\" font-size=\"3pt\">$key</text>\n";
+		}
 	}
 }
 
-- 
1.6.0.6


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
