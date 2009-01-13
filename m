Return-Path: <linux-kernel-owner+w=401wt.eu-S1758014AbZAMPBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014AbZAMPBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 10:01:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757435AbZAMPAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 10:00:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:42037 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757315AbZAMPAX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 10:00:23 -0500
Date: Tue, 13 Jan 2009 15:01:48 +0000
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org, akpm@linux-foundation.org
Subject: [PATCH 1/2] scripts: add x86 register parser to markup_oops.pl
Message-ID: <20090113150148.7d3fc379@infradead.org>
In-Reply-To: <20090113150103.085c6eb6@infradead.org>
References: <20090113150103.085c6eb6@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ace27f35478ed449fd345d2381411362f6bcc9f9 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Tue, 13 Jan 2009 05:50:35 +0000
Subject: [PATCH] scripts: add x86 register parser to markup_oops.pl

An oops dump also contains the register values.
This patch parses these for (32 bit) x86, and then annotates the
disassembly with these values; this helps in analysis of the oops
by the developer, for example, NULL pointer or other pointer bugs
show up clearly this way.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 scripts/markup_oops.pl |  106 +++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 100 insertions(+), 6 deletions(-)

diff --git a/scripts/markup_oops.pl b/scripts/markup_oops.pl
index d40449c..bb20468 100644
--- a/scripts/markup_oops.pl
+++ b/scripts/markup_oops.pl
@@ -32,6 +32,78 @@ my $module = "";
 my $func_offset;
 my $vmaoffset = 0;
 
+my %regs;
+
+
+sub parse_x86_regs
+{
+	my ($line) = @_;
+	if ($line =~ /EAX: ([0-9a-f]+) EBX: ([0-9a-f]+) ECX: ([0-9a-f]+) EDX: ([0-9a-f]+)/) {
+		$regs{"%eax"} = $1;
+		$regs{"%ebx"} = $2;
+		$regs{"%ecx"} = $3;
+		$regs{"%edx"} = $4;
+	}
+	if ($line =~ /ESI: ([0-9a-f]+) EDI: ([0-9a-f]+) EBP: ([0-9a-f]+) ESP: ([0-9a-f]+)/) {
+		$regs{"%esi"} = $1;
+		$regs{"%edi"} = $2;
+		$regs{"%esp"} = $4;
+	}
+}
+
+sub process_x86_regs
+{
+	my ($line, $cntr) = @_;
+	my $str = "";
+	if (length($line) < 40) {
+		return ""; # not an asm istruction
+	}
+
+	# find the arguments to the instruction
+	if ($line =~ /([0-9a-zA-Z\,\%\(\)\-\+]+)$/) {
+		$lastword = $1;
+	} else {
+		return "";
+	}
+
+	# we need to find the registers that get clobbered,
+	# since their value is no longer relevant for previous
+	# instructions in the stream.
+
+	$clobber = $lastword;
+	# first, remove all memory operands, they're read only
+	$clobber =~ s/\([a-z0-9\%\,]+\)//g;
+	# then, remove everything before the comma, thats the read part
+	$clobber =~ s/.*\,//g;
+
+	# if this is the instruction that faulted, we haven't actually done
+	# the write yet... nothing is clobbered.
+	if ($cntr == 0) {
+		$clobber = "";
+	}
+
+	foreach $reg (keys(%regs)) {
+		my $val = $regs{$reg};
+		# first check if we're clobbering this register; if we do
+		# we print it with a =>, and then delete its value
+		if ($clobber =~ /$reg/) {
+			if (length($val) > 0) {
+				$str = $str . " $reg => $val ";
+			}
+			$regs{$reg} = "";
+			$val = "";
+		}
+		# now check if we're reading this register
+		if ($lastword =~ /$reg/) {
+			if (length($val) > 0) {
+				$str = $str . " $reg = $val ";
+			}
+		}
+	}
+	return $str;
+}
+
+# parse the oops
 while (<STDIN>) {
 	my $line = $_;
 	if ($line =~ /EIP: 0060:\[\<([a-z0-9]+)\>\]/) {
@@ -46,10 +118,11 @@ while (<STDIN>) {
 	if ($line =~ /EIP is at ([a-zA-Z0-9\_]+)\+(0x[0-9a-f]+)\/0x[a-f0-9]+\W\[([a-zA-Z0-9\_\-]+)\]/) {
 		$module = $3;
 	}
+	parse_x86_regs($line);
 }
 
 my $decodestart = hex($target) - hex($func_offset);
-my $decodestop = $decodestart + 8192;
+my $decodestop = hex($target) + 8192;
 if ($target eq "0") {
 	print "No oops found!\n";
 	print "Usage: \n";
@@ -84,6 +157,7 @@ my $counter = 0;
 my $state   = 0;
 my $center  = 0;
 my @lines;
+my @reglines;
 
 sub InRange {
 	my ($address, $target) = @_;
@@ -188,16 +262,36 @@ while ($finish < $counter) {
 
 my $i;
 
-my $fulltext = "";
+
+# start annotating the registers in the asm.
+# this goes from the oopsing point back, so that the annotator
+# can track (opportunistically) which registers got written and
+# whos value no longer is relevant.
+
+$i = $center;
+while ($i >= $start) {
+	$reglines[$i] = process_x86_regs($lines[$i], $center - $i);
+	$i = $i - 1;
+}
+
 $i = $start;
 while ($i < $finish) {
+	my $line;
 	if ($i == $center) {
-		$fulltext = $fulltext . "*$lines[$i]     <----- faulting instruction\n";
+		$line =  "*$lines[$i] ";
 	} else {
-		$fulltext = $fulltext .  " $lines[$i]\n";
+		$line =  " $lines[$i] ";
+	}
+	print $line;
+	if (defined($reglines[$i]) && length($reglines[$i]) > 0) {
+		my $c = 60 - length($line);
+		while ($c > 0) { print " "; $c = $c - 1; };
+		print "| $reglines[$i]";
 	}
+	if ($i == $center) {
+		print "<--- faulting instruction";
+	}
+	print "\n";
 	$i = $i +1;
 }
 
-print $fulltext;
-
-- 
1.6.0.6




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
