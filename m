Return-Path: <linux-kernel-owner+w=401wt.eu-S1757418AbZAMPBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbZAMPBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 10:01:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758312AbZAMPA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 10:00:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:42040 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758073AbZAMPA1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 10:00:27 -0500
Date: Tue, 13 Jan 2009 15:02:23 +0000
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org, akpm@linux-foundation.org
Subject: [PATCH 2/2] scripts: add x86 64 bit support to the markup_oops.pl
 script
Message-ID: <20090113150223.08c1faad@infradead.org>
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

>From 231381ec24bf8f13fb87a06ae937032842a67225 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Tue, 13 Jan 2009 09:45:53 +0000
Subject: [PATCH] scripts: add x86 64 bit support to the markup_oops.pl script

---
 scripts/markup_oops.pl |   59 ++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 55 insertions(+), 4 deletions(-)

diff --git a/scripts/markup_oops.pl b/scripts/markup_oops.pl
index bb20468..9b90b6c 100644
--- a/scripts/markup_oops.pl
+++ b/scripts/markup_oops.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl -w
+#!/usr/bin/perl 
 
 use File::Basename;
 
@@ -29,7 +29,7 @@ my $filename = $vmlinux_name;
 my $target = "0";
 my $function;
 my $module = "";
-my $func_offset;
+my $func_offset = 0;
 my $vmaoffset = 0;
 
 my %regs;
@@ -49,6 +49,39 @@ sub parse_x86_regs
 		$regs{"%edi"} = $2;
 		$regs{"%esp"} = $4;
 	}
+	if ($line =~ /RAX: ([0-9a-f]+) RBX: ([0-9a-f]+) RCX: ([0-9a-f]+)/) {
+		$regs{"%eax"} = $1;
+		$regs{"%ebx"} = $2;
+		$regs{"%ecx"} = $3;
+	}
+	if ($line =~ /RDX: ([0-9a-f]+) RSI: ([0-9a-f]+) RDI: ([0-9a-f]+)/) {
+		$regs{"%edx"} = $1;
+		$regs{"%esi"} = $2;
+		$regs{"%edi"} = $3;
+	}
+	if ($line =~ /RBP: ([0-9a-f]+) R08: ([0-9a-f]+) R09: ([0-9a-f]+)/) {
+		$regs{"%r08"} = $2;
+		$regs{"%r09"} = $3;
+	}
+	if ($line =~ /R10: ([0-9a-f]+) R11: ([0-9a-f]+) R12: ([0-9a-f]+)/) {
+		$regs{"%r10"} = $1;
+		$regs{"%r11"} = $2;
+		$regs{"%r12"} = $3;
+	}
+	if ($line =~ /R13: ([0-9a-f]+) R14: ([0-9a-f]+) R15: ([0-9a-f]+)/) {
+		$regs{"%r13"} = $1;
+		$regs{"%r14"} = $2;
+		$regs{"%r15"} = $3;
+	}
+}
+
+sub reg_name
+{
+	my ($reg) = @_;
+	$reg =~ s/r(.)x/e\1x/;
+	$reg =~ s/r(.)i/e\1i/;
+	$reg =~ s/r(.)p/e\1p/;
+	return $reg;
 }
 
 sub process_x86_regs
@@ -83,10 +116,18 @@ sub process_x86_regs
 	}
 
 	foreach $reg (keys(%regs)) {
+		my $clobberprime = reg_name($clobber);
+		my $lastwordprime = reg_name($lastword);
 		my $val = $regs{$reg};
+		if ($val =~ /^[0]+$/) {
+			$val = "0"; 
+		} else {
+			$val =~ s/^0*//;
+		}
+		
 		# first check if we're clobbering this register; if we do
 		# we print it with a =>, and then delete its value
-		if ($clobber =~ /$reg/) {
+		if ($clobber =~ /$reg/ || $clobberprime =~ /$reg/) {
 			if (length($val) > 0) {
 				$str = $str . " $reg => $val ";
 			}
@@ -94,7 +135,7 @@ sub process_x86_regs
 			$val = "";
 		}
 		# now check if we're reading this register
-		if ($lastword =~ /$reg/) {
+		if ($lastword =~ /$reg/ || $lastwordprime =~ /$reg/) {
 			if (length($val) > 0) {
 				$str = $str . " $reg = $val ";
 			}
@@ -109,15 +150,25 @@ while (<STDIN>) {
 	if ($line =~ /EIP: 0060:\[\<([a-z0-9]+)\>\]/) {
 		$target = $1;
 	}
+	if ($line =~ /RIP: 0010:\[\<([a-z0-9]+)\>\]/) {
+		$target = $1;
+	}
 	if ($line =~ /EIP is at ([a-zA-Z0-9\_]+)\+(0x[0-9a-f]+)\/0x[a-f0-9]/) {
 		$function = $1;
 		$func_offset = $2;
 	}
+	if ($line =~ /RIP: 0010:\[\<[0-9a-f]+\>\]  \[\<[0-9a-f]+\>\] ([a-zA-Z0-9\_]+)\+(0x[0-9a-f]+)\/0x[a-f0-9]/) {
+		$function = $1;
+		$func_offset = $2;
+	}
 
 	# check if it's a module
 	if ($line =~ /EIP is at ([a-zA-Z0-9\_]+)\+(0x[0-9a-f]+)\/0x[a-f0-9]+\W\[([a-zA-Z0-9\_\-]+)\]/) {
 		$module = $3;
 	}
+	if ($line =~ /RIP: 0010:\[\<[0-9a-f]+\>\]  \[\<[0-9a-f]+\>\] ([a-zA-Z0-9\_]+)\+(0x[0-9a-f]+)\/0x[a-f0-9]+\W\[([a-zA-Z0-9\_\-]+)\]/) {
+		$module = $3;
+	}
 	parse_x86_regs($line);
 }
 
-- 
1.6.0.6




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
